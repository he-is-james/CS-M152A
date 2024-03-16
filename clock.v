`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 12:38:22 PM
// Design Name: 
// Module Name: clock
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


module clock(
    input clk,
    output clkenv
    );
    
    reg[24:0] env = 0;
    reg a1 = 0;
    
    always @ (posedge clk)
    begin
        if (env == 24999999)
        begin
            env <= 'd0;
            a1 <= ~a1;
        end
        else
        begin
            env <= env + 'd1;
        end
    end
    
    assign clkenv = a1;
endmodule