

class DoorTile < Tile

    @char = "_"
    @traversable = false

    def initialize
        @flavor = "Look at this door."
        @char = "_"
        @traversable = false
    end

    def interacted
        @flavor = "Look at this door."
        @char = "|"
        @traversable = true
    end
end
