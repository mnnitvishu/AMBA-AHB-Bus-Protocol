```verilog
`timescale 1ns/1ps

module ahb_master #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                  HCLK,
    input  wire                  HRESETn,

    // Master control
    input  wire                  start,
    input  wire                  write,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] wdata,

    output reg  [DATA_WIDTH-1:0] rdata,
    output reg                   ready,
    output reg                   error,

    // AHB signals
    output reg  [ADDR_WIDTH-1:0] HADDR,
    output reg  [1:0]            HTRANS,
    output reg                   HWRITE,
    output reg  [2:0]            HSIZE,
    output reg  [2:0]            HBURST,
    output reg  [3:0]            HPROT,
    output reg  [DATA_WIDTH-1:0] HWDATA,

    input wire  [DATA_WIDTH-1:0] HRDATA,
    input wire                   HREADY,
    input wire  [1:0]            HRESP
);

    localparam IDLE = 2'b00;
    localparam NONSEQ = 2'b10;

    reg busy;

    always @(posedge HCLK or negedge HRESETn) begin

        if (!HRESETn) begin
            HADDR  <= 0;
            HTRANS <= IDLE;
            HWRITE <= 0;
            HSIZE  <= 3'b010;       // 32-bit transfer
            HBURST <= 3'b000;       // SINGLE
            HPROT  <= 4'b0011;
            HWDATA <= 0;

            rdata  <= 0;
            ready  <= 1'b0;
            error  <= 1'b0;
            busy   <= 1'b0;
        end

        else begin

            ready <= 1'b0;
            error <= 1'b0;

            if (start && !busy) begin

                // Address phase
                HADDR  <= addr;
                HWRITE <= write;
                HWDATA <= wdata;
                HTRANS <= NONSEQ;

                busy <= 1'b1;
            end

            else if (busy) begin

                if (HREADY) begin

                    // Data phase completed
                    rdata <= HRDATA;

                    if (HRESP == 2'b01)
                        error <= 1'b1;

                    ready <= 1'b1;
                    busy  <= 1'b0;
                    HTRANS <= IDLE;
                end
            end

            else begin
                HTRANS <= IDLE;
            end
        end
    end

endmodule
```
