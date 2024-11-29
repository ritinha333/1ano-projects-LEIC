import pt.isel.canvas.*
import CarType.*
import FrogState.*
import TurtleState.*


fun Canvas.drawGame(frogger: Frogger) {
    erase()
    //drawGrid()
    drawRiver()
    drawLogs(frogger.logs)
    drawTurtles(frogger.turtles)
    drawSidewalk()
    drawHouses()
    drawCars(frogger.cars)
    drawFrog(frogger.frog)
    drawFrogWinner(frogger.homes)
}

/**
 * Draws the lake.
 * @receiver the canvas to draw on
 */

fun Canvas.drawRiver() {
    val numColumns = (SCREEN_WIDTH / GRID_SIZE) + 1
    val numRows = (SCREEN_HEIGHT / GRID_SIZE) + 1
    repeat(numColumns) { column ->
        repeat(numRows) { row ->
            val x = column * GRID_SIZE
            val y = row * GRID_SIZE / 3
            drawImage("frogger|3,391,27,16", x, y, GRID_SIZE * 2, GRID_SIZE * 3)
        }
    }
}

fun Canvas.drawHouses() {
    val y = GRID_SIZE + GRID_SIZE / 2
    for(x in 0..SCREEN_WIDTH step GRID_SIZE*3)
        drawImage("frogger|1,188,32,24", x, y, GRID_SIZE*2, GRID_SIZE+(GRID_SIZE/2))
    for(x in 0..SCREEN_WIDTH step GRID_SIZE*3)
        drawImage("frogger|35,188,8,24", x+GRID_SIZE*2, y, GRID_SIZE/2, GRID_SIZE+(GRID_SIZE/2))
    for(x in 0..SCREEN_WIDTH step GRID_SIZE*3)
        drawImage("frogger|35,188,8,24", x+GRID_SIZE*2+GRID_SIZE/2, y, GRID_SIZE/2, GRID_SIZE+(GRID_SIZE/2))
}

fun Canvas.drawSidewalk() {
    repeat(14) { i ->
        drawImage("frogger|135,196,16,16", GRID_SIZE * i, GRID_SIZE * (GRID_ROWS / 2), GRID_SIZE, GRID_SIZE)
        drawImage("frogger|135,196,16,16", GRID_SIZE * i, GRID_SIZE * GRID_COLS, GRID_SIZE, GRID_SIZE)
    }
}

fun CarType.getImage() = when(this){
    TRUCK -> "frogger|71,116,35,16"
    SPEED1 -> "frogger|37,116,16,16"
    CAR -> "frogger|0,116,18,17"
    BULLDOZER -> "frogger|53,116,17,17"
    SPEED2-> "frogger|19,116,16,16"
}

fun Canvas.drawCar(car:Car){
    drawImage(car.type.getImage(), car.part.x, car.part.row * GRID_SIZE, car.part.size * GRID_SIZE, GRID_SIZE)
}

fun Canvas.drawHome(home:Home){
    drawImage(HOME.getImage(), home.x , HOME_ROW * GRID_SIZE,  GRID_SIZE, GRID_SIZE)
}


fun Canvas.drawCars(cars:List<Car>) {
    cars.forEach { drawCar(it) }
}

fun Log.getImage(i : Int): String {
    return when(i) {
        1 -> "frogger|0,133,16,16"
        part.size -> "frogger|36,133,16,16"
        else -> "frogger|18,133,16,16"
    }
}


fun Canvas.drawLog(log: Log){
    for(x in 1..log.part.size) {
        drawImage(log.getImage(x),log.part.x + (x-1) * GRID_SIZE,log.part.row * GRID_SIZE, GRID_SIZE+4, GRID_SIZE)
    }
}

fun Canvas.drawLogs(logs:List<Log>){
    logs.forEach { drawLog(it) }
}

fun TurtleState.getImage()= when(this) {
    SWIM_1 -> "frogger|0,152,16,16"
    SWIM_2 -> "frogger|18,152,16,16"
    SWIM_3 -> "frogger|36,152,16,16"
    DIVE_1 -> "frogger|55,152,16,16"
    DIVE_2 -> "frogger|72,152,16,16"
    UNDER_WATER -> ""
}



