require 'net/http'
require 'openssl'

class Net::HTTP
  alias_method :origConnect, :connect
  def connect
    if(defined?(@ssl_context) && @ssl_context != nil)
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    origConnect
  end
end
