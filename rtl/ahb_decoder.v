`timescale 1ns/1ps

module ahb_decoder (
    input  wire [31:0] HADDR,
    input  wire [1:0]  HTRANS,

    output wire        HSEL_SRAM,
    output wire        HSEL_APB,
    output wire        HSEL_DEFAULT
);

    wire valid_transfer;

    assign valid_transfer =
        (HTRANS == 2'b10) ||
        (HTRANS == 2'b11);

    // SRAM
    // 0x0000_0000 - 0x0000_FFFF

    assign HSEL_SRAM =
        valid_transfer &&
        (HADDR >= 32'h0000_0000) &&
        (HADDR <= 32'h0000_FFFF);

    // APB
    // 0x4000_0000 - 0x4000_0FFF

    assign HSEL_APB =
        valid_transfer &&
        (HADDR >= 32'h4000_0000) &&
        (HADDR <= 32'h4000_0FFF);

    // Unmapped address

    assign HSEL_DEFAULT =
        valid_transfer &&
        !HSEL_SRAM &&
        !HSEL_APB;

endmodule
