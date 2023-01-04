%define NL 10
%define CF_MASK 00000001h
%define PF_MASK 00000004h
%define AF_MASK 00000010h
%define ZF_MASK 00000040h
%define SF_MASK 00000080h
%define DF_MASK 00000400h
%define OF_MASK 00000800h

segment .data
wskaznik db "pointer = %p",10, 0
 adress dq 0
int_format	    db  "%i", 0
string_format       db  "%s", 0
char_format       db  "%c", 0
int_ln_format	    db  "%i", NL, 0
string_ln_format       db  "%s", NL, 0
char_ln_format       db  "%c", NL, 0
reg_format	    db  "Register Dump # %d", NL, 
		        db  "RAX = %.16llX RBX = %.16llX RCX = %.16llX RDX = %.16llX", NL
                    db  "RSI = %.16llX RDI = %.16llX RBP = %.16llX RSP = %.16llX", NL
                    db  "R8  = %.16llX R9  = %.16llX R10 = %.16llX R11 = %.16llX", NL
                    db  "R12 = %.16llX R13 = %.16llX R14 = %.16llX R15 = %.16llX", NL
                    db  "EIP = %.16llX FLAGS = %.16llX [%s %s %s %s %s %s %s]", NL
	            db  0
endl_format     db  NL, 0
carry_flag	    db  "CF", 0
zero_flag	    db  "ZF", 0
sign_flag	    db  "SF", 0
parity_flag	    db	"PF", 0
overflow_flag	    db	"OF", 0
dir_flag	    db	"DF", 0
aux_carry_flag	    db	"AF", 0
unset_flag	    db	"  ", 0
mem_format1         db  "Memory Dump # %d Address = %.8X", NL, 0
mem_format2         db  "%.8X ", 0
mem_format3         db  "%.2X ", 0
stack_format        db  "Stack Dump # %d", NL
	            db  "EBP = %.8X ESP = %.8X", NL, 0
stack_line_format   db  "%+4d  %.8X  %.8X", NL, 0
math_format1        db  "Math Coprocessor Dump # %d Control Word = %.4X"
                    db  " Status Word = %.4X", NL, 0
valid_st_format     db  "ST%d: %.10g", NL, 0
invalid_st_format   db  "ST%d: Invalid ST", NL, 0
empty_st_format     db  "ST%d: Empty", NL, 0

 segment .text
 extern printf
 extern scanf
 extern exit

global read_int, print_int, print_nl, print_string, read_string
global read_char, print_char
global sub_dump_regs, sub_dump_mem, sub_dump_math, sub_dump_stack
global println_int,  println_string, println_char
    
; odklada na stos rejestry, ktore moga by zmieniane zgodnie z ABI 64
%macro pushall 0
   pushf
   push rax
   push rdi
   push rsi
   push rdx
   push rcx
   push r8
   push r9
   push r10
   push r11
%endmacro  

; odtwarza ze stosu rejestry, ktore moga by zmieniane zgodnie z ABI 64  
%macro popall 0
   pop r11
   pop r10
   pop r9
   pop r8
   pop rcx
   pop rdx
   pop rsi
   pop rdi 
   pop rax
   popf
%endmacro

; print_X format
;
; Wywoluje funkcje printf(format, RAX) 
; argumentem jest tekst formatujący dla printf  
; wartość drugiego argumentu podajemy w RAX
%macro print_X 1
    push rbp
    mov rbp, rsp
    pushall
    	 
	mov rdi, %1
	mov rsi, rax
    mov rax, 0
    ;call  __isoc99_scanf
    call printf
    
    popall
    mov rsp, rbp
    pop rbp
	ret
%endmacro

%macro read_X 1
	enter 8,0
    pushall
    
	lea	rax, [rbp-8]
	mov rdi, %1
	mov rsi, rax
    mov rax, 0
    ;call  __isoc99_scanf
    call  scanf
   
	popall
    mov	rax, [rbp-8]
    leave
	ret
%endmacro

read_int:
    read_X int_format

read_string:
    read_X string_format
    
read_char:
    read_X char_format
    
print_int:
    print_X int_format

print_string:
    print_X string_format

print_char:
    print_X char_format

println_string:
    print_X string_ln_format

println_int:
    print_X int_ln_format

println_char:
    print_X char_ln_format


print_nl:
    print_X endl_format
    


;reg_format	    db  "Register Dump # %d", NL
;		        db  "RAX = %.16X RBX = %.16X RCX = %.16X RDX = %.16X", NL
;                    db  "ESI = %.8X EDI = %.8X EBP = %.8X ESP = %.8X", NL
;                    db  "EIP = %.8X FLAGS = %.4X %s %s %s %s %s %s %s", NL

sub_dump_regs:
	enter   0,0
	pushall
;
; show which FLAGS are set
;
	test	dword [rbp-8], CF_MASK
	jz	cf_off
	mov	rax, carry_flag
	jmp	short push_cf
cf_off:
	mov	rax, unset_flag
push_cf:
	push	rax

	test	dword [rbp-8], PF_MASK
	jz	pf_off
	mov	rax, parity_flag
	jmp	short push_pf
pf_off:
	mov	rax, unset_flag
push_pf:
	push	rax
;~ 
	test	dword [rbp-8], AF_MASK
	jz	af_off
	mov	rax, aux_carry_flag
	jmp	short push_af
af_off:
	mov	rax, unset_flag
push_af:
	push	rax

	test	dword [rbp-8], ZF_MASK
	jz	zf_off
	mov	rax, zero_flag
	jmp	short push_zf
zf_off:
	mov	rax, unset_flag
push_zf:
	push	rax

	test	dword [rbp-8], SF_MASK
	jz	sf_off
	mov	rax, sign_flag
	jmp	short push_sf
sf_off:
	mov	rax, unset_flag
push_sf:
	push	rax

	test	dword [rbp-8], DF_MASK
	jz	.df_off
	mov	rax, dir_flag
	jmp	short .push_df
.df_off:
	mov	rax, unset_flag
.push_df:
	push	rax

	test	dword [rbp-8], OF_MASK
	jz	.of_off
	mov	rax, overflow_flag
	jmp	short .push_of
.of_off:
	mov	rax, unset_flag
.push_of:
	push	rax

  push    qword [rbp-8]   ; FLAGS

	mov	rax, [rbp+8]
	sub	rax, 10           ; RIP on stack is 10 bytes ahead of orig
	push	rax             ; RIP

  push r15
  push r14
  push r13
  push r12
  push r11
  push r10
  push r9
  push r8
; db  "ESI = %.8X EDI = %.8X EBP = %.8X ESP = %.8X", NL
	lea     rax, [rbp+24]
	push    rax             ; original RSP
	push    qword [rbp]     ; original RBP
  push rdi
  push rsi

  mov r9, rdx
  mov r8, rcx
  mov rcx, rbx        ; EBX 
  mov	rdx, [rbp-16]   ; original EAX
  mov rsi, [rbp+16]   ; # of dump
  mov rdi, reg_format  
  mov rax, 0          ; no floating points
  call	printf
  
  add rsp, 136+4*8   ; clean stack after printf
    ;~ add rsp, 24
	popall
	leave
	ret     8
