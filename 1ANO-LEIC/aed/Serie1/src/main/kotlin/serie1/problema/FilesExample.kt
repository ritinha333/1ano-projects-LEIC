package serie1.problem

import java.io.BufferedReader
import java.io.FileReader
import java.io.PrintWriter

fun createReader(fileName: String): BufferedReader {
    return BufferedReader(FileReader(fileName))
}

fun createWriter(fileName: String?): PrintWriter {
    return PrintWriter(fileName)
}

// Ler palavra
fun readWord(line: String) {
    var delimiter1 = "; "
    var delimiter2 = ": "

    val parts = line.split(delimiter1, delimiter2)
    print(parts)
    println()
}

/** Usage Example
 *  File on the project Directory:
 *  Copy Input Files to OutputFile.
 * **/
fun main(args: Array<String>) {
    var files = emptyArray<BufferedReader>()
    var line:String?
    for (n in 0..args.size - 1) {
        files += createReader(args[n])
        line = files[n].readLine()
        println(line)
    }
    val nFiles = args.size

    val pw = createWriter("output.txt")
    var line2:String?

    // Read files and write into output.txt
    for (i in 0..nFiles - 1) {
        line = files[i].readLine()
        while (line != null) {
            readWord(line)
            pw.println(line)
            line = files[i].readLine()
        }
    }
    pw.close()
}