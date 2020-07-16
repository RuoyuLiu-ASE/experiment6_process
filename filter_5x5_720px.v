/*
	Author:  Yee Yang Tan
	Last modified:  16/04/2020
*/

module filter_5x5_720px
#(
    parameter BLOCK_LENGTH = 720,

    // weight of each pixel, change these parameters to make difference effect of filter
    // |WA5|WB5|WC5|WB5|WA5|
    // |WB5|WA3|WB3|WA3|WB5|
    // |WC5|WB3|WA1|WB3|WC5|
    // |WB5|WA3|WB3|WA3|WB5|
    // |WA5|WB5|WC5|WB5|WA5|
    parameter   WA5 = 0,
                WB5 = 0,
                WC5 = 1,
                WA3 = 1,
                WB3 = 2,
                WA1 = -16,

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


	// flag to determine the middle px
	wire flag_cursor_mid;

	assign flag_cursor_mid = (cursor > 0 ) & (cursor < BLOCK_LENGTH );	

	// State to determine the position of each row of ram
	// state for reading data from ram
	reg state_ram1, state_ram2, state_ram3, state_ram4, state_ram5;

	always @ (posedge wren, posedge reset) begin
        if (reset == 1) begin
			state_ram1 <= 1;
			state_ram2 <= 0;
			state_ram3 <= 0;
			state_ram4 <= 0;
			state_ram5 <= 0;
        end
        else begin
			state_ram1 <= state_ram5;
			state_ram2 <= state_ram1;
			state_ram3 <= state_ram2;
			state_ram4 <= state_ram3;
			state_ram5 <= state_ram4;
        end
	end
	
	// state for writing the data to the ram
	
	// state for reading the data from the ram
	

	// writing enable signal for each 3 row
	wire wren_row1, wren_row2, wren_row3, wren_row4, wren_row5;

	assign wren_row1 = (wren == 1) & (state_ram1);
	assign wren_row2 = (wren == 1) & (state_ram2);
	assign wren_row3 = (wren == 1) & (state_ram3);	
	assign wren_row4 = (wren == 1) & (state_ram4);	
	assign wren_row5 = (wren == 1) & (state_ram5);	
	// writing enable signal for each row of ram

	

	// address for each ram
	
    // If the ram is not used, the address value of the ram is 0xFF
	wire [7:0] addr11, addr12, addr13, addr14, addr15,
			   addr21, addr22, addr23, addr24, addr25,
			   addr31, addr32, addr33, addr34, addr35,
			   addr41, addr42, addr43, addr44, addr45,
			   addr51, addr52, addr53, addr54, addr55;

	assign addr11 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 2 : -1;
	assign addr12 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 1 : -1;
	assign addr13 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr14 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr15 = ( wren==1 & wren_row1==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;

	assign addr21 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 2 : -1;
	assign addr22 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 1 : -1;
	assign addr23 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr24 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr25 = ( wren==1 & wren_row2==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;

	assign addr31 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 2 : -1;
	assign addr32 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 1 : -1;
	assign addr33 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr34 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr35 = ( wren==1 & wren_row3==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;

	assign addr41 = ( wren==1 & wren_row4==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 2 : -1;
	assign addr42 = ( wren==1 & wren_row4==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 1 : -1;
	assign addr43 = ( wren==1 & wren_row4==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr44 = ( wren==1 & wren_row4==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr45 = ( wren==1 & wren_row4==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;

	assign addr51 = ( wren==1 & wren_row5==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 2 : -1;
	assign addr52 = ( wren==1 & wren_row5==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] - 1 : -1;
	assign addr53 = ( wren==1 & wren_row5==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 0 : -1;
	assign addr54 = ( wren==1 & wren_row5==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 1 : -1;
	assign addr55 = ( wren==1 & wren_row5==1 )? cursor[7:0] : ( flag_cursor_mid )? cursor[7:0] + 2 : -1;

	// memory output of the ram to filter decision
	wire [15:0] q11, q12, q13, q14, q15,
			   q21, q22, q23, q24, q25,
			   q31, q32, q33, q34, q35,
			   q41, q42, q43, q44, q45,
			   q51, q52, q53, q54, q55;

	wire [15:0] d11, d12, d13, d14, d15,
			   d21, d22, d23, d24, d25,
			   d31, d32, d33, d34, d35,
			   d41, d42, d43, d44, d45,
			   d51, d52, d53, d54, d55;

	assign d11 = (state_ram5 == 1)? q11 : (state_ram4 == 1)? q51 : (state_ram3 == 1)? q41 : (state_ram1 == 1)? q21 : q31;
	assign d12 = (state_ram5 == 1)? q12 : (state_ram4 == 1)? q52 : (state_ram3 == 1)? q42 : (state_ram1 == 1)? q22 : q32;
	assign d13 = (state_ram5 == 1)? q13 : (state_ram4 == 1)? q53 : (state_ram3 == 1)? q43 : (state_ram1 == 1)? q23 : q33;
	assign d14 = (state_ram5 == 1)? q14 : (state_ram4 == 1)? q54 : (state_ram3 == 1)? q44 : (state_ram1 == 1)? q24 : q34;
	assign d15 = (state_ram5 == 1)? q15 : (state_ram4 == 1)? q55 : (state_ram3 == 1)? q45 : (state_ram1 == 1)? q25 : q35;

	assign d21 = (state_ram5 == 1)? q21 : (state_ram4 == 1)? q11 : (state_ram3 == 1)? q51 : (state_ram1 == 1)? q31 : q41;
	assign d22 = (state_ram5 == 1)? q22 : (state_ram4 == 1)? q12 : (state_ram3 == 1)? q52 : (state_ram1 == 1)? q32 : q42;
	assign d23 = (state_ram5 == 1)? q23 : (state_ram4 == 1)? q13 : (state_ram3 == 1)? q53 : (state_ram1 == 1)? q33 : q43;
	assign d24 = (state_ram5 == 1)? q24 : (state_ram4 == 1)? q14 : (state_ram3 == 1)? q54 : (state_ram1 == 1)? q34 : q44;
	assign d25 = (state_ram5 == 1)? q25 : (state_ram4 == 1)? q15 : (state_ram3 == 1)? q55 : (state_ram1 == 1)? q35 : q45;

	assign d31 = (state_ram5 == 1)? q31 : (state_ram4 == 1)? q21 : (state_ram3 == 1)? q11 : (state_ram1 == 1)? q41 : q51;
	assign d32 = (state_ram5 == 1)? q32 : (state_ram4 == 1)? q22 : (state_ram3 == 1)? q12 : (state_ram1 == 1)? q42 : q52;
	assign d33 = (state_ram5 == 1)? q33 : (state_ram4 == 1)? q23 : (state_ram3 == 1)? q13 : (state_ram1 == 1)? q43 : q53;
	assign d34 = (state_ram5 == 1)? q34 : (state_ram4 == 1)? q24 : (state_ram3 == 1)? q14 : (state_ram1 == 1)? q44 : q54;
	assign d35 = (state_ram5 == 1)? q35 : (state_ram4 == 1)? q25 : (state_ram3 == 1)? q15 : (state_ram1 == 1)? q45 : q55;

	assign d41 = (state_ram5 == 1)? q41 : (state_ram4 == 1)? q31 : (state_ram3 == 1)? q21 : (state_ram1 == 1)? q51 : q11;
	assign d42 = (state_ram5 == 1)? q42 : (state_ram4 == 1)? q32 : (state_ram3 == 1)? q22 : (state_ram1 == 1)? q52 : q12;
	assign d43 = (state_ram5 == 1)? q43 : (state_ram4 == 1)? q33 : (state_ram3 == 1)? q23 : (state_ram1 == 1)? q53 : q13;
	assign d44 = (state_ram5 == 1)? q44 : (state_ram4 == 1)? q34 : (state_ram3 == 1)? q24 : (state_ram1 == 1)? q54 : q14;
	assign d45 = (state_ram5 == 1)? q45 : (state_ram4 == 1)? q35 : (state_ram3 == 1)? q25 : (state_ram1 == 1)? q55 : q15;

	assign d51 = (state_ram5 == 1)? q51 : (state_ram4 == 1)? q41 : (state_ram3 == 1)? q31 : (state_ram1 == 1)? q11 : q21;
	assign d52 = (state_ram5 == 1)? q52 : (state_ram4 == 1)? q42 : (state_ram3 == 1)? q32 : (state_ram1 == 1)? q12 : q22;
	assign d53 = (state_ram5 == 1)? q53 : (state_ram4 == 1)? q43 : (state_ram3 == 1)? q33 : (state_ram1 == 1)? q13 : q23;
	assign d54 = (state_ram5 == 1)? q54 : (state_ram4 == 1)? q44 : (state_ram3 == 1)? q34 : (state_ram1 == 1)? q14 : q24;
	assign d55 = (state_ram5 == 1)? q55 : (state_ram4 == 1)? q45 : (state_ram3 == 1)? q35 : (state_ram1 == 1)? q15 : q25;

	// the correct position of the matrix, since the position of each ram depends on the state
	
    // seperate the RGB of the value from f_xy.
	wire [4:0] f_11_r, f_12_r, f_13_r, f_14_r, f_15_r,
				f_21_r, f_22_r, f_23_r, f_24_r, f_25_r,
				f_31_r, f_32_r, f_33_r;	 f_34_r, f_35_r,
				f_41_r, f_42_r, f_44_r;	 f_44_r, f_45_r,
				f_51_r, f_52_r, f_55_r;	 f_55_r, f_55_r,

	wire [5:0] f_11_g, f_12_g, f_13_g, f_14_g, f_15_g,
				f_21_g, f_22_g, f_23_g, f_24_g, f_25_g,
				f_31_g, f_32_g, f_33_g;	 f_34_g, f_35_g,
				f_41_g, f_42_g, f_44_g;	 f_44_g, f_45_g,
				f_51_g, f_52_g, f_55_g;	 f_55_g, f_55_g,

	wire [4:0] f_11_b, f_12_b, f_13_b, f_14_b, f_15_b,
				f_21_b, f_22_b, f_23_b, f_24_b, f_25_b,
				f_31_b, f_32_b, f_33_b;	 f_34_b, f_35_b,
				f_41_b, f_42_b, f_44_b;	 f_44_b, f_45_b,
				f_51_b, f_52_b, f_55_b;	 f_55_b, f_55_b,

	assign f_11_r = d11[15:11];
	assign f_12_r = d12[15:11];
	assign f_13_r = d13[15:11];
	assign f_14_r = d14[15:11];
	assign f_15_r = d15[15:11];

	assign f_21_r = d21[15:11];
	assign f_22_r = d22[15:11];
	assign f_23_r = d23[15:11];
	assign f_24_r = d24[15:11];
	assign f_25_r = d25[15:11];

	assign f_31_r = d31[15:11];
	assign f_32_r = d32[15:11];
	assign f_33_r = d33[15:11];
	assign f_34_r = d34[15:11];
	assign f_35_r = d35[15:11];

	assign f_41_r = d41[15:11];
	assign f_42_r = d42[15:11];
	assign f_43_r = d43[15:11];
	assign f_44_r = d44[15:11];
	assign f_45_r = d45[15:11];

	assign f_51_r = d51[15:11];
	assign f_52_r = d52[15:11];
	assign f_53_r = d53[15:11];
	assign f_54_r = d54[15:11];
	assign f_55_r = d55[15:11];
	
	assign f_11_g = d11[10:5];
	assign f_12_g = d12[10:5];
	assign f_13_g = d13[10:5];
	assign f_14_g = d14[10:5];
	assign f_15_g = d15[10:5];

	assign f_21_g = d21[10:5];
	assign f_22_g = d22[10:5];
	assign f_23_g = d23[10:5];
	assign f_24_g = d24[10:5];
	assign f_25_g = d25[10:5];

	assign f_31_g = d31[10:5];
	assign f_32_g = d32[10:5];
	assign f_33_g = d33[10:5];
	assign f_34_g = d34[10:5];
	assign f_35_g = d35[10:5];

	assign f_41_g = d41[10:5];
	assign f_42_g = d42[10:5];
	assign f_43_g = d43[10:5];
	assign f_44_g = d44[10:5];
	assign f_45_g = d45[10:5];

	assign f_51_g = d51[10:5];
	assign f_52_g = d52[10:5];
	assign f_53_g = d53[10:5];
	assign f_54_g = d54[10:5];
	assign f_55_g = d55[10:5];

	assign f_11_b = d11[4:0];
	assign f_12_b = d12[4:0];
	assign f_13_b = d13[4:0];
	assign f_14_b = d14[4:0];
	assign f_15_b = d15[4:0];

	assign f_21_b = d21[4:0];
	assign f_22_b = d22[4:0];
	assign f_23_b = d23[4:0];
	assign f_24_b = d24[4:0];
	assign f_25_b = d25[4:0];

	assign f_31_b = d31[4:0];
	assign f_32_b = d32[4:0];
	assign f_33_b = d33[4:0];
	assign f_34_b = d34[4:0];
	assign f_35_b = d35[4:0];

	assign f_41_g = d41[4:0];
	assign f_42_g = d42[4:0];
	assign f_43_g = d43[4:0];
	assign f_44_g = d44[4:0];
	assign f_45_g = d45[4:0];

	assign f_51_g = d51[4:0];
	assign f_52_g = d52[4:0];
	assign f_53_g = d53[4:0];
	assign f_54_g = d54[4:0];
	assign f_55_g = d55[4:0];
    // filtered data RGB
	wire [4:0] filtered_r;
	wire [5:0] filtered_g;
	wire [4:0] filtered_b;
    
	assign filtered_r = (f_13_r+f_22_r+ (f_23_r << 1) +f_24_r+f_31_r+(f_32_r << 1)+(f_34_r << 1)+f_35_r+f_42_r+(f_43_r << 1)+f_44_r+f_53_r) + f_33_r*WA1;

	assign filtered_g = (f_13_g+f_22_g+ (f_23_g << 1) +f_24_g+f_31_g+(f_32_g << 1)+(f_34_g << 1)+f_35_g+f_42_g+(f_43_g << 1)+f_44_g+f_53_g) + f_33_g*WA1;

	assign filtered_b = (f_13_b+f_22_b+ (f_23_b << 1) +f_24_b+f_31_b+(f_32_b << 1)+(f_34_b << 1)+f_35_b+f_42_b+(f_43_b << 1)+f_44_b+f_53_b) + f_33_b*WA1;
    // final filtered data
 	wire [15:0] filtered_data;

	assign filtered_data[15:11] = filtered_r[4:0];
	assign filtered_data[10:5] = filtered_g[5:0];
	assign filtered_data[4:0] = filtered_b[4:0];   

    // output data
	assign d_out = (flag_cursor_mid)? filtered_data : 0;    

	// data ready signal for write_filter_tb
	assign d_rdy = (wren == 0) & ((cursor == cursor3)|~flag_cursor_mid);


    // connection of wire with rams
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

    ram ram14
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr14),
        .wren(wren_row1),

		// data
        .data(d_in),
        .q(q14)
    );
    
    ram ram15
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr15),
        .wren(wren_row1),

		// data
        .data(d_in),
        .q(q15)
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

    ram ram24
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr24),
        .wren(wren_row2),

		// data
        .data(d_in),
        .q(q24)
    );
    
    ram ram25
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr25),
        .wren(wren_row2),

		// data
        .data(d_in),
        .q(q25)
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

    ram ram34
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr34),
        .wren(wren_row3),

		// data
        .data(d_in),
        .q(q34)
    );
    
    ram ram35
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr35),
        .wren(wren_row3),

		// data
        .data(d_in),
        .q(q35)
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

    ram ram44
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr44),
        .wren(wren_row4),

		// data
        .data(d_in),
        .q(q44)
    );
    
    ram ram45
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr45),
        .wren(wren_row4),

		// data
        .data(d_in),
        .q(q45)
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

    ram ram54
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr54),
        .wren(wren_row5),

		// data
        .data(d_in),
        .q(q54)
    );
    
    ram ram55
	(
		// sys
        .clock(clk),

		// control signal
        .address(addr55),
        .wren(wren_row5),

		// data
        .data(d_in),
        .q(q55)
    );

endmodule
