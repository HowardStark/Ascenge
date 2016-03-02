

class HiddenWallTile < Tile
    @char = "H"
    @traversable = false

    def initialize
        @flavor = "This is a wall?"
        @char = "#"
        @traversable = false
    end

    def interacted
        @flavor = "It's a hidden door!"
        @char = "H"
        @traversable = true
    end
end
