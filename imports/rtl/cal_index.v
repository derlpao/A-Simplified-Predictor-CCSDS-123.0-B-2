module cal_index#(
    parameter           X_LEN = 11,
    parameter           Y_LEN = 5,
    parameter           Z_LEN = 8,
    parameter      DATA_WIDTH = 12
)
(
  input  wire                       clk         ,
  input  wire                       rst_n       ,
    
  input  wire [X_LEN-1:0]           Nx          ,
  input  wire [Y_LEN-1:0]           Ny          ,
  input  wire [Z_LEN-1:0]           Nz          ,
  input  wire [DATA_WIDTH+1-1:0]    S_i         ,//17
  input  wire [DATA_WIDTH+1-1:0]    alpha_i     ,//17
  // input  wire                       AP_empty_i  ,
  input  wire                       en_i        ,
    
  output wire                       en_o        ,
  output wire [3:0]                 k_o         ,
  output wire [DATA_WIDTH+1-1:0]    alpha_o     ,
  /**************entropy*******************/
  output wire [3:0]                 index_mby_o  , 
  // output wire [3:0]                 alpha_delta_o, 
  // output wire [4:0]                 index_real_o     ,
  // output wire [4:0]                 index_data_max_o ,
  output wire                       en_last_o      
  // output wire                       en_x_o           ,
  // output wire                       low_entropy_vaild_o
);                      
 parameter                ACC_WIDTH = X_LEN + Y_LEN + DATA_WIDTH+1+2;//14+5+16+1         
 parameter                P_WIDTH     = 8;                   
 parameter                CNT49_WIDTH = 14;                   
    integer                  file_k_r6pp;           
    integer                  file_alpha;
    integer                  file_ac;
    integer                  file_acc;
    integer                  file_pcnt_r;
    integer                  file_index;
    reg     [X_LEN-1:0]             Nx_r        ;
    reg     [Y_LEN-1:0]             Ny_r        ;
    reg     [Z_LEN-1:0]             Nz_r        ;
    reg     [DATA_WIDTH+1-1:0]      S_r         ;
    reg     [DATA_WIDTH+1-1:0]      alpha_r     ;
    reg                             AP_empty_r  ;
    reg                             en_r        ;
  reg [X_LEN-1:0]          xcnt_r;
  reg [Y_LEN-1:0]          ycnt_r;
  reg [Z_LEN-1:0]          zcnt_r;
  reg [P_WIDTH-1:0]        pcnt_r;
  reg [P_WIDTH-1:0]        pcnt_INI_reg;
  reg [CNT49_WIDTH-1:0]    cnt49_r;
  reg [CNT49_WIDTH-1:0]    cnt49_INI_reg;
  reg                      x_full_rp;
  reg                      x_zero_rp;
  reg                      z_zero_rp;
  reg                      z_full_rp;
  reg                      y_full_rp;
  reg                      y_zero_rp;
  reg                      y_zero_s1_rpp;
  reg                      k_INI_en_rp;
  reg                      p_full_rp;

  reg [ACC_WIDTH-1:0]      acc_slt_rp;
  reg [ACC_WIDTH-1:0]      acc_rpp;
  reg [ACC_WIDTH-1-2:0]    ac_rpp;
  reg [ACC_WIDTH-1:0]      acc_rppp;

  reg                      en_r2;
  reg [DATA_WIDTH+1-1:0]   alpha_r2;//17
  reg [ACC_WIDTH-1:0]      acc_upt_r2;
  reg [ACC_WIDTH-1:0]      acc_crt_r2;
  reg [ACC_WIDTH-1-2:0]    ac_crt_r2;
  reg                      x_full_r2;
  reg                      x_full_r3;
  reg                      x_full_r4;
  reg                      x_full_r5;
  reg                      x_full_r6;
  reg                      x_full_r7;
  reg                      y_zero_s1_r2;
  reg [Z_LEN-1:0]          zcnt_r2;
  reg [P_WIDTH-1:0]        pcnt_r2;
  reg [CNT49_WIDTH-1:0]    cnt49_r2;
//cpr signal
  reg                      en_r3;
  reg [DATA_WIDTH+1-1:0]   alpha_r3;
  wire                     k7_bflag_r3;
  wire                     k7_sflag_r3;
  wire [P_WIDTH-1:0]       k7_pcnt_r3;
  wire [CNT49_WIDTH-1:0]   k7_cnt49_r3;
  wire [ACC_WIDTH-1-2:0]     k7_acc_r3;

  reg                      en_r4;
  wire                     k3_bflag_r4;
  wire                     k3_sflag_r4;
  wire [P_WIDTH-1:0]       k3_pcnt_r4;
  wire [CNT49_WIDTH-1:0]   k3_cnt49_r4;
  wire [ACC_WIDTH-1-2:0]     k3_acc_r4;
  wire                     k11_bflag_r4;
  wire                     k11_sflag_r4;
  wire [P_WIDTH-1:0]       k11_pcnt_r4;
  wire [CNT49_WIDTH-1:0]   k11_cnt49_r4;
  wire [ACC_WIDTH-1-2:0]     k11_acc_r4;

  reg                      en_r5;
  wire                     k2_bflag_r5;
  wire                     k2_sflag_r5;
  wire [P_WIDTH-1:0]       k2_pcnt_r5;
  wire [CNT49_WIDTH-1:0]   k2_cnt49_r5;
  wire [ACC_WIDTH-1-2:0]     k2_acc_r5;
  wire                     k5_bflag_r5;
  wire                     k5_sflag_r5;
  wire [P_WIDTH-1:0]       k5_pcnt_r5;
  wire [CNT49_WIDTH-1:0]   k5_cnt49_r5;
  wire [ACC_WIDTH-1-2:0]     k5_acc_r5;
  wire                     k9_bflag_r5;
  wire                     k9_sflag_r5;
  wire [P_WIDTH-1:0]       k9_pcnt_r5;
  wire [CNT49_WIDTH-1:0]   k9_cnt49_r5;
  wire [ACC_WIDTH-1-2:0]     k9_acc_r5;
  wire                     k13_bflag_r5;
  wire                     k13_sflag_r5;
  wire [P_WIDTH-1:0]       k13_pcnt_r5;
  wire [CNT49_WIDTH-1:0]   k13_cnt49_r5;
  wire [ACC_WIDTH-1-2:0]     k13_acc_r5;

  reg                      en_r6;

  wire                     k1_bflag_r6;
  wire                     k1_sflag_r6;
  wire                     k4_bflag_r6;
  wire                     k4_sflag_r6;
  wire                     k6_bflag_r6;
  wire                     k6_sflag_r6;
  wire                     k8_bflag_r6;
  wire                     k8_sflag_r6;
  wire                     k10_bflag_r6;
  wire                     k10_sflag_r6;
  wire                     k12_bflag_r6;
  wire                     k12_sflag_r6;
  wire                     k14_bflag_r6;
  wire                     k14_sflag_r6;
  reg                      k2_bflag_r6;
  wire [14:0]              k_one_num_r6;
  reg  [3:0]               k_r6p;
  reg  [3:0]               k_r6pp;

  reg                      en_r7;
  reg  [3:0]               k_r7;
  reg                      k_INI_en_r2;
  reg                      k_INI_en_r3;
  reg                      k_INI_en_r4;
  reg                      k_INI_en_r5;
  reg                      k_INI_en_r6;
/*delay signal*/
  wire[DATA_WIDTH+1-1:0]   alpha_r5;
  reg [DATA_WIDTH+1-1:0]   alpha_r6;
  wire[DATA_WIDTH+1-1:0]   alpha_r7;
