# 4. Data Transfers, Addressing, and Arithmetic

> 이 장에서는 x86 어셈블리의 데이터 전송 명령어, 메모리 주소 지정 방식, 배열 처리, 데이터 관련 연산자, 정수 덧셈·뺄셈 및 상태 플래그를 다룬다. 

---

## 1. 데이터 전송 명령어

### `MOV`

`MOV`는 원본(source) 피연산자의 값을 목적지(destination) 피연산자로 복사한다. 단, 하나의 `MOV` 명령어로 메모리에서 다른 메모리 위치로 직접 복사할 수는 없다. 

```asm
mov eax, 10        ; 즉시값 → 레지스터
mov ebx, eax       ; 레지스터 → 레지스터
mov value, eax     ; 레지스터 → 메모리
mov eax, value     ; 메모리 → 레지스터
```

잘못된 예시:

```asm
mov value1, value2     ; 메모리 → 메모리 직접 이동 불가
```

올바른 예시:

```asm
mov eax, value2
mov value1, eax
```

---

### `MOVZX` — Zero Extension

`MOVZX`는 작은 크기의 unsigned 값을 더 큰 레지스터로 복사하면서 상위 비트를 `0`으로 채운다. 

```asm
mov bx, 0A69Bh
movzx eax, bx      ; EAX = 0000A69Bh

movzx edx, bl      ; EDX = 0000009Bh
```

| 원본 값 | 명령어 | 결과 |
|---|---|---|
| `BX = A69Bh` | `movzx eax, bx` | `EAX = 0000A69Bh` |
| `BL = 9Bh` | `movzx edx, bl` | `EDX = 0000009Bh` |

---

### `MOVSX` — Sign Extension

`MOVSX`는 signed 값을 더 큰 레지스터로 복사하면서 최상위 비트(sign bit)를 상위 비트까지 확장한다. 

```asm
mov bx, 0A69Bh
movsx eax, bx      ; EAX = FFFFA69Bh

movsx edx, bl      ; EDX = FFFFFF9Bh
```

| 원본 값 | 명령어 | 결과 |
|---|---|---|
| `BX = A69Bh` | `movsx eax, bx` | `EAX = FFFFA69Bh` |
| `BL = 9Bh` | `movsx edx, bl` | `EDX = FFFFFF9Bh` |

---

### `XCHG` — 값 교환

`XCHG`는 두 피연산자의 값을 교환한다.

```asm
mov ax, val1
xchg ax, val2
mov val1, ax
```

위 코드는 `val1`과 `val2`의 값을 서로 바꾼다.

---

## 2. Little Endian 방식

x86 프로세서는 **Little Endian** 방식을 사용한다.

```asm
value DWORD 12345678h
```

메모리에는 하위 바이트부터 저장된다.

```text
78h 56h 34h 12h
```

| 메모리 주소 | 저장 값 |
|---|---|
| Lowest Address | `78h` |
|  | `56h` |
|  | `34h` |
| Highest Address | `12h` |

---

## 3. Direct-Offset Addressing

변수 이름이나 배열 이름에 오프셋을 더하여 특정 메모리 위치에 접근하는 방식이다.

```asm
.data
arrayB BYTE 10h, 20h, 30h, 40h
arrayW WORD 100h, 200h, 300h
arrayD DWORD 10000h, 20000h
```

```asm
mov al, arrayB          ; AL = 10h
mov al, [arrayB+1]      ; AL = 20h

mov ax, arrayW          ; AX = 0100h
mov ax, [arrayW+2]      ; AX = 0200h

mov eax, arrayD         ; EAX = 00010000h
mov eax, [arrayD+4]     ; EAX = 00020000h
```

배열의 요소 크기에 맞는 오프셋을 사용해야 한다.

| 자료형 | 요소 크기 | 두 번째 요소 오프셋 |
|---|---:|---:|
| `BYTE` | 1바이트 | `+1` |
| `WORD` | 2바이트 | `+2` |
| `DWORD` | 4바이트 | `+4` |

---

## 4. Indirect Addressing

Indirect Addressing은 레지스터에 저장된 주소를 이용해 메모리에 접근하는 방식이다.

```asm
.data
array BYTE 10h, 20h, 30h, 40h

.code
mov esi, OFFSET array
mov al, [esi]           ; AL = 10h

add esi, 1
mov al, [esi]           ; AL = 20h
```

주소를 저장하는 변수를 **Pointer**라고 한다. 

```asm
.data
ptr DWORD OFFSET array
```

---

## 5. Indexed Addressing

Indexed Addressing은 레지스터와 상수를 더하여 유효 주소를 계산하는 방식이다. 

```asm
.data
array DWORD 10, 20, 30, 40

.code
mov esi, 2
mov eax, array[esi * TYPE array]
```

위 코드에서:

```text
ESI = 2
TYPE array = 4
```

따라서 세 번째 배열 요소인 `30`이 EAX에 저장된다.

배열 요소의 크기를 고려하여 인덱스를 계산해야 한다. 

```asm
array[esi * TYPE array]
```

---

## 6. 데이터 관련 연산자와 지시문

### `TYPE`

`TYPE`은 배열 요소 하나의 크기를 바이트 단위로 반환한다.

