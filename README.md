# RISC-V Pipelined CPU (Verilog)

This project is a 5-stage pipelined RISC-V CPU written in Verilog with a simple data cache and basic hazard handling.

I built this project to understand how an actual processor pipeline works internally instead of only studying theory from textbooks. The main focus was on pipeline flow, cache behavior, stalls, forwarding logic, and debugging RTL issues during simulation.

The design was gradually improved by fixing problems like incorrect writeback, pipeline synchronization bugs, cache stalls, and X propagation during simulation.

---

# Pipeline Stages

The CPU uses a standard 5-stage pipeline:

1. IF  - Instruction Fetch  
2. ID  - Instruction Decode  
3. EX  - Execute  
4. MEM - Memory Access  
5. WB  - Write Back  

Pipeline registers are used between every stage:
- IF/ID
- ID/EX
- EX/MEM
- MEM/WB

---

# Features

## CPU Core
- 5-stage pipelined architecture
- Verilog RTL implementation
- ALU operations:
  - ADD
  - SUB
  - AND
  - OR
  - XOR
  - SLT
- Register file
- Immediate generator
- Control unit

---

## Pipeline and Hazard Handling
- Pipeline register implementation
- Stall support
- Forwarding unit
- Reset-safe pipeline registers
- Basic RAW hazard handling

---

## Cache and Memory
- Instruction memory
- Data memory
- Direct mapped data cache
- Cache hit/miss handling
- Valid bit + tag logic
- Stall generation during cache miss
- Write-through cache behavior

---

# Verification

To improve the verification side of the project, assertion-based verification files were also added using SystemVerilog.

The verification files check:
- ALU correctness
- Pipeline register behavior
- Forwarding logic
- Cache interface consistency

Files added:
- `fv_alu.sv`
- `fv_pipeline.sv`
- `fv_forwarding.sv`
- `fv_cache.sv`

These were added mainly to learn more about RTL verification and formal verification style assertions.

---

# Tools Used

- Verilog HDL
- SystemVerilog Assertions (SVA)
- Icarus Verilog
- GTKWave
- Vivado
- Git

---

# Project Structure

```text
│   README.md
│
├── rtl
│   ├── alu.v
│   ├── alu_control.v
│   ├── branch_predictor.v
│   ├── control_unit.v
│   ├── data_cache.v
│   ├── data_memory.v
│   ├── forwarding_unit.v
│   ├── immediate_generator.v
│   ├── instruction_memory.v
│   ├── mux.v
│   ├── pc.v
│   ├── register_file.v
│   ├── stall_unit.v
│   └── top_module.v
│
├── fv
│   ├── fv_alu.sv
│   ├── fv_pipeline.sv
│   ├── fv_forwarding.sv
│   └── fv_cache.sv
│
├── tb
├── sim
├── docs
└── programs



# Running Simulation

## Compile

```bash
iverilog -o sim/tb_top.vvp tb/tb_top.v rtl/*.v
```

## Simulation

```bash
vvp sim/tb_top.vvp
```

## Open Waveform

```bash
gtkwave dump.vcd
```

---

# Some Problems Faced During Development

Some issues that took time to debug:

- X propagation due to uninitialized pipeline registers
- Incorrect writeback behavior
- Cache stalls affecting pipeline flow
- Hazard handling bugs
- Forwarding path connection mistakes
- Pipeline synchronization issues between stages
