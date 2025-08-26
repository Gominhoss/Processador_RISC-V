// Módulo da Unidade de Controle Principal
// É um bloco puramente combinacional que decodifica a instrução
// e gera os sinais de controle para o resto do caminho de dados.

module control_unit (
    // Entrada
    input  [6:0] opcode, // Os 7 bits do opcode da instrução atual

    // Saídas (os sinais de controle)
    output reg       RegWrite,  // '1' para habilitar escrita no banco de registradores
    output reg [1:0] ALUOp,     // Sinal de 2 bits para o controle da ULA
    output reg       ALUSrc,    // '0': ULA opB vem do registrador; '1': vem do imediato
    output reg       MemRead,   // '1' para habilitar leitura da memória de dados
    output reg       MemWrite,  // '1' para habilitar escrita na memória de dados
    output reg       MemtoReg,  // '0': dado para registrador vem da ULA; '1': vem da memória
    output reg       Branch     // '1' se a instrução for um desvio (beq)
);

    // Bloco combinacional que reage a mudanças no opcode.
    always @(*) begin
        // A instrução "case" olha para o opcode e define todos os sinais de controle
        // de acordo com a instrução que ele representa.
        case (opcode)
            // Instruções do Tipo R: `sub`, `or`, `srl`
            7'b0110011: begin
                RegWrite = 1'b1; // Escreve o resultado no registrador
                ALUOp    = 2'b10; // Diz à ULA para fazer uma operação do Tipo R
                ALUSrc   = 1'b0; // O segundo operando da ULA vem de um registrador
                MemRead  = 1'b0; // Não lê da memória
                MemWrite = 1'b0; // Não escreve na memória
                MemtoReg = 1'b0; // O resultado vem da ULA
                Branch   = 1'b0; // Não é um desvio
            end
            
            // Instrução de Load: `lh` (load halfword)
            7'b0000011: begin
                RegWrite = 1'b1; // Escreve o dado lido no registrador
                ALUOp    = 2'b00; // Diz à ULA para fazer uma SOMA (cálculo de endereço)
                ALUSrc   = 1'b1; // O segundo operando da ULA vem do imediato
                MemRead  = 1'b1; // LÊ da memória
                MemWrite = 1'b0; // Não escreve na memória
                MemtoReg = 1'b1; // O resultado vem da MEMÓRIA
                Branch   = 1'b0; // Não é um desvio
            end
            
            // Instrução de Store: `sh` (store halfword)
            7'b0100011: begin
                RegWrite = 1'b0; // NÃO escreve no registrador
                ALUOp    = 2'b00; // Diz à ULA para fazer uma SOMA (cálculo de endereço)
                ALUSrc   = 1'b1; // O segundo operando da ULA vem do imediato
                MemRead  = 1'b0; // Não lê da memória
                MemWrite = 1'b1; // ESCREVE na memória
                MemtoReg = 1'b0; // Irrelevante, pois não há escrita no registrador
                Branch   = 1'b0; // Não é um desvio
            end
            
            // Instrução Imediata: `andi`
            7'b0010011: begin
                RegWrite = 1'b1; // Escreve o resultado no registrador
                ALUOp    = 2'b00; // Diz à ULA para fazer uma operação do tipo I (a ALU Control vai decifrar o AND)
                ALUSrc   = 1'b1; // O segundo operando da ULA vem do imediato
                MemRead  = 1'b0; // Não lê da memória
                MemWrite = 1'b0; // Não escreve na memória
                MemtoReg = 1'b0; // O resultado vem da ULA
                Branch   = 1'b0; // Não é um desvio
            end

            // Instrução de Desvio Condicional: `beq`
            7'b1100011: begin
                RegWrite = 1'b0; // NÃO escreve no registrador
                ALUOp    = 2'b01; // Diz à ULA para fazer uma SUBTRAÇÃO para comparar
                ALUSrc   = 1'b0; // O segundo operando da ULA vem de um registrador
                MemRead  = 1'b0; // Não lê da memória
                MemWrite = 1'b0; // Não escreve na memória
                MemtoReg = 1'b0; // Irrelevante
                Branch   = 1'b1; // É um DESVIO
            end

            // Caso padrão: se o opcode não for reconhecido, desliga tudo por segurança.
            default: begin
                RegWrite = 1'b0;
                ALUOp    = 2'b00;
                ALUSrc   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch   = 1'b0;
            end
        endcase
    end

endmodule