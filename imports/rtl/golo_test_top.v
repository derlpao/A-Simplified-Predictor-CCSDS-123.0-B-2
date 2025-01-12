module golomb_encode #(
        parameter      X_LEN = 11,
        parameter      Y_LEN = 5,
        parameter      Z_LEN = 8,
        parameter      WIDTH = 16
)
(
    input  wire             clk             ,
    input  wire             rst_n           ,

    input  wire [3:0]       k_i             ,
    input  wire [WIDTH:0] data_i            ,//修改为17bit  7.16
    input  wire             golomb_valid_i  , 
    input  wire             en_i            ,
    input  wire [2:0]       mode_i          ,
    input  wire [3:0]       id_ratio_i      ,

    output wire             en_o            ,
    output wire [WIDTH+1:0]   encode_data_o   ,//修改为18bit 17+1=18 7.16
    output wire [6:0]       encode_len_o    ,
    output wire             golomb_valid_o
);
parameter     TEMP_WIDTH  = 64;
    reg                         en_r    ;  
    reg                         en_r2   ;  
    reg                         golomb_valid_r ;
    reg                         golomb_valid_r2;
    reg  [WIDTH:0]            data_r  ; //残差 //WIDTH-1 修改 WIDTH
    reg  [3:0]                  k_r     ; 

    reg  [WIDTH:0]            zero_num_rp     ;//商   //WIDTH-1 修改 WIDTH
    reg  [WIDTH:0]            valid_data_rp   ;//余数  //WIDTH-1 修改 WIDTH
    reg  [WIDTH:0]            valid_data_rpp  ;//余数  //WIDTH-1 修改 WIDTH
    reg  [WIDTH:0]            valid_data_r2   ;//余数  //WIDTH-1 修改 WIDTH
    reg                         over_flow_rp    ;//商大于32个0的标志
    reg  [6:0]                  encoder_len_rpp ;//编出来的码的码长
    reg  [4:0]                  valid_len_rp    ;//k//7_2_gai
    reg  [4:0]                  valid_len_r2    ;//k//7_2_gai
    reg  [6:0]                  encoder_len_r2  ;//编出来的码的码长
    reg  [WIDTH+1:0]            encode_data_r2p ;//哥伦布编出来的码  WIDTH 修改  WIDTH+1

//integer     file_encoder_len_new;
//integer     file_encode_data_new;
      

always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    en_r   <= 1'b0;
    en_r2  <= 1'b0;
    golomb_valid_r <= 1'b0;  
    golomb_valid_r2<= 1'b0;      
  end else begin
    en_r   <= en_i;
    en_r2  <= en_r;
    golomb_valid_r <= golomb_valid_i;
    golomb_valid_r2<= golomb_valid_r;
  end
end
/**************************************regist1******************************************/
always @(posedge clk or negedge rst_n) begin : regist1
  if(rst_n == 1'b0) begin
    data_r <= 'd0;
    k_r    <= 'd0;
  end else if(en_i == 1'b1) begin
    data_r <= data_i;
    k_r    <= k_i;
  end
end

always @(k_r,data_r) begin : get_zero_num_rp
  case (k_r)//WIDTH-1 修改 WIDTH
    4'd0   : zero_num_rp <= data_r;
    4'd1   : zero_num_rp <= {{1{1'b0}},data_r[WIDTH:1]};
    4'd2   : zero_num_rp <= {{2{1'b0}},data_r[WIDTH:2]};
    4'd3   : zero_num_rp <= {{3{1'b0}},data_r[WIDTH:3]};
    4'd4   : zero_num_rp <= {{4{1'b0}},data_r[WIDTH:4]};
    4'd5   : zero_num_rp <= {{5{1'b0}},data_r[WIDTH:5]};
    4'd6   : zero_num_rp <= {{6{1'b0}},data_r[WIDTH:6]};
    4'd7   : zero_num_rp <= {{7{1'b0}},data_r[WIDTH:7]};
    4'd8   : zero_num_rp <= {{8{1'b0}},data_r[WIDTH:8]};
    4'd9   : zero_num_rp <= {{9{1'b0}},data_r[WIDTH:9]};
    4'd10  : zero_num_rp <= {{10{1'b0}},data_r[WIDTH:10]};
    4'd11  : zero_num_rp <= {{11{1'b0}},data_r[WIDTH:11]};
    4'd12  : zero_num_rp <= {{12{1'b0}},data_r[WIDTH:12]};
    4'd13  : zero_num_rp <= {{13{1'b0}},data_r[WIDTH:13]};
    4'd14  : zero_num_rp <= {{14{1'b0}},data_r[WIDTH:14]};
    // 4'd15  : zero_num_rp <= {{15{1'b0}},data_r[WIDTH-1:15]};        
    default: zero_num_rp <= 'd0;
  endcase
