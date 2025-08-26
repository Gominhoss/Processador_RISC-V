// Módulo da Unidade Lógica e Aritmética (ULA)
// É um bloco puramente combinacional, ou seja, uma calculadora.
module alu (
    input  [3:0]  ALUControl, // O "código da operação" de 4 bits
    input  [31:0] A,          // Operando A
    input  [31:0] B,          // Operando B
    output reg [31:0] ALUResult,  // O resultado da operação
    output reg        Zero        // '1' se o resultado for zero
);

    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = A + B;   // SOMA
            4'b0001: ALUResult = A - B;   // SUBTRAÇÃO
            4'b0010: ALUResult = A & B;   // AND
            4'b0011: ALUResult = A | B;   // OR
            4'b0101: ALUResult = A >> B;  // Deslocamento à Direita (SRL)
            default: ALUResult = 32'b0;
        endcase

        if (ALUResult == 32'b0)
            Zero = 1'b1;
        else
            Zero = 1'b0;
    end
endmodule