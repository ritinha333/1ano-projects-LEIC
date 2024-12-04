package stack

fun main() {
    val stk1 = AEDStackArray<String>(10)
    stk1.push("Ana")
    stk1.push("Maria")
    stk1.push("Rui")
    val element = stk1.pop()
    println("next element = $element")

    val stk2 = AEDStackArray<Int>(50)
    stk2.push(1)
    stk2.push(2)
    stk2.push(3)
    stk2.push(4)
    stk2.push(5)
    println("elements:")
    println("${stk2.pop()}")
    println("${stk2.pop()}")
    println("${stk2.pop()}")
    println("${stk2.pop()}")
    println("${stk2.pop()}")

    val stk3 = AEDStackArray<Pair<Int, String>>(20)
    stk3.push(Pair(1201, "Ana"))
    stk3.push(Pair(1202, "Rui"))
}
