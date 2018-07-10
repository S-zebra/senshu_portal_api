class CreateSecures < ActiveRecord::Migration[5.2]
  def change
    create_table :secures do |t|
      t.string :enc_key, null: false, uniqueness: true
      t.timestamps
    end
  end
end
