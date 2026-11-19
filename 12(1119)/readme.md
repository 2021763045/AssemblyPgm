# MASM 사칙연산 및 레지스터 값 출력 프로그램

## 1. 프로젝트 소개

Visual Studio에서 MASM(Microsoft Macro Assembler)을 사용하여 두 개의 정수를 입력받고 사칙연산을 수행하는 프로그램입니다.

덧셈, 뺄셈, 곱셈, 나눗셈 결과를 출력하고, 각 연산 결과의 하위 16비트를 AX, BX, CX, DX에 대응하는 변수에 저장하여 16진수로 출력합니다.

## 2. 개발 환경

- IDE: Microsoft Visual Studio
- 언어: MASM (Assembly Language)
- 플랫폼: Win32 (x86)
- 라이브러리: msvcrt.lib

## 3. 주요 기능

1. 두 개의 정수 입력
2. 덧셈 연산
3. 뺄셈 연산
4. 곱셈 연산
5. 나눗셈 연산
6. 0으로 나누는 경우 예외 처리
7. AX, BX, CX, DX에 대응하는 변수 값 출력

## 4. 프로그램 코드

파일명: `arithmetic_registers.asm`

```asm
.386
.model flat, c
.stack 4096

.data
    num1    SDWORD ?
    num2    SDWORD ?

    resultAdd SDWORD ?
    resultSub SDWORD ?
    resultMul SDWORD ?
    resultDiv SDWORD ?

    regAX WORD ?
    regBX WORD ?
    regCX WORD ?
    regDX WORD ?

    inputMsg BYTE "Enter first number: ", 0
    inputMsg2 BYTE "Enter second number: ", 0

    addMsg BYTE 13,10,"Addition: %d",13,10,0
    subMsg BYTE "Subtraction: %d",13,10,0
    mulMsg BYTE "Multiplication: %d",13,10,0
    divMsg BYTE "Division: %d",13,10,0

    regMsg BYTE 13,10,"===== Register Values =====",13,10,0
    axMsg BYTE "AX = %04X",13,10,0
    bxMsg BYTE "BX = %04X",13,10,0
    cxMsg BYTE "CX = %04X",13,10,0
    dxMsg BYTE "DX = %04X",13,10,0

    zeroMsg BYTE "Division by zero is not allowed.",13,10,0

    scanFmt BYTE "%d",0

.code

includelib msvcrt.lib

EXTERN printf:PROC
EXTERN scanf:PROC

main PROC

    ; 첫 번째 정수 입력
    push OFFSET inputMsg
    call printf
    add esp, 4

    push OFFSET num1
    push OFFSET scanFmt
    call scanf
    add esp, 8

    ; 두 번째 정수 입력
    push OFFSET inputMsg2
    call printf
    add esp, 4

    push OFFSET num2
    push OFFSET scanFmt
    call scanf
    add esp, 8

    ; 덧셈
    mov eax, num1
    add eax, num2
    mov resultAdd, eax

    ; 뺄셈
    mov eax, num1
    sub eax, num2
    mov resultSub, eax

    ; 곱셈
    mov eax, num1
    imul eax, num2
    mov resultMul, eax

    ; 나눗셈
    cmp num2, 0
    je DIV_ZERO

    mov eax, num1
    cdq
    idiv num2
    mov resultDiv, eax
    jmp PRINT_RESULT

DIV_ZERO:
    push OFFSET zeroMsg
    call printf
    add esp, 4

    mov resultDiv, 0

PRINT_RESULT:

    ; 사칙연산 결과 출력
    push resultAdd
    push OFFSET addMsg
    call printf
    add esp, 8

    push resultSub
    push OFFSET subMsg
    call printf
    add esp, 8

    push resultMul
    push OFFSET mulMsg
    call printf
    add esp, 8

    push resultDiv
    push OFFSET divMsg
    call printf
    add esp, 8

    ; 연산 결과의 하위 16비트를 저장
    mov ax, WORD PTR resultAdd
    mov regAX, ax

    mov ax, WORD PTR resultSub
    mov regBX, ax

    mov ax, WORD PTR resultMul
    mov regCX, ax

    mov ax, WORD PTR resultDiv
    mov regDX, ax

    ; 레지스터 값 출력
    push OFFSET regMsg
    call printf
    add esp, 4

    movzx eax, regAX
    push eax
    push OFFSET axMsg
    call printf
    add esp, 8

    movzx eax, regBX
    push eax
    push OFFSET bxMsg
    call printf
    add esp, 8

    movzx eax, regCX
    push eax
    push OFFSET cxMsg
    call printf
    add esp, 8

    movzx eax, regDX
    push eax
    push OFFSET dxMsg
    call printf
    add esp, 8

    ret

main ENDP
END
```

## 5. 실행 결과

입력값으로 20과 6을 사용한 실행 예시입니다.

![실행 결과 화면](example-output.png)

```text
Enter first number: 20
Enter second number: 6

Addition: 26
Subtraction: 14
Multiplication: 120
Division: 3

===== Register Values =====
AX = 001A
BX = 000E
CX = 0078
DX = 0003
```

## 6. 실행 결과 분석

| 구분 | 계산 | 결과 | 16진수 |
|---|---|---:|---|
| AX | 20 + 6 | 26 | 001A |
| BX | 20 - 6 | 14 | 000E |
| CX | 20 × 6 | 120 | 0078 |
| DX | 20 ÷ 6 | 3 | 0003 |

※ 나눗셈은 정수 나눗셈을 사용하므로 나머지는 출력하지 않습니다.

※ AX, BX, CX, DX는 실제 CPU 레지스터의 최종 상태를 읽은 값이 아니라, 각 연산 결과의 하위 16비트를 저장한 변수입니다.

## 7. 프로젝트 실행 방법

1. Visual Studio를 실행합니다.
2. 새 C++ 빈 프로젝트를 생성합니다.
3. 솔루션 플랫폼을 Win32(x86)로 설정합니다.
4. 프로젝트 속성에서 MASM 사용을 활성화합니다.
5. `arithmetic_registers.asm` 파일을 프로젝트에 추가합니다.
6. `msvcrt.lib`가 연결되어 있는지 확인합니다.
7. 빌드 후 실행합니다.
