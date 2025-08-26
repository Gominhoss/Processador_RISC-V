# Relatório de Verificação do Processador RISC-V (Grupo 32)

Para validar o processador RISC-V de ciclo único que implementei, desenvolvi uma suíte de testes com o objetivo de verificar a correção funcional de cada componente e do caminho de dados como um todo. A seguir, detalho os dois principais programas de teste que foram executados com sucesso, demonstrando a robustez do design.

A simulação foi realizada em um ambiente onde o registrador `x5` é pré-carregado com o valor `100` (`0x64`) pelo `testbench`, servindo como ponto de partida para a geração de valores não-nulos.

## Teste 1: Verificação Fundamental de Aritmética e Memória

O primeiro teste (`Teste_simples.txt`) foi projetado para ser uma verificação rápida e essencial do fluxo de dados principal, focando nas operações aritméticas básicas e no caminho de acesso à memória.

### Código Assembly (`Teste_simples.txt`)

```assembly
# Teste de verificação simples de SUB, ANDI, OR e acesso à memória

# Carrega 100 (de x5) em x6
or x6, x5, x0

# Cria a constante 4 em x7 (resultado de 100 & 20)
andi x7, x5, 20

# Calcula 100 - 4 = 96 e armazena em x8
sub x8, x6, x7

# Armazena o resultado (96) na memória no endereço 100
sh x8, 0(x5)

# Lê o valor (96) de volta da memória para o registrador x9
lh x9, 0(x5)
```


### Código Hexadecimal (`Teste_simples.txt`)

```hexadecimal
0002e333
0142f393
40730433
00829023
00029483
```



### Objetivo do Teste

O propósito deste teste era garantir que os componentes mais críticos do processador estavam funcionando em sequência.

1.  **Validação da ULA:** Verifiquei se as instruções `or`, `andi` e `sub` eram executadas corretamente pela ULA.
2.  **Integridade do Banco de Registradores:** Confirmei que o resultado de uma operação (`or`) era corretamente escrito em um registrador (`x6`) e podia ser lido como operando para a instrução seguinte (`sub`).
3.  **Caminho de Dados da Memória:** O mais importante, este teste validou todo o ciclo de acesso à memória. A instrução `sh` precisava que o endereço (calculado pela ULA e vindo de `x5`) e o dado (vindo de `x8`) chegassem corretamente à memória. Em seguida, a instrução `lh` precisava ler o mesmo endereço, buscar o dado da memória e garantir que o `mux` de write-back selecionasse a memória como fonte para escrever o valor de volta em `x9`. O sucesso neste teste provou que o coração do processador estava funcional.

## Teste 2: Verificação Completa do Conjunto de Instruções

O segundo teste (`Teste_todos_comandos.txt`) foi o "teste de estresse" final. O objetivo era criar um único programa que utilizasse **todas as 7 instruções** implementadas (`lh`, `sh`, `sub`, `or`, `andi`, `srl`, `beq`) de forma interdependente.

### Código Assembly (`Teste_todos_comandos.txt`)

```assembly
# Teste final de verificação para todas as instruções do Grupo 32

# Bloco 1: Preparação e Lógica
or x6, x5, x0      # x6 = 100 (Copia valor inicial)
andi x7, x5, 12    # x7 = 4   (Cria constante)
sub x8, x6, x7       # x8 = 96  (Teste de SUB)

# Bloco 2: Teste de Memória
sh x8, 0(x5)         # Memória[100] = 96 (Teste de SH)
lh x9, 0(x5)         # x9 = 96 (Teste de LH)

# Bloco 3: Teste de Deslocamento e Desvio
or x10, x9, x0     # x10 = 96 (Copia valor da memória)
andi x11, x5, 4    # x11 = 4  (Cria constante para deslocamento)
srl x12, x10, x11    # x12 = 6  (Teste de SRL: 96 >> 4)
beq x8, x9, 8        # Pula se 96 == 96 (Teste de BEQ)

# Bloco Final (só executa se o BEQ falhar)
sub x13, x5, x5      # Esta linha deve ser pulada
or x0, x0, x0        # NOP para preencher espaço
```

### Código Hexadecimal (`Teste_todos_comandos.txt`)

```hexadecimal
0002e333
00c2f393
40730433
00829023
00029483
0004e533
0042f593
00b55633
00940463
40d686b3
00006033
```

### Objetivo do Teste

Este programa foi desenhado como um "procurador de falhas" para validar a totalidade do meu design:

1.  **Confirmação da Lógica e Memória:** Os primeiros blocos revalidam as operações `or`, `andi`, `sub`, `sh`, e `lh`, garantindo a base do processador.
2.  **Validação da Instrução de Deslocamento:** A instrução `srl` foi testada para garantir que a ULA e o Controle da ULA pudessem lidar com operações de deslocamento de bits, que usam uma combinação diferente de sinais de controle.
3.  **Validação do Controle de Fluxo:** O passo mais crucial foi testar a instrução `beq`. Este teste não apenas verificou se a ULA podia fazer a subtração para a comparação, mas também se o sinal `Zero` era gerado corretamente, se o `branch_condition` era calculado, e se o `mux` do PC selecionava o endereço de desvio correto, alterando o fluxo de execução do programa. O fato de o registrador `x13` ter permanecido `0` ao final da simulação provou que o desvio foi tomado com sucesso, validando todo o mecanismo de controle de fluxo do processador.