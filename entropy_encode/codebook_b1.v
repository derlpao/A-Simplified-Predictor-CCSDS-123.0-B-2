`timescale 1ns/1ps

module codebook_b1#(
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

reg		[ENCODE_DATALENGTH - 1 : 0]		encode_data_b1_r	;
reg		[5 : 0]							encode_length_b1_r	;
reg										encode_match_b1_r	;

assign encode_match_o 	= encode_match_b1_r		;
assign encode_length_o 	= encode_length_b1_r	;
assign encode_data_o 	= encode_data_b1_r		;

/**************************************************************************/
//codebook_b1 match
always @(ap_cnt_i, ap_data_i) begin
	case(ap_cnt_i)
		6'd1 : begin
			case(ap_data_i)
				'h3,'h4,'h5,'h6,'h7,'h8,'h9,'hF : encode_match_b1_r = 1'd1;
				default	: encode_match_b1_r = 1'd0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h01,'h02,'h20,'h21,'h22,'h10,'h11,'h12,'h24,'h14,
				'h05,'h06,'h26,'h07,'h08,'h27,'h28,'h17,'h18,'h0F,
				'h29,'h2A,'h2F,'hA0,'hA1,'hA2,'h19,'h1A,'h1F,'h09,
				'h0A,'hA3,'hA4,'hA5,'hA6,'hA7,'hA8,'hAF,'hA9,'hAA : encode_match_b1_r = 1'd1;
				default	: encode_match_b1_r = 1'd0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h000,'h001,'h002,'h130,'h131,'h132,'h003,'h004,'h030,
				'h031,'h032,'h040,'h041,'h042,'h230,'h231,'h232,'h233,
				'h234,'h133,'h134,'h005,'h006,'h250,'h251,'h252,'h150,
				'h151,'h152,'h033,'h034,'h035,'h036,'h160,'h161,'h162,
				'h043,'h044,'h045,'h235,'h236,'h135,'h136,'h007,'h008,
				'h253,'h254,'h153,'h154,'h155,'h037,'h163,'h164,'h046,
				'h237,'h238,'h137,'h138,'h009,'h00A,'h00F,'h255,'h256,
				'h156,'h038,'h03F,'h165,'h166,'h047,'h048,'h04F,'h239,
				'h23A,'h23F,'h139,'h13A,'h13F,'h257,'h258,'h157,'h158,
				'h039,'h03A,'h15F,'h167,'h168,'h049,'h04A,'h259,'h25A,
				'h25F,'h159,'h15A,'h169,'h16A,'h16F : encode_match_b1_r = 1'd1;
				default	: encode_match_b1_r = 1'd0;
			endcase
		end
		default : encode_match_b1_r = 1'd0;
	endcase
end

//codebook_b1 length
always @(ap_cnt_i, ap_data_i) begin
	case(ap_cnt_i)
		6'd1 : begin
			case(ap_data_i)
				'h3,'h4 : encode_length_b1_r = 3;
				'h5,'h6 : encode_length_b1_r = 4;
				'h7,'h8 : encode_length_b1_r = 5;
				'h9,'hF : encode_length_b1_r = 6;
				default : encode_length_b1_r = 0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
			'h01,'h02,'h20,'h21,'h22,'h10,'h11,'h12 : 					encode_length_b1_r = 5;
			'h24,'h14,'h05,'h06 : 										encode_length_b1_r = 6;
			'h26,'h07,'h08 : 											encode_length_b1_r = 7;
			'h27,'h28,'h17,'h18,'h0F : 									encode_length_b1_r = 8;
			'h29,'h2A,'h2F,'hA0,'hA1,'hA2,'h19,'h1A,'h1F,'h09,'h0A : 	encode_length_b1_r = 9;
			'hA3,'hA4,'hA5,'hA6 : 										encode_length_b1_r = 10;
			'hA7 : 														encode_length_b1_r = 11;
			'hA8,'hAF : 												encode_length_b1_r = 12;
			'hA9,'hAA : 												encode_length_b1_r = 13;
			default : encode_length_b1_r = 0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h000,'h001,'h002 : 									encode_length_b1_r = 7;
				'h130,'h131,'h132,'h003,'h004,'h030,'h031,
				'h032,'h040,'h041,'h042,'h230,'h231,'h232 : 			encode_length_b1_r = 8;
				'h233,'h234,'h133,'h134,'h005,'h006,'h250,'h251,
				'h252,'h150,'h151,'h152,'h033,'h034,'h035,'h036,
				'h160,'h161,'h162,'h043,'h044,'h045 : 					encode_length_b1_r = 9;
				'h235,'h236,'h135,'h136,'h007,'h008,'h253,'h254,
				'h153,'h154,'h155,'h037,'h163,'h164,'h046 : 			encode_length_b1_r = 10;
				'h237,'h238,'h137,'h138,'h009,'h00A,'h00F,'h255,'h256,
				'h156,'h038,'h03F,'h165,'h166,'h047,'h048,'h04F : 		encode_length_b1_r = 11;
				'h239,'h23A,'h23F,'h139,'h13A,'h13F,'h257,'h258,'h157,
				'h158,'h039,'h03A,'h15F,'h167,'h168,'h049,'h04A : 		encode_length_b1_r = 12;
				'h259,'h25A,'h25F,'h159,'h15A,'h169,'h16A,'h16F : 		encode_length_b1_r = 13;
				default : encode_length_b1_r = 0;
			endcase
		end
		default : encode_length_b1_r = 0;
	endcase
end

//codebook_b1 data
always @(ap_cnt_i, ap_data_i) begin
	case(ap_cnt_i)
		6'd1 : begin
			case(ap_data_i)
				'h3 : encode_data_b1_r = 'b000				;
				'h4 : encode_data_b1_r = 'b001				;
				'h5 : encode_data_b1_r = 'b0100				;
				'h6 : encode_data_b1_r = 'b0101				;
				'h7 : encode_data_b1_r = 'b01100			;
				'h8 : encode_data_b1_r = 'b01101			;
				'h9 : encode_data_b1_r = 'b101100			;
				'hF : encode_data_b1_r = 'b101101			;
				default : encode_data_b1_r = 'b0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h01 : encode_data_b1_r = 'b01110			;
				'h02 : encode_data_b1_r = 'b01111			;
				'h20 : encode_data_b1_r = 'b10011			;
				'h21 : encode_data_b1_r = 'b10100			;
				'h22 : encode_data_b1_r = 'b10101			;
				'h10 : encode_data_b1_r = 'b10000			;
				'h11 : encode_data_b1_r = 'b10001			;
				'h12 : encode_data_b1_r = 'b10010			;
				'h24 : encode_data_b1_r = 'b110001			;
				'h14 : encode_data_b1_r = 'b110000			;
				'h05 : encode_data_b1_r = 'b101110			;
				'h06 : encode_data_b1_r = 'b101111			;
				'h26 : encode_data_b1_r = 'b1100110			;
				'h07 : encode_data_b1_r = 'b1100100			;
				'h08 : encode_data_b1_r = 'b1100101			;
				'h27 : encode_data_b1_r = 'b11010111		;
				'h28 : encode_data_b1_r = 'b11011000		;
				'h17 : encode_data_b1_r = 'b11010101		;
				'h18 : encode_data_b1_r = 'b11010110		;
				'h0F : encode_data_b1_r = 'b11010100		;
				'h29 : encode_data_b1_r = 'b111010011		;
				'h2A : encode_data_b1_r = 'b111010100		;
				'h2F : encode_data_b1_r = 'b111010101		;
				'hA0 : encode_data_b1_r = 'b111010110		;
				'hA1 : encode_data_b1_r = 'b111010111		;
				'hA2 : encode_data_b1_r = 'b111011000		;
				'h19 : encode_data_b1_r = 'b111010000		;
				'h1A : encode_data_b1_r = 'b111010001		;
				'h1F : encode_data_b1_r = 'b111010010		;
				'h09 : encode_data_b1_r = 'b111001110		;
				'h0A : encode_data_b1_r = 'b111001111		;
				'hA3 : encode_data_b1_r = 'b1111011110		;
				'hA4 : encode_data_b1_r = 'b1111011111		;
				'hA5 : encode_data_b1_r = 'b1111100000		;
				'hA6 : encode_data_b1_r = 'b1111100001		;
				'hA7 : encode_data_b1_r = 'b11111100010		;
				'hA8 : encode_data_b1_r = 'b111111101000	;
				'hAF : encode_data_b1_r = 'b111111101001	;
				'hA9 : encode_data_b1_r = 'b1111111110110	;
				'hAA : encode_data_b1_r = 'b1111111110111	;
				default : encode_data_b1_r = 'b0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h000 : encode_data_b1_r = 'b1100111		;
				'h001 : encode_data_b1_r = 'b1101000		;
				'h002 : encode_data_b1_r = 'b1101001		;
				'h130 : encode_data_b1_r = 'b11100001		;
				'h131 : encode_data_b1_r = 'b11100010		;
				'h132 : encode_data_b1_r = 'b11100011		;
				'h003 : encode_data_b1_r = 'b11011001		;
				'h004 : encode_data_b1_r = 'b11011010		;
				'h030 : encode_data_b1_r = 'b11011011		;
				'h031 : encode_data_b1_r = 'b11011100		;
				'h032 : encode_data_b1_r = 'b11011101		;
				'h040 : encode_data_b1_r = 'b11011110		;
				'h041 : encode_data_b1_r = 'b11011111		;
				'h042 : encode_data_b1_r = 'b11100000		;
				'h230 : encode_data_b1_r = 'b11100100		;
				'h231 : encode_data_b1_r = 'b11100101		;
				'h232 : encode_data_b1_r = 'b11100110		;
				'h233 : encode_data_b1_r = 'b111101010		;
				'h234 : encode_data_b1_r = 'b111101011		;
				'h133 : encode_data_b1_r = 'b111100010		;
				'h134 : encode_data_b1_r = 'b111100011		;
				'h005 : encode_data_b1_r = 'b111011001		;
				'h006 : encode_data_b1_r = 'b111011010		;
				'h250 : encode_data_b1_r = 'b111101100		;
				'h251 : encode_data_b1_r = 'b111101101		;
				'h252 : encode_data_b1_r = 'b111101110		;
				'h150 : encode_data_b1_r = 'b111100100		;
				'h151 : encode_data_b1_r = 'b111100101		;
				'h152 : encode_data_b1_r = 'b111100110		;
				'h033 : encode_data_b1_r = 'b111011011		;
				'h034 : encode_data_b1_r = 'b111011100		;
				'h035 : encode_data_b1_r = 'b111011101		;
				'h036 : encode_data_b1_r = 'b111011110		;
				'h160 : encode_data_b1_r = 'b111100111		;
				'h161 : encode_data_b1_r = 'b111101000		;
				'h162 : encode_data_b1_r = 'b111101001		;
				'h043 : encode_data_b1_r = 'b111011111		;
				'h044 : encode_data_b1_r = 'b111100000		;
				'h045 : encode_data_b1_r = 'b111100001		;
				'h235 : encode_data_b1_r = 'b1111101101		;
				'h236 : encode_data_b1_r = 'b1111101110		;
				'h135 : encode_data_b1_r = 'b1111100110		;
				'h136 : encode_data_b1_r = 'b1111100111		;
				'h007 : encode_data_b1_r = 'b1111100010		;
				'h008 : encode_data_b1_r = 'b1111100011		;
				'h253 : encode_data_b1_r = 'b1111101111		;
				'h254 : encode_data_b1_r = 'b1111110000		;
				'h153 : encode_data_b1_r = 'b1111101000		;
				'h154 : encode_data_b1_r = 'b1111101001		;
				'h155 : encode_data_b1_r = 'b1111101010		;
				'h037 : encode_data_b1_r = 'b1111100100		;
				'h163 : encode_data_b1_r = 'b1111101011		;
				'h164 : encode_data_b1_r = 'b1111101100		;
				'h046 : encode_data_b1_r = 'b1111100101		;
				'h237 : encode_data_b1_r = 'b11111110000	;
				'h238 : encode_data_b1_r = 'b11111110001	;
				'h137 : encode_data_b1_r = 'b11111101011	;
				'h138 : encode_data_b1_r = 'b11111101100	;
				'h009 : encode_data_b1_r = 'b11111100011	;
				'h00A : encode_data_b1_r = 'b11111100100	;
				'h00F : encode_data_b1_r = 'b11111100101	;
				'h255 : encode_data_b1_r = 'b11111110010	;
				'h256 : encode_data_b1_r = 'b11111110011	;
				'h156 : encode_data_b1_r = 'b11111101101	;
				'h038 : encode_data_b1_r = 'b11111100110	;
				'h03F : encode_data_b1_r = 'b11111100111	;
				'h165 : encode_data_b1_r = 'b11111101110	;
				'h166 : encode_data_b1_r = 'b11111101111	;
				'h047 : encode_data_b1_r = 'b11111101000	;
				'h048 : encode_data_b1_r = 'b11111101001	;
				'h04F : encode_data_b1_r = 'b11111101010	;
				'h239 : encode_data_b1_r = 'b111111110110	;
				'h23A : encode_data_b1_r = 'b111111110111	;
				'h23F : encode_data_b1_r = 'b111111111000	;
				'h139 : encode_data_b1_r = 'b111111101110	;
				'h13A : encode_data_b1_r = 'b111111101111	;
				'h13F : encode_data_b1_r = 'b111111110000	;
				'h257 : encode_data_b1_r = 'b111111111001	;
				'h258 : encode_data_b1_r = 'b111111111010	;
				'h157 : encode_data_b1_r = 'b111111110001	;
				'h158 : encode_data_b1_r = 'b111111110010	;
				'h039 : encode_data_b1_r = 'b111111101010	;
				'h03A : encode_data_b1_r = 'b111111101011	;
				'h15F : encode_data_b1_r = 'b111111110011	;
				'h167 : encode_data_b1_r = 'b111111110100	;
				'h168 : encode_data_b1_r = 'b111111110101	;
				'h049 : encode_data_b1_r = 'b111111101100	;
				'h04A : encode_data_b1_r = 'b111111101101	;
				'h259 : encode_data_b1_r = 'b1111111111101	;
				'h25A : encode_data_b1_r = 'b1111111111110	;
				'h25F : encode_data_b1_r = 'b1111111111111	;
				'h159 : encode_data_b1_r = 'b1111111111000	;
				'h15A : encode_data_b1_r = 'b1111111111001	;
				'h169 : encode_data_b1_r = 'b1111111111010	;
				'h16A : encode_data_b1_r = 'b1111111111011	;
				'h16F : encode_data_b1_r = 'b1111111111100	;
				default : encode_data_b1_r = 'b0;		
			endcase
		end
		default : encode_data_b1_r = 'b0;
	endcase
end
/**************************************************************************/

endmodule
