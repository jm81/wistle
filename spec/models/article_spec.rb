require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Article do
  
  before(:each) do
    Comment.all.each { |c| c.destroy }
    Site.all.each { |s| s.destroy }
    @site = Site.create(:name => 'site')
    @article = Article.create(:site_id => @site.id)
    @article.title = "First Post"
    @article.body = "Howdy folks"
    @article.save
  end
  
  def comment(article_id)
    c = Comment.new
    c.author = "Author"
    c.body = "A comment on Article #{article_id}"
    c.article_id = article_id
    c.save
    return c
  end
  
  it "should have many comments" do
    @article2 = Article.create(:site_id => @site.id)
    @article3 = Article.create(:site_id => @site.id)
    5.times do |i|
      comment(@article.id)
      comment(@article2.id)
      comment(@article3.id)
    end
    
    Article.get(@article.id).should have(5).comments
  end
  
  it "should have direct_comments" do
    5.times do |i|
      c = comment(@article.id)
      if i > 2
        c.parent_id = 1
        c.save
      end
    end
    
    Article.get(@article.id).should have(5).comments
    Article.get(@article.id).should have(3).direct_comments
  end
  
  it "should filter body to html" do
    @article.body = "Howdy *folks*"
    @article.filters = "Markdown"
    @article.save
    @article.html.should == "<p>Howdy <em>folks</em></p>\n"
  end

  it "should filter body to html (with Textile)" do
    @article.body = "Howdy *folks* ^2^"
    @article.filters = "Textile"
    @article.save
    @article.html.should == "<p>Howdy <strong>folks</strong> <sup>2</sup></p>"
  end
  
  describe "#published_at" do
    it "should respond to #published?" do
      @article.published_at = nil
      @article.published?.should be_false
      
      @article.published_at = Time.now
      @article.published?.should be_true
      
      @article.published_at = nil
      @article.published?.should be_false
    end

    it "should be set by #published=" do
      @article.published = false
      @article.published_at.should be_nil
      
      @article.published = true
      @article.published_at.should be_kind_of(DateTime)
      
      @article.published = false
      @article.published_at.should be_nil
      
      @article.published = '0'
      @article.published_at.should be_nil
    end
    
    # I managed to cause a problem with this at one point with my "Boolean
    # Timestamp" stuff. I don't remember the details, so I'm throwing in a test
    # to make myself feel better.
    it "should save #published_at nil" do
      @article.published_at = Time.now
      @article.save
      @article.reload_attributes(:published_at)
      @article.published?.should be_true

      @article.published_at = nil
      @article.save
      @article.reload_attributes(:published_at)
      @article.published?.should be_false      
    end
  end
  
  describe "#comments_allowed_at" do
    it "should respond to #comments_allowed?" do
      @article.comments_allowed_at = nil
      @article.comments_allowed?.should be_false
      
      @article.comments_allowed_at = Time.now
      @article.comments_allowed?.should be_true
      
      @article.comments_allowed_at = nil
      @article.comments_allowed?.should be_false      
    end

    it "should be set by #comments_allowed=" do
      @article.comments_allowed = false
      @article.comments_allowed_at.should be_nil
      
      @article.comments_allowed = true
      @article.comments_allowed_at.should be_kind_of(DateTime)
      
      @article.comments_allowed = false
      @article.comments_allowed_at.should be_nil
    end
  end

  describe 'class' do
    it "should find published articles" do
      Article.all.each { |a| a.destroy }
      7.times do |i|
        a = Article.create(:title => "Test article")
        if (i % 2 == 0)
          a.published_at = Time.now - 3600
          a.save
        end
      end
      
      a = Article.create(:title => "Test article", :published_at => (Time.now + 3600) )
      
      Article.all.length.should == 8
      Article.published.length.should == 4
    end
  end
  
  it "should belong to a Site" do
    site = Site.create(:name => "newsite")
    article = Article.create(:site_id => site.id)
    article.site.name.should == site.name
  end
  
end