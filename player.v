`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 12:56:27 PM
// Design Name: 
// Module Name: player
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


module player(
    input clk,
    input pause,
    input wire reset_player,
    input up, left, right, down,
    output wire [9:0] new_h,
    output wire [9:0] new_v,
    output wire [9:0] next_level
    );

    reg [9:0] h;
    reg [9:0] v;
    reg [9:0] level;

    initial
    begin
        h = 40;
        v = 240;
        level = 1;
    end
    
    always @ (posedge clk)
    begin
        if (reset_player)
        begin
            h = 40;
            v = 240;
            level = 1;
        end
        else if (pause) begin
            h = h;
            v = v;
        end
        else
        begin
            if (up && v - 40 > 0)
                v = v - 40;
            if (left && h - 40 > 0)
                h = h - 40;
            if (right)
            begin
                if (h + 40 <= 640)
                    h = h + 40;
                else
                begin
                    level = level + 1;
                    h = 40;
                end
            end
            if (down && v + 40 < 480)
                v = v + 40;
        end
    end
    
    assign new_h = h;
    assign new_v = v;
    assign next_level = level;

endmodule
