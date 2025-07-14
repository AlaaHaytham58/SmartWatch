# Smartwatch Desk Clock

## Overview
Our smartwatch is a versatile desk clock that incorporates various functionalities, including:

- ⏱ **Timer**
- ⏳ **Stopwatch**
- ⏰ **Alarm**
- 🌡 **Temperature and Humidity Reading**
- 📅 **Real-time Day and Time Display**
- 🎨 **Color and Theme Changing Layouts**

This project pushes the limits of the **STM32F103C8T6 (Blue Pill) microcontroller**, utilizing advanced features and techniques to achieve a fully functional smartwatch experience.

## Hardware & Features
To bring this project to life, we implemented:

- 🔹 **TIMER** – Used for precision timing.
- 🔹 **RTC (Real-Time Clock)** – Ensures accurate timekeeping and data storing.
- 🔹 **Flash Memory** – Stores images and other essential data.
- 🔹 **GPIOs** – Fully utilized for seamless device connectivity.
- 🔹 **TFT Display (ILI9486 driver)** – Provides an interactive user-friendly interface.
- 🔹 **Buzzer** – Used for alarm and sound notifications.
- 🔹 **Buttons** – Enables user interaction.

## Unique Challenges & Achievements
What makes this project unique:

- 🛠 **Written entirely in assembly language**, including the **I2C communication protocol**, which is not commonly available online.
- 🏆 **The only team to take on this challenge**, pushing the limits of low-level programming.
- ⏳ **Optimized for limited hardware resources** while working within a tight deadline.

## Development Environment
- **Microcontroller:** STM32F103C8T6 (Blue Pill)
- **Programming Language:** Assembly
- **Compiler & IDE:** Keil uVision
- **Display Driver:** ILI9486

## Installation & Usage
To use or modify this project:
1. Clone the repository:
   ```sh
   git clone https://github.com/AlaaHaytham58/SmartWatch.git
   ```
2. Open the project in **Keil uVision**.
3. Flash the compiled binary onto an STM32F103C8T6 (Blue Pill) microcontroller.
4. Connect the **TFT display, buttons, and buzzer** as per the circuit diagram.
5. Power the microcontroller and enjoy the smartwatch features!

## Contributions
We welcome contributions! Feel free to:
- Open issues for bugs and improvements.
- Submit pull requests with enhancements.
- Share your experiences and suggestions.

💻 **Made with passion for embedded systems & low-level programming!** ⚙️

