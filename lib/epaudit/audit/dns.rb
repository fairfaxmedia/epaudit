require 'net/dns'
require 'epaudit/audit/base'

module EPAudit
  class AuditDNS < AuditBase
    attr_accessor :resolver
    def initialize(options = {})
      super options
      @resolver = Net::DNS::Resolver.new
      resolver.nameservers = @config['nameservers']
    end
    def audit(options = {})
      begin
        data = resolver.query(options[:endpoint])
      rescue Exception => e
        $logger.info("#{e.class}::#{e.message}")
        status = AuditResult::FAILED
      end
      AuditResult.new(
        :source => self.class,
        :status => ( data.answer.size > 0 ) ? AuditResult::OK : AuditResult::ERROR,
        :data   => data,
      )
    end
  end
end
