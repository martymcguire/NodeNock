class User < ActiveRecord::Base

  has_one :phone

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_secret = auth["credentials"]["secret"]
    end
  end

  def update_with_omniauth(auth)
    self.oauth_token = auth["credentials"]["token"]
    self.oauth_secret = auth["credentials"]["secret"]
    self.save!
  end

end
