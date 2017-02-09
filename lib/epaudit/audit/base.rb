require 'logger'
require 'active_support/cache'

module EPAudit
  class AuditBase
    NO_STATUS = 'no status'
    attr_reader :config_section
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
      @cache = ActiveSupport::Cache::FileStore.new(cache, :expires_in => 1.minute)
    end

    def audit(options = {})
      NO_STATUS
    end

    def cache_block(key)
      raise Exception.new('must supply a block') unless block_given?
      result = @cache.read(key)
      if result == nil
        result = yield(key)
        @cache.write(key,result)
      end
      result
    end
  end
end
