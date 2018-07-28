class Api::V1::Messages::ListController < ApiController
  def index
    page = send_query
    @headers = []
    page.css("form table tr").each do |msg|
      title_col = msg.children[3]
      next if !title_col #中に本文入っているメッセージがある(!confirm_readなもの)
      @headers << MessageHeader.new(
        account: @account,
        title: title_col.at("a").text,
        sender: msg.children[5].at("span").text.gsub(/^\s+|\n.+$/, ""),
        post_date: DateTime.parse(msg.children[1].text),
        new: title_col.children.css('img[title="NEW"]').any?,
        important: title_col.children.css('img[title="緊急"]').any?,
        confirm_read: title_col.children.css('img[title="開封確認"]').any?,
        require_reply: title_col.children.css('img[title="要返信"]').any?,
        has_attachments: title_col.children.css('img[title="添付あり"]').any?,
      )
    end
  end

  private

  def send_query
    bd = params[:bd] ? DateTime.parse(params[:bd]) : DateTime.new(2014, 1, 1, 0, 0)
    ed = params[:bd] ? DateTime.parse(params[:ed]) : DateTime.now
    page = @browser.get(PortalCommunicator::MESSAGES_URL)
    page.form_with(class: "ac") { |f|
      f.action = PortalCommunicator::MESSAGES_URL
      f.mode = "backno"
      # begin date
      f.period_start_YY = bd.year
      f.period_start_MM = bd.month
      f.period_start_DD = bd.day
      f.period_start_HH = bd.hour
      f.period_start_MI = bd.minute

      #end date
      f.period_stop_YY = ed.year
      f.period_stop_MM = ed.month
      f.period_stop_DD = ed.day
      f.period_stop_HH = ed.hour
      f.period_stop_MI = ed.minute

      f.sender = params[:from] || ""
      f.title = params[:q] || ""
      f.add_field!("cmd", "検索")
    }.submit
  end
end
