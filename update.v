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


module update
    (
        input wire clk, reset,
        input wire [9:0] bar_pos2,
        input wire [9:0] bar_pos3,
        input wire [9:0] bar_pos4,
        input wire [9:0] bar_pos5,
        input wire [9:0] bar_pos6,
        input wire [9:0] bar_pos7,
        input wire [9:0] bar_op2,
        input wire [9:0] bar_op3,
        input wire [9:0] bar_op4,
        input wire [9:0] bar_op5,
        input wire [9:0] bar_op6,
        input wire [9:0] bar_op7,
        input wire [9:0] player_h,
        input wire [9:0] player_v,
        input wire [9:0] level,
        output wire [9:0] points,
        output wire reset_player
    );

    reg rst_player;
    reg [9:0] score = 0;
    reg [9:0] temp = 0;
    reg [3:0] cnt = 2;
    

    always @ (posedge clk or posedge reset)
        begin
            // check collisions
            if(reset) begin
                score = 0;
                rst_player = 1;
            end
            else if (~reset && rst_player == 1) begin
                cnt = cnt - 1;
                if (cnt == 0) begin
                    rst_player = 0;
                    cnt = 2;
                end
            end
            else begin
                if(player_h > 60 && player_h < 180) begin // 80 - 160
                    // check vertical
                    if(player_v + 20 > bar_pos2 && player_v - 20 < bar_pos2 + bar_op2) begin
                        temp = 0;
                        rst_player = 1;
                    end
                end
                if(player_h > 140 && player_h < 260) begin // 160 - 240
                    // check vertical
                    if(player_v + 20 > bar_pos2 && player_v - 20 < bar_pos2 + bar_op2) begin
                        temp = 0;
                        rst_player = 1;
                    end
                end
                if(player_h > 200 && player_h < 340) begin // 240 - 320
                    // check vertical
                    if(player_v + 20 > bar_pos2 && player_v - 20 < bar_pos2 + bar_op2) begin
                        temp = 0;
                        rst_player = 1;
                    end
                end
                if(player_h > 300 && player_h < 420) begin // 320 - 400
                    // check vertical
                    if(player_v + 20 > bar_pos2 && player_v - 20 < bar_pos2 + bar_op2) begin
                        temp = 0;
                        rst_player = 1;
                    end
                end
                if(player_h > 380 && player_h < 500) begin // 400 - 480
                    // check vertical
                    if(player_v + 20 > bar_pos2 && player_v - 20 < bar_pos2 + bar_op2) begin
                        temp = 0;
                        rst_player = 1;
                    end
                end
                if(player_h > 460 && player_h < 580) begin // 480 - 560
                    // check vertical
                    if(player_v + 20 > bar_pos2 && player_v - 20 < bar_pos2 + bar_op2) begin
                        temp = 0;
                        rst_player = 1;
                    end
                end
                
                if(player_h < 119)
                    temp = 'd0;
                if(player_h > 119)
                    temp = 'd1;
                if(player_h > 199)
                    temp = 'd2;
                if(player_h > 279)
                    temp = 'd3;
                if(player_h > 359)
                    temp = 'd4;
                if(player_h > 419)
                    temp = 'd5;
                if(player_h > 499)
                    temp = 'd6;
                score = ((level-1) * 6) + temp; // 40 120 200 280 
            end
        end


    assign reset_player = rst_player;
    assign points = score;


endmodule
