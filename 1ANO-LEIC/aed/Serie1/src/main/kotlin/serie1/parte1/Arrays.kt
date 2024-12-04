package serie1.parte1
import serie1.problema.*


fun binarySearch(a: IntArray, l: Int, r: Int, x: Int): Int{
    if (l>r) return 0
    else{
        val mid = (l+r)/2
        if(x == a[mid]) return mid
        return if (x<a[mid]) binarySearch(a,l,mid-1,x)
        else binarySearch(a,mid+1,r,x)
    }
}


/**
 * This function iterates over an array of integers and gives the pairs of numbers that added are the value s (parameter)
 * Complexity: O(n)
 *
 * @param v is the array of integers
 * @param l is first index in the left of the array v
 * @param r is the last index in the right of the array v
 * @param s is the value that wants to be searched (by the adding two numbers)
 * @return integer that gives the number of pairs that give the value s
 */

fun countPairsThatSumN(v: IntArray, l: Int, r: Int, s: Int): Int {
    var counter = 0
    var i = l
    var j = r

    if (v.isEmpty() || l >= r) return 0

    while (i in 0..j) {
        if (i == j) break
        val value = v[i] + v[j]
        if (value == s && v[i] != v[j]) {
            counter++
            j--
        }
        if (value > s) j--
        else if (value < s) i++

    }
    return counter
}
//          solução 1 (complexidade O(n^2logn))

fun countEachThreeElementsThatSumN(v: IntArray, l: Int, r: Int, s: Int): Int {
    var count = 0
    val n = r - l + 1
    val sortedArray = v.copyOfRange(l, r + 1).sortedArray() // Ordenando o sub-array
    for (i in 0 until n - 2) {
        for (j in i + 1 until n - 1) {
            val complement = s - sortedArray[i] - sortedArray[j]
            if (binarySearch(sortedArray, j + 1, n - 1, complement) > j) {
                count++
            }
        }
    }
    return count
}

fun main() {
    countEachThreeElementsThatSumN(intArrayOf(5, 1, 3, 4, 2, 6), 0, 5, 10)
}

                 /* solução 2 (complexidade O(n^2))
fun countEachThreeElementsThatSumN(v: IntArray, l: Int, r: Int, s: Int): Int {
    var count = 0
    if (r - l < 2) return 0
    mergeSort(v, l, r)
    for (i in l..<r) {
        val pairSum = s - v[i]
        count += countPairsThatSumN(v, i + 1, r, pairSum)
    }
    return count
}
*/

/*                  solução 3 (complexidade O(n^3), certo mas n utiliza a funçáo do countpairs )
fun countEachThreeElementsThatSumN(v: IntArray, l: Int, r: Int, s: Int): Int {
    if (s == 0 || r - l < 2) return 0
    var count = 0

    for (i in l..<r) {
        for (j in i + 1..<r) {
            for (k in j + 1..r) {
                if (v[i] + v[j] + v[k] == s) {
                    count++
                }
            }
        }
    }
    return count
}
*/

/*
Realize a função:
fun countInRange(v: IntArray, l: Int, r: Int, min: Int, max: Int): Int
que, dado o sub-array(v,l,r) de inteiros, ordenado de modo crescente, com a possibilidade de ocorrerem repetidos,
retorna o número de elementos cujos valores estão compreendidos entre min e max, inclusive. A solução deverá ter
complexidade O(log n) ), em que n = r-l+1 é o número de elementos do sub-array.

*/

fun countInRange1(v: IntArray, l: Int, r: Int, min: Int, max: Int): Int {
    var count = 0
    for(i in l..r){
        if (v[i] in min..max) {
            count++
        }
    }
    return count
}           // complexidade = O(n)

/**
 * ***Count Elements In Range***
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
 * @return **first** index where target is **first** placed.
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
        } else lowIdx = midIdx + 1                           // O(1);    Reduz o intervalo de busca pela metade inferior
    }
    return result                                           // O(1)
}                                                           // Complexidade final = O(log n)

/**
 *  @param v Int-array;
 *  @param l left index of sub-array;
 *  @param r right index of sub-array;
 *  @param target last element of sub-array that is between l and r;
 *  @return **last** index where target is **last** placed
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
        } else highIdx = midIdx - 1                       // O(1);    Reduz o intervalo de busca pela metade superior
    }
    return result                                       // O(1)
}                                                       // Complexidade final = O(log n)


/*
2.1. Indique a complexidade da mesma no pior caso, em função de n. Indique a equação de recorrência e resolva-a.
2.2. Será possível diminuir a complexidade desta função, mantendo a mesma funcionalidade? Justifique.
    Sim, as
 */
fun xpto2(x: Int, n: Int): Int {
    return if (n == 0) 1
    else if (n%2 == 0) xpto2(x, n/2) * xpto2(x, n/2)
    else xpto2(x, n/2) * xpto2(x, n/2) * x
}

