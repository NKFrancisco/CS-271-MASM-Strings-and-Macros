# CS-271-MASM-Strings-and-Macros
Input and Output macros for signed integers using an array.

## Assignment Info 
1. User’s numeric input must be validated the hard way:
  - Read the user's input as a string and convert the string to numeric form.
  - If the user enters non-digits other than something which will indicate sign (e.g. ‘+’ or ‘-‘), or the number is too large for 32-bit registers, an error message should be displayed and the number should be discarded.
  - If the user enters nothing (empty input), display an error and re-prompt.
2. ReadInt, ReadDec, WriteInt, and WriteDec are not allowed in this program.
3. Conversion routines must appropriately use the LODSB and/or STOSB operators for dealing with strings.
4. All procedure parameters must be passed on the runtime stack using the STDCall calling convention. Strings also must be passed by reference.
5. Prompts, identifying strings, and other memory locations must be passed by address to the macros.
6. Used registers must be saved and restored by the called procedures and macros.
7. The stack frame must be cleaned up by the called procedure.
8. Procedures (except main) must not reference data segment variables by name. There is a significant penalty attached to violations of this rule.  Some global constants (properly defined using EQU, =, or TEXTEQU and not redefined) are allowed. These must fit the proper role of a constant in a program (master values used throughout a program which, similar to HI and LO in Project 5).
9. The program must use Register Indirect addressing for integer (SDWORD) array elements, and Base+Offset addressing for accessing parameters on the runtime stack.
10. Procedures may use local variables when appropriate.
11. The program must be fully documented and laid out according to the CS271 Style Guide. This includes a complete header block for identification, description, etc., a comment outline to explain each section of code, and proper procedure headers/documentation.
