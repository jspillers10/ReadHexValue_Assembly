################################################################################
# Hexadecimal to Decimal Converter
#
# Author: Jake Spillers
# Course: Computer Organization
# Description:
#   Converts user-input hexadecimal strings (up to 8 digits) to decimal values.
#   Implements input validation, length checking, and proper error handling.
#
# Features:
#   - Validates hexadecimal input (0-9, A-F, case-insensitive)
#   - Enforces 8-character maximum length
#   - Provides detailed error messages
#   - Handles both uppercase and lowercase hex digits
################################################################################

# Hexadecimal to Decimal Converter
#
# Author: Jake Spillers
# Course: Computer Organization
# Date: September 2023
#
# Description:
#   Converts user-input hexadecimal strings (up to 8 digits) to decimal values.
#   Implements input validation, length checking, and proper error handling.
#
# Features:
#   - Validates hexadecimal input (0-9, A-F, case-insensitive)
#   - Enforces 8-character maximum length
#   - Provides detailed error messages
#   - Handles both uppercase and lowercase hex digits


    .data
hexInput:
    .space 12                   # Buffer for input string (8 hex + newline + null)
    
prompt:
    .asciiz "Enter a hexadecimal value (up to 8 characters): "
    
errorMsgLong:
    .asciiz "Error: More than 8 hex digits entered.\n"
    
errorMsgInvalid:
    .asciiz "Error: Invalid hexadecimal digit - '"
    
errorMsgEnd:
    .asciiz "'.\n"
    
resultMsg:
    .asciiz "Decimal value: "
    
newline:
    .asciiz "\n"

    .text
    .globl main

# Main Program Entry Point
main:
    # Display prompt to user
    li      $v0, 4              # syscall: print string
    la      $a0, prompt
    syscall

    # Read hexadecimal input string from user
    li      $v0, 8              # syscall: read string
    la      $a0, hexInput
    li      $a1, 12             # max characters to read
    syscall

    # Initialize registers for length checking
    la      $t0, hexInput       # $t0 = pointer to input string
    li      $t1, 0              # $t1 = character counter

# Count Input Length (excluding newline and null terminator)
count_length:
    lb      $t2, ($t0)          # Load current character
    beq     $t2, 10, validate_length    # Stop at newline (ASCII 10)
    beqz    $t2, validate_length        # Stop at null terminator
    
    addi    $t1, $t1, 1         # Increment counter
    addi    $t0, $t0, 1         # Move to next character
    j       count_length

# Validate Input Length (must be <= 8 characters)
validate_length:
    bgt     $t1, 8, error_too_long      # Error if > 8 hex digits
    beqz    $t1, exit                   # Exit if empty input

    # Initialize conversion variables
    la      $t0, hexInput       # Reset pointer to start of string
    li      $t3, 0              # $t3 = accumulated decimal value

# Convert Hexadecimal to Decimal
convert_loop:
    lb      $t2, ($t0)          # Load current character
    beq     $t2, 10, print_result       # Stop at newline
    beqz    $t2, print_result           # Stop at null terminator

    # Validate and convert hex digit to value (0-15)
    # Check for '0'-'9' (ASCII 48-57)
    blt     $t2, '0', error_invalid
    ble     $t2, '9', convert_numeric
    
    # Check for 'A'-'F' (ASCII 65-70)
    blt     $t2, 'A', error_invalid
    ble     $t2, 'F', convert_upper
    
    # Check for 'a'-'f' (ASCII 97-102)
    blt     $t2, 'a', error_invalid
    bgt     $t2, 'f', error_invalid

convert_lower:
    # Convert 'a'-'f' to value 10-15
    sub     $t2, $t2, 'a'
    addi    $t2, $t2, 10
    j       accumulate_value

convert_upper:
    # Convert 'A'-'F' to value 10-15
    sub     $t2, $t2, 'A'
    addi    $t2, $t2, 10
    j       accumulate_value

convert_numeric:
    # Convert '0'-'9' to value 0-9
    sub     $t2, $t2, '0'

accumulate_value:
    # Shift accumulated value left by 4 bits (multiply by 16)
    sll     $t3, $t3, 4
    
    # Add current hex digit value
    add     $t3, $t3, $t2
    
    # Move to next character
    addi    $t0, $t0, 1
    j       convert_loop

# Print Decimal Result
print_result:
    # Print result message
    li      $v0, 4
    la      $a0, resultMsg
    syscall

    # Print decimal value
    li      $v0, 1
    move    $a0, $t3
    syscall

    # Print newline
    li      $v0, 4
    la      $a0, newline
    syscall
    
    j       exit

# Error Handlers
error_too_long:
    # Print error message for input exceeding 8 characters
    li      $v0, 4
    la      $a0, errorMsgLong
    syscall
    j       exit

error_invalid:
    # Print error message for invalid hexadecimal character
    li      $v0, 4
    la      $a0, errorMsgInvalid
    syscall
    
    # Print the invalid character
    li      $v0, 11             # syscall: print character
    move    $a0, $t2
    syscall
    
    # Print closing message
    li      $v0, 4
    la      $a0, errorMsgEnd
    syscall
    j       exit

# Program Exit
exit:
    # Terminate program
    li      $v0, 10             # syscall: exit
    syscall