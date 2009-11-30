require 'builder'
require 'ipaddr'

module JekyllMigration
  # Disqus, naturally, doesn't have a generic import option (so far as I can
  # tell. It does import from the xml exported by intensedebate.com . By exporting
  # from IntenseDebate, it's possible to determine an xml format that will be
  # accepted by Disqus.
  #
  # See intense_debate_sample.xml for an example.
  #
  # merb -i production
  # > File.open(filename, 'w') do |f|
  # >   f.write JekyllMigration::DisqusComments.new(site_id, prefix).to_xml(f)
  # > end
  #
  # In Disqus admin for your site, go to Tools > Import/Export
  # Choose "IntenseDebate" and upload the generate xml file.
  #
  # **This does not take into account replies to comments.**
  class DisqusComments
    # ==== Parameters
    # site_id<Integer>:: ID of Site
    # prefix<String>:: prefix for paths, e.g. "http://example.com/"
    def initialize(site_id, prefix)
      @site = Site.get(site_id)
      @prefix = prefix
    end
  
    def to_xml(file)
      xml = Builder::XmlMarkup.new(:target => file)
      xml.instruct!
      xml.output do
        @site.articles.each do |a|
          if a.comments.count > 0
            xml.blogpost do
              # Article information
              xml.url "#{@prefix}#{a.path}"
              xml.title a.title
              xml.guid "#{@prefix}#{a.path}"
              
              # Comments
              xml.comments do
                a.comments.each do |c|
                  xml.comment do
                    xml.isAnon 0
                    xml.name c.author
                    xml.email c.email
                    # Note that self-closing tags cause import to fail.
                    xml.url '' # Not used by Wistle
                    xml.ip '' # Not used by Wistle, but would need to be a decimal representation
                    xml.comment c.body
                    xml.date c.created_at.strftime('%Y-%m-%d %H:%M:%S')
                    xml.gmt c.created_at.to_time.utc.strftime('%Y-%m-%d %H:%M:%S')
                    xml.score 1 # Just go with default
                  end
                end
              end
            end
          end
        end
      end
      xml.target!
    end # to_xml
   
  end
end

=begin
Sample Usage:

File.open(File.join(Merb.root, 'xmlout.xml'), 'w') do |f|
  JekyllMigration::DisqusComments.new(Site.first.id, 'http://half-penny.org/').to_xml(f)
end
=end