fun Canvas.drawTurtle(turtle: Turtle) {
    for(x in 1..turtle.part.size){
            if(turtle.state()!=UNDER_WATER)
            drawImage(turtle.state().getImage(),turtle.part.x + (x-1) * GRID_SIZE ,turtle.part.row * GRID_SIZE, (GRID_SIZE +  (turtle.part.size)) , GRID_SIZE )
    }
}

fun Canvas.drawTurtles(turtles:List<Turtle>){
    turtles.forEach { drawTurtle(it) }
}


fun FrogState.getImage() = when(this) {
    SMASH_1 -> "frogger|0,80,16,16"
    SMASH_2 -> "frogger|19,80,16,16"
    SMASH_3 -> "frogger|37,80,16,16"
    DROWN_1 -> "frogger|55,80,16,16"
    DROWN_2 -> "frogger|72,80,16,16"
    DROWN_3 -> "frogger|90,80,16,16"
    DEAD -> "frogger|110,80,16,16"
    HOME -> "frogger|43,193,20,20"
    else -> ""
}


fun Canvas.drawFrogMoving(frog: Frog) {
    var xslide = 0
    var yslide = 0
    val jump = GRID_SIZE/4
    if (frog.state == MOVE) {
        xslide = frog.dir.dCol/GRID_SIZE * ((5-frog.frames)*jump)
        yslide = frog.dir.dRow * ((5-frog.frames)*jump)
    }
    val x = frog.position.x + xslide
    val y = frog.position.y * GRID_SIZE + yslide
    val sprite = when(frog.dir){
        Direction.UP -> if( frog.state == MOVE) "frogger|18,0,16,16" else "frogger|0,0,16,16"
        Direction.DOWN -> if(frog.state ==  MOVE) "frogger|90,0,16,16" else "frogger|72,0,16,16"
        Direction.LEFT -> if(frog.state ==  MOVE) "frogger|55,0,16,16" else "frogger|35,0,16,16"
        Direction.RIGHT -> if( frog.state == MOVE) "frogger|127,0,16,16" else "frogger|110,0,16,16"
    }
    drawImage( sprite , x , y, GRID_SIZE, GRID_SIZE)
}


fun Canvas.drawFrogChanging(frog: Frog) {
    val x = frog.position.x
    val y = frog.position.y * GRID_SIZE
    drawImage( frog.state.getImage() , x , y, GRID_SIZE, GRID_SIZE)
}

fun Canvas.drawFrogEnded() {
    drawMessage(2,GRID_ROWS/2, "GAME OVER")
}

fun Canvas.drawFrog(frog:Frog){
        if(frog.state == MOVE || frog.state == STAY)
            drawFrogMoving(frog)
        else if (frog.state != GONE && frog.state != HOME)
            drawFrogChanging(frog)
        else if (frog.state == GONE)
            drawFrogEnded()
        }


fun Canvas.drawMessage(x: Int, y: Int, message: String) {
    message.forEachIndexed { index, element -> if (element != ' ')
        drawImage(element.getImage(),(x+index)*GRID_SIZE,y*GRID_SIZE,GRID_SIZE,GRID_SIZE)
    }
}

fun Char.getImage(): String =
    when (this) {
        'G' -> "frogger|144,360,10,10"
        'A' -> "frogger|90,360,10,10"
        'M' -> "frogger|45,369,10,10"
        'E' -> "frogger|127,360,10,10"
        'O' -> "frogger|63,369,10,10"
        'V' -> "frogger|127,369,10,10"
        'R' -> "frogger|90,369,10,10"
        'Y' -> "frogger|0,378,10,10"
        'U' -> "frogger|118,369,10,10"
        'W' -> "frogger|135,369,10,10"
        'I' -> "frogger|10,369,10,10"
        'N' -> "frogger|54,369,10,10"
        else -> ""
    }

fun Canvas.drawFrogWinner(homes: List<Home>) {
    homes.forEach { if (it.isFull()) drawHome(it) }
    if (!homes.any {!it.isFull()})
        drawMessage(4,GRID_ROWS/2, "YOU WIN")
}


