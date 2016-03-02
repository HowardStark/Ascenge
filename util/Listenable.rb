

module Listenable

    def listeners()
        @listeners ||= []
    end

    def add_listener(listener)
        listeners << listener
    end

    def remove_listener(listener)
        listeners.delete listener
    end

    def notify_listeners(event_name, *args)
        Log.d(TurnEvent.tag, "#{event_name} has been notified with #{args}.")
        listeners.each do |listener|
            Log.d(TurnEvent.tag, "#{listener}")
            if listener.respond_to? event_name
                listener.__send__ event_name, *args
            end
        end
    end

end
