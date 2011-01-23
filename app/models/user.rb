class User < ActiveRecord::Base

  has_one :phone

  @friend_status = nil
  @foursquare = nil

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

  def get_friendly
    return if self.is_friend? || self.friendship_waiting_on_them? #nothing to do
    if(self.friendship_waiting_on_me?)
      self.approve_user_request
    elsif(self.is_stranger? && (!self.is_venue_user?))
      begin
        self.send_friend_request
      rescue
      end
    end
    # reset friend status so it's pull from Foursquare next time it's requested
    @friend_status = nil
  end

  def is_friend?
    self.friend_status == 'friend'
  end

  def is_stranger?
    self.friend_status == 'stranger'
  end

  def send_friend_request
    foursquare.friend_sendrequest(:uid => self['uid'])
  end

  def friendship_waiting_on_me?
    self.friend_status == 'pendingMe'
  end

  def approve_user_request
    foursquare.friend_approve(:uid => self['uid'])
  end

  def friendship_waiting_on_them?
    self.friend_status == 'pendingThem'
  end

  def approve_venue_request
    # Make connection using this user's creds instead of the venue user's.
    oauth = Foursquare::OAuth.new(ENV['FOURSQUARE_CONSUMER_KEY'],ENV['FOURSQUARE_CONSUMER_SECRET'])
    oauth.authorize_from_access(self.oauth_token,self.oauth_secret)
    fsq = Foursquare::Base.new(oauth)
    fsq.friend_approve(ENV['NODENOCK_VENUE_USER_ID'])
  end

  def is_venue_user?
    self.oauth_token == ENV['NODENOCK_VENUE_USER_TOKEN']
  end

  def friend_status
    return @friend_status if @friend_status
    friends_hash = foursquare.friends.select{|f| f['id'] == self['uid']}
    if(! friends_hash.empty?)
      @friend_status = friends_hash[0]['friendstatus']
    else
      @friend_status = 'stranger'
    end
  end

  private

  def foursquare
    return @foursquare if @foursquare
    oauth = Foursquare::OAuth.new(ENV['FOURSQUARE_CONSUMER_KEY'],ENV['FOURSQUARE_CONSUMER_SECRET'])
    oauth.authorize_from_access(ENV['NODENOCK_VENUE_USER_TOKEN'],ENV['NODENOCK_VENUE_USER_SECRET'])
    @foursquare = Foursquare::Base.new(oauth)
  end
end
