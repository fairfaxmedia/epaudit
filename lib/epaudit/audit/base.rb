require 'logger'
require 'persistent-cache'

module EPAudit
  class AuditBase
    NO_STATUS = 'no status'
    def initialize(options = {})
      @config_section = self.class.to_s.sub(/^.*::[A-Z][a-z]*/,'').downcase
      @config = options[:config][@config_section]
      $logger.debug "initialising auditor: #{@config_section}"
      setup_cache
    end

    def setup_cache
      home  = File.join(Dir.home,'.epaudit')
      cache = File.join(home,@config_section)
      $logger.debug "opening cache file: #{cache}"
      Dir.mkdir(home)  unless Dir.exists?(home)
      @cache = Persistent::Cache.new(
        cache,
        43200, # 12 hour TTL default
      )
    end

    def audit(options = {})
      NO_STATUS
    end

    def cache_put(key,value)
      @cache[key] = value
    end

    def cache_block(key)
      raise Exception.new('must supply a block') unless block_given?
      @cache[key] = yield(key) unless @cache.key? key
      @cache[key]
    end

    def cache_get(key)
      @cache[key]
    end
  end
end
