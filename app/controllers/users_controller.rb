class UsersController < ApplicationController

  before_filter :get_friendly, :only => :show

  def show

  end

  def approve_friendship
    if(current_user)
      current_user.approve_venue_request
    end
    redirect_to root_path
  end

  private

  def get_friendly
    if(current_user && !current_user.is_friend?)
      current_user.get_friendly
    end
  end
end
