# Processador RISC-V de Ciclo Único em Verilog

## Visão Geral

Este projeto consiste na implementação de um processador RISC-V de 32 bits com um caminho de dados de ciclo único, desenvolvido como parte do trabalho prático da disciplina de **CSI211 - Fundamentos de Organização e Arquitetura de Computadores** na Universidade Federal de Ouro Preto (UFOP).

O design do processador foi baseado no diagrama de caminho de dados apresentado na Figura 4.21 do livro texto da disciplina, adaptado para um subconjunto específico de instruções.

### Conjunto de Instruções Implementado (Grupo 32)

O processador foi projetado para decodificar e executar corretamente o seguinte conjunto de 7 instruções do padrão RISC-V:

| Tipo        | Instrução | Descrição                               |
| :---------- | :-------- | :---------------------------------------- |
| Load        | `lh`      | Carrega uma meia-palavra (16 bits) da memória. |
| Store       | `sh`      | Armazena uma meia-palavra (16 bits) na memória. |
| Tipo-R      | `sub`     | Subtrai o conteúdo de dois registradores. |
| Tipo-R      | `or`      | Realiza a operação OU bit a bit.           |
| Tipo-I      | `andi`    | Realiza a operação E bit a bit com um imediato. |
| Tipo-R      | `srl`     | Realiza o deslocamento lógico de bits para a direita. |
| Tipo-SB     | `beq`     | Realiza um desvio condicional se dois registradores forem iguais. |

## Estrutura do Projeto

O design foi modularizado em vários arquivos Verilog para organização e clareza, representando os principais blocos lógicos de um processador:

-   `riscv_processor.v`: O módulo de topo que conecta todos os outros componentes.
-   `control_unit.v`: A unidade de controle principal, responsável por decodificar o opcode da instrução e gerar os sinais de controle.
-   `alu_control.v`: Unidade de controle secundária que gera o sinal específico para a ULA com base no `ALUOp` e nos campos `funct`.
-   `alu.v`: A Unidade Lógica e Aritmética, que executa as operações de cálculo.
-   `reg_file.v`: O banco de registradores que armazena o estado dos 32 registradores do processador.
-   `memory.v`: Um módulo que simula uma memória unificada para instruções e dados.
-   `datapath_components.v`: Contém componentes auxiliares como multiplexadores, o gerador de imediato e somadores.
-   `testbench.v`: O ambiente de simulação usado para verificar a funcionalidade do processador, pré-carregando um programa e monitorando a execução.

## Como Compilar e Executar
#### Pré-requisito: Tenha o Icarus Verilog instalado e configurado no seu sistema.

### **Primeira forma de rodar o código**:

1.  **Rodar o arquivo .bat:** Nesse repositório existe um arquivo chamado compila_e_executa_iterativo.bat. Ao rodar ele você escolhe que tipo de teste fará de acordo com os dois testes que estão na pasta /testes

### **Segunda forma de rodar o código**:

1.  **Preparar o Teste:** Certifique-se de que o arquivo `program.mem` contém o programa em hexadecimal que você deseja executar. Você pode usar o script `compila_e_executa_iterativo.bat` para escolher entre os testes pré-definidos.
2.  **Compilar:** No terminal, na pasta raiz do projeto, execute o comando:
    ```bash
    iverilog -o meu_processador.vvp testbench.v riscv_processor.v memory.v control_unit.v alu_control.v datapath_components.v reg_file.v alu.v
    ```
3.  **Executar:** Após a compilação bem-sucedida, execute a simulação com:
    ```bash
    vvp meu_processador.vvp
    ```
    A saída da simulação, incluindo o estado final dos registradores, será exibida no terminal.

## Verificação e Testes

Dois programas de teste foram criados para validar o design:

-   **`Teste_simples.txt`**: Realiza uma verificação fundamental das operações aritméticas (`or`, `andi`, `sub`) e do ciclo completo de acesso à memória (`sh` e `lh`).
-   **`Teste_todos_comandos.txt`**: Um teste de estresse que utiliza todas as 7 instruções implementadas de forma interdependente, validando a lógica de deslocamento de bits (`srl`) e o controle de fluxo com desvios condicionais (`beq`).

Ambos os testes foram executados com sucesso, e os resultados nos registradores corresponderam aos valores esperados, validando a correção funcional do processador.