import Direction.*



/**
 * Represents the state of a frog.
 * STAY, GONE and HOME are stable states, the others are intermediate states.
 * When frog is moved: STAY => MOVE->(STAY|HOME).
 * When frog is smashed: (STAY||MOVE) => SMASH_1->SMASH_2->SMASH_3->DEAD->GONE.
 * When frog is drowned: (STAY||MOVE) => DROWN_1->DROWN_2->DROWN_3->DEAD->GONE.
 */
enum class FrogState {
    STAY,   // Frog is not moving (in a cell)
    MOVE,   // Frog is moving between cells
    SMASH_1, SMASH_2, SMASH_3,  // Intermediate states when frog is smashed
    DROWN_1, DROWN_2, DROWN_3,  // Intermediate states when frog is drowned
    DEAD,   // Frog is dead
    GONE,   // Frog is hidden
    HOME    // Frog is in a home
}

/**
 * Number of frames to change for next state if current state is intermediate.
 */
private const val STATE_FRAMES = 5

/**
 * The information of the frog.
 * @property position the position (x and y) of the frog
 * @property dir the direction where the frog is facing (UP, LEFT, DOWN, RIGHT)
 * @property state the state of the frog
 * @property frames the number of frames left to change state
 */


data class Frog(
    val position: Point,
    val dir: Direction,
    val state: FrogState,
    val frames: Int = 0
)


fun Frog.move(dir: Direction) =
    if (state == FrogState.STAY && (position + dir).isValid()) copy( state = FrogState.MOVE, dir = dir, frames = STATE_FRAMES)
    else this


fun createFrog() = Frog(Point(SCREEN_WIDTH/2 , START_ROW), UP, FrogState.STAY, STATE_FRAMES)


fun Frog.collide(obj:Movable)= obj.row == position.y  && position.x + GRID_SIZE in obj.toRangeX()


fun Frog.collideCars(cars:List<Car>):Boolean {
    return cars.any {collide(it.part)} // retorna true se algum colidir
}

fun Frog.collideLog(logs:List<Log>):Boolean {
    return logs.any {collide(it.part)}
}

fun Frog.collideTurtle(turtles:List<Turtle>):Boolean {
    return if (turtles.any {collide(it.part)}) {
        val turtle = turtles.first { collide(it.part) }
        turtle.state() !=  TurtleState.UNDER_WATER

    }  else false
}


fun Frog.getTurtleSpeed(turtles:List<Turtle>):Int {
    val turtle = turtles.first {collide(it.part)}
    return turtle.part.speed
}

fun Frog.getLogSpeed(logs:List<Log>):Int {
    val log = logs.first {collide(it.part)}
    return log.part.speed
}


fun Frog.smashed() = copy(state = FrogState.SMASH_1, frames = STATE_FRAMES)


fun Frog.home() = copy(state = FrogState.HOME, frames = 0)


fun Frog.splashZone(turtles: List<Turtle>, logs: List<Log>):Boolean {
    return state == FrogState.STAY && position.y < GRID_ROWS/2 && position.y != HOME_ROW && !collideTurtle(turtles) && !collideLog(logs) // retorna true se afogar
}

fun Frog.drowned() = copy(state = FrogState.DROWN_1, frames = STATE_FRAMES)


//When in contact with movable object moves with it
fun Frog.attached(speed: Int) = copy(position = position + speed)


fun Frog.step(): Frog =
    if (frames > 0) copy(frames = frames - 1)
    else when (state) {
        FrogState.MOVE -> copy(state = FrogState.STAY, position = position + dir)
        FrogState.SMASH_1, FrogState.SMASH_2 -> {
            copy(frames = STATE_FRAMES, state = FrogState.values()[state.ordinal + 1])
        }

        FrogState.DROWN_1, FrogState.DROWN_2 -> {
            copy(frames = STATE_FRAMES, state = FrogState.values()[state.ordinal + 1])
        }

        FrogState.SMASH_3, FrogState.DROWN_3 -> {
            copy(state = FrogState.DEAD, frames = STATE_FRAMES)
        }

        FrogState.DEAD -> copy(state = FrogState.GONE)

        FrogState.HOME -> createFrog()

        else -> this
    }



