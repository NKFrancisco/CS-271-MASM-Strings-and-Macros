TITLE Program Template     (template.asm)

; Author: Nick Francisco 
; Last Modified: 5/22/2022
; OSU email address: francnic@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                 Due Date: 6/5/2022
; Description: This program reads in a string and converts and stores them 
;	in an array of SDWORDs, it also prints the SDWORD array as a string, 
;	calculates the sum, and truncated average
;	      

INCLUDE Irvine32.inc


; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Reads string into given array
;
; Preconditions: values passed 
;
; Receives:
; prompt = promt message
; userInput = array to store string
; limit = max length of input accepted
; inputCount = length of input string
;
; returns: 
; userInput = string
; inputCount = string length
;
; ---------------------------------------------------------------------------------
mGetString MACRO prompt, userInput, limit, inputCount
	
	;Save registers used
	PUSH	ECX
	PUSH	EDX

	;Print prompt
	MOV		EDX, prompt
	CALL	WriteString

	;Read string and save input string char count 
	MOV		EDX, userInput
	MOV		ECX, limit
	CALL	ReadString

	;Saving/Returing string input and string count
	MOV		userInput, EDX
	MOV		inputCount, EAX

	;Restore registers
	POP		EDX
	POP		ECX

ENDM


; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Displays string given
;
; Preconditions: striing passed 
;
; Receives:
; string = array that has string
;
; returns: none
;
; ---------------------------------------------------------------------------------
mDisplayString MACRO string
	
	;Save registers used
	PUSH	EDX

	;Print string 
	MOV		EDX, string
	CALL	WriteString 

	;Restore registers
	POP		EDX

ENDM


.data

;Intro messages
introOneMsg		BYTE	"Program Assignment 6: Designing low-level I/O procedures",0
introTwoMsg		BYTE	"Written by: Nick Francisco",0
prmptOneMsg		BYTE	"Please provide 10 signed decimal integers",0
prmptTwoMsg		BYTE	"Each number needs to be small enought to fit inside a 32 bit register. After you have finished",0
prmptThreeMsg	BYTE	"inputting the raw numbers I will display a list of the integers, their sum, and their average",0
prmptFourMsg	BYTE	"value.",0

;Data
getNumMsg		BYTE	"Please enter an signed number: ",0
errMsg			BYTE	"ERROR: You did not enter a signed number or you number was to big.",0	
userInput		BYTE	21 DUP(0)
inputLimit		DWORD	LENGTHOF userInput
sLen			DWORD	?
num				SDWORD	0
signedArray		SDWORD	10 DUP(?)
charArray		DWORD	12 DUP(?)	
revArray		SDWORD	12 DUP(?)
arryCount		SDWORD	LENGTHOF signedArray
sum				SDWORD  ?
avg				SDWORD	?

;Result messages
numMsg			BYTE	"You entered the following numbers:",0
spacer			BYTE	", ",0
sumMsg			BYTE	"The sum of these numbers is:",0
avgMsg			BYTE	"The truncated average is:",0

;Farewell message
byeMsg			BYTE	"Thanks for playing!",0


.code
main PROC

	;Displaying intro ----------------------------------
	PUSH	OFFSET prmptFourMsg
	PUSH	OFFSET prmptThreeMsg
	PUSH	OFFSET prmptTwoMsg
	PUSH	OFFSET prmptOneMsg
	PUSH	OFFSET introTwoMsg
	PUSH	OFFSET introOneMsg
	CALL	introduction
	; --------------------------------------------------

	
	;Get Input -----------------------------------------
	;Setting loop variables 
	MOV		ESI, OFFSET signedArray
	MOV		ECX, arryCount
	MOV		EBX, 0			
_readLoop:
	PUSH	OFFSET num
	PUSH	OFFSET errMsg
	PUSH	OFFSET sLen
	PUSH	inputLimit
	PUSH	OFFSET userInput
	PUSH	OFFSET getNumMsg
	CALL	ReadVal

	;Adding val to array 
	MOV		EAX, num
	MOV		[ESI], EAX
	ADD		ESI, 4
	MOV		num, 0
	LOOP	_readLoop
	CALL	crlf
	; --------------------------------------------------
	

	;Display Input -------------------------------------
	;Display message
	MOV		EDX, OFFSET numMsg
	CALL	WriteString
	CALL	crlf

	;Setting loop variables 
	MOV		ECX, arryCount
	MOV		ESI, OFFSET signedArray

	;Loop through array and call WriteVal for each number
_writeLoop:
	PUSH	OFFSET revArray
	PUSH	OFFSET charArray
	PUSH	[ESI]
	CALL	WriteVal
	ADD		ESI, 4
	;Print space or skip if last element
	CMP		ECX, 1 
	JE		_noSpacer
	MOV		EDX, OFFSET spacer
	CALL	WriteString
