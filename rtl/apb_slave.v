`timescale 1ns/1ps

module apb_slave #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                     PCLK,
    input  wire                     PRESETn,

    input  wire                     PSEL,
    input  wire                     PENABLE,
    input  wire                     PWRITE,

    input  wire [ADDR_WIDTH-1:0]    PADDR,
    input  wire [DATA_WIDTH-1:0]    PWDATA,

    output reg  [DATA_WIDTH-1:0]    PRDATA,
    output wire                     PREADY,
    output wire                     PSLVERR
);

    reg [DATA_WIDTH-1:0] registers [0:255];

    integer i;

    assign PREADY  = 1'b1;
    assign PSLVERR = 1'b0;

    always @(posedge PCLK or negedge PRESETn) begin

        if (!PRESETn) begin

            PRDATA <= 32'b0;

            for (i = 0; i < 256; i = i + 1)
                registers[i] <= 32'b0;

        end

        else begin

            if (PSEL && PENABLE) begin

                if (PWRITE) begin
                    registers[PADDR[9:2]] <= PWDATA;
                end

                else begin
                    PRDATA <= registers[PADDR[9:2]];
                end

            end

        end

    end

endmodule
