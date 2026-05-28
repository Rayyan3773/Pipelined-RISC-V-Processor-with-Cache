#!/bin/bash

echo "Running simulation..."

vvp sim/tb_top.vvp

echo "Opening waveform..."

gtkwave dump.vcd