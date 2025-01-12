module codebook_select_f#(
	parameter										CODEBOOK_LENGTH_MAX	= 64,
    parameter										ENCODE_DATALENGTH	= 21
)(
    input   wire                                	clk_i           		,
    input   wire                                	rst_i           		,
    input	wire	[3 : 0]							codebook_select_i		,        
    input	wire	[5 : 0]							ap_cnt_i				,
	input	wire	[CODEBOOK_LENGTH_MAX - 1 : 0]	ap_data_i				,

    output	wire                                    encode_match_o          ,
    output	wire    [5 : 0]                         encode_match_length_o   ,
    output	wire    [ENCODE_DATALENGTH - 1 : 0]     encode_match_data_o     
);

reg										encode_match_r		;
reg		[5 : 0]							encode_length_r		;
reg		[ENCODE_DATALENGTH - 1 : 0]		encode_data_r		;


wire									encode_match_b0_w	;
wire	[5 : 0]							encode_length_b0_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b0_w	;

wire									encode_match_b1_w	;
wire	[5 : 0]							encode_length_b1_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b1_w	;

wire									encode_match_b2_w	;
wire	[5 : 0]							encode_length_b2_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b2_w	;

wire									encode_match_b3_w	;
wire	[5 : 0]							encode_length_b3_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b3_w	;

wire									encode_match_b4_w	;
wire	[5 : 0]							encode_length_b4_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b4_w	;

wire									encode_match_b5_w	;
wire	[5 : 0]							encode_length_b5_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b5_w	;

wire									encode_match_b6_w	;
wire	[5 : 0]							encode_length_b6_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b6_w	;

wire									encode_match_b7_w	;
wire	[5 : 0]							encode_length_b7_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b7_w	;

wire									encode_match_b8_w	;
wire	[5 : 0]							encode_length_b8_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b8_w	;

wire									encode_match_b9_w	;
wire	[5 : 0]							encode_length_b9_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b9_w	;

wire									encode_match_b10_w	;
wire	[5 : 0]							encode_length_b10_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b10_w	;

wire									encode_match_b11_w	;
wire	[5 : 0]							encode_length_b11_w	;
wire	[ENCODE_DATALENGTH - 1 : 0]		encode_data_b11_w	;

assign encode_match_o			= encode_match_r		;
assign encode_match_length_o	= encode_length_r		;
assign encode_match_data_o 		= encode_data_r			;


always @(*) begin
	case(codebook_select_i)
		4'd0  : begin
			encode_match_r	<= encode_match_b0_w		;
			encode_length_r	<= encode_length_b0_w	;
			encode_data_r	<= encode_data_b0_w		;
		end
		4'd1  : begin
			encode_match_r	<= encode_match_b1_w		;
			encode_length_r	<= encode_length_b1_w	;
			encode_data_r	<= encode_data_b1_w		;			
		end
		4'd2  : begin
			encode_match_r	<= encode_match_b2_w		;
			encode_length_r	<= encode_length_b2_w	;
			encode_data_r	<= encode_data_b2_w		;			
		end
		4'd3  : begin
			encode_match_r	<= encode_match_b3_w		;
			encode_length_r	<= encode_length_b3_w	;
			encode_data_r	<= encode_data_b3_w		;			
		end
		4'd4  : begin
			encode_match_r	<= encode_match_b4_w		;
			encode_length_r	<= encode_length_b4_w	;
			encode_data_r	<= encode_data_b4_w		;			
		end
		4'd5  : begin
			encode_match_r	<= encode_match_b5_w		;
			encode_length_r	<= encode_length_b5_w	;
			encode_data_r	<= encode_data_b5_w		;			
		end
		4'd6  : begin
			encode_match_r	<= encode_match_b6_w		;
			encode_length_r	<= encode_length_b6_w	;
			encode_data_r	<= encode_data_b6_w		;			
		end
		4'd7  : begin
			encode_match_r	<= encode_match_b7_w		;
			encode_length_r	<= encode_length_b7_w	;
			encode_data_r	<= encode_data_b7_w		;			
		end
		4'd8  : begin
			encode_match_r	<= encode_match_b8_w		;
			encode_length_r	<= encode_length_b8_w	;
			encode_data_r	<= encode_data_b8_w		;			
		end
		4'd9  : begin
			encode_match_r	<= encode_match_b9_w		;
			encode_length_r	<= encode_length_b9_w	;
			encode_data_r	<= encode_data_b9_w		;			
		end
		4'd10 : begin
			encode_match_r	<= encode_match_b10_w	;
			encode_length_r	<= encode_length_b10_w	;
			encode_data_r	<= encode_data_b10_w		;			
		end
		4'd11 : begin
			encode_match_r	<= encode_match_b11_w	;
			encode_length_r	<= encode_length_b11_w	;
			encode_data_r	<= encode_data_b11_w		;			
		end
		default : begin
			encode_match_r	<= 'd0;
			encode_length_r	<= 'd0;
			encode_data_r	<= 'd0;
		end
	endcase
end


codebook_b0_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b0 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b0_w		),
	.encode_length_o   		(encode_length_b0_w		),
	.encode_data_o     		(encode_data_b0_w		)
);

codebook_b1_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b1 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b1_w		),
	.encode_length_o   		(encode_length_b1_w		),
	.encode_data_o     		(encode_data_b1_w		)
);

codebook_b2_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b2 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b2_w		),
	.encode_length_o   		(encode_length_b2_w		),
	.encode_data_o     		(encode_data_b2_w		)
);

codebook_b3_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b3 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b3_w		),
	.encode_length_o   		(encode_length_b3_w		),
	.encode_data_o     		(encode_data_b3_w		)
);

codebook_b4_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b4 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b4_w		),
	.encode_length_o   		(encode_length_b4_w		),
	.encode_data_o     		(encode_data_b4_w		)
);

codebook_b5_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b5 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b5_w		),
	.encode_length_o   		(encode_length_b5_w		),
	.encode_data_o     		(encode_data_b5_w		)
);

codebook_b6_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b6 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b6_w		),
	.encode_length_o   		(encode_length_b6_w		),
	.encode_data_o     		(encode_data_b6_w		)
);

codebook_b7_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b7 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b7_w		),
	.encode_length_o   		(encode_length_b7_w		),
	.encode_data_o     		(encode_data_b7_w		)
);

codebook_b8_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b8 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b8_w		),
	.encode_length_o   		(encode_length_b8_w		),
	.encode_data_o     		(encode_data_b8_w		)
);

codebook_b9_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b9 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b9_w		),
	.encode_length_o   		(encode_length_b9_w		),
	.encode_data_o     		(encode_data_b9_w		)
);

codebook_b10_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b10 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b10_w		),
	.encode_length_o   		(encode_length_b10_w	),
	.encode_data_o     		(encode_data_b10_w		)
);

codebook_b11_f #(
	.CODEBOOK_LENGTH_MAX	(CODEBOOK_LENGTH_MAX	),
	.ENCODE_DATALENGTH		(ENCODE_DATALENGTH		)
) inst_codebook_b11 (
	//.codebook_select_i 		(codebook_select_i),
	.ap_cnt_i          		(ap_cnt_i				),
	.ap_data_i         		(ap_data_i				),
	.encode_match_o    		(encode_match_b11_w		),
	.encode_length_o   		(encode_length_b11_w	),
	.encode_data_o     		(encode_data_b11_w		)
);

endmodule
