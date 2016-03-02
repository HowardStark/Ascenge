

class NullTile < Tile

    @char = "?"
    @traversable = false

    def initialize(character)
        @flavor = "What a mysterious thing this is..."
        @char = character
        @traversable = false
    end

end
