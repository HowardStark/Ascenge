

class TreeTile < Tile

    @char = "T"
    @traversable = false

    def initialize
        random = Random.rand(0...3)
        case random
        when 0
            tree = "small"
        when 1
            tree = "medium"
        else
            tree = "grand"
        end

        @flavor = "Before you stands a #{tree} tree, probably an oak."
        @char = "T"
        @traversable = false
    end


end
