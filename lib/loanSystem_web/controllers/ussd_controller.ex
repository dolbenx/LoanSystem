defmodule LoanSystemWeb.UssdController do
  use LoanSystemWeb, :controller
    require Logger
    alias LoanSystem.Ussds
    alias LoanSystem.Ussds.Ussd
    alias LoanSystem.Account.AppUser
    alias LoanSystem.Companies.Staff
    alias LoanSystem.Products.Product
    alias LoanSystem.Loan.LoanProduct
    alias LoanSystem.Loan.USSDLoanProduct
    alias LoanSystem.Repo
    alias LoanSystem.Loan.Loans
    alias LoanSystem.Loan.LoanCharge
    alias LoanSystem.Loan.LoanProductCharge
    alias LoanSystem.Loan.Charge
    alias LoanSystem.Loan.LoanTransaction
    alias LoanSystem.Loan.LoanChargePayment
    alias LoanSystem.Account.AppUser
    alias LoanSystem.Loan.LoanRepaymentSchedule
    require Record
    import Ecto.Query, only: [from: 2]

  
  def index(conn, _params) do
    ussds = Ussds.list_ussds()
    render(conn, "index.html", ussds: ussds)
  end


    def initiateUssd(conn, dd) do
        {:ok, body, _conn} = Plug.Conn.read_body(conn)
        Logger.info  "-----------"
        Logger.info  body

        query_params = conn.query_params;
        session_id = query_params["session_id"];
        query_params = conn.query_params;
        Logger.info  Jason.encode!(query_params)
        mobile_number = query_params["mobile_number"]
        text = query_params["text"]

        cmd = query_params["serviceCode"]
        orginal_short_code = cmd


        query = from au in AppUser, where: au.mobile_number == ^mobile_number, select: au
        appusers = Repo.all(query)
        Logger.info  Enum.count(appusers)


        tempText = text <> "*";
        text = if String.ends_with?(tempText, "*b*") do
            tempText = "*244#";
            
        else
            b_located = String.contains?(tempText, "*b*")
            text = if b_located == true do
                
                tempCheckMenu = String.split(tempText, "*b*")
                tempCheckMenuFirst = Enum.at(tempCheckMenu, 0);
                tempCheckMenuLength = Enum.count(tempCheckMenu); 
                
                text = if Enum.count(tempCheckMenu) > 1 do
                
                    tempCheckMenuLast = Enum.at(tempCheckMenu, tempCheckMenuLength-1);  
                    text = if String.length(tempCheckMenuLast) > 0 do
                        strlen_ = String.length(tempCheckMenuLast) - 1;
                        tempCheckMenuLast = String.slice(tempCheckMenuLast, 0, strlen_);
                        tempText = "*244#*#{tempCheckMenuLast}"
                    else
                        text
                        
                    end
                end
            else
                text
                        
            end
        end
        
        
        

        
        if (Enum.count(appusers)>0) do
            welcome_menu(conn, mobile_number, cmd, text)
        else
            Logger.info  "User does not exist"
            Logger.info("===================")
        Logger.info(cmd)
        Logger.info(mobile_number)

        
        Logger.info("short_code...")
        Logger.info(cmd)
        Logger.info("text...")
        Logger.info(text)

        
        if text do
            checkMenu = String.split(text, "*") 
            checkMenuLength = Enum.count(checkMenu)
            Logger.info(checkMenuLength)
            case checkMenuLength do
                2 ->
                    response = %{
                        Message: "CON Welcome to Laxim. \n\nEnter a password",
                        ClientState: 1,
                        Type: "Response"
                    }
                    send_response(conn, response)
                3 ->
                    response = %{
                        Message: "CON Confirm your password",
                        ClientState: 1,
                        Type: "Response"
                    }
                    send_response(conn, response)
                4 ->
                    password = Enum.at(checkMenu, 2)
                    cpassword = Enum.at(checkMenu, 3)
                    Logger.info("password..." <> password)
                    Logger.info("cpassword..." <> cpassword)

                    if (password != cpassword) do
                    
                        response = %{
                            Message: "BA2 Passwords dont match. Press\n\nb. Back\n",
                            ClientState: 1,
                            Type: "Response"
                        }
                        send_response(conn, response)
                    else

                        appUser = %AppUser{}

                        

                        appUser = %AppUser{mobile_number: mobile_number, password: password, staff_id: 1}
                        case Repo.insert(appUser) do
                          {:ok, appUser} ->
                                response = %{
                                    Message: "BA3 Your new Laxima account has been setup for you. Press\n\nb. Back\n0. Log Out",
                                    ClientState: 1,
                                    Type: "Response"
                                }
                                send_response(conn, response)
                                
                                
                          {:error, changeset} ->
                                Logger.info("Fail")
                                response = %{
                                    Message: "BA3 Your new Laxima account could not be setup for you. Press\n\nb. Back\n0. Log Out",
                                    ClientState: 1,
                                    Type: "Response"
                                }
                                send_response(conn, response)
                        end
                    end
                end
            else
                response = %{
                    Message: "BA1 Invalid input provided",
                    ClientState: 1,
                    Type: "Response"
                }
                send_response(conn, response) 
            end 
        end
        
    end


    def welcome_menu(conn, mobile_number, cmd, text) do
        Logger.info text
        orginal_short_code = cmd

        query = from au in AppUser, where: au.mobile_number == ^mobile_number, select: au
        customers = Repo.all(query)

        query = from pd in Product, select: pd
        products = Repo.all(query)


        Logger.info "customers count"
        Logger.info Enum.count(customers)
        Logger.info "customers count"
        Logger.info "Products count..."
        Logger.info Enum.count(products)


        


        if (Enum.count(customers)>0) do
            
            checkMenu = String.split(text, "*") 
            checkMenuLength = Enum.count(checkMenu)
            Logger.info(checkMenuLength)

            if checkMenuLength==2 do
                response = %{
                    Message: "CON Welome to Laxim\n\n1. Get Loan\n2. Loan Balance\n3. Repay Loan\n4. Account Status\n5. Terms and Conditions\n0. End",
                    ClientState: 1,
                    Type: "Response"
                }
                send_response(conn, response)
            end
            if checkMenuLength>2 do
                valueEntered = Enum.at(checkMenu, (2))
                Logger.info (valueEntered);
                case valueEntered do
                    "1" ->
                        Logger.info ("handleGetLoan");
                        handleGetLoan(conn, mobile_number, cmd, text, checkMenu)
                    "2" ->
                        Logger.info ("handleGetLoan");
                        handleGetLoanBalance(conn, mobile_number, cmd, text, checkMenu)
                    "3" ->
                        Logger.info ("handleGetLoan");
                        handleRepayLoanBalance(conn, mobile_number, cmd, text, checkMenu)
                    "4" ->
                        Logger.info ("handleGetLoan");
                        handleAccountStatus(conn, mobile_number, cmd, text, checkMenu)
                    "5" ->
                        Logger.info ("handleGetLoan");
                        handleTC(conn, mobile_number, cmd, text, checkMenu)
                    
                    
                end
            end
            
        else
            handle_new_account(conn, mobile_number, cmd, text)
        end
        
    end



    def handleTC(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        Logger.info("handleGetLoan");
        Logger.info(checkMenuLength);
        Logger.info(valueEntered);
        Logger.info(text);
        if valueEntered == "b" do
            tempText = text <> "*";
            tempCheckMenu = String.split(tempText, "*b*") 
            tempCheckMenuFirst = Enum.at(tempCheckMenu, 0);
            tempCheckMenuLength = Enum.count(tempCheckMenu);
            tempCheckMenuLast = Enum.at(tempCheckMenu, tempCheckMenuLength-1);

            nText = tempCheckMenuLast
            response = %{
                Message: nText,
                ClientState: 1,
                Type: "Response"
            }
            send_response(conn, response)
        else
            tc = "END Terms & Conditions\n-------------------------\nTerms and conditions appear here\n\nb: Back\n0: End";
            response = %{
                Message: tc,
                ClientState: 1,
                Type: "Response"
            }
            send_response(conn, response);
        end
    end


    def handleGetLoanBalance(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        Logger.info("handleGetLoan");
        Logger.info(checkMenuLength);
        Logger.info(valueEntered);
        Logger.info(text);
        if valueEntered == "b" do
            response = %{
                Message: "BA3",
                ClientState: 1,
                Type: "Response"
            }
            send_response(conn, response)
        else
            case checkMenuLength do
                3 ->
                    query = from au in AppUser, 
                        where: (au.mobile_number == type(^mobile_number, :string)),
                        select: au
                    appUsers = Repo.all(query);
                    appUser = Enum.at(appUsers, 0);



                    query = from au in Staff, 
                        where: (au.id == type(^appUser.staff_id, :integer)),
                        select: au
                    staffs = Repo.all(query);
                    staff = Enum.at(staffs, 0);


                    status = "Disbursed";
                    query = from au in Loans, 
                        where: (au.loan_status <= type(^status, :string) and au.customer_id >= type(^staff.id, :integer)), 
                        select: au
                    loans = Repo.all(query);
                    if Enum.count(loans)>0 do
                        loan = Enum.at(loans, 0);

                        outstandingTotal = loan.principal_outstanding_derived + loan.interest_outstanding_derived + loan.fee_charges_outstanding_derived + loan.penalty_charges_outstanding_derived;
                        Logger.info(outstandingTotal);
                        outstandingTotal = :erlang.float_to_binary(outstandingTotal, [decimals: 2])
                        principal_outstanding_derived = :erlang.float_to_binary(loan.principal_outstanding_derived, [decimals: 2])
                        interest_outstanding_derived = :erlang.float_to_binary(loan.interest_outstanding_derived, [decimals: 2])
                        fee_charges_outstanding_derived = :erlang.float_to_binary(loan.fee_charges_outstanding_derived, [decimals: 2])
                        penalty_charges_outstanding_derived = :erlang.float_to_binary(loan.penalty_charges_outstanding_derived, [decimals: 2])



                        text = "CON Loan Account ##{loan.loan_identity_number}\nPrincipal: #{loan.currency_code}#{principal_outstanding_derived}\nInterest: #{loan.currency_code}#{interest_outstanding_derived}\nFees: #{loan.currency_code}#{fee_charges_outstanding_derived}\nPenalties: #{loan.currency_code}#{penalty_charges_outstanding_derived}\n----------------\nTotal: #{loan.currency_code}#{outstandingTotal}\n\nb. Back \n0. End";
                        response = %{
                            Message: text,
                            ClientState: 1,
                            Type: "Response"
                        }
                        send_response(conn, response)
                    else
                        text = "END You do not have any loans. Apply for a loan first\n\nb. Back \n0. End";
                        response = %{
                            Message: text,
                            ClientState: 1,
                            Type: "Response"
                        }
                        send_response(conn, response)
                    end
            end
        end

    end


    def handleRepayLoanBalance(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        Logger.info("handleGetLoan");
        Logger.info(checkMenuLength);
        Logger.info(valueEntered);
        Logger.info(text);
        if valueEntered == "b" do
            response = %{
                Message: "BA3",
                ClientState: 1,
                Type: "Response"
            }
            send_response(conn, response)
        else
            case checkMenuLength do
                3 ->
                    query = from au in AppUser, 
                        where: (au.mobile_number == type(^mobile_number, :string)),
                        select: au
                    appUsers = Repo.all(query);
                    appUser = Enum.at(appUsers, 0);


                    query = from au in Staff, 
                        where: (au.id == type(^appUser.staff_id, :integer)),
                        select: au
                    staffs = Repo.all(query);
                    staff = Enum.at(staffs, 0);


                    status = "Disbursed";
                    query = from au in Loans, 
                        where: (au.loan_status <= type(^status, :string) and au.customer_id >= type(^staff.id, :integer)), 
                        select: au
                    loans = Repo.all(query);

                    if Enum.count(loans) > 0 do
                        loan = Enum.at(loans, 0);

                        outstandingTotal = loan.principal_outstanding_derived + loan.interest_outstanding_derived + loan.fee_charges_outstanding_derived + loan.penalty_charges_outstanding_derived;
                        Logger.info(outstandingTotal);
                        outstandingTotal = :erlang.float_to_binary(outstandingTotal, [decimals: 2])
                        principal_outstanding_derived = :erlang.float_to_binary(loan.principal_outstanding_derived, [decimals: 2])
                        interest_outstanding_derived = :erlang.float_to_binary(loan.interest_outstanding_derived, [decimals: 2])
                        fee_charges_outstanding_derived = :erlang.float_to_binary(loan.fee_charges_outstanding_derived, [decimals: 2])
                        penalty_charges_outstanding_derived = :erlang.float_to_binary(loan.penalty_charges_outstanding_derived, [decimals: 2])



                        text = "CON Loan Account ##{loan.loan_identity_number}\n\nOutstanding Balance: #{loan.currency_code}#{outstandingTotal}\n\n1. Pay Balance\nb. Back \n0. End";
                        response = %{
                            Message: text,
                            ClientState: 1,
                            Type: "Response"
                        }
                        send_response(conn, response)
                    else
                        text = "CON You do not have any loans at the moment. Apply for a loan first. Thank you\n\nb. Back \n0. End";
                        response = %{
                            Message: text,
                            ClientState: 1,
                            Type: "Response"
                        }
                        send_response(conn, response)
                    end
                4 ->
                    valueEntered = Enum.at(checkMenu, (3))
                    Logger.info (valueEntered);
                    case valueEntered do
                        "1" ->
                            Logger.info ("handleGetLoan");
                            payLoanBalance(conn, mobile_number, cmd, text, checkMenu)
                        
                        
                    end
            end
        end

    end



    def handleAccountStatus(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        Logger.info("handleGetLoan");
        Logger.info(checkMenuLength);
        Logger.info(valueEntered);
        Logger.info(text);
        if valueEntered == "b" do
            response = %{
                Message: "BA3",
                ClientState: 1,
                Type: "Response"
            }
            send_response(conn, response)
        else
            case checkMenuLength do
                3 ->
                    query = from au in AppUser, 
                        where: (au.mobile_number == type(^mobile_number, :string)),
                        select: au
                    appUsers = Repo.all(query);
                    appUser = Enum.at(appUsers, 0);


                    query = from au in Staff, 
                        where: (au.id == type(^appUser.staff_id, :integer)),
                        select: au
                    staffs = Repo.all(query);
                    staff = Enum.at(staffs, 0);


                    if appUser.status == "Active" do
                        
                        text = "CON Your account is active\n\n1. Pay Balance\nb. Back \n0. End";
                        response = %{
                            Message: text,
                            ClientState: 1,
                            Type: "Response"
                        }
                        send_response(conn, response)
                    else
                         if appUser.status == "Inactive" do
                        
                            text = "CON Your account is not active\n\n1. Pay Balance\nb. Back \n0. End";
                            response = %{
                                Message: text,
                                ClientState: 1,
                                Type: "Response"
                            }
                            send_response(conn, response)
                        else
                            text = "CON Your account has been blocked\n\n1. Pay Balance\nb. Back \n0. End";
                            response = %{
                                Message: text,
                                ClientState: 1,
                                Type: "Response"
                            }
                            send_response(conn, response)
                        end
                    end
            end
        end

    end


    def payLoanBalance(conn, mobile_number, cmd, text, checkMenu) do
        query = from au in AppUser, 
            where: (au.mobile_number == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query);
        appUser = Enum.at(appUsers, 0);


        query = from au in Staff, 
            where: (au.id == type(^appUser.staff_id, :integer)),
            select: au
        staffs = Repo.all(query);
        staff = Enum.at(staffs, 0);


        status = "Disbursed";
        query = from au in Loans, 
            where: (au.loan_status <= type(^status, :string) and au.customer_id >= type(^staff.id, :integer)), 
            select: au
        loans = Repo.all(query);
        if Enum.count(loans)>0 do
            loan = Enum.at(loans, 0);

            outstandingTotal = loan.principal_outstanding_derived + loan.interest_outstanding_derived + loan.fee_charges_outstanding_derived + loan.penalty_charges_outstanding_derived;

            principal_outstanding_derived = :erlang.float_to_binary(loan.principal_outstanding_derived, [decimals: 2])
            interest_outstanding_derived = :erlang.float_to_binary(loan.interest_outstanding_derived, [decimals: 2])
            fee_charges_outstanding_derived = :erlang.float_to_binary(loan.fee_charges_outstanding_derived, [decimals: 2])
            penalty_charges_outstanding_derived = :erlang.float_to_binary(loan.penalty_charges_outstanding_derived, [decimals: 2])

            loan_id = loan.id
            is_reversed = false;
            transaction_type_enum = "LOAN REPAYMENT";
            transaction_date = Date.utc_today;
            principal_portion_derived = loan.principal_outstanding_derived;
            interest_portion_derived = loan.interest_outstanding_derived;
            fee_charges_portion_derived = loan.fee_charges_outstanding_derived;
            penalty_charges_portion_derived = loan.penalty_charges_outstanding_derived;
            overpayment_portion_derived = 0.00;
            unrecognized_income_portion = 0.00;
            outstanding_loan_balance_derived = 0.00;
            submitted_on_date = Date.utc_today;
            manually_adjusted_or_reversed = false;
            manually_created_by_userid = nil;
            amount = outstandingTotal;

            

            Logger.info "Insert Loan Repayment Transaction";
            loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum, 
                transaction_date: transaction_date, amount: amount, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived, 
                fee_charges_portion_derived: fee_charges_portion_derived, 
                penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion, 
                outstanding_loan_balance_derived: outstanding_loan_balance_derived, 
                submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid}
            Repo.insert(loanTransaction);

            
            query = from au in LoanRepaymentSchedule, 
                where: (au.loan_id == type(^loan_id, :integer)), 
                select: au
            loanRepaymentSchedules = Repo.all(query)
            for {k, v} <- Enum.with_index(loanRepaymentSchedules) do
                loanRepaymentSchedule = Enum.at(loanRepaymentSchedules, v);
                obligations_met_on_date = Date.utc_today;
                completed_derived = loanRepaymentSchedule.principal_amount
                LoanRepaymentSchedule.changeset(loanRepaymentSchedule, %{obligations_met_on_date: obligations_met_on_date, completed_derived: completed_derived})
                    |> prepare_update(conn, loanRepaymentSchedule)
                    |> Repo.transaction()
                
            end

            closedon_date = Date.utc_today;
            completed_derived = loan.total_outstanding_derived;
            principal_repaid_derived = loan.approved_principal;
            interest_repaid_derived = loan.interest_charged_derived;
            fee_charges_repaid_derived = loan.fee_charges_charged_derived;
            Loans.changeset(loan, %{closedon_date: closedon_date, completed_derived: completed_derived, 
                principal_repaid_derived: principal_repaid_derived, interest_repaid_derived: interest_repaid_derived, fee_charges_repaid_derived: fee_charges_repaid_derived
                })
                |> prepare_update(conn, loan)
                |> Repo.transaction()


            

            text = "END Loan ##{loan.loan_identity_number} completely paid. Thank you\n\nb. Back \n0. End";
            response = %{
                Message: text,
                ClientState: 1,
                Type: "Response"
            }
            send_response(conn, response)
        else
            text = "END You do not have any loans. Apply for a loan first Thank you\n\nb. Back \n0. End";
            response = %{
                Message: text,
                ClientState: 1,
                Type: "Response"
            }
            send_response(conn, response);
        end
    end

    def prepare_update(changeset, conn, object) do
        Ecto.Multi.new()
        |> Ecto.Multi.update(:object, changeset)
    end


    def handleGetLoan(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        Logger.info("handleGetLoan");
        Logger.info(checkMenuLength);
        Logger.info(valueEntered);
        Logger.info(text);
        if valueEntered == "b" do
            response = %{
                Message: "BA3",
                ClientState: 1,
                Type: "Response"
            }
            send_response(conn, response)
        else
            case checkMenuLength do
                3 ->
                    response = %{
                        Message: "CON Enter Amount",
                        ClientState: 1,
                        Type: "Response"
                    }
                    send_response(conn, response)
                4 ->
                    amount = Enum.at(checkMenu, 3)
                    #Logger.info amount
                    query = from au in LoanProduct, 
                        where: (au.min_principal_amount <= type(^amount, :float) and au.max_principal_amount >= type(^amount, :float)), 
                        select: au
                    loanProducts = Repo.all(query)

                    if Enum.count(loanProducts) == 0 do
                        response = %{
                            Message: "CON We do not provide loans for the amount provided: ZMW\n\nb. Back\n0. Exit",
                            ClientState: 2,
                            Type: "Response"
                        }
                        send_response(conn, response)
                    else
                        loanProduct = Enum.at(loanProducts, 0);
                        query = from au in USSDLoanProduct, 
                            where: (au.loan_product_id == type(^loanProduct.id, :integer)), 
                            select: au
                        ussdLoanProducts = Repo.all(query)

                        dayOptions = [];
                        dayOptions = for {k, v} <- Enum.with_index(ussdLoanProducts) do
                            #Logger.info (k.id)
                            totalRepayAmount =0.00
                            if Enum.member?(dayOptions, k.default_period) do

                            else
                                default_rate = k.default_interest_rate
                                default_period = k.default_period
                                annual_period = loanProduct.days_in_year
                                amt = elem Integer.parse(amount), 0
                                no_of_payments = k.repayment_count
                                monthlyRepayment = calculate_monthly_repayments(amt, default_period/30, default_rate, annual_period, no_of_payments)
                                Logger.info "Test";
                                Logger.info ((monthlyRepayment));
                                totalRepayAmount = monthlyRepayment * no_of_payments
                                
                                totalRepayAmount = :erlang.float_to_binary((totalRepayAmount), [decimals: 2])
                                Logger.info "#{totalRepayAmount}"
                                default_period = :erlang.integer_to_binary(default_period)
                                repay_entry = "#{v+1}. " <> loanProduct.currency_code <> totalRepayAmount <> " within " <> default_period <> " days"
                                Logger.info "#{totalRepayAmount}"
                                dayOptions = dayOptions ++ [repay_entry]
                                Logger.info "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                                dayOptions
                            end
                        end

                        
                        if (Enum.count(dayOptions)>0) do
                            optionsList = "";
                            optionsList = Enum.join(dayOptions, "\n");
                            
                            Logger.info optionsList
                            msg = "CON Choose One. \n\nLoan " <> loanProduct.currency_code <> amount <> " to repay:\n" <> optionsList <> "\nb. Back"

                            response = %{
                                Message: msg,
                                ClientState: 2,
                                Type: "Response"
                            }
                            send_response(conn, response)
                        else
                            response = %{
                                Message: "CON Deposit Period: ZMW\n\n1. Choose One\n2. Exit\nb. Back",
                                ClientState: 2,
                                Type: "Response"
                            }
                            send_response(conn, response)

                        end
                    end
                5 ->
                    selectedIndex = Enum.at(checkMenu, 4)
                    selectedIndex = elem Integer.parse(selectedIndex), 0
                    Logger.info "<<<<<<"
                    Logger.info selectedIndex
                    amount = Enum.at(checkMenu, 3)
                    Logger.info amount
                    query = from au in LoanProduct, 
                        where: (au.min_principal_amount <= type(^amount, :float) and au.max_principal_amount >= type(^amount, :float)), 
                        select: au
                    loanProducts = Repo.all(query)

                    loanProduct = Enum.at(loanProducts, 0);
                    query = from au in USSDLoanProduct, 
                        where: (au.loan_product_id == type(^loanProduct.id, :integer)), 
                        select: au
                    ussdLoanProducts = Repo.all(query)

                    selectedUssdLoanProduct = Enum.at(ussdLoanProducts, (selectedIndex-1))
                    default_rate = selectedUssdLoanProduct.default_interest_rate
                    default_period = selectedUssdLoanProduct.default_period
                    no_of_payments = selectedUssdLoanProduct.repayment_count
                    annual_period = loanProduct.days_in_year
                    Logger.info no_of_payments
                    annual_period = loanProduct.days_in_year
                    amt = elem Integer.parse(amount), 0
                    monthylyRepayAmount = calculate_monthly_repayments(amt, default_period/30, default_rate, annual_period, no_of_payments)
                    Logger.info "*********"
                    Logger.info monthylyRepayAmount
                    monthylyRepayAmount = :erlang.float_to_binary(monthylyRepayAmount, [decimals: 2])
                    Logger.info monthylyRepayAmount
                    Logger.info no_of_payments
                    months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                    dayOptions = [];
                    dayOptions = for _x <- 0..(no_of_payments-1) do
                        dt = Date.add(Date.utc_today, ((_x+1)*30))
                        yr = dt.year
                        Logger.info yr
                        mn = dt.month
                        mn = Enum.at(months, mn)
                        Logger.info mn
                        dd = dt.day
                        dt = "#{yr}-#{mn}-#{dd}"
                        Logger.info dt
                        repay_entry = "#{dt}: " <> loanProduct.currency_code <> monthylyRepayAmount
                        Logger.info repay_entry
                        dayOptions = dayOptions ++ [repay_entry]
                    end
                    
                    if (Enum.count(dayOptions)>0) do
                        optionsList = "";
                        optionsList = Enum.join(dayOptions, "\n");
                        
                        Logger.info optionsList
                        msg = "CON Your repayment schedule. \n" <> optionsList <> "\n\n1. Confirm\nb. Back"

                        response = %{
                            Message: msg,
                            ClientState: 2,
                            Type: "Response"
                        }
                        send_response(conn, response)
                    else
                        response = %{
                            Message: "CON Deposit Period: ZMW\n\n1. Choose One\n2. Exit\nb. Back",
                            ClientState: 2,
                            Type: "Response"
                        }
                        send_response(conn, response)

                    end
                6 ->
                    confirmChoice = Enum.at(checkMenu, 5)
                    confirmChoice = elem Integer.parse(confirmChoice), 0
                    if confirmChoice != 0 do
                        amount = Enum.at(checkMenu, 3)
                        amount = elem Float.parse(amount), 0
                        #Logger.info amount
                        query = from au in LoanProduct, 
                            where: (au.min_principal_amount <= type(^amount, :float) and au.max_principal_amount >= type(^amount, :float)), 
                            select: au
                        loanProducts = Repo.all(query)

                        loanProduct = Enum.at(loanProducts, 0);
                        query = from au in USSDLoanProduct, 
                            where: (au.loan_product_id == type(^loanProduct.id, :integer)),
                            offset: ^confirmChoice, 
                            limit: 1,
                            order_by: au.id,
                            select: au
                        ussdLoanProducts = Repo.all(query)
                        ussdLoanProduct = Enum.at(ussdLoanProducts, 0);


                        query = from au in AppUser, 
                            where: (au.mobile_number == type(^mobile_number, :string)),
                            select: au
                        appUsers = Repo.all(query);
                        appUser = Enum.at(appUsers, 0);


                        query = from au in Staff, 
                            where: (au.id == type(^appUser.staff_id, :integer)),
                            select: au
                        staffs = Repo.all(query);
                        staff = Enum.at(staffs, 0);


                        totalCharges = 0.00;
                        query = from au in LoanProductCharge, 
                            where: (au.loan_product_id == type(^loanProduct.id, :integer)),
                            select: au
                        loanProductCharges = Repo.all(query);
                        Logger.info "Loan Charges";
                        Logger.info Enum.count(loanProductCharges);

                        loanProductCharge = nil;
                        charge = nil;
                        charge = if Enum.count(loanProductCharges)>0 do
                            loanProductCharge = Enum.at(loanProductCharges, 0);

                            query = from au in Charge, 
                                where: (au.id == type(^loanProductCharge.charge_id, :integer) and au.applicable_during_disbursement == true),
                                select: au
                            charges = Repo.all(query);
                            charge = Enum.at(charges, 0);
                        end


                        annual_period = loanProduct.days_in_year
                        account_no = staff.account_no;
                        customer_id =  staff.id
                        product_id = ussdLoanProduct.loan_product_id;
                        loan_status = "Pending Approval";
                        loan_type = "Salary Loan";
                        currency_code = loanProduct.currency_code;
                        principal_amount_proposed = amount;
                        principal_amount = amount;          #COMMENT OUT IF APPROVAL PROCESS APPLIES
                        approved_principal = amount;        #COMMENT OUT IF APPROVAL PROCESS APPLIES
                        annual_nominal_interest_rate = ussdLoanProduct.default_interest_rate;
                        interest_method = "FLAT";
                        term_frequency = ussdLoanProduct.default_period;
                        term_frequency_type = "DAYS";
                        repay_every = 30;
                        repay_every_type = "DAYS";
                        number_of_repayments = ussdLoanProduct.repayment_count;
                        approvedon_date = Date.utc_today;
                        expected_disbursedon_date = Date.utc_today;
                        disbursedon_date = Date.utc_today;  #COMMENT OUT IF APPROVAL PROCESS APPLIES
                        expected_maturity_date = Date.add(Date.utc_today, ((number_of_repayments)*30));
                        interest_calculated_from_date = Date.utc_today;
                        principal_disbursed_derived = amount;
                        interest_waived_derived = 0.00;
                        interest_writtenoff_derived = 0.00;
                        branch_id = staff.branch_id;


                        

                        monthylyRepayAmount = calculate_monthly_repayments(amount, term_frequency/30, annual_nominal_interest_rate, annual_period, number_of_repayments)
                        Logger.info "*********"
                        Logger.info monthylyRepayAmount
                        #monthylyRepayAmount = :erlang.float_to_binary(monthylyRepayAmount, [decimals: 2]);
                        totalRepayAmount = monthylyRepayAmount * number_of_repayments;
                        interest_outstanding_derived = totalRepayAmount - amount;
                        fee_charges_charged_derived = totalCharges;
                        fee_charges_repaid_derived = totalCharges;
                        fee_charges_waived_derived = 0.00;
                        fee_charges_writtenoff_derived = 0.00;
                        fee_charges_outstanding_derived = 0.00;
                        penalty_charges_charged_derived = 0.00;
                        penalty_charges_repaid_derived = 0.00;
                        penalty_charges_waived_derived = 0.00;
                        penalty_charges_writtenoff_derived = 0.00;
                        penalty_charges_outstanding_derived = 0.00;
                        total_expected_repayment_derived = totalRepayAmount;
                        total_repayment_derived = totalRepayAmount;
                        total_expected_costofloan_derived = totalCharges;
                        total_costofloan_derived = totalCharges;
                        total_waived_derived = 0.00;
                        total_outstanding_derived = totalRepayAmount;
                        total_overpaid_derived = 0.00;
                        withdrawnon_date = Date.utc_today;
                        loan_counter = 1;
                        is_npa = false;
                        is_legacyloan = false;
                        interest_charged_derived = 0.00;
                        interest_repaid_derived = 0.00;
                        interest_waived_derived = 0.00;
                        interest_writtenoff_derived = 0.00;
                        principal_repaid_derived = 0.00;
                        principal_writtenoff_derived = 0.00;
                        total_writtenoff_derived = 0.00;


                        query = from au in Loans, 
                            select: au
                        loans = Repo.all(query);
                        loanIdentityNumber = Enum.count(loans);
                        loanIdentityNumber = "0000000#{loanIdentityNumber}";


                        loan = %Loans{account_no: account_no, customer_id: customer_id, product_id: product_id, loan_status: loan_status, loan_type: loan_type, 
                                currency_code: currency_code, principal_amount_proposed: principal_amount_proposed, principal_amount: principal_amount, approved_principal: approved_principal, 
                                annual_nominal_interest_rate: annual_nominal_interest_rate, interest_method: interest_method, term_frequency: term_frequency, 
                                term_frequency_type: term_frequency_type, repay_every: repay_every, repay_every_type: repay_every_type, number_of_repayments: number_of_repayments, approvedon_date: approvedon_date, 
                                expected_disbursedon_date: expected_disbursedon_date, disbursedon_date: disbursedon_date, expected_maturity_date: expected_maturity_date, interest_calculated_from_date: interest_calculated_from_date, 
                                principal_disbursed_derived: principal_disbursed_derived, loan_identity_number: loanIdentityNumber, branch_id: branch_id,
                                principal_repaid_derived: principal_repaid_derived, principal_writtenoff_derived: principal_writtenoff_derived, principal_outstanding_derived: amount, 
                                interest_charged_derived: interest_charged_derived, interest_repaid_derived: interest_repaid_derived, 
                                interest_waived_derived: interest_waived_derived, interest_writtenoff_derived: interest_writtenoff_derived, interest_outstanding_derived: interest_outstanding_derived, 
                                fee_charges_charged_derived: fee_charges_charged_derived, fee_charges_repaid_derived: fee_charges_repaid_derived, 
                                fee_charges_waived_derived: fee_charges_waived_derived, fee_charges_writtenoff_derived: fee_charges_writtenoff_derived, fee_charges_outstanding_derived: fee_charges_outstanding_derived, 
                                penalty_charges_charged_derived: penalty_charges_charged_derived, penalty_charges_repaid_derived: penalty_charges_repaid_derived, 
                                penalty_charges_waived_derived: penalty_charges_waived_derived, penalty_charges_writtenoff_derived: penalty_charges_writtenoff_derived, penalty_charges_outstanding_derived: 
                                penalty_charges_outstanding_derived, total_expected_repayment_derived: total_expected_repayment_derived, total_repayment_derived: total_repayment_derived, 
                                total_expected_costofloan_derived: total_expected_costofloan_derived, total_costofloan_derived: total_costofloan_derived, total_waived_derived: total_waived_derived, total_writtenoff_derived: 
                                total_writtenoff_derived, total_outstanding_derived: total_outstanding_derived, total_overpaid_derived: total_overpaid_derived, 
                                withdrawnon_date: withdrawnon_date, loan_counter: loan_counter, is_npa: is_npa, is_legacyloan: is_legacyloan, total_charges_due_at_disbursement_derived: totalCharges}
                        case Repo.insert(loan) do
                          {:ok, loan} ->

                                loan_id = loan.id;
                                
                                if charge != nil do
                                    Logger.info "Charge";
                                    Logger.info charge.type;
                                    
                                    totalCharges = if charge.type=="PERCENT" do
                                        totalCharges = (amount * charge.valuation)/100;
                                    else
                                        if charge.type=="FLAT FEE" do
                                            totalCharges = charge.valuation;
                                        end
                                    end
                                    Logger.info "totalCharges";
                                    Logger.info totalCharges;
                                    charge_id = charge.id;
                                    is_penalty = charge.is_penalty;
                                    charge_time_enum = "DISBURSEMENT";
                                    due_for_collection_as_of_date = Date.utc_today;
                                    charge_calculation_enum = charge.type;
                                    charge_payment_mode_enum = "MOBILEMONEY";
                                    calculation_percentage = charge.valuation;
                                    calculation_on_amount = amount;
                                    charge_amount_or_percentage = charge.valuation;
                                    amount = amount;
                                    amount_paid_derived = totalCharges;
                                    amount_waived_derived = totalCharges;
                                    amount_writtenoff_derived = 0.00;
                                    amount_writtenoff_derived = 0.00;
                                    amount_outstanding_derived = 0.00;
                                    is_paid_derived = true;
                                    is_waived = false;
                                    is_active = false;

                                    loanCharge = %LoanCharge{loan_id: loan_id, charge_id: charge_id, is_penalty: is_penalty, charge_time_enum: charge_time_enum, due_for_collection_as_of_date: due_for_collection_as_of_date, 
                                        charge_calculation_enum: charge_calculation_enum, charge_payment_mode_enum: charge_payment_mode_enum, calculation_percentage: calculation_percentage, 
                                        calculation_on_amount: calculation_on_amount, charge_amount_or_percentage: charge_amount_or_percentage, amount: amount, amount_paid_derived: amount_paid_derived, 
                                        amount_waived_derived: amount_waived_derived, amount_writtenoff_derived: amount_writtenoff_derived, amount_outstanding_derived: amount_outstanding_derived, 
                                        is_paid_derived: is_paid_derived, is_waived: is_waived, is_active: is_active}
                                    Repo.insert(loanCharge);

                                    is_reversed = false;
                                    transaction_type_enum = "LOAN CHARGE PAYMENT";
                                    transaction_date = Date.utc_today;
                                    principal_portion_derived = 0.00;
                                    interest_portion_derived = 0.00;
                                    fee_charges_portion_derived = totalCharges;
                                    penalty_charges_portion_derived = 0.00;
                                    overpayment_portion_derived = 0.00;
                                    unrecognized_income_portion = 0.00;
                                    outstanding_loan_balance_derived = 0.00;
                                    submitted_on_date = Date.utc_today;
                                    manually_adjusted_or_reversed = false;
                                    manually_created_by_userid = nil;
                                    loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum, 
                                        transaction_date: transaction_date, amount: totalCharges, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived, 
                                        fee_charges_portion_derived: fee_charges_portion_derived, 
                                        penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion, 
                                        outstanding_loan_balance_derived: outstanding_loan_balance_derived, 
                                        submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid}
                                    Repo.insert(loanTransaction);


                                    loanCharge = %LoanChargePayment{loan_transaction_id: loanTransaction.id, loan_id: loan_id, loan_charge_id: loanCharge.id, amount: totalCharges, installment_number: nil}
                                    Repo.insert(loanCharge);

                                end


                                is_reversed = false;
                                transaction_type_enum = "LOAN ISSUED";
                                transaction_date = Date.utc_today;
                                principal_portion_derived = amount;
                                interest_portion_derived = interest_outstanding_derived;
                                fee_charges_portion_derived = totalCharges;
                                penalty_charges_portion_derived = 0.00;
                                overpayment_portion_derived = 0.00;
                                unrecognized_income_portion = interest_outstanding_derived;
                                outstanding_loan_balance_derived = amount + interest_outstanding_derived;
                                submitted_on_date = Date.utc_today;
                                manually_adjusted_or_reversed = false;
                                manually_created_by_userid = nil;

                                

                                Logger.info "Insert Loan Transaction";
                                loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum, 
                                    transaction_date: transaction_date, amount: amount, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived, 
                                    fee_charges_portion_derived: fee_charges_portion_derived, 
                                    penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion, 
                                    outstanding_loan_balance_derived: outstanding_loan_balance_derived, 
                                    submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid}
                                case Repo.insert(loanTransaction) do
                                  {:ok, loanTransaction} ->
                                        default_rate = ussdLoanProduct.default_interest_rate
                                        default_period = ussdLoanProduct.default_period
                                        no_of_payments = ussdLoanProduct.repayment_count
                                        annual_period = loanProduct.days_in_year
                                        Logger.info no_of_payments
                                        annual_period = loanProduct.days_in_year
                                        amt = amount
                                        monthylyRepayAmount = calculate_monthly_repayments(amt, default_period/30, default_rate, annual_period, no_of_payments)
                                        Logger.info "*********"
                                        Logger.info monthylyRepayAmount
                                        #monthylyRepayAmount = :erlang.float_to_binary(monthylyRepayAmount, [decimals: 2])
                                        #Logger.info monthylyRepayAmount
                                        Logger.info no_of_payments
                                        months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                                        dayOptions = [];
                                        dayOptions = for _x <- 0..(no_of_payments-1) do
                                            dt = Date.add(Date.utc_today, ((_x+1)*30))
                                            yr = dt.year
                                            Logger.info yr
                                            mn = dt.month
                                            mn = Enum.at(months, mn)
                                            Logger.info mn
                                            dd = dt.day
                                            dt = "#{yr}-#{mn}-#{dd}"
                                            Logger.info dt
                                            #repay_entry = "#{dt}: " <> loanProduct.currency_code <> monthylyRepayAmount
                                            #Logger.info repay_entry
                                            fromdate = Date.add(Date.utc_today, ((_x)*30))
                                            duedate = Date.add(Date.utc_today, ((_x+1)*30));
                                            installment = (_x + 1);
                                            principal_amount = monthylyRepayAmount;
                                            principal_completed_derived = monthylyRepayAmount;
                                            principal_writtenoff_derived = 0.00;
                                            interest_amount = monthylyRepayAmount;
                                            interest_completed_derived = monthylyRepayAmount;
                                            interest_writtenoff_derived = 0.00;
                                            interest_waived_derived = 0.00;
                                            accrual_interest_derived = monthylyRepayAmount;
                                            fee_charges_amount = totalCharges;
                                            fee_charges_completed_derived = totalCharges;
                                            fee_charges_writtenoff_derived = 0.00;
                                            fee_charges_waived_derived = 0.00;
                                            accrual_fee_charges_derived = 0.00;
                                            penalty_charges_amount = 0.00;
                                            penalty_charges_completed_derived = 0.00;
                                            penalty_charges_writtenoff_derived = 0.00;
                                            penalty_charges_waived_derived = 0.00;
                                            accrual_penalty_charges_derived = 0.00;
                                            total_paid_in_advance_derived = 0.00;
                                            total_paid_late_derived = 0.00;
                                            completed_derived = 0.00;
                                            createdby_id = appUser.id;
                                            lastmodifiedby_id = appUser.id;
                                            obligations_met_on_date = nil;

                                            loanRepaymentSchedule = %LoanRepaymentSchedule{loan_id: loan_id, fromdate: fromdate, duedate: duedate, installment: installment, principal_amount: principal_amount, 
                                                principal_completed_derived: principal_completed_derived, 
                                                principal_writtenoff_derived: principal_writtenoff_derived, interest_amount: interest_amount, interest_completed_derived: interest_completed_derived, 
                                                interest_writtenoff_derived: interest_writtenoff_derived,  
                                                interest_waived_derived: interest_waived_derived, accrual_interest_derived: accrual_interest_derived, fee_charges_amount: fee_charges_amount, 
                                                fee_charges_completed_derived: fee_charges_completed_derived,  
                                                fee_charges_writtenoff_derived: fee_charges_writtenoff_derived, fee_charges_waived_derived: fee_charges_waived_derived, accrual_fee_charges_derived: accrual_fee_charges_derived, 
                                                penalty_charges_amount: penalty_charges_amount,  
                                                penalty_charges_completed_derived: penalty_charges_completed_derived, penalty_charges_writtenoff_derived: penalty_charges_writtenoff_derived, 
                                                penalty_charges_waived_derived: penalty_charges_waived_derived,  
                                                accrual_penalty_charges_derived: accrual_penalty_charges_derived, total_paid_in_advance_derived: total_paid_in_advance_derived, total_paid_late_derived: total_paid_late_derived, 
                                                completed_derived: completed_derived,  
                                                createdby_id: createdby_id, lastmodifiedby_id: lastmodifiedby_id, obligations_met_on_date: obligations_met_on_date}
                                            Repo.insert(loanRepaymentSchedule);
                                            dayOptions = dayOptions ++ [""]
                                        end
                                        response = %{
                                            Message: "END Loan ##{loanIdentityNumber} has been approved. The funds has been deposited in your Airtel Wallet",
                                            ClientState: 1,
                                            Type: "Response"
                                        }

                                        #CONNECT TO AIRTEL TO CALL THE SERVICE FOR DEBITING CUSTOMERS WALLET 
                                        send_response(conn, response)

                                        
                                  {:error, changeset} ->
                                        Logger.info("Fail")
                                        response = %{
                                            Message: "END Customer Profile setup failed. Please try again",
                                            ClientState: 1,
                                            Type: "Response"
                                        }
                                        send_response(conn, response)
                                end
                                
                          {:error, changeset} ->
                                Logger.info("Fail")
                                response = %{
                                    Message: "END Customer Profile setup failed. Please try again",
                                    ClientState: 1,
                                    Type: "Response"
                                }
                                send_response(conn, response)
                        end

                        response = %{
                            Message: "Test",
                            ClientState: 2,
                            Type: "Response"
                        }
                        send_response(conn, response)
                        
                    else

                    end
            end
        end
    end




    def handle_new_account(conn, mobile_number, cmd, text) do
        Logger.info("===================")
        Logger.info(cmd)
        Logger.info(mobile_number)

        
        Logger.info("short_code...")
        Logger.info(cmd)
        Logger.info("text...")
        Logger.info(text)

        
        if text do
            checkMenu = String.split(text, "*") 
            checkMenuLength = Enum.count(checkMenu)
            Logger.info(checkMenuLength)
            case checkMenuLength do
                2 ->
                    response = %{
                        Message: "CON Welcome to Laxim. \n\nEnter a password",
                        ClientState: 1,
                        Type: "Response"
                    }
                    send_response(conn, response)
                3 ->
                    response = %{
                        Message: "CON Confirm your password",
                        ClientState: 1,
                        Type: "Response"
                    }
                    send_response(conn, response)
                4 ->
                    password = Enum.at(checkMenu, 2)
                    cpassword = Enum.at(checkMenu, 3)
                    Logger.info("password..." <> password)
                    Logger.info("cpassword..." <> cpassword)

                    if (password != cpassword) do
                    
                        response = %{
                            Message: "BA2 Passwords dont match. Press\n\nb. Back\n",
                            ClientState: 1,
                            Type: "Response"
                        }
                        send_response(conn, response)
                    else

                        appUser = %AppUser{}

                        

                        appUser = %AppUser{mobile_number: mobile_number, password: password, staff_id: 1}
                        case Repo.insert(appUser) do
                          {:ok, appUser} ->
                                response = %{
                                    Message: "BA3 Your new Laxima account has been setup for you.",# Press\n\nb. Back\n0. Log Out",
                                    ClientState: 1,
                                    Type: "Response"
                                }
                                send_response(conn, response)
                                
                                
                          {:error, changeset} ->
                                Logger.info("Fail")
                                response = %{
                                    Message: "BA3 Your new Laxima account could not be setup for you.",# Press\n\nb. Back\n0. Log Out",
                                    ClientState: 1,
                                    Type: "Response"
                                }
                                send_response(conn, response)
                        end
                    end
                end
            else
                response = %{
                    Message: "BA1 Invalid input provided",
                    ClientState: 1,
                    Type: "Response"
                }
                send_response(conn, response) 
            end 
        
    end


    def calculate_interest_for_days(amount, period, rate, annual_period, number_of_repayments) do
        #Logger.info "################"
        #Logger.info amount
        #Logger.info period
        #Logger.info rate
        #Logger.info annual_period
        #Logger.info number_of_repayments
        rate = rate/100
        nperiod = period/annual_period
        #Logger.info "+++++++++++++++++"
        #Logger.info rate
        #Logger.info nperiod
        #interest = (amount * (period/30) * mrate)
        #interest = ((rate/100)/12) * amount
        totalRepay = amount * (1 + (rate*nperiod))
        interest = totalRepay - amount
    end





    def calculate_monthly_repayments(amount, period, rate, annual_period, number_of_repayments) do
        Logger.info "################"
        Logger.info amount
        #Logger.info period
        #Logger.info "Rate ...#{rate}"
        #Logger.info annual_period
        Logger.info number_of_repayments
        rate = rate/100
        rate_ = (rate/12)
        nperiod = period/12
        Logger.info "+++++++++++++++++"
        Logger.info rate_
        #Logger.info nperiod
        #totalRepay = amount * (1 + (rate*nperiod))
        #interest = totalRepay - amount
        
        totalRepayable = 0.00;
        y = 1;
        

        rate__ = (1+rate_);
        raisedVal = :math.pow(rate__, (number_of_repayments))
        Logger.info raisedVal
        a = rate_*raisedVal
        b = raisedVal - 1
        c = a/b
        totalPayableInMonthX = amount * ((rate_*(raisedVal))/(raisedVal - 1));
        Logger.info totalPayableInMonthX
        #realMonthlyRepayment = amount * (rate_) * (1)
        totalPayableInMonthX
    end




    def union(list, p) do
        Enum.map(list, fn(x) -> 
            x
        end)
    end


    def test(idx, num, acc, rate_, y, acc1) do
        Logger.info Enum.at(Map.keys(acc), 0);
        tempAmount = Map.get(acc, :amt);
        Logger.info idx
        Logger.info num
        Logger.info "tempAmount...#{tempAmount}"
        rate__ = (1+rate_);
        raisedVal = :math.pow(rate__, (num))
        a = rate_*raisedVal
        b = raisedVal - 1
        #Logger.info a
        #Logger.info b
        c = a/b
        #Logger.info c
        #totalPayableInMonthX=tempAmount * c
        totalPayableInMonthX = tempAmount * ((rate_*(raisedVal))/(raisedVal - 1));
        Logger.info totalPayableInMonthX
        Logger.info "y....#{y}"
        realInterest = tempAmount * (rate_) * (idx+1)
        principalPart = totalPayableInMonthX - realInterest
        tempAmount = tempAmount - principalPart
        Logger.info "Real Interest...#{realInterest}"
        #dayOptions = dayOptions ++ totalPayableInMonthX
        #totalRepayable = totalRepayable + totalPayableInMonthX
        #=$A3*((rate_*(raisedVal))/(raisedVal - 1))
        #=$A3*((($C$2/12)*((1+($C$2/12))^$B3))/((1+($C$2/12))^$B3 - 1))
        Logger.info "principalPart...#{principalPart}";
        Logger.info "tempAmount...#{tempAmount}";
        Map.put(acc, "amt1", %{"tempAmount": tempAmount, "principalPart": principalPart})
        Logger.info Enum.count(Map.keys(acc))
        Map.put(acc1, (idx), tempAmount)
        acc1
    end


    def calculate_monthly_repayment(amount, period, rate, annual_period, number_of_repayments) do
        Logger.info amount
        Logger.info period
        Logger.info rate
        Logger.info annual_period
        Logger.info number_of_repayments
        rate = rate/100
        rate_ = (rate/12)
        nperiod = period/12
        Logger.info "+++++++++++++++++"
        Logger.info rate_
        Logger.info nperiod
        #totalRepay = amount * (1 + (rate*nperiod))
        #interest = totalRepay - amount
        
        dayOptions = [];
        totalRepayable = 0.00;
        dayOptions = for _x <- number_of_repayments..1 do
            
            Logger.info "xxxxxxxxxxxxxxxxx"
            Logger.info _x
            rate__ = (1+rate_);
            raisedVal = :math.pow(rate__, _x)
            Logger.info raisedVal
            a = rate_*raisedVal
            b = raisedVal - 1
            Logger.info a
            Logger.info b
            c = a/b
            Logger.info c
            #totalPayableInMonthX=amount * c
            totalPayableInMonthX = amount * ((rate_*(raisedVal))/(raisedVal - 1));
            Logger.info totalPayableInMonthX
            dayOptions = dayOptions ++ totalPayableInMonthX
            #totalRepayable = totalRepayable + totalPayableInMonthX
            #=$A3*((rate_*(raisedVal))/(raisedVal - 1))
            #=$A3*((($C$2/12)*((1+($C$2/12))^$B3))/((1+($C$2/12))^$B3 - 1))
        end

    end





    def send_response(conn, response) do
        Logger.info  "Test!"
        Logger.info  Jason.encode!(response)
        send_resp(conn, :ok, Jason.encode!(response))
    end

end
