`timescale 1ns/1ps

module ahb_master_tb;

    reg HCLK;
    reg HRESETn;

    reg start;
    reg write;

    reg [31:0] addr;
    reg [31:0] wdata;

    reg [2:0] burst_type;
    reg [4:0] burst_length;

    wire [31:0] rdata;
    wire ready;
    wire error;

    wire [31:0] HADDR;
    wire [1:0] HTRANS;

    wire HWRITE;

    wire [2:0] HSIZE;
    wire [2:0] HBURST;

    wire [3:0] HPROT;

    wire [31:0] HWDATA;

    reg [31:0] HRDATA;
    reg HREADY;
    reg [1:0] HRESP;

    ahb_master DUT (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .start(start),
        .write(write),

        .addr(addr),
        .wdata(wdata),

        .burst_type(burst_type),
        .burst_length(burst_length),

        .rdata(rdata),
        .ready(ready),
        .error(error),

        .HADDR(HADDR),
        .HTRANS(HTRANS),

        .HWRITE(HWRITE),
        .HSIZE(HSIZE),

        .HBURST(HBURST),
        .HPROT(HPROT),

        .HWDATA(HWDATA),

        .HRDATA(HRDATA),
        .HREADY(HREADY),
        .HRESP(HRESP)
    );

    initial begin
        HCLK = 0;
        forever #5 HCLK = ~HCLK;
    end

    initial begin

        HRESETn = 0;

        start = 0;
        write = 0;

        addr = 0;
        wdata = 0;

        burst_type = 3'b000;
        burst_length = 1;

        HRDATA = 0;
        HREADY = 1;
        HRESP = 0;

        #20;

        HRESETn = 1;


        @(posedge HCLK);

        addr <= 32'h00000000;
        wdata <= 32'h12345678;

        write <= 1;
        burst_type <= 3'b000;
        burst_length <= 1;

        start <= 1;

        @(posedge HCLK);
        start <= 0;

        wait(ready);

        if (!error)
            $display("MASTER SINGLE TRANSFER PASSED");
        else
            $display("MASTER SINGLE TRANSFER FAILED");

        #20;
        $finish;

    end

endmodule
