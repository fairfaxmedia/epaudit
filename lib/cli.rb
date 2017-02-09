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
      results = auditor.audit(endpoint)
      results.keys.sort.each do |check|
        $logger.info results[check].inspect
      end
    end
  end
end
