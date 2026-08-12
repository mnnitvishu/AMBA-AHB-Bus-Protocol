`timescale 1ns/1ps

module ahb_burst_controller #(
    parameter ADDR_WIDTH = 32
)(
    input  wire [ADDR_WIDTH-1:0] current_addr,
    input  wire [2:0]            HSIZE,
    input  wire [2:0]            HBURST,
    input  wire                  advance,

    output reg  [ADDR_WIDTH-1:0] next_addr
);

    reg [ADDR_WIDTH-1:0] increment;
    reg [ADDR_WIDTH-1:0] wrap_size;
    reg [ADDR_WIDTH-1:0] wrap_base;

    always @(*) begin

        increment = (1 << HSIZE);
        next_addr = current_addr;

        case (HBURST)

            // SINGLE
            3'b000:
                next_addr = current_addr;

            // INCR - undefined length incrementing burst
            3'b001:
                if (advance)
                    next_addr = current_addr + increment;

            // WRAP4
            3'b010: begin
                wrap_size = increment * 4;
                wrap_base = current_addr & ~(wrap_size - 1);

                if (advance)
                    next_addr = wrap_base |
                                ((current_addr + increment) &
                                 (wrap_size - 1));
            end

            // INCR4
            3'b011:
                if (advance)
                    next_addr = current_addr + increment;

            // WRAP8
            3'b100: begin
                wrap_size = increment * 8;
                wrap_base = current_addr & ~(wrap_size - 1);

                if (advance)
                    next_addr = wrap_base |
                                ((current_addr + increment) &
                                 (wrap_size - 1));
            end

            // INCR8
            3'b101:
                if (advance)
                    next_addr = current_addr + increment;

            // WRAP16
            3'b110: begin
                wrap_size = increment * 16;
                wrap_base = current_addr & ~(wrap_size - 1);

                if (advance)
                    next_addr = wrap_base |
                                ((current_addr + increment) &
                                 (wrap_size - 1));
            end

            // INCR16
            3'b111:
                if (advance)
                    next_addr = current_addr + increment;

            default:
                next_addr = current_addr;
        endcase

    end

endmodule
