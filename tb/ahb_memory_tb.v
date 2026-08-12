`timescale 1ns/1ps

module ahb_memory_tb;

    reg HCLK;
    reg HRESETn;

    reg mem_valid;
    reg mem_write;

    reg [31:0] mem_addr;
    reg [2:0] mem_size;
    reg [31:0] mem_wdata;

    wire [31:0] mem_rdata;

    ahb_memory #(
        .MEM_SIZE(1024)
    ) DUT (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .mem_valid(mem_valid),
        .mem_write(mem_write),

        .mem_addr(mem_addr),
        .mem_size(mem_size),

        .mem_wdata(mem_wdata),

        .mem_rdata(mem_rdata)
    );

    initial begin
        HCLK = 0;
        forever #5 HCLK = ~HCLK;
    end

    initial begin

        HRESETn = 0;
        mem_valid = 0;
        mem_write = 0;

        mem_addr = 0;
        mem_size = 3'b010;
        mem_wdata = 0;

        #20;
        HRESETn = 1;

        // WRITE

        @(posedge HCLK);

        mem_valid <= 1;
        mem_write <= 1;
        mem_addr <= 32'h00000010;
        mem_size <= 3'b010;
        mem_wdata <= 32'hDEADBEEF;

        @(posedge HCLK);

        mem_valid <= 0;


        // READ

        @(posedge HCLK);

        mem_valid <= 1;
        mem_write <= 0;
        mem_addr <= 32'h00000010;

        @(posedge HCLK);

        mem_valid <= 0;

        #10;

        if (mem_rdata == 32'hDEADBEEF)
            $display("MEMORY TEST PASSED");
        else
            $display("MEMORY TEST FAILED: %h", mem_rdata);

        #20;
        $finish;

    end

endmodule
