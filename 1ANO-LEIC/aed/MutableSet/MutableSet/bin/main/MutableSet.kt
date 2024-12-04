
interface MutableSet<K>: Iterable<MutableSet.MutableEntry<K>> {
    interface MutableEntry<K> {
        val key: K
    }
    val size: Int
    fun isEmpty(): Boolean
    fun contains(key: K): Boolean
    fun add(key: K): Boolean
    fun remove(key: K): Boolean
}