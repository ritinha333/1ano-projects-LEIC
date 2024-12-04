package serie2.part2

class Node<T> (
    var value: T = Any() as T,
    var next: Node<T>? = null,
    var previous: Node<T>? = null) {
}

fun plusOnTwoLists(list1: Node<Int>, list2: Node<Int>){
    var carry = 0
    var curr1 = list1.previous // último elemento de list1
    var curr2 = list2.previous // último elemento de list2

    // Percorre as listas da direita para a esquerda
    while (curr1 !== list1 && curr2 !== list2) {
        val sum = (curr1?.value ?: 0) + (curr2?.value ?: 0) + carry
        curr1?.value = sum % 10 // Atualiza o valor do nó em list1
        carry = sum / 10 // Atualiza o carry
        curr1 = curr1?.previous // Move para o próximo elemento de list1
        curr2 = curr2?.previous // Move para o próximo elemento de list2
    }

    // Se list2 tem mais elementos que list1, continua a soma
    while (curr2 !== list2) {
        val sum = (curr2?.value ?: 0) + carry
        curr1 = Node(sum % 10, curr1, null) // Cria um novo nó em list1
        curr1?.next?.previous = curr1 // Atualiza o nó seguinte
        carry = sum / 10 // Atualiza o carry
        curr2 = curr2?.previous // Move para o próximo elemento de list2
    }

    // Se houver carry restante, adicione um novo nó com carry em list1
    if (carry > 0) {
        while (curr1 !== list1 && carry > 0) {
            val sum = (curr1?.value ?: 0) + carry
            curr1?.value = sum % 10
            carry = sum / 10
            curr1 = curr1?.previous
        }
        if (carry > 0) {
            val newNode = Node(carry, curr1, null) // Cria um novo nó em list1
            curr1?.previous = newNode // Atualiza o nó anterior em list1
        }
    }
}

/**
 * Depending on the doubly linked list, it will sort it, and remove the elements that shouldn't be in the list
 *
 * @param list The doubly linked list to be analysed
 * @param cmp The comparator function
 * @return Doesn't return anything, just changes the list in memory
 */

fun <T> removeNonIncresing(list: Node<T>, cmp: Comparator<T>) {

    // Gets the head of the list
    var node = list.next
    var savedValue = node?.value

    while (node != null) {
        if (node.previous != null && node.next != null) {

            // Removes the element connecting the current one to the next
            if (cmp.compare(node.value, node.previous?.value) <= 0) {
                node.previous?.next = node.next
                node.next?.previous = node.previous
                node = node.next
            }
            // If the current value is higher than the previous one, node.next
            if(cmp.compare(node?.value, node?.previous?.value) > 0) node = node?.next
            else
                if (savedValue == node?.value) break
                else savedValue = node?.value
        }
        else{
            if(node.previous != null){
                if (cmp.compare(node.value, node.previous?.value) <= 0) {
                    node.previous?.next = node.next
                    node.next?.previous = node.previous
                }
            }
            break
        }
    }
}

