module cal_dn_delta #(
    parameter     DATA_WIDTH = 12,
    parameter     D_WIDTH    = 12+2+1
)
(
    input  wire                     clk,
    input  wire                     rst_n,

    input  wire    [3:0]            sl_num_i,
    input  wire    [4:0]            scan_area_i,

    input  wire    [DATA_WIDTH-1:0] S_i,
    input  wire    [DATA_WIDTH-1:0] Sne_i,
    input  wire    [DATA_WIDTH-1:0] Sn_i,
    input  wire    [DATA_WIDTH-1:0] Snw_i,
    input  wire                     en_i,
    input  wire    [2:0]            mode_i,
    input  wire    [DATA_WIDTH-1:0] cj_fst_i,

    output wire                     en_o,
    output wire    [D_WIDTH-1:0]    dn_o,
    // output wire    [D_WIDTH-1:0]    dw_o,
    output wire    [D_WIDTH-1:0]    dnw_o,
//    output wire    [D_WIDTH-1:0]    dn_ls_o,
//    output wire    [D_WIDTH-1:0]    dw_ls_o,
//    output wire    [D_WIDTH-1:0]    dnw_ls_o,
//    output wire    [D_WIDTH-1:0]    n_dn_ls_o,
//    output wire    [D_WIDTH-1:0]    n_dw_ls_o,
//    output wire    [D_WIDTH-1:0]    n_dnw_ls_o,
    output wire    [D_WIDTH-1:0]    dn_ls_r_o,
    output wire    [D_WIDTH-1:0]    dnw_ls_r_o,
    output wire    [D_WIDTH-1:0]    n_dn_ls_r_o,
    output wire    [D_WIDTH-1:0]    n_dnw_ls_r_o,

   /* output wire    [2:0]            S_med_num_o,
    output wire    [1:0]            S_e0_num_o,
    output wire    [D_WIDTH-1:0]    M_sub_delta_o,
    output wire    [D_WIDTH-1:0]    M_sub_delta1_o,
    output wire    [D_WIDTH-1:0]    n_delta_o,
    output wire    [D_WIDTH-2-1:0]  Sm4_sub_delta_o,
    output wire    [D_WIDTH-2-1:0]  Sm4_sub_delta1_o,
    output wire    [1:0]            delta_low2_o,
    output wire    [D_WIDTH-1:0]    dw_ls_r_o,
    output wire    [D_WIDTH-1:0]    n_dw_ls_r_o,*/

    output wire    [DATA_WIDTH-1:0] S_o,
    output wire    [DATA_WIDTH+2-1:0]delta_o//18
);
// integer                         file_delta_rp;
// integer                         file_dn_r3;
// integer                         file_dw_r3 ;
// integer                         file_dnw_r3;
// integer                         file_delta_r3;

    reg                             en_r;
    reg    [3:0]                    sl_num_r;
    reg    [4:0]                    scan_area_r;
    reg    [DATA_WIDTH-1:0]         S_r;
    //reg    [DATA_WIDTH-1:0]         Sw_r;
    reg    [DATA_WIDTH-1:0]         Sne_r;
    reg    [DATA_WIDTH-1:0]         Sn_r;
    reg    [DATA_WIDTH-1:0]         Snw_r;
  (* keep = "true" *)  reg    [DATA_WIDTH-1:0]         cj_fst_r;
    reg    [DATA_WIDTH-1+2:0]       delta_rp;
    reg    [DATA_WIDTH-1+2:0]       S_dn_rp;
    //reg    [DATA_WIDTH-1+2:0]       S_dw_rp;
    reg    [DATA_WIDTH-1+2:0]       S_dnw_rp;
    //reg    [2:0]                    S_med_num_rp;
    //reg    [1:0]                    S_e0_num_rp;
    reg    [2:0]                    mode_r;

    reg                             en_r2;
    reg    [4:0]                    scan_area_r2;
    reg    [DATA_WIDTH-1+2:0]       delta_r2;
    reg    [DATA_WIDTH-1:0]         S_r2;
   // reg    [D_WIDTH-1:0]            Sm4_sub_delta_r2p;
  //  reg    [D_WIDTH-1:0]            Sm4_sub_delta1_r2p;
    reg    [DATA_WIDTH-1+2:0]       S_dn_r2;
  //  reg    [DATA_WIDTH-1+2:0]       S_dw_r2;
    reg    [DATA_WIDTH-1+2:0]       S_dnw_r2;
    reg    [3:0]                    sl_num_r2;
    reg    [D_WIDTH-1:0]            dn_r2p;
    //reg    [D_WIDTH-1:0]            dw_r2p;
    reg    [D_WIDTH-1:0]            dnw_r2p;
    reg    [D_WIDTH-1:0]            n_dn_r2p;
    //reg    [D_WIDTH-1:0]            n_dw_r2p;
    reg    [D_WIDTH-1:0]            n_dnw_r2p;
    reg    [D_WIDTH-1:0]            dn_sl_r2pp;
    //reg    [D_WIDTH-1:0]            dw_sl_r2pp;
    reg    [D_WIDTH-1:0]            dnw_sl_r2pp;
    reg    [D_WIDTH-1:0]            n_dn_sl_r2pp;
  //  reg    [D_WIDTH-1:0]            n_dw_sl_r2pp;
    reg    [D_WIDTH-1:0]            n_dnw_sl_r2pp;
