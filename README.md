# emu8086 Ordering System

## Description

A basic ordering system written in emu8086 assembly language. The program displays a fixed menu, accepts an item selection, receives a payment from 0 to 255, and calculates the change.

This project is designed for beginners learning basic assembly language concepts.

## Features

- Displays a fixed menu of food items and decimal PHP prices.
- Provides a `4. Exit` option at the main menu.
- Returns to the main menu when an invalid menu option is entered.
- Accepts any valid 8-bit decimal payment from 0 to 255.
- Rejects invalid and oversized payment input.
- Displays multi-digit change values.
- Asks whether the user wants to place another order.
- Uses procedures to keep the program modular.
- Includes the required `newline` procedure.
- Uses DOS interrupt `21H` for input and output.

## Tech Stack

- emu8086 assembly language
- DOS interrupt `21H`
- Procedures
- Basic input and output
- Addition and subtraction

## Installation

1. Install and open emu8086.
2. Clone this repository:

   ```powershell
   git clone https://github.com/Pinnaclebc/emu8086-ordering-system.git
   ```

3. Open `ordering_system.asm` in emu8086.
4. Assemble and run the program.

## Usage

1. Run the program.
2. Select an item by entering:

   - `1` for Burger — 5.00 PHP
   - `2` for Fries — 3.00 PHP
   - `3` for Soda — 2.00 PHP
   - `4` to exit

3. Enter a payment from `0` to `255`, such as `100`.
4. The program displays the calculated change.
5. Enter `Y` to place another order or `N` to exit.

Invalid menu selections do not close the program; they return to the main menu.
