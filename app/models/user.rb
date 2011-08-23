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
    foursquare.user_friend_request(self['uid'])
  end

  def friendship_waiting_on_me?
    self.friend_status == 'pendingMe'
  end

  def approve_user_request
    foursquare.user_approve_friend(self['uid'])
  end

  def friendship_waiting_on_them?
    self.friend_status == 'pendingThem'
  end

  def approve_venue_request
    # Make connection using this user's creds instead of the venue user's.
    # FIXME: are we saving self.oauth_secret anymore? What is FS sending?
    fsq = Foursquare2::Client.new(
      :oauth_token => (self.oauth_secret ? self.oauth_secret : self.oauth_token)
    )
    fsq.user_approve_friend(ENV['NODENOCK_VENUE_USER_ID'])
  end

  def is_venue_user?
    self.oauth_token == ENV['NODENOCK_VENUE_USER_TOKEN']
  end

  def friend_status
    return @friend_status if @friend_status
    friends = foursquare.user_friends('self')
    if(friends.items)
      friends_hash = friends.items.select{|f| f['id'] == self['uid']}
      if(! friends_hash.empty?)
        @friend_status = friends_hash[0]['relationship']
      end
    else
      @friend_status = 'stranger'
    end
  end

  private

  def foursquare
    return @foursquare if @foursquare
    @foursquare = Foursquare2::Client.new(:oauth_token => ENV['NODENOCK_VENUE_USER_SECRET'])
  end
end
