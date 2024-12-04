package serie2
import serie2.part3.AEDHashMap
import java.io.File
import kotlin.system.measureTimeMillis

/**
 * Depending on the parameter boo, it'll be call the method that uses the kotlin.collections.HashMap or
 * the HaspMap implemented in the project
 *
 * @param k The size of the string that it's taken into account when searching the K-mers in the file
 * @param file The file path of the input files to be read
 * @param boo The boolean parameter that decides which HashMap implementation to be used
 */

fun readKmersOccurences(k: Int, filePath: String, boo: Boolean){
    val fileName = File(filePath)
    val totalString = fileName.readText()
    if (boo) implementedHash(k, totalString)
    else kotlinHash(k, totalString)
}

/**
 * Counts the occurences of the K-mers using the kotlin collections HashMap
 *
 * @param k The size of the string that it's taken into account when searching the K-mers in the file
 * @param string The string that has all the data of the file
 */

fun kotlinHash(k: Int, string: String){
    val timeInMillis = measureTimeMillis{
    val map = HashMap<String, Int>()
    var i = 0
    var j = k - 1

    while(j < string.length){
        var current = ""
        for (h in i ..j){
            current += string[h]
        }
        if (current in map.keys) {
            val currentValue = map.getOrDefault(current, 0)     // retorna o valor da key se n existir retorna 0
            map[current] = currentValue + 1
        }    // adicionar ao hasmap no key
        else {
            map += current to 1 // adiciona o valor um a a respectiva key
        }
        i++
        j++
    }

    val outputfile = File("Output.txt")
    outputfile.writeText("") // isto é utilizado para deixar o ficheiro em branco antes de vpoltar a apresentar os
    // resultados, se necessário comentamos esta linha

    for (elem in map.keys){
        outputfile.appendText(elem + " - " + map[elem] + "\n") // escreve no ficheiro com o formato pedido
    }
    }
    println("This operation took $timeInMillis ms")
}

/**
 * Counts the occurences of the K-mers using the HashMap implemented in the project
 *
 * @param k The size of the string that it's taken into account when searching the K-mers in the file
 * @param string The string that has all the data of the file
 */

fun implementedHash(k: Int, string: String){
    val timeInMillis = measureTimeMillis{
    val map = AEDHashMap<String, Int>()
    var i = 0
    var j = k - 1

    while(j < string.length){
        var current = ""
        for (h in i ..j){
            current += string[h]
        }
        if (map.contains(current) != null )  {
            val node = map.contains(current)
            node?.value = (node?.value ?: 0) + 1
        }    // adicionar ao hasmap no key
        else {
            map.put(current,1) // adiciona o valor um a a respectiva key
        }
        i++
        j++
    }

    val outputfile = File("Output.txt")
    outputfile.writeText("") // isto é utilizado para deixar o ficheiro em branco antes de vpoltar a apresentar os
    // resultados, se necessário comentamos esta linha

    for (elem in map.keys){
        outputfile.appendText(elem.key + " - " + elem.value + "\n") // escreve no ficheiro com o formato pedido
    }
    }
    println("This operation took $timeInMillis ms")
}

/**
 * The main function of the program.
 * Reads the occurrences of K-mers in the specified file using either the Kotlin collections HashMap
 * or the HashMap implemented in the project based on the value of the "boo" parameter.
 */
fun main (){
    readKmersOccurences(3, "src/main/kotlin/datasets/Vibrio_cholerae.txt", true)
}

