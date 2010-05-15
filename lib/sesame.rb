require 'net/http'
require 'uri'
require 'rubygems'
require 'nokogiri'

module Sesame

  class Server
    attr_reader :uri, :repo
    
    def initialize(host, port, sesamedir, repo, user, pass, options={})
      @host = host
      @port = port
      @sesamedir = sesamedir
      @repo = repo
      @user = user
      @pass = pass
      @opt = Hash.new(false).merge options
      @uri =
        URI.parse("http://#{@host}:#{@port}/#{@sesamedir}/repositories")
    end
    
    def process_query_xml(uri, &block)
      req = Net::HTTP::Get.new(@uri.path + uri, { 'Accept' => 'application/sparql-results+xml'})
      req.basic_auth @user, @pass
      xml = Nokogiri::XML.parse(request(req).body)
      if !@opt[:return_xml]
        res = yield xml
        return res
      else
        return xml
      end
    end

    def select(query_str, query_lang="sparql")
      params = { "query" => query_str, "queryLn" => query_lang }
      query_params =
        params.collect { |k,v| "#{k}=#{URI.escape(v.to_s)}" }.reverse.join '&'
      
      process_query_xml "/#{@repo}?#{query_params}" do |xml|
        res = Hash.new
        # Get variables from query
        xml.xpath('//xmlns:head/xmlns:variable').each do |var|
          res[var['name']] = Array.new
        end
        # Populate result hash by variable
        xml.xpath('//xmlns:result/xmlns:binding').each do |binding|
          res[binding['name']] << (binding / 'uri')[0].content
        end
        res # res should be the result of the block
      end
    end
    
    def list_repos
      process_query_xml "" do |xml|
        res = Array.new
        xml.xpath('//xmlns:binding[@name="id"]/xmlns:literal').each do |repo|
          res << repo.content
        end
        res # res should be the result of the block
      end
    end

    def list_namespaces repo
      process_query_xml "/#{repo}/namespaces" do |xml|
        res = Hash.new
        xml.xpath('//xmlns:result').each do |result|
          prefix = result.xpath('.//xmlns:binding[@name="prefix"]/xmlns:literal')[0].content
          namespc = result.xpath('.//xmlns:binding[@name="namespace"]/xmlns:literal')[0].content
          res[prefix] = namespc
        end
        res # res should be the result of the block
      end
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
