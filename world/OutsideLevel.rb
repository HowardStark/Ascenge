class OutsideLevel < Level
    def initialize
        @tiles = Array.new
        @xCoord = World.getInstance.getStartWidth
        @yCoord = World.getInstance.getStartHeight
        @xFinish = World.getInstance.getWidth
        @yFinish = World.getInstance.getHeight

        loadPath("maps/outside")

        @properties = {
            "" => "",
        }
        @level = 0
    end
end
