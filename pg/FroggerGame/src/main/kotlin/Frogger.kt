/**
 * Represents the state of the game.
 * @property frog the frog representation
 * @property cars the list of cars in the game
 */
data class Frogger(
    val frog: Frog,
    val cars: List<Car>,
    val logs: List<Log>,
    val turtles: List<Turtle>,
    val homes: List<Home>
)



fun Frogger.step(): Frogger {
    val newCars = cars.map { car ->
        car.move() }
    val newLogs = logs.map{ log ->
        log.move() }
    val newTurtles = turtles.map{ turtle ->
        turtle.move() }
    // if not gone and homes still free move frog with direction,turtles and logs
    return if (frogNotGone() && freeHomes())
        copy(frog = frog.step(), cars = newCars, logs = newLogs, turtles = newTurtles).detectCollidingCars().detectDrowning()
            .withTurtles().withLogs().detectHomes()
    else copy ( cars = newCars,
        logs = newLogs,
        turtles = newTurtles)
}

fun Frogger.detectCollidingCars(): Frogger =
    if(frog.collideCars(cars)) copy(frog = frog.smashed()) else this

fun Frogger.detectDrowning(): Frogger =
    if(frog.splashZone(turtles,logs)) copy(frog = frog.drowned()) else this

fun Frogger.withTurtles(): Frogger =
    if (frog.collideTurtle(turtles) && frogStay()) copy(frog = frog.attached(frog.getTurtleSpeed(turtles))) else this

fun Frogger.withLogs(): Frogger =
    if (frog.collideLog(logs) && frogStay()) copy(frog = frog.attached(frog.getLogSpeed(logs))) else this

//Returns true se alguma casa está vazia
fun Frogger.freeHomes():Boolean {
    return homes.any {!it.isFull()}
}

//Calcula casas vazias e muda o estado para HOME quando na casa certa
fun Frogger.detectHomes():Frogger =
    if(frog.position.y == HOME_ROW &&  frogStay()) {
        val emptyhomes = homes.count { it.empty }
        val newHomes = homes.map { home ->
            if (home.canAccept(frog.position)) home.fill() else home
        }
        val newHomeFilled = newHomes.count { it.empty } != emptyhomes
        if (newHomeFilled) copy(frog = frog.home(), homes = newHomes) else copy(frog = frog.smashed())
    }
    else this

fun Frogger.moveFrog(dir:Direction):Frogger {
    val newFrog = frog.move(dir)
    return copy(frog = newFrog)
}

fun Frogger.frogNotGone() = frog.state != FrogState.GONE

fun Frogger.frogStay() = frog.state == FrogState.STAY