end

always @(k_r,data_r) begin : get_valid_data_rp
  case (k_r)
    4'd0   : valid_data_rp <= 'd0;
    4'd1   : valid_data_rp <= {{WIDTH{1'b0}} ,data_r[0]};
    4'd2   : valid_data_rp <= {{WIDTH-1{1'b0}} ,data_r[1:0]};
    4'd3   : valid_data_rp <= {{WIDTH-2{1'b0}} ,data_r[2:0]};
    4'd4   : valid_data_rp <= {{WIDTH-3{1'b0}} ,data_r[3:0]};
    4'd5   : valid_data_rp <= {{WIDTH-4{1'b0}} ,data_r[4:0]};
    4'd6   : valid_data_rp <= {{WIDTH-5{1'b0}} ,data_r[5:0]};
    4'd7   : valid_data_rp <= {{WIDTH-6{1'b0}} ,data_r[6:0]};
    4'd8   : valid_data_rp <= {{WIDTH-7{1'b0}} ,data_r[7:0]};
    4'd9   : valid_data_rp <= {{WIDTH-8{1'b0}} ,data_r[8:0]};
    4'd10  : valid_data_rp <= {{WIDTH-9{1'b0}},data_r[9:0]};
    4'd11  : valid_data_rp <= {{WIDTH-10{1'b0}},data_r[10:0]};
    4'd12  : valid_data_rp <= {{WIDTH-11{1'b0}},data_r[11:0]};
    // 4'd13  : valid_data_rp <= data_r;
    // 4'd14  : valid_data_rp <= data_r;
    // 4'd15  : valid_data_rp <= {{3{1'b0}},data_r[12:0]};
    //zp gai
    4'd13  : valid_data_rp <= {{WIDTH-12{1'b0}},data_r[12:0]};
    4'd14  : valid_data_rp <= {{WIDTH-13{1'b0}},data_r[13:0]};
    4'd15  : valid_data_rp <= data_r;
    // 4'd16  : valid_data_rp <= data_r[15:0];
    default: valid_data_rp <= 'd0;
  endcase
end

