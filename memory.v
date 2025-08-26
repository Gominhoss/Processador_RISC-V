// Módulo de Memória Unificada (para Instruções e Dados)
// Simula um bloco de memória RAM.

module memory (
    input         clk,         // Clock para sincronizar a escrita

    // Interface com a Memória de Instrução
    input  [31:0] inst_addr,   // Endereço vindo do PC
    output [31:0] inst_out,    // Instrução de 32 bits lida

    // Interface com a Memória de Dados
    input         MemRead,     // Sinal de controle para ler dados
    input         MemWrite,    // Sinal de controle para escrever dados
    input  [31:0] data_addr,   // Endereço vindo da ULA (para lw/sw)
    input  [31:0] data_in,     // Dado a ser escrito (vindo do registrador rs2)
    output [31:0] data_out     // Dado lido da memória (para ser escrito no registrador)
);

    // Declara a memória principal.
    // armazém de 256 gavetas de 4 bytes (32 bits), o que corresponde ao tamanho exato de uma instrução
    // Usamos bytes porque o RISC-V é "byte-addressable".
    reg [31:0] mem[0:255];

    // Lógica de Leitura de Instrução (combinacional)
    // O processador sempre precisa buscar a próxima instrução.
    // A instrução de 32 bits é formada pela junção de 4 bytes da memória.
    // Nota: O endereço do PC é um endereço de byte, por isso o usamos diretamente.
    assign inst_out = mem[inst_addr >> 2];

    // Lógica de Leitura de Dados (combinacional, mas habilitada por MemRead)
    // Para simplificar, vamos ler uma palavra inteira (32 bits) mesmo para `lh`.
    // O processador (que não faremos em detalhe) seria responsável por extrair os bits corretos.
    assign data_out = MemRead ? mem[data_addr >> 2] : 32'bz;
	 
    // Lógica de Escrita de Dados (síncrona)
    // Só escreve na borda de subida do clock se MemWrite estiver ativo.
    always @(posedge clk) begin
        if (MemWrite) begin
            // Para `sh` (store halfword), escrevemos 2 bytes (16 bits).
            mem[data_addr >> 2] <= data_in;
        end
    end
    
    // Tarefa para carregar o programa na memória no início da simulação
    // Esta não é uma parte do hardware, mas uma instrução para o simulador.
    initial begin
        $readmemh("program.mem", mem);
    end

endmodule