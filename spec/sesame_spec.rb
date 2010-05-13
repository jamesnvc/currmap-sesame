require File.expand_path(File.dirname(__FILE) + '/spec_helper')
require 'rubygems'
require 'parseconfig'


def select_serql_test
  serv = new_test_serv
  query = <<EOF
SELECT C
FROM {C} rdf:type {base:Course}
USING NAMESPACE base = <file://schema.xml#>
EOF
  puts serv.select(query, "serql")
end

def select_sparql_test
  serv = new_test_serv
  query = <<EOF
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX base: <file://schema.xml>
SELECT ?x
WHERE
{ ?x rdf:type base:Course }
EOF
  puts serv.select(quer, "sparql")
end

describe Sesame::Server do

  before :all do
    config = ParseConfig.new "#{File.dirname(__FILE__)}/tests-config"
    @host = config.get_value('host')
    @port = config.get_value('port').to_i
    @sesame_dir = config.get_value('sesame_dir')
    @repo = config.get_value('repo')
    @user = config.get_value('username')
    @pass = config.get_value('password')
  end
  
  before :each do
    @serv = Sesame::Server.new(@host, @port, @sesame_dir, @repo, @user, @pass)
  end
  
  it "gets a list of repos" do
    repos = @serv.list_repos
    repos.should == [ "SYSTEM", "CurrMap" ]
  end

  it "gets a list of all namespaces" do namespaces = @serv.list_namespaces
    "CurrMap" namespaces.should == {
      "rdfs"=>"http://www.w3.org/2000/01/rdf-schema#",
      "xsd"=>"http://www.w3.org/2001/XMLSchema#",
      "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "base"=>"file://schema.xml#"
    }
  end

end
