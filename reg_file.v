// Módulo do Banco de Registradores (Register File)
// Armazena os 32 registradores de 32 bits do RISC-V.
// A leitura é assíncrona (instantânea).
// A escrita é síncrona (só acontece na borda de subida do clock).

module reg_file (
    // Entradas
    input         clk,         // O pulso do relógio (clock) que sincroniza a escrita
    input         RegWrite,    // Sinal de controle (1 bit): '1' para permitir a escrita, '0' para proibir
    input  [4:0]  rs1_addr,    // Endereço de 5 bits para a primeira porta de leitura (rs1)
    input  [4:0]  rs2_addr,    // Endereço de 5 bits para a segunda porta de leitura (rs2)
    input  [4:0]  rd_addr,     // Endereço de 5 bits para a porta de escrita (rd)
    input  [31:0] write_data,  // O dado de 32 bits a ser escrito no registrador

    // Saídas
    output [31:0] rs1_data,    // O dado de 32 bits lido do endereço rs1
    output [31:0] rs2_data     // O dado de 32 bits lido do endereço rs2
);

    // Declara a memória principal do banco de registradores.
    reg [31:0] registers[0:31];

    // Variável para o laço 'for' de inicialização. DECLARADA AQUI.
    integer i;

    // Lógica de Leitura Assíncrona (instantânea)
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];

    // Lógica de Escrita Síncrona (controlada pelo clock)
    always @(posedge clk) begin
        if (RegWrite && (rd_addr != 5'b0)) begin
            registers[rd_addr] <= write_data;
        end
    end

    // Bloco de inicialização para a simulação
    // Zera todos os registradores no início para evitar valores 'x'.
    initial begin
        // A declaração de 'i' foi movida para o topo do módulo.
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

endmodule