`timescale 1ns/1ps

module ahb_memory #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MEM_SIZE   = 65536
)(
    input  wire                     HCLK,
    input  wire                     HRESETn,

    input  wire                     mem_valid,
    input  wire                     mem_write,
    input  wire [ADDR_WIDTH-1:0]    mem_addr,
    input  wire [2:0]               mem_size,
    input  wire [DATA_WIDTH-1:0]    mem_wdata,

    output reg  [DATA_WIDTH-1:0]    mem_rdata
);

    reg [7:0] memory [0:MEM_SIZE-1];

    integer i;

    always @(posedge HCLK or negedge HRESETn) begin

        if (!HRESETn) begin

            mem_rdata <= 32'b0;

            for (i = 0; i < MEM_SIZE; i = i + 1)
                memory[i] <= 8'b0;

        end

        else if (mem_valid) begin

            if (mem_write) begin

                case (mem_size)

                    // BYTE
                    3'b000:
                        memory[mem_addr] <= mem_wdata[7:0];

                    // HALFWORD
                    3'b001: begin
                        memory[mem_addr]     <= mem_wdata[7:0];
                        memory[mem_addr + 1] <= mem_wdata[15:8];
                    end

                    // WORD
                    3'b010: begin
                        memory[mem_addr]     <= mem_wdata[7:0];
                        memory[mem_addr + 1] <= mem_wdata[15:8];
                        memory[mem_addr + 2] <= mem_wdata[23:16];
                        memory[mem_addr + 3] <= mem_wdata[31:24];
                    end

                    default: begin
                        memory[mem_addr]     <= mem_wdata[7:0];
                        memory[mem_addr + 1] <= mem_wdata[15:8];
                        memory[mem_addr + 2] <= mem_wdata[23:16];
                        memory[mem_addr + 3] <= mem_wdata[31:24];
                    end

                endcase

            end

            else begin

                case (mem_size)

                    3'b000:
                        mem_rdata <= {24'b0,
                                      memory[mem_addr]};

                    3'b001:
                        mem_rdata <= {16'b0,
                                      memory[mem_addr + 1],
                                      memory[mem_addr]};

                    default:
                        mem_rdata <= {
                            memory[mem_addr + 3],
                            memory[mem_addr + 2],
                            memory[mem_addr + 1],
                            memory[mem_addr]
                        };

                endcase

            end

        end

    end

endmodule
