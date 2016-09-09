module ServiceClient
  module Middleware

    # Base class for middlewares.
    #
    # Default implementations for `enter`, `leave` and `error`
    # return the context object `ctx` without manipulating it.
    # The subclasses can override all or some of these methods.
    #
    class MiddlewareBase
      def enter(ctx)
        ctx
      end

      def leave(ctx)
        ctx
      end

      def error(ctx)
        ctx
      end

      def to_s
        self.class.name
      end

      def inspect
        self.class.name
      end

      def as_json(opts)
        to_s
      end
    end
  end
end
