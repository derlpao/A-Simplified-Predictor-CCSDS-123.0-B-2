`timescale 1ns/1ps

module codebook_b0#(
	parameter										CODEBOOK_LENGTH_MAX	= 64,
    parameter										ENCODE_DATALENGTH	= 21
)(
	//input	wire									codebook_select_i	,
	input	wire	[5 : 0]							ap_cnt_i			,
	input	wire	[CODEBOOK_LENGTH_MAX - 1 : 0]	ap_data_i			,

	output	wire									encode_match_o		,
	output	wire	[5 : 0]							encode_length_o		,
	output	wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_o
);

reg		[ENCODE_DATALENGTH - 1 : 0]		encode_data_b0_r	;
reg		[5 : 0]							encode_length_b0_r	;
reg										encode_match_b0_r	;

assign encode_data_o	= encode_data_b0_r		;
assign encode_length_o 	= encode_length_b0_r	;
assign encode_match_o 	= encode_match_b0_r		;

/**************************************************************************/
//codebook_b0 match
always @(ap_cnt_i, ap_data_i) begin
	case(ap_cnt_i)
		6'd1 : begin
			case(ap_data_i)
				'h1, 'h2, 'h3, 'h5, 'h6, 'h9, 'hA, 'hF, 'hB, 'hC : encode_match_b0_r = 1'd1;
				default : encode_match_b0_r = 1'd0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h00, 'h40, 'h41, 'h42, 'h43, 'h03, 'h04, 'h05, 'h06, 'h70, 'h71, 
				'h72, 'h80, 'h81, 'h82, 'h45, 'h46, 'h07, 'h08, 'h09, 'h0A, 'h0F, 
				'h73, 'h74, 'h75, 'h76, 'h83, 'h84, 'h85, 'h86, 'h47, 'h48, 'h4F, 
				'h0B, 'h0C, 'h77, 'h78, 'h87, 'h88, 'h49, 'h4A, 'h4B, 'h4C, 'h79, 
				'h7A, 'h7F, 'h89, 'h8A, 'h8F, 'h7B, 'h7C, 'h8B, 'h8C : encode_match_b0_r = 1'd1;
				default : encode_match_b0_r = 1'd0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h010, 'h011, 'h012, 'h020, 'h021, 'h022, 'h013, 'h014, 'h015, 'h016,
				'h440, 'h441, 'h442, 'h023, 'h024, 'h025, 'h026, 'h017, 'h018, 'h443,
				'h444, 'h445, 'h446, 'h027, 'h028, 'h019, 'h01A, 'h01F, 'h447, 'h448,
				'h029, 'h02A, 'h02F, 'h01B, 'h01C, 'h449, 'h44A, 'h44F, 'h02B, 'h02C,
				'h44B, 'h44C : encode_match_b0_r = 1'd1;
				default : encode_match_b0_r = 1'd0;
			endcase
		end
		default : encode_match_b0_r = 1'd0;
	endcase
end

//codebook_b0 length
always @(ap_cnt_i, ap_data_i) begin
	case(ap_cnt_i)
		6'd1 : begin
			case(ap_data_i)
				'h1, 'h2, 'h3 : encode_length_b0_r = 3;
				'h5, 'h6 : 		encode_length_b0_r = 4;
				'h9, 'hA, 'hF :	encode_length_b0_r = 5;
				'hB, 'hC : 		encode_length_b0_r = 6;
				default : encode_length_b0_r = 0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h00 : 																	encode_length_b0_r = 5;
				'h40,'h41,'h42,'h43,'h03,'h04,'h05,'h06 : 								encode_length_b0_r = 6;
				'h70,'h71,'h72,'h80,'h81,'h82,'h45,'h46,'h07,'h08 : 					encode_length_b0_r = 7;
				'h09,'h0A,'h0F,'h73,'h74,'h75,'h76,'h83,'h84,'h85,'h86,'h47,'h48,'h4F : encode_length_b0_r = 8;
				'h0B,'h0C,'h77,'h78,'h87,'h88,'h49,'h4A,'h4B,'h4C : 					encode_length_b0_r = 9;
				'h79,'h7A,'h7F,'h89,'h8A,'h8F : 										encode_length_b0_r = 10;
				'h7B,'h7C,'h8B,'h8C	: 													encode_length_b0_r = 11;
				default : encode_length_b0_r = 0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h010,'h011,'h012,'h020,'h021,'h022	: 								encode_length_b0_r = 8;
				'h013,'h014,'h015,'h016,'h440,'h441,'h442,'h023,'h024,'h025,'h026 : encode_length_b0_r = 9;
				'h017,'h018,'h443,'h444,'h445,'h446,'h027,'h028: 					encode_length_b0_r = 10;
				'h019,'h01A,'h01F,'h447,'h448,'h029,'h02A,'h02F: 					encode_length_b0_r = 11;
				'h01B,'h01C,'h449,'h44A,'h44F,'h02B,'h02C :							encode_length_b0_r = 12;
				'h44B,'h44C : 														encode_length_b0_r = 13;
				default : encode_length_b0_r = 0;
			endcase
		end
		default : encode_length_b0_r = 0;
	endcase
end

//codebook_b0 data
always @(ap_cnt_i, ap_data_i) begin
	case(ap_cnt_i)
		6'd1 : begin
			case(ap_data_i)
				'h1 : encode_data_b0_r = 'b000;
				'h2 : encode_data_b0_r = 'b001;
				'h3 : encode_data_b0_r = 'b010;
				'h5 : encode_data_b0_r = 'b0110;
				'h6 : encode_data_b0_r = 'b0111;
				'h9 : encode_data_b0_r = 'b10000;
				'hA : encode_data_b0_r = 'b10001;
				'hF : encode_data_b0_r = 'b10010;
				'hB : encode_data_b0_r = 'b101000;
				'hC : encode_data_b0_r = 'b101001;
				default : encode_data_b0_r = 'b0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h00 : encode_data_b0_r = 'b10011;
				'h40 : encode_data_b0_r = 'b101110;
				'h41 : encode_data_b0_r = 'b101111;
				'h42 : encode_data_b0_r = 'b110000;
				'h43 : encode_data_b0_r = 'b110001;
				'h03 : encode_data_b0_r = 'b101010;
				'h04 : encode_data_b0_r = 'b101011;
				'h05 : encode_data_b0_r = 'b101100;
				'h06 : encode_data_b0_r = 'b101101;
				'h70 : encode_data_b0_r = 'b1101000;
				'h71 : encode_data_b0_r = 'b1101001;
				'h72 : encode_data_b0_r = 'b1101010;
				'h80 : encode_data_b0_r = 'b1101011;
				'h81 : encode_data_b0_r = 'b1101100;
				'h82 : encode_data_b0_r = 'b1101101;
				'h45 : encode_data_b0_r = 'b1100110;
				'h46 : encode_data_b0_r = 'b1100111;
				'h07 : encode_data_b0_r = 'b1100100;
				'h08 : encode_data_b0_r = 'b1100101;
				'h09 : encode_data_b0_r = 'b11011100;
				'h0A : encode_data_b0_r = 'b11011101;
				'h0F : encode_data_b0_r = 'b11011110;
				'h73 : encode_data_b0_r = 'b11100010;
				'h74 : encode_data_b0_r = 'b11100011;
				'h75 : encode_data_b0_r = 'b11100100;
				'h76 : encode_data_b0_r = 'b11100101;
				'h83 : encode_data_b0_r = 'b11100110;
				'h84 : encode_data_b0_r = 'b11100111;
				'h85 : encode_data_b0_r = 'b11101000;
				'h86 : encode_data_b0_r = 'b11101001;
				'h47 : encode_data_b0_r = 'b11011111;
				'h48 : encode_data_b0_r = 'b11100000;
				'h4F : encode_data_b0_r = 'b11100001;
				'h0B : encode_data_b0_r = 'b111100000;
				'h0C : encode_data_b0_r = 'b111100001;
				'h77 : encode_data_b0_r = 'b111100110;
				'h78 : encode_data_b0_r = 'b111100111;
				'h87 : encode_data_b0_r = 'b111101000;
				'h88 : encode_data_b0_r = 'b111101001;
				'h49 : encode_data_b0_r = 'b111100010;
				'h4A : encode_data_b0_r = 'b111100011;
				'h4B : encode_data_b0_r = 'b111100100;
				'h4C : encode_data_b0_r = 'b111100101;
				'h79 : encode_data_b0_r = 'b1111101010;
				'h7A : encode_data_b0_r = 'b1111101011;
				'h7F : encode_data_b0_r = 'b1111101100;
				'h89 : encode_data_b0_r = 'b1111101101;
				'h8A : encode_data_b0_r = 'b1111101110;
				'h8F : encode_data_b0_r = 'b1111101111;
				'h7B : encode_data_b0_r = 'b11111110000;
				'h7C : encode_data_b0_r = 'b11111110001;
				'h8B : encode_data_b0_r = 'b11111110010;
				'h8C : encode_data_b0_r = 'b11111110011;
				default : encode_data_b0_r = 'b0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h010 : encode_data_b0_r =	'b11101010;
				'h011 : encode_data_b0_r =	'b11101011;
				'h012 : encode_data_b0_r =	'b11101100;
				'h020 : encode_data_b0_r =	'b11101101;
				'h021 : encode_data_b0_r =	'b11101110;
				'h022 : encode_data_b0_r =	'b11101111;
				'h013 : encode_data_b0_r =	'b111101010;
				'h014 : encode_data_b0_r =	'b111101011;
				'h015 : encode_data_b0_r =	'b111101100;
				'h016 : encode_data_b0_r =	'b111101101;
				'h440 : encode_data_b0_r =	'b111110010;
				'h441 : encode_data_b0_r =	'b111110011;
				'h442 : encode_data_b0_r =	'b111110100;
				'h023 : encode_data_b0_r =	'b111101110;
				'h024 : encode_data_b0_r =	'b111101111;
				'h025 : encode_data_b0_r =	'b111110000;
				'h026 : encode_data_b0_r =	'b111110001;
				'h017 : encode_data_b0_r =	'b1111110000;
				'h018 : encode_data_b0_r =	'b1111110001;
				'h443 : encode_data_b0_r =	'b1111110100;
				'h444 : encode_data_b0_r =	'b1111110101;
				'h445 : encode_data_b0_r =	'b1111110110;
				'h446 : encode_data_b0_r =	'b1111110111;
				'h027 : encode_data_b0_r =	'b1111110010;
				'h028 : encode_data_b0_r =	'b1111110011;
				'h019 : encode_data_b0_r =	'b11111110100;
				'h01A : encode_data_b0_r =	'b11111110101;
				'h01F : encode_data_b0_r =	'b11111110110;
				'h447 : encode_data_b0_r =	'b11111111010;
				'h448 : encode_data_b0_r =	'b11111111011;
				'h029 : encode_data_b0_r =	'b11111110111;
				'h02A : encode_data_b0_r =	'b11111111000;
				'h02F : encode_data_b0_r =	'b11111111001;
				'h01B : encode_data_b0_r =	'b111111111000;
				'h01C : encode_data_b0_r =	'b111111111001;
				'h449 : encode_data_b0_r =	'b111111111100;
				'h44A : encode_data_b0_r =	'b111111111101;
				'h44F : encode_data_b0_r =	'b111111111110;
				'h02B : encode_data_b0_r =	'b111111111010;
				'h02C : encode_data_b0_r =	'b111111111011;
				'h44B : encode_data_b0_r =	'b1111111111110;
				'h44C : encode_data_b0_r =	'b1111111111111;
				default : encode_data_b0_r = 'b0;
			endcase
		end
		default : encode_data_b0_r = 'b0;
	endcase
end
/**************************************************************************/

endmodule
