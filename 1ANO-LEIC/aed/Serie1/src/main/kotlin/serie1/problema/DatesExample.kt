package serie1.problema


import com.example.heap.*
import serie1.problem.createReader
import java.io.BufferedReader
import java.text.SimpleDateFormat
import java.time.Duration
import java.util.*
import kotlin.time.measureTime

/**
 * Data class that represents a Par which is the set between an id and a time
 *
 * @param id -> the ID of the specified Tweet
 * @param time -> The time of a certain Tweet with the identification of an ID
 */
data class Par(val id: Long, val time: Long)


/**
 * Data class that represents the properties of a Tweet
 *
 * @param createdAt -> The property that represents when a Tweet was created (time)
 * @param hashtags -> The property that represents all the hashtags in a certain Tweet
 * @param id -> The property that identifies the ID of a Tweet
 * @param uid -> The property that identifies the user that posted the Tweet
 * @param par -> The property that has the set between the id and the time
 */
data class Tweet(
    var createdAt: String = "",
    var hashtags: String = "",
    var id: Long = 0,
    var uid: Long = 0,
    var par: Par = Par(0, 0)
)

/**
 * Function that given a certain date and time in a string, transforms it into a time in seconds
 *
 * @param dataString -> The date and time in a string that the user wants to convert into seconds
 * @return The date and time in seconds (Long)
 */

fun dateStringToSeconds(dateString: String): Long {
    // Define the date format of your input string
    val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
    // Set the timezone if necessary
    dateFormat.timeZone = TimeZone.getTimeZone("UTC")
    try {
        // Parse the date string into a Date object
        val date = dateFormat.parse(dateString)
        // Calculate the number of milliseconds since the epoch (January 1, 1970, 00:00:00 UTC)
        val milliseconds = date.time
        // Convert milliseconds to seconds
        return milliseconds / 1000
    } catch (e: Exception) {
        // Handle parsing exceptions, if any
        e.printStackTrace()
    }
    // Return -1 if parsing fails
    return -1
}


/**
 * Variable that compares two Pars, in this case, compare the time of each Par
 *
 * @param a -> The first Par to compare with
 * @param b -> The second Par to compare with
 */

val comparePar = { a: Par, b: Par -> a.time.compareTo(b.time) }

/**
 * Function that given an array of Tweets, it returns the k values that are near the date passed has parameter
 *
 * @param tweetList -> Array of all the Tweets in the file passed in the progrma arguments
 * @param k -> The k values near the date passed in the parameter
 * @param dateString -> The date the user wants to check
 * @return The array of the different k times near the date in seconds
 */

fun nearestTweetR(tweetList: Array<Tweet>, k: Int, dateString: String): Array<Long> {
    val dateSeconds = dateStringToSeconds(dateString)

    var ArrayID = tweetList.map { it.id }.toTypedArray()
    val ArrayTime = tweetList.map { dateSeconds - dateStringToSeconds(it.createdAt) }.toTypedArray()
    var ArrayPar = ArrayID.zip(ArrayTime).map { Par(it.first, it.second) }.toTypedArray()
    ArrayPar = ArrayPar.map {
        if (it.time < 0) {
            Par(it.id, it.time * -1)
        } else {
            Par(it.id, it.time)
        }
    }.toTypedArray()
    // Crie um mapa de tempos para IDs
    val timeToIdMap = ArrayPar.associateBy({ it.time }, { it.id })

// Construa o min heap
    val heapArray = ArrayPar

// Construa o min heap
    buildMinHeapL(heapArray, heapArray.size, comparePar)

// Ordene o array usando minHeapifyL
    for (i in heapArray.size downTo 2) {
        exchangeLL(heapArray, 0, i - 1)
        minHeapifyL(heapArray, 0, i - 1, comparePar)
    }

    return heapArray.take(k).map { it.id }.toTypedArray()


    /*  COMO ESTAVA ANTES DO MIN HEAP
        ArrayPar = ArrayPar.sortedBy { it.time }.toTypedArray()
        //ArrayPar =
        return ArrayPar.take(k).map { it.id }.toTypedArray()

    */


}


/**
 * Function main that does all the treatment to the file of tweets and runs the different methods
 *
 * @param args -> The program arguments where it's passed the file that has all the tweets
 */
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
            while (line != null) {
                aTweets[i++] = readTweet(line)
                line = files[0].readLine()
            }
            println(nearestTweetR(aTweets, k = 5, "2014-07-14 19:26:38").toList())
        }
    }
    println("Elapsed time: $elapse")
}

/**
 * Function that reads and delimitates the Tweets given the that file
 *
 * @param line -> The string of that has all the elements of the tweet
 */
fun readTweet(line: String): Tweet {
    val tweet = Tweet()
    val delimiter1 = ": "
    val delimiter2 = "; "

    val parts = line.split(delimiter1, delimiter2)
    for (i in 0..<parts.size) {
        when (i) {
            0 -> tweet.createdAt = parts[i + 1].substring(1..parts[i + 1].length - 2)
            2 -> tweet.hashtags = parts[i + 1]
            4 -> tweet.id = parts[i + 1].toLong()
            6 -> tweet.uid = parts[i + 1].substring(0..parts[i + 1].length - 2).toLong()
        }
    }
    return tweet
}