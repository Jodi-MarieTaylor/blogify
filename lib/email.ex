# Define your emails
defmodule Blog.Email do
  import Bamboo.Email

  def welcome_email do
    new_email(
      to: "jodimarietaylor18@gmail.com",
      from: "support@myapp.com",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )

    # or pipe using Bamboo.Email functions

  end
end
