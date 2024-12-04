
//first version
fun countPairsThatSumN1(v: IntArray, l: Int, r: Int, s: Int):Int {
    if(v.isEmpty() || l == r) return 0
    var counter = 0

    for (i in l..r) {
        val value = v[l] + v [i]
        if (value == s && v[l] != v[i]) counter++
    }
    counter +=  countPairsThatSumN1(v,l+1, r,s)
    return counter
}

//second version
fun countPairsThatSumN2(v: IntArray, l: Int, r: Int, s: Int):Int {
    var left = l
    var right = r
    var counter = 0
    var i = 0
    if(v.isEmpty() || l == r) return 0

    while(i in left..right){
        val value = v[left] + v[i]
        if(value == s && v[l] != v[i]) {
            counter++
            i++
        }
        else i++

        if(i == right) {
            left ++
            i = left + 1
        }

        if(left == right) {
            print(counter)
            return counter
        }

    }
    print(counter)
    return counter

}

//third version = versão final
fun countPairsThatSumN(v: IntArray, l: Int, r: Int, s: Int):Int {
    var left = l
    var counter = 0
    if (v.isEmpty() || l == r) return 0

    while (left < r) {
        for (i in left + 1..r) {
            val value = v[left] + v[i]
            if (value == s && v[l] != v[i]) counter++
        }
        left++
    }
    return counter
}