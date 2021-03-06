module SiteSvn
  class Changeset < DmSvn::Svn::Changeset
    def get(path)
      Article.get(@sync.site, short_path(path), true)
    end
    
    def new_record(node)
      if node.file?
        a = Article.new
        a.tmp_site = @sync.site
        a
      else
        @sync.site.categories.new
      end
    end
  end
end