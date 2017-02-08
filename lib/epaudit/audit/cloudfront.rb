require 'aws-sdk'
require 'epaudit/audit/base'
require 'logger'

module EPAudit
  class AuditCloudFront < AuditBase
    attr_accessor :distributions
    def initialize(options = {})
      super options
      @cloudfront = Aws::CloudFront::Client.new
      @distributions = cache_block('distributions') do
        begin
          dist = @cloudfront.list_distributions
          dist.distribution_list.items
        rescue Exception => e
          $logger.error "#{e.class}/#{e.message}"
          @setup_failure = true
        end
      end
    end

    def audit(options = {})
      dist = @distributions.select do |d|
        d.aliases.items.include? options[:endpoint]
      end
      AuditResult.new(
        :source => self.class,
        :status => ( dist && dist.size > 0 ) ? AuditResult::OK : AuditResult::NOTFOUND,
        :data   => dist,
      )
    end
  end
end
