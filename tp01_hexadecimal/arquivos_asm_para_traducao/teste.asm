# Coloca o valor 10 no registrador x2
addi x2, x0, 10
# Coloca o valor 20 no registrador x3
addi x3, x0, 20
# Agora, x1 vai receber 10 + 20
add x1, x2, x3
# x4 vai receber 20 - 10
sub x4, x3, x2