# 5. Procedure

> 어셈블리에서 프로시저는 여러 명령어를 하나로 묶어 재사용하는 기능으로, 고급 언어의 함수나 메서드와 비슷하다. 이 장에서는 프로시저 정의와 호출, 스택, 인자 전달, 레지스터 보존, Irvine32 라이브러리를 다룬다. 

## 1. 프로시저 정의와 호출

`PROC`와 `ENDP` 사이에 프로시저의 명령어를 작성한다. `CALL`은 프로시저를 호출하고 반환 주소를 스택에 저장하며, `RET`은 해당 주소로 돌아간다. 

```asm
MyProc PROC
    ; 프로시저 명령어
    ret
MyProc ENDP

main PROC
    call MyProc
    exit
main ENDP
```

프로시저 내부의 분기와 반복은 해당 프로시저 안에서 처리하는 것이 바람직하다.

---

## 2. 스택과 `PUSH` / `POP`

스택은 **LIFO(Last In, First Out)** 구조이다. 마지막에 넣은 값이 먼저 나온다. 

32비트 모드에서 `PUSH`는 스택 포인터를 4 감소시킨 후 값을 저장하고, `POP`은 스택 맨 위의 값을 꺼낸 뒤 스택 포인터를 4 증가시킨다. 

```asm
push eax       ; EAX를 스택에 저장
pop  ebx       ; 스택 최상단 값을 EBX로 꺼냄
```

레지스터를 프로시저에서 변경한 뒤 원래 값으로 복구해야 한다면 스택에 저장하고 복원한다.

```asm
MyProc PROC
    push esi
    push ecx

    ; ESI, ECX를 사용하는 작업

    pop ecx
    pop esi
    ret
MyProc ENDP
```

저장한 순서의 **반대 순서**로 복원해야 한다.

---

## 3. `PUSHAD` / `POPAD`

32비트 일반 목적 레지스터들을 한 번에 저장하거나 복원할 때 사용한다.

```asm
MyProc PROC
    pushad

    ; 여러 레지스터를 사용하는 작업

    popad
    ret
MyProc ENDP
```

단, `EAX`를 반환값으로 사용한다면 `POPAD`가 계산된 반환값까지 덮어쓸 수 있으므로 주의한다.

---

## 4. `USES` 연산자

`USES`는 프로시저에서 변경할 레지스터를 지정한다. 어셈블러가 프로시저 시작 부분에 `PUSH`, 종료 부분에 `POP` 코드를 생성해 해당 레지스터들을 보존한다. 

```asm
ArraySum PROC USES esi ecx
    mov eax, 0

L1:
    add eax, [esi]
    add esi, TYPE DWORD
    loop L1

    ret
ArraySum ENDP
```

`EAX`가 반환값이면 일반적으로 `USES`에 넣어 복구하지 않는다.

---

## 5. 인자 전달과 반환값

인자는 일반 목적 레지스터나 스택을 이용해 전달할 수 있다. 어떤 방법과 레지스터를 사용할지는 프로시저와 호출자가 같은 규칙을 사용하도록 정해야 한다.

### 레지스터로 인자 전달하는 예

```asm
; 입력:
;   EAX, EBX, ECX = 더할 값
; 반환:
;   EAX = 세 값의 합

SumOf PROC
    add eax, ebx
    add eax, ecx
    ret
SumOf ENDP
```

```asm
mov eax, 10000h
mov ebx, 20000h
mov ecx, 30000h
call SumOf
; 결과는 EAX에 있음
```

### 배열의 합을 계산하는 예

`ArraySum`은 `ESI`로 배열 주소, `ECX`로 배열 원소 수를 받고, 합계를 `EAX`로 반환한다. 

```asm
; 입력:
;   ESI = DWORD 배열 주소
;   ECX = 배열 원소 수
; 반환:
;   EAX = 원소 합계

ArraySum PROC USES esi ecx
    mov eax, 0

L1:
    add eax, [esi]
    add esi, TYPE DWORD
    loop L1

    ret
ArraySum ENDP
```

---

## 6. 중첩 루프에서 레지스터 보존

`ECX`를 바깥 루프와 안쪽 루프가 함께 사용하면, 안쪽 루프를 실행하기 전에 바깥 루프의 `ECX` 값을 저장하고 끝난 뒤 복원한다.

```asm
mov ecx, 100

OuterLoop:
    push ecx

    mov ecx, 20
InnerLoop:
    ; 안쪽 반복 작업
    loop InnerLoop

    pop ecx
    loop OuterLoop
```

---

## 7. 외부 라이브러리와 Irvine32

라이브러리는 미리 컴파일된 프로시저를 모아둔 파일이다. 링커는 프로그램에서 사용하는 라이브러리 코드를 연결한다. Windows의 `kernel32.lib` 같은 import library는 실제 기능이 들어 있는 DLL의 함수와 연결하는 데 사용된다. 

Irvine32는 초보자가 Windows 콘솔 입출력과 여러 기본 기능을 쉽게 사용할 수 있도록 제공되는 32비트 라이브러리이다. 

### 자주 사용하는 Irvine32 프로시저

| 프로시저 | 기능 |
|---|---|
| `Clrscr` | 콘솔 화면 지우기 |
| `Crlf` | 줄 바꾸기 |
| `ReadInt` | signed 정수 입력 |
| `ReadString` | 문자열 입력 |
| `WriteInt` | signed 정수 출력 |
| `WriteDec` | unsigned 정수 출력 |
| `WriteHex` | 16진수 출력 |
| `WriteString` | null-terminated 문자열 출력 |
| `WriteChar` | 문자 하나 출력 |
| `DumpRegs` | 레지스터와 상태 플래그 출력 |
| `DumpMem` | 메모리 내용 출력 |
| `RandomRange` | 지정된 범위의 난수 생성 |
| `SetTextColor` | 콘솔 글자색과 배경색 설정 |
| `Delay` | 지정한 시간만큼 실행 지연 |

Irvine32 라이브러리의 입출력, 난수, 콘솔 관련 함수는 레지스터를 통해 인자와 반환값을 주고받는다. 예를 들어 `WriteString`은 `EDX`에 문자열 주소를 받고, `RandomRange`는 `EAX`에 범위 값을 받는다. 

```asm
.data
message BYTE "Hello, Assembly!", 0

.code
mov edx, OFFSET message
call WriteString
call Crlf
```

---

## 핵심 정리

- 프로시저는 `PROC`로 시작하고 `ENDP`로 끝낸다.
- `CALL`은 반환 주소를 스택에 저장한 뒤 프로시저를 실행한다.
- `RET`은 스택에 저장된 반환 주소로 돌아간다.
- `PUSH`와 `POP`은 스택을 이용해 데이터를 저장하고 복원한다.
- 프로시저가 변경한 레지스터는 필요하면 직접 저장·복원하거나 `USES`로 보존한다.
- 인자는 레지스터 또는 스택으로 전달할 수 있으며, 반환값에는 흔히 `EAX`를 사용한다.
- Irvine32는 콘솔 입출력, 레지스터 확인, 난수 생성 등 학습에 유용한 프로시저를 제공한다.
