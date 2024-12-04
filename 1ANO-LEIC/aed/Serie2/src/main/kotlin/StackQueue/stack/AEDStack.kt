package stack
interface AEDStack<E> {
    fun isEmpty(): Boolean
    fun push(element: E)
    fun pop(): E?
    fun peek(): E?
}