````markdown
# AMBA AHB Bus Protocol

A Verilog RTL implementation and verification project based on the
AMBA Advanced High-performance Bus (AHB-Lite) protocol.

The project demonstrates AHB transaction handling through a simple
master, memory slave, bus interconnection and simulation-based
verification.

---

## Overview

AMBA AHB is a high-performance on-chip communication protocol used
in System-on-Chip (SoC) designs.

This project implements a simplified AHB-Lite system to demonstrate:

- Address and data phases
- Read transactions
- Write transactions
- AHB transfer types
- HREADY response
- HRESP response
- Memory-mapped transfers
- Basic error handling
- RTL simulation and verification

---

## Architecture

```text
                 +----------------+
                 |   AHB Master   |
                 +--------+-------+
                          |
                          |
                    AHB-Lite Bus
                          |
                          |
                 +--------v-------+
                 |  AHB Memory    |
                 |     Slave      |
                 +----------------+
````

---

## Repository Structure

```text
AMBA-AHB-Bus-Protocol/
│
├── rtl/
│   ├── ahb_master.v
│   ├── ahb_slave.v
│   ├── ahb_memory.v
│   ├── ahb_interconnect.v
│   └── ahb_top.v
│
├── tb/
│   ├── ahb_master_tb.v
│   ├── ahb_slave_tb.v
│   └── ahb_top_tb.v
│
├── docs/
│   ├── architecture.md
│   ├── protocol.md
│   └── verification.md
│
├── sim/
├── waves/
│
├── README.md
├── LICENSE
├── CHANGELOG.md
└── .gitignore
```

---

## AHB Signals

| Signal  | Description            |
| ------- | ---------------------- |
| HCLK    | Bus clock              |
| HRESETn | Active-low reset       |
| HADDR   | Transfer address       |
| HTRANS  | Transfer type          |
| HWRITE  | Read/write control     |
| HSIZE   | Transfer size          |
| HBURST  | Burst information      |
| HPROT   | Protection information |
| HWDATA  | Write data             |
| HRDATA  | Read data              |
| HREADY  | Transfer completion    |
| HRESP   | Transfer response      |

---

## HTRANS

| HTRANS | Meaning |
| ------ | ------- |
| 00     | IDLE    |
| 01     | BUSY    |
| 10     | NONSEQ  |
| 11     | SEQ     |

The implementation primarily uses NONSEQ transfers for individual
read/write transactions.

---

## Basic Transaction

An AHB transfer consists conceptually of:

```text
Address Phase
     |
     v
+----------+
| HADDR    |
| HTRANS   |
| HWRITE   |
| HSIZE    |
+----------+
     |
     v
Data Phase
     |
     v
+----------+
| HWDATA   |  Write
| HRDATA   |  Read
| HREADY   |
| HRESP    |
+----------+
```

---

## Verification

The testbench verifies:

### 1. Write

```text
Address = 0x00000010
Data    = 0xDEADBEEF
```

### 2. Read

The same address is subsequently read.

Expected result:

```text
HRDATA = 0xDEADBEEF
```

### 3. Result

```text
TEST PASSED
```

---

## Tools

The RTL can be simulated using:

* Xilinx Vivado
* ModelSim
* QuestaSim
* Icarus Verilog
* Verilator

---

## Scope

This repository is intended as an educational RTL implementation
and is not claimed to be a complete production AHB5 implementation.

Future versions can extend the design with:

* Burst transfers
* Multiple slaves
* Address decoding
* Bus arbitration
* Wait-state generation
* ERROR responses
* AHB-to-APB bridge
* SystemVerilog assertions
* Functional coverage
* UVM-based verification

---

## Reference

The implementation is based on publicly available Arm AMBA
AHB/AHB-Lite protocol documentation.

Official specification:

https://documentation-service.arm.com/static/5f91607cf86e16515cdc3b4b

---

## Author

**Vishu Sharma**

B.Tech – Electronics and Communication Engineering

MNNIT Allahabad

---

## License

This project is provided for educational and research purposes.

```
```
