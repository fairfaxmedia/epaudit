require 'yaml'

module EPAudit
  class Config
    DEFAULT_FILENAME = "#{ENV['HOME']}/.epaudit.yaml"
    attr_reader :filename
    def initialize(options = {})
      @filename = options[:filename] || DEFAULT_FILENAME
      @config = YAML.load_file(filename)
    end
    def [](x)
      @config[x]
    end
    def dig(*args)
      @config.dig(*args)
    end
  end
end
