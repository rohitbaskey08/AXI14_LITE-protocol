`timescale 1ns / 1ps

module axi_top_ram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4,
    parameter DEPTH      = 16
)(
    input                       aclk,
    input                       aresetn,

    // WRITE ADDRESS CHANNEL
    input  [ADDR_WIDTH-1:0]    s_axi_awaddr,
    input                       s_axi_awvalid,
    output reg                  s_axi_awready,

    // WRITE DATA CHANNEL
    input  [DATA_WIDTH-1:0]    s_axi_wdata,
    input                       s_axi_wvalid,
    output reg                  s_axi_wready,

    // WRITE RESPONSE CHANNEL
    output reg [1:0]           s_axi_bresp,
    output reg                 s_axi_bvalid,
    input                      s_axi_bready,

    // READ ADDRESS CHANNEL
    input  [ADDR_WIDTH-1:0]    s_axi_araddr,
    input                       s_axi_arvalid,
    output reg                  s_axi_arready,

    // READ DATA CHANNEL
    output reg [DATA_WIDTH-1:0] s_axi_rdata,
    output reg [1:0]            s_axi_rresp,
    output reg                  s_axi_rvalid,
    input                       s_axi_rready
);

    localparam OKAY = 2'b00;

    reg [ADDR_WIDTH-1:0] ram_addr;
    reg [DATA_WIDTH-1:0] ram_wdata;
    reg                  ram_wr_enb;
    wire [DATA_WIDTH-1:0] ram_rdata;

    //=====================================================
    // RAM INSTANTIATION
    //=====================================================
    ram_design #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .clk(aclk),
        .rst_n(aresetn),
        .wr_enb(ram_wr_enb),
        .addr(ram_addr),
        .wdata(ram_wdata),
        .rdata(ram_rdata)
    );

    //=====================================================
    // WRITE CHANNEL
    //=====================================================
    always @(posedge aclk or negedge aresetn) begin
        if(!aresetn) begin
            s_axi_awready <= 0;
            s_axi_wready  <= 0;
            s_axi_bvalid  <= 0;
            s_axi_bresp   <= OKAY;

            ram_wr_enb    <= 0;
            ram_addr      <= 0;
            ram_wdata     <= 0;
        end
        else begin

            ram_wr_enb <= 0;

            // Accept write address
            s_axi_awready <= 1;

            if(s_axi_awvalid && s_axi_awready) begin
                ram_addr <= s_axi_awaddr;
                s_axi_wready <= 1;
            end

            // Accept write data
            if(s_axi_wvalid && s_axi_wready) begin
                ram_wdata  <= s_axi_wdata;
                ram_wr_enb <= 1;

                s_axi_wready <= 0;
                s_axi_bvalid <= 1;
                s_axi_bresp  <= OKAY;
            end

            // Write response handshake
            if(s_axi_bvalid && s_axi_bready)
                s_axi_bvalid <= 0;
        end
    end

    //=====================================================
    // READ CHANNEL
    //=====================================================
    always @(posedge aclk or negedge aresetn) begin
        if(!aresetn) begin
            s_axi_arready <= 0;
            s_axi_rvalid  <= 0;
            s_axi_rresp   <= OKAY;
            s_axi_rdata   <= 0;
        end
        else begin

            s_axi_arready <= 1;

            // Read address handshake
            if(s_axi_arvalid && s_axi_arready) begin
                ram_addr <= s_axi_araddr;

                s_axi_rdata <= ram_rdata;
                s_axi_rresp <= OKAY;
                s_axi_rvalid <= 1;
            end

            // Read data handshake
            if(s_axi_rvalid && s_axi_rready)
                s_axi_rvalid <= 0;
        end
    end

endmodule