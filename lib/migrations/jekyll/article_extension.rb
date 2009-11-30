# WARNING: This is incomplete and will probably remain so. See 
# http://github.com/jm81/svn-transform for an alternate approach.
# I retain this file only for reference.
module JekyllMigration
  class ArticleExtension
    
    # Change extensions from +old_ext+ to +new_ext+ for files in given directory
    # and subdirectories.
    #
    # This makes the assumption to all articles will need the specified new
    # extension, i.e. that all articles use the same format.
    def convert(dir, old_ext, new_ext)
      Dir.glob(dir, "**/*.#{old_ext}", new_ext).each do |fn|
        fn = File.expand_path(fn)
        
        title = ctx.prop_get('ws:title', fn)
        # Should raise error if not published
        published_at = Time.parse(ctx.prop_get('ws:published_at', fn))
        tags = ctx.prop_get('ws:tags', fn).split(';')
        tags.each do |tag|
          tag.strip!
        end
        
        basename = File.basename(fn)
        dirname = File.dirname(fn)
        
        # extension
        basename.gsub!(/#{old_ext}\Z/, new_ext)
        
        # add publish date
        basename = published_at.strftime("%Y-%m-%d-") + basename
        
        # Move file
        FileUtils.mv(fn, File.join(dirname, basename))
        
        # YamlUpFront - http://wiki.github.com/mojombo/jekyll/yaml-front-matter 
        
      end
    end
    
    def ctx
      # Client::Context, which paticularly holds an auth_baton.
      @ctx ||= begin
        setup_ctx = Svn::Client::Context.new
        setup_ctx.auth_baton = ::Svn::Core::AuthBaton.new()
        setup_ctx
      end
    end
  end
end
