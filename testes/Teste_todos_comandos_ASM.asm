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