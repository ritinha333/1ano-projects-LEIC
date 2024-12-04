
fun main() {
    // val hashT: MutableSet<String> = MutableHashSet<String>()
    val hashT = HashSet<String>()
    println("IsEmpy = ${hashT.isEmpty()}")
    hashT.add("Carol")
    hashT.add("Luis")
    hashT.add("Ermelinda")
    hashT.add("Esteves")
    hashT.add("Ana")
    hashT.add("Carol")
    println("Size = ${hashT.size}")
    println("Contains(Ermelinda) = ${hashT.contains("Ermelinda")}")
    println("Remove(Ermelinda) = ${hashT.remove("Ermelinda")}")
    println("Contains(Ermelinda) = ${hashT.contains("Ermelinda")}")
    hashT.add("Rui")
    hashT.add("Tiago")
    hashT.add("Julia")
    hashT.add("Teresa")
    hashT.add("Carolina")
    hashT.add("Susana")
    hashT.add("Pedro")
    hashT.add("Ricardo")
    hashT.add("César")
    hashT.add("Pilar")
    hashT.add("Manuela")
    hashT.add("Beatriz")
    println("List of names:")

    println("Iterando no hashset")
    for (h in hashT) {
        println(h.key)
    }
    println()

    println("Iterando no hashset usando explicitamente o iterador")
    val it = hashT.iterator()
    while (it.hasNext())
        println(it.next().key)
    println()

    println("Size = ${hashT.size}")
}
