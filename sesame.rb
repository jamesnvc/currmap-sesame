require 'net/http'

module Sesame

  class Server
    def initialize(host, port, sesamedir,options=nil)
      @host = host
      @port = port
      @sesamedir = sesamedir
      @options = options
      @queryuri = "http://#{@host}:#{@port}/#{@sesamedir}/servlets/evaluateTableQuery"
    end

    def query(query_str)
      req = Net::HTTP::Post.new(@queryuri)
      req["content-type"] = "multipart/form-data"
    end
  end
end
