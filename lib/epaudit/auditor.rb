require 'net/dns'
require 'epaudit/audit/dns'
require 'epaudit/audit/synthetics'
require 'epaudit/audit/cloudfront'
require 'epaudit/audit/akamai'
require 'epaudit/config'

module EPAudit
  class Auditor
    CHECKS = [
      'EPAudit::AuditDNS',
      'EPAudit::AuditSynthetics',
      'EPAudit::AuditCloudFront',
      'EPAudit::AuditAkamai',
    ]
    attr_reader :config
    attr_reader :checks
    def initialize(options = {})
      @config = Config.new(:filename => options[:config_filename])
      @checks = CHECKS.map do |cn|
        Object::const_get(cn).new(:config => @config)
      end
    end

    def audit(endpoint)
      results = {}
      @checks.each do |check|
        r = check.audit(
          :endpoint => endpoint,
          :results => results
        )
       results[check.config_section] = r
      end
      results
    end
  end
end
