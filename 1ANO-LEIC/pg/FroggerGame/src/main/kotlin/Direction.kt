enum class Direction(val dRow: Int = 0, val dCol: Int = 0) {
    DOWN(dRow = +1), LEFT(dCol = -GRID_SIZE), RIGHT(dCol = +GRID_SIZE), UP(dRow = -1)
}
