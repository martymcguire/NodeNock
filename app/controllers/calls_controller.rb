class CallsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    from = params['From'].gsub(/ /,'+')
    phone = Phone.find_by_number(from)
    user = phone.nil? ? nil : phone.user
    name = user.nil? ? 'Caller' : user.name
    call = Call.create!({
      :from => from,
      :user_id => user.nil? ? nil : user.id,
      :sid => params['CallSid']
    })
    verb = Twilio::Verb.new do |v|
      v.say "Hello, #{name}! Let me see if anyone is at Baltimore Node.", :voice => 'woman'
      v.redirect dial_out_call_path(call)
    end
    render :text => verb.response
  end

  def dial_out
    call = Call.find_by_sid(params['CallSid'])
    user = call.user
    # set these in your environment
    oauth = Foursquare::OAuth.new(ENV['FOURSQUARE_CONSUMER_KEY'], ENV['FOURSQUARE_CONSUMER_SECRET'])
    oauth.authorize_from_access(ENV['NODENOCK_VENUE_USER_TOKEN'], ENV['NODENOCK_VENUE_USER_SECRET'])
    foursquare = Foursquare::Base.new(oauth)
    venue = foursquare.venue :vid => ENV['NODENOCK_VENUE_ID']

    if(! venue['checkins'])
      render :text => Twilio::Verb.say("Sorry, it looks like no one is checked in. Please try again later. Goodbye!", :voice => 'woman')
      return
    else
      number = number_from_checkins(venue['checkins'], params['From'].gsub(/ /,'+'))
      if(number)
        verb = Twilio::Verb.new do |v|
          v.say "Dialing.", :voice => 'woman'
          v.dial number
        end
        render :text => verb.response
        return
      else
        render :text => Twilio::Verb.say("Sorry, I don't have a phone number for anyone who is checked in. Goodbye!", :voice => 'woman')
      end
    end
  end

private

  def number_from_checkins(checkins, caller_num)
    checkins.each do |c|
      fsu = c['user']
      u = User.find_by_uid(fsu['id'])
      if(u && u.phone.verified?)
        next if u.phone.number == caller_num # don't call ourselves
        return u.phone.number
      end
    end
    return nil
  end
end
