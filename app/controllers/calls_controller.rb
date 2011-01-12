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
    render :text => Twilio::Verb.say("Derp derp.")
  end

end
