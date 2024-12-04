

fun upperBound(a: IntArray, l: Int, r: Int, max: Int):Int{
    val mid = (l + r)/2
    if(l > r) return if(max > a[mid]) mid else mid - 1
    return if(max >= a[mid]) upperBound(a, mid+1, r, max)
        else upperBound(a, l, mid-1, max)
}
//not finished
fun lowerBound(a: IntArray, l: Int, r: Int, min: Int): Int{
    val mid = (l + r) / 2
    if (l > r) return if(min < a[mid]) mid - 1 else a[mid + 1]
    return if(min <= a[mid]) return lowerBound(a, l, mid-1, 5)
    else lowerBound(a, mid + 1, r, 5)
}
fun main() {
    val arr:IntArray = intArrayOf(2,5,7,7,8,8,8,11)
    println(upperBound(arr, 0, 7, 10))
    println(lowerBound(arr,0,7,5))
}
val arr = arrayOf(2,5,7,7,8,8,8,11)
upperBound(arr, arr[0], arr[arr.size - 1], 10)