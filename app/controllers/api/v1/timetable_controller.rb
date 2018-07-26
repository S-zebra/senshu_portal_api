class Api::V1::TimetableController < ApplicationController
  before_action :authenticate
  after_action :logout

  def index
    @lectures = Lecture.where(account: @account)
    if @lectures.size == 0 || @params[:force_refresh] == "true"
      student_id = @account.student_id
      login_password = @account.decrypt_password
      delete_old_data
      @browser = PortalCommunicator.login(student_id, login_password)
      parse(@browser.get(PortalCommunicator::MY_PAGE_URL).root)
    end
  end

  private

  def authenticate
    @params = params.permit(:token, :force_refresh)
    token = @params[:token]
    @account = Token.find_by(token: token, available: true).account
  end

  def delete_old_data
    Lecture.where(account: @account).each do |d|
      d.destroy!
    end
  end

  def parse(page)
    table = page.css("table.acac").first
    table.css("tr").each_with_index do |row, slot|
      row.css("td").each_with_index do |cell, dow|
        if cell.css("a").size == 0
          next
        end
        text_nodes = cell.content.split("\n")
        images = cell.css("img")
        # if images.size > 0
        #   tn_index = 5
        #   cr_index = 6
        # else
        tn_index = 3
        cr_index = 4
        # end
        lecture = Lecture.new(
          account: @account,
          day_of_week: dow + 1,
          slot: slot - 2,
          lecture_name: cell.css("a").last.content.gsub(/[\[\]]/, ""),
          teacher_name: text_nodes[tn_index].split(/\]/)[1].gsub(/^\s+|\s+$/, ""),
          classroom_name: text_nodes[cr_index].gsub(/^\s+|\s+$/, "").split("(")[0].gsub(/\s+$/, ""),
          change_status: images.first ? images.first.attribute("title").value : nil,
        )
        lecture.save!
      end
    end
  end

  def logout
    PortalCommunicator.logout(@browser)
  end
end
