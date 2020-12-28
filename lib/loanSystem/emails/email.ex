defmodule LoanSystem.Emails.Email do
  import Bamboo.Email
  # alias Bamboo.Attachment
  use Bamboo.Phoenix, view: LoanSystemWeb.EmailView
  alias LoanSystem.Emails.Mailer
  # alias Proxy.Notifications


  # def send_email_notification(attr) do
  #   Notifications.list_tbl_email_logs()
  #   |> Task.async_stream(&(email_alert(&1.email, attr) |> Mailer.deliver_now()),
  #     max_concurrency: 10,
  #     timeout: 30_000
  #   )
  #   |> Stream.run()
  # end

  def password_alert(email, password) do
    password(email, password) |> Mailer.deliver_later()
  end

  def confirm_password_reset(token, email) do
    confirmation_token(token, email) |> Mailer.deliver_later()
  end

  def password(email, password) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email}")
    |> put_html_layout({LoanSystemWeb.LayoutView, "email.html"})
    |> subject("Proxy Password")
    |> assign(:password, password)
    # |> assign(:user_credentials, %{password: password, username: username})
    |> render("password_content.html")
  end

  def confirmation_token(token, email) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email}")
    |> put_html_layout({LoanSystemWeb.LayoutView, "email.html"})
    |> subject("Proxy Password Reset")
    |> assign(:token, token)
    |> render("token_content.html")
  end

  def send_email(email, password) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email}")
    |> subject("Account Creation")
    |> put_html_layout({LoanSystemWeb.LayoutView, "email.html"})
    |> subject("Customer Account Creation")
    |> assign(:password, password)
    |> render("user_email.html")
    |> Mailer.deliver_later()
  end
  def compose_email(recipient, subject, body) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{recipient}")
    |> subject("#{subject}")
    |> text_body("#{body}")
    |> Mailer.deliver_later()
  end

  def notify_customer(email_address, password, customer_no) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email_address}")
    |> put_html_layout({LoanSystemWeb.LayoutView, "email.html"})
    |> subject("Customer Account Creation")
    |> assign(:password, password)
    |> assign(:customer_no, customer_no)
    |> render("profile_creation.html")
    |> Mailer.deliver_later()
  end

  def eod(items, recipient) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to(recipient)
    |> subject("End of day Report as at #{Timex.now}")
    |> render("send_eoc.html", items: items)
    |> Mailer.deliver_later()
  end
  def sod(items, recipient) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to(recipient)
    |> subject("Start Of Day Report as at #{Timex.now}")
    |> render("send_eoc.html", items: items)
    |> Mailer.deliver_later()
  end
  def eom(items, recipient) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to(recipient)
    |> subject("End of Month Report as at #{Timex.now}")
    |> render("send_eoc.html", items: items)
    |> Mailer.deliver_later()
  end
  def eoy(items, recipient) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to(recipient)
    |> subject("End of Year Report as at #{Timex.now}")
    |> render("send_eoc.html", items: items)
    |> Mailer.deliver_later()
  end

  def estate(email_address) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email_address}")
    |> put_html_layout({LoanSystemWeb.LayoutView, "email.html"})
    |> subject("End of Day Statement Report as at #{Timex.now}")
    |> render("estatement.html")
    |> Mailer.deliver_later()
  end
end