//    reg    [D_WIDTH-1:0]            dn_sl_r2ppp;
//    reg    [D_WIDTH-1:0]            dw_sl_r2ppp;
//    reg    [D_WIDTH-1:0]            dnw_sl_r2ppp;
//    reg    [D_WIDTH-1:0]            n_dn_sl_r2ppp;
//    reg    [D_WIDTH-1:0]            n_dw_sl_r2ppp;
//    reg    [D_WIDTH-1:0]            n_dnw_sl_r2ppp;
   // reg    [2:0]                    S_med_num_r2;
  //  reg    [1:0]                    S_e0_num_r2;
   // reg    [D_WIDTH-1:0]            M_sub_delta_r2p;
   // reg    [D_WIDTH-1:0]            M_sub_delta1_r2p;
  //  reg    [D_WIDTH-1:0]            n_delta_r2p;
    reg    [2:0]                    mode_r2;

    reg                             en_r3;
    reg    [DATA_WIDTH-1:0]         S_r3;
    reg    [DATA_WIDTH-1+2:0]       delta_r3;
    //reg    [D_WIDTH-1:0]            Sm4_sub_delta_r3;
    //reg    [D_WIDTH-1:0]            Sm4_sub_delta1_r3;
    reg    [D_WIDTH-1:0]            dn_r3;
    reg    [D_WIDTH-1:0]            dw_r3;
    reg    [D_WIDTH-1:0]            dnw_r3;
//    reg    [D_WIDTH-1:0]            dn_sl_r3;
//    reg    [D_WIDTH-1:0]            dw_sl_r3;
//    reg    [D_WIDTH-1:0]            dnw_sl_r3;
//    reg    [D_WIDTH-1:0]            n_dn_sl_r3;
//    reg    [D_WIDTH-1:0]            n_dw_sl_r3;
//    reg    [D_WIDTH-1:0]            n_dnw_sl_r3;
    reg    [D_WIDTH-1:0]            dn_sl_r_r3;
    //reg    [D_WIDTH-1:0]            dw_sl_r_r3;
    reg    [D_WIDTH-1:0]            dnw_sl_r_r3;
    reg    [D_WIDTH-1:0]            n_dn_sl_r_r3;
   // reg    [D_WIDTH-1:0]            n_dw_sl_r_r3;
    reg    [D_WIDTH-1:0]            n_dnw_sl_r_r3;
   // reg    [2:0]                    S_med_num_r3;
    //reg    [1:0]                    S_e0_num_r3;
    //reg    [D_WIDTH-1:0]            M_sub_delta_r3;
   // reg    [D_WIDTH-1:0]            M_sub_delta1_r3;
    //reg    [D_WIDTH-1:0]            n_delta_r3;
   // reg    [1:0]                    delta_low_r3;

