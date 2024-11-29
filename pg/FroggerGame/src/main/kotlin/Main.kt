import pt.isel.canvas.*

const val REFRESH_TIME = 25  // 40 fps  (1000/40 = 25 ms)
const val GRID_SIZE = 42
const val GRID_ROWS = 16
const val GRID_COLS = 14
const val SCREEN_WIDTH = GRID_SIZE * GRID_COLS
const val SCREEN_HEIGHT = GRID_SIZE * GRID_ROWS
const val START_ROW = GRID_ROWS-2

/**
 * The main function of the Frogger game.
 * Creates a canvas and starts the game.
 * The frog is moved by pressing the arrow keys.
 * The game evolved and is redrawn every REFRESH TIME.
 */
fun main() {
    onStart {
        val canvas = Canvas(SCREEN_WIDTH, SCREEN_HEIGHT, BLACK)
        var game = Frogger(frog= createFrog(), cars= createCars(), logs = createLogs(), turtles = createTurtles(), homes = createHomes())
        canvas.onKeyPressed { key ->
            val dir = key.toDirection()
            if (dir != null) game = game.moveFrog(dir)
        }
        canvas.onTimeProgress(REFRESH_TIME) {
            game = game.step()
            canvas.drawGame(game)
        }
    }
    onFinish { }
}

/**
 * Returns the direction corresponding to the pressed key.
 * If key is not a direction key, returns null.
 * @receiver the event of key pressed
 * @return the direction corresponding to the key pressed or null
 */

fun KeyEvent.toDirection(): Direction? = when(code) {
    LEFT_CODE -> Direction.LEFT
    RIGHT_CODE -> Direction.RIGHT
    UP_CODE -> Direction.UP
    DOWN_CODE -> Direction.DOWN
    else -> null
}

