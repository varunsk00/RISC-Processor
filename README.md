# team-a-3130
## 32-Bit, 5-Stage RISC Processor
### Created by: Varun Kosgi

Processor Instruction Set:
add $rd, $rs, $rt
addi $rd, $rs, N
sub $rd, $rs, $rt
and $rd, $rs, $rt
or $rd, $rd, $rt
sll $rd, $rs, shamt
sra $rd, $rs, shamt
sw $rd, N($rs)
lw $rd, N($rs)
j T
bne $rd, $rs, N
jal T
jr $rd
blt $rd, $rs, N
bex T
setx T

(not implemented but planned for future)
mul $rd, $rd, $rt
div $rd, $rs, $rt

Processor Features:
Stall and WX Bypass Logic for Data Hazard avoidance
Brnach Recovery implementation

Known Bugs:
Exceptions are not loaded into the status register in its current state (but the status register logic for bex and setx is still implemented)
store word instruction must be followed by a nop (add $0, $0, $0) coded within the assembly file in order to work properly.
