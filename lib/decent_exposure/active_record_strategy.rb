require 'decent_exposure/strategy'
require 'active_support/core_ext/module/delegation'

module DecentExposure
  class ActiveRecordStrategy < Strategy
    delegate :plural?, :parameter, :to => :inflector

    def collection
      inflector.plural.to_sym
    end

    def scope
      if options[:ancestor]
        ancestor_scope
      else
        default_scope
      end
    end

    def ancestor_scope
      if plural?
        controller.send(options[:ancestor]).send(inflector.plural)
      else
        controller.send(options[:ancestor])
      end
    end

    def default_scope
      if controller.respond_to?(collection) && !plural?
        controller.send(collection)
      else
        model
      end
    end

    def finder
      options[:finder] || :find
    end

    def builder
      options[:builder] || default_builder
    end

    def default_builder
      scope.respond_to? :build ? :build : :new
    end

    def collection_resource
      scope.send(scope_method)
    end

    def id
      params[parameter] || params[finder_parameter]
    end

    def finder_parameter
      options[:finder_parameter] || :id
    end

    def singular_resource
      if id
        scope.send(finder, id)
      else
        scope.send(builder)
      end
    end

    def resource
      if plural?
        collection_resource
      else
        singular_resource
      end
    end

    private

    def scope_method
      if defined?(ActiveRecord) && ActiveRecord::VERSION::MAJOR > 3
        :all
      else
        :scoped
      end
    end
  end
end