//    reg    [D_WIDTH-1:0]            dn_sl_r4;
//    reg    [D_WIDTH-1:0]            dw_sl_r4;
//    reg    [D_WIDTH-1:0]            dnw_sl_r4;
//    reg    [D_WIDTH-1:0]            n_dn_sl_r4;
//    reg    [D_WIDTH-1:0]            n_dw_sl_r4;
//    reg    [D_WIDTH-1:0]            n_dnw_sl_r4;
    reg    [D_WIDTH-1:0]            dn_sl_r_r4;
 //   reg    [D_WIDTH-1:0]            dw_sl_r_r4;
    reg    [D_WIDTH-1:0]            dnw_sl_r_r4;
    reg    [D_WIDTH-1:0]            n_dn_sl_r_r4;
  //  reg    [D_WIDTH-1:0]            n_dw_sl_r_r4;
    reg    [D_WIDTH-1:0]            n_dnw_sl_r_r4;
  // integer                         file_Sm4_sub_delta_r2p;
 /***************************************************************************************/
 /**************************************regist1******************************************/
 /***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : register1
  if(rst_n == 1'b0) begin
    S_r    <=  'd0;
    Sne_r  <=  'd0;
    Sn_r   <=  'd0;
    Snw_r  <=  'd0;
    sl_num_r<=  'd0;
    scan_area_r<=  'd0;
    mode_r <= 'd0;
    cj_fst_r<= 'd0;
  end else if(en_i == 1'b1) begin
    S_r    <= S_i  ;
    Sne_r  <= Sne_i;
    Sn_r   <= Sn_i ;
    Snw_r  <= Snw_i;
    sl_num_r<= sl_num_i;
    scan_area_r<= scan_area_i;
    mode_r <= mode_i;
    cj_fst_r<= cj_fst_i;
  end
end
always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    en_r  <= 1'b0;
    en_r2 <= 1'b0;
    en_r3 <= 1'b0;
  end else begin
    en_r  <= en_i;
    en_r2 <= en_r;
    en_r3 <= en_r2;
  end
end
// y ==0 x == 0 
// y>0   x>0 x<Nx
// y ==0 x >0
// y > 0 x== 0
// y > 0 x== Nx

 /***************************************************************************************/
 /**************************************stream1******************************************/
 /***************************************************************************************/
always @(scan_area_r,Snw_r,Sn_r,Sne_r,cj_fst_r) begin : get_delta_rp
  case(scan_area_r)
    5'b00001 : delta_rp <= 'd0;//INI 
    5'b00010 : delta_rp <= {2'b00,Snw_r} + {2'b00,Sn_r,1'b0} + {2'b00,Sne_r};//area1除了第一行
    5'b00100 : delta_rp <= {cj_fst_r,2'b00};//area2第一行 第一个谱段
    5'b01000 : delta_rp <= {1'b0,Sn_r,1'b0} + {1'b0,Sne_r,1'b0};//area3每一行的第一个数
    5'b10000 : delta_rp <= {2'b00,Snw_r,1'b0} + {1'b0,Sn_r,1'b0};//area4每一行的最后一个数
    default  : delta_rp <= 'd0;//INI
  endcase
end

always @(scan_area_r,Sn_r) begin : get_S_dn_rp
  case(scan_area_r)
    5'b00010 : S_dn_rp <= {Sn_r,2'b00};//area1
    5'b01000 : S_dn_rp <= {Sn_r,2'b00};//area3
    5'b10000 : S_dn_rp <= {Sn_r,2'b00};//area4
    default  : S_dn_rp <= 'd0;//INI
  endcase
end

always @(scan_area_r,Sn_r,Snw_r) begin : get_S_dnw_rp
  case(scan_area_r)
    5'b00010 : S_dnw_rp <= {Snw_r,2'b00};//area1
    5'b01000 : S_dnw_rp <= {Sn_r,2'b00};//area3
    5'b10000 : S_dnw_rp <= {Snw_r,2'b00};//area4
    default  : S_dnw_rp <= 'd0;//INI
  endcase
end
// always @(S_r) begin : get_S_med_num_rp
  // if(S_r == 'd4095) begin
    // S_med_num_rp[0] <= 1'b1;
  // end else begin
    // S_med_num_rp[0] <= 1'b0;
  // end
  // if(S_r > 'd4095) begin
    // S_med_num_rp[1] <= 1'b1;
  // end else begin
    // S_med_num_rp[1] <= 1'b0;
  // end
  // if(S_r < 'd4095) begin
    // S_med_num_rp[2] <= 1'b1;
  // end else begin
    // S_med_num_rp[2] <= 1'b0;
  // end
// end

