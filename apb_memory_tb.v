/*
Testbench: apb_memory_tb

Description:
This Verilog testbench verifies the functionality of the APB memory module (apb_memory) by simulating its behavior under various test scenarios.

Parameters:
- data_width: Width of the data bus.
- mem_depth: Depth of the memory.
- addr_width: Width of the address bus.

Signals:
- pclk: Clock signal.
- presetn: Asynchronous reset signal.
- paddr: Address input for memory access.
- psel: Chip select input.
- penable: Enable signal for memory access.
- pwrite: Write enable signal.
- pwdata: Data input for write operation.
- prdata: Data output for read operation.
- pready: Ready signal indicating the module is ready for a new transaction.
- pslverr: Error signal (not used in this implementation).

Tasks:
- write_data: Simulates a write operation to the memory.
- read_data: Simulates a read operation from the memory.

Behavior:
1. Module Instantiation:
    - Instantiates the apb_memory module and connects its ports to signals defined within the testbench.

2. Tasks for Writing and Reading Data:
    - write_data: Simulates a write operation by setting appropriate input signals (pwrite, psel, penable, paddr, pwdata).
    - read_data: Simulates a read operation by setting appropriate input signals (pwrite, psel, penable, paddr).

3. Initial Block:
    - Initializes signals and performs a sequence of write and read operations on the memory.
    - Iterates over each memory location and writes data to the memory using the write_data task.
    - Iterates over each memory location and reads data from the memory using the read_data task.

*/

module apb_memory_tb;

    parameter data_width = 32; 
    parameter mem_depth = 1024; 
    parameter addr_width = 10;

    reg pclk;
    reg presetn;
    reg [addr_width-1:0] paddr;
    reg psel;
    reg penable;
    reg pwrite;
    reg [data_width-1:0] pwdata;
    wire [data_width-1:0] prdata;
    wire pready;
    wire pslverr;
    integer i;

    // Instantiating the apb_memory module
    apb_memory uut (
        .pclk(pclk), 
        .presetn(presetn), 
        .paddr(paddr), 
        .psel(psel), 
        .penable(penable), 
        .pwrite(pwrite), 
        .pwdata(pwdata), 
        .prdata(prdata), 
        .pready(pready), 
        .pslverr(pslverr)
    );
    
    // Task for simulating a write operation to the memory
    task write_data(input [addr_width-1:0] i_addr, input [data_width-1:0] i_data);
    begin 
        // Setting signals for write operation
        pwrite = 1'b1;
        psel = 1'b1;
        penable = 1'b1;
        pclk = 1'b0;
        #10 pclk = 1'b1;
        paddr = i_addr;
        pwdata = i_data + 6; // Incrementing data for simulation purpose
        #10 ;
    end
    endtask

    // Task for simulating a read operation from the memory
    task read_data(input [addr_width-1:0] r_addr);
    begin 
        // Setting signals for read operation
        pwrite = 1'b0;
        psel = 1'b1;
        penable = 1'b1;
        pclk = 1'b0;
        #10 pclk = 1'b1;
        paddr = r_addr;
        #10 ;
    end
    endtask

    initial begin
        // Initializing signals
        presetn = 1'b0;
        #10 presetn = 1'b1;
        
        // Performing write operations for each memory location
        for(i=0; i<mem_depth; i=i+1) begin
            write_data(i, i); // Writing data (i) to memory location (i)
        end
        
        // Performing read operations for each memory location
        for(i=0; i<mem_depth; i=i+1) begin
            read_data(i); // Reading data from memory location (i)
        end
    end

endmodule
