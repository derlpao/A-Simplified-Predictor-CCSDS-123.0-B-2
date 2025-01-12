module cal_alpha #(
    parameter     W_WIDTH    = 12+2+1+16,//dn_width+16 //31
    parameter     D_WIDTH    = 12+2+1, //15
    parameter     DATA_WIDTH = 12,
    parameter     OHM        = 12,
    parameter     tx_type = 0
)
(
  input  wire                             clk,
  input  wire                             rst_n,
  
  input  wire [2:0]                       mode_i,
  input  wire                             en_i,
  // input  wire [W_WIDTH+D_WIDTH+3-OHM-1:0] vec_crt_sl_ohm_i,
  input  wire [DATA_WIDTH-1:0]            S_i,//鐪熷疄鍍忕礌
  input  wire [DATA_WIDTH+2-1:0]          delta_i,
  // input  wire                             uof_i,
  // input  wire                             dof_i,
  input  wire  [2:0]                       up_mode_i,
  input  wire                              en_upmode_i,
  input  wire                             en_block_cnt_i,
  input  wire [3:0]                       id_ratio_i,
/////////////////5_18zp///////////////////  
  input  wire [W_WIDTH+D_WIDTH+3-1:0]     vec1_i,
  input  wire [W_WIDTH+D_WIDTH+3-1:0]     vec2_i,
  input  wire [W_WIDTH+D_WIDTH+3-1:0]     vec3_i,
  input  wire                             spec_fst_i,  
  input  wire                             en_fst_blo_i,
    
  // output wire [DATA_WIDTH+1-1:0]          S_o,
  // output wire [DATA_WIDTH+1-1:0]          alpha_o,
  output wire [2:0]                       sgn_img_o,
  output wire                             en_o,
  //output wire                             en_cj_o,
  //output wire [DATA_WIDTH+1-1:0]          cj_S_o,
  //output wire [5:0]                       quant_near_o //写入包头的near
  
  output wire [DATA_WIDTH-1:0]           S_o                ,
  output wire [7:0]                      quant_near_o       ,
  output wire [DATA_WIDTH-1:0]           alpha_o          ,//16
  output wire [2:0]                      sgn_img_r_o        ,
  output wire                            sgn_alpha_o        ,
  output wire [DATA_WIDTH+1-1:0]         vec_sl_ad_delta_o  ,
  output wire                            en_cj_o          

);
  parameter                       VEC_USED_WIDTH = W_WIDTH+D_WIDTH+1-OHM;
  parameter                       VEC_USED_LOW   = D_WIDTH-3;
  //integer                         file_alpha_r2p;
 // integer                         file_vec1_test;
  // integer                         file_phi_rpp;
  // integer                         file_cj_S_r;
  // integer                         file_delta_i;
  // integer                         file_sgn_img;zhege
  // integer                         file_sgn_img_test;
  // integer                         file_vec_sl;
  reg  [W_WIDTH+D_WIDTH+3-1:0]       vec1_test;
 // reg [W_WIDTH+D_WIDTH+3-1:0]     vec1_r;
 // reg [W_WIDTH+D_WIDTH+3-1:0]     vec2_r;
  //reg [W_WIDTH+D_WIDTH+3-1:0]     vec3_r;
  reg [2:0]                       mode_r;
 reg                             en_r;
  reg [DATA_WIDTH-1:0]            S_r;
  reg [DATA_WIDTH+2-1:0]          delta_r;
 // reg                             uof_r;
 // reg                             dof_r;
 reg [DATA_WIDTH+3:0]          vec_sl_ad_delta_rp;
 wire [DATA_WIDTH+3-2:0]       vec_sl_ad_delta_rp_4;//18 scp9_4
  //wire [DATA_WIDTH+1-1:0]         vec_sl_ad_delta_rp_high;
  reg signed [DATA_WIDTH+1-1:0]   phi_rpp;
  reg [DATA_WIDTH+1-1:0]          n_phi_rpp;
  reg [DATA_WIDTH-1:0]            alpha_r;//16wei
 reg [DATA_WIDTH+1-1:0]          alpha_quant;//閲忓寲鍚庣殑娈嬪樊                          
  reg                             sgn_alpha;//娈嬪樊鐨勭鍙�
//  reg                             sgn_alpha_rp;

  reg                             en_r2;
 // reg [DATA_WIDTH+1-1:0]          phi_r2;
  //reg [DATA_WIDTH+1-1:0]          phi_r3;
 // reg [DATA_WIDTH+1-1:0]          n_phi_r3p;
 // reg [DATA_WIDTH+1-1:0]          alpha_r2p;
 // reg [DATA_WIDTH-1:0]            S_r2;

  reg                             en_r3;
  reg                             en_block_cnt_r;
 // reg [DATA_WIDTH+1-1:0]          alpha_r3;
 // reg [DATA_WIDTH-1:0]            S_r3;
  reg [3:0]                       id_ratio_r;  
  reg [7:0]                       quant_near;
  reg [7:0]                       requant_near;
  reg [7:0]                       n_quant_near;
  reg [7:0]                       quant_near_r;
  reg [7:0]                       quant_near_rp;
  reg [7:0]                       n_quant_near_r;
  reg [2:0]                       up_mode_r;
  reg                             en_upmode_r;
  reg [2:0]                       sgn_img;
 // reg [2:0]                       sgn_img_test;
  reg [2:0]                       sgn_img_r;
reg [2:0]                       sgn_img_p;
  reg[0:0] dof;
   reg[0:0] uof;
 // reg                             sgn_phi_cpr;
  
  //reg [DATA_WIDTH+1-1:0]          alpha_cpr;
 // reg [DATA_WIDTH+1-1:0]          n_phi_cpr;
  reg [DATA_WIDTH-1:0]          n_alpha_quant;
 reg [DATA_WIDTH+1-1:0]          alpha_div_od_ev;
  // reg [DATA_WIDTH+1-1+4:0]        alpha_cj_;
  reg [W_WIDTH+D_WIDTH+3-OHM-1:0] vec_crt_p     ;
 // reg [1:0]                       vec_low2_crt_p;
  // reg [W_WIDTH+D_WIDTH+3-OHM-1:0] vec_crt_r;
 // reg [W_WIDTH+D_WIDTH+3-OHM-1:0] vec_crt_sl_ohm_r;
  reg [DATA_WIDTH+1-1:0]          alpha_cj;
  //reg [DATA_WIDTH+1-1:0]          alpha_cj_test;
  (* keep = "true" *) reg [DATA_WIDTH+1-1:0]          cj_S_r;
 // reg [3:0]                       dif_sign_img;
  //reg [1:0]                       fpga_sgn_img;
  reg [DATA_WIDTH+3-2:0]          vec_sl_ad_delta_rpp;//scp_9_4
 //reg [DATA_WIDTH+1-1:0]          vec_sl_ad_delta_rpp;
  reg [DATA_WIDTH+1-1:0]          vec_sl_ad_delta_rppp;//scp_9_4
  reg                             sgn_alpha_r        ;

  reg [DATA_WIDTH-1:0]          alpha_r2           ;//16wei
  reg [DATA_WIDTH+1-1:0]          cj_S_r2           ;
  //wire[DATA_WIDTH+2-1:0]          test               ;
/***************************************************************************************/
/**************************************common ******************************************/
/***************************************************************************************/
always @(sgn_img_r,vec1_i,vec2_i,vec3_i) begin : get_vec1_test
  case(sgn_img_r)
    3'b001 : vec1_test <= vec1_i;
    3'b010 : vec1_test <= vec2_i;
    3'b100 : vec1_test <= vec3_i;
    default: vec1_test <= vec1_i;
  endcase
end
always @(sgn_img_r,vec1_i,vec2_i,vec3_i) begin : get_vec_crt_p
  case(sgn_img_r)
    3'b001 : vec_crt_p <= vec1_i[W_WIDTH+D_WIDTH+3-1:OHM];
    3'b010 : vec_crt_p <= vec2_i[W_WIDTH+D_WIDTH+3-1:OHM];
    3'b100 : vec_crt_p <= vec3_i[W_WIDTH+D_WIDTH+3-1:OHM];
    default: vec_crt_p <= vec1_i[W_WIDTH+D_WIDTH+3-1:OHM];
  endcase