//ram signal
  wire                     w_RAM_en;
  wire[ACC_WIDTH-1:0]      w_RAM_data;
  wire[38:0]               r_RAM_data;
  reg [ACC_WIDTH-1:0]      r_RAM_data_reg;
  reg [Z_LEN-1:0]          r_RAM_addr;
  reg [Z_LEN-1:0]          r_RAM_addr_p;
  reg                      r_RAM_en;   
/*****entropy encode control*****/  
  reg [ACC_WIDTH-1+14:0]    index_0         ;
  reg [ACC_WIDTH-1+14:0]    index_1         ;
  reg [ACC_WIDTH-1+14:0]    index_2         ;
  reg [ACC_WIDTH-1+14:0]    index_3         ;
  reg [ACC_WIDTH-1+14:0]    index_4         ;
  reg [ACC_WIDTH-1+14:0]    index_5         ;
  reg [ACC_WIDTH-1+14:0]    index_6         ;
  reg [ACC_WIDTH-1+14:0]    index_7         ;
  reg [ACC_WIDTH-1+14:0]    index_8         ;
  reg [ACC_WIDTH-1+14:0]    index_9         ;
  reg [ACC_WIDTH-1+14:0]    index_10        ;
  reg [ACC_WIDTH-1+14:0]    index_11        ;
  reg [ACC_WIDTH-1+14:0]    index_12        ;
  reg [ACC_WIDTH-1+14:0]    acc_crt_r2_rl   ;
  reg                       index_num0      ;
  reg                       index_num1      ;
  reg                       index_num2      ;
  reg                       index_num3      ;
  reg                       index_num4      ;
  reg                       index_num5      ;
  reg                       index_num6      ;
  reg                       index_num7      ;
  reg                       index_num8      ;
  reg                       index_num9      ;
  reg                       index_num10     ;
  reg                       index_num11     ;
  reg [11:0]                index_total     ;
  reg [11:0]                index_total_r3  ;
  reg [3:0]                 index_mby       ;
  // reg                       index_num12  ;
  reg                       AP_empty_r2       ;
  reg                       AP_empty_r3       ;
  reg  [3:0]                index_mby_r4      ;
  reg  [3:0]                index_mby_r5      ;
  reg  [3:0]                index_mby_r6      ;
  reg  [3:0]                index_mby_r7      ;
  // reg  [4:0]                index_now_ram     ;
  // reg  [4:0]                index_mby_old     ;
  reg                       AP_empty_r4       ;
  reg  [4:0]                chge_index_req    ;
  reg                       en_chge_req       ;
  reg  [5:0]                count_cnt         ;
  reg                       en_count_zero     ;
  reg                       en_chge_req_r5    ;
  reg                       AP_empty_r5       ;
  reg                       count_INI         ;
  // reg  [4:0]                index_mby_old_r5  ;
  // reg  [4:0]                index_now         ;
  wire [4:0]                w_RAM_preindex    ;
  wire [4:0]                r_RAM_preindex    ;
  // reg  [4:0]                index_real_r6     ;
  // reg  [4:0]                index_real_r7     ;
  reg                       en_spec_fst       ;
  reg                       en_spec_fst_r2       ;
  reg                       en_spec_fst_r3       ;
  reg                       en_spec_fst_r4       ;
  reg                       en_spec_fst_r5       ;
  
  reg   [X_LEN-1:0]                    xcnt_r2        ;
  reg   [X_LEN-1:0]                    xcnt_r3        ;
  reg   [X_LEN-1:0]                    xcnt_r4        ;
  reg   [X_LEN-1:0]                    xcnt_r5        ;
  reg   [X_LEN-1:0]                    xcnt_r6        ;
  
  reg                                   en_chge_spec   ; 
  reg                                   en_chge_spec_r2;
  reg                                   en_chge_spec_r3;
  reg                                   en_chge_spec_r4;
  reg                                   en_chge_spec_r5;
  reg   [Z_LEN-1:0]                     zcnt_r3      ;
  reg   [Z_LEN-1:0]                     zcnt_r4      ;
  reg   [Z_LEN-1:0]                     zcnt_r5      ;
  reg                                   en_yzero_chge_spec    ;
  reg                                   en_yzero_chge_spec_r2 ;
  reg                                   en_yzero_chge_spec_r3 ;
  reg                                   en_yzero_chge_spec_r4 ;
  reg                                   en_yzero_chge_spec_r5 ;
  reg                                   en_yzero_chge_spec_r6 ;
  reg  [4:0]                            index_data_max        ;
  reg  [4:0]                            index_data_max_r6     ;
  
  reg                                   en_x                  ;
  reg                                   en_x_r6               ;
  reg  [DATA_WIDTH+1-1:0]               dif_alpha_index       ;
  reg                                   low_entropy_vaild     ;
  reg                                   low_entropy_vaild_r6  ;
/************count_ram***************/ 
  wire  [5:0]               w_RAM_count   ;
  wire                      w_RAM_cnt_en  ;
  reg                       w_RAM_cnt_en_r2  ;
  reg                       w_RAM_cnt_en_r3  ;
  reg                       w_RAM_cnt_en_r4  ;
  reg                       w_RAM_cnt_en_r5  ;
  reg                       r_cnt_RAM_en_r3  ;
  reg                       r_cnt_RAM_en_r4  ;
  reg                       r_cnt_RAM_en_r5  ;
  reg   [Z_LEN-1:0]         r_RAM_cnt_ad_r3  ;
  reg   [Z_LEN-1:0]         r_RAM_cnt_ad_r4  ;
  reg   [Z_LEN-1:0]         r_RAM_cnt_ad_r5  ;
  wire  [5:0]               r_RAM_count      ;
  reg   [5:0]               count_cnt_ram    ;
  // reg                       en_spec_fst       ;
always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    en_r  <= 'd0;
    en_r2 <= 'd0;
    en_r3 <= 'd0;
    en_r4 <= 'd0;
    en_r5 <= 'd0;
    en_r6 <= 'd0;
    en_r7 <= 'd0;
    r_RAM_data_reg <= 'd0;
  end else begin
    en_r  <= en_i;
    en_r2 <= en_r;
    en_r3 <= en_r2;
    en_r4 <= en_r3;
    en_r5 <= en_r4;
    en_r6 <= en_r5;
    en_r7 <= en_r6;
    r_RAM_data_reg <= r_RAM_data[ACC_WIDTH-1:0];
  end
end

