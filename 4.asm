INOUT MACRO X,Y
	LEA DX,X
	MOV AH,Y
	INT 21H
	ENDM
DATAS SEGMENT
	;此处输入数据段代码
	ARY DW 0100H,250AH,0FF88H,8660H,40H,9500H,6000H,1200H,8008H,0A200H,2800H,0FF60H,0F50H
	N = ($-ARY)/2
	N2 = ($-ARY)
	V DW 0000H
	COUN DB 00H
	STRR DB 9 DUP(' ')
	CHE DW 10000,1000,100,10,1
	TIPS DB "THESE NUMBERS ARE:",13,10,'$'
	TIPS2 DB "THE AVERGAE IS:",13,10,'$'
	TIPS3 DB "THE NUMBER OF BIGGER THAN AVERAGE IS:",13,10,'$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    DW 128 DUP(0)
    TOPS LABEL WORD
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    INOUT TIPS,9

    MOV AX,STACKS
	MOV SS,AX
	LEA SP,TOPS
	LEA SI,ARY
	MOV CX,N
   
   	L:
	MOV AX,[SI]
	LEA DI,STRR
	CALL CBD
	ADD SI,2
	LOOP L
	
	INOUT TIPS2,9
	
	
	MOV BX,0
	MOV SI,0
	MOV AX,0
	MOV DL,13
	
	
	L3:
	ADD AX,ARY[SI]
	INC SI
	INC SI
	CMP SI,N2
	JNZ L3		
	
	
	MOV BX,000EH
	DIV BX
	AND AX,00FFH
	
	LEA DI,STRR
	CALL CBD
	
	
	MOV V,AX
	
	MOV BX,0
	MOV SI,0
	
	L4:
	MOV AX,ARY[SI]
	CMP AX,V
	JNG L5
	INC BX
	L5:
	INC SI
	INC SI
	CMP SI,N2
	JNZ L4
	
	INOUT TIPS3,9
	
	MOV COUN,BL
	MOV AX,BX
	LEA DI,STRR
	CALL CBD
	  
    MOV AH,4CH
    INT 21H


CBD PROC 
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	PUSH DI
	
	LEA SI,CHE
	OR AX,AX
	JNS PLUS
	MOV BYTE PTR[DI],'-'
	INC DI
	NEG AX
PLUS:
	MOV CX,5
L1:
	MOV BX,[SI]
	MOV DX,0
	DIV BX
	ADD AL,30H
	MOV [DI],AL
	INC DI
	ADD SI,2
	MOV AX,DX
	LOOP L1
L2:
	MOV BYTE PTR[DI],0DH
	INC DI
	MOV BYTE PTR[DI],0AH
	INC DI
	MOV BYTE PTR[DI],'$'
	POP DX
	MOV AH,9
	INT 21H
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
CBD ENDP


CODES ENDS
    END START





