`timescale 1ns / 1ps
module testbench;
    reg clk; reg rst;
    wire [31:0] pc_out; wire [31:0] instruction_in;

    // Fios para a memória de dados
    wire MemRead, MemWrite;
    wire [31:0] data_mem_address, data_mem_in, data_mem_out;

    // Variável para o laço 'for' de impressão
    integer i;

    // Instanciação do Processador (com as novas portas)
    riscv_processor DUT (
        .clk(clk), .rst(rst), .pc_out(pc_out), .instruction_in(instruction_in),
        .MemRead(MemRead), .MemWrite(MemWrite), .data_mem_address(data_mem_address),
        .data_mem_in(data_mem_in), .data_mem_out(data_mem_out)
    );

    // Instanciação da Memória (com as novas portas)
    memory MEM (
        .clk(clk), .inst_addr(pc_out), .inst_out(instruction_in),
        .MemRead(MemRead), .MemWrite(MemWrite), .data_addr(data_mem_address),
        .data_in(data_mem_in), .data_out(data_mem_out)
    );

    // Geração do Clock e Sequência de Simulação (sem alterações)
    initial begin clk = 1'b0; forever #5 clk = ~clk; end
    initial begin
        $monitor("Tempo: %0t | PC: %h | Instrucao: %h | RegWrite: %b | MemWrite: %b | ALU_Res: %h | wb_data: %h",
                 $time, DUT.pc_reg, instruction_in, DUT.RegWrite, MemWrite, DUT.alu_result, DUT.write_data_reg);
        $display("Iniciando..."); rst = 1'b1; #20; rst = 1'b0; $display("Reset liberado.");
        // ======================================================
        // === ESTA LINHA EXISTE PARA FORÇAR UM VALOR INICIAL ===
        DUT.reg_file_inst.registers[5] = 32'd100; // x5 = 100
        // ======================================================
        #200;
        $display("\n--- Simulacao Concluida ---");
        $display("Estado final dos Registradores:");
        for (i = 0; i < 32; i = i + 1) begin
            $display("x%0d = %h", i, DUT.reg_file_inst.registers[i]);
        end
        $finish;
    end
endmodule