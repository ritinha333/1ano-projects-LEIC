
fun mergeSort(table: IntArray, left: Int, right: Int) {
    if (left < right) {
        val mid = (right + left)/ 2
        val tableLeft = IntArray(mid - left + 1)
        val tableRight = IntArray(right - mid)
        //divide os elementos de table por left e right
        divide(table, tableLeft, tableRight, left, mid, right)
        mergeSort(tableLeft, 0, mid - left) //ordena left
        mergeSort(tableRight, 0, right - mid - 1) //ordena right
        merge(table, tableLeft, tableRight, left, mid, right)
        // junta ambas as metades em table, ordenando-as
    }
}
 
fun divide(t: IntArray, tLeft: IntArray, tRight: IntArray, left: Int, mid: Int, right: Int) {
    var i = 0
    var j = 0
    for (k in left..mid)
        tLeft[i++] = t[k]
    for (k in mid + 1..right)
        tRight[j++] = t[k]
}

fun merge(t: IntArray, tLeft: IntArray, tRight: IntArray, left: Int, mid: Int, right: Int) {
    var i = 0
    var j = 0
    var k = left
    while (i < tLeft.size && j < tRight.size)
        if (tLeft[i] <= tRight[j])
            t[k++] = tLeft[i++]
        else t[k++] = tRight[j++]
    while (i < tLeft.size)   
        t[k++] = tLeft[i++]
    while (j < tRight.size)
        t[k++] = tRight[j++]
}
