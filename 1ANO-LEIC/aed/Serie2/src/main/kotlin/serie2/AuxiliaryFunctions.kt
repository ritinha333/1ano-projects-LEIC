package serie2

/**
 * Auxiliary Function for the kElement function
 * Depending on the array, it sorts the array the same way that is done in the QuickSort sorting algorithm but for
 * Abstract Data Types
 *
 * @param a The array to be sorted
 * @param left The left limit of the array
 * @param right The right limit of the array
 * @param compare The comparator function
 * @return The index of the pivot
 */

fun <T> partition(a: Array<T>, left: Int, right: Int, compare: (T, T) -> Int): Int {
    var i = left - 1
    var j = right
    val pivot = a[right]
    while (true) {
        while (i < right && compare(a[++i], pivot) <= 0);
        while (j > left && compare(a[--j], pivot) > 0);
        if (i >= j) break
        exchange(a, i, j)
    }
    exchange(a, i, right)
    return i
}

/**
 * Changes two elements of an array, in terms of their position
 *
 * @param a The array where the elements belong to
 * @param i The index i of one of the elements of the array
 * @param j The index j of one of the elements of the array
 */

fun <T> exchange(a: Array<T>, i: Int, j: Int) {
    val x = a[i]
    a[i] = a[j]
    a[j] = x
}

/**
 * Auxiliary Function for the EvaluateRPNTest function
 * Takes care of the arithmetic calculations made by the two operands
 *
 * @param a The operand a
 * @param b The operand b
 * @param operator The operator of the arithmetic calculation
 * @return If the operator is valid it returns an integer, which is the result of the calculation
 */

fun performOperation(a: Int, b: Int, operator: Char) = when (operator) {
    '+' -> a + b
    '-' -> a - b
    '*' -> a * b
    '/' -> if (b == 0) throw ArithmeticException("Operação impossível") else a / b
    else -> throw IllegalArgumentException("Operador Inválido")
}

