class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :student_id, null: false, uniquenss: true
      t.string :login_password, null: false
      t.string :generated_hash, uniquenss: true
      t.timestamps
    end
  end
end
