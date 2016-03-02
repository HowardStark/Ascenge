module Exceptions
    class IllegalTileStateException < StandardError
        attr_reader :msg
        def initialize(msg)
            super
            @msg = msg
            @tag = "IllegalTileStateException"
            Log.e(self.class.name, @msg)
        end
    end

    class IllegalEntityStateException < StandardError
        attr_reader :msg
        def initialize(msg)
            super
            @msg = msg
            Log.e(self.class.name, @msg)
        end
    end

    class IllegalEntityMovementException < StandardError
        attr_reader :msg
        def initialize(msg)
            super
            @msg = msg
            Log.e(self.class.name, @msg)
        end
    end

    class IllegalArgumentException < StandardError
        attr_reader :msg
        def initialize(msg)
            super
            @msg = msg
            Log.e(self.class.name, @msg)
        end
    end
end