/*always @(S_r,mode_i) begin : get_S_med_num_rp
    case (mode_i)
     3'b001 : begin
                if(S_r == 'd4095) begin
                    S_med_num_rp[0] <= 1'b1;
                end else begin
                    S_med_num_rp[0] <= 1'b0;
                end
                if(S_r > 'd4095) begin
                    S_med_num_rp[1] <= 1'b1;
                end else begin
                    S_med_num_rp[1] <= 1'b0;
                end
                if(S_r < 'd4095) begin
                    S_med_num_rp[2] <= 1'b1;
                end else begin
                    S_med_num_rp[2] <= 1'b0;
                end
            end
     3'b010 : begin  
                if(S_r == 'd16383) begin
                    S_med_num_rp[0] <= 1'b1;
                end else begin
                    S_med_num_rp[0] <= 1'b0;
                end
                if(S_r > 'd16383) begin
                    S_med_num_rp[1] <= 1'b1;
                end else begin
                    S_med_num_rp[1] <= 1'b0;
                end
                if(S_r < 'd16383) begin
                    S_med_num_rp[2] <= 1'b1;
                end else begin
                    S_med_num_rp[2] <= 1'b0;
                end
            end
     3'b100 : begin
                if(S_r == 'd65535) begin
                    S_med_num_rp[0] <= 1'b1;
                end else begin
                    S_med_num_rp[0] <= 1'b0;
                end
                if(S_r > 'd65535) begin
                    S_med_num_rp[1] <= 1'b1;
                end else begin
                    S_med_num_rp[1] <= 1'b0;
                end
                if(S_r < 'd65535) begin
                    S_med_num_rp[2] <= 1'b1;
                end else begin
                    S_med_num_rp[2] <= 1'b0;
                end  
            end
    default : begin 
                S_med_num_rp <= 'd0;
            end
    endcase
end*/

/*always @(S_r) begin : get_S_e0_num_rp
  if(S_r == 'd0) begin
    S_e0_num_rp[0] <= 1'b1;
  end else begin
    S_e0_num_rp[0] <= 1'b0;
  end
  if(S_r > 'd0) begin
    S_e0_num_rp[1] <= 1'b1;
  end else begin
    S_e0_num_rp[1] <= 1'b0;
  end
end*/
 /***************************************************************************************/
 /**************************************regist2******************************************/
 /***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : register2
  if(rst_n == 1'b0) begin
    delta_r2 <=  'd0;
    S_r2     <=  'd0;
    S_dn_r2  <=  'd0;
    S_dnw_r2 <=  'd0;
    sl_num_r2<=  'd0;
    scan_area_r2 <= 'd0;
   // S_med_num_r2 <= 'd0;
   // S_e0_num_r2  <= 'd0;
    mode_r2  <= 'd0;
  end else if(en_r == 1'b1) begin
    delta_r2 <= delta_rp;
    S_r2     <= S_r;
    S_dn_r2  <= S_dn_rp ;
    S_dnw_r2 <= S_dnw_rp;
    sl_num_r2<= sl_num_r;
    scan_area_r2 <= scan_area_r;
   // S_med_num_r2 <= S_med_num_rp;
   // S_e0_num_r2  <= S_e0_num_rp;
    mode_r2  <= mode_r;
  end
end
 /***************************************************************************************/
 /**************************************stream2******************************************/
 /***************************************************************************************/
/*always @(S_r2,delta_r2) begin : get_Sm4_sub_delta_r2p
    Sm4_sub_delta_r2p <= {1'b0,S_r2,2'b00} - {1'b0,delta_r2[DATA_WIDTH-1+2:2],2'b00};
end*/
/*always @(S_r2,delta_r2) begin : get_Sm4_sub_delta1_r2p
    Sm4_sub_delta1_r2p <= {1'b0,S_r2,2'b00} - {1'b0,delta_r2[DATA_WIDTH-1+2:2],2'b00} - 3'b100;
end*/
// always @(S_dn_r2,delta_r2,mode_r2) begin : get_dn_r2p
  // if (mode_r2[0] == 1'b1) begin  //mode_r2 == 3'b001
    // dn_r2p <= {1'b0,S_dn_r2} - {1'b0,delta_r2};
  // end else begin
    // dn_r2p <= 'd0;
  // end
// end
// always @(S_dw_r2,delta_r2,mode_r2) begin : get_dw_r2p
  // if (mode_r2[0] == 1'b1) begin
    // dw_r2p <= {1'b0,S_dw_r2} - {1'b0,delta_r2};
  // end else begin
    // dw_r2p <= 'd0;
  // end
// end
// always @(S_dnw_r2,delta_r2,mode_r2) begin : get_dnw_r2p
  // if (mode_r2[0] == 1'b1) begin
    // dnw_r2p <= {1'b0,S_dnw_r2} - {1'b0,delta_r2};
  // end else begin
    // dnw_r2p <= 'd0;
  // end
// end
// always @(S_dn_r2,delta_r2,mode_r2) begin : get_n_dn_r2p
  // if (mode_r2[0] == 1'b1) begin
    // n_dn_r2p <= {1'b0,delta_r2} - {1'b0,S_dn_r2};
  // end else begin
    // n_dn_r2p <= 'd0;
  // end
// end
// always @(S_dw_r2,delta_r2,mode_r2) begin : get_n_dw_r2p
  // if (mode_r2[0] == 1'b1) begin
    // n_dw_r2p <= {1'b0,delta_r2} - {1'b0,S_dw_r2};
  // end else begin
    // n_dw_r2p <= 'd0;
  // end
