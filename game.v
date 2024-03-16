`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 12:41:38 PM
// Design Name: 
// Module Name: game
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


module game(
    input clk,
    input up, down, left, right,
    input reset,
    input pause,
    output Hsync, Vsync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
    );
    
    // Clock
    wire clkenv;
    
    // Update
    wire [9:0] level;
    wire [9:0] score;
    wire [12:0] digit1;
    wire [12:0] digit2;
    wire rst_player;
    
    // Environment
    wire [9:0] bar_pos1;
    wire [9:0] bar_pos2;
    wire [9:0] bar_pos3;
    wire [9:0] bar_pos4;
    wire [9:0] bar_pos5;
    wire [9:0] bar_pos6;
    wire [9:0] bar_pos7;
    wire [9:0] bar_pos8;
    wire [9:0] bar_op1;
    wire [9:0] bar_op2;
    wire [9:0] bar_op3;
    wire [9:0] bar_op4;
    wire [9:0] bar_op5;
    wire [9:0] bar_op6;
    wire [9:0] bar_op7;
    wire [9:0] bar_op8;

    
    // Player
    wire [9:0] player_h;
    wire [9:0] player_v;
    
    clock clk_out (
        .clk(clk),
        .clkenv(clkenv)
    );
    
    player p (
        .clk(clkenv),
        .pause(pause),
        .reset_player(rst_player),
        .up(up),
        .left(left),
        .right(right),
        .down(down),
        .new_h(player_h),
        .new_v(player_v),
        .next_level(level)
    );
    
    environment env (
        .clkenv(clkenv),
        .pause(pause),
        .level(level),
        .bar_pos1(bar_pos1),
        .bar_pos2(bar_pos2),
        .bar_pos3(bar_pos3),
        .bar_pos4(bar_pos4),
        .bar_pos5(bar_pos5),
        .bar_pos6(bar_pos6),
        .bar_pos7(bar_pos7),
        .bar_pos8(bar_pos8),
        .bar_op1(bar_op1),
        .bar_op2(bar_op2),
        .bar_op3(bar_op3),
        .bar_op4(bar_op4),
        .bar_op5(bar_op5),
        .bar_op6(bar_op6),
        .bar_op7(bar_op7),
        .bar_op8(bar_op8)
    );

    update u (
        .clk(clk),
        .reset(reset),
        .bar_pos2(bar_pos2),
        .bar_pos3(bar_pos3),
        .bar_pos4(bar_pos4),
        .bar_pos5(bar_pos5),
        .bar_pos6(bar_pos6),
        .bar_pos7(bar_pos7),
        .bar_op2(bar_op2),
        .bar_op3(bar_op3),
        .bar_op4(bar_op4),
        .bar_op5(bar_op5),
        .bar_op6(bar_op6),
        .bar_op7(bar_op7),
        .player_h(player_h),
        .player_v(player_v),
        .level(level),
        .points(score),
        .reset_player(rst_player)
   );

   score s (
    .clk(clkenv),
    .score(score),
    .digit1(digit1),
    .digit2(digit2)
   );
   
    vga_sync vga_out (
        .clk(clk),
        .reset(reset),
        .score(score),
        .bar_pos1(bar_pos1),
        .bar_pos2(bar_pos2),
        .bar_pos3(bar_pos3),
        .bar_pos4(bar_pos4),
        .bar_pos5(bar_pos5),
        .bar_pos6(bar_pos6),
        .bar_pos7(bar_pos7),
        .bar_pos8(bar_pos8),
        .bar_op1(bar_op1),
        .bar_op2(bar_op2),
        .bar_op3(bar_op3),
        .bar_op4(bar_op4),
        .bar_op5(bar_op5),
        .bar_op6(bar_op6),
        .bar_op7(bar_op7),
        .bar_op8(bar_op8),
        .player_h(player_h),
        .player_v(player_v),
        .digit1(digit1),
        .digit2(digit2),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue)
    );
    
    
endmodule
