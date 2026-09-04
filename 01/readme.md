1.7 Review Questions and Exercises
1.7.1 Short Answer
1. MSB: 가장 왼쪽 비트, 즉 bit 7

2. 10진수

- a. `00110101` = 53
- b. `10010110` = 150
- c. `11001100` = 204

3. 덧셈

- a. `10101111 + 11011011` = `110001010`
- b. `10010111 + 11111111` = `110010110`
- c. `01110101 + 10101100` = `100100001`

4. `00001101 - 00000111` = `00000110`

5. 비트 수

- a. word = 16 bits
- b. doubleword = 32 bits
- c. quadword = 64 bits
- d. double quadword = 128 bits

6. 필요한 최소 비트 수

- a. 4095 = 12 bits
- b. 65534 = 16 bits
- c. 42319 = 16 bits

7. 16진수

- a. `0011 0101 1101 1010` = `35DA`
- b. `1100 1110 1010 0011` = `CEA3`
- c. `1111 1110 1101 1011` = `FEDB`

8. 2진수

- a. `0126F9D4` = `0000 0001 0010 0110 1111 1001 1101 0100`
- b. `6ACDFA95` = `0110 1010 1100 1101 1111 1010 1001 0101`
- c. `F69BDC2A` = `1111 0110 1001 1011 1101 1100 0010 1010`

9. 16진수 → 10진수

- a. `3A` = 58
- b. `1BF` = 447
- c. `1001` = 4097

10. 16진수 → 10진수

- a. `62` = 98
- b. `4B3` = 1203
- c. `29F` = 671

11. 16-bit signed decimal → 16진수

- a. `-24` = `FFE8`
- b. `-331` = `FEB5`

12. 16-bit signed decimal → 16진수

- a. `-21` = `FFEB`
- b. `-45` = `FFD3`

13. signed 16진수 → 10진수

- a. `6BF9` = 27641
- b. `C123` = -16093

14. signed 16진수 → 10진수

- a. `4CD2` = 19666
- b. `8230` = -32208

15. signed binary → 10진수

- a. `10110101` = -75
- b. `00101010` = 42
- c. `11110000` = -16

16. signed binary → 10진수

- a. `10000000` = -128
- b. `11001100` = -52
- c. `10110111` = -73

17. 10진수 → 8-bit 2의 보수

- a. `-5` = `11111011`
- b. `-42` = `11010110`
- c. `-16` = `11110000`

18. 10진수 → 8-bit 2의 보수

- a. `-72` = `10111000`
- b. `-98` = `10011110`
- c. `-26` = `11100110`

19. 16진수 덧셈

- a. `6B4 + 3FE` = `AB2`
- b. `A49 + 6BD` = `1106`

20. 16진수 덧셈

- a. `7C4 + 3BE` = `B82`
- b. `B69 + 7AD` = `1316`

21. ASCII 대문자 `B`

- 16진수: `42`
- 10진수: `66`

22. ASCII 대문자 `G`

- 16진수: `47`
- 10진수: `71`

23. 129-bit unsigned 최대값

- `2¹²⁹ - 1`
- `680564733841876926926749214863536422911`

24. 86-bit signed 최대값

- `2⁸⁵ - 1`
- `38685626227668133590597631`

25. ¬(A ∨ B) 진리표

| A | B | 결과 |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 0 |

26. ¬(A ∧ ¬B) 진리표

| A | B | 결과 |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

De Morgan 법칙: `¬(A ∧ ¬B) = ¬A ∨ B`

27. 입력이 4개면 진리표 행 수는 `2⁴ = 16개`

28. 4-input multiplexer의 selector bit 수는 `2개`

1.7.2 Algorithm Workbench
1. 16-bit binary string -> integer
def binary16_to_int(s):
    value = 0
    for ch in s:
        value = value * 2
        if ch == '1':
            value += 1
    return value


2. 32-bit hexadecimal string -> integer
def hex32_to_int(s):
    digits = "0123456789ABCDEF"
    value = 0

    for ch in s:
        ch = ch.upper()
        digit = 0
        while digits[digit] != ch:
            digit += 1
        value = value * 16 + digit

    return value


3. integer -> binary string
def int_to_binary(n):
    if n == 0:
        return "0"

    sign = ""
    if n < 0:
        sign = "-"
        n = -n

    result = ""
    while n > 0:
        result = str(n % 2) + result
        n //= 2

    return sign + result


4. integer -> hexadecimal string
def int_to_hex(n):
    if n == 0:
        return "0"

    digits = "0123456789ABCDEF"
    sign = ""

    if n < 0:
        sign = "-"
        n = -n

    result = ""
    while n > 0:
        result = digits[n % 16] + result
        n //= 16

    return sign + result


5. base b(2~10) 문자열 2개 덧셈
def add_base_b(a, b, base):
    result = ""
    carry = 0
    i = len(a) - 1
    j = len(b) - 1

    while i >= 0 or j >= 0 or carry > 0:
        x = 0 if i < 0 else ord(a[i]) - ord('0')
        y = 0 if j < 0 else ord(b[j]) - ord('0')

        total = x + y + carry
        result = chr(total % base + ord('0')) + result
        carry = total // base

        i -= 1
        j -= 1

    return result


6. hexadecimal 문자열 2개 덧셈
def add_hex(a, b):
    digits = "0123456789ABCDEF"
    result = ""
    carry = 0
    i = len(a) - 1
    j = len(b) - 1

    while i >= 0 or j >= 0 or carry > 0:
        x = 0 if i < 0 else digits.index(a[i].upper())
        y = 0 if j < 0 else digits.index(b[j].upper())

        total = x + y + carry
        result = digits[total % 16] + result
        carry = total // 16

        i -= 1
        j -= 1

    return result


7. 한 자리 hexadecimal × hexadecimal 문자열
def multiply_hex_digit(digit, number):
    digits = "0123456789ABCDEF"
    d = digits.index(digit.upper())

    result = ""
    carry = 0

    for i in range(len(number) - 1, -1, -1):
        value = digits.index(number[i].upper())
        total = d * value + carry

        result = digits[total % 16] + result
        carry = total // 16

    while carry > 0:
        result = digits[carry % 16] + result
        carry //= 16

    return result


8. Java 코드
public class Exercise8 {
    public static void main(String[] args) {
        int Y = 0;
        int X = (Y + 4) * 3;
    }
}


9. unsigned binary 뺄셈은 각 비트를 오른쪽부터 빼고, 작은 수에서 큰 수를 빼야 하면 왼쪽 비트에서 `borrow`를 가져온다. 최종 borrow는 버리면 된다.

- `00000101 - 00100000`
  = `11100101`

- `00001100 - 00010101`
  = `11110111`

- `00110010 - 01000000`
  = `11110010`

8비트 unsigned에서 작은 값에서 큰 값을 빼면 결과는 0 아래로 내려가므로, `256`을 더한 값으로 표현된다.
