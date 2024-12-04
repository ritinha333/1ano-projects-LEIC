
fun selectionSort(table: IntArray, left: Int, right: Int) {
    for (i in left..right) {
        var min = i
        for (j in i + 1..right) if (table[j] < table[min]) min = j
        exchange(table, i , min)
    }
}

 