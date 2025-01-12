module encode#(
    parameter                           ZERO_NUM_MAN            = 16,
    parameter                           CODEBOOK_LENGTH_MAX     = 64,
    parameter                           CODE_DATALENGTH         = 20,      
    parameter                           ENCODE_DATALENGTH       = CODE_DATALENGTH + ZERO_NUM_MAN + 17+1 //7_16修改
)(
    input                               clk_i                       ,
    input                               rst_i                       ,
    input   [3 : 0]                     codebook_index_i            ,
    input   [16: 0]                     delta_i                     ,//位宽修改
    input   [3 : 0]                     residual_i                  ,
    input   [3 : 0]                     delta_max_i                 ,
    input                               en_x_i                      ,
    input                               codebook_residual_valid_i   ,
    input                               last_i                      ,                       

    output                              ap_empty_o                  ,
    output                              encode_match_o              ,
    output [5 : 0]                      encode_match_length_o       ,
    output [ENCODE_DATALENGTH - 1 : 0]  encode_match_data_o         
);

reg     [3 : 0]                         codebook_index_r;
reg     [5 : 0]                         ap_cnt_r    ;
reg     [CODEBOOK_LENGTH_MAX - 1 : 0]   ap_data_r   ;
reg                                     last_r      ;

reg     [16: 0]                         delta_r     ;//位宽修改
reg     [3 : 0]                         delta_max_r ;
reg    [15: 0]                          R0_w        ; //0的个数

reg                                     en_x_r      ;

reg                                     encode_match_r;
(*keep="true"*)reg     [5 : 0]                         encode_match_length_r;
(*keep="true"*)reg     [ENCODE_DATALENGTH - 1 : 0]     encode_match_data_r;
reg                                     encode_match_d_r;
reg     [5 : 0]                         encode_match_length_d_r;
reg     [ENCODE_DATALENGTH - 1 : 0]     encode_match_data_d_r;
// reg                                     last_f_flag_r;
wire                                    match_w;
wire    [5 : 0]                         match_length_w;
wire    [CODE_DATALENGTH - 1 : 0]       match_data_w;

wire    [4: 0]                          zero_num_w  ;

reg     [5 : 0]                         ap_cnt_f_r    ;
reg     [CODEBOOK_LENGTH_MAX - 1 : 0]   ap_data_f_r   ;

wire                                    match_f_w;
wire    [5 : 0]                         match_length_f_w;
wire    [CODE_DATALENGTH - 1 : 0]       match_data_f_w;

assign  ap_empty_o              =   match_w | match_f_w;
assign  encode_match_o          =   encode_match_d_r;
assign  encode_match_length_o   =   encode_match_length_d_r;
assign  encode_match_data_o     =   encode_match_data_d_r;

//assign  R0_w = delta_r - delta_max_r - 1;
// assign  R0_w = delta_r > delta_max_r ? delta_r - delta_max_r - 1 : 0;
//assign  zero_num_w = (R0_w >= ZERO_NUM_MAN) ? ZERO_NUM_MAN : R0_w[4:0];

