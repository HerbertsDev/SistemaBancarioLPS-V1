// Projeto Final LPS
// Sistema Bancário em Swift
// Mack Bank

import Foundation


// MARK: - Estrutura da Conta

struct Conta {
    var numero: String
    var titular: String
    var senha: String
    var saldo: Double
    var isAdmin: Bool
}


// MARK: - Funções


// Verifica se já existe uma conta com o número informado
func contaExiste(
    numero: String,
    contas: [Conta]
) -> Bool {

    return contas.contains { conta in
        conta.numero == numero
    }
}


// Cria uma nova conta
func criarConta(
    numero: String,
    titular: String,
    senha: String,
    saldoInicial: Double,
    contas: inout [Conta]
) {

    let novaConta = Conta(
        numero: numero,
        titular: titular,
        senha: senha,
        saldo: saldoInicial,
        isAdmin: false
    )

    contas.append(novaConta)
}


// Autentica uma conta pelo número e senha
func autenticar(
    numero: String,
    senha: String,
    contas: [Conta]
) -> Int? {

    return contas.firstIndex { conta in
        conta.numero == numero &&
        conta.senha == senha
    }
}


// Procura uma conta pelo número
func buscarConta(
    numero: String,
    contas: [Conta]
) -> Int? {

    return contas.firstIndex { conta in
        conta.numero == numero
    }
}


// Realiza um depósito
func depositar(
    valor: Double,
    indiceConta: Int,
    contas: inout [Conta]
) -> Bool {

    if valor <= 0 {
        return false
    }

    contas[indiceConta].saldo += valor

    return true
}


// Realiza uma transferência entre contas
func transferir(
    valor: Double,
    indiceOrigem: Int,
    indiceDestino: Int,
    contas: inout [Conta]
) -> Bool {

    if valor <= 0 {
        return false
    }

    if indiceOrigem == indiceDestino {
        return false
    }

    if contas[indiceOrigem].saldo < valor {
        return false
    }

    contas[indiceOrigem].saldo -= valor
    contas[indiceDestino].saldo += valor

    return true
}


// Altera a senha de uma conta
func alterarSenha(
    novaSenha: String,
    indiceConta: Int,
    contas: inout [Conta]
) -> Bool {

    if novaSenha.isEmpty {
        return false
    }

    contas[indiceConta].senha = novaSenha

    return true
}


// Remove uma conta
func removerConta(
    numero: String,
    contas: inout [Conta]
) -> Bool {

    guard let indice = contas.firstIndex(where: { conta in
        conta.numero == numero
    }) else {
        return false
    }

    // Impede a remoção da conta administrativa
    if contas[indice].isAdmin {
        return false
    }

    contas.remove(at: indice)

    return true
}


// Formata valores monetários
func formatarMoeda(_ valor: Double) -> String {

    return String(format: "R$ %.2f", valor)
}


// MARK: - Administrador

let admin = Conta(
    numero: "0000",
    titular: "Administrador",
    senha: "admin",
    saldo: 0.0,
    isAdmin: true
)


// MARK: - Banco de Dados

// O array representa o banco de dados do sistema.
var contas: [Conta] = [
    admin
]


// MARK: - Controle do Sistema

var sistemaExecutando = true


// MARK: - Sistema Principal

