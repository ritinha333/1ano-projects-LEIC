package serie1.problema

import kotlin.math.*


/*
//Fila prioritária Q implementada através de um min-heap de dimensão fixa size; */
data class AEDPriorityQueue(val heap: IntArray,
                            var size:Int,
                            var cmp:(Int, Int) -> Int)

/* ISEMPTY, verifica se a Q está vazia */
fun AEDPriorityQueue.isEmpty() = size == 0

/* OFFER, adiciona um novo elemento a Q de dimensão size, organizado
segundo o critério de comparação; */
fun AEDPriorityQueue.offer(element: Int): Boolean {
    if (size == heap.size) return false
    heap[size] = element
    decreaseKey(size)
    size++
    return true
}

private fun AEDPriorityQueue.decreaseKey(i: Int) {
    var i = i
    while (i > 0 && cmp(heap[i], heap[parent(i)]) < 0) {
        exchange(i, parent(i))
        i = parent(i)
    }
}

/* PEEK, retorna o elemento de Q com mais prioritário; */
fun AEDPriorityQueue.peek() =
    if (size == 0) -1 else heap[0]

/* POLL remove e retorna o elemento de Q mais prioritário;*/
fun AEDPriorityQueue.poll(): Int {
    if (size == 0) return 0
    val element = heap[0]
    size--
    heap[0] = heap[size]
    heap[size] = 0//null
    minHeapify(0)
    return element
}

private fun AEDPriorityQueue.minHeapify(i: Int) {
    var smallest = i
    val l = left(i)
    val r = right(i)
    if (l < size && cmp(heap[l], heap[i]) < 0) smallest = l
    if (r < size && cmp(heap[r], heap[smallest]) < 0) smallest = r
    if (smallest != i) {
        exchange(i, smallest)
        minHeapify(smallest)
    }
}

private fun AEDPriorityQueue.exchange(i: Int, j: Int) {
    val x = heap[i]
    heap[i] =heap[j]
    heap[j] = x
}

fun getHeapHeight(n: Int): Int{
    if(n == 0) return 0
    return floor(log2(n.toDouble())).toInt()
}

private fun parent(i: Int) = (i - 1) / 2

private fun left(i: Int) = 2 * i + 1

private fun right(i: Int) = 2 * i + 2

