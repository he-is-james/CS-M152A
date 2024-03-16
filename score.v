`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 12:57:46 PM
// Design Name: 
// Module Name: update
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module score
    (
        input clk,
        input wire [9:0] score,
        output wire [12:0] digit1,
        output wire [12:0] digit2
    );

    reg [9:0] a;
    reg [9:0] b;
    reg [12:0] tens;
    reg [12:0] ones;

    always @ (posedge clk)
    begin
        a = score % 'd10;
        b = score / 'd10;

        case(a)
            0: ones = 13'b1111110111111;
            1: ones = 13'b0010100101001;
            2: ones = 13'b1110111110111;
            3: ones = 13'b1110111101111;
            4: ones = 13'b1011111101001;
            5: ones = 13'b1111011101111;
            6: ones = 13'b1111011111111;
            7: ones = 13'b1110100101001;
            8: ones = 13'b1111111111111;
            9: ones = 13'b1111111101111;
        endcase

        case(b)
            0: tens = 13'b1111110111111;
            1: tens = 13'b0010100101001;
            2: tens = 13'b1110111110111;
            3: tens = 13'b1110111101111;
            4: tens = 13'b1011111101001;
            5: tens = 13'b1111011101111;
            6: tens = 13'b1111011111111;
            7: tens = 13'b1110100101001;
            8: tens = 13'b1111111111111;
            9: tens = 13'b1111111101111;
        endcase
    end

    assign digit1 = ones;
    assign digit2 = tens;

endmodule
