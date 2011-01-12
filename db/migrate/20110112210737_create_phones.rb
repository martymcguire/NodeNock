class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.integer :user_id
      t.string :number
      t.string :verification_code

      t.timestamps
    end
  end

  def self.down
    drop_table :phones
  end
end