// end
// always @(S_dnw_r2,delta_r2,mode_r2) begin : get_n_dnw_r2p
  // if (mode_r2[0] == 1'b1) begin
    // n_dnw_r2p <= {1'b0,delta_r2} - {1'b0,S_dnw_r2};
  // end else begin
    // n_dnw_r2p <= 'd0;
  // end
// end
// always @(S_dn_r2,delta_r2) begin : get_dn_r2p
    // dn_r2p <= {1'b0,S_dn_r2} - {1'b0,delta_r2};
// end
// always @(S_dw_r2,delta_r2) begin : get_dw_r2p
    // dw_r2p <= {1'b0,S_dw_r2} - {1'b0,delta_r2};
// end
// always @(S_dnw_r2,delta_r2) begin : get_dnw_r2p
    // dnw_r2p <= {1'b0,S_dnw_r2} - {1'b0,delta_r2};
// end
// always @(S_dn_r2,delta_r2) begin : get_n_dn_r2p
    // n_dn_r2p <= {1'b0,delta_r2} - {1'b0,S_dn_r2};
// end



// always @(S_dw_r2,delta_r2) begin : get_n_dw_r2p
    // n_dw_r2p <= {1'b0,delta_r2} - {1'b0,S_dw_r2};
// end
// always @(S_dnw_r2,delta_r2,) begin : get_n_dnw_r2p
    // n_dnw_r2p <= {1'b0,delta_r2} - {1'b0,S_dnw_r2};
// end
always @(S_dn_r2,delta_r2,S_dnw_r2) begin : get_dn_r2p
    dn_r2p <= {1'b0,S_dn_r2} - {1'b0,delta_r2};
    dnw_r2p <= {1'b0,S_dnw_r2} - {1'b0,delta_r2};
end

//周边局部差dn dw dnw的相反数
always @(S_dn_r2,delta_r2,S_dnw_r2) begin : get_n_dn_r2p
    n_dn_r2p <= {1'b0,delta_r2} - {1'b0,S_dn_r2};
    n_dnw_r2p <= {1'b0,delta_r2} - {1'b0,S_dnw_r2};
end
always @(sl_num_r2,dn_r2p) begin : get_dn_sl_r2pp
  case(sl_num_r2)
    4'b0001 : dn_sl_r2pp <= {{9{dn_r2p[D_WIDTH-1]}},dn_r2p[D_WIDTH-1:9]};
    4'b0010 : dn_sl_r2pp <= {{6{dn_r2p[D_WIDTH-1]}},dn_r2p[D_WIDTH-1:6]};
    4'b0100 : dn_sl_r2pp <= {{3{dn_r2p[D_WIDTH-1]}},dn_r2p[D_WIDTH-1:3]};
    4'b1000 : dn_sl_r2pp <= dn_r2p;
    default : dn_sl_r2pp <= 'd0;
  endcase
end

always @(sl_num_r2,dnw_r2p) begin : get_dnw_sl_r2pp
  case(sl_num_r2)
    4'b0001 : dnw_sl_r2pp <= {{9{dnw_r2p[D_WIDTH-1]}},dnw_r2p[D_WIDTH-1:9]};
    4'b0010 : dnw_sl_r2pp <= {{6{dnw_r2p[D_WIDTH-1]}},dnw_r2p[D_WIDTH-1:6]};
    4'b0100 : dnw_sl_r2pp <= {{3{dnw_r2p[D_WIDTH-1]}},dnw_r2p[D_WIDTH-1:3]};
    4'b1000 : dnw_sl_r2pp <= dnw_r2p;
    default : dnw_sl_r2pp <= 'd0;
  endcase
end

always @(sl_num_r2,n_dn_r2p) begin : get_n_dn_sl_r2pp
  case(sl_num_r2)
    4'b0001 : n_dn_sl_r2pp <= {{9{n_dn_r2p[D_WIDTH-1]}},n_dn_r2p[D_WIDTH-1:9]};
    4'b0010 : n_dn_sl_r2pp <= {{6{n_dn_r2p[D_WIDTH-1]}},n_dn_r2p[D_WIDTH-1:6]};
    4'b0100 : n_dn_sl_r2pp <= {{3{n_dn_r2p[D_WIDTH-1]}},n_dn_r2p[D_WIDTH-1:3]};
    4'b1000 : n_dn_sl_r2pp <= n_dn_r2p;
    default : n_dn_sl_r2pp <= 'd0;
  endcase
