`timescale 1ns/1ps

module ahb_mux #(
    parameter DATA_WIDTH = 32
)(
    input  wire                     HSEL_SRAM,
    input  wire                     HSEL_APB,
    input  wire                     HSEL_DEFAULT,

    input  wire [DATA_WIDTH-1:0]    SRAM_HRDATA,
    input  wire                     SRAM_HREADYOUT,
    input  wire [1:0]               SRAM_HRESP,

    input  wire [DATA_WIDTH-1:0]    APB_HRDATA,
    input  wire                     APB_HREADYOUT,
    input  wire [1:0]               APB_HRESP,

    output reg  [DATA_WIDTH-1:0]    HRDATA,
    output reg                      HREADY,
    output reg  [1:0]               HRESP
);

    always @(*) begin

        HRDATA = 32'b0;
        HREADY = 1'b1;
        HRESP  = 2'b00;

        if (HSEL_SRAM) begin

            HRDATA = SRAM_HRDATA;
            HREADY = SRAM_HREADYOUT;
            HRESP  = SRAM_HRESP;

        end

        else if (HSEL_APB) begin

            HRDATA = APB_HRDATA;
            HREADY = APB_HREADYOUT;
            HRESP  = APB_HRESP;

        end

        else if (HSEL_DEFAULT) begin

            HRDATA = 32'b0;
            HREADY = 1'b1;
            HRESP  = 2'b01;

        end

    end

endmodule
