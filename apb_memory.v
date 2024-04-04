/*
Module: apb_memory

Description:
This Verilog module implements an APB (Advanced Peripheral Bus) memory with configurable data width, memory depth, and address width. It provides a simple memory interface accessible through APB signals.

Parameters:
- data_width: Width of the data bus.
- mem_depth: Depth of the memory.
- addr_width: Width of the address bus.

Inputs:
- pclk: Clock signal.
- presetn: Asynchronous reset signal.
- paddr: Address input for memory access.
- psel: Chip select input.
- penable: Enable signal for memory access.
- pwrite: Write enable signal.
- pwdata: Data input for write operation.

Outputs:
- prdata: Data output for read operation.
- pready: Ready signal indicating the module is ready for a new transaction.
- pslverr: Error signal (not used in this implementation).

Internal Signals:
- w_wr_enable: Write enable signal for internal use.
- w_rd_enable: Read enable signal for internal use.
- memory: Array to store data.

Behavior:
- On positive edge of the clock (posedge pclk) or negative edge of the reset (negedge presetn), the memory is either reset or initialized with zeros depending on the reset signal.
- The w_wr_enable signal is asserted when there is a valid write operation (chip select, enable, and write are all asserted).
- The w_rd_enable signal is asserted when there is a valid read operation (chip select and enable are asserted, write is deasserted).
- During write operation, data is written into the memory at the given address.
- During read operation, data is read from the memory at the given address.
*/

module apb_memory #(
    parameter data_width = 32, 
    parameter mem_depth = 1024, 
    parameter addr_width = 10
) 
(
    input pclk,
    input presetn,
    input [addr_width-1:0] paddr,
    input psel,
    input penable,
    input pwrite,
    input [data_width-1:0] pwdata,
    output reg [data_width-1:0] prdata,
    output reg pready,
    output pslverr
);

    integer i;
    wire w_wr_enable, w_rd_enable;

    reg [data_width-1:0] memory [0:mem_depth-1];

    // Write and read enable signals
    assign w_wr_enable = (psel && penable && pwrite)? 1'b1 : 1'b0;
    assign w_rd_enable = (psel && penable && !pwrite)? 1'b1 : 1'b0;

    // Error signal (not used in this implementation)
    assign pslverr = 1'b0;

    // Always block for write operation and memory initialization/reset
    always@(posedge pclk or negedge presetn) begin
        if(!presetn) begin
            // Reset memory to 0
            for(i = 0; i<mem_depth; i=i+1) begin
                memory[i] <= 0;
            end
            // Set pready signal high
            pready <= 1'b1;
        end
        else if(w_wr_enable) begin
            // Write data into memory at the given address
            memory[paddr] <= pwdata;
            // Set pready signal high
            pready <= 1'b1;
        end
    end

    // Always block for read operation
    always@(posedge pclk or negedge presetn) begin
        if(!presetn) begin
            // Reset prdata to 0
            prdata <= 0;
            // Set pready signal high
            pready <= 1'b1;
        end
        else if(w_rd_enable) begin
            // Read data from memory at the given address
            prdata <= memory[paddr];
            // Set pready signal high
            pready <= 1'b1;
        end
    end

endmodule
