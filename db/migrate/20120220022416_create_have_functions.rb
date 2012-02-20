class CreateHaveFunctions < ActiveRecord::Migration
  def change
    create_table :have_functions do |t|
      t.integer :testcase_id
      t.integer :function_id
      t.integer :level

      t.timestamps
    end
  end
end
