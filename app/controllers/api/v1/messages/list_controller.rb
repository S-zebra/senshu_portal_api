class Api::V1::Messages::ListController < ApplicationController
  before_action :authenticate
  after_action :logout
  after_action :delete_temp_headers #storing headers makes no sense

  def index
    page = send_query
    page.css("form table tr").each do |msg|
      title_col = msg.children[3]
      next if !title_col #中に本文入っているメッセージがある(!confirm_readなもの)
      @header = MessageHeader.new(
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
      @header.save!
    end
    @headers = MessageHeader.where(account: @account)
  end

  private

  def send_query
    bd = @params[:bd] ? DateTime.parse(@params[:bd]) : DateTime.new(2014, 1, 1, 0, 0)
    ed = @params[:bd] ? DateTime.parse(@params[:ed]) : DateTime.now
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

      f.sender = @params[:from] || ""
      f.title = @params[:title] || ""
      f.add_field!("cmd", "検索")
    }.submit
  end

  def delete_temp_headers
    MessageHeader.where(account: @account).each do |d|
      d.destroy!
    end
  end

  def authenticate
    @params = params.permit(:token, :bd, :ed, :from, :title)
    token = @params[:token]
    @account = Token.find_by(token: token, available: true).account
    @browser = PortalCommunicator.login(@account.student_id, @account.decrypt_password)
  end

  def logout
    PortalCommunicator.logout(@browser)
  end
end
