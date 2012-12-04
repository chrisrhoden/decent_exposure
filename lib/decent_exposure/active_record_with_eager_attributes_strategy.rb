require 'decent_exposure/active_record_strategy'

module DecentExposure
  class ActiveRecordWithEagerAttributesStrategy < ActiveRecordStrategy
    delegate :get?,    :to => :request
    delegate :delete?, :to => :request

    def singular?
      !plural?
    end

    def attributes
      custom_params || params[inflector.singular] || {}
    end

    def assign_attributes?
      return false unless attributes && singular?
      (!get? && !delete?) || new_record?
    end

    def new_record?
      !id
    end

    def resource
      super.tap do |r|
        r.attributes = attributes if assign_attributes?
      end
    end

    private
    def custom_params
      return @custom_params if defined?(@custom_params)
      @custom_params = controller.send(options[:params]) if options[:params]
    end
  end
end
