package queue

class AEDCircularQueueArray<E>(capacity: Int) : AEDCircularQueue<E> {
    private val elements = arrayOfNulls<Any?>(capacity) as Array<E?>
    private var head = 0
    private var tail = 0
    private var size = 0

    override fun isEmpty() = size == 0

    override fun enqueue(element: E) {
        if (size != elements.size) {
            elements[tail] = element
            tail = (tail + 1) % elements.size
            size++
        }
    }

    override fun dequeue() =
        if (isEmpty()) null
        else {
            val element = elements[head]
            head = (head + 1) % elements.size
            size--
            element
        }

    override fun peek() =
        if (isEmpty()) null else elements[head]
}