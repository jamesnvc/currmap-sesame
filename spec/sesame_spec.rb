require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rubygems'
require 'parseconfig'

describe Sesame::Server do

  before :all do
    begin
      config = ParseConfig.new "#{File.dirname(__FILE__)}/tests-config"
      @host = config.get_value('host')
      @port = config.get_value('port').to_i
      @sesame_dir = config.get_value('sesame_dir')
      @repo = config.get_value('repo')
      @user = config.get_value('username')
      @pass = config.get_value('password')
    rescue Errno::EACCES
      puts "Unable to open #{File.dirname(__FILE__)}/tests-config"
    end
  end
  
  before :each do
    @serv = Sesame::Server.new(@host, @port, @sesame_dir, @repo, @user, @pass)
  end
  
  it "should get a list of repos" do
    repos = @serv.list_repos
    repos.should == [ "SYSTEM", "CurrMap" ]
  end

  it "should get a list of all namespaces" do
    namespaces = @serv.list_namespaces "CurrMap"
    namespaces.should == {
      "rdfs"=>"http://www.w3.org/2000/01/rdf-schema#",
      "xsd"=>"http://www.w3.org/2001/XMLSchema#",
      "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "base"=>"file://schema.xml#"
    }
  end

  it "should run a SeRQL query" do
    query = <<EOF
SELECT C
FROM {C} rdf:type {base:Course}
USING NAMESPACE base = <file://schema.xml#>
EOF
    res = @serv.select(query, "serql")
    res.keys.should == ["C"]
    res["C"].length.should == 1000
    res
  end

  it "should run a SPARQL query" do
    query = <<EOF
PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
PREFIX base:<file://schema.xml#>
PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX xsd:<http://www.w3.org/2001/XMLSchema#>
SELECT ?x
WHERE
{ ?x rdf:type base:Course }
EOF
    res =  @serv.select(query, "sparql")
    res.keys.should == ["x"]
    res["x"].length.should == 1000
  end

end
