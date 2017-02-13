require 'synthetics'
require 'epaudit/auditresult'
require 'epaudit/audit/base'
require 'uri'

module EPAudit
  class AuditSucuri < AuditBase
    def audit(options = {})
      @cloudfronts = [options[:results]['cloudfront']].flatten.map { |cf| cf.data }
      dists = @cloudfronts.flatten.select do |dist|
        dist.origins.items.any? do |origin|
          origin.domain_name.match? /^proxy-\w+\.fairfax\.com\.au$/
        end
      end
      AuditResult.new(
        :source => self.class,
        :status => ( dists.size > 0 ) ? AuditResult::OK : AuditResult::WARNING,
        :data   => dists,
      )
    end
  end
end

