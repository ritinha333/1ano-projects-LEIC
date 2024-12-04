fun main() {
 
    val languages = arrayOf("Kotlin", "Java", "C", "C++", "C#", "JavaScript")
    println(languages[0])
    println(languages[4])
    println("-------------------")
    println(languages.get(0))
    println(languages.get(5))
    println("-------------------")
    println(languages.component1())
    println(languages.component5())
    println("-------------------")
    println(languages.elementAt(1))
    //println(languages.elementAtOrElse(2, 5))
    println(languages.elementAtOrNull(2))
    //println(languages.getOrElse(2,"kotlin"))
    println(languages.getOrNull(0))


    val food = arrayOf(
        arrayOf(1,2,3),
        arrayOf(4,5,6),
        arrayOf(7,8,9)
    )

    val row1= food[0]
    val row2 = food[2]

    val first= row1[1]
    val second = row2[2]
    println("-------------------")
    println("$row1")
    println("$row2")
    println("$first")
    println("$second")

}