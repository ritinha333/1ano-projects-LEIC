package queue

fun main() {
    val queue1 = AEDCircularQueueArray<String>(10)
    queue1.enqueue("Ana")
    queue1.enqueue("Maria")
    queue1.enqueue("Rui")
    val element = queue1.dequeue()
    println("next element = $element")

    val queue2 = AEDCircularQueueArray<Pair<Int, String>>(20)
    queue2.enqueue(Pair(1201, "Ana"))
    queue2.enqueue(Pair(1205, "Maria"))
    queue2.enqueue(Pair(1202, "Rui"))
    println("elements:")
    println("${queue2.dequeue()}")
    println("${queue2.dequeue()}")
    println("${queue2.dequeue()}")
}