end

always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    en_r  <= 'd0;
    en_r2 <= 'd0;
    en_r3 <= 'd0;
    mode_r<= 'd0;
    id_ratio_r<= 'd1;
    en_upmode_r<= 'd0;
    en_block_cnt_r<= 1'b0;
  end else begin
    en_r  <= en_i;
    en_r2 <= en_r;
    en_r3 <= en_r2;
    mode_r<= mode_i;
    id_ratio_r<= id_ratio_i;
    en_upmode_r<=en_upmode_i;
    en_block_cnt_r<= en_block_cnt_i;
  end
end
generate 
if((tx_type==0)||(tx_type==1)||(tx_type==2)||(tx_type==3)||(tx_type==4)) begin//qs
	always @(id_ratio_r) begin : get_quant_near
	    case(id_ratio_r)
	        8'd1:   quant_near = 'd0 ;
	        8'd4:   quant_near = 'd12 ;
	        8'd8:   quant_near = 'd24;
	        default: quant_near= 'd0 ;
	    endcase
	end
end
// else if(tx_type == 1)begin //kj
// 	always @(id_ratio_r) begin : get_quant_near
// 	    case(id_ratio_r)
// 	        4'd1:   quant_near = 'd0 ;
// 	        4'd4:   quant_near = 'd10 ;
// 	        4'd8:   quant_near = 'd22;
// 	        default: quant_near= 'd0 ;
// 	    endcase
// 	end
// end
else begin
	always @(id_ratio_r) begin : get_quant_near
	    case(id_ratio_r)
	        8'd1:   quant_near = 'd0 ;
	        8'd4:   quant_near = 'd8 ;
	        8'd8:   quant_near = 'd20;
	        default: quant_near= 'd0 ;
	    endcase
	end
end
endgenerate
always @(quant_near) begin : get_n_quant_near
  n_quant_near <= ~quant_near+1;
