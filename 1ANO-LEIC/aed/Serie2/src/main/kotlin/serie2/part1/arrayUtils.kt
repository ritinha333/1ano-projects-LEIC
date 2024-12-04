package serie2.part1

import stack.AEDStackArray
import serie2.*

/**
 * Depending on the n-th element, it's given its value
 *
 * @throws IllegalArgumentException If the array is empty
 * @throws IllegalArgumentException If the n-th value passes the boundaries of the array
 * @param a The array to search the n-th element
 * @param l The left limit of the array
 * @param r The right limit of the array
 * @param n The n-th element
 * @param comp The comparator function
 * @return The value of the n-th element
 */

fun <T> kElement(a: Array<T>, l:Int, r: Int, n:Int, comp: (T, T)-> Int ) : T {
    var right = r
    var left = l

    if(left > right) throw IllegalArgumentException("Array vazio")

    if(n - 1 > a.size || n - 1 < 0) throw IllegalArgumentException("N não pertence ao array ")

    var pivot = partition(a, l, r, comp)
    var nPos = n - 1

    // If the left parameter doesn't start in the 0 index, the n-th element needs to be adapted
    if(left != 0) nPos = left + n - 1

    while(true){
        if(pivot == nPos) break
        if(pivot < nPos) left = pivot + 1
        else right = pivot - 1

        pivot = partition(a, left, right, comp)
    }
    return a[pivot]
}



/**
 * After given an expression, returns the result
 * @throws IllegalArgumentException if expression isn't well wrote.
 * @throws NumberFormatException if pop of stack is null.
 * @throws ArithmeticException if the operation is '\' and the denominator is 0.
 * @param exp Expression expected to calculate.
 * @return 0 if expression is blank else the result of the expression.
 */

fun evaluateRPN(exp: String): Int {
    // retorna 0 se a expressão é vazia
    if (exp.isBlank()) return 0

    val operators = listOf("+", "*", "-", "/")
    val stack = AEDStackArray<Int>(exp.length)
    var stackSize = 0

    // transforma a string numa lista e remove espaços em branco
    val stringList = exp.split(' ').filter{ it.isNotEmpty()}

    for (i in stringList.indices){              // percorre todos os indices da lista
        if (stringList[i] in operators){        // verifica se algum elemento da lista é um operador
            // verifica se existe elementos suficientes para realizar a operação
            if (stackSize < 2) throw IllegalArgumentException("Expressão inválida")
            val operator = stringList[i]

            // b = stringList[i-1]
            val b = stack.pop() ?: throw NumberFormatException("Número Inválido")

            // a = stringList[i-2]
            val a = stack.pop() ?: throw NumberFormatException("Número Inválido")

            // introduz o resultado da operação guardando no stack
            stack.push(performOperation(a, b, operator[0]))
            stackSize--
        } else {
            // caso não seja um operando guarda o valor se não null no stack
            stack.push(stringList[i].toIntOrNull() ?: throw NumberFormatException("Operador Inválido"))
            stackSize++
        }

    }
    // como aqui as contas já foram efetuadas, o stack terá de ter tamanho 1 (o resultado só tem um elemento)
    if (stackSize != 1 ) throw IllegalArgumentException("Expressão inválida")
    // retornar o cálculo total -> ultimo valor do stack
    return stack.pop() ?: throw NumberFormatException("Número Inválido")
}



