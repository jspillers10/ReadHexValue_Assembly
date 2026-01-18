# Hexadecimal to Decimal Converter (MIPS Assembly)

A MIPS assembly program that converts hexadecimal strings to decimal integers with comprehensive input validation and error handling.

## Project Overview

This program demonstrates low-level programming concepts through direct implementation in MIPS assembly language. It accepts hexadecimal input from users and performs base conversion while validating input format and length constraints.

### Features

- Converts hexadecimal strings (up to 8 digits) to decimal values
- Supports both uppercase (A-F) and lowercase (a-f) hex digits
- Validates input length and character validity
- Provides detailed error messages for invalid input
- Efficient bit-shifting algorithm for base conversion

## Technical Specifications

### Input Requirements

- Maximum length: 8 hexadecimal characters
- Valid characters: 0-9, A-F, a-f
- Input format: Single line terminated by newline

### Conversion Algorithm

The program uses a shift-and-add algorithm for base conversion:

```
For each hex digit:
    result = (result << 4) + digit_value
```

Where left shift by 4 bits is equivalent to multiplying by 16 (hexadecimal base).

### Memory Layout

```
.data segment:
- hexInput:      12-byte buffer for input string
- prompt:        User prompt message
- errorMsgLong:  Length validation error
- errorMsgInvalid: Character validation error  
- resultMsg:     Output label
```

## Compilation and Execution

### Using SPIM Simulator

```bash
spim -file hex_to_decimal.s
```

### Using MARS (MIPS Assembler and Runtime Simulator)

1. Open MARS
2. Load hex_to_decimal.s
3. Assemble the program (F3)
4. Run the program (F5)

### Using QtSPIM

1. File → Load
2. Select hex_to_decimal.s
3. Click Run

## Usage Examples

### Example 1: Valid Uppercase Input
```
Enter a hexadecimal value (up to 8 characters): CAFE
Decimal value: 51966
```

### Example 2: Valid Lowercase Input
```
Enter a hexadecimal value (up to 8 characters): deadbeef
Decimal value: 3735928559
```

### Example 3: Mixed Case Input
```
Enter a hexadecimal value (up to 8 characters): 1A2b3C4d
Decimal value: 437650509
```

### Example 4: Input Too Long
```
Enter a hexadecimal value (up to 8 characters): 123456789
Error: More than 8 hex digits entered.
```

### Example 5: Invalid Character
```
Enter a hexadecimal value (up to 8 characters): 12G5
Error: Invalid hexadecimal digit - 'G'.
```

## Implementation Details

### Validation Process

1. **Length Validation**
   - Counts characters excluding newline and null terminator
   - Rejects input exceeding 8 characters
   - Handles empty input gracefully

2. **Character Validation**
   - Verifies each character is in valid hex range
   - Checks three separate ranges: '0'-'9', 'A'-'F', 'a'-'f'
   - Rejects characters in gaps between valid ranges

3. **Conversion Process**
   - Processes string left to right
   - Converts each character to its numeric value (0-15)
   - Accumulates result using shift-and-add algorithm

### Algorithm Complexity

**Time Complexity:** O(n) where n is input length (max 8)
- Single pass for length counting
- Single pass for conversion
- No nested loops

**Space Complexity:** O(1)
- Fixed 12-byte input buffer
- Constant register usage
- No dynamic memory allocation

## Register Usage

| Register | Purpose |
|----------|---------|
| $t0 | Pointer to current character in input string |
| $t1 | Character counter for length validation |
| $t2 | Current character being processed |
| $t3 | Accumulated decimal result |
| $v0 | Syscall number |
| $a0 | Syscall argument (address or value) |

## Syscalls Used

| Number | Function | Parameters |
|--------|----------|------------|
| 1 | Print integer | $a0 = integer to print |
| 4 | Print string | $a0 = address of null-terminated string |
| 8 | Read string | $a0 = buffer address, $a1 = max length |
| 10 | Exit program | None |
| 11 | Print character | $a0 = ASCII character |

## Error Handling

The program handles three error conditions:

1. **Input Length Error**
   - Triggered when input exceeds 8 hex digits
   - Displays clear error message
   - Program exits gracefully

2. **Invalid Character Error**
   - Triggered for non-hexadecimal characters
   - Shows the specific invalid character
   - Prevents incorrect conversion

3. **Empty Input**
   - Handled by checking character count
   - Program exits without error message

## Improvements from Original Implementation

The original code contained several critical bugs that have been corrected:

1. Fixed pointer management to reset position before conversion loop
2. Added support for lowercase hexadecimal digits
3. Corrected character validation to check proper ranges
4. Replaced incorrect multiplication with efficient bit-shift operation
5. Fixed loop termination logic to handle '0' digits correctly
6. Implemented proper error message formatting with character output
7. Removed redundant branches and unreachable code
8. Added comprehensive documentation and code organization

## Learning Outcomes

This project demonstrates understanding of:

- MIPS instruction set architecture and assembly syntax
- Low-level string processing and character manipulation
- Base conversion algorithms and bit-shift operations
- Input validation and error handling at assembly level
- Syscall interface for I/O operations
- Register allocation and management
- Control flow implementation with branches and jumps
- Memory organization in assembly programs

## Testing

The program has been validated against multiple test cases:

- Valid uppercase hex input (A-F)
- Valid lowercase hex input (a-f)
- Mixed case input
- Hex values containing '0' digit
- Maximum length input (8 characters)
- Input exceeding maximum length
- Invalid characters in various ranges
- Empty input
- Boundary values (0x00000000, 0xFFFFFFFF)

## Author

Jake Spillers  
Cyber Security Specialist

## Course Information

Computer Organization  
Assembly Language Programming

---

Built with MIPS assembly language  
Refined for professional portfolio presentation
