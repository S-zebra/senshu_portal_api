class MessageHeader < ActiveRecord::Migration[5.2]
  def change
    add_reference :message_headers, :account, index: true, null: false
  end
end
