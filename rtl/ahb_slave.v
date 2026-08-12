`timescale 1ns/1ps

module ahb_slave #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MEM_SIZE   = 65536,
    parameter WAIT_CYCLES = 1
)(
    input  wire                     HCLK,
    input  wire                     HRESETn,

    input  wire                     HSEL,
    input  wire [ADDR_WIDTH-1:0]    HADDR,
    input  wire [1:0]               HTRANS,
    input  wire                     HWRITE,
    input  wire [2:0]               HSIZE,
    input  wire [2:0]               HBURST,
    input  wire [3:0]               HPROT,
    input  wire [DATA_WIDTH-1:0]    HWDATA,

    output wire [DATA_WIDTH-1:0]    HRDATA,
    output reg                      HREADYOUT,
    output reg  [1:0]               HRESP
);

    localparam IDLE   = 2'b00;
    localparam BUSY   = 2'b01;
    localparam NONSEQ = 2'b10;
    localparam SEQ    = 2'b11;

    localparam OKAY   = 2'b00;
    localparam ERROR  = 2'b01;

    reg transaction_active;
    reg [7:0] wait_counter;

    wire valid_transfer;
    wire address_valid;
    wire mem_valid;

    assign valid_transfer =
        (HTRANS == NONSEQ) ||
        (HTRANS == SEQ);

    assign address_valid =
        (HADDR < MEM_SIZE);

    assign mem_valid =
        HSEL &&
        valid_transfer &&
        HREADYOUT &&
        address_valid;

    ahb_memory #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_SIZE(MEM_SIZE)
    ) u_memory (
        .HCLK(HCLK),
        .HRESETn(HRESETn),

        .mem_valid(mem_valid),
        .mem_write(HWRITE),
        .mem_addr(HADDR),
        .mem_size(HSIZE),
        .mem_wdata(HWDATA),

        .mem_rdata(HRDATA)
    );

    always @(posedge HCLK or negedge HRESETn) begin

        if (!HRESETn) begin

            HREADYOUT        <= 1'b1;
            HRESP            <= OKAY;
            transaction_active <= 1'b0;
            wait_counter     <= 0;

        end

        else begin

            HRESP <= OKAY;

            if (HSEL && valid_transfer && !transaction_active) begin

                transaction_active <= 1'b1;

                if (!address_valid) begin

                    HRESP     <= ERROR;
                    HREADYOUT <= 1'b1;
                    transaction_active <= 1'b0;

                end

                else if (WAIT_CYCLES != 0) begin

                    HREADYOUT <= 1'b0;
                    wait_counter <= WAIT_CYCLES;

                end

                else begin

                    HREADYOUT <= 1'b1;
                    transaction_active <= 1'b0;

                end

            end

            else if (transaction_active) begin

                if (wait_counter != 0) begin

                    wait_counter <= wait_counter - 1'b1;

                    if (wait_counter == 1) begin
                        HREADYOUT <= 1'b1;
                        transaction_active <= 1'b0;
                    end

                end

            end

            else begin
                HREADYOUT <= 1'b1;
            end

        end

    end

endmodule
