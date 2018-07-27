json.messageList @headers do |msg|
  json.title msg.title
  json.sender msg.sender
  json.postDate msg.post_date
  json.isNew msg.new
  json.isImportant msg.important
  json.confirmRead msg.confirm_read
  json.requireReply msg.require_reply
  json.hasAttachments msg.has_attachments
end
