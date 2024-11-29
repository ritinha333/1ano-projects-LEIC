data class Point(var x:Int, var y:Int)

operator fun Point.plus(dir:Direction) = Point(x = x + dir.dCol, y = y + dir.dRow)

operator fun Point.plus(speed:Int) = Point(x = x + speed, y )

fun Point.isValid(): Boolean = x in 0 until GRID_COLS*GRID_SIZE && y in 0 until GRID_ROWS-1