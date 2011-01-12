class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.string :from
      t.integer :user_id
      t.string :sid

      t.timestamps
    end
  end

  def self.down
    drop_table :calls
  end
end
