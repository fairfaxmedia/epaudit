module EPAudit
  class AuditResult
    OK       = 'ok'
    WARNING  = 'not ok'
    ERROR    = 'error'
    NOTFOUND = 'not found'
    FAILED   = 'failure'
    attr_reader :status
    attr_reader :data
    def initialize(options = {})
      @source = options[:source]
      @status = options[:status]
      @data   = options[:data]
    end

    def valid?
      @status != FAILED
    end

    def inspect
      "#{@source}: status='#{status}', items=#{[ data ].flatten.size}"
    end
  end
end
