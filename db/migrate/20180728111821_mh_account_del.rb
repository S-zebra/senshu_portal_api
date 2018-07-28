class MhAccountDel < ActiveRecord::Migration[5.2]
  def change
    remove_column :message_headers, :account
  end
end
