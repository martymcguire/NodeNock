class AddOauthAccessToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_secret, :string
  end

  def self.down
    remove_column :users, :oauth_token
    remove_column :users, :oauth_secret
  end
end
