`timescale 1ns/1ps

module ahb_apb_bridge #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                     HCLK,
    input  wire                     HRESETn,

    input  wire                     HSEL,
    input  wire [ADDR_WIDTH-1:0]    HADDR,
    input  wire [1:0]               HTRANS,
    input  wire                     HWRITE,
    input  wire [2:0]               HSIZE,
    input  wire [DATA_WIDTH-1:0]    HWDATA,

    output reg  [DATA_WIDTH-1:0]    HRDATA,
    output reg                      HREADYOUT,
    output reg  [1:0]               HRESP,

    output reg                      PSEL,
    output reg                      PENABLE,
    output reg                      PWRITE,
    output reg  [ADDR_WIDTH-1:0]    PADDR,
    output reg  [DATA_WIDTH-1:0]    PWDATA,

    input  wire [DATA_WIDTH-1:0]    PRDATA,
    input  wire                     PREADY,
    input  wire                     PSLVERR
);

    localparam IDLE   = 2'b00;
    localparam SETUP  = 2'b01;
    localparam ACCESS = 2'b10;

    localparam OKAY   = 2'b00;
    localparam ERROR  = 2'b01;

    reg [1:0] state;

    wire valid_transfer;

    assign valid_transfer =
        HSEL &&
        ((HTRANS == 2'b10) ||
         (HTRANS == 2'b11));

    always @(posedge HCLK or negedge HRESETn) begin

        if (!HRESETn) begin

            state     <= IDLE;

            PSEL      <= 1'b0;
            PENABLE   <= 1'b0;
            PWRITE    <= 1'b0;
            PADDR     <= 32'b0;
            PWDATA    <= 32'b0;

            HRDATA    <= 32'b0;
            HREADYOUT <= 1'b1;
            HRESP     <= OKAY;

        end

        else begin

            case (state)

                IDLE: begin

                    HREADYOUT <= 1'b1;
                    HRESP <= OKAY;

                    if (valid_transfer) begin

                        PADDR   <= HADDR;
                        PWDATA  <= HWDATA;
                        PWRITE  <= HWRITE;

                        PSEL    <= 1'b1;
                        PENABLE <= 1'b0;

                        HREADYOUT <= 1'b0;

                        state <= SETUP;

                    end

                end


                SETUP: begin

                    PSEL    <= 1'b1;
                    PENABLE <= 1'b1;

                    state <= ACCESS;

                end


                ACCESS: begin

                    PSEL    <= 1'b1;
                    PENABLE <= 1'b1;

                    if (PREADY) begin

                        HRDATA <= PRDATA;
                        HREADYOUT <= 1'b1;

                        if (PSLVERR)
                            HRESP <= ERROR;
                        else
                            HRESP <= OKAY;

                        PSEL    <= 1'b0;
                        PENABLE <= 1'b0;

                        state <= IDLE;

                    end

                end


                default:
                    state <= IDLE;

            endcase

        end

    end

endmodule
