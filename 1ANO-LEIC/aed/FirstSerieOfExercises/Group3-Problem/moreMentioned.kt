package serie1.problema
import java.io.File
import com.example.heap.*

data class HashTag(val str: String, val counter: Int)
data class Tweet(val date: String, val hashTag: Array<String>, val tweet_id: Int, val user_id: Int)

/**
 * This function returns the most mentioned hashtag from a .tag file
 * First Version
 */
fun moreMentioned(filePath: String): String {
    //inicialização de variáveis
    val delimeters = "\r\n"
    var counterArr = intArrayOf()
    var mostMentionedHash = HashTag("", 0)
    var counter = 0
    var i = 0
    var element = 0

    //abertura de ficheiro
    val file = File(filePath)
    val str = file.readText()

    //valores da string do ficheiro em array
    val arrOfHashTags = str.split(delimeters, ignoreCase = true).toTypedArray()

    // iterar sobre esse array para ver as ocorrências de cada indice do arr
    while (i in 0..arrOfHashTags.size-1 || i == arrOfHashTags.size) {
        if (i > arrOfHashTags.size - 1 ) {
            element++
            i = element - 1
            counterArr += counter
            counter = 0
        } else
            if (arrOfHashTags[element] == arrOfHashTags[i]) counter++
        i++
        if(element > arrOfHashTags.size - 1) break
    }

    val hashWithCounter = Array(arrOfHashTags.size) {HashTag(arrOfHashTags[it], counterArr[it])}

    for ((h,c) in hashWithCounter){
        if(c == counterArr.max())
            mostMentionedHash = HashTag(h,c)
    }
    return "Most Mentioned Hashtag => #${mostMentionedHash.str} . \n" +
            "Which was mentioned ${mostMentionedHash.counter} times."
}

/**
 * This function returns the most mentioned hashtag from a .tag file
 * Second Version
 */
fun moreMentioned2(filePath: String): String {
    //inicialização de variáveis
    val delimeters = "\r\n"
    var counterArr = intArrayOf()
    var mostMentionedHash = HashTag("", 0)
    var counter = 0
    var i = 0
    var element = 0

    //abertura de ficheiro
    val file = File(filePath)
    val str = file.readText()

    //valores da string do ficheiro em array
    val arrOfHashTags = str.split(delimeters, ignoreCase = true).toTypedArray()

    // iterar sobre esse array para ver as ocorrências de cada indice do arr
    while (i in 0..arrOfHashTags.size-1 || i == arrOfHashTags.size) {
        if (i > arrOfHashTags.size - 1 ) {
            element++
            i = element - 1
            counterArr += counter
            counter = 0
        } else
            if (arrOfHashTags[element] == arrOfHashTags[i]) counter++
        i++
        if(element > arrOfHashTags.size - 1) break
    }

    val hashWithCounter = Array(arrOfHashTags.size) {HashTag(arrOfHashTags[it], counterArr[it])}
    for ((h,c) in hashWithCounter){
        mostMentionedHash = HashTag(h,c)
    }
    buildMaxHeap(counterArr, counterArr.size, compare)

    return "Most Mentioned Hashtag => #${mostMentionedHash.str} . \n" +
            "Which was mentioned ${counterArr[0]} times."
}

/**
 * This function returns the most mentioned hashtag from a .tag file
 * Third Version
 */

fun moreMentioned3(filePath: String): String {
    //inicialização de variáveis
    val delimeters = "\r\n"
    var arrayOfCounterPairs = intArrayOf()
    var hashTagFinal = ""

    //abertura de ficheiro
    val file = File(filePath)
    val str = file.readText()

    //valores da string do ficheiro em array
    val arrOfHashTags = str.split(delimeters, ignoreCase = true).toTypedArray()
    val frequencyByAppearence = arrOfHashTags.groupingBy { it }.eachCount().toList()

    //adicionar ao arrayOfCounterPairs
    frequencyByAppearence.forEach {
        val (hashtag, counter) = Pair(it.first, it.second)
        arrayOfCounterPairs += counter
    }
    buildMaxHeap(arrayOfCounterPairs, arrayOfCounterPairs.size, compare)

    frequencyByAppearence.forEach{
        val (hashtag, counter) = Pair(it.first, it.second)
        if( arrayOfCounterPairs[0] == counter)
            hashTagFinal = it.first
    }

    return "Most Mentioned Hashtag => #${hashTagFinal} . \n" +
            "Which was mentioned ${arrayOfCounterPairs[0]} times."

}

//for debugging purposes
fun main(){
    println(moreMentioned3("./hashtag.tag"))
}
