class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.references :account, null: false
      t.string :token, null: false
      t.boolean :available, default: true, null: false
      t.timestamps
    end
  end
end
