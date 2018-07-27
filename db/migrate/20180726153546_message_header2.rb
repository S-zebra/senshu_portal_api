class MessageHeader2 < ActiveRecord::Migration[5.2]
  def change
    remove_column :message_headers, :account
    add_column :message_headers, :account_id, :account_id
    change_column :message_headers, :account_id, :account_id, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
