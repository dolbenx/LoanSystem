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
    pipe_through([:browser, :app])

    get("/dashboard", UserController, :dashboard)
    get("/User/Management", UserController, :user_mgt)
    get("/User/Logs", UserController, :user_logs)
    get "/User/Roles", UserController, :user_roles
    post "/Create/User/Role", UserController, :create_roles

    get("/all/users", UserController, :list_users)
    get("/new/user", UserController, :new)
    get "/Create/User", UserController, :create_user
    post("/new/user", UserController, :create)

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


    get "/Users/On/Leave", UserController, :users_on_leave
    post "/Activate/Leave/Account", UserController, :activate_user_on_leave
  end



  scope "/", LoanSystemWeb do
    pipe_through([:browser, :no_layout])
    get("/emulator-ussd", UssdController, :index)
    get("/appusers", UssdController, :index)
    get("/ussd", UssdController, :initiateUssd)
  end

  scope "/", LoanSystemWeb do
    pipe_through([:browser, :app])
    # ---------------------------Test
    get("/new/password", UserController, :new_password)
    post("/reset/password", UserController, :default_password)
    post("/reset/user/password", UserController, :reset_pwd)
    post("/new/password", UserController, :change_password)
    # ----------------------------------------------------------------
  end

  scope "/", LoanSystemWeb do
    pipe_through([:browser, :api])

    ########### REPORT ROUTES #############
    get "/Reports", ReportsController, :reports
    get "/Logs", ReportsController, :logs
    ########### END REPORT ROUTES #############

    ########### System Setting ROUTES #############
    get "/Bank/Settings", SystemSettingsController, :bank
    post("Add/Bank", SystemSettingsController, :add_bank)
    get "/MNO/Settings", SystemSettingsController, :mno
    post("/Add/MNO", SystemSettingsController, :add_mno)
    get "/System/Parameters", SystemSettingsController, :systemparams
    post("Add/System/Params", SystemSettingsController, :add_systemparams)
    ########### END System Setting ROUTES #############

    ########### Loan ROUTES #############
    get "/Customer/Loan", LoanController, :loan
    get "/Customer/Loan/Transactions", LoanController, :loan_transactions
    get "/Customer/Loan/Charge", LoanController, :loan_charge
    get "/Customer/Loan/Collateral", LoanController, :loan_collateral
    get "/Customer/Loan/Advance", LoanController, :loan_advance
    get "/Customer/Loan/Schedule/Mapping", LoanController, :loan_sche_mapping
    get "/Customer/Loan/Overdue", LoanController, :loan_overdue
    ########### END System Setting ROUTES #############

    get("/Companies", CompanyController, :companies)
    get("/Staff", CompanyController, :staff)
    get("/Staff/Upload", CompanyController, :staff_uploads)
    post("/Staff/Upload", CompanyController, :handle_bulk_upload)
    get("/Products", CompanyController, :products)
    post("Companies", CompanyController, :add_company)
    post("Staff", CompanyController, :add_staff)
    post("/Add/Products", CompanyController, :add_product)
    get("/edit/Companies", CompanyController, :update_company)
    post("/edit/Companies", CompanyController, :update_company)
    post("/view/Companies", CompanyController, :update_company)
    get("/view/staff", CompanyController, :update_staff)
    post("/view/staff", CompanyController, :update_staff)
    post("/edit/staff", CompanyController, :update_staff)
    post("/Companies/disable", CompanyController, :disable)
    get("/view/product", CompanyController, :update_product)
    post("/view/product", CompanyController, :update_product)
    post("/edit/product", CompanyController, :update_product)
    post("/products/disable", CompanyController, :disable_product)
    post("/products/enable", CompanyController, :enable_product)
    post "/Upload/Company", CompanyController, :handle_bulk_upload
    get("/Admin/Portal/User", CompanyController, :portal_admin)
    post "/Generate/Company/ID", CompanyController, :generate_company_id
    post("/Create/User", UserController, :create_user)
    post "/Generate/Random/Password", UserController, :generate_random_password
    ########### END OF MAINTENANCE ROUTES #############
  end

  scope "/", LoanSystemWeb do
    pipe_through([:browser, :app_client])
      # ---------------------------------------------Client Portal profile
      get "/Client/Portal", ClientPortalController, :index
      get "/Client/Payment/Schedule", ClientPortalController, :payment_schedule
      get "/Client/Staff/Register", ClientPortalController, :register_staff
      post "/Client/Staff/Register", ClientPortalController, :handle_bulk_upload
      post "/Client/Staff", ClientPortalController, :add_staff
      get "/Client/Loan/Balances", ClientPortalController, :loan_balance
      post "/Approve/Client", ClientPortalController, :approve_staff

  end

  # Other scopes may use custom stacks.
  # scope "/api", LoanSystemWeb do
  #   pipe_through :api
  # end
end
