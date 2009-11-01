# Set bundle path to ./gems
bundle_path "gems"

# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.1"
dm_gems_version   = "0.10.1"
do_gems_version   = "0.10.0"

# If you did disable json for Merb, comment out this line.
# Don't use json gem version lower than 1.1.7! Older version have a security bug
gem "json_pure", ">= 1.1.7", :require_as => "json"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
gem "merb-core", merb_gems_version
gem "merb-assets", merb_gems_version
gem "merb-builder", "0.9.8"
gem("merb-cache", merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end
gem "merb-haml", merb_gems_version
gem "merb-helpers", merb_gems_version
gem "merb-exceptions", merb_gems_version

gem "data_objects", do_gems_version
gem "do_sqlite3", do_gems_version # If using another database, replace this
gem "dm-core", dm_gems_version
gem "dm-aggregates", dm_gems_version
gem "dm-timestamps", dm_gems_version
gem "dm-types", dm_gems_version
gem "dm-validations", dm_gems_version
gem "dm-serializer", dm_gems_version

gem "merb_datamapper", merb_gems_version

gem "jm81-paginate", "0.1.6", :require_as => "paginate"
gem "jm81-dm-filters", "0.3.0", :require_as => "dm-filters"
gem "svn-fixture", "0.1.2"
gem "dm-svn", "0.2.2"
gem "antage-merb-recaptcha", "~> 1.0.0", :require_as => "merb-recaptcha"