while sistemaExecutando {

    print(
        """

        ==================================
                 MACK BANK
        ==================================

        1 - Criar nova conta
        2 - Entrar
        3 - Sair do programa

        ==================================
        """
    )

    print("Escolha uma opção:", terminator: " ")

    let opcao = readLine() ?? ""


    switch opcao {


    // MARK: - Criar Conta

    case "1":

        print(
            """

            ================================
                 CRIAR NOVA CONTA
            ================================
            """
        )


        print("Número da conta:", terminator: " ")
        let numero = readLine() ?? ""


        if numero.isEmpty {

            print("\nO número da conta não pode estar vazio.")
            continue
        }


        if contaExiste(
            numero: numero,
            contas: contas
        ) {

            print("\nJá existe uma conta com esse número.")
            continue
        }


        print("Nome do titular:", terminator: " ")
        let titular = readLine() ?? ""


        if titular.isEmpty {

            print("\nO nome do titular não pode estar vazio.")
            continue
        }


        print("Senha:", terminator: " ")
        let senha = readLine() ?? ""


        if senha.isEmpty {

            print("\nA senha não pode estar vazia.")
            continue
        }


        print("Saldo inicial: R$", terminator: " ")
        let saldoTexto = readLine() ?? ""


        guard let saldoInicial = Double(saldoTexto) else {

            print("\nDigite um valor válido para o saldo.")
            continue
        }


        if saldoInicial < 0 {

            print("\nO saldo inicial não pode ser negativo.")
            continue
        }


        criarConta(
            numero: numero,
            titular: titular,
            senha: senha,
            saldoInicial: saldoInicial,
            contas: &contas
        )


        print(
            """

            Conta criada com sucesso!

            Número: \(numero)
            Titular: \(titular)
            Saldo inicial: \(formatarMoeda(saldoInicial))

            """
        )


    // MARK: - Login

    case "2":

        print(
            """

            ================================
                       LOGIN
            ================================
            """
        )


        print("Número da conta:", terminator: " ")
        let numero = readLine() ?? ""


        print("Senha:", terminator: " ")
        let senha = readLine() ?? ""


        if let indiceConta = autenticar(
            numero: numero,
            senha: senha,
            contas: contas
        ) {

            let contaLogada = contas[indiceConta]


            print(
                """

                Login realizado com sucesso!

                Bem-vindo, \(contaLogada.titular)!

                """
            )


            // ==================================
            // ADMINISTRADOR
            // ==================================

            if contaLogada.isAdmin {

                var adminLogado = true


                while adminLogado {

                    print(
                        """

                        ==================================
                           MENU DO ADMINISTRADOR
                        ==================================

                        1 - Listar todas as contas
                        2 - Remover conta
                        3 - Logout

                        ==================================
                        """
                    )


                    print(
                        "Escolha uma opção:",
                        terminator: " "
                    )


                    let opcaoAdmin = readLine() ?? ""


                    switch opcaoAdmin {


                    // MARK: Listar Contas

                    case "1":

                        print(
                            """

                            ==================================
                                CONTAS CADASTRADAS
                            ==================================
                            """
                        )


                        for conta in contas {

                            let tipoConta: String

                            if conta.isAdmin {
                                tipoConta = "Administrador"
                            } else {
                                tipoConta = "Usuário"
                            }


                            print(
                                """

                                ------------------------------
                                Titular: \(conta.titular)
                                Número: \(conta.numero)
                                Saldo: \(formatarMoeda(conta.saldo))
                                Tipo: \(tipoConta)
                                """
                            )
                        }


                        print(
                            """

                            ------------------------------
                            Total de contas: \(contas.count)

                            """
                        )


                    // MARK: Remover Conta

                    case "2":

                        print(
                            """

                            ================================
                                  REMOVER CONTA
                            ================================
                            """
                        )


                        print(
                            "Número da conta que deseja remover:",
                            terminator: " "
                        )


                        let numeroRemover = readLine() ?? ""


                        guard let indiceRemover = buscarConta(
                            numero: numeroRemover,
                            contas: contas
                        ) else {

                            print("\nConta não encontrada.")
                            continue
                        }


                        if contas[indiceRemover].isAdmin {

                            print(
                                "\nA conta de administrador não pode ser removida."
                            )

                            continue
                        }


                        let titularRemovido =
                            contas[indiceRemover].titular


                        if removerConta(
                            numero: numeroRemover,
                            contas: &contas
                        ) {

                            print(
                                """

                                Conta removida com sucesso!

                                Titular: \(titularRemovido)
                                Número: \(numeroRemover)

                                """
                            )

                        } else {

                            print(
                                "\nNão foi possível remover a conta."
                            )
                        }


                    // MARK: Logout Admin

                    case "3":

                        print(
                            """

                            Logout do administrador realizado.
                            Voltando ao menu inicial...

                            """
                        )

                        adminLogado = false


                    default:

                        print(
                            "\nOpção inválida. Digite 1, 2 ou 3."
                        )
                    }
                }


            // ==================================
            // USUÁRIO COMUM
            // ==================================

            } else {

                var usuarioLogado = true


                while usuarioLogado {

                    print(
                        """

                        ==================================
                              MENU DO CLIENTE
                        ==================================

                        Olá, \(contas[indiceConta].titular)!

                        1 - Ver meus dados e saldo
                        2 - Depositar
                        3 - Transferir
                        4 - Alterar senha
                        5 - Logout

                        ==================================
                        """
                    )


                    print(
                        "Escolha uma opção:",
                        terminator: " "
                    )


                    let opcaoUsuario = readLine() ?? ""


                    switch opcaoUsuario {


                    // MARK: Ver Dados

                    case "1":

                        print(
                            """

                            ================================
                                  DADOS DA CONTA
                            ================================

                            Titular: \(contas[indiceConta].titular)
                            Número: \(contas[indiceConta].numero)
                            Saldo: \(formatarMoeda(contas[indiceConta].saldo))

                            ================================
                            """
                        )


                    // MARK: Depositar

                    case "2":

                        print(
                            """

                            ================================
                                     DEPÓSITO
                            ================================
                            """
                        )


                        print(
                            "Valor do depósito: R$",
                            terminator: " "
                        )


                        let valorTexto = readLine() ?? ""


                        guard let valor = Double(valorTexto) else {

                            print("\nValor inválido.")
                            continue
                        }


                        if depositar(
                            valor: valor,
                            indiceConta: indiceConta,
                            contas: &contas
                        ) {

                            print(
                                """

                                Depósito realizado com sucesso!

                                Valor depositado: \(formatarMoeda(valor))
                                Novo saldo: \(formatarMoeda(contas[indiceConta].saldo))

                                """
                            )

                        } else {

                            print(
                                "\nO valor do depósito deve ser maior que zero."
                            )
                        }


                    // MARK: Transferir

                    case "3":

                        print(
                            """

                            ================================
                                  TRANSFERÊNCIA
                            ================================
                            """
                        )


                        print(
                            "Número da conta de destino:",
                            terminator: " "
                        )


                        let numeroDestino = readLine() ?? ""


                        guard let indiceDestino = buscarConta(
                            numero: numeroDestino,
                            contas: contas
                        ) else {

                            print(
                                "\nConta de destino não encontrada."
                            )

                            continue
                        }


                        if indiceDestino == indiceConta {

                            print(
                                "\nVocê não pode transferir para a própria conta."
                            )

                            continue
                        }


                        print(
                            "Valor da transferência: R$",
                            terminator: " "
                        )


                        let valorTexto = readLine() ?? ""


                        guard let valor = Double(valorTexto) else {

                            print("\nValor inválido.")
                            continue
                        }


                        if transferir(
                            valor: valor,
                            indiceOrigem: indiceConta,
                            indiceDestino: indiceDestino,
                            contas: &contas
                        ) {

                            print(
                                """

                                Transferência realizada com sucesso!

                                Destino: \(contas[indiceDestino].titular)
                                Valor: \(formatarMoeda(valor))
                                Saldo atual: \(formatarMoeda(contas[indiceConta].saldo))

                                """
                            )

                        } else {

                            print(
                                """

                                Não foi possível realizar a transferência.

                                Verifique:
                                - se o valor é maior que zero;
                                - se existe saldo suficiente.

                                """
                            )
                        }


                    // MARK: Alterar Senha

                    case "4":

                        print(
                            """

                            ================================
                                  ALTERAR SENHA
                            ================================
                            """
                        )


                        print(
                            "Senha atual:",
                            terminator: " "
                        )


                        let senhaAtual = readLine() ?? ""


                        if senhaAtual != contas[indiceConta].senha {

                            print(
                                "\nSenha atual incorreta."
                            )

                            continue
                        }


                        print(
                            "Nova senha:",
                            terminator: " "
                        )


                        let novaSenha = readLine() ?? ""


                        if novaSenha.isEmpty {

                            print(
                                "\nA nova senha não pode estar vazia."
                            )

                            continue
                        }


                        print(
                            "Confirme a nova senha:",
                            terminator: " "
                        )


                        let confirmacaoSenha =
                            readLine() ?? ""


                        if novaSenha != confirmacaoSenha {

                            print(
                                "\nAs senhas não coincidem."
                            )

                            continue
                        }


                        if alterarSenha(
                            novaSenha: novaSenha,
                            indiceConta: indiceConta,
                            contas: &contas
                        ) {

                            print(
                                "\nSenha alterada com sucesso!"
                            )

                        } else {

                            print(
                                "\nNão foi possível alterar a senha."
                            )
                        }


                    // MARK: Logout Usuário

                    case "5":

                        print(
                            """

                            Logout realizado com sucesso.
                            Voltando ao menu inicial...

                            """
                        )

                        usuarioLogado = false


                    default:

                        print(
                            "\nOpção inválida. Digite de 1 a 5."
                        )
                    }
                }
            }


        } else {

            print(
                """

                Número da conta ou senha incorretos.

                """
            )
        }


    // MARK: - Sair

    case "3":

        print(
            """

            Obrigado por utilizar o Mack Bank!
            Encerrando o sistema...

            """
        )

        sistemaExecutando = false


    // MARK: - Opção Inválida

    default:

        print(
            """

            Opção inválida.
            Digite 1, 2 ou 3.

            """
        )
    }
}