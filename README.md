# GargantuRAM

[![License: CERN OHL-P v2](https://img.shields.io/badge/Hardware_License-CERN_OHL--P_v2-blue)](https://ohwr.org/cern_ohl_p_v2.txt)
[![Status: Hardware Prototype Verified](https://img.shields.io/badge/Status-Hardware_Prototype_Verified-green)]()
[![Architecture: Balanced Ternary](https://img.shields.io/badge/Architecture-Balanced_Ternary-orange)]()
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.18881738-blue)](https://doi.org/10.5281/zenodo.18881738)



GargantuRAM is the open hardware development board for the **5500FP**, a 24-trit balanced ternary RISC processor.  
It is part of the **Ternary Computer System** initiative, focused on developing hardware and software components for non-binary computation.

> Physical boards have been successfully manufactured and verified. The 5500FP is fully operational on hardware.

---

## Overview

The **GargantuRAM 1.5 PRE** is the reference development board for the 5500FP CPU module. It accepts the CPU module via an edge connector and provides all the supporting infrastructure needed to run and program the processor: static RAM, mass storage, serial communication, and a ternary/binary bridge that adapts the signals of the 5500FP ternary CPU to the binary circuitry of this board, allowing immediate use of standard binary peripherals.

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
- `Img/` — Photo and rendering.
- `Docs/` — Schematics and documentations.

> **Note on PCB routing:** The current layout is fully functional and has been used to produce verified physical boards (MiniITX form factor). The routing is not yet optimized — improvements are planned for a future revision. Contributions and review from experienced PCB designers are welcome.

---

## Related Repositories

| Repository | Contents |
|---|---|
| [GargantuRAM_ROM](https://github.com/Ternary-Computer-System/GargantuRAM_ROM) | Firmware for the SPI ROM |
| [GargantuRAM_VHDL](https://github.com/Ternary-Computer-System/GargantuRAM_VHDL) | FPGA source code (VHDL) |

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