end

always @(sl_num_r2,n_dnw_r2p) begin : get_n_dnw_sl_r2pp
  case(sl_num_r2)
    4'b0001 : n_dnw_sl_r2pp <= {{9{n_dnw_r2p[D_WIDTH-1]}},n_dnw_r2p[D_WIDTH-1:9]};
    4'b0010 : n_dnw_sl_r2pp <= {{6{n_dnw_r2p[D_WIDTH-1]}},n_dnw_r2p[D_WIDTH-1:6]};
    4'b0100 : n_dnw_sl_r2pp <= {{3{n_dnw_r2p[D_WIDTH-1]}},n_dnw_r2p[D_WIDTH-1:3]};
    4'b1000 : n_dnw_sl_r2pp <= n_dnw_r2p;
    default : n_dnw_sl_r2pp <= 'd0;
  endcase
end
/*
always @(scan_area_r,dn_sl_r2pp) begin : get_dn_sl_r2ppp
  if(scan_area_r[0] == 1'b1 || scan_area_r[3] == 1'b1) begin
    dn_sl_r2ppp <= 'd0;
  end else begin
    dn_sl_r2ppp <= dn_sl_r2pp;
  end
end*/
/*
always @(scan_area_r,dw_sl_r2pp) begin : get_dw_sl_r2ppp
  if(scan_area_r[0] == 1'b1 || scan_area_r[3] == 1'b1) begin
    dw_sl_r2ppp <= 'd0;
  end else begin
    dw_sl_r2ppp <= dw_sl_r2pp;
  end
end*/
/*
always @(scan_area_r,dnw_sl_r2pp) begin : get_dnw_sl_r2ppp
  if(scan_area_r[0] == 1'b1 || scan_area_r[3] == 1'b1) begin
    dnw_sl_r2ppp <= 'd0;
  end else begin
    dnw_sl_r2ppp <= dnw_sl_r2pp;
  end
end*/
/*
always @(scan_area_r,n_dn_sl_r2pp) begin : get_n_dn_sl_r2ppp
  if(scan_area_r[0] == 1'b1 || scan_area_r[3] == 1'b1) begin
    n_dn_sl_r2ppp <= 'd0;
  end else begin
    n_dn_sl_r2ppp <= n_dn_sl_r2pp;
  end
end*/
/*
always @(scan_area_r,n_dw_sl_r2pp) begin : get_n_dw_sl_r2ppp
  if(scan_area_r[0] == 1'b1 || scan_area_r[3] == 1'b1) begin
    n_dw_sl_r2ppp <= 'd0;
  end else begin
    n_dw_sl_r2ppp <= n_dw_sl_r2pp;
  end
end*/
/*
always @(scan_area_r,n_dnw_sl_r2pp) begin : get_n_dnw_sl_r2ppp
  if(scan_area_r[0] == 1'b1 || scan_area_r[3] == 1'b1) begin
    n_dnw_sl_r2ppp <= 'd0;
  end else begin
    n_dnw_sl_r2ppp <= n_dnw_sl_r2pp;
  end
end*/
/*always @(delta_r2,mode_r2) begin : get_M_sub_delta_r2p
  if (mode_r2[2] == 1'b1) begin
    M_sub_delta_r2p <= 'd262142 - {1'b0,delta_r2[DATA_WIDTH+2-1:1],1'b0};
  end else if(mode_r2[1] == 1'b1) begin
    M_sub_delta_r2p <= 'd65534 - {1'b0,delta_r2[DATA_WIDTH+2-1:1],1'b0};
  end else begin
    M_sub_delta_r2p <= 'd16382 - {1'b0,delta_r2[DATA_WIDTH+2-1:1],1'b0};
  end
end
*/
/*always @(delta_r2,mode_r2) begin : get_M_sub_delta1_r2p
  if (mode_r2[2] == 1'b1) begin
    M_sub_delta1_r2p <= 'd262141 - {1'b0,delta_r2[DATA_WIDTH+2-1:1],1'b0};
  end else if(mode_r2[1] == 1'b1) begin
    M_sub_delta1_r2p <= 'd65533 - {1'b0,delta_r2[DATA_WIDTH+2-1:1],1'b0};
  end else begin
    M_sub_delta1_r2p <= 'd16381 - {1'b0,delta_r2[DATA_WIDTH+2-1:1],1'b0};
  end
end*/
/*always @(delta_r2) begin : get_n_delta_r2p
  n_delta_r2p <= 'd0 - {1'b0,delta_r2};
end*/
 /***************************************************************************************/
 /**************************************regist3******************************************/
 /***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : get_d_r3
  if(rst_n == 1'b0) begin
    dn_r3      <= 'd0;
    dnw_r3     <= 'd0;
//    dn_sl_r3   <= 'd0;
//    dw_sl_r3   <= 'd0;
//    dnw_sl_r3  <= 'd0;
//    n_dn_sl_r3 <= 'd0;
//    n_dw_sl_r3 <= 'd0;
//    n_dnw_sl_r3<= 'd0;
  end else if(en_r2 == 1'b1   &&    ( scan_area_r2[1]==1'b1 || scan_area_r2[3]==1'b1 || scan_area_r2[4]==1'b1 )    ) begin
    dn_r3      <= dn_r2p     ;
    dnw_r3     <= dnw_r2p    ;
//    dn_sl_r3   <= dn_sl_r2ppp ;
//    dw_sl_r3   <= dw_sl_r2ppp ;
//    dnw_sl_r3  <= dnw_sl_r2ppp;
//    n_dn_sl_r3 <= n_dn_sl_r2ppp ;
//    n_dw_sl_r3 <= n_dw_sl_r2ppp ;
//    n_dnw_sl_r3<= n_dnw_sl_r2ppp;
  end else begin
    dn_r3      <= 'd0;
    dnw_r3     <= 'd0;
//    dn_sl_r3   <= 'd0;
//    dw_sl_r3   <= 'd0;
//    dnw_sl_r3  <= 'd0;
//    n_dn_sl_r3 <= 'd0;
//    n_dw_sl_r3 <= 'd0;
//    n_dnw_sl_r3<= 'd0;
  end
end

always @(posedge clk or negedge rst_n) begin : register3r
  if(rst_n == 1'b0) begin
   // delta_low_r3     <= 'd0;
    dn_sl_r_r3       <= 'd0;
    dnw_sl_r_r3      <= 'd0;
    n_dn_sl_r_r3     <= 'd0;
   // n_dw_sl_r_r3     <= 'd0;
    n_dnw_sl_r_r3    <= 'd0;
  end else if(en_r2 == 1'b1   &&    ( scan_area_r2[0]==1'b1 || scan_area_r2[2]==1'b1)    ) begin
   // delta_low_r3     <= 'd0;
    dn_sl_r_r3       <= 'd0;
    dnw_sl_r_r3      <= 'd0;
    n_dn_sl_r_r3     <= 'd0;
  //  n_dw_sl_r_r3     <= 'd0;
    n_dnw_sl_r_r3    <= 'd0;
  end else if(en_r2 == 1'b1) begin
   // delta_low_r3     <= delta_r2[1:0];
    dn_sl_r_r3       <= dn_sl_r2pp ;
    dnw_sl_r_r3      <= dnw_sl_r2pp;
    n_dn_sl_r_r3     <= n_dn_sl_r2pp ;
    //n_dw_sl_r_r3     <= n_dw_sl_r2pp ;
    n_dnw_sl_r_r3    <= n_dnw_sl_r2pp;
  end
end
always @(posedge clk or negedge rst_n) begin : register3
  if(rst_n == 1'b0) begin
    delta_r3         <= 'd0;
   // Sm4_sub_delta_r3 <= 'd0;
   // Sm4_sub_delta1_r3<= 'd0;
   // S_med_num_r3     <= 'd0;
   // S_e0_num_r3      <= 'd0;
   // M_sub_delta_r3   <= 'd0;
   // M_sub_delta1_r3  <= 'd0;
   // n_delta_r3       <= 'd0;
    S_r3             <= 'd0;
  end else if(en_r2 == 1'b1) begin
    delta_r3         <= delta_r2;
   // Sm4_sub_delta_r3 <= Sm4_sub_delta_r2p;
    //Sm4_sub_delta1_r3<= Sm4_sub_delta1_r2p;
    //S_med_num_r3     <= S_med_num_r2;
    //S_e0_num_r3      <= S_e0_num_r2;
   // M_sub_delta_r3   <= M_sub_delta_r2p;
   // M_sub_delta1_r3  <= M_sub_delta1_r2p;
  //  n_delta_r3       <= n_delta_r2p;
    S_r3             <= S_r2;
  end
end


 /***************************************************************************************/
 /**************************************regist4******************************************/
 /***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : register4
  if(rst_n == 1'b0) begin
//    dn_sl_r4         <= 'd0;
//    dw_sl_r4         <= 'd0;
//    dnw_sl_r4        <= 'd0;
//    n_dn_sl_r4       <= 'd0;
//    n_dw_sl_r4       <= 'd0;
//    n_dnw_sl_r4      <= 'd0;
    dn_sl_r_r4     <= 'd0;
    dnw_sl_r_r4    <= 'd0;
    n_dn_sl_r_r4     <= 'd0;
  //  n_dw_sl_r_r4     <= 'd0;
    n_dnw_sl_r_r4    <= 'd0;
  end else if(en_r3 == 1'b1) begin
//    dn_sl_r4         <= dn_sl_r3;
//    dw_sl_r4         <= dw_sl_r3;
//    dnw_sl_r4        <= dnw_sl_r3;
//    n_dn_sl_r4       <= n_dn_sl_r3;
//    n_dw_sl_r4       <= n_dw_sl_r3;
//    n_dnw_sl_r4      <= n_dnw_sl_r3;
    dn_sl_r_r4       <= dn_sl_r_r3;
    dnw_sl_r_r4      <= dnw_sl_r_r3;
    n_dn_sl_r_r4     <= n_dn_sl_r_r3;
   // n_dw_sl_r_r4     <= n_dw_sl_r_r3;
    n_dnw_sl_r_r4    <= n_dnw_sl_r_r3;
  end
end
// always @(posedge clk) begin
    // if (en_r3 == 1'b1) begin
        // file_dn_r3 = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_23/dn_r3.txt", "a"); // 使用 "a" 模式以追加方式打开文件
        // file_dw_r3 = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_23/dw_r3.txt", "a");
        // file_dnw_r3 = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_23/dnw_r3.txt", "a");
        // file_delta_r3 = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_23/delta_r3.txt", "a");
        // if (file_dn_r3 != 0 && file_dw_r3 != 0 && file_dnw_r3 != 0 ) begin
            // $fwrite(file_dn_r3, "%20b\n", dn_o);
            // $fwrite(file_dw_r3, "%20b\n", dw_o);
            // $fwrite(file_dnw_r3, "%20b\n", dnw_o);
            // $fwrite(file_delta_r3, "%18b\n", delta_o );
            
            // $fclose(file_dn_r3);
            // $fclose(file_dw_r3);
            // $fclose(file_dnw_r3);
            // $fclose(file_delta_r3);
        // end
    // end
// end

// always @(posedge clk) begin
//     if (en_r3) begin
//         file_Sm4_sub_delta_r2p = $fopen("D:/KEHU_ceshi/KEHU_test/jiemaceshi/guoke_7_2/delta_r3.txt", "a"); // 使用 "a" 模式以追加方式打开文件
        
//         if (file_Sm4_sub_delta_r2p != 0) begin
//             $fwrite(file_Sm4_sub_delta_r2p, "%05h\n", delta_r3);
            
//             $fclose(file_Sm4_sub_delta_r2p);
//         end
//     end
// end 

 /***************************************************************************************/
 /**************************************  out  ******************************************/
 /***************************************************************************************/
 assign en_o      =  en_r3;
 assign dn_o      =  dn_r3;
 // assign dw_o      =  'd0;
 assign dnw_o     =  dnw_r3;
