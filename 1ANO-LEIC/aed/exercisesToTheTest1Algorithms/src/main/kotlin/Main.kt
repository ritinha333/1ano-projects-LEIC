package org.example

fun sumGivesN(n: Int): IntArray{
    var l = 0
    var r = 1
    var sum = 0
    var arr = (n/4-1..n/2-1).map { it + 1 }.toIntArray()

    var resArr = ArrayList<IntRange>()

    while(l >= 0 && r < arr.size-1) {
        if (r == 1 || sum == 0) {
            val value = arr[l] + arr[r]
            sum = value
            if (value != n) r++
            else resArr += l..r//resArr += Pair(l,r)
        } else {
            if (sum < n && sum != 0) sum = sum + arr[r]
            if (sum == n) {
                resArr += l..r//resArr += Pair(l,r)
                break
            }
            r++
            if (sum > n) {
                l++
                r = l + 1
                sum = 0

            }
            if (r == arr.size - 1) {
                l++
                r = l + 1
            }
        }
    }
    var valueArr = arrayOf<Int>()
    for (value in resArr) valueArr += value.toList()
    return IntArray(valueArr.size) { arr[valueArr[it]] }
}

fun sumGivesN1(n: Int): List<IntRange> {
    val result = mutableListOf<IntRange>()
    var start = 1
    var end = 1
    var sum = 1

    while (start <= n / 2) {
        if (sum < n) {
            end++
            sum += end
        } else if (sum > n) {
            sum -= start
            start++
        } else {
            result.add(start..end)
            sum -= start
            start++
        }
    }
    return result
}

fun sumGivesN2 (n: Int){
    var i = 0
    var j = 1
    var arr = IntArray (n/2) {it + 1}
    var pair = Pair(0,0)
    var sum = 0

    while (j <= arr.size - 1){
        if(arr[i] + arr[j] < n && sum == 0){
            sum = arr[i] + arr[j]
            j++
        }
        else {
            sum += arr[j]
            j++
        }

        if(sum > n){
            i++
            j = i + 1
            sum = 0
        }
        else if(sum == n){
            pair = Pair(i,j - 1)
            break
        }
    }

    for (idx in pair.first..pair.second){
        println(arr[idx])
    }
}
fun identity(ar : IntArray, l: Int, r: Int): Int{
    for(i in 0..ar.size-1){
        if(ar[i]==i) return i
    }
    return -1
}

fun Array<Int>.isSubArray(v: Array<Int>): Boolean{
    for(i in 0.. v.size - 1){
        if(v[i] != this[i]) return false
    }
    return true}

fun printAll(ar: IntArray){
    var i = 0
    var j = 0
    var arrFinal = intArrayOf()

    while(i >= 0 && j <= ar.size - 1){
        if(ar[i] > ar[j]) arrFinal += ar[i]
        else if(ar[i] < ar[j] && arrFinal.size != 0) remove(i, arrFinal)
        if(j == ar.size - 1){
            i++
            j = i + 1
        }
        if(i == j && i == ar.size - 1){
            arrFinal += ar[i]
            break
        } else j++
    }

    for(i in arrFinal){
        if(arrFinal[i] != -1)
        println(i)
    }
}

fun remove(i: Int, arr: IntArray):List<Int>{
    return arr.map { if(arr[it] != arr[i]) it else -1 }
}

//complexidade O(n) maravilhoso e está certa (100%)
fun largestPalindromeSize(sequence: String, pos: Int): Int{
    var i = pos - 1
    var j = pos + 1
    var count = 1

    if(pos > sequence.length - 1 || pos < 0 || sequence.length == 0) return 0
    while(i >= 0 && j <= sequence.length - 1){
        if(sequence[i] == sequence[j]) {
            count += 2
            i--
            j++
        }
        else return 1

    }
    return count
}

//não está totalmente certo - linear !!! por isso ainda tinha alguns pontos (60%)
fun maxSubArrayWithSumLessThan_K(ar: IntArray, k: Int): Pair<Int, Int>{
    var i = 0
    var j = 0
    var finalPair = Pair(0,0)
    var sum1 = k

    if(ar.size == 0) return Pair(0, -1)
    if(ar.size == 1) return Pair(0, 0)

    while(j <= ar.size - 1) {
        val sum = ar[i] + ar[j]
        if (ar[i] > k || ar[j] > k) {
            i++
            j++
        }
        if (sum < k) {
            finalPair = Pair(i, j)
            sum1 = sum
            j++
        } else if (sum1 != k)
            sum1 = sum1 + ar[j]
        if (sum1 < k) {
            finalPair = Pair(i, j)
            j++
        }else {
            i++
            j++
        }
    }
    return finalPair
}

data class Interval (val init: Int, val end: Int)

fun findInterval (array: Array<Interval>, left: Int, right: Int, inter: Interval): Int{
    var left = left
    var right = right
    var pair = Pair(0,0)
    while (left <= right){
        if(array[left].init != inter.init){
            left++
        } else 1
    }
    return TODO()
}

fun counter(v: IntArray, k: Int, lower: Int, upper: Int): Pair<Int, Int>{
    var counterL = 0
    var counterU = 0

    for(i in 0..v.size - k) {
        var sum = 0
        for (j in i..i + k - 1) {
            sum += v[j]
        }

        if(sum < lower) counterL++
        else if(sum > upper) counterU++
    }
    return Pair(counterL, counterU)
}
//[1, 4, 3]
fun reverse(v: IntArray){
    var i = 0
    var j = v.size - 1

    while(i  <  j){             //primeira iteração
        val temp = v[i]         //temp = 1
        v[i] = v[j]             //posição 0 com o valor de 3
        v[j] = temp             //posição 2 com o valor 1
        i++                     // i = 1
        j--                     // j = 1
    }
    println(v.toList())
}

