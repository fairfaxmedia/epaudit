require 'epaudit/auditresult'
require 'epaudit/audit/base'
require 'borderlands/config'
require 'borderlands/propertymanager'
require 'pp'

module EPAudit
  class AuditAkamai < AuditBase
    def initialize(options = {})
      super options
      edgegrid_config = Borderlands::Config.new
      @propertymanager = Borderlands::PropertyManager.new(edgegrid_config.client(:default))
      @contracts = cache_block('akamai-contracts') do
        $logger.debug "akamai: retrieving contracts"
        @propertymanager.contracts
      end
      @groups = cache_block('akamai-groups') do
        $logger.debug "akamai: retrieving groups"
        @propertymanager.groups
      end
      @properties = cache_block('akamai-properties') do
        $logger.debug "akamai: retrieving properties"
        @propertymanager.properties
      end
      @hostnames = {}
      @properties.select{ |property| property.productionversion != nil }.each do |property|
        @hostnames[property.id] = cache_block("akamai-hostnames-#{property.id}") do
          $logger.debug "akamai: retrieving hostnames for production config: #{property.name}"
          @propertymanager.hostnames(property)
        end
      end
      $logger.debug "akamai: #{@contracts.size} contracts found"
      $logger.debug "akamai: #{@groups.size} groups found"
      $logger.debug "akamai: #{@properties.size} properties found"
      $logger.debug "akamai: #{@hostnames.size} property hostname sets found"
    end

    def audit(options = {})
      props = @properties.select do |property|
        if @hostnames[property.id]
          @hostnames[property.id].any? { |hn| hn.name == options[:endpoint] }
        end
      end
      AuditResult.new(
        :source => self.class,
        :status => ( props.size > 0 ) ? AuditResult::OK : AuditResult::WARNING,
        :data   => props,
      )
    end
  end
end
