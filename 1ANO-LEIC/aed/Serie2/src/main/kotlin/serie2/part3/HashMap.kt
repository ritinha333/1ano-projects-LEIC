package serie2.part3

import java.util.NoSuchElementException

/**
 *
 * Abstract Data Type called AEDHashMap that implements a HashMap based on the implementation described in the
 * interface MutableMap<K, V>
 *
 * The methods to be implemented:
 *     val size: Int
 *     val capacity: Int
 *     operator fun get(key: K): V?
 *     fun put(key: K, value: V): V?
 *
 * The interface MutableEntry<K, V>:
 *      val key: K
 *      var value: V
 *      fun setValue(newValue: V): V
 *
 * The ADT parameters are:
 * @param initialCapacity That indicates the intial capacity of the HashTable
 * @param loadFactor That indicates the maximum size of the Linked Lists so that the data structure keeps its efficiency
 * @return A HashMap based on the interface MutableMap<K, V>
 *
 */

class AEDHashMap<K, V>(initialCapacity: Int = 16, private val loadFactor: Float = 0.75f) : MutableMap<K, V> {

    /**
     * Initialization of the different variables needed throughout the implementation of the HashMap
     */
    override var size: Int = 0
    private var table: Array<HashNode<K, V>?> = arrayOfNulls(initialCapacity)
    override var capacity: Int = table.size


    //: MutableMap<K, V> {
    class HashNode<K, V>(
        override val key: K, override var value: V, var next: HashNode<K, V>? = null
    ) :
        MutableMap.MutableEntry<K, V> {
        override fun setValue(newValue: V): V {
            val oldValue = value
            value = newValue
            return oldValue
        }
    }


    /**
     *  Gives a certain key an address inside the HashTable
     *
     *  @param key The key that is going to receive an address
     *  @return The index of the address for the key
     */

    private fun hashFunction(key: K): Int {
        var idx = key.hashCode() % table.size
        if (idx < 0) idx += table.size
        return idx
    }

    /**
     * Get the element of the hashTable
     *
     * @param key The key to look for
     * @return Returns the value associated with the key passed as parameter
     */

    override operator fun get(key: K): V? {
        val idx = hashFunction(key)
        capacity = table.size
        return table[idx]?.value
    }

    /**
     * Gets the keys and values (puts them in a HashMap) of the HashNodes that are in the HashTable
     */

    val keys: Map<K, V>
        get() {
            val keyMap = mutableMapOf<K, V>()
            for (node in table) {
                var current = node
                while (current != null) {
                    keyMap.put(current.key, current.value)
                    current = current.next
                }
            }
            return keyMap
        }

    /**
     * Implementation of the iterator, by defining the Iterator class with the methods
     * hasNext() and next()
     *
     * Method hasNext()
     * @return a boolean informing if there's a element in the next position
     *
     * Method next()
     * @return the current node that can have a Key - Value association, or it can be null
     */

    private inner class MyIterator : Iterator<MutableMap.MutableEntry<K, V>> {
        var currIdx = -1
        var currNode: HashNode<K, V>? = null
        var list: HashNode<K, V>? = null

        override fun hasNext(): Boolean {
            if (currNode != null) return true
            while (currIdx < capacity) {
                if (list == null) {
                    currIdx++
                    if (currIdx < capacity) list = table[currIdx]
                } else {
                    currNode = list
                    list?.let { l -> list = l.next }
                    return true
                }
            }
            return false
        }

        override fun next(): MutableMap.MutableEntry<K, V> {
            if (!hasNext()) throw NoSuchElementException()
            val aux = currNode
            currNode = null
            return aux ?: Any() as MutableMap.MutableEntry<K, V>
        }
    }

    /**
     *
     * Instance that creates an iterator. This iterator will in this specification iterate over MutableEntry elements
     * MutableEntry Interface is a Key - Value association, that have the properties key, value and a function setValue
     * that indicates the next value in the linked list in case od collisions
     *
     */

    override operator fun iterator(): Iterator<MutableMap.MutableEntry<K, V>> = MyIterator()

    /**
     * Adds an element to the HashTable
     *
     * @param key The key of the HashNode to be added
     * @param value The value of the key of the HashNode to be added
     * @return The previous value associated with the key or null if it's the first element to be added to that node
     */

    override fun put(key: K, Value: V): V? {
        needToExpand()                      //verifica se pode expandir
        val idx = hashFunction(key)         // calcular o index para a key - o valor de hash e cosnequenemtne o idx para a key
        val node = contains(key) // verificar se a key ja existe
        if (node != null) {
            val oldValue = node.value
            node.value = Value
            return oldValue
        } else {
            val newNode = HashNode(key, Value)
            newNode.next = table[idx] // colocar ao inicio
            table[idx] = newNode // atualizar na tabela
            size++  // incrementar o tamanho
            capacity = table.size
            return null
        }
    }


    /**
     * Checks depending on the index of the key, if a certain key already exists in a node of the HashTable
     *
     * @param key The key to search in the HashTable elements
     * @return If the key is found in the HashTable it returns the HashNode, if it doesn't it returns null
     */

    fun contains(key: K): HashNode<K, V>? {
        val idx = hashFunction(key) // calcular o valor de hash e cosnequenemtne o idx para a key
        var cur = table[idx] // ir buscar o node que esta na posicao idx
        while (cur != null) {
            if (cur.key == key && key != null) return cur // verificar se a key é igual a key do node
            cur = cur.next // passar para o proximo node
        }
        return null
    }

    /**
     * Checks if the load factor is the same or higher than the load factor passed in the class AEDHashMap<K, V>
     * If it is, then it'll call the method expand() to expand/resize the size of the HashTable.
     */

    private fun needToExpand() {
        if ((size.toDouble() / table.size) >= loadFactor)
            expand()
    }

    /**
     *
     * When called, this method expands the size of the HashTable, transferring the current data (by applying again the
     * hashFunction) to the new HashTable (the newTable has double the size of elements to be populated)
     *
     */

    private fun expand() {
        val newtable = arrayOfNulls<HashNode<K, V>>(table.size * 2)
        for (node in table) {
            var cur = node
            while (cur != null) {
                val idx = hashFunction(cur.key) // calculamos o novo index a partir do hash do proprio node
                val next = cur.next           // guardamos o next node
                cur.next = newtable[idx]      // o next do current node passa a ser o node que estava na posicao idx
                newtable[idx] = cur          // o node que estava na posicao idx passa a ser o current node
                cur = next             // o current node passa a ser o next node
            }
        }
        capacity = table.size
        table = newtable
    }

}