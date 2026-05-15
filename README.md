# AXI4-Lite RAM Controller using Verilog

This project implements a simple **AXI4-Lite RAM Controller** using **Verilog HDL**. The design supports **read and write operations** using the **AXI4-Lite protocol** and is verified using **Xilinx Vivado simulation**.

---

# Project Overview

This project demonstrates communication between an **AXI4-Lite Slave Interface** and a **RAM module**.

## Features

- AXI4-Lite Write Address Channel
- AXI4-Lite Write Data Channel
- AXI4-Lite Write Response Channel
- AXI4-Lite Read Address Channel
- AXI4-Lite Read Data Channel
- RAM Read/Write Operations
- Simulation using Xilinx Vivado
- Waveform Verification

---

# AXI4-Lite Protocol

AXI4-Lite is a lightweight version of the AXI protocol used for:

- Register access
- Memory-mapped communication
- Peripheral interfacing
- Low-bandwidth applications

Unlike **Full AXI4**, AXI4-Lite **does not support burst transfer**.

Therefore, the following signals are **not present** in AXI4-Lite:

```text
WLAST
RLAST
AWLEN
ARLEN
AWSIZE
ARSIZE
AWBURST
ARBURST
```

This project uses a **single data transfer per transaction**.

---

# Project Structure

```text
axi_protocol/
│── ram_design.v
│── axi_top_ram.v
│── tb_axi_top_ram.v
│── waveform.jpg
│── README.md
```

---

# File Description

## 1. ram_design.v

This module implements a synchronous RAM.

### Functions

- Memory Write Operation
- Memory Read Operation
- Reset Handling

### Inputs

| Signal | Description |
|--------|-------------|
| clk | Clock signal |
| rst_n | Active low reset |
| wr_enb | Write enable |
| addr | Memory address |
| wdata | Write data |

### Output

| Signal | Description |
|--------|-------------|
| rdata | Read data |

---

## 2. axi_top_ram.v

This is the **Top-Level AXI4-Lite Slave Module**.

It handles:

- AXI Write Transactions
- AXI Read Transactions
- RAM Communication

### AXI Channels Used

```text
AW Channel → Write Address
W Channel  → Write Data
B Channel  → Write Response
AR Channel → Read Address
R Channel  → Read Data
```

### Write Flow

1. Master sends write address
2. Slave accepts address
3. Master sends write data
4. RAM stores data
5. Slave sends response

### Read Flow

1. Master sends read address
2. Slave accesses RAM
3. RAM returns data
4. Slave sends read response

---

## 3. tb_axi_top_ram.v

This is the **Testbench File** used to verify the design.

### Operations Performed

#### Write Transactions

| Address | Data |
|----------|------|
| 0x1 | DEADBEEF |
| 0x2 | 12345678 |
| 0x3 | AAAAAAAA |

#### Read Verification

The written data is read back and verified.

---

# Simulation Result

The simulation waveform confirms:

✅ Successful AXI Write Transaction  
✅ Successful AXI Read Transaction  
✅ Correct Handshake Signals  
✅ Proper Data Transfer  
✅ Correct RAM Read/Write Operation

---

# Waveform

Save your waveform screenshot as:

```text
waveform.jpg
```

Then place it inside the project folder.

The image will automatically display below.

```md
![Waveform](waveform.jpg)
```

![Waveform](waveform.jpg)

---

# Expected Simulation Output

```text
=================================
      AXI RAM TEST START
=================================

WRITE -> ADDR = 1 DATA = DEADBEEF
READ  -> ADDR = 1 DATA = DEADBEEF
TEST1 PASS

WRITE -> ADDR = 2 DATA = 12345678
READ  -> ADDR = 2 DATA = 12345678
TEST2 PASS

WRITE -> ADDR = 3 DATA = AAAAAAAA
READ  -> ADDR = 3 DATA = AAAAAAAA
TEST3 PASS

=================================
       SIMULATION END
=================================
```

---

# Tools Used

| Tool | Description |
|------|-------------|
| Verilog HDL | Hardware Description Language |
| Xilinx Vivado | Simulation Tool |
| AXI4-Lite | Communication Protocol |

---

# How to Run the Project

## Step 1: Open Vivado

Create a new project and add the following files:

```text
ram_design.v
axi_top_ram.v
tb_axi_top_ram.v
```

---

## Step 2: Set Top Module

Set:

```text
tb_axi_top_ram.v
```

as the **Top Module**.

---

## Step 3: Run Simulation

Click:

```text
Run Simulation → Run Behavioral Simulation
```

Or use TCL console:

```tcl
launch_simulation
run all
```

---

# Clone Repository

```bash
git clone https://github.com/your-username/your-repository-name.git
```

---

# GitHub Upload Commands

```bash
git init
git add .
git commit -m "Added AXI4-Lite RAM Controller Project"
git branch -M main
git remote add origin https://github.com/rohit_baskey08/AXI14_LITE-protocol.git
git push -u origin main
```

---

# Author

## Rohit Baskey

Electronics and Communication Engineering Student

Interested in:

- VLSI Design
- Digital Electronics
- Verilog HDL
- FPGA Design
- Verification

---
