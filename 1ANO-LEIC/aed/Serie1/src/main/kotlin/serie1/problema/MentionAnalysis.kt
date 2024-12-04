package serie1.problema

import java.io.File
import com.example.heap.*
import serie1.problem.createReader
import java.io.BufferedReader
import kotlin.time.measureTime

/**
 * Data class that identifies the properties of an HashTag
 *
 * @param str -> The hashtag in question
 * @param counter -> The occurrences of the hashtag
 */
data class HashTag(val str: String, val counter: Int)

/**
 * This function returns the most mentioned hashtag from a .tag file
 * Complexity: O(n) + O(n) + O(n) = O(n)
 *
 * @param filePath It passes the file the user wants to iterate over
 * @return a string that gives the user the information about the most mentioned hashtag
 */
fun moreMentioned(filePath: String, tweets: Array<String>): String {
    //inicialização de variáveis
    val delimeters = "\r\n"
    var counterArr = intArrayOf()
    var hashToPickedHash = arrayOf<String>()
    var mostMentionedHash = ""
    var counter = 1
    var i = 0
    var j = 1
    var idx = 0
    var aux = 0

    //abertura de ficheiro
    val file = File(filePath)
    val str = file.readText()

    val arrOfHashTags = str.split(delimeters).toTypedArray()        //[wc, m]

    while (idx in 0..tweets.size - 1) {
        if (tweets[idx] == arrOfHashTags[aux]) {
            hashToPickedHash += tweets[idx]
        }
        if (idx == tweets.size - 1) {
            idx = 0
            aux++
        } else idx++
        if (aux == arrOfHashTags.size - 1 && idx == tweets.size - 1) break
    }

    val size = hashToPickedHash.size

    //testar o tamanho do array
    if (size == 0) return "There are no HashTags in the file"
    if (size == 1) return "Most Mentioned Hashtag => #${hashToPickedHash[0]}. \nWhich was mentioned $counter times."

    else {

        while (j <= size - 1) {
            if (j == size - 1) {
                if (hashToPickedHash[i] == hashToPickedHash[j]) counter++
                counterArr += counter
                mostMentionedHash = hashToPickedHash[i]
                counter = 1
                i++
                j = i + 1
            }
            if (hashToPickedHash[i] == hashToPickedHash[j]) counter++
            j++
            if (i == size - 1) break
        }

        buildMaxHeap(counterArr, counterArr.size, compare)

        return "Most Mentioned Hashtag => #${mostMentionedHash} . \n" +
                "Which was mentioned ${counterArr[0]} times."
    }
}

fun main(args: Array<String>) {
    val elapse: kotlin.time.Duration = measureTime {
        var files = emptyArray<BufferedReader>()
        val aTweets: Array<Tweet>
        var line: String? = null
        for (n in 0..args.size - 1) {
            files += createReader(args[n])
            line = files[n].readLine()
            println("Number tweets = $line")
        }
        val nFiles = args.size
        if (nFiles > 0) {
            val size = line!!.toInt()
            aTweets = Array(size) { Tweet() }
            line = files[0].readLine()
            var i = 0
            while (line != null && i < aTweets.size) {
                aTweets[i++] = readTweet(line)
                line = files[0].readLine()
            }

            var hashTagArrayTweet = aTweets.map { it.hashtags }
            var arraypos = emptyArray<String>()
            for (i in hashTagArrayTweet) {
                if (i.contains(",")) {
                    arraypos += i.split(",")
                } else arraypos += i
            }

            var temp = ""
            var arr = arrayOf<String>()
            for (i in arraypos.indices) {
                for (j in arraypos[i]) {
                    if (j.isLetter()) temp += j
                }
                arr += temp
                temp = ""
            }


            //println(arr.toList())
            println(moreMentioned("src/main/kotlin/serie1/problema/hashtags.tag", arr))

        }
    }
    println("Elapsed time: $elapse")
}




