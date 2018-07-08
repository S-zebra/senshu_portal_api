class CreateLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :lectures do |t|
      t.references :account, null: false
      t.integer :day_of_week, null: false
      t.integer :slot, null: false
      t.string :lecture_name, null: false
      t.string :teacher_name, null: false
      t.string :classroom_name, null: false
      t.string :change_status
      t.timestamps
    end
  end
end
