/*
	Author:  Yee Yang Tan
	Last modified:  16/04/2020
*/

module filter_3x3_720px
#(
	 parameter BLOCK_LENGTH = 720,

    // weight of each pixel, change these parameters to make difference effect of filter
	// |WA3|WB3|WA3|
	// |WB3|WA1|WB3|
	// |WA3|WB3|WA3|
	parameter WA3 = 0,
			  WB3 = 1,
			  WA1 = -4,

	parameter DIV = 1
)
(
	// system
	input	reset,
	input	clk,

	// io
	input [15:0] d_in,
	output wire [15:0] d_out,

	// control
	input wren,
	output wire d_rdy,
	input [9:0] cursor

);


	// 3 cursors delay, because of the ram required 3 clk cycle to output the data to 'q'
	reg [9:0] cursor1, cursor2, cursor3;

	always @ (posedge clk) begin
        if (reset == 1) begin
            cursor1 <= 0;
            cursor2 <= 0;
            cursor3 <= 0;
        end
        else begin
            cursor1 <= cursor;
            cursor2 <= cursor1;
            cursor3 <= cursor2;
        end
	end
/******************************************************************************/
/******************************************************************************/
	// state to indicate which row of ram is written in current cycle
	reg state_ram1, state_ram2, state_ram3;
	reg state_ram4, state_ram5, state_ram6;
	reg state_ram7, state_ram8, state_ram9;

	wire [8:0] state_combine; 	// Combine all state_ram to indicate which row is written better

	always @ (posedge wren, posedge reset) begin
        if (reset == 1) begin
			state_ram1 <= 1;
			state_ram2 <= 0;
			state_ram3 <= 0;
			state_ram4 <= 0;
			state_ram5 <= 0;
			state_ram6 <= 0;
			state_ram7 <= 0;
			state_ram8 <= 0;
			state_ram9 <= 0;			
        end
        else begin
			state_ram1 <= state_ram9;
			state_ram2 <= state_ram1;
			state_ram3 <= state_ram2;
			state_ram4 <= state_ram3;
			state_ram5 <= state_ram4;
			state_ram6 <= state_ram5;
			state_ram7 <= state_ram6;
			state_ram8 <= state_ram7;
			state_ram9 <= state_ram8;
        end
	end

	assign state_combine = {state_ram9,state_ram8,state_ram7,state_ram6,state_ram5,state_ram4,state_ram3,state_ram2,state_ram1};
/******************************************************************************/
/******************************************************************************/
	// enable signal for each row of ram
	wire wren_row1, wren_row2, wren_row3;	
	wire wren_row4, wren_row5, wren_row6;
	wire wren_row7, wren_row8, wren_row9;

	assign wren_row1 = (wren == 1) & (state_ram1);
	assign wren_row2 = (wren == 1) & (state_ram2);
	assign wren_row3 = (wren == 1) & (state_ram3);
	assign wren_row4 = (wren == 1) & (state_ram4);
	assign wren_row5 = (wren == 1) & (state_ram5);
	assign wren_row6 = (wren == 1) & (state_ram6);	
	assign wren_row7 = (wren == 1) & (state_ram7);
	assign wren_row8 = (wren == 1) & (state_ram8);
	assign wren_row9 = (wren == 1) & (state_ram9);	
/******************************************************************************/
	// flag to determine the middle px
	wire flag_cursor_mid;

	assign flag_cursor_mid = (cursor > 0 ) & (cursor < BLOCK_LENGTH );	

	// address of each ram
	
    // If the ram is not used, the address value of the ram is 0xFF
	wire [7:0] addr11, addr12, addr13,
			   addr21, addr22, addr23,
			   addr31, addr32, addr33;

	assign addr11 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 1 : -1;
	assign addr12 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr13 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr21 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 1 : -1;
	assign addr22 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr23 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr31 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 1 : -1;
	assign addr32 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr33 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
