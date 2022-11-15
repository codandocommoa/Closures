/*:
## Closures
 
 Closures são blocos de funcionalidade independentes que podem ser passados e usados em seu código.
 Os closures em Swift são semelhantes aos blocos em C e Objective-C e aos lambdas em outras linguagens de programação.

 Os Closures podem capturar e armazenar referências a quaisquer constantes e variáveis do contexto em que são definidas.
 
 Isso é conhecido como closure sobre essas constantes e variáveis.
 
 O Swift lida com todo o gerenciamento de memória da captura para você.
 
 >Não se preocupe se você não estiver familiarizado com o conceito de captura. É explicado em detalhes abaixo em Capturando Valores(@Capturando%20Valores).
 
 Funções globais e aninhadas, como introduzidas em [Funções](https://docs.swift.org/swift-book/LanguageGuide/Functions.html), são na verdade casos especiais de Closures. Os Closures assumem uma das três formas:

 Funções globais são Closures que têm um nome e não capturam nenhum valor.
 Funções aninhadas são Closures que têm um nome e podem capturar valores de sua função delimitadora.
 
 As expressões de Closures são escritas sem nome em uma sintaxe leve que pode capturar valores de seu contexto circundante.
 
 As expressões de Closures da Swift têm um estilo limpo e claro, com otimizações que incentivam uma sintaxe breve e sem bagunça em cenários comuns.
 
 Essas otimizações incluem:

 Inferindo parâmetros e retornando tipos de valor do contexto
 Retornos implícitos de closures de expressão única
 Nomes de argumentos abreviados
 Sintaxe de (Trailing Closures) closure à direita
 
 
 ### Expressões de Closures

 Funções aninhadas, como introduzidas em Funções Aninhadas, são um meio conveniente de nomear e definir blocos de código independentes como parte de uma função maior.
 
 No entanto, às vezes é útil escrever versões mais curtas de construções semelhantes a funções sem uma declaração e nome completos. Isso é particularmente verdadeiro quando você trabalha com funções ou métodos que usam funções como um ou mais de seus argumentos.
 

 As expressões de Closure são uma maneira de escrever Closure embutidos em uma sintaxe breve e focada. As expressões de Closure fornecem várias otimizações de sintaxe para escrever encerramentos de forma abreviada sem perda de clareza ou intenção. Os exemplos de expressão de encerramento abaixo ilustram essas otimizações refinando um único exemplo do método sorted(by:) em várias iterações, cada uma delas expressando a mesma funcionalidade de maneira mais sucinta.


 ### O Método Classificado
 
 A biblioteca padrão do Swift fornece um método chamado sorted(by:), que classifica uma matriz de valores de um tipo conhecido, com base na saída de um encerramento de classificação que você fornece. Depois de concluir o processo de classificação, o método sorted(by:) retorna um novo array do mesmo tipo e tamanho do antigo, com seus elementos na ordem de classificação correta. O array original não é modificado pelo método sorted(by:).

 Os exemplos de expressão de closure abaixo usam o método sorted(by:) para classificar uma matriz de valores String em ordem alfabética inversa. Aqui está a matriz inicial a ser classificada:
 */

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames is equal to ["Ewa", "Daniella", "Chris", "Barry", "Alex"]

/*:
 Se a primeira string (s1) for maior que a segunda string (s2), a função backward(_:_:) retornará true, indicando que s1 deve aparecer antes de s2 no array ordenado. Para caracteres em strings, “maior que” significa “aparece mais tarde no alfabeto que”. Isso significa que a letra "B" é "maior que" a letra "A", e a string "Tom" é maior que a string "Tim". Isso fornece uma classificação alfabética reversa, com "Barry" sendo colocado antes de "Alex" e assim por diante.

 No entanto, esta é uma maneira bastante prolixa de escrever o que é essencialmente uma função de expressão única (a > b). Neste exemplo, seria preferível escrever o encerramento de classificação inline, usando a sintaxe de expressão de closure.
 
 ### Sintaxe da Expressão de Closure
 A sintaxe da expressão de encerramento tem a seguinte forma geral:
 
 ````
 { (parameters) -> return type in
     statements
 }
 ````
 
 Os parâmetros na sintaxe da expressão de closure podem ser parâmetros de entrada e saída, mas não podem ter um valor padrão. Parâmetros variádicos podem ser usados se você nomear o parâmetro variádico. As tuplas também podem ser usadas como tipos de parâmetros e tipos de retorno.

 O exemplo a baixo mosta uma versão da expressão closure em comparação com a função acima backward(_:_:)
 
 */

reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

/*:
 
 Observe que a declaração de parâmetros e o tipo de retorno para esse closure inline é idêntico à declaração da função backward(_:_:). Em ambos os casos, é escrito como:
 
 #### (s1: String, s2: String) -> Bool.
 
 No entanto, para a expressão closure inline, os parâmetros e o tipo de retorno são escritos dentro das chaves, não fora delas.
 
 O início do corpo do closure é introduzido pela palavra-chave in. Essa palavra-chave indica que a definição dos parâmetros e do tipo de retorno do encerramento foi concluída e o corpo do closure está prestes a começar.

 Como o corpo do closure é tão curto, ele pode até ser escrito em uma única linha:
 
 */

reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )

/*:
 
 > Isso ilustra que a chamada geral para o método sorted(by:) permaneceu a mesma. Um par de parênteses ainda envolve todo o argumento do método. No entanto, esse argumento agora é um Closure InLine.
 
 
 ### Inferindo tipo a partir do contexto
 
 Como o closure de classificação é passado como um argumento para um método, o Swift pode inferir os tipos de seus parâmetros e o tipo do valor que ele retorna.
 O método sorted(by:) está sendo chamado em um array de strings, então seu argumento deve ser uma função do tipo (String, String) -> Bool. Isso significa que os tipos (String, String) e Bool não precisam ser escritos como parte da definição da expressão closure. Como todos os tipos podem ser inferidos, a seta de retorno (->) e os parênteses em torno dos nomes dos parâmetros também podem ser omitidos:
 */

reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )

/*:
 
 É sempre possível inferir os tipos de parâmetros e retornar o tipo ao passar um closure para uma função ou método como uma expressão de closure InLine. Como resultado, você nunca precisa escrever um closure em linha em sua forma mais completa quando o closure é usado como um argumento de função ou método.

 No entanto, você ainda pode tornar os tipos explícitos, se desejar, e isso é recomendado para evitar ambiguidade para os leitores do seu código. No caso do método sorted(by:), o propósito do closure é claro pelo fato de que a ordenação está ocorrendo, e é seguro para um leitor supor que o closure provavelmente está funcionando com valores String, porque é auxiliando na classificação de uma matriz de strings.
 
 */

/*:
 ### Devoluções Implícitas de Fechamentos de Expressão Única
 
 Closures de expressão única podem retornar implicitamente o resultado de sua expressão única omitindo a palavra-chave return de sua declaração, como nesta versão do exemplo anterior:

 */

 reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )

 /*:
  
 Aqui, o tipo de função do argumento do método sorted(by:) deixa claro que um valor Bool deve ser retornado pela closure. Como o corpo do closure contém uma única expressão (s1 > s2) que retorna um valor Bool, não há ambiguidade e a palavra-chave return pode ser omitida.
  
 */


/*:
 ### Nomes de Argumentos Abreviados
 
 O Swift fornece automaticamente nomes de argumentos abreviados para closures inline, que podem ser usados para se referir aos valores dos argumentos do closure pelos nomes $0, $1, $2 e assim por diante.

 Se você usar esses nomes de argumentos abreviados em sua expressão de closure, poderá omitir a lista de argumentos do closure de sua definição. O tipo dos nomes dos argumentos abreviados é inferido a partir do tipo de função esperado e o argumento abreviado de número mais alto que você usa determina o número de argumentos que o closure leva. A palavra-chave in também pode ser omitida, porque a expressão de closure é composta inteiramente de seu corpo:
 */

