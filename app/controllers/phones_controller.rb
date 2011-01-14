class PhonesController < ApplicationController
  def create
    p = current_user.build_phone(params[:phone])
    p.save!
    result = send_verification(p.number,p.verification_code)
    redirect_to root_url, :notice => "We've sent a verification code to your phone."
  end

  def verify
    code = params[:code] ? params[:code].upcase : nil
    p = Phone.find_by_user_id_and_verification_code(current_user.id,code)
    if(p)
      p.verification_code = nil
      p.save!
      redirect_to root_url, :notice => "Your phone number has been verified!"
    else
      redirect_to root_url, :alert => "Sorry, that code was not valid."
    end
  end

  def resend_code
    notice = ""
    if(current_user)
      p = current_user.phone
      if(p && p.verification_code)
        send_verification(p.number, p.verification_code)
        notice = "We've sent a verification code to your phone."
      end
    end

    redirect_to root_url, :notice => notice
  end

  def destroy
    current_user.phone.destroy
    redirect_to root_url, :notice => "Phone deleted!"
  end

private

  def send_verification(number,code)
    msg = "Your Code is #{code}.\nOr visit #{verify_phone_url}/#{code}"
    Twilio::Sms.message(ENV['NODENOCK_PHONE'], number, msg)
  end
end