```asm
myBytes BYTE 10h, 20h, 30h
myWords WORD 1000h, 2000h

mov eax, TYPE myBytes      ; EAX = 1
mov eax, TYPE myWords      ; EAX = 2
```

---

### `LENGTHOF`

`LENGTHOF`는 배열에 포함된 요소의 개수를 반환한다. 

```asm
myBytes BYTE 10h, 20h, 30h, 40h

mov eax, LENGTHOF myBytes  ; EAX = 4
```

---

### `SIZEOF`

`SIZEOF`는 전체 배열 크기를 바이트 단위로 반환한다.

$$\text{SIZEOF} = \text{LENGTHOF} \times \text{TYPE}$$

```asm
myWords WORD 1000h, 2000h, 3000h, 4000h

mov eax, SIZEOF myWords    ; EAX = 8
```

`SIZEOF`는 `LENGTHOF × TYPE`과 동일한 값을 반환한다. 

---

### `PTR`

`PTR`은 피연산자의 자료형 크기를 임시로 지정하거나 변경할 때 사용한다. 

```asm
mov al, BYTE PTR [esi]
mov ax, WORD PTR [esi]
mov eax, DWORD PTR [esi]
```

---

### `LABEL`

`LABEL`은 별도의 메모리 공간을 할당하지 않고 기존 위치에 새로운 자료형 속성을 가진 레이블을 붙인다. 

```asm
myBytes LABEL WORD
        BYTE 10h, 20h, 30h, 40h

mov ax, myBytes            ; AX = 2010h
```

---

### `ALIGN`

`ALIGN`은 다음 데이터가 특정 배수 주소에 위치하도록 정렬한다.

```asm
ALIGN 2
myBytes BYTE 10h, 20h, 30h, 40h
```

위 코드는 `myBytes`가 짝수 주소에서 시작하도록 한다.

---

## 7. 덧셈과 뺄셈

### `ADD`

```asm
mov eax, 10
add eax, 20        ; EAX = 30
```

### `SUB`

```asm
mov eax, 10
sub eax, 3         ; EAX = 7
```

### `INC`와 `DEC`

`INC`는 1을 더하고, `DEC`는 1을 뺀다. 

```asm
inc eax            ; EAX = EAX + 1
dec eax            ; EAX = EAX - 1
```

`INC`와 `DEC`는 Carry Flag를 변경하지 않는다. 

---

### `NEG`

`NEG`는 2의 보수를 이용해 피연산자의 부호를 반전한다. 

```asm
mov eax, 5
neg eax            ; EAX = -5
```

피연산자가 0이 아니면 `NEG`는 Carry Flag를 설정한다.

```text
CF = 1
```

---

## 8. 산술 연산과 상태 플래그

| 플래그 | 의미 |
|---|---|
| `CF` | unsigned 연산에서 자리올림 또는 빌림 발생 |
| `ZF` | 연산 결과가 0 |
| `SF` | 연산 결과가 음수 |
| `OF` | signed 연산에서 범위 초과 발생 |
| `AF` | 하위 4비트에서 자리올림 또는 빌림 발생 |
| `PF` | 결과의 하위 바이트에서 1의 개수가 짝수 |

### Carry Flag

뺄셈에서 작은 unsigned 값에서 큰 값을 빼면 Carry Flag가 설정된다. 

```asm
mov al, 0
sub al, 1

; AL = FFh
; CF = 1
```

### Zero Flag

연산 결과가 0이면 Zero Flag가 설정된다. 

```asm
mov al, 0FFh
add al, 1

; AL = 00h
; ZF = 1
; CF = 1
```

### Sign Flag와 Overflow Flag

Sign Flag는 signed 연산 결과가 음수이면 설정된다.  
Overflow Flag는 signed 연산 결과가 목적지 범위를 벗어나면 설정된다. 

```asm
mov al, 127
add al, 1

; AL = 80h = -128
; OF = 1
; SF = 1
```

### Auxiliary Carry와 Parity Flag

- `AF`: 비트 3에서 자리올림 또는 빌림이 발생하면 설정된다.
- `PF`: 결과의 하위 바이트에서 `1`의 개수가 짝수이면 설정된다. 

```asm
mov al, 1
add al, 3

; AL = 04h = 00000100b
; 1의 개수는 1개
; PF = 0
```

---

## 핵심 정리

- `MOV`는 데이터를 복사하지만 메모리에서 메모리로 직접 복사할 수 없다.
- `MOVZX`는 상위 비트를 `0`으로 확장하고, `MOVSX`는 부호 비트로 확장한다.
- `XCHG`는 두 피연산자의 값을 교환한다.
- x86은 Little Endian 방식을 사용한다.
- 배열 접근 시 `TYPE`을 사용하면 요소 크기에 맞는 주소 계산이 가능하다.
- `TYPE`, `LENGTHOF`, `SIZEOF`는 배열의 크기와 요소 수를 쉽게 계산하는 연산자이다.
- `PTR`은 메모리 피연산자의 크기를 지정한다.
- `ADD`, `SUB`, `INC`, `DEC`, `NEG`는 기본 산술 명령어이다.
- `CF`, `ZF`, `SF`, `OF`, `AF`, `PF`는 산술 결과의 상태를 나타낸다.