/******************************************************************************/
	wire [7:0] addr41, addr42, addr43,
			   addr51, addr52, addr53,
			   addr61, addr62, addr63;

	assign addr41 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr42 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr43 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;
	assign addr51 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr52 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr53 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;
	assign addr61 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr62 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr63 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;	
/******************************************************************************/	
	wire [7:0] addr71, addr72, addr73,
			   addr81, addr82, addr83,
			   addr91, addr92, addr93;

	assign addr71 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr72 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;
	assign addr73 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 3 : -1;
	assign addr81 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr82 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;
	assign addr83 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 3 : -1;
	assign addr91 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr92 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;
	assign addr93 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 3 : -1;	
/******************************************************************************/	
//注意：这是大套娃
	// memory output of ram
	
	wire [15:0] q11, q12, q13,
				q21, q22, q23,
				q31, q32, q33;
	wire [15:0] q41, q42, q43,
				q51, q52, q53,
				q61, q62, q63;
	wire [15:0] q71, q72, q73,
				q81, q82, q83,
				q91, q92, q93;				

	wire [15:0] d11, d12, d13,
				d21, d22, d23,
				d31, d32, d33;
	wire [15:0] d41, d42, d43,
				d51, d52, d53,
				d61, d62, d63;
	wire [15:0] d71, d72, d73,
				d81, d82, d83,
				d91, d92, d93;

	case (state_combine)
		9'b0_0000_0001: begin	// When state_ram1 = 1: The first row of ram is written
			assign d11 = q21;
			assign d21 = q31;
			assign d31 = q41;
			assign d41 = q51;
			assign d51 = q61;
			assign d61 = q71;
			assign d71 = q81;
			assign d81 = q91;
			assign d91 = q11;

			assign d12 = q22;
			assign d22 = q32;
			assign d32 = q42;
			assign d42 = q52;
			assign d52 = q62;
			assign d62 = q72;
			assign d72 = q82;
			assign d82 = q92;
			assign d92 = q12;

			assign d13 = q23;
			assign d23 = q33;
			assign d33 = q43;
			assign d43 = q53;
			assign d53 = q63;
			assign d63 = q73;
			assign d73 = q83;
			assign d83 = q93;
			assign d93 = q13;
		end	
		9'b0_0000_0010: begin	//When state_ram2 = 1, the second row of ram is written.
			assign d11 = q31;
			assign d21 = q41;
			assign d31 = q51;
			assign d41 = q61;
			assign d51 = q71;
			assign d61 = q81;
			assign d71 = q91;
			assign d81 = q11;
			assign d91 = q21;

			assign d12 = q32;
			assign d22 = q42;
			assign d32 = q52;
			assign d42 = q62;
			assign d52 = q72;
			assign d62 = q82;
			assign d72 = q92;
			assign d82 = q12;
			assign d92 = q22;

			assign d13 = q33;
			assign d23 = q43;
			assign d33 = q53;
			assign d43 = q63;
			assign d53 = q73;
			assign d63 = q83;
			assign d73 = q93;
			assign d83 = q13;
			assign d93 = q23;
		end	
		9'b0_0000_0100: begin	//When state_ram3 = 1, the third row of ram is written.
			assign d11 = q41;
			assign d21 = q51;
			assign d31 = q61;
			assign d41 = q71;
			assign d51 = q81;
			assign d61 = q91;
			assign d71 = q11;
			assign d81 = q21;
			assign d91 = q31;

			assign d12 = q42;
			assign d22 = q52;
			assign d32 = q62;
			assign d42 = q72;
			assign d52 = q82;
			assign d62 = q92;
			assign d72 = q12;
			assign d82 = q22;
			assign d92 = q32;

			assign d13 = q43;
			assign d23 = q53;
			assign d33 = q63;
			assign d43 = q73;
			assign d53 = q83;
			assign d63 = q93;
			assign d73 = q13;
			assign d83 = q23;
			assign d93 = q33;
		end	
		9'b0_0000_1000: begin	//When state_ram4 = 1, the fourth row of ram is written.
			assign d11 = q51;
			assign d21 = q61;
			assign d31 = q71;
			assign d41 = q81;
			assign d51 = q91;
			assign d61 = q11;
			assign d71 = q21;
			assign d81 = q31;
			assign d91 = q41;

			assign d12 = q52;
			assign d22 = q62;
			assign d32 = q72;
			assign d42 = q82;
			assign d52 = q92;
			assign d62 = q12;
			assign d72 = q22;
			assign d82 = q32;
			assign d92 = q42;

			assign d13 = q53;
			assign d23 = q63;
			assign d33 = q73;
			assign d43 = q83;
			assign d53 = q93;
			assign d63 = q13;
			assign d73 = q23;
			assign d83 = q33;
			assign d93 = q43;
		end	
		9'b0_0001_0000: begin	//When state_ram5 = 1, the fifth row of ram is written.
			assign d11 = q61;
			assign d21 = q71;
			assign d31 = q81;
			assign d41 = q91;
			assign d51 = q11;
			assign d61 = q21;
			assign d71 = q31;
			assign d81 = q41;
			assign d91 = q51;

			assign d12 = q62;
			assign d22 = q72;
			assign d32 = q82;
			assign d42 = q92;
			assign d52 = q12;
			assign d62 = q22;
			assign d72 = q32;
			assign d82 = q42;
			assign d92 = q52;

			assign d13 = q63;
			assign d23 = q73;
			assign d33 = q83;
			assign d43 = q93;
			assign d53 = q13;
			assign d63 = q23;
			assign d73 = q33;
			assign d83 = q43;
			assign d93 = q53;
		end	
		9'b0_0010_0000: begin	//When state_ram6 = 1, the sixth row of ram is written.
			assign d11 = q71;
			assign d21 = q81;
			assign d31 = q91;
			assign d41 = q11;
			assign d51 = q21;
			assign d61 = q31;
			assign d71 = q41;
			assign d81 = q51;
			assign d91 = q61;

			assign d12 = q72;
			assign d22 = q82;
			assign d32 = q92;
			assign d42 = q12;
			assign d52 = q22;
			assign d62 = q32;
			assign d72 = q42;
			assign d82 = q52;
			assign d92 = q62;

			assign d13 = q73;
			assign d23 = q83;
			assign d33 = q93;
			assign d43 = q13;
			assign d53 = q23;
			assign d63 = q33;
			assign d73 = q43;
			assign d83 = q53;
			assign d93 = q63;
		end	
		9'b0_0100_0000: begin	//When state_ram7 = 1, the seventh of ram is written.
			assign d11 = q81;
			assign d21 = q91;
			assign d31 = q11;
			assign d41 = q21;
			assign d51 = q31;
			assign d61 = q41;
			assign d71 = q51;
			assign d81 = q61;
			assign d91 = q71;

			assign d12 = q82;
			assign d22 = q92;
			assign d32 = q12;
			assign d42 = q22;
			assign d52 = q32;
			assign d62 = q42;
			assign d72 = q52;
			assign d82 = q62;
			assign d92 = q72;

			assign d13 = q83;
			assign d23 = q93;
			assign d33 = q13;
			assign d43 = q23;
			assign d53 = q33;
			assign d63 = q43;
			assign d73 = q53;
			assign d83 = q63;
			assign d93 = q73;
		end	
		9'b0_1000_0000: begin	//When state_ram8 = 1, the eighth of ram is written.
			assign d11 = q91;
			assign d21 = q11;
			assign d31 = q21;
			assign d41 = q31;
			assign d51 = q41;
			assign d61 = q51;
			assign d71 = q61;
			assign d81 = q71;
			assign d91 = q81;

			assign d12 = q92;
			assign d22 = q12;
			assign d32 = q22;
			assign d42 = q32;
			assign d52 = q42;
			assign d62 = q52;
			assign d72 = q62;
			assign d82 = q72;
			assign d92 = q82;

			assign d13 = q93;
			assign d23 = q13;
			assign d33 = q23;
			assign d43 = q33;
			assign d53 = q43;
			assign d63 = q53;
			assign d73 = q63;
			assign d83 = q73;
			assign d93 = q83;
		end	
		9'b1_0000_0000: begin	//When state_ram9 = 1, the ninth of ram is written.
			assign d11 = q11;
			assign d21 = q21;
			assign d31 = q31;
			assign d41 = q41;
			assign d51 = q51;
			assign d61 = q61;
			assign d71 = q71;
			assign d81 = q81;
			assign d91 = q91;

			assign d12 = q12;
			assign d22 = q22;
			assign d32 = q32;
			assign d42 = q42;
			assign d52 = q52;
			assign d62 = q62;
			assign d72 = q72;
			assign d82 = q82;
			assign d92 = q92;

			assign d13 = q13;
			assign d23 = q23;
			assign d33 = q33;
			assign d43 = q43;
			assign d53 = q53;
			assign d63 = q63;
			assign d73 = q73;
			assign d83 = q83;
			assign d93 = q93;
		end	
		default: begin
			assign d11 = 16'b0;
			assign d21 = 16'b0;
			assign d31 = 16'b0;
			assign d41 = 16'b0;
			assign d51 = 16'b0;
			assign d61 = 16'b0;
			assign d71 = 16'b0;
			assign d81 = 16'b0;
			assign d91 = 16'b0;

			assign d12 = 16'b0;
			assign d22 = 16'b0;
			assign d32 = 16'b0;
			assign d42 = 16'b0;
			assign d52 = 16'b0;
			assign d62 = 16'b0;
			assign d72 = 16'b0;
			assign d82 = 16'b0;
			assign d92 = 16'b0;

			assign d13 = 16'b0;
			assign d23 = 16'b0;
			assign d33 = 16'b0;
			assign d43 = 16'b0;
			assign d53 = 16'b0;
			assign d63 = 16'b0;
			assign d73 = 16'b0;
			assign d83 = 16'b0;
			assign d93 = 16'b0;
		end 
	endcase			
