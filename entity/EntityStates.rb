module EntityStates extend self

    def add(key,value)
        @hash ||= Hash.new { |hash, key|
            raise IllegalEntityStateException, "#{key} is not a valid entity state."
        }
        @hash[key] = value
    end

    def const_missing(key)
        @hash[key]
    end

    def each
        @hash.each { |key,value|
            yield(key,value)
        }
    end

    EntityStates.add(:ENTITY_UNKNOWN, 0)
    EntityStates.add(:ENTITY_SLEEPING, 1)
    EntityStates.add(:ENTITY_ACTIVE, 2)
    EntityStates.add(:ENTITY_FIGHTING, 3)
    EntityStates.add(:ENTITY_HIDDEN, 4)

    EntityStates.add(:DIRECTION_UP, [0, -1])
    EntityStates.add(:DIRECTION_DOWN, [0, 1])
    EntityStates.add(:DIRECTION_LEFT, [-1, 0])
    EntityStates.add(:DIRECTION_RIGHT, [1, 0])
end