_noSpacer:
	LOOP	_writeLoop
	CALL	crlf
	CALL	crlf
	; --------------------------------------------------

	
	;Calculate Sum -------------------------------------
	PUSH	OFFSET revArray
	PUSH	OFFSET charArray
	PUSH	arryCount
	PUSH	OFFSET sumMsg
	PUSH	OFFSET signedArray
	CALL	calcSum
	; --------------------------------------------------
	

	;Calculate Average ---------------------------------
	PUSH	OFFSET revArray
	PUSH	OFFSET charArray
	PUSH	arryCount
	PUSH	OFFSET avgMsg
	PUSH	OFFSET signedArray
	CALL	calcAvg
	; --------------------------------------------------
	

	;Displaying farewell -------------------------------
	CALL	crlf
	PUSH	OFFSET byeMsg
	CALL	farewell
	; --------------------------------------------------

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; --------------------------------------------------------
;Name: introduction

;Description: displays intro and prompt messages

;Preconditions: None

;Postconditions: Registers saved and restored

;Receives: Global variables - intro and prompt messages

;Retuens: None
; --------------------------------------------------------
introduction PROC 

	;Preserve EBP and Assign static stack-frame pointer
	PUSH	EBP         
	MOV		EBP, ESP    

	;Save Registers
	PUSHAD

	;Intro one message
	MOV		EDX, [EBP + 8]	
	CALL	WriteString
	CALL	crlf

	;Intro two message
	MOV		EDX, [EBP + 12]	
	CALL	WriteString
	CALL	crlf
	CALL	crlf

	;Prompt one message
	MOV		EDX, [EBP + 16]	
	CALL	WriteString
	CALL	crlf

	;Prompt two message
	MOV		EDX, [EBP + 20]	
	CALL	WriteString
	CALL	crlf

	;Prompt three message
	MOV		EDX, [EBP + 24]	
	CALL	WriteString
	CALL	crlf

	;Prompt four message
	MOV		EDX, [EBP + 28]	
	CALL	WriteString
	CALL	crlf
	CALL	crlf

	;Restore register
	POPAD

	POP		EBP
	RET		24

introduction ENDP

; --------------------------------------------------------
;Name: ReadVal

;Description: Read string in and converts to SWORD

;Preconditions: None

;Postconditions: Registers saved and restored

;Receives: Global variables - Array, num, prompt, and error msg

;Retuens: SDWORD
; --------------------------------------------------------
ReadVal PROC

	;Preserve EBP and Assign static stack-frame pointer
	PUSH	EBP         
	MOV		EBP, ESP    

	;Save Registers
	PUSHAD

	;[EBP + 8] getNumMsg
	;[EBP + 12] userInput array
	;[EBP + 16] inputLimit
	;[EBP + 20] sLen
	;[EBP + 24] errMsg
	;[EBP + 28] num

_start:

	;Call Macro mGetString
	mGetString	[EBP + 8], [EBP + 12], [EBP + 16], [EBP + 20]

	
	;userInput array to ESI and sLen to ECX for loop
	MOV		ESI, [EBP + 12]
	MOV		ECX, [EBP + 20]

	;Used as bool to check for negative number
	MOV		EDX, 0

;Validate input
	;Check if first char in string is + or -
	MOV		AL, "+"
	CMP		AL, [ESI]
	JE		_plus
	MOV		AL, "-"
	CMP		AL, [ESI]
	JE		_minus

	;No + or -
	JMP		_signComp

_plus:
	;Move to next char in string and Sub 1 from sLen
	ADD		ESI, 1
	SUB		ECX, 1
	JMP		_signComp

_minus:
	;Set negative bool, Move to next char in string, Sub 1 from sLen
	;EDI used for Negative bool
	MOV		EDI, 1			
	ADD		ESI, 1
	SUB		ECX, 1
	JMP		_signComp
	
_signComp:

;Check that all chars are numbers
	;Setting loop counter and registers 
	MOV		EBX, 0			
	;EBX used to store and build number 
	;ECS already has counter 
	;ESI already has string 

_checkChar:
	;Load byte into AL
	LODSB

	;Check if char is a number
	CMP		AL, 48
	JB		_error
	CMP		AL, 57
	JA		_error

	;Char is a number converting ASCII to number
	SUB		AL, 48

	;Building SDWORD
	IMUL	EBX, 10
	JC		_error
	ADD		EBX, EAX
	JC		_error
	LOOP	_checkChar

	;Check negative bool
	CMP		EDI, 1
	JNE		_complete
	IMUL	EBX, -1
	JMP		_complete

_error:
	;Non-Number in string get new num returning to begining
	MOV		EDX, [EBP + 24] 
	CALL	WriteString
	CALL	crlf
	JMP		_start

_complete:

	;Save/Return SWORD
	MOV		EAX, [EBP + 28]
	MOV		[EAX], EBX
	
	;Restore register
	POPAD

	POP		EBP
	RET		24

ReadVal ENDP

; --------------------------------------------------------
;Name: WriteVal

;Description: Writes SDWORD array as string

;Preconditions: None

;Postconditions: Registers saved and restored

;Receives: Global variables - charArray, revArray,  prompt, 
;	and error msg