always@(posedge clk or negedge rst_n)begin: regist1
    if(rst_n == 1'b0) begin
        Nx_r       <= 'd0;
        Ny_r       <= 'd0;
        Nz_r       <= 'd0;
        S_r        <= 'd0;
        alpha_r    <= 'd0;
        // AP_empty_r <= 'd0;
    end else if(en_i == 1'b1) begin
        Nx_r       <= Nx        ;
        Ny_r       <= Ny        ;
        Nz_r       <= Nz        ;
        S_r        <= S_i       ;
        alpha_r    <= alpha_i   ;
        // AP_empty_r <= AP_empty_i;
    end
end

always @(posedge clk or negedge rst_n) begin : get_xcnt
  if(rst_n == 1'b0) begin
    xcnt_r <= 'd0;
  end else if(en_r == 1'b1 && x_full_rp == 1'b1) begin
    xcnt_r <= 'd0;
  end else if(en_r == 1'b1) begin
    xcnt_r <= xcnt_r + 1'b1;
  end
end

always @(posedge clk or negedge rst_n) begin : get_zcnt
  if(rst_n == 1'b0) begin
    zcnt_r <= 'd0;
  end else if(en_r == 1'b1 && z_full_rp == 1'b1 && x_full_rp == 1'b1) begin
    zcnt_r <= 'd0;
  end else if(en_r == 1'b1 && x_full_rp == 1'b1) begin
    zcnt_r <= zcnt_r + 1'b1;
  end
end

always @(posedge clk or negedge rst_n) begin : get_ycnt
  if(rst_n == 1'b0) begin
    ycnt_r <= 'd0;
  end else if(en_r == 1'b1 && y_full_rp == 1'b1 && z_full_rp == 1'b1 && x_full_rp == 1'b1) begin
    ycnt_r <= 'd0;
  end else if(en_r == 1'b1 && z_full_rp == 1'b1 && x_full_rp == 1'b1) begin
    ycnt_r <= ycnt_r + 1'b1;
  end
  
end
always @(posedge clk or negedge rst_n) begin : get_pcnt_r
  if(rst_n == 1'b0) begin
    pcnt_r <= 'd0;//6_8gai
  end else if(en_r == 1'b1 && y_full_rp == 1'b1 && z_full_rp == 1'b1 && x_full_rp == 1'b1) begin
    pcnt_r <= 'd0;//finish//6_8gai
  end else if(en_r == 1'b1 && x_full_rp == 1'b1 && z_full_rp == 1'b1 && p_full_rp == 1'b0) begin
    pcnt_r <= pcnt_r + 1'b1;//last z last x pcnt no full
  end else if(en_r == 1'b1 && x_full_rp == 1'b1 && z_full_rp == 1'b1 && p_full_rp == 1'b1) begin
    pcnt_r <= 'd128;//last z last x pcnt full
  end else if(en_r == 1'b1 && x_full_rp == 1'b1) begin
    pcnt_r <= pcnt_INI_reg;//next z
  end else if(en_r == 1'b1 && p_full_rp == 1'b1) begin
    pcnt_r <= 'd128;//working  pcnt full
  end else if(en_r == 1'b1) begin
    pcnt_r <= pcnt_r + 1'b1;//working  pcnt no full
  end
end
// always @(posedge clk) begin
    // if (en_r == 1'b1) begin
        // file_pcnt_r = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/pcnt_r.txt", "a"); 
        // if (file_pcnt_r != 0 ) begin
            // $fwrite(file_pcnt_r, "%h\n", pcnt_r);
            // $fclose(file_pcnt_r);
        // end
    // end
// end
always @(posedge clk or negedge rst_n) begin : get_pcnt_INI_reg
  if(rst_n == 1'b0) begin
    pcnt_INI_reg <= 'd0;//6_8gai
  end else if(en_r == 1'b1 && y_full_rp == 1'b1 && z_full_rp == 1'b1 && x_full_rp == 1'b1) begin
    pcnt_INI_reg <= 'd0;//finish//6_8gai
  end else if(en_r == 1'b1 && x_full_rp == 1'b1 && z_full_rp == 1'b1 && p_full_rp == 1'b0) begin
    pcnt_INI_reg <= pcnt_r + 1'b1;
  end else if(en_r == 1'b1 && x_full_rp == 1'b1 && z_full_rp == 1'b1 && p_full_rp == 1'b1) begin
    pcnt_INI_reg <= 'd128;
  end
end

always @(posedge clk or negedge rst_n) begin : get_cnt49_r
  if(rst_n == 1'b0) begin
    cnt49_r <= 'd0;//6_8gai
  end else if(en_r == 1'b1 && y_full_rp == 1'b1 && z_full_rp == 1'b1 && x_full_rp == 1'b1) begin
    cnt49_r <= 'd0;//finish//6_8gai
  end else if(en_r == 1'b1 && x_full_rp == 1'b1 && z_full_rp == 1'b1 && p_full_rp == 1'b0) begin
    cnt49_r <= cnt49_r + 'd49;//last z last x pcnt no full
  end else if(en_r == 1'b1 && x_full_rp == 1'b1 && z_full_rp == 1'b1 && p_full_rp == 1'b1) begin
    cnt49_r <= 'd6272;//last z last x pcnt full     128*49 = 6272
  end else if(en_r == 1'b1 && x_full_rp == 1'b1) begin
    cnt49_r <= cnt49_INI_reg;//next z
  end else if(en_r == 1'b1 && p_full_rp == 1'b1) begin
    cnt49_r <= 'd6272;//working  pcnt full     128*49 = 6272
  end else if(en_r == 1'b1) begin
    cnt49_r <= cnt49_r + 'd49;//working  pcnt no full
  end
end

always @(posedge clk or negedge rst_n) begin : get_cnt49_INI_reg
  if(rst_n == 1'b0) begin
    cnt49_INI_reg <= 'd0;//16*48//6_8gai
  end else if(en_r == 1'b1 && y_full_rp == 1'b1 && z_full_rp == 1'b1 && x_full_rp == 1'b1) begin
    cnt49_INI_reg <= 'd0;//finish//6_8gai
  end else if(en_r == 1'b1 && x_full_rp == 1'b1 && z_full_rp == 1'b1 && p_full_rp == 1'b0) begin
    cnt49_INI_reg <= cnt49_r + 'd49;
  end else if(en_r == 1'b1 && x_full_rp == 1'b1 && z_full_rp == 1'b1 && p_full_rp == 1'b1) begin
    cnt49_INI_reg <= 'd6272;
  end
end
/**************************************stream1******************************************/
always @(xcnt_r,Nx_r) begin : get_x_full_rp
  if(xcnt_r == Nx_r-1'b1) begin
    x_full_rp <= 1'b1;
  end else begin
    x_full_rp <= 1'b0;
  end
end
always @(ycnt_r,Ny_r) begin : get_y_full_rp
  if(ycnt_r == Ny_r-1'b1) begin
    y_full_rp <= 1'b1;
  end else begin
    y_full_rp <= 1'b0;
  end
end
always @(zcnt_r,Nz_r) begin : get_z_full_rp
  if(zcnt_r == Nz_r-1'b1) begin
    z_full_rp <= 1'b1;
  end else begin
    z_full_rp <= 1'b0;
  end
end
always @(pcnt_r) begin : get_p_full_rp
  if(pcnt_r == 'd255) begin
    p_full_rp <= 1'b1;
  end else begin
    p_full_rp <= 1'b0;
  end
end
always @(ycnt_r) begin : get_y_zero_rp
  if(ycnt_r == 'd0) begin
    y_zero_rp <= 1'b1;
  end else begin
    y_zero_rp <= 1'b0;
  end
end
always @(xcnt_r) begin : get_x_zero_rp
  if(xcnt_r == 'd0) begin
    x_zero_rp <= 1'b1;
  end else begin
    x_zero_rp <= 1'b0;
  end
end
always @(x_zero_rp,y_zero_rp) begin : get_en_spec_fst
  if(x_zero_rp == 1'b1 && y_zero_rp == 1'b1) begin
    en_spec_fst <= 1'b1;//第一行换谱段第一个数
  end else begin
    en_spec_fst <= 1'b0;
  end
end
always @(xcnt_r,y_zero_rp) begin : get_en_yzero_chge_spec
  if(xcnt_r[X_LEN-1:1] == 1'b0 && y_zero_rp == 1'b1) begin
    en_yzero_chge_spec <= 1'b1;//第一行换谱段前两个数
  end else begin
    en_yzero_chge_spec <= 1'b0;
  end
end
always @(x_full_rp,y_zero_s1_rpp,Nz_r )begin : get_en_chge_spec
  if(x_full_rp == 1'b1 && y_zero_s1_rpp == 1'b0 && Nz_r >1) begin
    en_chge_spec <= 1'b1;//除了第一行换谱段
  end else begin
    en_chge_spec <= 1'b0;
  end
end
always @(xcnt_r,y_zero_rp) begin : get_k_INI_en_rp
  if(xcnt_r < 2 && y_zero_rp == 1'b1) begin
    k_INI_en_rp <= 1'b1;
  end else begin
    k_INI_en_rp <= 1'b0;
  end
end
always @(y_zero_rp,z_full_rp) begin : get_y_zero_s1_rpp
  y_zero_s1_rpp <= y_zero_rp & (~z_full_rp);
end
always @(x_full_r2,y_zero_s1_r2,r_RAM_data_reg,acc_upt_r2,Nz_r) begin : get_acc_slt_rp
  if(x_full_r2 == 1'b1 && y_zero_s1_r2 == 1'b0 && Nz_r >1) begin
    acc_slt_rp <= r_RAM_data_reg;
  end else if(x_full_r2 == 1'b1 && y_zero_s1_r2 == 1'b1) begin
    acc_slt_rp <= 'd24;
  end else begin
    acc_slt_rp <= acc_upt_r2;
  end
end
// always @(acc_slt_rp,alpha_r,x_zero_rp,y_zero_rp,p_full_rp) begin : get_acc_rpp
  // if(x_zero_rp == 1'b1 && (y_zero_rp == 1'b1)) begin
    // acc_rpp <= 'd5;
  // end else if(p_full_rp == 1'b1) begin
    // acc_rpp <= acc_slt_rp + alpha_r + 1;
  // end else begin
    // acc_rpp <= acc_slt_rp + alpha_r;
  // end
// end

always @(acc_slt_rp,alpha_r,x_zero_rp,y_zero_rp,p_full_rp) begin : get_acc_rpp
  if(x_zero_rp == 1'b1 && (y_zero_rp == 1'b1)) begin
    acc_rpp <= 'd24;
  end else if(p_full_rp == 1'b1) begin
    acc_rpp <= acc_slt_rp + {alpha_r,2'b01};
  end else begin
    acc_rpp <= acc_slt_rp + {alpha_r,2'b00};
  end
end

always @(p_full_rp,acc_rpp) begin : get_acc_rppp
  if(p_full_rp == 1'b1) begin
    acc_rppp <= {1'b0,acc_rpp[ACC_WIDTH-1:1]};
  end else begin
    acc_rppp <= acc_rpp;
  end
end

/***************************************************************************************/
/**************************************regist2******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : regist2
  if(rst_n == 1'b0) begin
    acc_upt_r2   <=  'd24;
    acc_crt_r2   <=  'd24;
    acc_crt_r2_rl<=  'd393216;
    ac_crt_r2    <=  'd6;
    x_full_r2    <= 1'b0;
    y_zero_s1_r2 <= 1'b0;
    zcnt_r2      <=  'd0;
    pcnt_r2      <=  'd0;
    cnt49_r2     <=  'd0;
    k_INI_en_r2  <= 1'b0;
    // AP_empty_r2  <= 'd0;
    // xcnt_r2      <= 'd0;
    // en_spec_fst_r2 <= 'd0;
    // en_chge_spec_r2<= 'd0;
    en_yzero_chge_spec_r2<= 'd0;
  end else if(en_r == 1'b1) begin
    acc_upt_r2   <= acc_rppp;
    acc_crt_r2   <= acc_slt_rp;
    acc_crt_r2_rl<= {acc_slt_rp,{14{1'b0}}};
    ac_crt_r2    <= acc_slt_rp[ACC_WIDTH-1:2];
    x_full_r2    <= x_full_rp;
    y_zero_s1_r2 <= y_zero_s1_rpp;
    zcnt_r2      <= zcnt_r;
    pcnt_r2      <= pcnt_r;
    cnt49_r2     <= cnt49_r;
    k_INI_en_r2  <= k_INI_en_rp;
    // AP_empty_r2  <= AP_empty_r;
    // xcnt_r2      <= xcnt_r;
    // en_spec_fst_r2 <=en_spec_fst;
    // en_chge_spec_r2<= en_chge_spec;
    en_yzero_chge_spec_r2<= en_yzero_chge_spec;
  end
end
// always @(posedge clk) begin
    // if (en_r2 == 1'b1) begin
        // file_acc = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/acc_crt_r2.txt", "a"); 
        // if (file_acc != 0 ) begin
            // $fwrite(file_acc, "%h\n", acc_crt_r2);
            // $fclose(file_acc);
        // end
    // end
// end
// always @(posedge clk) begin
    // if (en_r2 == 1'b1) begin
        // file_ac = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/ac_crt_r2.txt", "a"); 
        // if (file_ac != 0 ) begin
            // $fwrite(file_ac, "%h\n", ac_crt_r2);
            // $fclose(file_ac);
        // end
    // end
// end
// always @(posedge clk) begin
    // if (en_r2 == 1'b1) begin
        // file_pcnt_r = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/pcnt_r2.txt", "a"); 
        // if (file_pcnt_r != 0 ) begin
            // $fwrite(file_pcnt_r, "%h\n", pcnt_r2);
            // $fclose(file_pcnt_r);
        // end
    // end
// end
always @(posedge clk or negedge rst_n) begin : get_index_up_low
  if(rst_n == 1'b0) begin
    index_0    <= 'd0;
    index_1    <= 'd0;
    index_2    <= 'd0;
    index_3    <= 'd0;
    index_4    <= 'd0;
    index_5    <= 'd0;
    index_6    <= 'd0;
    index_7    <= 'd0;
    index_8    <= 'd0;
    index_9    <= 'd0;
    index_10   <= 'd0;
    index_11   <= 'd0;
    index_12   <= 'd0;
  end else if(en_r == 1'b1) begin
    index_0    <= 303336*pcnt_r ;
    index_1    <= 225404*pcnt_r ;
    index_2    <= 166979*pcnt_r ;
    index_3    <= 128672*pcnt_r ;
    index_4    <= 95597*pcnt_r  ;
    index_5    <= 69670*pcnt_r  ;
    index_6    <= 50678*pcnt_r  ;
    index_7    <= 34898*pcnt_r  ;
    index_8    <= 23331*pcnt_r  ;
    index_9    <= 14935*pcnt_r  ;
    index_10   <= 9282*pcnt_r   ;
    index_11   <= 5510*pcnt_r   ;
    index_12   <= 3195*pcnt_r   ;  
  end                 
end

always@(index_0,index_1,acc_crt_r2_rl) begin : get_index_num0
    if(index_0>=acc_crt_r2_rl && index_1<acc_crt_r2_rl)begin
        index_num0 <= 1'b1;
    end else begin
        index_num0 <= 1'b0;
    end
end
always@(index_1,index_2,acc_crt_r2_rl) begin : get_index_num1
    if(index_1>=acc_crt_r2_rl && index_2<acc_crt_r2_rl)begin
        index_num1 <= 1'b1;
    end else begin
        index_num1 <= 1'b0;
    end
end
always@(index_2,index_3,acc_crt_r2_rl) begin : get_index_num2
    if(index_2>=acc_crt_r2_rl && index_3<acc_crt_r2_rl)begin
        index_num2 <= 1'b1;
    end else begin
        index_num2 <= 1'b0;
    end
end
always@(index_3,index_4,acc_crt_r2_rl) begin : get_index_num3
    if(index_3>=acc_crt_r2_rl && index_4<acc_crt_r2_rl)begin
        index_num3 <= 1'b1;
    end else begin
        index_num3 <= 1'b0;
    end
end
always@(index_4,index_5,acc_crt_r2_rl) begin : get_index_num4
    if(index_4>=acc_crt_r2_rl && index_5<acc_crt_r2_rl)begin
        index_num4 <= 1'b1;
    end else begin
        index_num4 <= 1'b0;
    end
end
always@(index_5,index_6,acc_crt_r2_rl) begin : get_index_num5
    if(index_5>=acc_crt_r2_rl && index_6<acc_crt_r2_rl)begin
        index_num5 <= 1'b1;
    end else begin
        index_num5 <= 1'b0;
    end
end
always@(index_6,index_7,acc_crt_r2_rl) begin : get_index_num6
    if(index_6>=acc_crt_r2_rl && index_7<acc_crt_r2_rl)begin
        index_num6 <= 1'b1;
    end else begin
        index_num6 <= 1'b0;
    end
end
always@(index_7,index_8,acc_crt_r2_rl) begin : get_index_num7
    if(index_7>=acc_crt_r2_rl && index_8<acc_crt_r2_rl)begin
        index_num7 <= 1'b1;
    end else begin
        index_num7 <= 1'b0;
    end
end
always@(index_8,index_9,acc_crt_r2_rl) begin : get_index_num8
    if(index_8>=acc_crt_r2_rl && index_9<acc_crt_r2_rl)begin
        index_num8 <= 1'b1;
    end else begin
        index_num8 <= 1'b0;
    end
end
always@(index_9,index_10,acc_crt_r2_rl) begin : get_index_num9
    if(index_9>=acc_crt_r2_rl && index_10<acc_crt_r2_rl)begin
        index_num9 <= 1'b1;
    end else begin
        index_num9 <= 1'b0;
    end
end
always@(index_10,index_11,acc_crt_r2_rl) begin : get_index_num10
    if(index_10>=acc_crt_r2_rl && index_11<acc_crt_r2_rl)begin
        index_num10 <= 1'b1;
    end else begin
        index_num10 <= 1'b0;
    end
end
always@(index_11,index_12,acc_crt_r2_rl) begin : get_index_num11
    if(index_11>=acc_crt_r2_rl && index_12<acc_crt_r2_rl)begin
        index_num11 <= 1'b1;
    end else begin
        index_num11 <= 1'b0;
    end
end

always @(index_num0,index_num1,index_num2,index_num3,index_num4,index_num5,index_num6,index_num7,index_num8,index_num9,index_num10,index_num11) begin :get_index_total
    index_total <= {index_num11,index_num10,index_num9,index_num8,index_num7,index_num6,index_num5,index_num4,index_num3,index_num2,index_num1,index_num0};
end
// always @(posedge clk) begin
    // if (en_r == 1'b1) begin
        // file_k_r6pp = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/acc.txt", "a"); 
        // if (file_k_r6pp != 0 ) begin
            // $fwrite(file_k_r6pp, "%10h\n", acc_slt_rp);
            // $fclose(file_k_r6pp);
        // end
    // end
// end

always @(posedge clk or negedge rst_n) begin : get_alpha_r2
  if(rst_n == 1'b0) begin
    alpha_r2     <=  'd0;
  end else if(en_r == 1'b1 && x_zero_rp == 1'b1 && y_zero_rp == 1'b1) begin//每一个
    alpha_r2     <= S_r;
  end else if(en_r == 1'b1) begin
    alpha_r2     <= alpha_r;
  end
end

always @(posedge clk or negedge rst_n) begin : regist3
  if(rst_n == 1'b0) begin
    alpha_r3     <=  'd0;
    k_INI_en_r3  <= 1'b0;
    index_total_r3<= 'd0;
    // AP_empty_r3   <= 'd0;
    // en_spec_fst_r3<= 'd0;
    // xcnt_r3      <= 'd0;
    // w_RAM_cnt_en_r3<= 'd0;
    // zcnt_r3      <= 'd0;
    // r_cnt_RAM_en_r3<= 'd0;
    // r_RAM_cnt_ad_r3<= 'd0;
    // en_chge_spec_r3<= 'd0;
    en_yzero_chge_spec_r3<= 'd0;
    x_full_r3       <= 'd0;
  end else if(en_r2 == 1'b1) begin
    alpha_r3     <= alpha_r2;
    k_INI_en_r3  <= k_INI_en_r2;
    index_total_r3<= index_total;
    // AP_empty_r3   <= AP_empty_r2;
    // en_spec_fst_r3<= en_spec_fst_r2;
    // xcnt_r3      <= xcnt_r2;
    // w_RAM_cnt_en_r3<= w_RAM_cnt_en_r2;
    // zcnt_r3      <= zcnt_r2;
    // r_cnt_RAM_en_r3<= r_RAM_en;
    // r_RAM_cnt_ad_r3<= r_RAM_addr;
    // en_chge_spec_r3<= en_chge_spec_r2;
    en_yzero_chge_spec_r3<= en_yzero_chge_spec_r2;
    x_full_r3       <= x_full_r2;
  end
end
always @(index_total_r3) begin : get_index_mby
    case(index_total_r3) 
        12'b000000000001 : index_mby <= 4'd0  ;
        12'b000000000010 : index_mby <= 4'd1  ;
        12'b000000000100 : index_mby <= 4'd2  ;
        12'b000000001000 : index_mby <= 4'd3  ;
        12'b000000010000 : index_mby <= 4'd4  ;
        12'b000000100000 : index_mby <= 4'd5  ;
        12'b000001000000 : index_mby <= 4'd6  ;
        12'b000010000000 : index_mby <= 4'd7  ;
        12'b000100000000 : index_mby <= 4'd8  ;
        12'b001000000000 : index_mby <= 4'd9  ;
        12'b010000000000 : index_mby <= 4'd10 ;
        12'b100000000000 : index_mby <= 4'd11 ;
        default : index_mby <= 4'b1111;
    endcase
end

/***************************************************************************************/
/**************************************regist4******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : regist4
  if(rst_n == 1'b0) begin
    k_INI_en_r4  <= 1'b0;
    index_mby_r4 <= 1'b0;
    // index_mby_old<= 'd0;
    // AP_empty_r4  <= 'd0;
    // en_spec_fst_r4<= 'd0;
    // xcnt_r4      <= 'd0;
    // w_RAM_cnt_en_r4<= 'd0;
    // zcnt_r4      <= 'd0;
    // r_cnt_RAM_en_r4<= 'd0;
    // r_RAM_cnt_ad_r4<= 'd0;
    // en_chge_spec_r4<= 'd0;
    en_yzero_chge_spec_r4<= 'd0;
    x_full_r4       <= 'd0;
  end else if(en_r3 == 1'b1) begin
    k_INI_en_r4  <= k_INI_en_r3;
    index_mby_r4 <= index_mby;
    // index_mby_old<= index_mby_r4;
    // AP_empty_r4  <= AP_empty_r3;
    // en_spec_fst_r4<= en_spec_fst_r3;
    // xcnt_r4      <= xcnt_r3;
    // w_RAM_cnt_en_r4<= w_RAM_cnt_en_r3;
    // zcnt_r4      <= zcnt_r3;
    // r_cnt_RAM_en_r4<= r_cnt_RAM_en_r3;
    // r_RAM_cnt_ad_r4<= r_RAM_cnt_ad_r3;
    // en_chge_spec_r4<= en_chge_spec_r3;
    en_yzero_chge_spec_r4<= en_yzero_chge_spec_r3;
    x_full_r4       <= x_full_r3;
  end
end

// always @(posedge clk) begin
    // if (en_r4 == 1'b1) begin
        // file_k_r6pp = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/index_mby_test.txt", "a"); 
        // if (file_k_r6pp != 0 ) begin
            // $fwrite(file_k_r6pp, "%h\n", index_mby_r4);
            // $fclose(file_k_r6pp);
        // end
    // end
// end
/***************************************************************************************/
/**************************************regist5******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : regist5
  if(rst_n == 1'b0) begin
    k_INI_en_r5   <= 1'b0;
    index_mby_r5  <= 'd0;
    // index_mby_old_r5<= 'd0;
    // en_chge_req_r5<= 'd0;
    // AP_empty_r5   <= 'd0;
    // en_spec_fst_r5<= 'd0;
    // xcnt_r5      <= 'd0;
    // w_RAM_cnt_en_r5<= 'd0;
    // zcnt_r5      <= 'd0;
    // r_cnt_RAM_en_r5<= 'd0;
    // en_chge_spec_r5<= 'd0;
    en_yzero_chge_spec_r5<= 'd0;
    x_full_r5       <= 'd0;
  end else if(en_r4 == 1'b1) begin
    k_INI_en_r5   <= k_INI_en_r4;
    index_mby_r5  <= index_mby_r4;
    // index_mby_old_r5 <= index_mby_old;
    // en_chge_req_r5<= en_chge_req;
    // AP_empty_r5   <= AP_empty_r4;
    // en_spec_fst_r5<= en_spec_fst_r4;
    // xcnt_r5       <= xcnt_r4;
    // w_RAM_cnt_en_r5<= w_RAM_cnt_en_r4;
    // zcnt_r5      <= zcnt_r4;
    // r_cnt_RAM_en_r5<= r_cnt_RAM_en_r4;
    // r_RAM_cnt_ad_r5<= r_RAM_cnt_ad_r4;
    // en_chge_spec_r5<= en_chge_spec_r4;
    en_yzero_chge_spec_r5<= en_yzero_chge_spec_r4;
    x_full_r5       <= x_full_r4;
  end
end

// always @(index_mby_r5,index_now) begin : get_chge_index_req
    // chge_index_req <= index_mby_r5 - index_now;
// end

// always @(chge_index_req) begin : get_en_chge_index_req
    // if(chge_index_req == 'd0)begin
        // en_chge_req <= 1'b0;
    // end else begin
        // en_chge_req <= 1'b1;
    // end
// end

// always @(posedge clk or negedge rst_n) begin : get_count_cnt
    // if(rst_n == 1'b0) begin
        // count_cnt <= 'd0;
    // end else if(en_r4 == 1'b1 && en_chge_spec_r5 == 1'b1)begin
        // count_cnt <= r_RAM_count + 1;
    // end else if(en_r4 == 1'b1 && en_yzero_chge_spec_r4== 1'b1)begin
        // count_cnt <= 'd0;
    // end else if(en_r4 == 1'b1 && en_count_zero == 1'b1)begin
        // count_cnt <= 'd1;
    // end else if(en_r4 == 1'b1 && count_INI == 1'b1)begin
        // count_cnt <= 6'b100000;
    // end else if(en_r4 == 1'b1)begin
        // count_cnt <= count_cnt+1;
    // end
// end
// always @(posedge clk) begin
    // if (en_r5 == 1'b1) begin
        // file_k_r6pp = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/count_cnt.txt", "a"); 
        // if (file_k_r6pp != 0 ) begin
            // $fwrite(file_k_r6pp, "%h\n", count_cnt);
            // $fclose(file_k_r6pp);
        // end
    // end
// end
// always@(count_cnt) begin :get_count_INI
    // if(count_cnt[5] == 1'b1)begin
        // count_INI <= 1'b1;
    // end else begin
        // count_INI <= 1'b0;
    // end
// end

// always @(index_mby_r5,index_mby_old_r5,count_INI,AP_empty_r5,en_chge_req,en_spec_fst_r5) begin : get_index_real
    // if(count_INI == 1'b1 && AP_empty_r5 == 1'b1 && en_chge_req == 1'b1 || en_spec_fst_r5 == 1'b1)begin

        // en_count_zero<= 1'b1;
    // end else begin 

        // en_count_zero<= 1'b0;
    // end
// end 

// always @(posedge clk or negedge rst_n) begin : get_index_now
    // if(rst_n == 1'b0)begin
        // index_now <= 5'b11111;
    // end else if(en_r4 == 1'b1 && en_chge_spec_r5 == 1'b1)begin
        // index_now <= r_RAM_preindex;
    // end else if(en_count_zero == 1'b1)begin
        // index_now <= index_mby_r5;
    // end else begin
        // index_now <= index_now;
    // end
// end 

// always @(index_now,alpha_r6) begin :get_index_data_max
    // case(index_now)
        // 5'd0   :  index_data_max <= 'd12  ;
        // 5'd1   :  index_data_max <= 'd10  ;
        // 5'd2   :  index_data_max <= 'd8   ;
        // 5'd3   :  index_data_max <= 'd6   ;
        // 5'd4   :  index_data_max <= 'd6   ;
        // 5'd5   :  index_data_max <= 'd4   ;
        // 5'd6   :  index_data_max <= 'd4   ;
        // 5'd7   :  index_data_max <= 'd4   ;
        // 5'd8   :  index_data_max <= 'd2   ;
        // 5'd9   :  index_data_max <= 'd2   ;
        // 5'd10  :  index_data_max <= 'd2   ;
        // 5'd11  :  index_data_max <= 'd2   ;
        // default   index_data_max <= 5'b11111;
    // endcase
// end

// always @(index_data_max,alpha_r6) begin : get_dif_alpha_index
    // dif_alpha_index <= alpha_r6 - {{DATA_WIDTH+1-1-4{1'b0}},index_data_max};
// end 

// always @(dif_alpha_index) begin :  get_en_x
    // if(dif_alpha_index[DATA_WIDTH+1-1] == 0)begin
        // en_x <= 1'b1;
    // end else begin
        // en_x <= 1'b0;
    // end
// end

// always @(index_now,en_r5) begin : get_low_entropy_vaild
    // if(index_now[4] == 1'b0 && en_r5 == 1'b1)begin
        // low_entropy_vaild <= 1'b1;
    // end else begin
        // low_entropy_vaild <= 1'b0;
    // end
// end
// always @(posedge clk) begin
    // if (en_r6 == 1'b1) begin
        // file_k_r6pp = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/index_now.txt", "a"); 
        // if (file_k_r6pp != 0 ) begin
            // $fwrite(file_k_r6pp, "%h\n", index_now);
            // $fclose(file_k_r6pp);
        // end
    // end
// end
/***************************************************************************************/
/**************************************regist6******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : regist6
  if(rst_n == 1'b0) begin
    k2_bflag_r6      <= 1'b0;
    k_INI_en_r6      <= 1'b0;
    // index_real_r6    <= 'd0;
    // xcnt_r6          <= 'd0;
    // index_data_max_r6<= 'd0;
    x_full_r6        <= 'd0;
    alpha_r6         <= 'd0;
    // en_x_r6          <= 'd0;
    // low_entropy_vaild_r6<= 'd0;
    index_mby_r6 <= 'd0;
    en_yzero_chge_spec_r6 <= 'd0;
  end else if(en_r5 == 1'b1) begin
    k2_bflag_r6       <= k2_bflag_r5;
    k_INI_en_r6       <= k_INI_en_r5;
    // index_real_r6     <= index_now;
    // xcnt_r6           <= xcnt_r5;
    // index_data_max_r6 <= index_data_max;
    x_full_r6         <= x_full_r5;
    alpha_r6          <= alpha_r5;
    // en_x_r6           <= en_x;
    // low_entropy_vaild_r6<= low_entropy_vaild;
    index_mby_r6 <= index_mby_r5;
    en_yzero_chge_spec_r6 <= en_yzero_chge_spec_r5;
  end
end
/**************************************steam6******************************************/

assign k_one_num_r6 = {k14_bflag_r6,k14_sflag_r6,
                       k12_bflag_r6,k12_sflag_r6,
                       k10_bflag_r6,k10_sflag_r6,
                       k8_bflag_r6 ,k8_sflag_r6,
                       k6_bflag_r6 ,k6_sflag_r6,
                       k4_bflag_r6 ,k4_sflag_r6,
                       k2_bflag_r6 ,
                       k1_bflag_r6 ,k1_sflag_r6};

always @(k_one_num_r6) begin : get_k_r6p
 case (k_one_num_r6)
   15'b000000000000001 : k_r6p <= 4'd0;
   15'b000000000000010 : k_r6p <= 4'd1;
   15'b000000000000100 : k_r6p <= 4'd2;
   15'b000000000001000 : k_r6p <= 4'd3;
   15'b000000000010000 : k_r6p <= 4'd4;
   15'b000000000100000 : k_r6p <= 4'd5;
   15'b000000001000000 : k_r6p <= 4'd6;
   15'b000000010000000 : k_r6p <= 4'd7;
   15'b000000100000000 : k_r6p <= 4'd8;
   15'b000001000000000 : k_r6p <= 4'd9;
   15'b000010000000000 : k_r6p <= 4'd10;
   15'b000100000000000 : k_r6p <= 4'd11;
   15'b001000000000000 : k_r6p <= 4'd12;
   15'b010000000000000 : k_r6p <= 4'd13;
   15'b100000000000000 : k_r6p <= 4'd14;
   default : k_r6p <= 4'd0;
 endcase
end
always @(k_INI_en_r6,k_r6p) begin : get_k_r6pp
  if(k_INI_en_r6 == 1'b1) begin
    k_r6pp <= 'd15;
  end else begin
    k_r6pp <= k_r6p;
  end
end


/***************************************************************************************/
/**************************************regist7******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : regist7
  if(rst_n == 1'b0) begin
    k_r7 <= 'd0;
    // index_real_r7<= 'd0;
    x_full_r7       <= 'd0;
    // index_mby_r7    <= 'd0;
  end else if(en_r6 == 1'b1) begin
    k_r7 <= k_r6pp;
    // index_real_r7<= index_real_r6;
    x_full_r7       <= x_full_r6; 
    // index_mby_r7    <= index_mby_r6;
  end
end
always @(posedge clk or negedge rst_n) begin : get_index_mby_r7
    if(rst_n == 1'b0) begin
        index_mby_r7 <= 'd0;
    end else if(en_yzero_chge_spec_r6 == 1'b1) begin
        index_mby_r7 <= 4'b1111;
    end else if(en_r6 == 1'b1)begin
        index_mby_r7 <= index_mby_r6;
    end
end
assign index_mby_o       = index_mby_r7;
// assign alpha_delta_o     = alpha_r7[3:0];
assign en_last_o         = x_full_r7  ;
// assign index_data_max_o  = index_data_max_r6;
// assign chge_spec_o       = x_full_r7;

// assign low_entropy_vaild_o = low_entropy_vaild_r6;


assign alpha_o           = alpha_r7;
assign en_o              = en_r7;
assign k_o               = k_r7;
/***************************************************************************************/
/**************************************for ram******************************************/
/***************************************************************************************/
always @(x_full_r2, en_r2, r_RAM_addr, Nz_r, y_zero_s1_r2) begin : get_r_RAM_addr_p
  if((x_full_r2 == 1'b1 && en_r2 && r_RAM_addr == Nz_r-1'b1) || (y_zero_s1_r2 == 1'b1)) begin
    r_RAM_addr_p <= 'd0;
  end else begin
    r_RAM_addr_p <= r_RAM_addr + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_r_RAM_addr
  if(rst_n == 1'b0) begin
    r_RAM_addr <= 'd0;
  end else if((x_full_r2 == 1'b1 && en_r2) || y_zero_s1_r2 == 1'b1) begin
    r_RAM_addr <= r_RAM_addr_p;
  end
end
always @(posedge clk or negedge rst_n) begin : get_r_RAM_en
  if(rst_n == 1'b0) begin
    r_RAM_en <= 1'b0;
  end else if(xcnt_r == Nx_r-3) begin
    r_RAM_en <= 1'b1;
  end else begin
    r_RAM_en <= 1'b0;
  end
end
// always @(x_full_r2,en_r2)begin
    // w_RAM_cnt_en_r2 <= x_full_r2&en_r2;
// end
assign w_RAM_data = acc_upt_r2;
assign w_RAM_en   = x_full_r2&en_r2;
// always @(en_count_zero, count_cnt, w_RAM_cnt_en_r5)begin
    // if(en_count_zero == 1'b1 && w_RAM_cnt_en_r5 == 1'b1)begin
        // count_cnt_ram <= 'd0;
    // end else begin
        // count_cnt_ram <= count_cnt;
    // end
// end
// assign w_RAM_count = count_cnt_ram;
// assign w_RAM_cnt_en = w_RAM_cnt_en_r5;

// always @(en_count_zero, index_now,index_mby_r5, w_RAM_cnt_en_r5)begin
    // if(en_count_zero == 1'b1 && w_RAM_cnt_en_r5 == 1'b1)begin
        // index_now_ram <= index_mby_r5;
    // end else begin
        // index_now_ram <= index_now;
    // end
// end
// assign w_RAM_preindex = index_now_ram;
// wight_ram31x160 acc_ram (
  // .clka      (clk),    // input wire clka
  // .ena       (w_RAM_en),    // input wire ena
  // .wea       (w_RAM_en),    // input wire [0 : 0] wea
  // .addra     (zcnt_r2),  // input wire [7 : 0] addra
  // .dina      ({{38-ACC_WIDTH{1'b0}},w_RAM_data}),   // input wire [30 : 0] dina
  // .clkb      (clk),    // input wire clkb
  // .enb       (r_RAM_en),    // input wire enb
  // .addrb     (r_RAM_addr),  // input wire [7 : 0] addrb
  // .doutb     (r_RAM_data)   // output wire [30 : 0] doutb
// );
// wight_ram31x160 accn_ram (
  // .clka(clk),    // input wire clka
  // .ena(w_RAM_en),      // input wire ena
  // .wea(w_RAM_en),      // input wire [0 : 0] wea
  // .addra(zcnt_r2),  // input wire [7 : 0] addra
  // .dina({{38-ACC_WIDTH{1'b0}},w_RAM_data}),    // input wire [37 : 0] dina
  // .clkb(clk),    // input wire clkb
  // .enb(r_RAM_en),      // input wire enb
  // .addrb(r_RAM_addr),  // input wire [7 : 0] addrb
  // .doutb(r_RAM_data)  // output wire [37 : 0] doutb
// );
acc_ram39x160 acc_ram_inst (
  .clka(clk),    // input wire clka
  .ena(w_RAM_en),      // input wire ena
  .wea(w_RAM_en),      // input wire [0 : 0] wea
  .addra(zcnt_r2),  // input wire [7 : 0] addra
  .dina({{(39-ACC_WIDTH){1'b0}}, w_RAM_data}),    // input wire [38 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(r_RAM_en),      // input wire enb
  .addrb(r_RAM_addr),  // input wire [7 : 0] addrb
  .doutb(r_RAM_data)  // output wire [38 : 0] doutb
);
// count_ram5x160 count_ram (
  // .clka(clk),    // input wire clka
  // .ena(w_RAM_cnt_en),      // input wire ena
  // .wea(w_RAM_cnt_en),      // input wire [0 : 0] wea
  // .addra(zcnt_r5),  // input wire [7 : 0] addra
  // .dina(w_RAM_count),    // input wire [5 : 0] dina
  // .clkb(clk),    // input wire clkb
  // .enb(r_cnt_RAM_en_r5),      // input wire enb
  // .addrb(r_RAM_cnt_ad_r5),  // input wire [7 : 0] addrb
  // .doutb(r_RAM_count)  // output wire [5 : 0] doutb
// );
// prvindex_ram4x160 prvindex_ram (
  // .clka(clk),    // input wire clka
  // .ena(w_RAM_cnt_en),      // input wire ena
  // .wea(w_RAM_cnt_en),      // input wire [0 : 0] wea
  // .addra(zcnt_r5),  // input wire [7 : 0] addra
  // .dina(w_RAM_preindex),    // input wire [3 : 0] dina
  // .clkb(clk),    // input wire clkb
  // .enb(r_cnt_RAM_en_r5),      // input wire enb
  // .addrb(r_RAM_cnt_ad_r5),  // input wire [7 : 0] addrb
  // .doutb(r_RAM_preindex)  // output wire [3 : 0] doutb
// );
/**************************************steam2******************************************/
vcc_cpr #(
  .K           (7),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k7
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (en_r2),
  .pcnt_i      (pcnt_r2),
  .cnt49_i     (cnt49_r2),
  .acc_i       (ac_crt_r2),

  .bflag       (k7_bflag_r3),
  .sflag       (k7_sflag_r3),
  .pcnt_o      (k7_pcnt_r3),
  .cnt49_o     (k7_cnt49_r3),
  .acc_o       (k7_acc_r3)
);
/**************************************steam3******************************************/
vcc_cpr #(
  .K           (3),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k3
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k7_sflag_r3),
  .pcnt_i      (k7_pcnt_r3),
  .cnt49_i     (k7_cnt49_r3),
  .acc_i       (k7_acc_r3),

  .bflag       (k3_bflag_r4),
  .sflag       (k3_sflag_r4),
  .pcnt_o      (k3_pcnt_r4),
  .cnt49_o     (k3_cnt49_r4),
  .acc_o       (k3_acc_r4)
);
vcc_cpr #(
  .K           (11),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k11
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k7_bflag_r3),
  .pcnt_i      (k7_pcnt_r3),
  .cnt49_i     (k7_cnt49_r3),
  .acc_i       (k7_acc_r3),

  .bflag       (k11_bflag_r4),
  .sflag       (k11_sflag_r4),
  .pcnt_o      (k11_pcnt_r4),
  .cnt49_o     (k11_cnt49_r4),
  .acc_o       (k11_acc_r4)
);
/**************************************steam4******************************************/
vcc_cpr #(
  .K           (2),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k2
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k3_sflag_r4),
  .pcnt_i      (k3_pcnt_r4),
  .cnt49_i     (k3_cnt49_r4),
  .acc_i       (k3_acc_r4),

  .bflag       (k2_bflag_r5),
  .sflag       (k2_sflag_r5),
  .pcnt_o      (k2_pcnt_r5),
  .cnt49_o     (k2_cnt49_r5),
  .acc_o       (k2_acc_r5)
);
vcc_cpr #(
  .K           (5),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k5
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k3_bflag_r4),
  .pcnt_i      (k3_pcnt_r4),
  .cnt49_i     (k3_cnt49_r4),
  .acc_i       (k3_acc_r4),

  .bflag       (k5_bflag_r5),
  .sflag       (k5_sflag_r5),
  .pcnt_o      (k5_pcnt_r5),
  .cnt49_o     (k5_cnt49_r5),
  .acc_o       (k5_acc_r5) 
);
vcc_cpr #(
  .K           (9),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k9
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k11_sflag_r4),
  .pcnt_i      (k11_pcnt_r4),
  .cnt49_i     (k11_cnt49_r4),
  .acc_i       (k11_acc_r4),

  .bflag       (k9_bflag_r5),
  .sflag       (k9_sflag_r5),
  .pcnt_o      (k9_pcnt_r5),
  .cnt49_o     (k9_cnt49_r5),
  .acc_o       (k9_acc_r5) 
);
vcc_cpr #(
  .K           (13),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k13
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k11_bflag_r4),
  .pcnt_i      (k11_pcnt_r4),
  .cnt49_i     (k11_cnt49_r4),
  .acc_i       (k11_acc_r4),

  .bflag       (k13_bflag_r5),
  .sflag       (k13_sflag_r5),
  .pcnt_o      (k13_pcnt_r5),
  .cnt49_o     (k13_cnt49_r5),
  .acc_o       (k13_acc_r5) 
);
/**************************************steam5******************************************/
vcc_cpr #(
  .K           (1),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k1
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k2_sflag_r5),
  .pcnt_i      (k2_pcnt_r5),
  .cnt49_i     (k2_cnt49_r5),
  .acc_i       (k2_acc_r5),

  .bflag       (k1_bflag_r6),
  .sflag       (k1_sflag_r6),
  .pcnt_o      (),
  .cnt49_o     (),
  .acc_o       () 
);
vcc_cpr #(
  .K           (4),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k4
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k5_sflag_r5),
  .pcnt_i      (k5_pcnt_r5),
  .cnt49_i     (k5_cnt49_r5),
  .acc_i       (k5_acc_r5),

  .bflag       (k4_bflag_r6),
  .sflag       (k4_sflag_r6),
  .pcnt_o      (),
  .cnt49_o     (),
  .acc_o       () 
);
vcc_cpr #(
  .K           (6),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k6
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k5_bflag_r5),
  .pcnt_i      (k5_pcnt_r5),
  .cnt49_i     (k5_cnt49_r5),
  .acc_i       (k5_acc_r5),

  .bflag       (k6_bflag_r6),
  .sflag       (k6_sflag_r6),
  .pcnt_o      (),
  .cnt49_o     (),
  .acc_o       () 
);
vcc_cpr #(
  .K           (8),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k8
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k9_sflag_r5),
  .pcnt_i      (k9_pcnt_r5),
  .cnt49_i     (k9_cnt49_r5),
  .acc_i       (k9_acc_r5),

  .bflag       (k8_bflag_r6),
  .sflag       (k8_sflag_r6),
  .pcnt_o      (),
  .cnt49_o     (),
  .acc_o       () 
);
vcc_cpr #(
  .K           (10),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k10
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k9_bflag_r5),
  .pcnt_i      (k9_pcnt_r5),
  .cnt49_i     (k9_cnt49_r5),
  .acc_i       (k9_acc_r5),

  .bflag       (k10_bflag_r6),
  .sflag       (k10_sflag_r6),
  .pcnt_o      (),
  .cnt49_o     (),
  .acc_o       () 
);
vcc_cpr #(
  .K           (12),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k12
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k13_sflag_r5),
  .pcnt_i      (k13_pcnt_r5),
  .cnt49_i     (k13_cnt49_r5),
  .acc_i       (k13_acc_r5),

  .bflag       (k12_bflag_r6),
  .sflag       (k12_sflag_r6),
  .pcnt_o      (),
  .cnt49_o     (),
  .acc_o       () 
);
vcc_cpr #(
  .K           (14),
  .ACC_WIDTH   (ACC_WIDTH-2),
  .P_WIDTH     (P_WIDTH),
  .CNT49_WIDTH (CNT49_WIDTH)
)vcc_cpr_k14
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (k13_bflag_r5),
  .pcnt_i      (k13_pcnt_r5),
  .cnt49_i     (k13_cnt49_r5),
  .acc_i       (k13_acc_r5),

  .bflag       (k14_bflag_r6),
  .sflag       (k14_sflag_r6),
  .pcnt_o      (),
  .cnt49_o     (),
  .acc_o       () 
);
//delay2
delay2_new #(     
  .DATA_WIDH   (DATA_WIDTH+1)
)delay3to5_alpha
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (en_r3),
  .data_i      (alpha_r3),

  .en_o        (),
  .data_o      (alpha_r5)
);
delay2_new #(
  .DATA_WIDH   (DATA_WIDTH+1)
)delay5to7_alpha
(
  .clk         (clk),
  .rst_n       (rst_n),

  .en_i        (en_r5),
  .data_i      (alpha_r5),

  .en_o        (),
  .data_o      (alpha_r7)
);
endmodule
