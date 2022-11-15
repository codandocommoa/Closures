//: [Previous](@previous)

/*:
 ### Capturando valores

 Um closure pode capturar constantes e variáveis do contexto circundante no qual é definido.
 O closure pode então se referir e modificar os valores dessas constantes e variáveis de dentro de seu corpo, mesmo que o escopo original que definiu as constantes e variáveis não exista mais.

 Em Swift, a forma mais simples de um closure que pode capturar valores é uma função aninhada, escrita dentro do corpo de outra função.
 Uma função aninhada pode capturar qualquer um dos argumentos de sua função externa e também pode capturar quaisquer constantes e variáveis definidas dentro da função externa.

 Aqui está um exemplo de uma função chamada makeIncrementer, que contém uma função aninhada chamada incrementer.
 A função incrementer() aninhada captura dois valores, runningTotal e amount, de seu contexto circundante.
 Depois de capturar esses valores, o incrementador é retornado pelo makeIncrementer como um closure que incrementa runningTotal por valor cada vez que é chamado.
 */

func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

/*:
 O tipo de retorno de makeIncrementer é () -> Int. Isso significa que ele retorna uma função, em vez de um valor simples. A função que ele retorna não tem parâmetros e retorna um valor Int cada vez que é chamada. Para saber como as funções podem retornar outras funções, consulte [Tipos de função como tipos de retorno](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID177).
 
 
 A função makeIncrementer(forIncrement:) define uma variável inteira chamada runningTotal, para armazenar o total atual do incrementador que será retornado. Esta variável é inicializada com um valor de 0.
 
 A função makeIncrementer(forIncrement:) tem um único parâmetro Int com um rótulo de argumento forIncrement e um nome de parâmetro de amount. O valor do argumento passado para este parâmetro especifica quanto runningTotal deve ser incrementado cada vez que a função incrementadora retornada é chamada. A função makeIncrementer define uma função aninhada chamada incrementer, que realiza o incremento real.
 Esta função simplesmente adiciona valor ao runningTotal e retorna o resultado.
 
````
func incrementer() -> Int {
    runningTotal += amount
    return runningTotal
}
````
 
 A função incrementer() não possui nenhum parâmetro e, no entanto, refere-se a runningTotal e a quantidade de dentro do corpo da função.
 
 Ele faz isso capturando uma referência para runningTotal e valor da função circundante e usando-os dentro de seu próprio corpo de função.
 
 A captura por referência garante que runningTotal e amount não desapareçam quando a chamada para makeIncrementer terminar e também garante que runningTotal esteja disponível na próxima vez que a função de incrementador for chamada.
 
 > Como otimização, o Swift pode capturar e armazenar uma cópia de um valor se esse valor não for mutado por um fechamento e se o valor não for alterado após a criação do fechamento.
 > O Swift também lida com todo o gerenciamento de memória envolvido na eliminação de variáveis quando elas não são mais necessárias.
 
 Aqui está um exemplo de makeIncrementer em ação:
 */
let incrementByTen = makeIncrementer(forIncrement: 10)

/*:
 Este exemplo define uma constante chamada incrementByTen para se referir a uma função incrementadora que adiciona 10 à sua variável runningTotal cada vez que é chamada.
 Chamar a função várias vezes mostra esse comportamento em ação:
 */

incrementByTen()
// returns a value of 10
incrementByTen()
// returns a value of 20
incrementByTen()
// returns a value of 30

/*:
 Se você criar um segundo incrementador, ele terá sua própria referência armazenada para uma nova variável runningTotal separada:
 */

let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()
// returns a value of 7

/*:
 Chamar o incrementador original (incrementByTen) novamente continua a incrementar sua própria variável runningTotal e não afeta a variável capturada por incrementBySeven:
 */

incrementByTen()
// returns a value of 40


