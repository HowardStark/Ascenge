

class WallTile < Tile
    @char = "#"
    @traversable = false

    def initialize
        @flavor = "This is a wall."
        @char = "#"
        @traversable = false
    end

end
