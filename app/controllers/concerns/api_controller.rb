class ApiController < ActionController::Base
  # include RestfulError::ActionController
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_token

  before_action :authenticate
  after_action :logout

  def invalid_token(e)
    code = ActionDispatch::ExceptionWrapper.new(nil, e).status_code
    render json: {status: code, message: "Invalid token"}, status: code
  end

  def authenticate
    @account = Token.find_by!(token: params[:token], available: true).account
    @browser = PortalCommunicator.login(@account.student_id, @account.decrypt_password)
  end

  def logout
    PortalCommunicator.logout(@browser)
  end
end
