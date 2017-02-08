require 'synthetics'
require 'epaudit/auditresult'
require 'epaudit/audit/base'
require 'uri'

module EPAudit
  class AuditSynthetics < AuditBase
    def initialize(options = {})
      super options
      @synthetics = Synthetics.new(@config['apikey'])
      @monitors = cache_block('synthetics') do
        mons = @synthetics.monitors.list[:monitors]
        mons.keep_if { |monitor| monitor[:uri] }
        mons
      end
    end

    def audit(options = {})
      mons = @monitors.select do |monitor|
        URI(monitor[:uri]).host == options[:endpoint]
      end
      AuditResult.new(
        :source => self.class,
        :status => ( mons.size > 0 ) ? AuditResult::OK : AuditResult::WARNING,
        :data   => mons,
      )
    end
  end
end