/******************************************************************************/
/******************************************************************************
//注意：这里是小套娃，每三行ram套一个。如果最后结果不对，很有可能是9行ram的大套娃
	// memory output of ram
	
	wire [15:0] q11, q12, q13,
				q21, q22, q23,
				q31, q32, q33;

	wire [15:0] d11, d12, d13,
				d21, d22, d23,
				d31, d32, d33;

	assign d11 = (state_ram3 == 1)? q11 : (state_ram1 == 1)? q21 : q31;
	assign d12 = (state_ram3 == 1)? q12 : (state_ram1 == 1)? q22 : q32;
	assign d13 = (state_ram3 == 1)? q13 : (state_ram1 == 1)? q23 : q33;
	assign d21 = (state_ram3 == 1)? q21 : (state_ram1 == 1)? q31 : q11;
	assign d22 = (state_ram3 == 1)? q22 : (state_ram1 == 1)? q32 : q12;
	assign d23 = (state_ram3 == 1)? q23 : (state_ram1 == 1)? q33 : q13;
	assign d31 = (state_ram3 == 1)? q31 : (state_ram1 == 1)? q11 : q21;
	assign d32 = (state_ram3 == 1)? q32 : (state_ram1 == 1)? q12 : q22;
	assign d33 = (state_ram3 == 1)? q33 : (state_ram1 == 1)? q13 : q23;				

	wire [15:0] q41, q42, q43,
				q51, q52, q53,
				q61, q62, q63;

	wire [15:0] d41, d42, d43,
				d51, d52, d53,
				d61, d62, d63;

	assign d41 = (state_ram6 == 1)? q41 : (state_ram4 == 1)? q51 : q61;
	assign d42 = (state_ram6 == 1)? q42 : (state_ram4 == 1)? q52 : q62;
	assign d43 = (state_ram6 == 1)? q43 : (state_ram4 == 1)? q53 : q63;
	assign d51 = (state_ram6 == 1)? q51 : (state_ram4 == 1)? q61 : q41;
	assign d52 = (state_ram6 == 1)? q52 : (state_ram4 == 1)? q62 : q42;
	assign d53 = (state_ram6 == 1)? q53 : (state_ram4 == 1)? q63 : q43;
	assign d61 = (state_ram6 == 1)? q61 : (state_ram4 == 1)? q41 : q51;
	assign d62 = (state_ram6 == 1)? q62 : (state_ram4 == 1)? q42 : q43;
	assign d63 = (state_ram6 == 1)? q63 : (state_ram4 == 1)? q43 : q53;

	wire [15:0] q71, q72, q73,
				q81, q82, q83,
				q91, q92, q93;

	wire [15:0] d71, d72, d73,
				d81, d82, d83,
				d91, d92, d93;

	assign d71 = (state_ram9 == 1)? q71 : (state_ram7 == 1)? q81 : q91;
	assign d72 = (state_ram9 == 1)? q72 : (state_ram7 == 1)? q82 : q92;
	assign d73 = (state_ram9 == 1)? q73 : (state_ram7 == 1)? q83 : q83;
	assign d81 = (state_ram9 == 1)? q81 : (state_ram7 == 1)? q91 : q71;
	assign d82 = (state_ram9 == 1)? q82 : (state_ram7 == 1)? q92 : q72;
	assign d83 = (state_ram9 == 1)? q83 : (state_ram7 == 1)? q93 : q73;
	assign d91 = (state_ram9 == 1)? q91 : (state_ram7 == 1)? q71 : q81;
	assign d92 = (state_ram9 == 1)? q92 : (state_ram7 == 1)? q72 : q82;
	assign d93 = (state_ram9 == 1)? q93 : (state_ram7 == 1)? q73 : q83;	
*****************************************************************************/	
	// filter color data
	wire [4:0] f_11_r, f_12_r, f_13_r,
				 f_21_r, f_22_r, f_23_r,
				 f_31_r, f_32_r, f_33_r;

	wire [5:0] f_11_g, f_12_g, f_13_g,
				f_21_g, f_22_g, f_23_g,
				f_31_g, f_32_g, f_33_g;

	wire [4:0] f_11_b, f_12_b, f_13_b,
			   f_21_b, f_22_b, f_23_b,
			   f_31_b, f_32_b, f_33_b;

	assign f_11_r = d11[15:11];
	assign f_12_r = d12[15:11];
	assign f_13_r = d13[15:11];
	assign f_21_r = d41[15:11];
	assign f_22_r = d42[15:11];
	assign f_23_r = d43[15:11];
	assign f_31_r = d71[15:11];
	assign f_32_r = d72[15:11];
	assign f_33_r = d73[15:11];

	assign f_11_g = d11[10:5];
	assign f_12_g = d12[10:5];
	assign f_13_g = d13[10:5];
	assign f_21_g = d41[10:5];
	assign f_22_g = d42[10:5];
	assign f_23_g = d43[10:5];
	assign f_31_g = d71[10:5];
	assign f_32_g = d72[10:5];
	assign f_33_g = d73[10:5];

	assign f_11_b = d11[4:0];
	assign f_12_b = d12[4:0];
	assign f_13_b = d13[4:0];
	assign f_21_b = d41[4:0];
	assign f_22_b = d42[4:0];
	assign f_23_b = d43[4:0];
	assign f_31_b = d71[4:0];
	assign f_32_b = d72[4:0];
	assign f_33_b = d73[4:0];


	// filtered RGB
 	wire [4:0] filtered_r;
	wire [5:0] filtered_g;
	wire [4:0] filtered_b;

	assign filtered_r = (f_12_r+f_21_r+f_23_r+f_32_r) - (f_22_r<<2);

	assign filtered_g = (f_12_g+f_21_g+f_23_g+f_32_g) - (f_22_g<<2);

	assign filtered_b = (f_12_b+f_21_b+f_23_b+f_32_b) - (f_22_b<<2);
	

	// final filtered data
	wire [15:0] filtered_data;

	assign filtered_data[15:11] = filtered_r[4:0];
	assign filtered_data[10:5] = filtered_g[5:0];
	assign filtered_data[4:0] = filtered_b[4:0];	

	// output data
	assign d_out = (flag_cursor_mid)? filtered_data : 0; 	

	// data ready signal for write_filter_tb
	assign d_rdy = (wren == 0) & ((cursor == cursor3)|~flag_cursor_mid);
	
	// connection of wire and ram
    ram ram11
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr11),
        .wren(wren_row1),

		// data
        .data(d_in),
        .q(q11)
    );

    ram ram12
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr12),
        .wren(wren_row1),

		// data
        .data(d_in),
        .q(q12)
    );

    ram ram13
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr13),
        .wren(wren_row1),

		// data
        .data(d_in),
        .q(q13)
    );

    ram ram21
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr21),
        .wren(wren_row2),

		// data
        .data(d_in),
        .q(q21)
    );

    ram ram22
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr22),
        .wren(wren_row2),

		// data
        .data(d_in),
        .q(q22)
    );

    ram ram23
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr23),
        .wren(wren_row2),

		// data
        .data(d_in),
        .q(q23)
    );

    ram ram31
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr31),
        .wren(wren_row3),

		// data
        .data(d_in),
        .q(q31)
    );

    ram ram32
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr32),
        .wren(wren_row3),

		// data
        .data(d_in),
        .q(q32)
    );

    ram ram33
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr33),
        .wren(wren_row3),

		// data
        .data(d_in),
        .q(q33)
    );
   

    ram ram41
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr41),
        .wren(wren_row4),

		// data
        .data(d_in),
        .q(q41)
    );

    ram ram42
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr42),
        .wren(wren_row4),

		// data
        .data(d_in),
        .q(q42)
    );

    ram ram43
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr43),
        .wren(wren_row4),

		// data
        .data(d_in),
        .q(q43)
    );

    ram ram51
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr51),
        .wren(wren_row5),

		// data
        .data(d_in),
        .q(q51)
    );

    ram ram52
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr52),
        .wren(wren_row5),

		// data
        .data(d_in),
        .q(q52)
    );

    ram ram53
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr53),
        .wren(wren_row5),

		// data
        .data(d_in),
        .q(q53)
    );

    ram ram61
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr61),
        .wren(wren_row6),

		// data
        .data(d_in),
        .q(q61)
    );

    ram ram62
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr62),
        .wren(wren_row6),

		// data
        .data(d_in),
        .q(q62)
    );

    ram ram63
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr63),
        .wren(wren_row6),

		// data
        .data(d_in),
        .q(q63)
    );
	
    ram ram71
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr71),
        .wren(wren_row7),

		// data
        .data(d_in),
        .q(q71)
    );

    ram ram72
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr72),
        .wren(wren_row7),

		// data
        .data(d_in),
        .q(q72)
    );

    ram ram73
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr73),
        .wren(wren_row7),

		// data
        .data(d_in),
        .q(q73)
    );

    ram ram81
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr81),
        .wren(wren_row8),

		// data
        .data(d_in),
        .q(q81)
    );

    ram ram82
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr82),
        .wren(wren_row8),

		// data
        .data(d_in),
        .q(q82)
    );

    ram ram83
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr83),
        .wren(wren_row8),

		// data
        .data(d_in),
        .q(q83)
    );

    ram ram91
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr91),
        .wren(wren_row9),

		// data
        .data(d_in),
        .q(q91)
    );

    ram ram92
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr92),
        .wren(wren_row9),

		// data
        .data(d_in),
        .q(q92)
    );

    ram ram93
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr93),
        .wren(wren_row9),

		// data
        .data(d_in),
        .q(q93)
    );	
endmodule