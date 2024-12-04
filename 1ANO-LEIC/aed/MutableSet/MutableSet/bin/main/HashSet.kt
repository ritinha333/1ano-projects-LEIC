import java.util.NoSuchElementException

class HashSet<K>: MutableSet<K>  {

    private class Node<K>(k: K) : MutableSet.MutableEntry<K> {
        override var key: K = k
        var next: Node<K>? = null
        var previous: Node<K>? = null
    }

    private var table: Array<Node<K>?>
    private var dimTable = 0 // M dimensão da tabela
    override var size = 0    // N chaves

    constructor() {
        table = arrayOfNulls<Node<K>?>(11)  
        dimTable = table.size
    }

    constructor(dim: Int) {
        table = arrayOfNulls<Node<K>?>(dim)
        dimTable = dim
    }

    private fun hash(key: K): Int {
        var idx = key.hashCode() % dimTable
        if (idx < 0) idx += dimTable
        return idx
    }

    override fun isEmpty() = size == 0

    override fun contains(key: K): Boolean {
        val idx = hash(key)
        var curr = table[idx]
        while (curr != null) {
            if (key != null && key.equals(curr.key)) return true
            curr = curr.next
        }
        return false
    }

    override fun add(key: K): Boolean {
        if (contains(key)) return false
        if (size.toDouble() / dimTable >= 0.75) resize()
        val idx = hash(key)
        val node = Node<K>(key)
        node.next = table[idx]
        table[idx]?.let { t -> t.previous = node }
        table[idx] = node
        size++
        return true
    }

    private fun resize() {
        //Aumentar a dimensão da tabela e recalcular a posição dos elementos na nova tabela.
        dimTable *= 2
        val newTable = arrayOfNulls<Node<K>?>(dimTable)
        for (i in table.indices) {
            var curr = table[i];
            while (curr != null) {
                table[i] = table[i]?.next
                val idx = hash(curr.key)
                curr.next = newTable[idx]
                newTable[idx]?.let { nt -> nt.previous = curr }
                newTable[idx] = curr
                curr.previous = null
                curr = table[i]
            }
        }
        table = newTable
    }

    override fun remove(key: K): Boolean {
        val idx = hash(key)
        var curr: Node<K>? = table[idx]
        while (curr != null) {
            if (key == curr.key) {
                var node = curr
                if (node.previous != null)
                    node.previous?.let { np -> np.next = node.next }
                else table[idx] = node.next
                node.next?.let { nn -> nn.previous = node.previous }
                size--
                return true
            }
            else curr = curr.next
        }
        return false
    }

    private inner class MyIterator: Iterator<MutableSet.MutableEntry<K>> {
        var currIdx = -1;
        var currNode: Node<K>? = null
        var list: Node<K>? = null

        override fun hasNext(): Boolean {
            if (currNode != null) return true
            while (currIdx < dimTable) {
                if (list == null) {
                    currIdx++
                    if (currIdx < dimTable) list = table[currIdx]
                } else {
                    currNode = list
                    list?.let { l -> list = l.next }
                    return true
                }
            }
            return false;
        }

        override fun next(): MutableSet.MutableEntry<K> {
            if (!hasNext()) throw NoSuchElementException()
            val aux = currNode
            currNode = null
            return aux ?: Any() as MutableSet.MutableEntry<K>
        }
    }

    override fun iterator(): Iterator<MutableSet.MutableEntry<K>> = MyIterator()
}