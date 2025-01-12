`timescale 1ns/1ps

module codebook_b1_f#(
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
				'hF : encode_match_b1_r = 1'd1;
				default	: encode_match_b1_r = 1'd0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h0F,'h2F,'h1F,'hAF : encode_match_b1_r = 1'd1;
				default	: encode_match_b1_r = 1'd0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h00F,'h03F,'h04F,
				'h23F,'h13F,'h15F,'h25F,'h16F : encode_match_b1_r = 1'd1;
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
				'hF : encode_length_b1_r = 6;
				default : encode_length_b1_r = 0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
			'h0F : encode_length_b1_r = 8;
			'h2F,'h1F : encode_length_b1_r = 9;
			'hAF : encode_length_b1_r = 12;
			default : encode_length_b1_r = 0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h00F,'h03F,'h04F : encode_length_b1_r = 11;
				'h23F,'h13F,'h15F : encode_length_b1_r = 12;
				'h25F,'h16F : 		encode_length_b1_r = 13;
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
				'hF : encode_data_b1_r = 'b101101			;
				default : encode_data_b1_r = 'b0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h0F : encode_data_b1_r = 'b11010100		;
				
				'h2F : encode_data_b1_r = 'b111010101		;
				
				'h1F : encode_data_b1_r = 'b111010010		;
				
				'hAF : encode_data_b1_r = 'b111111101001	;
				default : encode_data_b1_r = 'b0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h00F : encode_data_b1_r = 'b11111100101	;

				'h03F : encode_data_b1_r = 'b11111100111	;

				'h04F : encode_data_b1_r = 'b11111101010	;

				'h23F : encode_data_b1_r = 'b111111111000	;

				'h13F : encode_data_b1_r = 'b111111110000	;

				'h15F : encode_data_b1_r = 'b111111110011	;

				'h25F : encode_data_b1_r = 'b1111111111111	;

				'h16F : encode_data_b1_r = 'b1111111111100	;
				default : encode_data_b1_r = 'b0;		
			endcase
		end
		default : encode_data_b1_r = 'b0;
	endcase
end
/**************************************************************************/

endmodule
