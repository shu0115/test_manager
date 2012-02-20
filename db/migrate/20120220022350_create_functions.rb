class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :level
      t.string :name

      t.timestamps
    end
  end
end
