# A-CPU-Based-On-RV32I-Instruction-Set
A general RV32I CPU in Verilog
This project is is designed as a five-stage pipeline with single emission sequencing CPU based on RV32I instruction set.
The CPU an implement basic integer operations, register reading and writing, jump operations, and support risky processing mechanisms such as pipeline flushing, pipeline stalling, bypass network,etc.
This project passed the simulation and logic verification via Cadence IES environment.
The top design of the CPU is the Core.v file.
