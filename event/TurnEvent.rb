class TurnEvent
    include Listenable

    @@turns = 0
    @@tag = "TurnEvent"

    def turnHappened
        @@turns+=1
        notify_listeners :turn, @@turns
        Log.v(@@tag, "turn #{@@turns} has happened")
    end

    def self.getInstance
        @@instance ||= TurnEvent.new
    end

    def self.tag
        @@tag
    end
end
