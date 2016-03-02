class FireplaceTile < Tile

    @char = "F"
    @traversable = false

    def initialize
        @flavor = "That looks like a hot fireplace."
        @char = "*"
        @traversable = false
        @damageAmount = 1.5
    end

    def interacted
        @flavor = "That looks like a hot fireplace."
        @char = "*"
        @traversable = true
    end

    def ontop(entity)
        @flavor = "It is definitely a hot fireplace."
        @char = "*"
        @traversable = true
        entity.damage(@damageAmount)
        if(entity.instance_of?(Player))
            World.getInstance.setTitle("Ow! You're at " + Player.getInstance.getHealth.to_s + "HP")
        end
    end
end
