class Api::V1::Messages::HeadlinesController < ApiController
  MESSAGE_TYPES = [1, 2, 3]

  def index
    raise ArgumentError.new("type is not specified") if !params[:type]
    @type = params[:type].to_i
    raise ArgumentError.new("type must be between 1 and 3.") if !MESSAGE_TYPES.include?(@type)
    page = @browser.get(PortalCommunicator::MY_PAGE_URL).root
    @headers = []
    page.css("table.new_message")[@type - 1].css("tr").each do |msg|
      title_col = msg.children[3]
      next if !title_col
      @headers << MessageHeader.new(
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
end