end
generate
    if((tx_type==0)||(tx_type==1)||(tx_type==2)||(tx_type==3)||(tx_type==4))begin
        always @(posedge clk or posedge rst_n) begin
            if (rst_n == 1'b0) begin
                requant_near <= 'd0;
                
            end
            else if (en_fst_blo_i)begin
                requant_near <= quant_near;
            end
            else if (en_upmode_r && id_ratio_r[0] == 0) begin
                if(quant_near_r == 'd0 && up_mode_r[1]==1'b1)begin
                    requant_near   <= 'd0;
                end else if((quant_near_r == 'd60 || quant_near_r == 'd62 )&& up_mode_r[0]==1'b1)begin
                    requant_near   <= 'd64;//8-10
                end else if(quant_near_r[7:6] > 'd0&& up_mode_r[0]==1'b1)begin
                    requant_near   <= 'd255;//11.21 
                end else if(quant_near_r[7] == 1'b1&& up_mode_r[1]==1'b1)begin
                    requant_near   <= 'd64;//11.21     
                end else begin
                    case (up_mode_r)
                        3'b001 : requant_near <= quant_near_r+4;
                        3'b010 : requant_near <= quant_near_r-2;
                        3'b000 : requant_near <= quant_near_r;
                        default : requant_near <= 'd0;
                    endcase
                end
            end 
        end
    end
    else begin

        always @(posedge clk or posedge rst_n) begin
            if (rst_n == 1'b0) begin
                requant_near <= 'd0;
                
            end
            else if (en_fst_blo_i)begin
                requant_near <= quant_near;
            end
            //else if (quant_near_r=='d1&& ) begin
            //    case (up_mode_r)
            //        3'b001 : requant_near <= quant_near_r+1;
            //        3'b010 : requant_near <= quant_near_r-1;
            //        3'b000 : requant_near <= quant_near_r;
            //        default : requant_near <= 'd0;
            //    endcase
            //end 
            else if (en_upmode_r && id_ratio_r[0] == 0) begin
                if(quant_near_r == 'd0 && up_mode_r[1]==1'b1)begin
                    requant_near   <= 'd0;
                end else if(quant_near_r == 'd32 && up_mode_r[0]==1'b1)begin
                    requant_near   <= 'd32;
                end else begin
                    case (up_mode_r)
                        3'b001 : requant_near <= quant_near_r+1;
                        3'b010 : requant_near <= quant_near_r-1;
                        3'b000 : requant_near <= quant_near_r;
                        default : requant_near <= 'd0;
                    endcase
                end
            end 
        end
        
    end
endgenerate

/***************************************************************************************/
/**************************************regist1******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : register1
  if(rst_n == 1'b0) begin
    S_r              <= 'd0;
    delta_r          <= 'd0;
    // uof_r            <= 'd0;
    // dof_r            <= 'd0;
    //quant_near_r     <= 'd0;
    up_mode_r        <= 'd0;
    quant_near_rp    <= 1'b0;
  end else if(en_i == 1'b1) begin
    S_r              <= S_i;
    delta_r          <= delta_i;
    // uof_r            <= uof_i;
    // dof_r            <= dof_i;
    //quant_near_r     <= quant_near;
    up_mode_r        <= up_mode_i;
    quant_near_rp    <= quant_near_r;
  end
end

always @(*) begin :get_quant_near_r
    if(en_block_cnt_i == 1'b1) begin
        quant_near_r <= requant_near;
    end else begin
        quant_near_r <= quant_near_rp;
    end
end

/**************************************stream1******************************************/
//assign test = vec_crt_p[DATA_WIDTH+2-1:0];

always @(vec_crt_p,delta_i) begin : get_vec_sl_ad_delta_rp
  vec_sl_ad_delta_rp <= {vec_crt_p[W_WIDTH+D_WIDTH+3-OHM-1],vec_crt_p[DATA_WIDTH+2:0]} + delta_i;//四倍预测像素
end

assign vec_sl_ad_delta_rp_4 =vec_sl_ad_delta_rp[DATA_WIDTH+3:2]; //四倍预测像素 除4  scp_9_4 18bit
//需要修改 

/*always @(S_i,vec_sl_ad_delta_rp) begin : get_phi_rpp
    if (vec_sl_ad_delta_rp> 'd16382 ) begin //12bits
        phi_rpp <= {1'b0,S_i} - 'd4095;
    end else if(vec_sl_ad_delta_rp< 'd0) begin
        phi_rpp <= {1'b0,S_i};
    end else begin
        phi_rpp <= {1'b0,S_i} - vec_sl_ad_delta_rp[DATA_WIDTH+2:2];//娈嬪樊
    end
end
*/

/*always @(S_i, vec_sl_ad_delta_rp, mode_r) begin : get_phi_rpp 
    if (mode_r[0] == 1'b1 && vec_sl_ad_delta_rp > 'd16382) begin
        phi_rpp <= {1'b0, S_i} - 'd4095;//12
    end else if (mode_r[1] == 1'b1 && vec_sl_ad_delta_rp > 'd65534) begin
        phi_rpp <= {1'b0, S_i} - 'd16383;//14
    end else if (mode_r[2] == 1'b1 && vec_sl_ad_delta_rp > 'd262142) begin
        phi_rpp <= {1'b0, S_i} - 'd65535;//16
    end else if (vec_sl_ad_delta_rp[DATA_WIDTH+3-1] ==  1'b1) begin
        phi_rpp <= {1'b0, S_i};
    end else begin
        phi_rpp <= {1'b0, S_i} - vec_sl_ad_delta_rp[DATA_WIDTH+2:2]; 
    end
end*/

wire is_neg   ;
wire range_12 ;
wire range_14 ;
wire range_16 ;

assign is_neg = vec_sl_ad_delta_rp_4[DATA_WIDTH+3-2];  // [17] 判断是否为负值
assign range_12 = |vec_sl_ad_delta_rp_4[DATA_WIDTH:DATA_WIDTH+3-2-5]; // [16:12] 是否有非零
assign range_14 = |vec_sl_ad_delta_rp_4[DATA_WIDTH:DATA_WIDTH+3-2-3]; // [16:14] 是否有非零
assign range_16 = vec_sl_ad_delta_rp_4[DATA_WIDTH+3-2-1]; // [16] 判断是否为1

always @(*) begin : get_phi_rpp
    if (is_neg) begin
        // 如果为负数，直接赋值 {1'b0, S_i}
        phi_rpp = {1'b0, S_i};
    end else if (mode_r[0] == 1'b1 && range_12) begin
        // 如果 mode_r[0] 为 1 且 [16:12] 有非零位，减去 4095
        phi_rpp = {1'b0, S_i} - 'd4095;  // 12 位减法
    end else if (mode_r[1] == 1'b1 && range_14) begin
        // 如果 mode_r[1] 为 1 且 [16:14] 有非零位，减去 16383
        phi_rpp = {1'b0, S_i} - 'd16383;  // 14 位减法
    end else if (mode_r[2] == 1'b1 && range_16) begin
        // 如果 mode_r[2] 为 1 且 [16] 位为 1，减去 65535
        phi_rpp = {1'b0, S_i} - 'd65535;  // 16 位减法
    end else begin
        // 否则，减去 vec_sl_ad_delta_rp_4
        phi_rpp = {1'b0, S_i} - vec_sl_ad_delta_rp_4;
    end
end

always @(phi_rpp,quant_near_r,alpha_r,spec_fst_i) begin : get_sgn_img //鍚戝墠棰勬祴涓夌绗﹀彿
  if(spec_fst_i == 1'b1)begin
    sgn_img <= 3'b001;
  end else if((phi_rpp[DATA_WIDTH+1-1] == 1'b0)&&(alpha_r>quant_near_r)) begin //娈嬪樊鏄鏁� 娈嬪樊缁濆鍊煎ぇ浜巒ear
    sgn_img <= 3'b010;
  end else if((phi_rpp[DATA_WIDTH+1-1] == 1'b1)&&(alpha_r>quant_near_r)) begin//娈嬪樊鏄礋鏁板苟涓� 娈嬪樊缁濆鍊煎ぇ浜巒ear
    sgn_img <= 3'b100;
  end else begin
    sgn_img <= 3'b001;
  end
end 

always @(phi_rpp) begin : get_n_phi_rpp
  n_phi_rpp <= ~phi_rpp;//鍙栧弽
end

always @(phi_rpp,n_phi_rpp) begin : get_alpha_r //瀵规畫宸彇绗﹀彿 缁濆鍊�
  if(phi_rpp[DATA_WIDTH+1-1] == 1'b0) begin
    alpha_r     = phi_rpp[DATA_WIDTH-1:0];
    sgn_alpha   = 1'b0;
  end else begin
    alpha_r     = n_phi_rpp[DATA_WIDTH-1:0]+1;
    sgn_alpha   = 1'b1;
  end
end

/***************************************************************************************/
/**************************************regist2******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin: regist2
    if(rst_n == 1'b0)begin
      //  vec_sl_ad_delta_rpp <= 'd0;
        sgn_alpha_r         <= 'd0;
       // sgn_img_r           <= 'd0;
        alpha_r2            <= 'd0;
    end else if(en_i == 1'b1)begin
       // vec_sl_ad_delta_rpp <= vec_sl_ad_delta_rp[DATA_WIDTH+2:2];
        sgn_alpha_r         <= sgn_alpha         ;
      //  sgn_img_r           <= sgn_img           ;
        alpha_r2            <= alpha_r           ;
    end
end

// always @(posedge clk or negedge rst_n) begin: get_vec_sl_ad_delta_rpp
//     if(rst_n == 1'b0)begin
//         vec_sl_ad_delta_rpp <= 'd0;
//     end else if(en_i == 1'b1 && vec_sl_ad_delta_rp[DATA_WIDTH+2] == 1'b0)begin
//         vec_sl_ad_delta_rpp <= vec_sl_ad_delta_rp[DATA_WIDTH+2:2];
//     end else if(en_i == 1'b1)begin
//         vec_sl_ad_delta_rpp <= 'd0;
//     end
// end

/*always @(posedge clk or negedge rst_n) begin: get_vec_sl_ad_delta_rpp
    if(rst_n == 1'b0)begin
        vec_sl_ad_delta_rpp <= 'd0;
    end else if(en_i == 1'b1 && mode_r[0] == 1'b1&&dof==1'b0&& uof==1'b1)begin
        vec_sl_ad_delta_rpp <= 'd4095;
    end else if(en_i == 1'b1 && mode_r[1] == 1'b1&&dof==1'b0&& uof==1'b1)begin
        vec_sl_ad_delta_rpp <= 'd16383;
    end else if(en_i == 1'b1 && mode_r[2] == 1'b1&&dof==1'b0&& uof==1'b1)begin
        vec_sl_ad_delta_rpp <= 'd65535;
    end else if(en_i == 1'b1 && dof==1'b0&& uof==1'b0)begin
        vec_sl_ad_delta_rpp <= vec_sl_ad_delta_rp[DATA_WIDTH+2:2];
    end else if(en_i == 1'b1&&dof==1'b1&& uof==1'b0)begin
        vec_sl_ad_delta_rpp <= 'd0;
    end
end*/
//-

always @(posedge clk or negedge rst_n) begin: get_vec_sl_ad_delta_rpp
    if(rst_n == 1'b0)begin
        vec_sl_ad_delta_rpp <= 'd0;
    end else if(en_i == 1'b1)begin
        vec_sl_ad_delta_rpp <= vec_sl_ad_delta_rp_4;//scp_9_4//四倍预测像素 除4   18bit
    end 
end

wire is2_neg   ;
wire range2_12 ;
wire range2_14 ;
wire range2_16 ;

assign is2_neg = vec_sl_ad_delta_rpp[DATA_WIDTH+3-2];  // 检查符号位，判断是否为负数
assign range2_12 = vec_sl_ad_delta_rpp[DATA_WIDTH-3] || vec_sl_ad_delta_rpp[DATA_WIDTH+3-2-5]; // 判断 [13] 或 [12]
assign range2_14 = vec_sl_ad_delta_rpp[DATA_WIDTH-1] || vec_sl_ad_delta_rpp[DATA_WIDTH+3-2-3]; // 判断 [15] 或 [14]
assign range2_16 = vec_sl_ad_delta_rpp[DATA_WIDTH+3-2-1];  // 判断 [16]
always @(*) begin : get_vec_sl_ad_delta_rppp 
    // 组合逻辑条件判断
    if (is2_neg) begin
        vec_sl_ad_delta_rppp <= 'd0; // 如果为负数，直接输出 0
    end else if (mode_r[0] == 1'b1 && range2_12) begin
        vec_sl_ad_delta_rppp <= 'd4095; // 12b
    end else if (mode_r[1] == 1'b1 && range2_14) begin
        vec_sl_ad_delta_rppp <= 'd16383; // 14b
    end else if (mode_r[2] == 1'b1 && range2_16) begin
        vec_sl_ad_delta_rppp <= 'd65535; // 16b
    end else begin
        vec_sl_ad_delta_rppp <= vec_sl_ad_delta_rpp[DATA_WIDTH+1-1:0]; 
    end
end



//-
always @(sgn_img, en_i) begin : get_sgn_img_p
  if (en_i == 1'b1) begin
    sgn_img_p <= sgn_img;
  end else begin
    sgn_img_p  <= 'd0;
  end
end

always @(posedge clk or negedge rst_n) begin: sgn_img_r_regist2
    if(rst_n == 1'b0)begin
        sgn_img_r           <= 'd0;
    end else if(en_i == 1'b1|| (en_i == 1'b0 && en_r == 1'b1))begin       
        sgn_img_r           <= sgn_img_p           ;

    end
end

//3 5 7 9  11
//5 6 9 10 13
/**************************************stream2******************************************/
// always @(alpha_r2,quant_near_rp) begin : get_phi_quant
  // case(quant_near_rp)//閲忓寲
    // 5'd0   :    alpha_quant <= alpha_r2;
   
    // 5'd1   :    alpha_quant <= (alpha_r2+quant_near_rp)/3;
    // 5'd2   :    alpha_quant <= (alpha_r2+quant_near_rp)/5;
    // 5'd3   :    alpha_quant <= (alpha_r2+quant_near_rp)/7;
    // 5'd4   :    alpha_quant <= (alpha_r2+quant_near_rp)/9;
    // 5'd5   :    alpha_quant <= (alpha_r2+quant_near_rp)/11;
    // 5'd6   :    alpha_quant <= (alpha_r2+quant_near_rp)/13;
    // 5'd7   :    alpha_quant <= (alpha_r2+quant_near_rp)/15;
    // 5'd8   :    alpha_quant <= (alpha_r2+quant_near_rp)/17;
    // 5'd9   :    alpha_quant <= (alpha_r2+quant_near_rp)/19;
    // 5'd10   :    alpha_quant <= (alpha_r2+quant_near_rp)/21;
    // 5'd11   :    alpha_quant <= (alpha_r2+quant_near_rp)/23;
    // 5'd12   :    alpha_quant <= (alpha_r2+quant_near_rp)/25;
    
    // 5'd16  :    alpha_quant <= (alpha_r2+quant_near_rp)/33;
    // 5'd17  :    alpha_quant <= (alpha_r2+quant_near_rp)/35;
    // 5'd18  :    alpha_quant <= (alpha_r2+quant_near_rp)/37;
    // 5'd19  :    alpha_quant <= (alpha_r2+quant_near_rp)/39;
    // 5'd20  :    alpha_quant <= (alpha_r2+quant_near_rp)/41;
    // 5'd21  :    alpha_quant <= (alpha_r2+quant_near_rp)/43;
    // 5'd22  :    alpha_quant <= (alpha_r2+quant_near_rp)/45;
    // 5'd23  :    alpha_quant <= (alpha_r2+quant_near_rp)/47;
    // 5'd24  :    alpha_quant <= (alpha_r2+quant_near_rp)/49;
    // 5'd25  :    alpha_quant <= (alpha_r2+quant_near_rp)/51;
    // 5'd26  :    alpha_quant <= (alpha_r2+quant_near_rp)/53;
    // 5'd27  :    alpha_quant <= (alpha_r2+quant_near_rp)/55;
    // 5'd28  :    alpha_quant <= (alpha_r2+quant_near_rp)/57;
    // 5'd29  :    alpha_quant <= (alpha_r2+quant_near_rp)/69;
    // 5'd30  :    alpha_quant <= (alpha_r2+quant_near_rp)/61;
    // 5'd31  :    alpha_quant <= (alpha_r2+quant_near_rp)/63;
    // default:    alpha_quant <= 'd0;
  // endcase 
// end


// always @(alpha_quant,quant_near_r) begin : get_alpha_cj
  // case(quant_near_r) //鍙嶉噺鍖�
    // 5'd0   :    alpha_cj <= alpha_quant;
    // 5'd1   :    alpha_cj <= alpha_quant*3;
    // 5'd2   :    alpha_cj <= alpha_quant*5;
    // 5'd3   :    alpha_cj <= alpha_quant*7;
    // 5'd4   :    alpha_cj <= alpha_quant*9;
    // 5'd5   :    alpha_cj <= alpha_quant*11;
    // 5'd6   :    alpha_cj <= alpha_quant*13;
    // 5'd7   :    alpha_cj <= alpha_quant*15;
    // 5'd8   :    alpha_cj <= alpha_quant*17;
    // 5'd9   :    alpha_cj <= alpha_quant*19;
    // 5'd10   :    alpha_cj <= alpha_quant*21;
    // 5'd11   :    alpha_cj <= alpha_quant*23;
    // 5'd12   :    alpha_cj <= alpha_quant*25;
    // 5'd16   :    alpha_cj <= alpha_quant*33;
    // 5'd17   :    alpha_cj <= alpha_quant*35;
    // 5'd18   :    alpha_cj <= alpha_quant*37;
    // 5'd19   :    alpha_cj <= alpha_quant*39;
    // 5'd20   :    alpha_cj <= alpha_quant*41;
    // 5'd21   :    alpha_cj <= alpha_quant*43;
    // 5'd22  :    alpha_cj <= alpha_quant*45;
    // 5'd23  :    alpha_cj <= alpha_quant*47;
    // 5'd24  :    alpha_cj <= alpha_quant*49;
    // 5'd25  :    alpha_cj <= alpha_quant*51;
    // 5'd26  :    alpha_cj <= alpha_quant*53;
    // 5'd27  :    alpha_cj <= alpha_quant*55;
    // 5'd28  :    alpha_cj <= alpha_quant*57;
    // 5'd29  :    alpha_cj <= alpha_quant*59;
    // 5'd30  :    alpha_cj <= alpha_quant*61;
    // 5'd31  :    alpha_cj <= alpha_quant*63;
    // default:    alpha_cj <= 'd0;
  // endcase 
// end    
// always @(alpha_quant) begin : get_n_alpha_quant//姝ｈ礋濂囧伓鏄犲皠
  // n_alpha_quant <= ~alpha_quant[15:0];
// end
// always @(alpha_cj) begin : get_alpha_cj_test
  // alpha_cj_test <= alpha_cj[47:32];
// end 
// always @(alpha_quant,sgn_img_r) begin : get_sgn_cj_Sr
    // case(sgn_img_r[2])
        // 1'b0:   alpha_div_od_ev <= {alpha_quant[16:0],1'b0};
        // 1'b1:   alpha_div_od_ev <= {alpha_quant[16:0],1'b0}-1;
        // default : alpha_div_od_ev <= 'd0;
    // endcase
// end

// always @(alpha_cj,sgn_alpha_r,vec_sl_ad_delta_rppp) begin : get_cj_S_r
    // case(sgn_alpha_r)
        // 1'b0:   cj_S_r <= vec_sl_ad_delta_rppp + alpha_cj;
        // 1'b1:   cj_S_r <= vec_sl_ad_delta_rppp - alpha_cj;
        // default : cj_S_r <= 'd0;
    // endcase
// end
// always @(posedge clk or negedge rst_n) begin: get_cj_S_r2
    // if(rst_n == 1'b0)begin
        // cj_S_r2          <= 'd0;
    // end else if(en_r == 1'b1)begin       
        // cj_S_r2           <= cj_S_r ;

    // end
// end
/*always @(posedge clk) begin
    if (en_r == 1'b1) begin
        file_alpha_r2p = $fopen("D:/KEHU_ceshi/KEHU_test/jiemaceshi/ccsds_ceshi000/KEJAIN_GAOSI/alpha_div_od_ev.txt", "a"); 
        if (file_alpha_r2p != 0 ) begin
            $fwrite(file_alpha_r2p, "%05h\n", alpha_r2);
            $fclose(file_alpha_r2p);
        end
    end
end*/

/*always @(posedge clk) begin
    if (en_i == 1'b1) begin
        file_vec1_test = $fopen("D:/KEHU_ceshi/KEHU_test/jiemaceshi/guoke_7_2/vec1_test.txt", "a"); 
        if (file_vec1_test != 0 ) begin
            $fwrite(file_vec1_test, "%42b\n", vec1_test);
            $fclose(file_vec1_test);
        end
    end
end*/
/***************************************************************************************/
/**************************************  out  ******************************************/
/***************************************************************************************/
//assign S_o     = {1'b0,S_r};
//assign alpha_o = alpha_div_od_ev;
//assign cj_S_o  = cj_S_r2; //閲嶅缓鍍忕礌
assign sgn_img_o = sgn_img;
assign en_o    = en_i;
//assign en_cj_o = en_r;
//assign quant_near_o = quant_near_r;

assign S_o              = S_r                  ;
assign quant_near_o     = quant_near_r         ;
assign alpha_o          = alpha_r2             ; //16
assign sgn_img_r_o      = sgn_img_r            ;
assign sgn_alpha_o      = sgn_alpha_r            ;
assign vec_sl_ad_delta_o= vec_sl_ad_delta_rppp ; //17
assign en_cj_o          = en_r                 ;
endmodule
