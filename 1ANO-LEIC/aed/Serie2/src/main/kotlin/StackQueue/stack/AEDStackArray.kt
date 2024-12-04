package stack

class AEDStackArray<E>(capacity: Int) : AEDStack<E> {
    private val elements = arrayOfNulls<Any?>(capacity) as Array<E?>
    private var top = 0

    override fun isEmpty() = top == 0

    override fun push(element: E) {
        if (top != elements.size)
            elements[top++] = element
    }

    override fun pop() =
        if (isEmpty()) null
        else {
            val element = elements[top - 1]
            elements[--top] = null
            element
        }

    override fun peek() =
        if (isEmpty()) null else elements[top - 1]
}