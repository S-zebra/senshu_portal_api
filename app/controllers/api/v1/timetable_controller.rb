class Api::V1::TimetableController < ApplicationController
  def index
    token = params.permit(:token)[:token]
    account = Token.find_by(token: token).account
    student_id = account.student_id
    login_password = account.decrypt_password
    render plain: PortalCommunicator.get_page(student_id, login_password)
  end
end
