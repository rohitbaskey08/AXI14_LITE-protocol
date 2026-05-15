`timescale 1ns / 1ps

module ram_design #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 16
)(
    input                         clk,
    input                         rst_n,
    input                         wr_enb,
    input      [ADDR_WIDTH-1:0]  addr,
    input      [DATA_WIDTH-1:0]  wdata,
    output reg [DATA_WIDTH-1:0]  rdata
);

    // Memory Array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    integer i;

    always @(posedge clk) begin
        if (!rst_n) begin
            rdata <= 0;

            // Optional memory reset
            for(i = 0; i < DEPTH; i = i + 1)
                mem[i] <= 0;
        end
        else begin
            if (wr_enb)
                mem[addr] <= wdata;
            else
                rdata <= mem[addr];
        end
    end

endmodule