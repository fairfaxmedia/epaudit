require 'erb'

module EPAudit
  class Renderer
    def initialize(options = {})
      @template_dir = options[:template_dir]
      @templates = {}
    end

    def render(results)
      renderings = {}
      results.each_pair do |check,result|
        @templates[check]  ||= ERB.new(template(check))
        renderings[check] ||= []
        renderings[check] << @templates[check].result(result.get_binding)
      end
      renderings
    end

  private

    def template(name)
      filename = File.join(@template_dir,"#{name}.erb")
      tmpl = File.read(filename)
      $logger.debug "loaded template: #{filename}"
      tmpl
    end
  end
end
