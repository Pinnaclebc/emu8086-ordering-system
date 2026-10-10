# emu8086 Ordering System

## Description

A basic ordering system written in emu8086 assembly language. The program displays a fixed menu, accepts an item selection, receives payment, and calculates the change.

This project is designed for beginners learning basic assembly language concepts.

## Features

- Displays a fixed menu of food items and decimal PHP prices.
- Accepts an item choice from the user.
- Displays the selected item and its price.
- Accepts a one-digit payment amount.
- Calculates change using subtraction.
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

   - `1` for Burger — 59.50 PHP
   - `2` for Fries — 35.00 PHP
   - `3` for Soda — 20.00 PHP

3. Enter a one-digit payment amount.
4. The program displays the calculated change.

The menu items and prices are fixed directly in the assembly source code.
