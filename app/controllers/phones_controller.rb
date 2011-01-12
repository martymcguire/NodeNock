class PhonesController < ApplicationController
  def create
    p = current_user.build_phone(params[:phone])
    p.save!
    redirect_to root_url, :notice => "Confirmation message sent!"
  end

  def verify
    p = Phone.find_by_user_id_and_verification_code(current_user.id,params[:verification_code])
    if(p)
      p.verification_code = nil
      p.save!
      redirect_to root_url, :notice => "Your phone number has been verified!"
    else
      redirect_to root_url, :alert => "Sorry, that code was not valid."
    end
  end

  def destroy
    current_user.phone.destroy
    redirect_to root_url, :notice => "Phone deleted!"
  end

end
