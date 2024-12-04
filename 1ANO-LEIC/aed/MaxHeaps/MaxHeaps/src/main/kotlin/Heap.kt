
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

fun heapIncreaseKey(h: IntArray, i: Int, n: Int, cmp:(Int, Int) -> Int) {
    var i = i
    while (i > 0 && cmp(h[i], h[parent(i)]) > 0) {
        exchange(h, i, parent(i))
        i = parent(i)
    }
}

fun exchange(h: IntArray, i: Int, j: Int) {
    val tmp = h[i]
    h[i] = h[j]
    h[j] = tmp
}

fun buildMaxHeap(h: IntArray, n: Int, cmp:(Int, Int) -> Int) {
    for (i in n / 2 - 1 downTo 0)
        maxHeapify(h, i, n, cmp)
}

fun heapSort(array: IntArray, n: Int, cmp:(Int, Int) -> Int) {
    buildMaxHeap(array, n, cmp)
    for (i in n - 1 downTo 1) {
        exchange(array, 0, i)
        maxHeapify(array, 0, i,cmp)
    }
}

