package problem

import graphCollections.GraphStructure
import java.io.File
import kotlin.system.measureTimeMillis

fun deBruijnGraph (k: Int, filePath: String, output: String): GraphStructure<String> {
        val graph = GraphStructure<String>()
        val fileName = File(filePath)
        val arrayNuc = fileName.readLines()

        for (kmers in arrayNuc) {

            val prefix = kmers.substring(0, k - 1)
            val sufix = kmers.substring(1, k)

            graph.addVertex(prefix)
            graph.addVertex(sufix)  // "os prefixos e sufixos, de dimensao k-1, de cada k-mer correspondem aos noos do grafo."

            graph.addEdge(prefix, sufix)   // "cada k-mer corresponde a uma aresta do grafo"
        }
        val outputfile = File(output)
        outputfile.writeText("") // isto é utilizado para deixar o ficheiro em branco antes de vpoltar a apresentar os
        for (vertex in graph) {
            outputfile.appendText("${vertex.id} = ${vertex.getAdjacencies()} \n")
        }

        return graph

}

fun printDeBruijnGraph(graph: GraphStructure<String>) {
    for (vertex in graph) {
        println("${vertex.id} = ${vertex.getAdjacencies()}")
    }
}

/**
 * Implementa o algoritmo de Hierholzer para encontrar um percurso euleriano em um grafo.
 *
 * @param graph A estrutura do grafo representando os vértices e arestas.
 * @return Uma lista de strings representando o percurso euleriano.
 */

fun findEulerianPath(graph: GraphStructure<String>): List<String> {

        // Lista que armazenará o percurso euleriano final
        val eulerianPath = mutableListOf<String>()

        // Pilha utilizada para manter o controle dos vértices durante a construção do percurso
        val stack = mutableListOf<String>()

        // Seleciona um vértice inicial arbitrário a partir do grafo
        val initialVertex = graph.iterator().next().id

        // Adiciona o vértice inicial à pilha
        stack.add(initialVertex)

        // Loop principal do algoritmo que continua até que a pilha esteja vazia
        while (stack.isNotEmpty()) {
            // Obtém o vértice no topo da pilha (o último elemento adicionado)

            val u = stack.last()
            // Obtém o objeto vértice correspondente a 'u' no grafo
            val vertex = graph.getVertex(u)
            // Verifica se o vértice tem arestas não visitadas
            if (vertex != null && vertex.getAdjacencies().isNotEmpty()) {
                // Se houver arestas não visitadas, remove a primeira aresta e empilha o vértice adjacente
                val w = vertex.getAdjacencies().removeAt(vertex.getAdjacencies().size - 1)
                stack.add(w)
            } else {
                // Se não houver arestas não visitadas, remove 'u' da pilha e adiciona à lista do percurso euleriano
                stack.removeAt(stack.size - 1)
                eulerianPath.add(u)
            }
        }

    // Retorna o percurso euleriano na ordem correta, invertendo a lista
        return eulerianPath.reversed()
    }



fun main (){
    val time = measureTimeMillis {
        val graph =
            deBruijnGraph(3, "src/main/kotlin/ficheiros/3MersVibrioCholerae.txt", "src/main/kotlin/ficheiros/Output.txt")


    val eulerianPath = findEulerianPath(graph)
    println("\nEulerian Path: ${eulerianPath.joinToString(" -> ")}\n")
    }
    println("Time $time ms")
}
