# 3장 Assembly Language Fundamentals 정리

> 어셈블리 언어의 기본 문법, 데이터 정의, 기호 상수, 정수 연산, 그리고 프로그램 빌드 과정을 정리한 내용이다. 어셈블리 코드는 어셈블러에 의해 기계어 바이트로 번역된다. 

---

## 1. 어셈블리 프로그램 빌드 과정

어셈블리 프로그램은 다음 과정으로 실행 파일이 된다. 

```text
Source File (.asm)
        ↓ Assembler
Object File (.obj) + Listing File (.lst)
        ↓ Linker
Executable File (.exe)
        ↓
Run
```

| 파일 | 설명 |
|---|---|
| `.asm` | 사람이 작성하는 어셈블리 소스 파일 |
| `.obj` | 어셈블러가 만든 목적 파일 |
| `.lst` | 소스 코드, 주소, 기계어 코드가 포함된 listing 파일 |
| `.lib` | 링커가 사용하는 라이브러리 파일 |
| `.exe` | 실행 가능한 프로그램 파일 |

- **Assembler**: 어셈블리 코드를 기계어로 변환한다.
- **Linker**: Object file과 library를 연결하여 실행 파일을 만든다.
- **Listing file**: 명령어가 어떤 기계어 코드로 변환되었는지 확인할 수 있다.

---

## 2. 어셈블리 언어 기본 구조

일반적인 어셈블리 명령어는 다음 4가지 요소로 구성된다.

```asm
label:  mnemonic  operand1, operand2  ; comment
```

| 요소 | 설명 |
|---|---|
| Label | 코드나 데이터의 위치를 나타내는 이름 |
| Mnemonic | 실행할 명령어 이름 |
| Operand | 명령어의 대상 데이터 또는 값 |
| Comment | 코드 설명을 위한 주석 |

예시:

```asm
start:
    mov eax, 5      ; EAX에 5 저장
    add eax, 10     ; EAX에 10 더하기
```

---

## 3. 식별자와 레이블

식별자(identifier)는 변수, 상수, 프로시저, 레이블 등의 이름으로 사용된다.

```asm
count DWORD 10
total DWORD ?
```

레이블은 코드 또는 데이터가 위치한 메모리 주소에 이름을 붙이는 역할을 한다. 

| 종류 | 예시 | 용도 |
|---|---|---|
| Data Label | `count DWORD 10` | 데이터가 저장된 위치를 나타냄 |
| Code Label | `L1:` | 명령어 위치를 나타내며 분기 대상에 사용 |

```asm
.data
count DWORD 10

.code
L1:
    mov eax, count
```

---

## 4. 정수 리터럴과 정수식

정수 리터럴은 10진수, 2진수, 8진수, 16진수 형식으로 표현할 수 있다.

```asm
value1 DWORD 25       ; 10진수
value2 DWORD 11001b   ; 2진수
value3 DWORD 31o      ; 8진수
value4 DWORD 19h      ; 16진수
```

정수식은 정수 리터럴과 산술 연산자를 이용해 작성한다. 

```asm
result EQU (10 + 20) * 2
```

---

## 5. 기호 상수

기호 상수는 숫자나 문자열에 의미 있는 이름을 부여하는 방법이다.

### `EQU` 지시문

`EQU`는 정수식 또는 텍스트에 기호 이름을 연결한다. 

```asm
MAX_SIZE EQU 100
PI_VALUE  EQU 3
```

```asm
mov ecx, MAX_SIZE
```

### 기호 상수의 장점

- 숫자 값의 의미를 명확하게 표현할 수 있다.
- 값을 수정할 때 한 곳만 변경하면 된다.
- 코드의 가독성과 유지보수성이 향상된다.

### 문자열 기호 상수

```asm
MESSAGE EQU <"Hello, Assembly!">

.data
msg BYTE MESSAGE, 0
```

`TEXTEQU`는 텍스트 매크로를 만들 때 사용할 수 있다. 

---

## 6. 데이터 정의

데이터 정의문은 메모리에 변수를 위한 공간을 할당하며, 필요하면 초기값도 저장한다. 자료형은 크기, 부호 여부, 정수/실수 여부를 나타낸다. 

```asm
.data
number DWORD 100
```

### 주요 정수 자료형

| 지시문 | 크기 | 설명 |
|---|---:|---|
| `BYTE` | 8비트 | 부호 없는 정수 |
| `SBYTE` | 8비트 | 부호 있는 정수 |
| `WORD` | 16비트 | 부호 없는 정수 |
| `SWORD` | 16비트 | 부호 있는 정수 |
| `DWORD` | 32비트 | 부호 없는 정수 |
| `SDWORD` | 32비트 | 부호 있는 정수 |
| `QWORD` | 64비트 | 64비트 정수 |
| `TBYTE` | 80비트 | 10바이트 정수 또는 BCD 데이터 |

