import java.net.Socket
import java.net.InetSocketAddress
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.PrintWriter

const val RESPONSE_SIZE = 10000
const val PORT = 80

//mensagem que será enviada para o servidor
val mensage = """
GET /%s HTTP/1.1\r\n
Host: %s\r\n
Connection: keep-alive\r\n
User-Agent: WebClient Console Application written in Kotlin\r\n
Accept: text/html,application/xhtml+xml\r\n
Accept-Language: en-US,en;q=0.9\r\n
Accept-Encoding: gzip, deflate, br\r\n
\r\n
""".trimIndent()

fun main(args: Array<String>) {
    if (args.size != 1) {
        println("Usage: ./webclient <URL>")
        return
    }
// guarda os argumentos
    val url = args[0]
    val host = url.split("/")[0]
    val path = url.split("/").drop(1).joinToString("/")
    val msg = mensage.format(path, host)

// criação do socket TCP (IP address e porto)
    val socket = Socket()
    println("-> Socket created successfully")

// conexão com o servidor
    socket.connect(InetSocketAddress(host, PORT))
    println("-> Server connection made successfully ($host:$PORT)")


// envia a mensagem
    val writer = PrintWriter(socket.getOutputStream(), true)
    writer.println(msg)
    println("-> Message sent:\n$msg")


// recebe e guarda a mensagem do servidor
    val reader = BufferedReader(InputStreamReader(socket.getInputStream()))
    val response = CharArray(RESPONSE_SIZE)
    reader.read(response, 0, RESPONSE_SIZE)
    println("-> Response received")


// permite ao utilizador guardar a mensagem num documento texto ou escrever a resposta na linha de comandos
    httpResponse(response.joinToString(""))

// fecho do socket
    println("-> Closing socket...")
    socket.close()
}
// trata da mensagem do servidor, se o utilizador quer guardar num ficheiro ou escrevê-la na linha de comandos
fun httpResponse(httpResponse: String) {
    var options: Int
    do {
        println("Display http response in:")
        println(" 1. Current terminal")
        println(" 2. Separate file")
        println(" 3. Exit")
        print(" > ")
        options = readLine()?.toIntOrNull() ?: 0
        when (options) {
            1 -> {
                println("-> Message received:\n$httpResponse")
            }
            2 -> {
                val writer = PrintWriter("response.txt", "UTF-8")
                writer.print(httpResponse)
                writer.close()
                println("-> Message printed to \"response.txt\"")
            }
            3 -> {
            }
            else -> {
                println("Invalid option!\n")
            }
        }
    } while (options != 1 && options != 2 && options != 3)
}