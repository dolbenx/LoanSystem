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

  pipeline :app_client do
    plug(:put_layout, {LoanSystemWeb.LayoutView, :app_client})
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

    ########### System Setting ROUTES #############
    get "/Bank/Settings", SystemSettingsController, :bank
    get "/MNO/Settings", SystemSettingsController, :mno
    get "/System/Parameters", SystemSettingsController, :systemparams
    ########### END System Setting ROUTES #############

    get("/Companies", CompanyController, :companies)
    get("/staff", CompanyController, :staff)
    get("/products", CompanyController, :products)
    post("Companies", CompanyController, :add_company)
    post("staff", CompanyController, :add_staff)
    post("/add/products", CompanyController, :add_product)
    get("/edit/Companies", CompanyController, :update_company)
    post("/edit/Companies", CompanyController, :update_company)
    post("/view/Companies", CompanyController, :update_company)
    get("/view/staff", CompanyController, :update_staff)
    post("/view/staff", CompanyController, :update_staff)
    post("/edit/staff", CompanyController, :update_staff)
    post("/Companies/disable", CompanyController, :disable_company)
    post("/Companies/enable", CompanyController, :enable_company)
    get("/view/product", CompanyController, :update_product)
    post("/view/product", CompanyController, :update_product)
    post("/edit/product", CompanyController, :update_product)
    post("/products/disable", CompanyController, :disable_product)
    post("/products/enable", CompanyController, :enable_product)
    post("/staff/disable", CompanyController, :disable_staff)
    post("/staff/enable", CompanyController, :enable_staff)










    ########### END OF MAINTENANCE ROUTES #############
  end

  scope "/", LoanSystemWeb do
    pipe_through([:browser, :app_client])
      # ---------------------------------------------Client Portal profile
      get "/Client/Portal", ClientPortalController, :index
      get "/Client/Payment/Schedule", ClientPortalController, :payment_schedule
      get "/Client/Staff/Register", ClientPortalController, :register_staff
      get "/Client/Reports", ClientPortalController, :report
      get "/Client/Settings", ClientPortalController, :setting
      get "/Client/Investments/BalancedFund", ClientPortalController, :balanced_fund
      get "/Client/Investments/MoneyMarket", ClientPortalController, :money_market_fund
      get "/Client/Investments/MyStar", ClientPortalController, :my_star_fund
      get "/Client/Investments/ZMWHighYield", ClientPortalController, :zmw_high_yield_fund
      get "/Client/Investments/Equity", ClientPortalController, :equity_fund
      get "/Client/Investments/USDFund", ClientPortalController, :usd_fund
      get "/Client/Investments/USDHighYield", ClientPortalController, :usd_high_yield_fund
      get "/Client/Error", ClientPortalController, :error
      get "/Client/Requests", ClientPortalController, :request
      get "/Client/Withdraw", ClientPortalController, :withdraw
      get "/Client/Investment", ClientPortalController, :invest
      get "/Client/Beneficiaries", ClientPortalController, :beneficiary
      post"/Client/Beneficiaries", ClientPortalController, :client_create_beneficiary
      get "/View/Ben", ClientPortalController, :view_beneficiary

  end

  # Other scopes may use custom stacks.
  # scope "/api", LoanSystemWeb do
  #   pipe_through :api
  # end
end