reversedNames = names.sorted(by: { $0 > $1 } )

/*:
 Aqui, $0 e $1 referem-se ao primeiro e segundo argumentos String do closure. Como $1 é o argumento abreviado com o número mais alto, entende-se que o closure recebe dois argumentos. Como a função sorted(by:) aqui espera um closure cujos argumentos são ambos strings, os argumentos abreviados $0 e $1 são ambos do tipo String.
 */

/*:
 ### Métodos do Operador
 
 Na verdade, existe uma maneira ainda mais curta de escrever a expressão de closure acima. O tipo String do Swift define sua implementação específica de string do operador maior que (>) como um método que possui dois parâmetros do tipo String e retorna um valor do tipo Bool. Isso corresponde exatamente ao tipo de método necessário para o método sorted(by:). Portanto, você pode simplesmente passar o operador maior que, e o Swift deduzirá que você deseja usar sua implementação específica de string:
 */

reversedNames = names.sorted(by: >)

/*:
 > Para saber mais sobre métodos de operador, consulte [Métodos de Operador](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID42)
 */

/*:
 ### Fechamentos à direita (Trailing Closures)

 Se você precisar passar uma expressão de closure para uma função como argumento final da função e a expressão de closure for longa, pode ser útil escrevê-la como um closure à direita. Você escreve um closure à direita após os parênteses da chamada de função, mesmo que o closure à direita ainda seja um argumento para a função. Quando você usa a sintaxe de closure à direita, você não escreve o rótulo do argumento para o primeiro closure como parte da chamada de função. Uma chamada de função pode incluir vários closures à direita; no entanto, os primeiros exemplos abaixo usam um único closure à direita.
 
 */

func someFunctionThatTakesAClosure(closure: () -> Void) {
    // function body goes here
}

// Here's how you call this function without using a trailing closure:

someFunctionThatTakesAClosure(closure: {
    // closure's body goes here
})

// Here's how you call this function with a trailing closure instead:

someFunctionThatTakesAClosure() {
    // trailing closure's body goes here
}


/*:
 O closure de classificação de string da seção Sintaxe de Expressão de Fechamento acima pode ser escrito fora dos parênteses do método sorted(by:) como um closure à direita:
 */

reversedNames = names.sorted() { $0 > $1 }

/*:
 Se uma expressão de closure for fornecida como o único argumento da função ou método e você fornecer essa expressão como um closure à direita, não será necessário escrever um par de parênteses () após o nome da função ou do método ao chamar a função:
 */

reversedNames = names.sorted { $0 > $1 }

/*:
 closures à direita são mais úteis quando o closure é suficientemente longo para que não seja possível escrevê-lo em linha em uma única linha. Como exemplo, o tipo Array do Swift tem um método map(_:), que recebe uma expressão closure como seu único argumento. O encerramento é chamado uma vez para cada item na matriz e retorna um valor mapeado alternativo (possivelmente de algum outro tipo) para esse item. Você especifica a natureza do mapeamento e o tipo do valor retornado escrevendo o código no closure que você passa para map(_:).

 Depois de aplicar o closure fornecido a cada elemento do array, o método map(_:) retorna um novo array contendo todos os novos valores mapeados, na mesma ordem que seus valores correspondentes no array original.

 Veja como você pode usar o método map(_:) com um closure à direita para converter uma matriz de valores Int em uma matriz de valores String. O array [16, 58, 510] é usado para criar o novo array ["OneSix", "FiveEight", "FiveOneZero"]:
 */

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

/*:
 O código acima cria um dicionário de mapeamentos entre os dígitos inteiros e como versões em inglês de seus nomes. Ele também define uma matriz de inteiros, pronto para ser convertido em strings

 Agora você pode usar o array de números para criar um array de valores String, passando uma expressão de closure para o método map(_:) do array como um closure à direita:
 
 */

