package org.example

import org.junit.jupiter.api.Test
import kotlin.test.assertEquals
import org.example.*

class MainTests {
    @Test
    fun test_sumGivesN1_n_zero() {
        //assertEquals(0, sumGivesN1(0))
    }

    @Test
    fun test_isSubArray(){
        val arr = arrayOf(1,2,3,5,6)
        val subArray = arrayOf(5, 6)
        assertEquals(true, subArray.isSubArray(arr))
    }

    @Test
    fun test_largestPalindromeSize(){
        val sequence: String = "anabelal"
        val pos1: Int = 1
        val pos2: Int = 6
        val pos3: Int = 3
        assertEquals(3, largestPalindromeSize(sequence, pos1))
        assertEquals(3, largestPalindromeSize(sequence, pos2))
        assertEquals(1, largestPalindromeSize(sequence, pos3))

    }
}