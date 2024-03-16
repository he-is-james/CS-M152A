`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 12:55:24 PM
// Design Name: 
// Module Name: environment
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


module environment(
    input clkenv, pause,
    input wire [9:0] level,
    output wire [9:0] bar_pos1,
    output wire [9:0] bar_pos2,
    output wire [9:0] bar_pos3,
    output wire [9:0] bar_pos4,
    output wire [9:0] bar_pos5,
    output wire [9:0] bar_pos6,
    output wire [9:0] bar_pos7,
    output wire [9:0] bar_pos8,
    output wire [9:0] bar_op1,
    output wire [9:0] bar_op2,
    output wire [9:0] bar_op3,
    output wire [9:0] bar_op4,
    output wire [9:0] bar_op5,
    output wire [9:0] bar_op6,
    output wire [9:0] bar_op7,
    output wire [9:0] bar_op8
    );
    
    reg[9:0] bar_height = 'd0;
    reg[9:0] bar_position[7:0]; // top of opening
    reg moving[7:0];
    reg[9:0] bar_opening[7:0];   // how big the opening is
    reg[9:0] bar_speed[7:0];
    
    integer i;
    
    initial begin
        for (i=0; i < 8; i=i+1) begin
            moving[i] = 1; 
            bar_opening[i] = 60;
            bar_position[i] = 120;
            bar_speed[i] = 20;
        end
        moving[0] = 0;
        moving[7] = 0;
    end
    
    always @ (posedge clkenv)
    begin
        if(~pause) begin
            for (i=0; i < 8; i=i+1) begin
                if (moving[i])
                    bar_position[i] = bar_position[i] + bar_speed[i] * level;//
                if (bar_position[i] > 480) //different directions later
                    bar_position[i] = 0;
            end
        end
    end

    assign {bar_pos1, bar_pos2, bar_pos3, bar_pos4, bar_pos5, bar_pos6, bar_pos7, bar_pos8} = {bar_position[0], bar_position[1], bar_position[2], bar_position[3], bar_position[4], bar_position[5], bar_position[6], bar_position[7]};
    assign {bar_op1, bar_op2, bar_op3, bar_op4, bar_op5, bar_op6, bar_op7, bar_op8} = {bar_opening[0], bar_opening[1], bar_opening[2], bar_opening[3], bar_opening[4], bar_opening[5], bar_opening[6], bar_opening[7]};
    
endmodule
