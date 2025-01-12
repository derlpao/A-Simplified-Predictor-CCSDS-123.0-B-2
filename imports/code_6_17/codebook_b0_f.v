`timescale 1ns/1ps

module codebook_b0_f#(
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
				'hF : encode_match_b0_r = 1'd1;
				default : encode_match_b0_r = 1'd0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h0F, 'h4F, 'h7F, 'h8F : encode_match_b0_r = 1'd1;
				default : encode_match_b0_r = 1'd0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h01F, 'h02F, 'h44F : encode_match_b0_r = 1'd1;
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
				'hF :	encode_length_b0_r = 5;
				default : encode_length_b0_r = 0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h0F, 'h4F : encode_length_b0_r = 8;
				'h7F, 'h8F : encode_length_b0_r = 10;
				default : encode_length_b0_r = 0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h01F, 'h02F: encode_length_b0_r = 11;
				'h44F :	encode_length_b0_r = 12;
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
				'hF : encode_data_b0_r = 'b10010;
				default : encode_data_b0_r = 'b0;
			endcase
		end
		6'd2 : begin
			case(ap_data_i)
				'h0F : encode_data_b0_r = 'b11011110;

				'h4F : encode_data_b0_r = 'b11100001;

				'h7F : encode_data_b0_r = 'b1111101100;

				'h8F : encode_data_b0_r = 'b1111101111;
				default : encode_data_b0_r = 'b0;
			endcase
		end
		6'd3 : begin
			case(ap_data_i)
				'h01F : encode_data_b0_r =	'b11111110110;
				
				'h02F : encode_data_b0_r =	'b11111111001;
				
				'h44F : encode_data_b0_r =	'b111111111110;
				default : encode_data_b0_r = 'b0;
			endcase
		end
		default : encode_data_b0_r = 'b0;
	endcase
end
/**************************************************************************/

endmodule
