defmodule Blog.MessageController do
  @moduledoc """
  AuthenticationController implements the  authentication workflow for
  performing the users authentication
  """
  use Blog.Web, :controller
  import Ecto.Query
  alias Blog.User
  alias Blog.Post
  alias Blog.Channel
  alias Blog.Repo
  alias Blog.UserChannel
  use Timex

  def compose(conn, params) do
    user = Repo.get_by(User, zid: params["zid"])
    render conn, "compose.html", user: user

  end

  def send_email(conn, params) do
    user = Repo.get_by(User, zid: params["zid"])

    Blog.Email.welcome_email |> Blog.Mailer.deliver_now

    redirect(conn, to: "/users/profile/" <> user.zid )
  end

end
