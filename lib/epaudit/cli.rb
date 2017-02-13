require "epaudit/version"
require "epaudit/logger"
require "epaudit/auditor"
require "epaudit/renderer"

require 'thor'
require 'pp'

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

      renderer = Renderer.new(:template_dir => auditor.config.dig('epaudit','template_dir'))

      pp renderer.render(results)
    end

    desc 'audit_all', 'audit all configured endpoints'
    def audit_all
      auditor = Auditor.new
      endpoints = [ auditor.config.dig('epaudit','endpoints').flatten ]
      if endpoints.size < 1
        $logger.error("must supply endpoints")
        exit false
      end

      result_sets = {}
      endpoints.flatten.each do |endpoint|
        $logger.debug "auditing: #{endpoint}"
        result_sets[endpoint] = auditor.audit(endpoint)
      end

      renderer = Renderer.new(:template_dir => auditor.config.dig('epaudit','template_dir'))

      rendering_sets = {}
      result_sets.each_pair do |endpoint,results|
        rendering_sets[endpoint] = renderer.render(results)
      end

      pp rendering_sets
    end
  end
end
