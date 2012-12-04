module DecentExposure
  class Strategy
    attr_reader :controller, :inflector, :options

    def initialize(controller, inflector, options={})
      @controller, @inflector, @options = controller, inflector, options
    end

    def name
      inflector.name
    end

    def resource
      raise 'Implement in subclass'
    end

    protected

    def model
      inflector.constant(controller.class)
    end

    def params
      controller.params
    end

    def request
      controller.request
    end
  end
end
