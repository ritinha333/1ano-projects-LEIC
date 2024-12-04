package queue

interface AEDCircularQueue<E>{
    fun isEmpty(): Boolean
    fun enqueue(element: E)
    fun dequeue(): E?
    fun peek(): E?
}