

class DirtTile < Tile

    @char = "."

    def initialize
        isSpecial = Random.rand(0...6)
        if(isSpecial == 5)
            @char = ","
        else
            @char = "."
        end
        @traversable = true
    end
end
