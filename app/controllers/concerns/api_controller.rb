class ApiController < ActionController::Base
  # include RestfulError::ActionController

  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_token
  rescue_from ArgumentError, with: :invalid_parameter

  before_action :authenticate
  after_action :logout

  def invalid_token(e)
    render json: {status: 403, message: "Invalid token"}, status: 403
  end

  def invalid_parameter(e)
    render json: {status: 400, message: "Invalid parameter", detailMessage: e.message}, status: 400
  end

  def authenticate
    @account = Token.find_by!(token: params[:token], available: true).account
    @browser = PortalCommunicator.login(@account.student_id, @account.decrypt_password)
  end

  def logout
    PortalCommunicator.logout(@browser)
  end
end
