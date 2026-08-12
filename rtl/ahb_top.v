`timescale 1ns/1ps

module ahb_top (
    input wire HCLK,
    input wire HRESETn,

    input wire start,
    input wire write,

    input wire [31:0] addr,
    input wire [31:0] wdata,

    input wire [2:0] burst_type,
    input wire [4:0] burst_length,

    output wire [31:0] rdata,
    output wire ready,
    output wire error
);

    // Master signals

    wire [31:0] M_HADDR;
    wire [1:0]  M_HTRANS;
    wire        M_HWRITE;
    wire [2:0]  M_HSIZE;
    wire [2:0]  M_HBURST;
    wire [3:0]  M_HPROT;
    wire [31:0] M_HWDATA;

    wire [31:0] M_HRDATA;
    wire        M_HREADY;
    wire [1:0]  M_HRESP;


    // Slave select

    wire HSEL_SRAM;
    wire HSEL_APB;
    wire HSEL_DEFAULT;


    // Common slave signals

    wire [31:0] S_HADDR;
    wire [1:0]  S_HTRANS;
    wire        S_HWRITE;
    wire [2:0]  S_HSIZE;
    wire [2:0]  S_HBURST;
    wire [3:0]  S_HPROT;
    wire [31:0] S_HWDATA;


    // SRAM

    wire [31:0] SRAM_HRDATA;
    wire        SRAM_HREADYOUT;
    wire [1:0]  SRAM_HRESP;


    // APB bridge

    wire [31:0] APB_HRDATA;
    wire        APB_HREADYOUT;
    wire [1:0]  APB_HRESP;


    // APB signals

    wire        PSEL;
    wire        PENABLE;
    wire        PWRITE;

    wire [31:0] PADDR;
    wire [31:0] PWDATA;

    wire [31:0] PRDATA;
    wire        PREADY;
    wire        PSLVERR;


    // MASTER

    ahb_master u_master (

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

        .HADDR(M_HADDR),
        .HTRANS(M_HTRANS),
        .HWRITE(M_HWRITE),
        .HSIZE(M_HSIZE),
        .HBURST(M_HBURST),
        .HPROT(M_HPROT),
        .HWDATA(M_HWDATA),

        .HRDATA(M_HRDATA),
        .HREADY(M_HREADY),
        .HRESP(M_HRESP)
    );


    // INTERCONNECT

    ahb_interconnect u_interconnect (

        .M_HADDR(M_HADDR),
        .M_HTRANS(M_HTRANS),
        .M_HWRITE(M_HWRITE),
        .M_HSIZE(M_HSIZE),
        .M_HBURST(M_HBURST),
        .M_HPROT(M_HPROT),
        .M_HWDATA(M_HWDATA),

        .M_HRDATA(M_HRDATA),
        .M_HREADY(M_HREADY),
        .M_HRESP(M_HRESP),

        .SRAM_HRDATA(SRAM_HRDATA),
        .SRAM_HREADYOUT(SRAM_HREADYOUT),
        .SRAM_HRESP(SRAM_HRESP),

        .APB_HRDATA(APB_HRDATA),
        .APB_HREADYOUT(APB_HREADYOUT),
        .APB_HRESP(APB_HRESP),

        .S_HADDR(S_HADDR),
        .S_HTRANS(S_HTRANS),
        .S_HWRITE(S_HWRITE),
        .S_HSIZE(S_HSIZE),
        .S_HBURST(S_HBURST),
        .S_HPROT(S_HPROT),
        .S_HWDATA(S_HWDATA),

        .HSEL_SRAM(HSEL_SRAM),
        .HSEL_APB(HSEL_APB),
        .HSEL_DEFAULT(HSEL_DEFAULT)
    );


    // SRAM SLAVE

    ahb_slave #(
        .MEM_SIZE(65536),
        .WAIT_CYCLES(1)
    ) u_sram_slave (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .HSEL(HSEL_SRAM),

        .HADDR(S_HADDR),
        .HTRANS(S_HTRANS),
        .HWRITE(S_HWRITE),

        .HSIZE(S_HSIZE),
        .HBURST(S_HBURST),
        .HPROT(S_HPROT),

        .HWDATA(S_HWDATA),

        .HRDATA(SRAM_HRDATA),
        .HREADYOUT(SRAM_HREADYOUT),
        .HRESP(SRAM_HRESP)
    );


    // AHB TO APB BRIDGE

    ahb_apb_bridge u_apb_bridge (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .HSEL(HSEL_APB),

        .HADDR(S_HADDR),
        .HTRANS(S_HTRANS),

        .HWRITE(S_HWRITE),
        .HSIZE(S_HSIZE),

        .HWDATA(S_HWDATA),

        .HRDATA(APB_HRDATA),
        .HREADYOUT(APB_HREADYOUT),
        .HRESP(APB_HRESP),

        .PSEL(PSEL),
        .PENABLE(PENABLE),

        .PWRITE(PWRITE),

        .PADDR(PADDR),
        .PWDATA(PWDATA),

        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );


    // APB PERIPHERAL

    apb_slave u_apb_slave (

        .PCLK(HCLK),
        .PRESETn(HRESETn),

        .PSEL(PSEL),
        .PENABLE(PENABLE),

        .PWRITE(PWRITE),

        .PADDR(PADDR),
        .PWDATA(PWDATA),

        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );

endmodule
