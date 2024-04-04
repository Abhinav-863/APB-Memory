# APB-Memory
The provided Verilog code implements an APB (Advanced Peripheral Bus) memory module. Let's break down the code and discuss the APB memory interface.

APB Memory Interface:
The APB (Advanced Peripheral Bus) is a low-power, low-latency, easy-to-implement interface widely used for connecting low-bandwidth peripherals with processors. It typically consists of the following signals:

pclk: Clock signal for the interface.
presetn: Active-low asynchronous reset signal.
paddr: Address bus for memory access.
psel: Chip select signal indicating if the peripheral is selected.
penable: Enable signal indicating a valid access.
pwrite: Write enable signal.
pwdata: Data bus for write operation.
prdata: Data bus for read operation.
pready: Ready signal indicating the module is ready for a new transaction.
pslverr: Error signal indicating an error condition (not used in this implementation).
apb_memory Module:
Parameters:

data_width: Width of the data bus.
mem_depth: Depth of the memory.
addr_width: Width of the address bus.
Inputs:

pclk: Clock signal.
presetn: Asynchronous reset signal.
paddr: Address input for memory access.
psel: Chip select input.
penable: Enable signal for memory access.
pwrite: Write enable signal.
pwdata: Data input for write operation.

Outputs:

prdata: Data output for read operation.
pready: Ready signal indicating the module is ready for a new transaction.
pslverr: Error signal.

Internal Signals:

w_wr_enable: Write enable signal for internal use.
w_rd_enable: Read enable signal for internal use.
memory: Array to store data.

Behavior:

On positive edge of the clock (posedge pclk) or negative edge of the reset (negedge presetn), the memory is either reset or initialized with zeros depending on the reset signal.
The w_wr_enable signal is asserted when there is a valid write operation (chip select, enable, and write are all asserted).
The w_rd_enable signal is asserted when there is a valid read operation (chip select and enable are asserted, write is deasserted).
During write operation, data is written into the memory at the given address.
During read operation, data is read from the memory at the given address.


Testbench (apb_memory_tb):

Parameters:Same parameters as the apb_memory module.

Signals:Signals to control the inputs of the apb_memory module (pclk, presetn, paddr, psel, penable, pwrite, pwdata) and to monitor the outputs (prdata, pready, pslverr).

Tasks:
write_data: Simulates a write operation to the memory. It sets appropriate signals to perform a write operation.
read_data: Simulates a read operation from the memory. It sets appropriate signals to perform a read operation.

Initial Block:

Initializes signals and performs a sequence of write and read operations on the memory.

Summary:

The apb_memory module provides a simple memory interface accessible through an APB interface. The provided testbench verifies the functionality of this memory module by performing write and read operations on it.
