
# GargantuRAM

[![License: CERN OHL-P v2](https://img.shields.io/badge/Hardware_License-CERN_OHL--P_v2-blue)](https://ohwr.org/cern_ohl_p_v2.txt)
[![Status: Hardware Prototype Verified](https://img.shields.io/badge/Status-Hardware_Prototype_Verified-green)]()
[![Architecture: Balanced Ternary](https://img.shields.io/badge/Architecture-Balanced_Ternary-orange)]()

GargantuRAM is the open hardware development board for the **5500FP**, a 24-trit balanced ternary RISC processor.  
It is part of the **Ternary Computer System** initiative, focused on developing hardware and software components for non-binary computation.

> Physical boards have been successfully manufactured and verified. The 5500FP is fully operational on hardware.

---

## Overview

The **GargantuRAM 1.5 PRE** is the reference development board for the 5500FP CPU module. It accepts the CPU module via an edge connector and provides all the supporting infrastructure needed to run and program the processor: static RAM, mass storage, serial communication, and the analog circuitry that translates between binary logic levels and the balanced ternary voltage domain (±3.3 V).

The board is implemented on an **Efinix Trion T120F484** FPGA and clocked at **20 MHz** via a dedicated on-board oscillator, ensuring a clean and stable reference for the CPU module.

---

## Board Peripherals

| Interface | Details |
|---|---|
| CPU Module connector | Edge connector for the 5500FP CPU module |
| Static RAM | Three ISS static RAM modules (RAM_0, RAM_1, RAM_2) |
| SPI ROM | Non-volatile storage for boot code and firmware images |
| SPI SD card | Removable mass storage for programs and data |
| Serial interfaces | 2× UART over USB (SER_1USB, SER_2) — program loading and host communication |
| Power section | On-board power regulation |

---

## Repository Structure
- `Altium Project/` — Project files for Altium.
- `Docs/` — Schematics and documentations.
- `Img/` — Photo and rendering.


---

## License

This project is released under the **CERN-OHL-P v2** license.  
See the `LICENSE` file for the full text.

### Required Notice (CERN-OHL-P v2, Clause 4.2)
Any Product made using this Source must include the following notice:

> **"This Product is based on CERN‑OHL‑P licensed Source, available at https://github.com/Ternary-Computer-System/GargantuRAM."**

---

## Project Information

For more details about the Ternary Computer System:  
https://www.ternary-computing.com