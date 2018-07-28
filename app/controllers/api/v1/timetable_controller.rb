class Api::V1::TimetableController < ApiController
  def index
    @lectures = Lecture.where(account: @account)
    if @lectures.size == 0 || params[:force_refresh] == "true"
      delete_old_data
      parse(@browser.get(PortalCommunicator::MY_PAGE_URL).root)
    end
  end

  private

  def delete_old_data
    Lecture.where(account: @account).each do |d|
      d.destroy!
    end
  end

  def parse(page)
    table = page.css("table.acac").first
    table.css("tr").each_with_index do |row, slot|
      row.css("td").each_with_index do |cell, dow|
        next if cell.css("a").size == 0
        text_nodes = cell.content.split("\n")
        images = cell.css("img")
        lecture = Lecture.new(
          account: @account,
          day_of_week: dow + 1,
          slot: slot - 2,
          lecture_name: cell.css("a").last.content.gsub(/[\[\]]/, ""),
          teacher_name: text_nodes[3].split(/\]/)[1].gsub(/^\s+|\s+$/, ""),
          classroom_name: text_nodes[4].gsub(/^\s+|\s+$/, "").split("(")[0].gsub(/\s+$/, ""),
          change_status: images.first ? images.first.attribute("title").value : nil,
        )
        lecture.save!
      end
    end
  end
end
