#!/bin/bash

echo "Compiling RISC-V CPU..."

iverilog -o sim/tb_top.vvp tb/tb_top.v rtl/*.v

echo "Compilation complete."