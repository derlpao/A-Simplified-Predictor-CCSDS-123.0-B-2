module encode_top#(
    parameter                           ZERO_NUM_MAN            = 16,
    parameter                           CODEBOOK_LENGTH_MAX     = 64,
    parameter                           CODE_DATALENGTH         = 20,      
    parameter                           ENCODE_DATALENGTH       = CODE_DATALENGTH + ZERO_NUM_MAN + 17+1  //7_16ÐÞ¸Ä
)(
    input                               clk_i                       ,
    input                               rst_i                       ,

    input                               en_i                        ,
    input   [3 : 0]                     index_i                     ,
    input   [16: 0]                     delta_i                     ,//7_15ÐÞ¸ÄÎ»17bit
    input                               last_i                      ,
    
    output [3:0]                        index_now_o                 ,
    output                              encode_match_o              ,
    output [5 : 0]                      encode_match_length_o       ,
    output [ENCODE_DATALENGTH - 1 : 0]  encode_match_data_o         
);

wire                                    ap_empty_w;
wire                                    codebook_residual_valid_w;

reg     [3:0]                           index_now_r;
reg     [3:0]                           index_now_d_r;
reg     [3:0]                           index_now_rp ;
reg     [3:0]                           index_now_rpp;
reg     [3:0]                           delta_max_r;
reg                                     en_x_r;
reg     [3:0]                           residual_r;
// reg     [15:0]                          delta_r;
reg                                     en_d_r;
reg                                     en_d_r2;
reg                                     empty_flag_r;
reg                                     ap_empty_exist_r;
integer                                 file_index_now_r;
assign codebook_residual_valid_w = en_i && (index_now_r != 'hf);//en_d_r

assign index_now_o = index_now_rpp;
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        en_d_r <= 'd0;
        en_d_r2<= 'd0;
    end else begin
        en_d_r <= en_i;
        en_d_r2<= en_d_r;
    end
end
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        index_now_rp <= 'd0;
    end else if(en_i) begin
        index_now_rp <= index_now_r;
    end
end
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        index_now_rpp <= 'd0;
    end else if(en_d_r) begin
        index_now_rpp <= index_now_rp;
    end
end
// always @(posedge clk_i or posedge rst_i) begin
//     if (rst_i) begin
//         delta_r <= 'd0;
//     end else begin
//         delta_r <= delta_i;
//     end
// end

// always @(posedge clk_i or posedge rst_i) begin
//     if (rst_i) begin
//         empty_flag_r <= 'd1;
//     end else if (en_i && empty_flag_r && index_i != 'hf) begin
//         empty_flag_r <= 'd0;
//     end else if (ap_empty_w) begin
//         empty_flag_r <= 'd1;
//     end else begin
//         empty_flag_r <= empty_flag_r;
//     end
// end

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        ap_empty_exist_r <= 'd1;
    end else if (en_i && empty_flag_r && index_i != 'hf) begin
        ap_empty_exist_r <= 'd0;
    end else if (ap_empty_w) begin
        ap_empty_exist_r <= 'd1;
    end else begin
        ap_empty_exist_r <= ap_empty_exist_r;
    end
end

always @(*) begin
    empty_flag_r = ap_empty_w | ap_empty_exist_r;
end


// always @(posedge clk_i or posedge rst_i) begin
//     if (rst_i) begin
//         index_now_r <= 'hf;
//     end else if (en_i && empty_flag_r) begin
//         index_now_r <= index_i;
//     end else begin
//         index_now_r <= index_now_r;
//     end
// end

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        index_now_d_r <= 'd0;
    end else if(en_i) begin
        index_now_d_r <= index_now_r;
    end
end

always @(*) begin
    index_now_r = en_i && empty_flag_r ? index_i : index_now_d_r;
end

always @(*) begin
    case(index_now_r)
        4'd0 : begin
            delta_max_r <= 'd12;
            if (delta_i <= 'd12) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd1 : begin
            delta_max_r <= 'd10;
            if (delta_i <= 'd10) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd2 : begin
            delta_max_r <= 'd8;
            if (delta_i <= 'd8) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd3 : begin
            delta_max_r <= 'd6;
            if (delta_i <= 'd6) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd4 : begin
            delta_max_r <= 'd6;
            if (delta_i <= 'd6) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd5 : begin
            delta_max_r <= 'd4;
            if (delta_i <= 'd4) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd6 : begin
            delta_max_r <= 'd4;
            if (delta_i <= 'd4) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd7 : begin
            delta_max_r <= 'd4;
            if (delta_i <= 'd4) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd8 : begin
            delta_max_r <= 'd2;
            if (delta_i <= 'd2) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd9 : begin
            delta_max_r <= 'd2;
            if (delta_i <= 'd2) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd10 : begin
            delta_max_r <= 'd2;
            if (delta_i <= 'd2) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        4'd11 : begin
            delta_max_r <= 'd2;
            if (delta_i <= 'd2) begin
                residual_r <= delta_i[3:0];
                en_x_r <= 'd0;
            end else begin
                residual_r <= 4'hf;
                en_x_r <= 'd1;
            end
        end
        default : begin
            delta_max_r <= 'd0;
            residual_r <= 'h0;
            en_x_r <= 'd0;
        end
    endcase
end
// always @(posedge clk_i) begin
    // if (en_i == 1'b1) begin
        // file_index_now_r = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/index_now_r.txt", "a"); 
        // if (file_index_now_r != 0 ) begin
            // $fwrite(file_index_now_r, "%h\n", index_now_r);
            // $fclose(file_index_now_r);
        // end
    // end
// end
encode #(
    .ZERO_NUM_MAN               (ZERO_NUM_MAN               ),
    .CODEBOOK_LENGTH_MAX        (CODEBOOK_LENGTH_MAX        ),
    .CODE_DATALENGTH            (CODE_DATALENGTH            ),
    .ENCODE_DATALENGTH          (ENCODE_DATALENGTH          )
) inst_encode (
    .clk_i                      (clk_i                      ),
    .rst_i                      (~rst_i                      ),
    .codebook_index_i           (index_now_r                ),
    .delta_i                    (delta_i                    ),
    .residual_i                 (residual_r                 ),
    .delta_max_i                (delta_max_r                ),
    .en_x_i                     (en_x_r                     ),
    .codebook_residual_valid_i  (codebook_residual_valid_w  ),
    .last_i                     (last_i                     ),
    .ap_empty_o                 (ap_empty_w                 ),
    .encode_match_o             (encode_match_o             ),
    .encode_match_length_o      (encode_match_length_o      ),
    .encode_match_data_o        (encode_match_data_o        )
);


endmodule
