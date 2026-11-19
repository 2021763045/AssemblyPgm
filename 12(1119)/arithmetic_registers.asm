; MASM x86: two integers, arithmetic results, AX/BX/CX/DX display
.386
.model flat, c
option casemap:none

EXTERN _scanf:PROC
EXTERN _printf:PROC

.data
    promptA     BYTE "Enter the first integer: ", 0
    promptB     BYTE "Enter the second integer: ", 0
    inputFmt    BYTE "%d", 0
    resultTitle BYTE 13,10,"[Arithmetic Results]",13,10,0
    addFmt      BYTE "A + B = %d",13,10,0
    subFmt      BYTE "A - B = %d",13,10,0
    mulFmt      BYTE "A * B = %d",13,10,0
    divFmt      BYTE "A / B = %d (integer division)",13,10,0
    divZeroMsg  BYTE "A / B = undefined (division by zero)",13,10,0
    regTitle    BYTE 13,10,"[16-bit Register Values (Hex)]",13,10,0
    regFmt      BYTE "AX = %04X",13,10,"BX = %04X",13,10,"CX = %04X",13,10,"DX = %04X",13,10,0

    numA        DWORD ?
    numB        DWORD ?
    sumResult   DWORD ?
    subResult   DWORD ?
    mulResult   DWORD ?
    divResult   DWORD ?
    divValid    DWORD 0
    regAX       DWORD ?
    regBX       DWORD ?
    regCX       DWORD ?
    regDX       DWORD ?

.code
main PROC
    ; Read first integer
    push OFFSET promptA
    call _printf
    add  esp, 4
    push OFFSET numA
    push OFFSET inputFmt
    call _scanf
    add  esp, 8

    ; Read second integer
    push OFFSET promptB
    call _printf
    add  esp, 4
    push OFFSET numB
    push OFFSET inputFmt
    call _scanf
    add  esp, 8

    ; Addition
    mov  eax, numA
    add  eax, numB
    mov  sumResult, eax

    ; Subtraction
    mov  eax, numA
    sub  eax, numB
    mov  subResult, eax

    ; Multiplication (32-bit result)
    mov  eax, numA
    imul eax, numB
    mov  mulResult, eax

    ; Signed integer division
    mov  divValid, 0
    cmp  numB, 0
    je   division_by_zero
    mov  eax, numA
    cdq
    idiv numB
    mov  divResult, eax
    mov  divValid, 1
    jmp  division_done

division_by_zero:
    mov  divResult, 0

division_done:
    ; Register display mapping: low 16 bits of each result
    mov  eax, sumResult
    and  eax, 0FFFFh
    mov  regAX, eax

    mov  eax, subResult
    and  eax, 0FFFFh
    mov  regBX, eax

    mov  eax, mulResult
    and  eax, 0FFFFh
    mov  regCX, eax

    mov  eax, divResult
    and  eax, 0FFFFh
    mov  regDX, eax

    ; Print arithmetic results
    push OFFSET resultTitle
    call _printf
    add  esp, 4

    push sumResult
    push OFFSET addFmt
    call _printf
    add  esp, 8

    push subResult
    push OFFSET subFmt
    call _printf
    add  esp, 8

    push mulResult
    push OFFSET mulFmt
    call _printf
    add  esp, 8

    cmp  divValid, 0
    je   print_division_by_zero
    push divResult
    push OFFSET divFmt
    call _printf
    add  esp, 8
    jmp  print_registers

print_division_by_zero:
    push OFFSET divZeroMsg
    call _printf
    add  esp, 4

print_registers:
    push OFFSET regTitle
    call _printf
    add  esp, 4

    ; printf arguments are pushed right-to-left
    push regDX
    push regCX
    push regBX
    push regAX
    push OFFSET regFmt
    call _printf
    add  esp, 20

    xor  eax, eax
    ret
main ENDP

END
