
fun insertionSort(table: IntArray, left: Int, right: Int) {
    for (i in left + 1..right) {
        val curr = table[i]
        var j = i
        while (j > left && curr < table[j - 1]) {
            table[j] = table[j - 1]
            j--
        }
        table[j] = curr
    }
}
 