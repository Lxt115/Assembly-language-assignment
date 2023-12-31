STACKS SEGMENT
    ;此处输入堆栈段代码
	DW 128 DUP(0)
	TOPS LABEL WORD
STACKS ENDS

DATAS SEGMENT
    BUF DW 6F80H,98B0H,-74ABH,-0F88AH
	N = ($-BUF)/2
	STRR DB 9 DUP(' ')
	CHE DW 10000,1000,100,10,1
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
	MOV AX,STACKS
	MOV SS,AX
	LEA SP,TOPS
	LEA SI,BUF
	MOV CX,N
L:
	MOV AX,[SI]
	LEA DI,STRR
	CALL CBD
	ADD SI,2
	LOOP L
	
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