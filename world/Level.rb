class Level

    def initialize()
        @chunks = nil
        @level = nil
        @requirements = nil
        @tiles = Array.new
        @xCoord = nil
        @yCoord = nil
        @xFinish = nil
        @yFinish = nil
    end

    def getLevel
        @level
    end

    def getTiles
        @tiles
    end

    def getTile(x, y)
        Log.d(self.class.name, "Got #{@tiles[x][y].class.name} at #{x}, #{y}")
        return @tiles[x][y]
    end

    def paintLevel()
        @tiles.length.times { |x|
            @tiles[x].length.times { |y|
                Curses.setpos(y + @yCoord,x + @xCoord)
                Curses.addstr(@tiles[x][y].getCharacter)
            }
        }
        Curses.refresh
    end

    def paintTiles(tiles)
        tiles.each { |value|
            Curses.setpos(value[1] + @yCoord, value[0] + @xCoord)
            Curses.addstr(@tiles[value[0]][value[1]].getCharacter)
        }
        Curses.refresh
    end

    def getBounds
        return [@xCoord, @yCoord, @xFinish, @yFinish]
    end

    def loadPath(path)
        shouldSpawn = false
        spawnX = nil
        spawnY = nil
        linenum = nil
        Log.d(self.class.name, "Starting level generation")
        File.foreach(File.expand_path(path)).with_index { |line,linenum|
            line.delete!("\n")
            line.length.times { |x|
                @tiles[x] ||= Array.new
                @tiles[x][linenum] = NullTile.new(line[x])
                Tile.descendants.each { |descendant|
                    if(descendant.getCharacter == line[x])
                        @tiles[x][linenum] = descendant.new
                        break
                    end
                }
                if(line[x] == "@")
                    Log.d(self.class.name, line[x])
                    Log.d(self.class.name, @tiles[x][linenum])
                    @tiles[x][linenum] = @tiles[x - 1][linenum]
                    Log.d(self.class.name, @tiles[x - 1][linenum])
                    spawnX = x
                    spawnY = linenum
                    shouldSpawn = true
                end
            }
        }
        if(shouldSpawn)
            Player.getInstance.create(spawnX, spawnY, self)
        end

        Log.d(self.class.name, "Finishing level generation")
    end

    def isWithinBounds(x, y)
        Log.d(self.class.name, "Is within bounds #{x}, #{y}?")
        if(x > @xCoord && x < @xFinish || y < @yCoord && y > @yFinish)
            return true
        else
            return false
        end
    end

end
