//Colleagues version

/**
 * **Count Elements In Range**
 * @param v Int-array;
 * @param l left index of sub-array;
 * @param r right index of sub-array;
 * @param min minimum value of elements;
 * @param max maximum value of elements;
 * @return number of elements between min and max (min <= elem <= max) in index between l and r.
 */
fun countInRange(v: IntArray, l: Int, r: Int, min: Int, max: Int): Int {
    val firstIndex = findFirstIndex(v, l, r, min)           //  O(log n)
    val lastIndex = findLastIndex(v, l, r, max)             //  O(log n)
    if (firstIndex == -1 || lastIndex == -1) return 0       //  O(1);       Se algum dos índices não for encontrado, retornar 0
    return lastIndex - firstIndex + 1                       //  O(1);       Retorna o número de elementos dentro do intervalo
}                                                           //  Complexidade da função = O(log n)



/**
 * @param v Int-array;
 * @param l left index of sub-array;
 * @param r right index of sub-array;
 * @param target first element of sub-array that is between l and r;
 * @return *first* index where target is *first* placed.
**/
fun findFirstIndex(v: IntArray, l: Int, r: Int, target: Int): Int {
    var lowIdx = l                                          // O(1)
    var highIdx = r                                         // O(1)
    var result = -1                                         // O(1)
    while (lowIdx <= highIdx) {                             // O(log n)
        val midIdx = lowIdx + (highIdx - lowIdx) / 2        // O(1)
        if (v[midIdx] >= target) {                          // O(1)
            result = midIdx                                 // O(1)
            highIdx = midIdx - 1                            // O(1);    Reduz o intervalo de busca pela metade superior
        }
        else  lowIdx = midIdx + 1                           // O(1);    Reduz o intervalo de busca pela metade inferior
    }
    return result                                           // O(1)
}                                                           // Complexidade final = O(log n)



/**
 *  @param v Int-array;
 *  @param l left index of sub-array;
 *  @param r right index of sub-array;
 *  @param target last element of sub-array that is between l and r;
 *  @return *last* index where target is *last* placed
 **/
fun findLastIndex(v: IntArray, l: Int, r: Int, target: Int): Int {
    var lowIdx = l                                      // O(1)
    var highIdx = r                                     // O(1)
    var result = -1                                     // O(1)
    while (lowIdx <= highIdx) {                         // O(log n)
        val midIdx = lowIdx + (highIdx - lowIdx) / 2    // O(1)
        if (v[midIdx] <= target) {                      // O(1)
            result = midIdx                             // O(1)
            lowIdx = midIdx + 1                         // O(1);    Reduz o intervalo de busca pela metade inferior
        }
        else highIdx = midIdx - 1                       // O(1);    Reduz o intervalo de busca pela metade superior
    }
    return result                                       // O(1)
}                                                       // Complexidade final = O(log n)