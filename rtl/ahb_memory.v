```verilog
`timescale 1ns/1ps

module ahb_memory #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 256
)(
    input wire                  HCLK,
    input wire                  HRESETn,

    input wire [ADDR_WIDTH-1:0] HADDR,
    input wire [1:0]            HTRANS,
    input wire                  HWRITE,
    input wire [2:0]            HSIZE,
    input wire [DATA_WIDTH-1:0] HWDATA,

    output reg [DATA_WIDTH-1:0] HRDATA,
    output reg                  HREADY,
    output reg [1:0]            HRESP
);

    localparam IDLE    = 2'b00;
    localparam NONSEQ  = 2'b10;
    localparam SEQ     = 2'b11;

    localparam OKAY  = 2'b00;
    localparam ERROR = 2'b01;

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    integer i;

    always @(posedge HCLK or negedge HRESETn) begin

        if (!HRESETn) begin

            HRDATA <= 0;
            HREADY <= 1'b1;
            HRESP  <= OKAY;

            for (i = 0; i < DEPTH; i = i + 1)
                memory[i] <= 0;

        end

        else begin

            HREADY <= 1'b1;
            HRESP  <= OKAY;

            if ((HTRANS == NONSEQ) || (HTRANS == SEQ)) begin

                if (HADDR[ADDR_WIDTH-1:2] < DEPTH) begin

                    if (HWRITE) begin
                        memory[HADDR[ADDR_WIDTH-1:2]] <= HWDATA;
                    end

                    else begin
                        HRDATA <= memory[HADDR[ADDR_WIDTH-1:2]];
                    end

                end

                else begin
                    HRESP <= ERROR;
                end
            end
        end
    end

endmodule
```
