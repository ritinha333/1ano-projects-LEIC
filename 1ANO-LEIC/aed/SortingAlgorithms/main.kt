import kotlin.time.Duration
import kotlin.time.ExperimentalTime
import kotlin.time.measureTime
import com.example.heap.exchange

const val SIZE = 100
const val NUMBER = SIZE / 1000
@ExperimentalTime

fun main() {
    val size = SIZE
    val unsortedTab = IntArray(size) { (0..size).random() }
    val partialSortedTab = unsortedTab.clone()
    var table = IntArray(size)
    // println(unsortedTab.toList())
 
    mergeSort(partialSortedTab, 2, partialSortedTab.size - 3)
    //println(partialSortedTab.toList())
    for (i in 1..NUMBER) {
        val n1 = (0..size-1).random()
        val n2 = (0..size-1).random()
        exchange(partialSortedTab, n1, n2)
    }
    //println(partialSortedTab.toList())

    table = partialSortedTab.clone()
    val elapsed1: Duration = measureTime {
        mergeSort(table, 0, table.size - 1)
    }
    println("Merge sort - partial sorted ($elapsed1)")
    table = unsortedTab.clone()
    val elapsed11: Duration = measureTime {
        mergeSort(table, 0, table.size - 1)
    }
    println("Merge sort - unsorted ($elapsed11)")
    println()

    table = partialSortedTab.clone()
    val elapsed444: Duration = measureTime {
        bubbleSort(table, 0, table.size - 1)
    }
    println("Bubble sort - partial sorted ($elapsed444)")

    table = partialSortedTab.clone()
    val elapsed2: Duration = measureTime {
        insertionSort(table, 0, table.size - 1)
    }
    println("Insertion sort - partial sorted ($elapsed2)")
    table = unsortedTab.clone()
    val elapsed22: Duration = measureTime {
        insertionSort(table, 0, table.size - 1)
    }
    println("Insertion sort - unsorted ($elapsed22)")
    println()

    table = partialSortedTab.clone()
    val elapsed3: Duration = measureTime {
        selectionSort(table, 0, table.size - 1)
    }
    println("Selection sort - partial sorted ($elapsed3)")
    table = unsortedTab.clone()
    val elapsed33: Duration = measureTime {
        selectionSort(table, 0, table.size - 1)
    }
    println("Selection sort - unsorted ($elapsed33)")
    println()

    table = partialSortedTab.clone()
    val elapsed4: Duration = measureTime {
        bubbleSort(table, 0, table.size - 1)
    }
    println("Bubble sort - partial sorted ($elapsed4)")
    table = unsortedTab.clone()
    val elapsed44: Duration = measureTime {
        bubbleSort(table, 0, table.size - 1)
    }
    println("Bubble sort - unsorted ($elapsed44)")

/*
    table = unsortedTab.clone()
    val elapsed7: Duration = measureTime {
        bubbleSortRecursive(table, 0, table.size - 1)
    }
    println("Bubble sort recursive ($elapsed7)")
*/
}

