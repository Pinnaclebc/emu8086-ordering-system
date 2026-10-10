; Basic Ordering System
; emu8086 / DOS assembly program
; Prices are fixed and stored in the DATA segment.

.MODEL SMALL
.STACK 100H

.DATA
menuTitle       DB 0DH, 0AH, '===== SIMPLE ORDERING SYSTEM =====', 0DH, 0AH, '$'
item1Text      DB '1. Burger  - $5', 0DH, 0AH, '$'
item2Text      DB '2. Fries   - $3', 0DH, 0AH, '$'
item3Text      DB '3. Soda    - $2', 0DH, 0AH, '$'
chooseText     DB 'Choose an item (1-3): $'
selectedText   DB 'You selected: $'
burgerText     DB 'Burger', '$'
friesText      DB 'Fries', '$'
sodaText       DB 'Soda', '$'
priceText      DB 0DH, 0AH, 'Price: $'
paymentText    DB 0DH, 0AH, 'Enter payment (one digit): $'
changeText     DB 0DH, 0AH, 'Your change is: $'
thankYouText   DB 0DH, 0AH, 'Thank you for ordering!', 0DH, 0AH, '$'
invalidText    DB 0DH, 0AH, 'Invalid choice.', 0DH, 0AH, '$'

total          DB 0
payment        DB 0
change         DB 0

.CODE
main PROC
    MOV AX, @DATA
    MOV DS, AX

    CALL displayMenu
    CALL getChoice
    CALL newline

    ; Select an item and store its fixed price in total.
    CMP AL, '1'
    JE chooseBurger
    CMP AL, '2'
    JE chooseFries
    CMP AL, '3'
    JE chooseSoda

    ; Any other key is rejected.
    MOV AH, 09H
    MOV DX, OFFSET invalidText
    INT 21H
    JMP programExit

chooseBurger:
    MOV DX, OFFSET burgerText
    MOV total, 5
    JMP showOrder

chooseFries:
    MOV DX, OFFSET friesText
    MOV total, 3
    JMP showOrder

chooseSoda:
    MOV DX, OFFSET sodaText
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
    MOV AL, total
    CALL printDigit

    ; Read payment, then subtract the price from it.
    MOV AH, 09H
    MOV DX, OFFSET paymentText
    INT 21H
    CALL readDigit
    CALL newline
    MOV payment, AL

    MOV AL, payment
    SUB AL, total
    MOV change, AL

    ; Display the change and finish.
    MOV AH, 09H
    MOV DX, OFFSET changeText
    INT 21H
    MOV AL, change
    CALL printDigit

    MOV AH, 09H
    MOV DX, OFFSET thankYouText
    INT 21H

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

; Read one payment digit and convert ASCII to a number.
readDigit PROC
    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    RET
readDigit ENDP

; Convert a number from 0 to 9 into ASCII and print it.
printDigit PROC
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
printDigit ENDP

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
