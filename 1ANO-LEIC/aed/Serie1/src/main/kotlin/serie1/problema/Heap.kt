package com.example.heap
import com.example.heap.*
import serie1.problema.Par

fun parent(i: Int) = (i - 1) / 2

fun left(i: Int) = 2 * i + 1

fun right(i: Int) = 2 * i + 2

fun maxHeapify(h: IntArray, i: Int, n: Int, cmp:(a: Int, b: Int) -> Int) {
    var largest= i
    val l = left(i)
    val r = right(i)
    if (l < n && cmp(h[l], h[i]) > 0) largest = l
    if (r < n && cmp(h[r], h[largest]) > 0) largest = r
    if (largest != i) {
        exchange(h, i, largest)
        maxHeapify(h, largest, n, cmp)
    }
}

fun exchange(h: IntArray, i: Int, j: Int) {
    val tmp = h[i]
    h[i] = h[j]
    h[j] = tmp
}

fun exchangeLL(h: Array<Par>, i: Int, j: Int) {
    val tmp = h[i]
    h[i] = h[j]
    h[j] = tmp
}
fun buildMaxHeap(h: IntArray, n: Int, cmp:(Int, Int) -> Int) {
    for (i in n / 2 - 1 downTo 0)
        maxHeapify(h, i, n, cmp)
}

val compare = {a: Int, b: Int -> a - b}

fun buildMinHeapL(h: Array<Par>, n: Int, cmp:(Par, Par) -> Int) {
    for (i in n / 2 - 1 downTo 0)
        minHeapifyL(h, i, n, cmp)
}

fun minHeapifyL(h: Array<Par>, i: Int, n: Int, cmp:(Par, Par) -> Int) {
    var lowest= i
    val l = left(i)
    val r = right(i)
    if (l < n && cmp(h[l], h[i]) >= 0) lowest = l
    if (r < n && cmp(h[r], h[lowest]) >= 0) lowest = r
    if (lowest != i) {
        exchangeLL(h, i, lowest)
        minHeapifyL(h, lowest, n, cmp)
    }
}




