source :rubygems

# Dependencies are generated using a strict version,
# Don't forget to edit the dependency versions when upgrading.

merb_gems_version = '1.1.3'
merb_related_gems = '~> 1.1.0'
dm_gems_version   = '~> 1.0'

# If you did disable json for Merb, comment out this line.
# Don't use json gem version lower than 1.1.7! Older version have a security bug

gem 'json_pure', '>= 1.1.7', :require => 'json'

# For more information about each component,
# please read http://wiki.merbivore.com/faqs/merb_components

gem 'merb-core',                merb_gems_version
gem 'merb-assets',              merb_gems_version
gem 'merb-builder',             '0.9.8'
gem 'merb-haml',                merb_gems_version
gem 'merb-helpers',             merb_gems_version
gem 'merb-exceptions',          merb_gems_version

gem('merb-cache', merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end

group(:development) do
  gem 'thin'
end

group(:test) do
  gem 'rspec', '1.3.0'
end

gem 'dm-core',                  dm_gems_version
gem 'dm-sqlite-adapter',        dm_gems_version # change as appropriate
gem 'dm-aggregates',            dm_gems_version
gem 'dm-migrations',            dm_gems_version
gem 'dm-timestamps',            dm_gems_version
gem 'dm-types',                 dm_gems_version
gem 'dm-validations',           dm_gems_version
gem 'dm-serializer',            dm_gems_version

gem 'merb_datamapper',          merb_related_gems

gem 'jm81-paginate', '0.1.6', :require => 'paginate'
gem 'jm81-dm-filters', '0.3.0', :require => 'dm-filters'
gem 'svn-fixture', '0.1.2'
gem 'dm-svn', '0.2.3'
gem 'merb-recaptcha', '~> 1.0.3'
gem 'maruku'
gem 'rubypants'
gem 'RedCloth', :require => 'redcloth'
