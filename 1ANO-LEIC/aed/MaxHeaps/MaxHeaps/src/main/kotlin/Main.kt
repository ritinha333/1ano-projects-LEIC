fun main(){
    val array= intArrayOf(2, 7, 8, 1, 3, 8, 3, 6, 9, 10, 3, 12)
    val compare = {a: Int, b: Int ->  a - b}
    buildMaxHeap(array, array.size, compare)
    println("Max-heap = ${array.asList()}")
    array[8] = 14
    heapIncreaseKey(array, 8, array.size, compare)
    println("Max-heap after increase key(9 -> 14) = ${array.asList()}")
    heapSort(array,array.size, compare)
    println("Sorted array = ${array.asList()}")
}