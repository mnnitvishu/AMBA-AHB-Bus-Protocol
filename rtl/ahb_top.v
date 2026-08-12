```verilog
`timescale 1ns/1ps

module ahb_top #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input wire                  HCLK,
    input wire                  HRESETn,

    input wire                  start,
    input wire                  write,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] wdata,

    output wire [DATA_WIDTH-1:0] rdata,
    output wire                  ready,
    output wire                  error
);

    wire [ADDR_WIDTH-1:0] HADDR;
    wire [1:0]            HTRANS;
    wire                  HWRITE;
    wire [2:0]            HSIZE;
    wire [2:0]            HBURST;
    wire [3:0]            HPROT;
    wire [DATA_WIDTH-1:0] HWDATA;

    wire [DATA_WIDTH-1:0] HRDATA;
    wire                  HREADY;
    wire [1:0]            HRESP;

    ahb_master #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) master_inst (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .start(start),
        .write(write),
        .addr(addr),
        .wdata(wdata),

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


    ahb_memory #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) memory_inst (

        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .HADDR(HADDR),
        .HTRANS(HTRANS),
        .HWRITE(HWRITE),
        .HSIZE(HSIZE),
        .HWDATA(HWDATA),

        .HRDATA(HRDATA),
        .HREADY(HREADY),
        .HRESP(HRESP)
    );

endmodule
```
