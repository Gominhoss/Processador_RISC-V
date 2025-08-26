// Módulo que contém componentes lógicos menores e reutilizáveis do caminho de dados.

// -----------------------------------------------------------------------------
// Multiplexador (Mux) 2 para 1 genérico de 32 bits
// -----------------------------------------------------------------------------
module mux2_1 (
    input  [31:0] A,    // Entrada 0
    input  [31:0] B,    // Entrada 1
    input         Sel,  // Sinal de seleção (0 para A, 1 para B)
    output [31:0] Out   // Saída selecionada
);
    // Lógica combinacional: se Sel for 1, a saída é B; senão, a saída é A.
    assign Out = (Sel == 1'b1) ? B : A;
endmodule

// -----------------------------------------------------------------------------
// Gerador de Imediato (Immediate Generator)
// -----------------------------------------------------------------------------
module imm_gen (
    input  [31:0] instruction, // A instrução completa de 32 bits
    output [31:0] immediate    // O valor imediato de 32 bits, estendido em sinal
);
    // Fios internos para extrair os diferentes formatos de imediato
    wire [31:0] i_imm, s_imm, sb_imm;

    // Decodifica o opcode para determinar o tipo de imediato
    wire [6:0] opcode = instruction[6:0];

    // Formato I (para `lh`, `andi`)
    // O imediato são os 12 bits mais à esquerda da instrução.
    // O bit mais à esquerda (bit 31) é replicado para as posições restantes (extensão de sinal).
    assign i_imm = {{20{instruction[31]}}, instruction[31:20]};

    // Formato S (para `sh`)
    // O imediato é formado pela junção dos bits [31:25] e [11:7].
    assign s_imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

    // Formato SB (para `beq`)
    // O imediato é formado por uma combinação mais complexa de bits, e o bit 0 é sempre 0.
    assign sb_imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};

    // Usa o opcode para selecionar qual formato de imediato deve sair
    // Para o Grupo 32, precisamos dos tipos I, S e SB.
    assign immediate = (opcode == 7'b0000011 || opcode == 7'b0010011) ? i_imm :
                       (opcode == 7'b0100011) ? s_imm :
                       (opcode == 7'b1100011) ? sb_imm :
                       32'b0; // Valor padrão caso o opcode não seja reconhecido

endmodule

// -----------------------------------------------------------------------------
// Somador (Adder) genérico de 32 bits
// -----------------------------------------------------------------------------
module adder (
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] Sum
);
    // A saída é simplesmente a soma das duas entradas.
    assign Sum = A + B;
endmodule