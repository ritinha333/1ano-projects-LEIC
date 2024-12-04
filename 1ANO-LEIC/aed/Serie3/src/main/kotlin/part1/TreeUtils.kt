package part1

data class Node<E>(var item: E, var left:Node<E>?, var right:Node<E>?)

fun printIf( root:Node<Int>?, predicate: (Int) -> Boolean ):Int{
  var count = 0 // contador de elementos que satisfazem a condição
    fun decrescente(root: Node<Int>?){
        if(root != null){ // se o nó não for nulo para chegar até ao fim
            decrescente(root.right) // chama a função recursivamente para o nó da direita de forma a ser decrescente
            if(predicate(root.item)){ // se satisfaz o predicate incrementa e dá print
                println(root.item)
                count++
            }
            decrescente(root.left)  // chama a função recursivamente para o nó da esquerda dps de tratar da parte da direita
        }
    }
    decrescente(root)
    return count
} // talvez tente mudar, mas não há bem outra forma de fazer
 // recursivamente é o mais legivel e eficiente

/**
 * @return o número de elementos presentes na árvore binária de pesquisa com raíz root contidos no
 * intervalo fechado [min, max]. Assuma que não existem elementos repetidos na árvore.
 */
fun countBetween(root: Node<Int>?, a: Int, b: Int): Int {
    // Função auxiliar recursiva
    fun countInRange(node: Node<Int>?): Int{
        // Se o nó for nulo, retorna 0
        if (node == null) return 0
        // Inicialize o contador
        var count = 0
        // Se o valor do nó estiver dentro do intervalo [a, b], incrementa o contador
        if (node.item in a..b) count++
        // Se o valor do nó for maior que `a`, continua a busca na subárvore esquerda
        if (node.item > a) count += countInRange(node.left)
        // Se o valor do nó for menor que `b`, continua a busca na subárvore direita
        if (node.item < b) count += countInRange(node.right)
        return count
    }
    // Inicia a busca a partir da raiz
    return countInRange(root)
}

fun isChildrenSum(root:Node<Int>?):Boolean{
    var boo = false
    // Verifies if the tree is empty
    if(root == null) return true

    val leftChild = root.left
    val rightChild = root.right

    // When there's only one node that is the root
    if(leftChild == null && rightChild == null) return true

    // If one of the children is null
    if(leftChild != null){
        if(leftChild.item == root.item && rightChild == null) return true
    }
    else if(rightChild != null){
        if(rightChild.item == root.item) return true
        else return false
    }

    // Sums the children and verifies for each side of the table if they follow the rule
    if(leftChild!!.item + rightChild!!.item == root.item) {
        boo = true
        isChildrenSum(leftChild)
        isChildrenSum(rightChild)
    }
    return boo
}

//ola