/*:
 Se você atribuir um closure a uma propriedade de uma instância de classe e o closure capturar essa instância referindo-se à instância ou a seus membros, você criará um forte ciclo de referência entre o fechamento e a instância.
 O Swift usa listas de captura para quebrar esses ciclos de referência fortes.
 Para mais informações, consulte [Ciclos de Referência Fortes para Fechamentos](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID56).
 */

/*:
 ## Closures são Reference Types
 
 No exemplo acima, incrementBySeven e incrementByTen são constantes, mas os closures aos quais essas constantes se referem ainda podem incrementar as variáveis runningTotal que elas capturaram. Isso ocorre porque funções e closures são tipos de referência (Reference Types).

 Sempre que você atribui uma função ou um closure a uma constante ou variável, na verdade você está definindo essa constante ou variável para ser uma referência à função ou closure.
 
 
 No exemplo acima, é a escolha do closure que incrementByTen se refere a essa constante, e não o conteúdo do closures em si.

 Isso também significa que se você atribuir um closure a duas constantes ou variáveis diferentes, ambas as constantes ou variáveis se referem ao mesmo closure (a mesma referência de memória).
 
 */

let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
// returns a value of 50

incrementByTen()
// returns a value of 60

/*:
 O exemplo acima mostra que chamar alsoIncrementByTen é o mesmo que chamar incrementByTen.
 Como ambos se referem ao mesmo closure, ambos incrementam e retornam o mesmo total em execução.
 */

/*:
 ### Escape de Closures

 Diz-se que um closure escapa de uma função quando o closure é passado como um argumento para a função, mas é chamado após o retorno da função.
 Quando você declara uma função que recebe uma closure como um de seus parâmetros, você pode escrever @escaping antes do tipo do parâmetro para indicar que a closure tem permissão para escapar.

 Uma maneira que um closure pode escapar é sendo armazenado em uma variável que é definida fora da função. Como exemplo, muitas funções que iniciam uma operação assíncrona usam um argumento de encerramento como um manipulador de conclusão.
 A função retorna após iniciar a operação, mas o closure não é chamado até que a operação seja concluída - o closure precisa escapar, para ser chamado posteriormente. Por exemplo:
 */

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

/*:
 A função someFunctionWithEscapingClosure(_:) recebe um closure como argumento e o adiciona a um array declarado fora da função.
 Se você não marcasse o parâmetro desta função com @escaping, você receberia um erro em tempo de compilação.
 
 

 Um closure de escape que se refere a self precisa de consideração especial se self se refere a uma instância de uma classe.
 Capturar self em um closure de escape facilita a criação acidental de um forte ciclo de referência(strong reference cycle).
 
 > Para obter informações sobre ciclos de referência, consulte [Contagem automática de referências](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html).
 
 Normalmente, uma closure captura variáveis implicitamente usando-as no corpo da closure, mas neste caso você precisa ser explícito. Se você deseja capturar self, escreva self explicitamente ao usá-lo ou inclua self na lista de captura do closure.
 Escrever self explicitamente permite que você expresse sua intenção e o lembra de confirmar que não há um ciclo de referência.
 Por exemplo, no código abaixo, o closure passado para someFunctionWithEscapingClosure(_:) refere-se explicitamente a self. Em contraste, o encerramento passado para someFunctionWithNonescapingClosure(_:) é um encerramento sem escape, o que significa que ele pode se referir a self implicitamente.
 */

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
// Prints "200"

completionHandlers.first?()
print(instance.x)
// Prints "100"

/*:
 Aqui está uma versão de doSomething() que captura self incluindo-o na lista de captura do closure, e então se refere a self implicitamente:
 */

class SomeOtherClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { [self] in x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

/*:
 Se self for uma instância de uma estrutura ou enumeração, você sempre poderá se referir a self implicitamente. No entanto, um closure de escape não pode capturar uma referência mutável a self quando self é uma instância de uma estrutura ou uma enumeração.
 Estruturas e enumerações não permitem mutabilidade compartilhada, conforme discutido em [Estruturas e enumerações são tipos de valor](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html#ID88).
 
 */

struct SomeStruct {
    var x = 10
    mutating func doSomething() {
        someFunctionWithNonescapingClosure { x = 200 }  // Ok
      //  someFunctionWithEscapingClosure { x = 100 }     // Error
    }
}


/*:
 A chamada para a função someFunctionWithEscapingClosure no exemplo acima é um erro porque está dentro de um método mutante, então self é mutável. Isso viola a regra de que closures de escape não podem capturar uma referência mutável a self para estruturas.
 */

/*:
 ### Autoclosures
 
 Um autoclosure é um closure que é criado automaticamente para envolver uma expressão que está sendo passada como argumento para uma função. Ele não recebe nenhum argumento e, quando é chamado, retorna o valor da expressão que está dentro dele. Essa conveniência sintática permite omitir chaves em torno do parâmetro de uma função escrevendo uma expressão normal em vez de um closure explícito.

 É comum chamar funções que aceitam closure automático, mas não é comum implementar esse tipo de função. Por exemplo, a função assert(condition:message:file:line:) aceita um closure automático para seus parâmetros de condição e mensagem; seu parâmetro de condição é avaliado apenas em compilações de depuração e seu parâmetro de mensagem é avaliado somente se condição for falsa.

 Um closure automático permite atrasar a avaliação, porque o código interno não é executado até que você chame o closure. Atrasar a avaliação é útil para código que tem efeitos colaterais ou é computacionalmente caro, porque permite controlar quando esse código é avaliado. O código abaixo mostra como um encerramento atrasa a avaliação.
 */

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// Prints "5"

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// Prints "5"
print("Now serving \(customerProvider())!")
// Prints "Now serving Chris!"
print(customersInLine.count)
// Prints "4"

/*:
 Mesmo que o primeiro elemento do array clientsInLine seja removido pelo código dentro do closure, o elemento do array não é removido até que o closure seja realmente chamado. Se a closure nunca for chamada, a expressão dentro da closure nunca será avaliada, o que significa que o elemento do array nunca é removido. Observe que o tipo de customerProvider não é String, mas () -> String uma função sem parâmetros que retorna uma string.

 Você obtém o mesmo comportamento de avaliação atrasada quando passa um closure como argumento para uma função.
 */

// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
// Prints "Now serving Alex!"


/*:
 A função serve(customer:) na listagem acima usa um closure explícito que retorna o nome de um cliente. A versão de serve(customer:) abaixo executa a mesma operação, mas, em vez de fazer um closure explícito, faz um autoclosure marcando o tipo de seu parâmetro com o atributo @autoclosure.
 Agora você pode chamar a função como se ela recebesse um argumento String em vez de um closure.
 O argumento é convertido automaticamente em um closure, porque o tipo do parâmetro customerProvider é marcado com o atributo @autoclosure.
 
 */

// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
// Prints "Now serving Ewa!"


/*:
 > O uso excessivo de autoclosures pode tornar seu código difícil de entender. O contexto e o nome da função devem deixar claro que a avaliação está sendo adiada.
 
 
 Se você quiser um autoclosure com permissão de escape, use os atributos @autoclosure e @escaping. O atributo @escaping é descrito acima em [Escape Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID546).
 */

// customersInLine is ["Barry", "Daniella"]
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("Collected \(customerProviders.count) closures.")
// Prints "Collected 2 closures."
for customerProvider in customerProviders {
    print("Now serving \(customerProvider())!")
}
// Prints "Now serving Barry!"
// Prints "Now serving Daniella!"


/*:
 No código acima, em vez de chamar o closure passado para ele como seu argumento customerProvider, a função collectCustomerProviders(_:) anexa o closure à matriz customerProviders. A matriz é declarada fora do escopo da função, o que significa que os closures na matriz podem ser executados após o retorno da função. Como resultado, o valor do argumento customerProvider deve poder escapar do escopo da função.
 */



