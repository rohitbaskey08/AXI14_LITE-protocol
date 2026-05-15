`timescale 1ns / 1ps

module tb_axi_top_ram;

    //=========================================================
    // PARAMETERS
    //=========================================================
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 4;
    parameter DEPTH      = 16;

    //=========================================================
    // CLOCK & RESET
    //=========================================================
    reg aclk;
    reg aresetn;

    //=========================================================
    // WRITE ADDRESS CHANNEL
    //=========================================================
    reg  [ADDR_WIDTH-1:0] s_axi_awaddr;
    reg                   s_axi_awvalid;
    wire                  s_axi_awready;

    //=========================================================
    // WRITE DATA CHANNEL
    //=========================================================
    reg  [DATA_WIDTH-1:0] s_axi_wdata;
    reg                   s_axi_wvalid;
    wire                  s_axi_wready;

    //=========================================================
    // WRITE RESPONSE CHANNEL
    //=========================================================
    wire [1:0]            s_axi_bresp;
    wire                  s_axi_bvalid;
    reg                   s_axi_bready;

    //=========================================================
    // READ ADDRESS CHANNEL
    //=========================================================
    reg  [ADDR_WIDTH-1:0] s_axi_araddr;
    reg                   s_axi_arvalid;
    wire                  s_axi_arready;

    //=========================================================
    // READ DATA CHANNEL
    //=========================================================
    wire [DATA_WIDTH-1:0] s_axi_rdata;
    wire [1:0]            s_axi_rresp;
    wire                  s_axi_rvalid;
    reg                   s_axi_rready;

    //=========================================================
    // READ STORAGE
    //=========================================================
    reg [DATA_WIDTH-1:0] read_data;

    //=========================================================
    // DUT INSTANTIATION
    //=========================================================
    axi_top_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .aclk(aclk),
        .aresetn(aresetn),

        // WRITE ADDRESS
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),

        // WRITE DATA
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),

        // WRITE RESPONSE
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),

        // READ ADDRESS
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),

        // READ DATA
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready)
    );

    //=========================================================
    // CLOCK GENERATION (10ns PERIOD)
    //=========================================================
    initial begin
        aclk = 0;
        read_data = 0;
        forever #5 aclk = ~aclk;
    end

    //=========================================================
    // AXI WRITE TASK
    //=========================================================
    task axi_write;
        input [ADDR_WIDTH-1:0] addr;
        input [DATA_WIDTH-1:0] data;
        begin

            // WRITE ADDRESS
            @(posedge aclk);
            s_axi_awaddr  = addr;
            s_axi_awvalid = 1'b1;

            wait(s_axi_awready);
            @(posedge aclk);
            s_axi_awvalid = 1'b0;

            // WRITE DATA
            s_axi_wdata   = data;
            s_axi_wvalid  = 1'b1;

            wait(s_axi_wready);
            @(posedge aclk);
            s_axi_wvalid  = 1'b0;

            // WRITE RESPONSE
            s_axi_bready = 1'b1;

            wait(s_axi_bvalid);
            @(posedge aclk);
            s_axi_bready = 1'b0;

            $display("[%0t] WRITE -> ADDR = %h DATA = %h",
                      $time, addr, data);

        end
    endtask

    //=========================================================
    // AXI READ TASK
    //=========================================================
    task axi_read;
        input  [ADDR_WIDTH-1:0] addr;
        output [DATA_WIDTH-1:0] data;
        begin

            // READ ADDRESS
            @(posedge aclk);
            s_axi_araddr  = addr;
            s_axi_arvalid = 1'b1;

            wait(s_axi_arready);
            @(posedge aclk);
            s_axi_arvalid = 1'b0;

            // READ DATA
            s_axi_rready = 1'b1;

            wait(s_axi_rvalid);
            data = s_axi_rdata;

            @(posedge aclk);
            s_axi_rready = 1'b0;

            $display("[%0t] READ  -> ADDR = %h DATA = %h",
                      $time, addr, data);

        end
    endtask

    //=========================================================
    // TEST SEQUENCE
    //=========================================================
    initial begin

        //-----------------------------------------------------
        // INITIALIZATION
        //-----------------------------------------------------
        aresetn       = 0;

        s_axi_awaddr  = 0;
        s_axi_awvalid = 0;

        s_axi_wdata   = 0;
        s_axi_wvalid  = 0;

        s_axi_bready  = 0;

        s_axi_araddr  = 0;
        s_axi_arvalid = 0;

        s_axi_rready  = 0;

        //-----------------------------------------------------
        // RESET
        //-----------------------------------------------------
        repeat(5) @(posedge aclk);
        aresetn = 1;

        $display("=================================");
        $display("      AXI RAM TEST START        ");
        $display("=================================");

        //-----------------------------------------------------
        // TEST 1
        //-----------------------------------------------------
        axi_write(4'h1, 32'hDEADBEEF);
        axi_read (4'h1, read_data);

        if(read_data == 32'hDEADBEEF)
            $display("TEST1 PASS");
        else
            $display("TEST1 FAIL");

        //-----------------------------------------------------
        // TEST 2
        //-----------------------------------------------------
        axi_write(4'h2, 32'h12345678);
        axi_read (4'h2, read_data);

        if(read_data == 32'h12345678)
            $display("TEST2 PASS");
        else
            $display("TEST2 FAIL");

        //-----------------------------------------------------
        // TEST 3
        //-----------------------------------------------------
        axi_write(4'h3, 32'hAAAAAAAA);
        axi_read (4'h3, read_data);

        if(read_data == 32'hAAAAAAAA)
            $display("TEST3 PASS");
        else
            $display("TEST3 FAIL");

        //-----------------------------------------------------
        // END SIMULATION
        //-----------------------------------------------------
        #50;

        $display("=================================");
        $display("       SIMULATION END           ");
        $display("=================================");

        $finish;
    end

endmodule