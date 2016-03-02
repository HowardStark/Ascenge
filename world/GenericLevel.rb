class GenericLevel < Level
    def initialize(level)
        @tiles = Array.new

        @xCoord = World.getInstance.getWidth / 2 - 5
        @yCoord = World.getInstance.getHeight / 2 - 7
        @xFinish = World.getInstance.getWidth / 2 + 4
        @yFinish = World.getInstance.getHeight / 2 + 8

        length = @xFinish - @xCoord
        height = @yFinish - @yCoord

        length.times { |x|
            @tiles[x] = Array.new
            height.times { |y|
                if (x == 0 || y == 0 || x == length - 1|| y == height - 1)
                    @tiles[x][y] = WallTile.new
                else
                    @tiles[x][y] = FloorTile.new
                end
            }
        }

        @properties = {
            "" => "",
        }
        @level = level
    end
end
