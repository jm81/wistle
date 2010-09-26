begin
  # Just in case the bundle was locked
  # This shouldn't happen in a dev environment but lets be safe
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

require "spec" # Satisfies Autotest and anyone else not using the Rake tasks
require "merb-core"

# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

Spec::Runner.configure do |config|
  # config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
  # You don't need this if you don't use Webrat directly in your specs
  config.include(Merb::Test::WebratHelper)
end

DataMapper.auto_migrate! if Merb.orm == :datamapper

# for temporarily disabling one set of specs.
def dont_describe(*args)
  nil
end

# auto_migrate one or more models
def migrate(*klasses)
  klasses.each do |klass|
    klass.auto_migrate!
  end
end

# Delete all entries in one or more models
def clean(*klasses)
  klasses.each do |klass|
    klass.all.each {|entry| entry.destroy}
  end
end

# These setup_* methods are designed to quickly setup a chain of relationships,]
# when I only particularly care about the end of the chain. Site -> Category ->
# Article -> Comment
def setup_site(attrs = {})
  Site.create(attrs.merge(:name => "Test Site #{Site.count}"))
end

def setup_category(site = nil, attrs = {})
  site = setup_site unless site.kind_of?(Site)
  site.categories.create({:name => "Test Category"}.merge(attrs))
end

def setup_article(category = nil, attrs = {})
  if category.kind_of?(Site)
    category = setup_category(category)
  elsif !category.kind_of?(Category)
    category = setup_category
  end
  
  category.articles.create(
      {:title => "Test Article", :body => "A test"}.merge(attrs))
end

def setup_comment(article = nil, attrs = {})
  if article.kind_of?(Site) || article.kind_of?(Category)
    article = setup_article(article)
  elsif !article.kind_of?(Article)
    article = setup_article
  end
  
  article.comments.create(
     {:author => "author", :body => "A comment"}.merge(attrs))
end

# Load a fixture and return the repos uri.
def load_svn_fixture(name)
  script = File.expand_path(File.join(File.dirname(__FILE__), "fixtures", "#{name}.rb" ))
  load script
  return SvnFixture.repo(name).uri + "/articles"
end