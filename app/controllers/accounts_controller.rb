class AccountsController < ApplicationController
  def new
    @new_account = Account.new
  end

  def create
    account = params.require(:account).permit(:student_id, :login_password) #for strong parameters
    @new_account = Account.new(student_id: account[:student_id], login_password: account[:login_password])
    login_success = PortalCommunicator.can_login?(account[:student_id], account[:login_password])
    if login_success
      if @new_account.save
        flash[:notice] = "アカウントは正常に作成されました"
        redirect_to :new_session
      end
    else
      flash[:alert] = "エラー: ポータルにログインできません。"
      redirect_to action: "new"
    end
  end
end