always @(posedge clk_i or negedge rst_i) begin
    if (rst_i == 1'b0) begin
        codebook_index_r <= 'd0;
        last_r <= 'd0;
        en_x_r <= 'd0;
    end else begin
        codebook_index_r <= codebook_index_i;
        last_r <= last_i;
        en_x_r <= en_x_i;
    end

end

always @(posedge clk_i or negedge rst_i) begin
    if (rst_i == 1'b0) begin
        delta_r <= 'd0;
        delta_max_r <= 'd0;
        R0_w <=16'd0;
    end else if (en_x_i || last_i) begin
        delta_r <= delta_i;
        delta_max_r <= delta_max_i;
        R0_w = delta_i - delta_max_i - 1;
    end else begin
        delta_r <= delta_r;
        delta_max_r <= delta_max_r;
        R0_w<=R0_w;
    end
end
(*keep="true"*) reg [5:0] ext_cnt;

always @(*) begin
    if(R0_w >= 16'd16) begin
            if (en_x_r ) begin
                encode_match_r          <= match_w;
                encode_match_length_r   <= match_length_w + 'd34;//低熵长度加1
                encode_match_data_r     <= {match_data_w[19:0], 17'd1, delta_r[16:0]};//修改长度7.16
                ext_cnt                 <= 6'd1;
                // encode_match_data_r     = ((match_data_w << (zero_num_w+16+1)) | (delta_r << 1)) + 'd1;
            end else if (last_r && !match_w && (delta_r <= delta_max_r)) begin
                encode_match_r          <= match_f_w;
                encode_match_length_r   <= match_length_f_w;
                encode_match_data_r     <= match_data_f_w;  
                ext_cnt                 <= 6'd2;      
            end else if (last_r && !match_w) begin
                encode_match_r          <= match_f_w;
                encode_match_length_r   <= match_length_f_w + 5'd17;
                encode_match_data_r     <= (match_data_f_w << ('d17)) + 'd1;
                ext_cnt                 <= 6'd3;
            end else begin
                encode_match_r          <= match_w;
                encode_match_length_r   <= match_length_w;
                encode_match_data_r     <= match_data_w;
                ext_cnt                 <= 6'd4;
            end
    end 
    else begin

            if (en_x_r) begin
                encode_match_r          <= match_w;
                encode_match_length_r   <= match_length_w + R0_w[4:0] + 'd1;
				if(R0_w==16'd0)begin
					encode_match_data_r     <= (match_data_w << 1) + 'd1;
				end
				else if(R0_w==16'd1)begin
					encode_match_data_r     <= (match_data_w << 2) + 'd1;
				end
				else if(R0_w==16'd2)begin
					encode_match_data_r     <= (match_data_w << 3) + 'd1;
				end
				else if(R0_w==16'd3)begin
					encode_match_data_r     <= (match_data_w << 4) + 'd1;
				end
				else if(R0_w==16'd4)begin
					encode_match_data_r     <= (match_data_w << 5) + 'd1;
				end
				else if(R0_w==16'd5)begin
					encode_match_data_r     <= (match_data_w << 6) + 'd1;
				end
				else if(R0_w==16'd6)begin
					encode_match_data_r     <= (match_data_w << 7) + 'd1;
				end
				else if(R0_w==16'd7)begin
					encode_match_data_r     <= (match_data_w << 8) + 'd1;
				end
				else if(R0_w==16'd8)begin
					encode_match_data_r     <= (match_data_w << 9) + 'd1;
				end
				else if(R0_w==16'd9)begin
					encode_match_data_r     <= (match_data_w << 10) + 'd1;
				end
				else if(R0_w==16'd10)begin
					encode_match_data_r     <= (match_data_w << 11) + 'd1;
				end
				else if(R0_w==16'd11)begin
					encode_match_data_r     <= (match_data_w << 12) + 'd1;
				end
				else if(R0_w==16'd12)begin
					encode_match_data_r     <= (match_data_w << 13) + 'd1;
				end
				else if(R0_w==16'd13)begin
					encode_match_data_r     <= (match_data_w << 14) + 'd1;
				end
				else if(R0_w==16'd14)begin
					encode_match_data_r     <= (match_data_w << 15) + 'd1;
				end
				else begin
					encode_match_data_r     <= (match_data_w << 16) + 'd1;
				end
		    // case(R0_w)//閲忓寲
            // 16'd0    :    encode_match_data_r     <= (match_data_w << 1) + 'd1;
            // 16'd1    :    encode_match_data_r     <= (match_data_w << 2) + 'd1;
            // 16'd2    :    encode_match_data_r     <= (match_data_w << 3) + 'd1;
            // 16'd3    :    encode_match_data_r     <= (match_data_w << 4) + 'd1;
            // 16'd4    :    encode_match_data_r     <= (match_data_w << 5) + 'd1;
            // 16'd5    :    encode_match_data_r     <= (match_data_w << 6) + 'd1;
            // 16'd6    :    encode_match_data_r     <= (match_data_w << 7) + 'd1;
            // 16'd7    :    encode_match_data_r     <= (match_data_w << 8) + 'd1;
            // 16'd8    :    encode_match_data_r     <= (match_data_w << 9) + 'd1;
            // 16'd9    :    encode_match_data_r     <= (match_data_w << 10) + 'd1;
            // 16'd10   :    encode_match_data_r     <= (match_data_w << 11) + 'd1;
            // 16'd11   :    encode_match_data_r     <= (match_data_w << 12) + 'd1;
            // 16'd12   :    encode_match_data_r     <= (match_data_w << 13) + 'd1;
            // 16'd13   :    encode_match_data_r     <= (match_data_w << 14) + 'd1;
            // 16'd14   :    encode_match_data_r     <= (match_data_w << 15) + 'd1;
            // 16'd15   :    encode_match_data_r     <= (match_data_w << 16) + 'd1;
			// default  :    encode_match_data_r     <= 'd0;
			// endcase 
		
               // encode_match_data_r     <= (match_data_w << (R0_w[4:0]+1)) + 'd1;
                ext_cnt                 <= 6'd5;
            end else if (last_r && !match_w && (delta_r <= delta_max_r)) begin
                encode_match_r          <= match_f_w;
                encode_match_length_r   <= match_length_f_w;
                encode_match_data_r     <= match_data_f_w;  
                ext_cnt                 <= 6'd6;      
            end else if (last_r && !match_w) begin
                encode_match_r          <= match_f_w;
                encode_match_length_r   <= match_length_f_w + R0_w[4:0] + 'd1;
				if(R0_w==16'd0)begin
					encode_match_data_r     <= (match_data_w << 1) + 'd1;
				end
				else if(R0_w==16'd1)begin
					encode_match_data_r     <= (match_data_w << 2) + 'd1;
				end
				else if(R0_w==16'd2)begin
					encode_match_data_r     <= (match_data_w << 3) + 'd1;
				end
				else if(R0_w==16'd3)begin
					encode_match_data_r     <= (match_data_w << 4) + 'd1;
				end
				else if(R0_w==16'd4)begin
					encode_match_data_r     <= (match_data_w << 5) + 'd1;
				end
				else if(R0_w==16'd5)begin
					encode_match_data_r     <= (match_data_w << 6) + 'd1;
				end
				else if(R0_w==16'd6)begin
					encode_match_data_r     <= (match_data_w << 7) + 'd1;
				end
				else if(R0_w==16'd7)begin
					encode_match_data_r     <= (match_data_w << 8) + 'd1;
				end
				else if(R0_w==16'd8)begin
					encode_match_data_r     <= (match_data_w << 9) + 'd1;
				end
				else if(R0_w==16'd9)begin
					encode_match_data_r     <= (match_data_w << 10) + 'd1;
				end
				else if(R0_w==16'd10)begin
					encode_match_data_r     <= (match_data_w << 11) + 'd1;
				end
				else if(R0_w==16'd11)begin
					encode_match_data_r     <= (match_data_w << 12) + 'd1;
				end
				else if(R0_w==16'd12)begin
					encode_match_data_r     <= (match_data_w << 13) + 'd1;
				end
				else if(R0_w==16'd13)begin
					encode_match_data_r     <= (match_data_w << 14) + 'd1;
				end
				else if(R0_w==16'd14)begin
					encode_match_data_r     <= (match_data_w << 15) + 'd1;
				end
				else begin
					encode_match_data_r     <= (match_data_w << 16) + 'd1;
				end
				// case(R0_w)//閲忓寲
				// 16'd0   :    encode_match_data_r     <= (match_data_w << 1) + 'd1;
				// 16'd1   :    encode_match_data_r     <= (match_data_w << 2) + 'd1;
				// 16'd2   :    encode_match_data_r     <= (match_data_w << 3) + 'd1;
				// 16'd3   :    encode_match_data_r     <= (match_data_w << 4) + 'd1;
				// 16'd4   :    encode_match_data_r     <= (match_data_w << 5) + 'd1;
				// 16'd5   :    encode_match_data_r     <= (match_data_w << 6) + 'd1;
				// 16'd6   :    encode_match_data_r     <= (match_data_w << 7) + 'd1;
				// 16'd7   :    encode_match_data_r     <= (match_data_w << 8) + 'd1;
				// 16'd8   :    encode_match_data_r     <= (match_data_w << 9) + 'd1;
				// 16'd9   :    encode_match_data_r     <= (match_data_w << 10) + 'd1;
				// 16'd10  :    encode_match_data_r     <= (match_data_w << 11) + 'd1;
				// 16'd11  :    encode_match_data_r     <= (match_data_w << 12) + 'd1;
				// 16'd12  :    encode_match_data_r     <= (match_data_w << 13) + 'd1;
				// 16'd13  :    encode_match_data_r     <= (match_data_w << 14) + 'd1;
				// 16'd14  :    encode_match_data_r     <= (match_data_w << 15) + 'd1;
				// 16'd15  :    encode_match_data_r     <= (match_data_w << 16) + 'd1;
				// default:     encode_match_data_r     <= 'd0;
				// endcase 
                //encode_match_data_r     <= (match_data_f_w << (R0_w[4:0]+1)) + 'd1;
                ext_cnt                 <= 6'd7;
            end else begin
                encode_match_r          <= match_w;
                encode_match_length_r   <= match_length_w;
                encode_match_data_r     <= match_data_w;
                ext_cnt                 <= 6'd8;
            end
        
    end
end

always @(posedge clk_i or negedge rst_i) begin
    if (rst_i == 1'b0) begin
        encode_match_d_r        <= 'd0;
        encode_match_length_d_r <= 'd0;
        encode_match_data_d_r   <= 'd0;
    end else begin
        encode_match_d_r        <= encode_match_r;
        encode_match_length_d_r <= encode_match_length_r;
        encode_match_data_d_r   <= encode_match_data_r;
    end
end


// always @(posedge clk_i or posedge rst_i) begin
//     if (rst_i) begin
//         last_f_flag_r <= 'd0;
//     end else if (last_r && !match_w) begin
//         last_f_flag_r <= 'd1;
//     end else begin
//         last_f_flag_r <= 'd0;
//     end
// end

always @(posedge clk_i or negedge rst_i) begin
    if (rst_i == 1'b0) begin
        ap_cnt_r <= 'd0;
    end else if (codebook_residual_valid_i && (match_w || match_f_w || last_r)) begin
        ap_cnt_r <= 'd1;    //输出一个编码的同时，又来了新的请求
    end else if (match_w || last_r) begin
        ap_cnt_r <= 'd0;
    // end else if (last_r && !match_w) begin
    //     ap_cnt_r <= ap_cnt_r + 'd1;        
    end else if (codebook_residual_valid_i) begin
        ap_cnt_r <= ap_cnt_r + 'd1;
    end else begin
        ap_cnt_r <= ap_cnt_r;
    end
end

always @(posedge clk_i or negedge rst_i) begin
    if (rst_i == 1'b0) begin
        ap_data_r <= 'd0;
    end else if (codebook_residual_valid_i && (match_w || match_f_w || last_r)) begin
        ap_data_r <= residual_i[3:0];   //输出一个编码的同时，又来了新的请求
    end else if (match_w || last_r) begin
        ap_data_r <= 'd0;
    // end else if (last_r && !match_w) begin
    //     ap_data_r <= {ap_data_r[CODEBOOK_LENGTH_MAX-5:0], 4'hf};
    end else if (codebook_residual_valid_i) begin
        ap_data_r <= {ap_data_r[CODEBOOK_LENGTH_MAX-5:0], residual_i[3:0]};
    end else begin
        ap_data_r <= ap_data_r;
    end
end

codebook_select #(
    .CODEBOOK_LENGTH_MAX   (CODEBOOK_LENGTH_MAX),
    .ENCODE_DATALENGTH     (CODE_DATALENGTH)
) inst_codebook_select (
    .clk_i                 (clk_i              ),
    .rst_i                 (rst_i              ),
    .codebook_select_i     (codebook_index_r   ),
    .ap_cnt_i              (ap_cnt_r           ),
    .ap_data_i             (ap_data_r          ),
    .encode_match_o        (match_w            ),
    .encode_match_length_o (match_length_w     ),
    .encode_match_data_o   (match_data_w       )
);





always @(posedge clk_i or negedge rst_i) begin
    if (rst_i == 1'b0) begin
        ap_cnt_f_r <= 'd0;
    end else if (codebook_residual_valid_i && last_i && match_w) begin
        ap_cnt_f_r <= 'd2;
    end else if (codebook_residual_valid_i && last_i) begin
        ap_cnt_f_r <= ap_cnt_r + 'd2;
    end else begin
        ap_cnt_f_r <= 'd0;
    end
end

always @(posedge clk_i or negedge rst_i) begin
    if (rst_i == 1'b0) begin
        ap_data_f_r <= 'd0;
    end else if (codebook_residual_valid_i && last_i && match_w) begin
        ap_data_f_r <= {residual_i[3:0], 4'hf};
    end else if (codebook_residual_valid_i && last_i) begin
        ap_data_f_r <= {ap_data_r[CODEBOOK_LENGTH_MAX-9:0], residual_i[3:0], 4'hf};
    end else begin
        ap_data_f_r <= 'd0;
    end
end

codebook_select_f #(
    .CODEBOOK_LENGTH_MAX   (CODEBOOK_LENGTH_MAX),
    .ENCODE_DATALENGTH     (CODE_DATALENGTH)
) inst_codebook_select_f (
    .clk_i                 (clk_i              ),
    .rst_i                 (rst_i              ),
    .codebook_select_i     (codebook_index_r   ),
    .ap_cnt_i              (ap_cnt_f_r           ),
    .ap_data_i             (ap_data_f_r          ),
    .encode_match_o        (match_f_w            ),
    .encode_match_length_o (match_length_f_w     ),
    .encode_match_data_o   (match_data_f_w       )
);

endmodule
