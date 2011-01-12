class Phone < ActiveRecord::Base
  belongs_to :user

  before_create :generate_verification_code

  def verified?
    verification_code.nil?
  end

private

  def generate_verification_code
    o =  [('0'..'9'),('A'..'Z')].map{|i| i.to_a}.flatten;  
    self['verification_code']  =  (0..5).map{ o[rand(o.length)]  }.join;
  end
end