;Retuens: None
; --------------------------------------------------------
WriteVal PROC

	;Preserve EBP and Assign static stack-frame pointer
	PUSH	EBP         
	MOV		EBP, ESP    

	;Save Registers
	PUSHAD
	
	;Used for loop to count amoutnt of numbers
	MOV		ECX, 0

	;Number is EAX
	MOV		EAX, [EBP + 8]

	;charArry adress in EDI 
	MOV		EDI, [EBP + 12]

	;Check if negative num in EAX
	MOV		EAX, [EBP + 8]
	CMP		EAX, 0
	JGE		_isPosCheckOne

	;Multiply number by -1 to get positive, will add "-" at end 
	IMUL	EAX, -1

	
_isPosCheckOne:

;Determine SDWORD length and convert to ASCII store individual numbers in charArray
	MOV		EBX, 10

	;Add 0 to begining of string
	PUSH	EAX
	MOV		AL, 0
	STOSB	
	POP		EAX

_buildCharArray:
	CDQ		
	IDIV	EBX

	;Convert remainder into ASCII
	ADD		EDX, 48

	;Save remainder in array, increase count
	PUSH	EAX
	MOV		EAX, EDX
	STOSB	;EAX to	[EDI]			
	POP		EAX
	ADD		ECX, 1
	CMP		EAX, 0
	JNE		_buildCharArray


	;Check if negative num 
	MOV		EAX, [EBP + 8]
	CMP		EAX, 0				
	JGE		_isPosCheckTwo

	;EAX 0 after division used to check if negative
	;Add negative char
	MOV		EAX, 0
	MOV		AL, 45
	STOSB
	ADD		ECX, 1

_isPosCheckTwo:
	
;Reverse string 
	;Set up arrays
	ADD		ECX, 1
	MOV		ESI, [EBP + 12]
	ADD		ESI, ECX
	DEC		ESI
	MOV		EDI, [EBP + 16]

_reverse:
	;Reversing byte
	STD
	LODSB
	CLD
	STOSB
	LOOP	_reverse

	;Display reversed string in EDX
	MOV		EDX, [EBP + 16]
	mDisplayString	EDX
	
	;Restore register
	POPAD

	POP		EBP
	RET		12

WriteVal ENDP

; --------------------------------------------------------
;Name: calcSum

;Description: Calculates total for given array

;Preconditions: None

;Postconditions: Registers saved and restored

;Receives: Global variables - signedArray, count, msg, charArray,
;	and revArray

;Retuens: none
; --------------------------------------------------------
calcSum PROC

	PUSH	EBP         
	MOV		EBP, ESP    

	;Save Registers
	PUSHAD

	;Sum Message
	MOV		EDX, [EBP + 12]	
	CALL	WriteString

	;Setting up loop
	MOV		ECX, [EBP + 16] ;array count 
	MOV		ESI, [EBP + 8]	;signedArray
	MOV		EAX, 0

_sumLoop:
	ADD		EAX, [ESI]
	ADD		ESI, 4
	LOOP	_sumLoop

	;Printing sum value
	PUSH	[EBP + 24]		;revArray
	PUSH	[EBP + 20]		;charArray
	PUSH	EAX
	CALL	WriteVal
	CALL	crlf
	CALL	crlf

	;Restore register
	POPAD

	POP		EBP
	RET		20

calcSum ENDP

; --------------------------------------------------------
;Name: calcAvg

;Description: Calculates average for given array

;Preconditions: None

;Postconditions: Registers saved and restored

;Receives: Global variables - signedArray, count, msg, charArray,
;	and revArray

;Retuens: none
; --------------------------------------------------------
calcAvg PROC

	PUSH	EBP         
	MOV		EBP, ESP    

	;Save Registers
	PUSHAD

	;Avg Message
	MOV		EDX, [EBP + 12]	
	CALL	WriteString

	;Setting up loop
	MOV		ECX, [EBP + 16] ;array count 
	MOV		ESI, [EBP + 8]	;signedArray
	MOV		EAX, 0

_avgLoop:
	ADD		EAX, [ESI]
	ADD		ESI, 4
	LOOP	_avgLoop

	MOV		EBX, [EBP + 16]
	CDQ
	IDIV	EBX				;Divid total in EAX by array count

	;Printing sum value
	PUSH	[EBP + 24]		;revArray
	PUSH	[EBP + 20]		;charArray
	PUSH	EAX
	CALL	WriteVal
	CALL	crlf
	CALL	crlf

	;Restore register
	POPAD

	POP		EBP
	RET		20

calcAvg ENDP

; --------------------------------------------------------
;Name: farewell

;Description: displays farewell message

;Preconditions: None

;Postconditions: Registers saved and restored

;Receives: Global variables - byeMsg

;Retuens: None
; --------------------------------------------------------
farewell PROC

	PUSH	EBP         
	MOV		EBP, ESP    

	;Save Registers
	PUSHAD

	;Farewell Message
	MOV		EDX, [EBP + 8]	
	CALL	WriteString
	CALL	crlf

	;Restore register
	POPAD

	POP		EBP
	RET		4

farewell ENDP

END main

