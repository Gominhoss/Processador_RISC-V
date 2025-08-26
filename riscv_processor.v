// Módulo Principal do Processador RISC-V de Ciclo Único
// Este módulo conecta todos os componentes do caminho de dados.

module riscv_processor (
    input clk,
    input rst,
    output [31:0] pc_out,
    input  [31:0] instruction_in,
    
    // Portas para a memória de dados
    output       MemRead,
    output       MemWrite,
    output [31:0] data_mem_address,
    output [31:0] data_mem_in,
    input  [31:0] data_mem_out
);

    // Sinais e Fios
    wire       RegWrite; wire [1:0] ALUOp; wire ALUSrc; wire MemtoReg; wire Branch;
    wire [31:0] immediate; wire [31:0] rs1_data; wire [31:0] rs2_data;
    wire [31:0] alu_in_B; wire [31:0] alu_result; wire alu_zero;
    wire [31:0] write_data_reg; wire [31:0] pc_plus_4; wire [31:0] branch_target;
    wire branch_condition; wire [31:0] next_pc; wire [3:0] alu_control_signal;

    // Estágio 1: IF
    reg [31:0] pc_reg;
    assign pc_out = pc_reg;
    adder pc_adder(.A(pc_reg), .B(32'd4), .Sum(pc_plus_4));
    adder branch_addr_adder(.A(pc_reg), .B(immediate), .Sum(branch_target));
    assign branch_condition = Branch & alu_zero;
    mux2_1 pc_mux(.A(pc_plus_4), .B(branch_target), .Sel(branch_condition), .Out(next_pc));
    always @(posedge clk or posedge rst) begin
        if (rst) pc_reg <= 32'b0; else pc_reg <= next_pc;
    end

    // Estágio 2: ID
    control_unit ctrl_unit(.opcode(instruction_in[6:0]), .RegWrite(RegWrite), .ALUOp(ALUOp), .ALUSrc(ALUSrc), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .Branch(Branch));
    reg_file reg_file_inst(.clk(clk), .RegWrite(RegWrite), .rs1_addr(instruction_in[19:15]), .rs2_addr(instruction_in[24:20]), .rd_addr(instruction_in[11:7]), .write_data(write_data_reg), .rs1_data(rs1_data), .rs2_data(rs2_data));
    imm_gen imm_gen_inst(.instruction(instruction_in), .immediate(immediate));

    // Estágio 3: EX
    alu_control alu_ctrl_inst(.ALUOp(ALUOp), .funct7(instruction_in[31:25]), .funct3(instruction_in[14:12]), .ALUControl(alu_control_signal));
    mux2_1 alu_mux(.A(rs2_data), .B(immediate), .Sel(ALUSrc), .Out(alu_in_B));
    alu alu_inst(.ALUControl(alu_control_signal), .A(rs1_data), .B(alu_in_B), .ALUResult(alu_result), .Zero(alu_zero));

    // Estágio 4: MEM
    assign data_mem_address = alu_result; // O endereço da memória é o resultado da ULA
    assign data_mem_in      = rs2_data;   // O dado a ser escrito é o do segundo registrador

    // Estágio 5: WB
    mux2_1 write_back_mux (
        .A(alu_result),
        .B(data_mem_out), // Conectado à saída da memória de dados
        .Sel(MemtoReg), 
        .Out(write_data_reg)
    );
endmodule