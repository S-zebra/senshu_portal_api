class CreateMessageHeaders < ActiveRecord::Migration[5.2]
  def change
    create_table :message_headers do |t|
      t.string :title, null: false
      t.string :sender, null: false
      t.datetime :post_date, null: false
      t.boolean :read, null: false, default: false
      t.boolean :new, null: false, default: false
      t.boolean :important, null: false, default: false
      t.boolean :confirm_read, null: false, default: false
      t.boolean :require_reply, null: false, default: false
      t.boolean :has_attachments, null: false, default: false
      t.timestamps
    end
  end
end
