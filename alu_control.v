// Módulo da Unidade de Controle da ULA
// Traduz o sinal ALUOp e os campos de função
module alu_control (
    input  [1:0]  ALUOp,
    input  [6:0]  funct7,
    input  [2:0]  funct3,
    output reg [3:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = (funct3 == 3'b111) ? 4'b0010 : 4'b0000; // ANDI ou SOMA
            2'b01: ALUControl = 4'b0001; // BEQ (SUB)
            2'b10: begin // Tipo-R
                case (funct3)
                    3'b000: ALUControl = (funct7 == 7'b0100000) ? 4'b0001 : 4'b0000; // SUB ou ADD
                    3'b110: ALUControl = 4'b0011; // OR
                    3'b101: ALUControl = 4'b0101; // SRL
                    default: ALUControl = 4'bxxxx;
                endcase
            end
            default: ALUControl = 4'bxxxx;
        endcase
    end
endmodule