```asm
.data
age      BYTE   20
score    WORD   1000
total    DWORD  50000
balance  SDWORD -200
bigValue QWORD  123456789ABCDEF0h
```

### 초기화되지 않은 변수

`?`를 사용하면 초기화되지 않은 메모리 공간을 할당한다. 해당 변수는 실행 시간에 값을 할당받는다. 

```asm
.data
count DWORD ?
```

---

## 7. 배열과 `DUP` 연산자

`DUP` 연산자는 동일한 초기값 또는 초기화되지 않은 공간을 여러 개 생성할 때 사용한다. 

```asm
.data
scores BYTE 10 DUP(0)      ; 0으로 초기화된 BYTE 10개
array  DWORD 100 DUP(?)    ; 초기화되지 않은 DWORD 100개
```

문자 배열은 문자열로 사용할 수 있다.

```asm
.data
name BYTE "Assembly", 0
```

문자열 끝의 `0`은 null terminator이다.

---

## 8. Little Endian 방식

x86 프로세서는 데이터를 메모리에 저장할 때 **Little Endian** 방식을 사용한다. 즉, 가장 낮은 바이트가 가장 낮은 메모리 주소에 저장된다. 

```asm
val1 DWORD 87654321h
```

메모리에 저장되는 순서:

```text
21h 43h 65h 87h
```

| 메모리 주소 | 저장 값 |
|---|---|
| Lowest Address | `21h` |
|  | `43h` |
|  | `65h` |
| Highest Address | `87h` |

---

## 9. 코드와 데이터 세그먼트

MASM 프로그램은 일반적으로 `.data`와 `.code` 세그먼트로 나뉜다. 필요에 따라 코드와 데이터 영역을 번갈아 선언할 수도 있다. 

```asm
.data
value DWORD 10

.code
main PROC
    mov eax, value
    exit
main ENDP

END main
```

| 구역 | 역할 |
|---|---|
| `.data` | 초기값이 있는 변수와 상수 선언 |
| `.data?` | 초기화되지 않은 변수 선언 |
| `.code` | 실행할 명령어 작성 |

---

## 10. 프로시저와 프로그램 종료

프로시저는 특정 작업을 수행하는 명령어들의 묶음이다.

```asm
main PROC
    mov eax, 0
    exit
main ENDP

END main
```

| 키워드 | 역할 |
|---|---|
| `PROC` | 프로시저 시작 |
| `ENDP` | 프로시저 종료 |
| `END main` | 프로그램의 시작 프로시저 지정 |
| `ExitProcess` | 프로그램 종료 후 운영체제로 제어 반환 |

Windows 프로그램은 운영체제의 함수를 호출하여 종료할 수 있다. 

```asm
INVOKE ExitProcess, 0
```

---

## 11. 정수 덧셈과 뺄셈

`ADD`는 덧셈, `SUB`는 뺄셈 명령어이다.

```asm
mov eax, 20
mov ebx, 10

add eax, ebx      ; EAX = 30
sub eax, 5        ; EAX = 25
```

다음 식도 레지스터를 이용해 계산할 수 있다.

$$A = (A + B) - (C + D)$$

```asm
mov eax, 20
mov ebx, 10
mov ecx, 5
mov edx, 3

add eax, ebx
add ecx, edx
sub eax, ecx
```

최종 결과는 `EAX = 22`이다.

---

## 핵심 정리

- 어셈블리 코드는 **Assembler**가 Object file로 변환하고, **Linker**가 실행 파일을 생성한다.
- 명령어는 일반적으로 **Label, Mnemonic, Operand, Comment**로 구성된다.
- `EQU`는 숫자와 문자열에 의미 있는 기호 이름을 붙일 때 사용한다.
- `BYTE`, `WORD`, `DWORD`, `QWORD` 등의 지시문으로 변수의 크기를 정의한다.
- `DUP`를 사용하면 배열 또는 반복 데이터를 간단히 선언할 수 있다.
- x86 시스템은 **Little Endian** 방식으로 데이터를 메모리에 저장한다.
- `.data`에는 변수, `.code`에는 실행 명령어를 작성한다.
- `PROC`와 `ENDP`는 프로시저의 시작과 끝을 나타낸다.
- `ADD`, `SUB`, `MOV`는 가장 기본적인 어셈블리 명령어이다.