let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + " " + output
        number /= 10
    } while number > 0
    return output
}

print(strings)
// strings is inferred to be of type [String]
// its value is ["One Six", "Five Eight", "Five One Zero"]

/*:
 O método map(_:) chama a expressão closure uma vez para cada item no array. Você não precisa especificar o tipo do parâmetro de entrada do closure, (number), porque o tipo pode ser inferido a partir dos valores na matriz a ser mapeada.
 
 Neste exemplo, a variável number é inicializada com o valor do parâmetro number da closure, para que o valor possa ser modificado dentro do corpo da closure. (Os parâmetros para funções e closures são sempre constantes.) A expressão closure também especifica um tipo de retorno String, para indicar o tipo que será armazenado na matriz de saída mapeada.
 
 A expressão closure cria uma string chamada output cada vez que é chamada.
 Ele calcula o último dígito do número usando o operador restante (número % 10) e usa esse dígito para procurar uma string apropriada no dicionário digitNames.
 O closure pode ser usado para criar uma representação de string de qualquer inteiro maior que zero.
 */

/*:
 > A chamada para o subscrito do dicionário digitNames é seguida por um ponto de exclamação (!), porque os subscritos do dicionário retornam um valor opcional para indicar que a pesquisa do dicionário pode falhar se a chave não existir. No exemplo acima, é garantido que o número % 10 sempre será uma chave de subscrito válida para o dicionário digitNames e, portanto, um ponto de exclamação é usado para forçar o desdobramento do valor String armazenado no valor de retorno opcional do subscrito.
 */

/*:
 A string recuperada do dicionário digitNames é adicionada à frente da saída, criando efetivamente uma versão string do número ao contrário.
 (A expressão número % 10 dá um valor de 6 para 16, 8 para 58 e 0 para 510.)
 
 A variável number é então dividida por 10. Por ser um número inteiro, é arredondado para baixo durante a divisão, então 16 se torna 1, 58 se torna 5 e 510 se torna 51.
 
 O processo é repetido até que o número seja igual a 0, ponto em que a string de saída é retornada pelo encerramento e é adicionada à matriz de saída pelo método map(_:).
 
 O uso da sintaxe de closure à direita no exemplo acima encapsula perfeitamente a funcionalidade do closure imediatamente após a função que o closure suporta, sem a necessidade de envolver o closure inteiro dentro dos parênteses externos do método map(_:).
 
 Se uma função receber vários closure's, você omitirá o rótulo do argumento para o primeiro closure à direita e rotulará os closure's à direita restantes. Por exemplo, a função abaixo carrega uma imagem para uma galeria de fotos:
 */

/*:
````
func loadPicture(from server: Server, completion: (Picture) -> Void, onFailure: () -> Void) {
    if let picture = download("photo.jpg", from: server) {
        completion(picture)
    } else {
        onFailure()
    }
}
````
*/

/*:
 Ao chamar essa função para carregar uma imagem, você fornece dois closures.
 O primeiro closure é um manipulador de conclusão que exibe uma imagem após um download bem-sucedido.
 O segundo closure é um manipulador de erros que exibe um erro para o usuário.
 */

/*:
 ````
 loadPicture(from: someServer) { picture in
     someView.currentPicture = picture
 } onFailure: {
     print("Couldn't download the next picture.")
 }
 ````
 
 */

/*:
 Neste exemplo, a função loadPicture(from:completion:onFailure:) despacha sua tarefa de rede em segundo plano e chama um dos dois manipuladores de conclusão quando a tarefa de rede termina.
 Escrever a função dessa maneira permite separar claramente o código responsável por lidar com uma falha de rede do código que atualiza a interface do usuário após um download bem-sucedido, em vez de usar apenas um closure que lida com as duas circunstâncias.
 */

//: [Next](@next)
