; Basic Ordering System
; emu8086 / DOS assembly program
; Prices are fixed and stored in the DATA segment.

.MODEL SMALL
.STACK 100H

.DATA
menuTitle       DB 0DH, 0AH, '==== SIMPLE ORDERING SYSTEM ====', 0DH, 0AH, '$'
item1Text      DB '1. Burger - 5.00 PHP', 0DH, 0AH, '$'
item2Text      DB '2. Fries  - 3.00 PHP', 0DH, 0AH, '$'
item3Text      DB '3. Soda   - 2.00 PHP', 0DH, 0AH, '$'
exitText       DB '4. Exit', 0DH, 0AH, '$'
chooseText     DB 'Choose an item: $'
selectedText   DB 'You selected: $'
burgerText      DB 'Burger', '$'
friesText       DB 'Fries', '$'
sodaText        DB 'Soda', '$'
priceText       DB 0DH, 0AH, 'Price: $'
price1Text      DB '5.00 PHP', '$'
price2Text      DB '3.00 PHP', '$'
price3Text      DB '2.00 PHP', '$'
paymentText     DB 0DH, 0AH, 'Enter payment (0-255): $'
changeText      DB 0DH, 0AH, 'Your change is: $'
thankYouText    DB 0DH, 0AH, 'Thank you for ordering!', 0DH, 0AH, '$'
invalidText     DB 0DH, 0AH, 'Invalid choice.', 0DH, 0AH, '$'
invalidPaymentText DB 0DH, 0AH, 'Please enter a number from 0 to 255.', 0DH, 0AH, '$'
insufficientText DB 0DH, 0AH, 'Payment is not enough for this item.', 0DH, 0AH, '$'
againText      DB 0DH, 0AH, 'Would you like to order again? (Y/N): $'

total           DB 0
payment         DB 0
change          DB 0
pricePointer    DW 0

.CODE
main PROC
    MOV AX, @DATA
    MOV DS, AX

    JMP mainMenu

chooseBurger:
    MOV DX, OFFSET burgerText
    MOV pricePointer, OFFSET price1Text
    MOV total, 5
    JMP showOrder

chooseFries:
    MOV DX, OFFSET friesText
    MOV pricePointer, OFFSET price2Text
    MOV total, 3
    JMP showOrder

chooseSoda:
    MOV DX, OFFSET sodaText
    MOV pricePointer, OFFSET price3Text
    MOV total, 2

showOrder:
    ; Display the selected item.
    MOV AH, 09H
    PUSH DX
    MOV DX, OFFSET selectedText
    INT 21H
    POP DX
    INT 21H

    ; Display the fixed price.
    MOV AH, 09H
    MOV DX, OFFSET priceText
    INT 21H
    MOV DX, pricePointer
    INT 21H

    ; Read an 8-bit payment, then subtract the price from it.
    MOV AH, 09H
    MOV DX, OFFSET paymentText
    INT 21H
    CALL readNumber
    JC invalidPayment
    MOV payment, AL
    CALL newline

    MOV AL, payment
    CMP AL, total
    JB insufficientPayment
    SUB AL, total
    MOV change, AL

    ; Display the change and finish.
    MOV AH, 09H
    MOV DX, OFFSET changeText
    INT 21H
    MOV AL, change
    CALL printNumber

    MOV AH, 09H
    MOV DX, OFFSET thankYouText
    INT 21H

askAgain:
    CALL askOrderAgain
    CMP AL, 'Y'
    JE restartOrder
    CMP AL, 'y'
    JE restartOrder
    CMP AL, 'N'
    JE programExit
    CMP AL, 'n'
    JE programExit

    MOV AH, 09H
    MOV DX, OFFSET invalidText
    INT 21H
    JMP askAgain

restartOrder:
    CALL newline
    JMP mainMenu

invalidPayment:
    MOV AH, 09H
    MOV DX, OFFSET invalidPaymentText
    INT 21H
    JMP showOrder

insufficientPayment:
    MOV AH, 09H
    MOV DX, OFFSET insufficientText
    INT 21H
    JMP showOrder

mainMenu:
    CALL displayMenu
    CALL getChoice
    MOV BL, AL
    CALL newline

    ; Select an item and store its fixed price in total.
    CMP BL, '1'
    JE chooseBurger
    CMP BL, '2'
    JE chooseFries
    CMP BL, '3'
    JE chooseSoda
    CMP BL, '4'
    JE programExit

    ; Invalid choices return to the main menu.
    MOV AH, 09H
    MOV DX, OFFSET invalidText
    INT 21H
    JMP mainMenu

programExit:
    MOV AH, 4CH
    INT 21H
main ENDP

; Display the fixed menu.
displayMenu PROC
    MOV AH, 09H
    MOV DX, OFFSET menuTitle
    INT 21H
    MOV DX, OFFSET item1Text
    INT 21H
    MOV DX, OFFSET item2Text
    INT 21H
    MOV DX, OFFSET item3Text
    INT 21H
    MOV DX, OFFSET exitText
    INT 21H
    RET
displayMenu ENDP

; Show the prompt and return the typed ASCII character in AL.
getChoice PROC
    MOV AH, 09H
    MOV DX, OFFSET chooseText
    INT 21H
    MOV AH, 01H
    INT 21H
    RET
getChoice ENDP

; Read a decimal number from 0 to 255.
readNumber PROC
    MOV BX, 0
readNumberLoop:
    MOV AH, 01H
    INT 21H
    CMP AL, 0DH
    JE readNumberDone
    CMP AL, '0'
    JB readNumberInvalid
    CMP AL, '9'
    JA readNumberInvalid

    SUB AL, '0'
    MOV DL, AL
    MOV SI, BX
    MOV BX, 0
    MOV CX, 10

multiplyByTen:
    ADD BX, SI
    DEC CX
    JNZ multiplyByTen

    CMP BX, 255
    JA readNumberInvalid
    ADD BL, DL
    CMP BX, 255
    JA readNumberInvalid
    JMP readNumberLoop

readNumberDone:
    MOV AX, BX
    CLC
    RET

readNumberInvalid:
readInvalidRest:
    MOV AH, 01H
    INT 21H
    CMP AL, 0DH
    JNE readInvalidRest
    STC
    RET
readNumber ENDP

; Read Y or N for another order.
askOrderAgain PROC
    MOV AH, 09H
    MOV DX, OFFSET againText
    INT 21H
    MOV AH, 01H
    INT 21H
    RET
askOrderAgain ENDP

; Convert a number from 0 to 9 into ASCII and print it.
printDigit PROC
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
printDigit ENDP

; Print an unsigned number from 0 to 255.
printNumber PROC
    MOV BL, 0

hundredsLoop:
    CMP AL, 100
    JB tensStart
    SUB AL, 100
    INC BL
    JMP hundredsLoop

tensStart:
    MOV BH, 0

tensLoop:
    CMP AL, 10
    JB printNumberDigits
    SUB AL, 10
    INC BH
    JMP tensLoop

printNumberDigits:
    CMP BL, 0
    JE checkTens
    PUSH AX
    MOV AL, BL
    CALL printDigit
    POP AX

checkTens:
    CMP BL, 0
    JNE printTens
    CMP BH, 0
    JE printOnes

printTens:
    PUSH AX
    MOV AL, BH
    CALL printDigit
    POP AX

printOnes:
    CALL printDigit
    RET
printNumber ENDP

; Move to the next line.
newline PROC
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    MOV DL, 0DH
    INT 21H
    RET
newline ENDP

END main
