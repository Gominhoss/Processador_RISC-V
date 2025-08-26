@echo off
cls

:menu
echo ===============================================
echo  Escolha um teste para carregar na memoria:
echo ===============================================
echo.
echo 1 - Teste_simples
echo 2 - Teste_todos_comandos
echo.
echo ===============================================
echo.

set /p "choice=Digite o numero do teste (1-2): "

if not '%choice%'=='' set choice=%choice:~0,1%

if /i "%choice%"=="1" (
    echo Copiando "Teste_simples.txt"...
    copy /Y "testes\Teste_simples.txt" "program.mem"
) else if /i "%choice%"=="2" (
    echo Copiando "Teste_todos_comandos.txt"...
    copy /Y "testes\Teste_todos_comandos.txt" "program.mem"
) else (
    echo Opcao invalida. Por favor, escolha um numero de 1 a 5.
    pause
    goto menu
)

echo.
echo Arquivo de teste copiado para program.mem com sucesso!
echo.
echo ===============================================
echo  Compilando e Executando o Processador
echo ===============================================
echo.

iverilog -o meu_processador.vvp testbench.v riscv_processor.v memory.v control_unit.v alu_control.v datapath_components.v reg_file.v alu.v
vvp meu_processador.vvp

echo.
echo ===============================================
echo      Execucao finalizada.
echo ===============================================
pause