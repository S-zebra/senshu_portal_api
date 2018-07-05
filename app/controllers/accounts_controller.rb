class AccountsController < ApplicationController
  def new
    @new_account = Account.new
  end

  def create
    account = params.require(:account).permit(:student_id, :login_password) #for strong parameters
    @new_account = Account.new(student_id: account[:student_id], login_password: account[:login_password])
    if @new_account.save
      render plain: "Account created."
    end
  end
end
