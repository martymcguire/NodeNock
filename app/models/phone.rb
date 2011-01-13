class Phone < ActiveRecord::Base
  belongs_to :user

  before_create :generate_verification_code
  before_save :canonicalize_phone

  def verified?
    verification_code.nil?
  end

private

  # Thanks, stackoverflow
  # http://stackoverflow.com/questions/88311/
  def generate_verification_code
    o =  [('0'..'9'),('A'..'Z')].map{|i| i.to_a}.flatten;  
    self['verification_code']  =  (0..5).map{ o[rand(o.length)]  }.join;
  end

  def canonicalize_phone
    if(self['number'])
      self['number'].gsub!(/[- ()]/,'')
      if(! self['number'].starts_with? '+1')
        self['number'].gsub!(/^/,'+1')
      end
    end
  end
end
