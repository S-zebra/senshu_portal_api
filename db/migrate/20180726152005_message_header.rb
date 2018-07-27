class MessageHeader < ActiveRecord::Migration[5.2]
  def change
    add_column :message_headers, :account_id, :account_id
    change_column :message_headers, :account_id, :account_id, null: false
    remove_column :message_headers, :read
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
