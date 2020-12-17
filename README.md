## 32-Bit, 5-Stage RISC Processor
### Created by: Varun Kosgi

### Processor Instruction Set:

* add $rd, $rs, $rt
* addi $rd, $rs, N
* sub $rd, $rs, $rt
* and $rd, $rs, $rt
* or $rd, $rd, $rt
* sll $rd, $rs, shamt
* sra $rd, $rs, shamt
* sw $rd, N($rs)
* lw $rd, N($rs)
* j T
* bne $rd, $rs, N
* jal T
* jr $rd
* blt $rd, $rs, N
* bex T
* setx T
* mul $rd, $rd, $rt
* div $rd, $rs, $rt

### ALU Implementation
This Arithmetic Logic Unit consists of:
* 32-Bit Carry Select Adder/Subtractor formed of four 8-bit Carry Look Ahead blocks. The subtractor support comparisons between two bits (isNotEqual, isLessThan)
* Generate function (Bitwise AND)
* Propagate function (Bitwise OR)
* 32-Bit Left Logical Shifter (Barrel style implementation with five "shift-left-by-X-or-0" (x = 16, 8, 4, 2, 1))
* 32-Bit Right Arithmetic Shifter (Barrel style implementation with five "shift-left-by-X-or-0" (x = 16, 8, 4, 2, 1))

OpCode Table:
* add = 00000
* sub = 00001
* and = 00010
* or  = 00011	
* sll = 00100
* sra = 00101	

### Register File Implementation
This Register File Unit consists of:
* 32 Clocked Registers, each of which supports 32-bit values
* 2 Read Ports
* 1 Write Port
* 32-Bit Decoder (5:32)
* Reset functionality for all stored memory elements (D Flip Flops)
* A tri-state buffer implementation for quickly selecting the correct register's output

### Multiplier/Divider Implementation
32-Bit Signed Multiplier

Modified Booth's algorithm that checks multiplier bits two at a time (along with a third helper bit).
Implements the follwing actions on a running 65-bit product register (LSB implicit 0) based on three multiplier bits:
000: middle of run of 0s, do nothing
100: beginning of run of 1s, subtract multiplicand<<1
010: singleton 1, add multiplicand
110: beginning of run of 1s, subtract multiplicand
001: end of run of 1s, add multiplicand
101: end of run of 1s, beginning of another, subtract multiplicand
011: end of a run of 1s, add multiplicand<<1 (M*2)
111: middle of run of 1s, do nothing

All additions/subtractions were implemented with a modified ALU 
Multiplication Overflow Logic is implemented by checking if any bit within the upper half of the 65-bit product register is not expected for a signed integer multiplication, meaning the large numerical product has "spilled" out of a 32-bit universe and into a 64-bit one.

32-Bit Signed Divider

Non-Restoring Division algorithm that shifts a 64-bit register (Remainder/Quotient) left by 1 each cycle
The sign bit of the remainder is used to determine whether to add or subtract the devisor from the remainder
The LSB of the quotient is then set to the complement of the MSB of the newly shifted remainder
At the end of the entire algorithm, the sign bit of the final remainder is then used to determine wheter or not to add the divisor one last time to the remainder.
Signed division is handled by converting all negative divisors and dividends to positive ones, and then negating the end quotient based on the expected ouput. For example, a positive dividend and negative divisor should yield a negative quotient, while a negative divisor and dividend should yield a positive quotient.

### Processor Features:
* Stall and WX Bypass Logic for Data Hazard avoidance
* Branch Recovery implementation

### Known Bugs:
* Exceptions are not loaded into the status register in its current state (but the status register logic for bex and setx is still implemented)
* store word instruction must be followed by a nop (add $0, $0, $0) coded within the assembly file in order to work properly.
