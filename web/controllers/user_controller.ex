defmodule Blog.UserController do
  @moduledoc """
  AuthenticationController implements the  authentication workflow for
  performing the users authentication
  """
  use Blog.Web, :controller
  import Ecto.Query
  alias Blog.User
  alias Blog.Post
  alias Blog.Like
  alias Blog.Channel
  alias Blog.Repo
  alias Blog.UserChannel
  use Timex

  def profile(conn, params) do
    user = Repo.get_by(User, zid: params["zid"])
    IO.inspect user.id
    mychannels = Repo.all(from c in Channel, where: c.creator_id == ^user.id)
    IO.inspect mychannels
    joined_channels = Repo.all(from  c in Channel, join: u in UserChannel, where: c.id == u.channel_id and c.creator_id != u.user_id and u.user_id == ^user.id)
    user_likes = Repo.one(from l in Like, where: l.liked_item_id == ^user.id and l.type == "profile" , select: count(l.id))
    render conn, "profile.html", user: user, mychannels: mychannels, joined_channels: joined_channels, user_likes: user_likes
  end

  def edit(conn, params) do
    user = Repo.get_by(User,  zid: params["zid"])
    render conn, "edit_profile.html", user: user
  end

  def update(conn, params) do
    user = Repo.get_by(User, zid: params["zid"])
    # get name
    name =
      if params["name"] do
        if params["name"] == "" do
          user.name
        else
           params["name"]
        end
      end

    #get email
    email =
      if params["email"] do
        if params["email"] == "" do
          email = user.email
        else
          email = params["email"]
        end
      end
    #get bio

    bio =
      if params["bio"] do
        IO.puts "____________________________________"
        if params["bio"] == "" do
          bio  = user.bio
        else
          IO.puts"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
          bio = params["bio"]
        end
      end

    #get address
    address =
      if params["address"] do
        if params["address"] == "" do
          address = user.address
        else
          address = params["address"]
        end
      end

    #edit details
    map =
      if is_nil(user.details) do
        %{}
      else
        user.details
      end
    map =
      if params["hobbies"] != "" do
        if Map.has_key?(map, "hobbies") do
          Map.replace(map, "hobbies", params["hobbies"])
        else
          Map.put(map, "hobbies", params["hobbies"])
        end
      else
        map
      end

    map =
      if params["work"] != "" do
        if Map.has_key?(map, "work") do
          Map.replace(map, "work", params["work"])
        else
          Map.put(map, "work", params["work"])
        end
      else
        map
      end

    map =
      if params["profile_privacy"] != "" do
        if Map.has_key?(map, "profile_privacy") do
          Map.replace(map, "profile_privacy", params["profile_privacy"])
        else
          Map.put(map, "profile_privacy", params["profile_privacy"])
        end
      else
        map
      end

    map =
      if params["dob"] != "" do
        if Map.has_key?(map, "dob") do
          Map.replace(map, "dob", params["dob"])
        else
          Map.put(map, "dob", params["dob"])
        end
      else
        map
      end

    map =
      if params["bg_image"] != "" do
        if Map.has_key?(map, "bg_image") do
          Map.replace(map, "bg_image", params["bg_image"])
        else
          Map.put(map, "bg_image", params["bg_image"])
        end
      else
        map
      end

      map =
        if params["profile_image"] != "" do
          if Map.has_key?(map, "profile_image") do
            Map.replace(map, "profile_image", params["profile_image"])
          else
            Map.put(map, "profile_image", params["profile_image"])
          end
        else
          map
        end


    changeset = User.changeset(user, %{name: name, email: email, address: address, bio: bio, details: map})
    case Repo.update(changeset) do
      {:ok, _users} ->
         conn
         |> redirect(to: "/users/profile/" <> user.zid)
      {:error, changeset} ->
        render conn, "edit_profile.html", user: user
    end
  end


  def upload(conn, params) do
  IO.inspect params
  File.read params
  IO.puts ":::::::::::"
  IO.inspect data = Cloudinary.upload(params)
   {:ok, image}  =  Cloudinex.Uploader.upload_text("")
   IO.inspect image
  end
  def like_user(conn, params) do
    liked_user =  Repo.get_by(User, zid: params["user_zid"])
    user = Repo.get_by(User, zid: conn.cookies["bloguser"])

    required_params = %{liked_item_id: liked_user.id,    user_id: user.id, type: "profile"}
    changeset = Like.changeset(%Like{}, required_params)
    unless Repo.get_by(Like, liked_item_id: liked_user.id, user_id: user.id, type: "profile") do
      case Repo.insert(changeset) do
       {:ok, like} ->
         conn
         |> put_flash(:info, "Liked successfully.")
         |> redirect(to: "/users/profile/" <> liked_user.zid)

       {:error, changeset} ->
         IO.inspect changeset
         conn
       end
     else
       dislike(conn, params)
     end
  end

  def dislike(conn, params) do
    unliked_user =  Repo.get_by(User, zid: params["user_zid"])
    user = Repo.get_by(User, zid: conn.cookies["bloguser"])
    required_params = %{liked_item_id: unliked_user.id,    user_id: user.id, type: "profile"}
    like = Repo.get_by(Like, liked_item_id: unliked_user.id,    user_id: user.id, type: "profile" )
    case Repo.delete like do
      {:ok, struct}       ->
        conn
        |> put_flash(:info, "Unliked successfully.")
        |> redirect(to: "/users/profile/" <> unliked_user.zid)
      {:error, changeset} ->
        IO.inspect changeset
        conn
    end

  end

end
