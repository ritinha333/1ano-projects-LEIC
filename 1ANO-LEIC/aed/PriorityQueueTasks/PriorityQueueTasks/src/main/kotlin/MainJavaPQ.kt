import java.util.PriorityQueue

fun main(){
    println("Using Java PriorityQueue (resizable)")
    val pq = PriorityQueue { x: Task?, y: Task? -> cmpResult(x, y) }
    val task0=Task("Task0",0,90)
    val task1=Task("Task1",1,40)
    val task2=Task("Task2",2,30)
    val task3=Task("Task3",3,60)
    val task4=Task("Task4",4,70)
    val task5=Task("Task5",5,10)
    val task6=Task("Task6",6,20)
    val task7=Task("Task7",7,20)
    pq.offer(task0)
    pq.offer(task1)
    pq.offer(task2)
    pq.offer(task3)
    pq.offer(task4)
    pq.offer(task5)
    pq.offer(task6)
    pq.offer(task7)
    println(pq)
    println("#######################################################################################################")

    println("Size = ${pq.size}")
    println("Peek = ${pq.peek()}")
    println("Poll = ${pq.poll()}")
    println("Poll = ${pq.poll()}")
    println()
    println(pq)
}

