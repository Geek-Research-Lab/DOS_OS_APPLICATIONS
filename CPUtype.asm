; GET THE PROCESSOR TYPE - RETURNS 086 = 8088 OR 8086
;									286 = 80286
;									386 = 80386
;									486 = 80486
;			PUBLIC _CpuType
_CpuType	PROC	FAR
			PUSHF					;SAVE OLD FLAGS
			
			MOV DX,86				;TEST FOR 8086
			PUSH SP					;IF SP DECREMENTS BEFORE
			POP AX					;A VALUE IS PUSHED
			CMP SP,AX				;IT'S A REAL-MODE CHIP
			JNE CPUT_X				;8088,8086,80188,80186,NECV20/V30

			MOVDX,286				;TEST FOR 286
			PUSHF					;IF NT (NESTED TASK)
			POP AX					;BIT (BIT 14) IN THE
			OR AX,4000H				;FLAGS REGISTER
			PUSH AX					;UNABLE TO SET
			POPF					;THEN IT'S A 286
			PUSHF
			POP AX
			TEST AX,4000H
			JZ CPUT_X

			MOV DX,386				;TEST FOR 386/486
			.386					;DO SOME 32-BIT STUFF
			MOV EBX,ESP				;ZERO LOWER 2 BITS OF ESP
			AND ESP,0FFFFFFFCH		;TO AVOID AC FAULT ON 486
			PUSHFD					;PUSH EFLAGS REGISTER
			POP EAX					;EAX=EFLAGS
			MOV ECX,EAX				;ECX=EFLAGS
			XOR EAX,40000H			;TOGGLE AC BIT(BIT 18)
									;IN EFLAGS REGISTER
			PUSH EAX				;PUSH NEW VALUE
			POPFD					;PUT IT IN EFLAGS
			PUSHFD					;PUSH EFLAGS
			POP EAX					;EAX=EFLAGS
			AND EAX,40000H			;ISOLATE BIT 18 IN EAX
			AND ECX,40000H			;ISOLATE BIT 18 IN ECX
			CMP EAX,ECX				;IS EAX AND ECX EQUAL?
			JE A_386				;IT'S A 386
			MOV DX,486				;IT'S A 486
A_386:
			PUSH ECX				;RESTORE
			POPFD					;EFLAGS
			MOV ESP,EBX				;RESTORE ESP
			.8086
CPUT_X:		MOV AX,DX				;PUT CPU TYPE IN AX
			POPF					;RESTORE OLD FLAGS
			RET
_CpuType	ENDP
