class SessionsController < ApplicationController
  def new
    @new_session = Session.new
  end

  def create
    allowed_param = params.permit(:student_id, :login_password)
    @account = Account.authenticate(allowed_param[:login_password], allowed_param[:login_password])
    if @account
      session[:uid] = @account.id
      session = Session.new(@account)
      redirect_to :tokens if session.save
    else
      flash.alert = "パスワードが違います！"
      redirect_to action: "new"
    end
  end
end
