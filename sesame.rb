require 'net/http'
require 'uri'
require 'rubygems'
require 'nokogiri'

module Sesame

  class Server
    def initialize(host, port, sesamedir, repo, user, pass, options=nil)
      @host = host
      @port = port
      @sesamedir = sesamedir
      @repo = repo
      @user = user
      @pass = pass
      @options = options
      @uri =
        URI.parse("http://#{@host}:#{@port}/#{@sesamedir}/repositories")
    end

    def select(query_str, query_lang="sparql")
      params = { "query" => query_str, "queryLn" => query_lang }
      query_params = params.collect { |k,v| "#{k}=#{URI.escape(v.to_s)}" }.
        reverse.join '&'
      req = Net::HTTP::Get.new("#{@uri.path}/#{@repo}?#{query_params}",
                               {'Accept' => 'application/rdf+xml' })
      req.basic_auth @user, @pass
      return request(req).body
    end
    
    def list_repos
      req = Net::HTTP::Get.new(@uri.path,
                               {'Accept' => "application/sparql-results+xml" })
      xml = Nokogiri::XML.parse(request(req).body)
      res = Array.new
      xml.xpath('//xmlns:binding[@name="id"]/xmlns:literal',
                xml.root.namespaces ).each do |repo|
        res << repo.content
      end
      return res
    end

    def list_namespaces repo
      req = Net::HTTP::Get.new("#{@uri.path}/#{repo}/namespaces",
                               {'Accept' => "application/sparql-results+xml" })
      xml =  Nokogiri::XML.parse(request(req).body)
      res = Hash.new
      xml.xpath('//xmlns:result').each do |result|
        prefix = result.xpath('.//xmlns:binding[@name="prefix"]/xmlns:literal')[0].content
        namespc = result.xpath('.//xmlns:binding[@name="namespace"]/xmlns:literal')[0].content
        res[prefix] = namespc
      end
      return res
    end
    
    def request(req)
      res = Net::HTTP.start(@host, @port) {|http|
        http.request(req)
      }
      if (not res.kind_of?(Net::HTTPSuccess))
        handle_error(req, res)
      end
      res
    end

    private

    def handle_error(req, res)
      e = RuntimeError.new("#{res.code}:#{res.message}\nMETHOD:#{req.method}\nURI:#{req.path}\n#{res.body}")
      raise e
    end
  end
end
