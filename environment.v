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
    reg[9:0] bar_opening[7:0];   // how big the opening is
    reg[9:0] bar_speed[7:0];
    // Level 1
    reg [9:0] l1_bp [7:0];
    reg [9:0] l1_bo [7:0];
    reg [9:0] l1_bs [7:0];
    
    integer i;
    
    initial begin
        // Level 1
        l1_bp[1] = 240;
        l1_bp[2] = 240;
        l1_bp[3] = 120;
        l1_bp[4] = 240;
        l1_bp[5] = 120;
        l1_bp[6] = 120;

        l1_bo[1] = 60;
        l1_bo[2] = 60;
        l1_bo[3] = 60;
        l1_bo[4] = 60;
        l1_bo[5] = 60;
        l1_bo[6] = 60;

        l1_bs[1] = -10;
        l1_bs[2] = -15;
        l1_bs[3] = 10;
        l1_bs[4] = -10;
        l1_bs[5] = 15;
        l1_bs[6] = 10;


        // Level 2
        l2_bp[1] = 240;
        l2_bp[2] = 240;
        l2_bp[3] = 120;
        l2_bp[4] = 240;
        l2_bp[5] = 120;
        l2_bp[6] = 120;

        l2_bo[1] = 60;
        l2_bo[2] = 80;
        l2_bo[3] = 70;
        l2_bo[4] = 90;
        l2_bo[5] = 100;
        l2_bo[6] = 60;

        l2_bs[1] = -20;
        l2_bs[2] = -10;
        l2_bs[3] = 20;
        l2_bs[4] = -15;
        l2_bs[5] = 15;
        l2_bs[6] = 25;

    end
    
    always @ (posedge clkenv)
    begin
        if(~pause) begin
            for(i = 1; i < 7; i = i + 1) begin
                if (level % 2 == 1) begin
                    bar_position[i] = l1_bp[i] + l1_bs[i];
                    bar_opening[i] = l1_bo[i];
                end
                if (level % 2 == 2) begin
                    bar_position[i] = l2_bp[i] + l2_bs[i];
                    bar_opening[i] = l2_bo[i];
                end
                if (bar_position[i] > 480)
                    bar_position[i] = 0;
                if (bar_position[i] < 0)
                    bar_position[i] = 480;
            end
        end
    end

    assign {bar_pos1, bar_pos2, bar_pos3, bar_pos4, bar_pos5, bar_pos6, bar_pos7, bar_pos8} = {bar_position[0], bar_position[1], bar_position[2], bar_position[3], bar_position[4], bar_position[5], bar_position[6], bar_position[7]};
    assign {bar_op1, bar_op2, bar_op3, bar_op4, bar_op5, bar_op6, bar_op7, bar_op8} = {bar_opening[0], bar_opening[1], bar_opening[2], bar_opening[3], bar_opening[4], bar_opening[5], bar_opening[6], bar_opening[7]};
    
endmodule
