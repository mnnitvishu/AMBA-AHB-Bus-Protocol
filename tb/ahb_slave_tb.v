`timescale 1ns/1ps

module ahb_slave_tb;

    reg HCLK;
    reg HRESETn;

    reg HSEL;

    reg [31:0] HADDR;
    reg [1:0] HTRANS;

    reg HWRITE;

    reg [2:0] HSIZE;
    reg [2:0] HBURST;

    reg [3:0] HPROT;

    reg [31:0] HWDATA;

    wire [31:0] HRDATA;
    wire HREADYOUT;
    wire [1:0] HRESP;

    ahb_slave #(
        .MEM_SIZE(1024),
        .WAIT_CYCLES(0)
    ) DUT (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .HSEL(HSEL),
        .HADDR(HADDR),

        .HTRANS(HTRANS),
        .HWRITE(HWRITE),

        .HSIZE(HSIZE),
        .HBURST(HBURST),
        .HPROT(HPROT),

        .HWDATA(HWDATA),

        .HRDATA(HRDATA),
        .HREADYOUT(HREADYOUT),
        .HRESP(HRESP)
    );

    initial begin
        HCLK = 0;
        forever #5 HCLK = ~HCLK;
    end

    initial begin

        HRESETn = 0;

        HSEL = 0;
        HADDR = 0;
        HTRANS = 0;

        HWRITE = 0;

        HSIZE = 3'b010;
        HBURST = 0;
        HPROT = 0;

        HWDATA = 0;

        #20;

        HRESETn = 1;


        // WRITE

        @(posedge HCLK);

        HSEL <= 1;
        HADDR <= 32'h20;

        HTRANS <= 2'b10;
        HWRITE <= 1;

        HWDATA <= 32'hCAFEBABE;

        @(posedge HCLK);

        HSEL <= 0;
        HTRANS <= 0;


        // READ

        @(posedge HCLK);

        HSEL <= 1;
        HADDR <= 32'h20;

        HTRANS <= 2'b10;
        HWRITE <= 0;

        @(posedge HCLK);

        HSEL <= 0;
        HTRANS <= 0;

        #10;

        if (HRDATA == 32'hCAFEBABE)
            $display("SLAVE TEST PASSED");
        else
            $display("SLAVE TEST FAILED");

        #20;
        $finish;

    end

endmodule
