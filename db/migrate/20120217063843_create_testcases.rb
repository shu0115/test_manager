class CreateTestcases < ActiveRecord::Migration
  def change
    create_table :testcases do |t|
      t.integer :user_id
      t.integer :project_id
      t.string :title
      t.text :page
      t.text :operation
      t.text :result
      t.string :status
      t.text :note
      t.integer :operation_user_id
      t.integer :check_user_id
      t.timestamp :operation_at
      t.timestamp :check_at
      t.string :ticket_no
      t.string :spec_flag

      t.timestamps
    end
  end
end
