`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_sync

	(
		input wire clk, reset,
		input wire [9:0] score,
		input wire [9:0] bar_pos1,
        input wire [9:0] bar_pos2,
        input wire [9:0] bar_pos3,
        input wire [9:0] bar_pos4,
        input wire [9:0] bar_pos5,
        input wire [9:0] bar_pos6,
        input wire [9:0] bar_pos7,
        input wire [9:0] bar_pos8,
        input wire [9:0] bar_op1,
        input wire [9:0] bar_op2,
        input wire [9:0] bar_op3,
        input wire [9:0] bar_op4,
        input wire [9:0] bar_op5,
        input wire [9:0] bar_op6,
        input wire [9:0] bar_op7,
        input wire [9:0] bar_op8,
        input wire [9:0] player_h,
        input wire [9:0] player_v,
		input wire [12:0] digit1,
		input wire [12:0] digit2,
		output wire Hsync, Vsync,
		output reg [3:0] vgaRed,
		output reg [3:0] vgaGreen,
		output reg [3:0] vgaBlue
	);
    
	reg [9:0] bar_position [7:0];
	reg [9:0] bar_opening [7:0];
    integer i;
	
	// constant declarations for VGA sync parameters
	localparam H_DISPLAY       = 640; // horizontal display area
	localparam H_L_BORDER      =  48; // horizontal left border
	localparam H_R_BORDER      =  16; // horizontal right border
	localparam H_RETRACE       =  96; // horizontal retrace
	localparam H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE - 1;
	localparam START_H_RETRACE = H_DISPLAY + H_R_BORDER;
	localparam END_H_RETRACE   = H_DISPLAY + H_R_BORDER + H_RETRACE - 1;
	
	localparam V_DISPLAY       = 480; // vertical display area
	localparam V_T_BORDER      =  10; // vertical top border
	localparam V_B_BORDER      =  33; // vertical bottom border
	localparam V_RETRACE       =   2; // vertical retrace
	localparam V_MAX           = V_DISPLAY + V_T_BORDER + V_B_BORDER + V_RETRACE - 1;
        localparam START_V_RETRACE = V_DISPLAY + V_B_BORDER;
	localparam END_V_RETRACE   = V_DISPLAY + V_B_BORDER + V_RETRACE - 1;
	
	// mod-4 counter to generate 25 MHz pixel tick
	reg [1:0] pixel_reg;
	wire [1:0] pixel_next;
	wire pixel_tick;
	
	always @(posedge clk, posedge reset)
		if(reset)
		  pixel_reg <= 0;
		else
		  pixel_reg <= pixel_next;
	
	assign pixel_next = pixel_reg + 1; // increment pixel_reg 
	
	assign pixel_tick = (pixel_reg == 0); // assert tick 1/4 of the time
	
	// registers to keep track of current pixel location
	reg [9:0] h_count_reg, h_count_next, v_count_reg, v_count_next;
	
	// register to keep track of vsync and hsync signal states
	reg vsync_reg, hsync_reg;
	wire vsync_next, hsync_next;
 
	// infer registers
	always @(posedge clk, posedge reset)
		if(reset)
		    begin
                    v_count_reg <= 0;
                    h_count_reg <= 0;
                    vsync_reg   <= 0;
                    hsync_reg   <= 0;
		    end
		else
		    begin
                    v_count_reg <= v_count_next;
                    h_count_reg <= h_count_next;
                    vsync_reg   <= vsync_next;
                    hsync_reg   <= hsync_next;
		    end
			
	// next-state logic of horizontal vertical sync counters
	always @*
		begin
		{bar_position[0], bar_position[1], bar_position[2], bar_position[3], bar_position[4], bar_position[5], bar_position[6], bar_position[7]} = {bar_pos1, bar_pos2, bar_pos3, bar_pos4, bar_pos5, bar_pos6, bar_pos7, bar_pos8};
        {bar_opening[0], bar_opening[1], bar_opening[2], bar_opening[3], bar_opening[4], bar_opening[5], bar_opening[6], bar_opening[7]} = {bar_op1, bar_op2, bar_op3, bar_op4, bar_op5, bar_op6, bar_op7, bar_op8};
		h_count_next = pixel_tick ? 
		               h_count_reg == H_MAX ? 0 : h_count_reg + 1
			       : h_count_reg;
		
		v_count_next = pixel_tick && h_count_reg == H_MAX ? 
		               (v_count_reg == V_MAX ? 0 : v_count_reg + 1) 
			       : v_count_reg;
		end
		
        // hsync and vsync are active low signals
        // hsync signal asserted during horizontal retrace
        assign hsync_next = h_count_reg >= START_H_RETRACE
                            && h_count_reg <= END_H_RETRACE;
   
        // vsync signal asserted during vertical retrace
        assign vsync_next = v_count_reg >= START_V_RETRACE 
                            && v_count_reg <= END_V_RETRACE;

        // video only on when pixels are in both horizontal and vertical display region
        assign video_on = (h_count_reg < H_DISPLAY) 
                          && (v_count_reg < V_DISPLAY);
		always @(*)
		begin
			// first check if we're within vertical active video range
			if (v_count_reg >= 0 && v_count_reg < V_DISPLAY)
			begin
				// now display different colors every 80 pixels
				// while we're within the active horizontal range
				// -----------------
				// Bars
				for (i = 0; i < 8; i = i + 1)
				begin
					if (h_count_reg >= i * 80 && h_count_reg < (i + 1) * 80)
					begin
						if (i > 0 && i < 7)
						begin
							if (v_count_reg <= bar_position[i] || v_count_reg >= (bar_position[i] + bar_opening[i]))
							begin
                                vgaRed = 0;
                                vgaGreen = 0;
                                vgaBlue = 0;
							end
							else
							begin
								vgaRed = 4'b1111;
								vgaGreen = 4'b1111;
								vgaBlue = 4'b0000;
							end
						end
						else
						begin
							vgaRed = 0;
							vgaGreen = 0;
							vgaBlue = 0;
						end
					end
				end

				// Player
				if (h_count_reg >= player_h-20 && h_count_reg < player_h+20)
				begin
				    if (v_count_reg >= player_v-20 && v_count_reg < player_v+20)
				    begin
                        vgaRed = 4'b1111;
                        vgaGreen = 4'b1111;
                        vgaBlue = 4'b1111;
				    end
				end

				// Score
				if (digit2[2] == 1)
				begin
					if (h_count_reg >= 10 && h_count_reg < 14 && v_count_reg >= 20 && v_count_reg < 24)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[1] == 1)
				begin
					if (h_count_reg >= 14 && h_count_reg < 18 && v_count_reg >= 20 && v_count_reg < 24)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[0] == 1)
				begin
					if (h_count_reg >= 18 && h_count_reg < 22 && v_count_reg >= 20 && v_count_reg < 24)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[4] == 1)
				begin
					if (h_count_reg >= 10 && h_count_reg < 14 && v_count_reg >= 24 && v_count_reg < 28)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[3] == 1)
				begin
					if (h_count_reg >= 18 && h_count_reg < 22 && v_count_reg >= 24 && v_count_reg < 28)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[7] == 1)
				begin
					if (h_count_reg >= 10 && h_count_reg < 14 && v_count_reg >= 28 && v_count_reg < 32)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[6] == 1)
				begin
					if (h_count_reg >= 14 && h_count_reg < 18 && v_count_reg >= 28 && v_count_reg < 32)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[5] == 1)
				begin
					if (h_count_reg >= 18 && h_count_reg < 22 && v_count_reg >= 28 && v_count_reg < 32)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[9] == 1)
				begin
					if (h_count_reg >= 10 && h_count_reg < 14 && v_count_reg >= 32 && v_count_reg < 36)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[8] == 1)
				begin
					if (h_count_reg >= 18 && h_count_reg < 22 && v_count_reg >= 32 && v_count_reg < 36)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[12] == 1)
				begin
					if (h_count_reg >= 10 && h_count_reg < 14 && v_count_reg >= 36 && v_count_reg < 40)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[11] == 1)
				begin
					if (h_count_reg >= 14 && h_count_reg < 18 && v_count_reg >= 36 && v_count_reg < 40)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit2[10] == 1)
				begin
					if (h_count_reg >= 18 && h_count_reg < 22 && v_count_reg >= 36 && v_count_reg < 40)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end

				if (digit1[0] == 1)
				begin
					if (h_count_reg >= 30 && h_count_reg < 34 && v_count_reg >= 20 && v_count_reg < 24)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[1] == 1)
				begin
					if (h_count_reg >= 34 && h_count_reg < 38 && v_count_reg >= 20 && v_count_reg < 24)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[2] == 1)
				begin
					if (h_count_reg >= 38 && h_count_reg < 42 && v_count_reg >= 20 && v_count_reg < 24)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[3] == 1)
				begin
					if (h_count_reg >= 30 && h_count_reg < 34 && v_count_reg >= 24 && v_count_reg < 28)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[4] == 1)
				begin
					if (h_count_reg >= 38 && h_count_reg < 42 && v_count_reg >= 24 && v_count_reg < 28)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[5] == 1)
				begin
					if (h_count_reg >= 30 && h_count_reg < 34 && v_count_reg >= 28 && v_count_reg < 32)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[6] == 1)
				begin
					if (h_count_reg >= 34 && h_count_reg < 38 && v_count_reg >= 28 && v_count_reg < 32)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[7] == 1)
				begin
					if (h_count_reg >= 38 && h_count_reg < 42 && v_count_reg >= 28 && v_count_reg < 32)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[8] == 1)
				begin
					if (h_count_reg >= 30 && h_count_reg < 34 && v_count_reg >= 32 && v_count_reg < 36)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[9] == 1)
				begin
					if (h_count_reg >= 38 && h_count_reg < 42 && v_count_reg >= 32 && v_count_reg < 36)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[10] == 1)
				begin
					if (h_count_reg >= 30 && h_count_reg < 34 && v_count_reg >= 36 && v_count_reg < 40)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[11] == 1)
				begin
					if (h_count_reg >= 34 && h_count_reg < 38 && v_count_reg >= 36 && v_count_reg < 40)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end
				if (digit1[12] == 1)
				begin
					if (h_count_reg >= 38 && h_count_reg < 42 && v_count_reg >= 36 && v_count_reg < 40)
					begin
						vgaRed = 4'b1111;
						vgaGreen = 4'b00000;
						vgaBlue = 4'b1111;
					end
				end


				// if (h_count_reg >= 0 && h_count_reg < (0+80))
				// begin
				//     if (v_count_reg <= (bar_pos1) || v_count_reg >= (bar_pos1+bar_op1))
				//     begin
                //         vgaRed = 4'b1111;
                //         vgaGreen = 4'b1111;
                //         vgaBlue = 4'b1111;
				//     end
				// 	else
                //     begin
                //         vgaRed = 0;
                //         vgaGreen = 0;
                //         vgaBlue = 0;
                //     end
				// end
				// // display yellow bar
				// else if (h_count_reg >= (0+80) && h_count_reg < (0+160))
				// begin
                //     if (v_count_reg <= (bar_pos2) || v_count_reg >= (bar_pos2+bar_op2))
                //     begin
                //         vgaRed = 4'b1111;
                //         vgaGreen = 4'b1111;
                //         vgaBlue = 4'b0000;
                //     end
                //     else
                //     begin
                //         vgaRed = 0;
                //         vgaGreen = 0;
                //         vgaBlue = 0;
                //     end
                // end
				// // display cyan bar
				// else if (h_count_reg >= (0+160) && h_count_reg < (0+240))
				// begin
                //     if (v_count_reg <= (bar_pos3) || v_count_reg >= (bar_pos3+bar_op3))
                //     begin
                //         vgaRed = 4'b0000;
                //         vgaGreen = 4'b1111;
                //         vgaBlue = 4'b1111;
                //     end
                //     else
                //     begin
                //         vgaRed = 0;
                //         vgaGreen = 0;
                //         vgaBlue = 0;
                //     end
                // end
				// // display green bar
				// else if (h_count_reg >= (0+240) && h_count_reg < (0+320))
				// begin
                //     if (v_count_reg <= (bar_pos4) || v_count_reg >= (bar_pos4+bar_op))
				//     begin
                //         vgaRed = 4'b0000;
                //         vgaGreen = 4'b1111;
                //         vgaBlue = 4'b0000;
                //     end
                //     else
                //     begin
                //         vgaRed = 0;
                //         vgaGreen = 0;
                //         vgaBlue = 0;
                //     end
                // end
				// // display magenta bar
				// else if (h_count_reg >= (0+320) && h_count_reg < (0+400))
				// begin
				// 	vgaRed = 4'b1111;
				// 	vgaGreen = 4'b00000;
				// 	vgaBlue = 4'b1111;
				// end
				// // display red bar
				// else if (h_count_reg >= (0+400) && h_count_reg < (0+480))
				// begin
				// 	vgaRed = 4'b1111;
				// 	vgaGreen = 4'b0000;
				// 	vgaBlue = 4'b0000;
				// end
				// // display blue bar
				// else if (h_count_reg >= (0+480) && h_count_reg < (0+560))
				// begin
				// 	vgaRed = 4'b0000;
				// 	vgaGreen = 4'b0000;
				// 	vgaBlue = 4'b1111;
				// end
				// // display black bar
				// else if (h_count_reg >= (0+560) && h_count_reg < (0+640))
				// begin
				// 	vgaRed = 4'b0000;
				// 	vgaGreen = 4'b0000;
				// 	vgaBlue = 4'b0000;
				// end
				// // we're outside active horizontal range so display black
				// else
				// begin
				// 	vgaRed = 0;
				// 	vgaGreen = 0;
				// 	vgaBlue = 0;
				// end
			end
			// we're outside active vertical range so display black
			else
			begin
                vgaRed = 4'b0000;
                vgaGreen = 4'b0000;
                vgaBlue = 4'b1111;
			end
		end
        // output signals
        assign Hsync  = hsync_reg;
        assign Vsync  = vsync_reg;
        // assign x      = h_count_reg;
        // assign y      = v_count_reg;
        // assign p_tick = pixel_tick;
endmodule