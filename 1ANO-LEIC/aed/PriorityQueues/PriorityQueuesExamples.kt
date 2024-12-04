
//https://www.bezkoder.com/kotlin-priority-queue/

package com.bezkoder.kotlin.priorityqueue

import java.util.PriorityQueue

fun priorityQueueWithInt() {
  val nums: PriorityQueue<Int> = PriorityQueue<Int>()

  // Add items (enqueue)
  nums.add(800)
  nums.add(50)
  nums.add(200)
  nums.add(550)

  println("peek: " + nums.peek())
  
  // Remove items (dequeue)
  while (!nums.isEmpty()) {
    println(nums.remove())
  }
}


fun priorityQueueWithString() {
  val names: PriorityQueue<String> = PriorityQueue<String>()

  // Add items (enqueue)
  names.add("Jack")
  names.add("Alex")
  names.add("Katherin")
  names.add("Watson")
  names.add("Jason")
  names.add("Hector")
  
  println("peek: " + names.peek())

  // Remove items (dequeue)
  while (!names.isEmpty()) {
    println(names.remove())
  }
}
/*
Kotlin Priority Queue with Comparator
How about creating a Priority Queue of String items in which the String with the smallest length is processed first.
We need a Comparator that compares two Strings by their length.

To create Comparator, we use compareBy function.
*/

fun priorityQueueWithComparator() {
  val compareByLength: Comparator<String> = compareBy { it.length }

  val namesQueueByLength = PriorityQueue<String>(compareByLength)

  namesQueueByLength.add("Jack")
  namesQueueByLength.add("Alex")
  namesQueueByLength.add("Katherin")
  namesQueueByLength.add("Watsons")
  namesQueueByLength.add("Jason")
  namesQueueByLength.add("Hector")

  while (!namesQueueByLength.isEmpty()) {
    println(namesQueueByLength.remove())
  }
}