// assign dn_ls_o   =  dn_sl_r4;
// assign dw_ls_o   =  dw_sl_r4;
// assign dnw_ls_o  =  dnw_sl_r4;
// assign n_dn_ls_o =  n_dn_sl_r4;
// assign n_dw_ls_o =  n_dw_sl_r4;
// assign n_dnw_ls_o=  n_dnw_sl_r4;
 assign dn_ls_r_o =  dn_sl_r_r4;
// assign dw_ls_r_o =  'd0;
 assign dnw_ls_r_o=  dnw_sl_r_r4;
 assign n_dn_ls_r_o =  n_dn_sl_r_r4;
 //assign n_dw_ls_r_o =  'd0;
 assign n_dnw_ls_r_o=  n_dnw_sl_r_r4;
 //assign Sm4_sub_delta_o = Sm4_sub_delta_r3[D_WIDTH-1:2];
 //assign Sm4_sub_delta1_o= Sm4_sub_delta1_r3[D_WIDTH-1:2];
 assign S_o         = S_r3;
 assign delta_o     = delta_r3;
 //assign delta_low2_o= delta_low_r3;
// assign S_med_num_o = S_med_num_r3;
 //assign S_e0_num_o  = S_e0_num_r3 ;
 //assign M_sub_delta_o  = M_sub_delta_r3 ;
 //assign M_sub_delta1_o = M_sub_delta1_r3;
 //assign n_delta_o      = n_delta_r3     ;
endmodule