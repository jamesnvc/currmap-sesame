require File.expand_path(File.dirname(__FILE) + '/spec_helper')
require 'rubygems'
require 'parseconfig'

def new_test_serv
  config = ParseConfig.new "#{File.dirname(__FILE__)}/tests-config"
  user = config.get_value('username')
  pass = config.get_value('password')
  puts "username = #{user}"
  puts "password = #{pass}"
  serv = Sesame::Server.new("engsci.utoronto.ca", 8080, "openrdf-sesame",
                            "CurrMap", user, pass)
  return serv
end

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

def list_repos_test
  serv = new_test_serv
  puts serv.list_repos
end

def list_namespaces_test
  serv = new_test_serv
  puts serv.list_namespaces("CurrMap").inspect
end

describe "Sesame::Server" do
  it "gets a list of repos" do
    
  end
end
