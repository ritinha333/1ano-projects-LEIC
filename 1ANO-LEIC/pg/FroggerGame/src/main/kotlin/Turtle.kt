import TurtleState.*
/**
 * Possible animation states of a turtle.
 * SWIM_1, SWIM_2, SWIM_3: the turtle is swimming (first 3 sprites of turtle)
 * DIVE_1, DIVE_2: the turtle is diving (last 2 sprites of turtle)
 * UNDER_WATER: the turtle is underwater (no sprite)
 */
enum class TurtleState { SWIM_1, SWIM_2, SWIM_3, DIVE_1, DIVE_2, UNDER_WATER }

/**
 * Successive animation states of a no diver (normal) turtle.
 */
private val NormalStates = listOf(SWIM_1, SWIM_2, SWIM_3, SWIM_2)
/**
 * Successive animation states of a diver turtle.
 */
private val DiverStates = listOf(SWIM_1, SWIM_2, SWIM_3, DIVE_1, DIVE_2, UNDER_WATER, DIVE_2, DIVE_1, SWIM_3, SWIM_2)

/**
 * Number of frames to change for next animation state.
 */
private const val STATE_FRAMES = 5

/**
 * Represents a group of turtles swimming in the river of game.
 * @property part the movable object that represents the group of turtles
 * @property diver true if the group of turtles dives, false otherwise
 * @property anim the index of animation state of turtles
 * @property frames the number of frames in each animation state
 */
data class Turtle(val part: Movable, val diver: Boolean, val anim: Int =0, val frames: Int = STATE_FRAMES)

/**
 * Number os pixels moved by a turtle in each frame.
 */
private const val TURTLE_SPEED = -2

/**
 * Creates a group of 2 turtles in row 4, in the given [column] and the given [diver] property.
 */
private fun turtle2(column: Int, diver: Boolean =false) = Turtle(
    part = Movable(x= column * GRID_SIZE, row= 4, size= 2, speed= TURTLE_SPEED),
    diver = diver
)

/**
 * Creates a group of 3 turtles in row 7, in the given [column] and the given [diver] property.
 */
private fun turtle3(column: Int, diver: Boolean =false) = Turtle(
    part= Movable(x= column * GRID_SIZE, row= 7, size= 3, speed= TURTLE_SPEED),
    diver= diver
)

/**
 * Creates all groups of turtles in game.
 */
fun createTurtles() = listOf(
    turtle2(0), turtle2(4), turtle2(8), turtle2(12, diver = true),
    turtle3(-2), turtle3(3), turtle3(7, diver = true), turtle3(11)
)

/**
 * Returns the animation state of the group of turtles.
 */
fun Turtle.state() = if (diver) DiverStates[anim] else NormalStates[anim]

/**
 * Returns the group of turtles after moving it, for each frame.
 * The group of turtles is moved by moving its movable part.
 * The animation state is changed after a number of frames.
 */
fun Turtle.move(): Turtle =
    if (frames > 1)
        copy(part= part.move(), frames= frames-1)
    else
        copy(
            part = part.move(),
            anim = (anim+1) % if (diver) DiverStates.size else NormalStates.size,
            frames = STATE_FRAMES
        )
