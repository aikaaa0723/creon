class CreateViewLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :view_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tweet, null: false, foreign_key: true
      t.integer :duration, default: 0  
      t.timestamps
    end
  end
end
