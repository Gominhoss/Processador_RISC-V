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