# Ascenge

Ascenge is a 2D ASCII game engine built in Ruby. It's designed to be simple to use for beginners, with the expandability for more advanced uses. It's currently a work-in-progress, and there aren't any games currently built on Ascenge.

## World Architecture

This is the hierarchy for a world in Ascenge thus far. (This will change. It's been a while since I thought of all this)
```
    World
    ├── Chunk
    └── Level
        ├── Area
        │   └── Tile
        └── Entity
```
The World is the main class that handles and starts everything. The World also handles the UI, although that is subject to change later.

The World, on startup, creates a Chunk. The Chunk is actually just a way to render what the player can currently see. While the world manages the UI, the Chunk displays what is currently seen on-screen.

The Level is, as the name would suggest, a level in the game. The current level could be compared to a Z coordinate, and fully implementing the third dimension is an item on the to-do list.

The Level doesn't directly handle the tiles, though. Instead, that is left up to Areas. Areas can represent anything, from a dungeon room to a small closet. They are just a small collection of tiles. This layer is for ease of generation for world events.

The Level does handle all the entities in the level. If an area or a room has a quota for entities, it spawns the entities with a given x and y coordinate and a pointer to the current level they are on. Then it hands them off to the level, and the level manages them from there.

The final layer is the Tile. The tile is a collection of an ASCII character and a few other properties. The basic properties are `traversable`, their character, and effects. Interactive tiles are on the to-do list.

## Next Steps (TODO)

 - Tile
     - Implement tile effects
     - Interactive tiles
     - Uniquity
     - Coloring
 - Entity
     - Work on NPCs
     - Add Questing
 - Chunk
     - Render only what's in view
     - Shift chunk over when moving out-of-view
 - UI
     - Add better titles
     - Add action navigator
     - (Idea) Dialog in action navigator screen section
     - Coloring
     - Add main menu
 - Abstraction
     - Re-work engine to make it more 'engine-y'
     - ITEMS!