always @(zero_num_rp,k_r) begin : get_over_flow_rp_encoder_len_rpp_valid_len_rp
  if(zero_num_rp[WIDTH-1:5] != 'd0) begin
    over_flow_rp    <= 1'b1;
    encoder_len_rpp <= 'd50;//49改50
    valid_len_rp    <= 5'b11111;//32 ,0
  end else begin
    over_flow_rp    <= 1'b0;
    encoder_len_rpp <= k_r + zero_num_rp[5:0] + 1'b1;
    valid_len_rp    <= k_r;
  end
end

always @(over_flow_rp,data_r,valid_data_rp) begin : get_valid_data_rpp
  if(over_flow_rp == 1'b1) begin
    valid_data_rpp <= data_r;
  end else begin
    valid_data_rpp <= valid_data_rp;
  end
end

always @(posedge clk or negedge rst_n) begin : regist2
  if(rst_n == 1'b0) begin
    valid_data_r2    <=  'd0;
    valid_len_r2     <=  'd0;
    encoder_len_r2   <=  'd0;
  end else if(en_r == 1'b1) begin
    valid_data_r2    <= valid_data_rpp;
    valid_len_r2     <= valid_len_rp;
    encoder_len_r2   <= encoder_len_rpp;
  end
end

always @(valid_len_r2,valid_data_r2) begin : get_encode_data_r2p
  case (valid_len_r2)//余数长度
    5'd0   : encode_data_r2p <= {{WIDTH+1{1'b0}} ,1'b1}; //
    5'd1   : encode_data_r2p <= {{WIDTH{1'b0}} ,1'b1,valid_data_r2[0]};
    5'd2   : encode_data_r2p <= {{WIDTH-1{1'b0}} ,1'b1,valid_data_r2[1:0]};
    5'd3   : encode_data_r2p <= {{WIDTH-2{1'b0}} ,1'b1,valid_data_r2[2:0]};
    5'd4   : encode_data_r2p <= {{WIDTH-3{1'b0}} ,1'b1,valid_data_r2[3:0]};
    5'd5   : encode_data_r2p <= {{WIDTH-4{1'b0}} ,1'b1,valid_data_r2[4:0]};
    5'd6   : encode_data_r2p <= {{WIDTH-5{1'b0}} ,1'b1,valid_data_r2[5:0]};
    5'd7   : encode_data_r2p <= {{WIDTH-6{1'b0}} ,1'b1,valid_data_r2[6:0]};
    5'd8   : encode_data_r2p <= {{WIDTH-7{1'b0}} ,1'b1,valid_data_r2[7:0]};
    5'd9   : encode_data_r2p <= {{WIDTH-8{1'b0}} ,1'b1,valid_data_r2[8:0]};
    5'd10  : encode_data_r2p <= {{WIDTH-9{1'b0}},1'b1,valid_data_r2[9:0]};
    5'd11  : encode_data_r2p <= {{WIDTH-10{1'b0}},1'b1,valid_data_r2[10:0]};
    5'd12  : encode_data_r2p <= {{WIDTH-11{1'b0}},1'b1,valid_data_r2[11:0]};//normal
    5'd13  : encode_data_r2p <= {{WIDTH-12{1'b0}},1'b1,valid_data_r2[12:0]};//k=13
   // 4'd14  : encode_data_r2p <= {1'b1,valid_data_r2[15:0]};//(data>>k)>64//7_2_gai
    5'd14  : encode_data_r2p <= {{WIDTH-13{1'b0}},1'b1,valid_data_r2[13:0]};//(data>>k)>64//7_2_gai
    5'd15  : encode_data_r2p <= {1'b0,valid_data_r2};//frst1、2
    5'd31  : encode_data_r2p <= {1'b1,valid_data_r2[16:0]};//(data>>k)>64//7_2_gai 
    default: encode_data_r2p <= 'd0;
  endcase
end

// always @(posedge clk) begin
    // if (en_r2 == 1'b1) begin
        // file_encoder_len_new = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/encoder_len_new.txt", "a"); 
        // if (file_encoder_len_new != 0 ) begin
            // $fwrite(file_encoder_len_new, "%h\n", encoder_len_r2);
            // $fclose(file_encoder_len_new);
        // end
    // end
// end
// always @(posedge clk) begin
    // if (en_r2 == 1'b1) begin
        // file_encode_data_new = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/encode_data_new.txt", "a"); 
        // if (file_encode_data_new != 0 ) begin
            // $fwrite(file_encode_data_new, "%05h\n", encode_data_r2p);
            // $fclose(file_encode_data_new);
        // end
    // end
// end
assign encode_data_o = encode_data_r2p;
assign encode_len_o  = encoder_len_r2;
assign en_o          = en_r2;
assign golomb_valid_o= golomb_valid_r2;
endmodule
