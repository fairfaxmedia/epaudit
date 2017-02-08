require "epaudit/version"
require "epaudit/logger"
require "epaudit/auditor"

require 'thor'

module EPAudit
  class CLI < Thor
    desc 'version', 'display the EPAudit gem version'
    def version
      puts "epaudit version #{EPAudit::VERSION}"
    end

    desc 'audit', 'audit a single endpoint'
    def audit(endpoint)
      auditor = Auditor.new
      [ auditor.audit(endpoint) ].flatten.each do |result|
        $logger.info result.inspect
      end
    end
  end
end
