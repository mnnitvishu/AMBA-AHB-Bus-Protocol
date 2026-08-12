```verilog
`timescale 1ns/1ps

module ahb_top_tb;

    reg HCLK;
    reg HRESETn;

    reg start;
    reg write;

    reg [31:0] addr;
    reg [31:0] wdata;

    wire [31:0] rdata;
    wire        ready;
    wire        error;


    ahb_top DUT (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .start(start),
        .write(write),
        .addr(addr),
        .wdata(wdata),

        .rdata(rdata),
        .ready(ready),
        .error(error)
    );


    // Clock generation
    initial begin
        HCLK = 1'b0;

        forever #5 HCLK = ~HCLK;
    end


    // Test sequence
    initial begin

        HRESETn = 1'b0;

        start = 1'b0;
        write = 1'b0;

        addr  = 32'h00000000;
        wdata = 32'h00000000;

        #20;

        HRESETn = 1'b1;

        // ------------------------------------------------
        // WRITE TRANSACTION
        // ------------------------------------------------

        @(posedge HCLK);

        addr  <= 32'h00000010;
        wdata <= 32'hDEADBEEF;
        write <= 1'b1;
        start <= 1'b1;

        @(posedge HCLK);

        start <= 1'b0;

        wait(ready);

        $display("---------------------------------------");
        $display("WRITE TRANSACTION");
        $display("Address : %h", addr);
        $display("Data    : %h", wdata);
        $display("Error   : %b", error);
        $display("---------------------------------------");


        // ------------------------------------------------
        // READ TRANSACTION
        // ------------------------------------------------

        @(posedge HCLK);

        addr  <= 32'h00000010;
        write <= 1'b0;
        start <= 1'b1;

        @(posedge HCLK);

        start <= 1'b0;

        wait(ready);

        $display("---------------------------------------");
        $display("READ TRANSACTION");
        $display("Address : %h", addr);
        $display("Data    : %h", rdata);
        $display("Error   : %b", error);
        $display("---------------------------------------");


        // ------------------------------------------------
        // CHECK RESULT
        // ------------------------------------------------

        if (rdata == 32'hDEADBEEF)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");


        #20;

        $finish;

    end

endmodule
```
