defmodule LoanSystemWeb.Router do
  use LoanSystemWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(LoanSystemWeb.Plugs.SetUser)
    plug(LoanSystemWeb.Plugs.SessionTimeout, timeout_after_seconds: 3_600)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :session do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_secure_browser_headers)
  end

  pipeline :app do
    plug(:put_layout, {LoanSystemWeb.LayoutView, :app})
  end

  pipeline :dashboard_layout do
    plug(:put_layout, {LoanSystemWeb.LayoutView, :dashboard_layout})
  end

  pipeline :no_layout do
    plug :put_layout, false
  end

  scope "/", LoanSystemWeb do
    pipe_through([:browser, :no_layout])

    get("/logout/current/user", SessionController, :signout)
    get "/Account/Disabled", SessionController, :error_405
  end

  scope "/", LoanSystemWeb do
    pipe_through([:session, :app])
    # pipe_through :browser
    # get "/Dashboard", UserController, :dashboard
    get("/", SessionController, :new)
    post("/", SessionController, :create)
    get("/forgortFleetHub//password", UserController, :forgot_password)
    post("/confirmation/token", UserController, :token)
    get("/reset/FleetHub/password", UserController, :default_password)
  end

  scope "/", LoanSystemWeb do
    pipe_through([:session, :dashboard_layout])
    # ---------------------------Test
    get("/new/password", UserController, :new_password)
    post("/reset/password", UserController, :default_password)
    post("/reset/user/password", UserController, :reset_pwd)
    # ----------------------------------------------------------------
  end

  scope "/", LoanSystemWeb do
    pipe_through([:browser, :api])


    get("/dashboard", UserController, :dashboard)

    ########### REPORT ROUTES #############
    get "/Reports", ReportsController, :reports
    get "/Logs", ReportsController, :logs
    ########### END REPORT ROUTES #############
    get("/Companies", CompanyController, :companies)
  end

  # Other scopes may use custom stacks.
  # scope "/api", LoanSystemWeb do
  #   pipe_through :api
  # end
end
