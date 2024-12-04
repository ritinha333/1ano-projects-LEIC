
fun bubbleSort(table: IntArray, left: Int, right: Int) {
    var trocas = false
    for (i in left..right) {
        for (j in right downTo i + 1) if (table[j] < table[j - 1]) {
            exchange(table, j, j - 1)
            trocas = true
        }
        trocas = if (trocas) false else break
    }
}
 
/*
fun bubbleSortRecursive(arr: IntArray, left: Int, right: Int) {
    if (left == right) return
    var trocas = false
    for (j in right downTo left + 1) {
        if (arr[j] < arr[j - 1]) {
            exchange(arr, j, j - 1)
            trocas = true
        }
    }
    if (trocas) return
    bubbleSortRecursive(arr, left + 1, right);
}
 */



