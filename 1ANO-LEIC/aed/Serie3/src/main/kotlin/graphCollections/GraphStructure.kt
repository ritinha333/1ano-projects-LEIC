package graphCollections


class GraphStructure<I>: Graph<I>{

    private var graph = HashMap<I, Graph.Vertex<I>?>()

    override var size: Int = graph.size

    class Vertex<I>(override val id: I): Graph.Vertex<I> {
        private val adj: MutableList<I> = mutableListOf()

        override fun getAdjacencies(): MutableList<I> = adj
    }

    /**
     * This method adds a Vertex to the graph
     *
     * @param id id of Vertex
     * @return A boolean saying if it was added or not
     */
    override fun addVertex(id: I): Boolean {
        var canAdd = false
        if(graph[id] == null) {
            graph[id] = Vertex(id)
            canAdd = true
            size++
        }
        return canAdd
    }

    /**
     * This method adds to the list of adjacencies the adjacency between the Vertex with the id1 and with the id
     *
     * @param id id of first Vertex
     * @param idAdj id of the second Vertex
     * @return Either the idAdj to be added or null
     */

    override fun addEdge(id: I, idAdj: I): I? {
        val vertex = getVertex(id)
        val adjVertex = getVertex(idAdj)
        if (vertex != null && adjVertex != null) {
            vertex.getAdjacencies().add(idAdj)
            return idAdj
        }
        return null
    }


    /**
     * This method gets a certain vertex depending on the id passed as parameter
     *
     * @param id id of the Vertex
     * @return The specified Vertex
     */


    override fun getVertex(id: I): Graph.Vertex<I>? = if(graph[id] == null) null else graph[id]

/*
    This method implements the iterator on the different Vertex's
 */
    override fun iterator(): Iterator<Graph.Vertex<I>> = graph.values.filterNotNull().iterator()
}
