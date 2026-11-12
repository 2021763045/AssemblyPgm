# MASM을 이용한 정수 5개의 평균 계산 프로그램

## 1. 프로젝트 소개

Visual Studio에서 MASM(Microsoft Macro Assembler)을 사용하여 정수 5개를 입력받고, 입력받은 정수의 평균을 계산하여 출력하는 프로그램입니다.

## 2. 개발 환경

- IDE: Visual Studio 2022
- Assembly: MASM (Microsoft Macro Assembler)
- Platform: x64
- OS: Windows 10 / 11

## 3. 프로그램 기능

1. 사용자로부터 정수 5개를 입력받습니다.
2. 입력받은 5개의 정수를 모두 더합니다.
3. 정수의 합을 5로 나누어 평균을 계산합니다.
4. 계산된 평균을 소수점 둘째 자리까지 출력합니다.

## 4. 소스 코드

파일명: `average5.asm`

```asm
OPTION CASEMAP:NONE

EXTERN scanf:PROC
EXTERN printf:PROC

.data
    prompt      BYTE "Enter integer %d: ", 0
    inputFmt    BYTE "%d", 0
    resultFmt   BYTE "Average = %s%llu.%02llu", 13, 10, 0
    minusSign   BYTE "-", 0
    emptySign   BYTE 0

.code
main PROC
    sub     rsp, 48h

    mov     qword ptr [rsp+20h], 0
    mov     dword ptr [rsp+28h], 1

read_loop:
    lea     rcx, prompt
    mov     edx, dword ptr [rsp+28h]
    call    printf

    lea     rcx, inputFmt
    lea     rdx, [rsp+2Ch]
    call    scanf

    movsxd  rax, dword ptr [rsp+2Ch]
    add     qword ptr [rsp+20h], rax

    inc     dword ptr [rsp+28h]
    cmp     dword ptr [rsp+28h], 6
    jl      read_loop

    ; 평균을 100배하여 소수점 둘째 자리까지 계산
    mov     rax, qword ptr [rsp+20h]
    imul    rax, 20
    mov     qword ptr [rsp+30h], rax

    test    rax, rax
    js      negative_result

positive_result:
    jmp     divide_scaled

negative_result:
    neg     rax

divide_scaled:
    xor     rdx, rdx
    mov     r9, 100
    div     r9

    mov     r9, rdx
    mov     r8, rax
    mov     rcx, OFFSET resultFmt

    mov     rax, qword ptr [rsp+30h]
    test    rax, rax
    js      set_minus

    lea     rdx, emptySign
    jmp     print_result

set_minus:
    lea     rdx, minusSign

print_result:
    call    printf

    xor     eax, eax
    add     rsp, 48h
    ret
main ENDP

END
```

## 5. 실행 결과

다음은 정수 5개를 입력했을 때의 실행 결과입니다.

### 입력값
- 첫 번째 정수: 10
- 두 번째 정수: 20
- 세 번째 정수: 30
- 네 번째 정수: 40
- 다섯 번째 정수: 50

### 실행 화면

<img width="1200" height="560" alt="image" src="https://github.com/user-attachments/assets/759ebbcf-900f-490c-8228-62ad8647b7d8" />


### 계산 과정

입력한 정수의 합:

10 + 20 + 30 + 40 + 50 = 150

평균 계산:

150 / 5 = 30

최종 출력 결과:

`Average = 30.00`

## 6. 프로그램 실행 방법

1. Visual Studio 2022를 실행합니다.
2. 빈 프로젝트(Empty Project)를 생성합니다.
3. 프로젝트 플랫폼을 x64로 설정합니다.
4. 프로젝트의 빌드 사용자 지정(Build Customizations)에서 MASM을 활성화합니다.
5. `average5.asm` 파일을 프로젝트에 추가합니다.
6. 솔루션 빌드를 실행합니다.
7. Ctrl + F5를 눌러 프로그램을 실행합니다.

## 7. 프로젝트 파일 구성

```text
MASM-Average/
├── average5.asm
└── README.md
```