fun segment(v: IntArray, l: Int, r: Int, element: Int){
    var l = l
    var r = r

    while(l >= 0 && r <= v.size - 1){
        if(l == r) break
        if(v[l] < element) l++
        else if(v[r] < element){
            val temp = v[l]
            v[l] = v[r]
            v[r] = temp
            l++
            r--
        }
        else r--
    }
    println(v.toList())
}

var pair = Pair<Pair<Int, Int>, Int>(Pair(5,4), 3)
fun tests(){
    println(pair.first.first)
    println(pair.first.second)
    println(pair.second)
}

fun minAbsSum(ar: IntArray): Pair<Int, Int>?{
    var i = 0
    var j = ar.size - 1
    var pair = Pair<Pair<Int, Int>, Int>(Pair(0,0), 0)
    var count = 0

    while(i >= 0 && j <= ar.size - 1){
        var absI = ar[i]
        var absJ = ar[j]
        if(i == j) break
        if(ar[i] < 0) absI * (-1)
        if(ar[j] < 0) absJ * (-1)

        val value =  absI + absJ
        if(count == 0) count = value
        if(value > count) j--
        else{
            count = value
            pair = Pair(Pair(ar[i], ar[j]), count)
            i++
            j--
        }
    }
    return Pair(pair.first.first, pair.first.second)
}

fun findAll(ar: IntArray){
    var i = 0
    var j = ar.size - 1

    while (j <= ar.size - 1){
        if(i == ar.size - 1) break
        if(i == j){
            i++
            j = ar.size - 1
        }
        if(ar[i] < ar[j] || ar[i] < ar[j]) {
            println(ar[j])
            j--
        }
        else j--
    }

}

fun xpto2(x: Int, n: Int): Int{
    if(n == 0) return 1
    val xpto2 = xpto2(x, n/2)
    return if(n % 2 == 0) xpto2 * xpto2
    else xpto2 * xpto2
}

fun maxSortedSubArray(ar: Array<Int>): Pair<Int,Int>{
    var i = 0
    var j = 1
    var pair = Pair(Pair(0,0), 0)
    var size = 0
    if(ar.size == 0) return Pair(0, -1)
    while(j <= ar.size - 1){
        val sizeW = j - 1 - i + 1
        if(ar[i] < ar[j] && i + 1 != j && sizeW > size){
            pair = Pair(Pair(i, j - 1), sizeW)
            size = sizeW
            i = j
            j++
            println(pair)
        }
        else if(ar[i] < ar[j]) j++
            else{
                i++
                j++
            }
    }
    return Pair(pair.first.first, pair.first.second)
}

fun findInterval1(array: Array<Interval>, left: Int, right: Int, inter: Interval): Int{
    if(array.size == 0) return -1
    var i = 0
    var index = 0

    while(i in 0..array.size - 1){
        if(compare(array[i], inter) == 0){
            i = index
        }
        else if(compare(array[i], inter) < 0) i++
        if(i ==  array.size - 1 && index == 0){
            index =  -1
            break
        }
    }
    return index

}

fun compare(inter1: Interval, inter2: Interval): Int = if(inter1.init != inter2.init) inter1.init - inter2.init else inter1.end - inter2.end

fun ksmallest(heap: IntArray, k: Int): Int?{
    var num = 0
    if(heap.size ==  0) return null
    for(i in 0..heap.size - 1){
        if(k == heap[i]){
            num = heap[k]
            break
        } else num
    }
    return num
}

fun isShuffle(isShuffle: String, str1: String, str2: String): Boolean{
    var i0 = 0
    var i1 = 0
    var i2 = 0
    var boo = false
    if(isShuffle.length != str1.length + str2.length) return boo

    while(i0 in 0..isShuffle.length - 1){
        if(i0 == isShuffle.length - 1){
            boo = true
            break
        }
        if(str1[i1] == isShuffle[i0]){
            i1++
            i0++
        }
        else if(str2[i2] == isShuffle[i0]){
            i2++
            i0++
        }
        if(str1[i1] != isShuffle[i0] && str2[i2] != isShuffle[i0]) break
    }
    return boo
}

fun oi (ar: IntArray){
    println(arrayOf(Pair(Pair(0,0), 0)).toList())

}


//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
fun main() {
    /*val arr4 = intArrayOf(-1,-3,1,3,8,9)
    val arr1 = intArrayOf(10, 4, 6, 3, 5)
    println(sumGivesN1(24).toList())
    println(identity(arr4, 0,arr4.size - 1 ))
    println(printAll(arr1))
    println(largestPalindromeSize("anagrama", 1))
    val arr = intArrayOf(10, 7, 6, 1, 7, 1, 2, 3)
    println(maxSubArrayWithSumLessThan_K(arr, 7))
    var arr2 = intArrayOf(1, 4, 3)
    println(counter(arr2, 2, 3, 3))
    println(counter(arr2, 1, 3, 3))
    println("_.-------------------------------")
    println(arr2.toList())
    println(reverse(arr2))
    println("---------------------------------")
    val arrSegment = intArrayOf(1, 4, 6, 2, 3, 8)
    println(segment( arrSegment, 0, 4, 5))
    val arrMinAbsSum = intArrayOf(-6, -5, -3, 0, 2, 4, 9)
    println(minAbsSum(arrMinAbsSum))
    val arrFinal = intArrayOf(10, 4, 6, 3, 5)
    findAll(arrFinal)
    val arrMaxSorted = arrayOf(5, 1, 7, 1, 2, 5, 8, 1, 7, 9)
    println(maxSortedSubArray(arrMaxSorted))
    oi(arrFinal)*/
    /*val array = IntArray(12) { it + 1 }
    println(array.toList())*/
    sumGivesN2(24)
}
