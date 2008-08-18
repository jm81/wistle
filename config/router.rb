# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   r.match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   r.match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   r.match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|  
  r.resources :articles, :collection =>  {:sync => :get, :sync_all => :get} do | article |
    article.resources :comments
  end
  
  r.match('/').to(:controller => 'articles', :action =>'index').name(:root)
  
  r.match('/sitemap.xml').to(:controller => 'sitemap', :action => 'index', :format => "xml")
  r.match('/sitemap').to(:controller => 'sitemap', :action => 'index').name(:sitemap)
  
  r.match(%r[/search/results]).to(
    :controller => 'articles', :action => 'search')
  
  r.match(%r[/categories/(.*)]).to(
     :controller => 'articles', :action => 'index', :category => '[1]')
  
  r.match(%r[/(.*)]).to(
     :controller => 'articles', :action => 'show', :path => '[1]').name(:article_path)
end