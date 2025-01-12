module cal_d_delta #(
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
    input  wire    [DATA_WIDTH-1:0] cj_fst_i,

    output wire                     en_o,
    output wire    [D_WIDTH-1:0]    d_o,
//    output wire    [D_WIDTH-1:0]    d_ls_o,
//    output wire    [D_WIDTH-1:0]    n_d_ls_o,
    output wire    [D_WIDTH-1:0]    d_ls_r_o,
    output wire    [D_WIDTH-1:0]    n_d_ls_r_o
);
    reg                          en_r;
    reg    [3:0]                 sl_num_r;
    reg    [4:0]                 scan_area_r;
    reg    [DATA_WIDTH-1:0]      S_r;
    reg    [DATA_WIDTH-1:0]      Sne_r;
    reg    [DATA_WIDTH-1:0]      Sn_r;
    reg    [DATA_WIDTH-1:0]      Snw_r;
    reg    [DATA_WIDTH-1:0]      cj_fst_r;
    reg    [DATA_WIDTH-1+2:0]    delta_rp;
    reg    [DATA_WIDTH-1+2:0]    S_m4_rp;

    reg                          en_r2;
    reg    [DATA_WIDTH-1+2:0]    delta_r2;
    reg    [DATA_WIDTH-1+2:0]    S_m4_r2;
    reg    [3:0]                 sl_num_r2;
    reg    [D_WIDTH-1:0]         d_r2p;
    reg    [D_WIDTH-1:0]         d_sl_r2pp;
    reg    [D_WIDTH-1:0]         n_d_r2p;
    reg    [D_WIDTH-1:0]         n_d_sl_r2pp;
    //reg    [2:0]                 mode_r2;

//    reg    [D_WIDTH-1:0]         d_sl_r2ppp;
//    reg    [D_WIDTH-1:0]         n_d_sl_r2ppp;

    reg                          en_r3;
    reg    [D_WIDTH-1:0]         d_r3;
//    reg    [D_WIDTH-1:0]         d_sl_r3;
//    reg    [D_WIDTH-1:0]         n_d_sl_r3;
    reg    [D_WIDTH-1:0]         d_sl_r_r3;
    reg    [D_WIDTH-1:0]         n_d_sl_r_r3;
//    reg    [D_WIDTH-1:0]         d_sl_r4;
//    reg    [D_WIDTH-1:0]         n_d_sl_r4;
    reg    [D_WIDTH-1:0]         d_sl_r_r4;
    reg    [D_WIDTH-1:0]         n_d_sl_r_r4;
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
    cj_fst_r<= 'd0;
  end else if(en_i == 1'b1) begin
    S_r    <= S_i  ;
    Sne_r  <= Sne_i;
    Sn_r   <= Sn_i ;
    Snw_r  <= Snw_i;
    sl_num_r<= sl_num_i;
    scan_area_r<= scan_area_i;
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
 /***************************************************************************************/
 /**************************************stream1******************************************/
 /***************************************************************************************/
// always @(scan_area_r,Snw_r,Sn_r,Sne_r,Sw_r) begin : get_delta_rp
  // case(scan_area_r)
    // 5'b00001 : delta_rp <= 'd0;//INI
    // 5'b00010 : delta_rp <= {2'b00,Sw_r} + {2'b00,Snw_r} + {2'b00,Sn_r} + {2'b00,Sne_r};//area1
    // 5'b00100 : delta_rp <= {Sw_r,2'b00};//area2
    // 5'b01000 : delta_rp <= {1'b0,Sn_r,1'b0} + {1'b0,Sne_r,1'b0};//area3
    // 5'b10000 : delta_rp <= {2'b00,Sw_r} + {2'b00,Snw_r} + {1'b0,Sn_r,1'b0};//area4
    // default  : delta_rp <= 'd0;//INI
  // endcase
// end
always @(scan_area_r,Snw_r,Sn_r,Sne_r,cj_fst_r) begin : get_delta_rp
  case(scan_area_r)
    5'b00001 : delta_rp <= 'd0;//INI
    5'b00010 : delta_rp <= {2'b00,Snw_r} + {2'b00,Sn_r,1'b0} + {2'b00,Sne_r};//area1
    5'b00100 : delta_rp <= {cj_fst_r,2'b00};//area2
    5'b01000 : delta_rp <= {1'b0,Sn_r,1'b0} + {1'b0,Sne_r,1'b0};//area3
    5'b10000 : delta_rp <= {2'b00,Snw_r,1'b0} + {1'b0,Sn_r,1'b0};//area4
    default  : delta_rp <= 'd0;//INI
  endcase
end
always @(S_r) begin : get_S_m4_rp
  S_m4_rp <= {S_r,2'b00};
end
 /***************************************************************************************/
 /**************************************regist2******************************************/
 /***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : register2
  if(rst_n == 1'b0) begin
    delta_r2 <=  'd0;
    S_m4_r2  <=  'd0;
    sl_num_r2<=  'd0;
  end else if(en_r == 1'b1) begin
    delta_r2 <= delta_rp;
    S_m4_r2  <= S_m4_rp;
    sl_num_r2<= sl_num_r;
  end
end
 /***************************************************************************************/
 /**************************************stream2******************************************/
 /***************************************************************************************/
always @(S_m4_r2,delta_r2,en_r2) begin : get_d_r2p
    if(en_r2 == 1'b0) begin
      d_r2p   <= 'd0;       
    end else begin
      d_r2p <= {1'b0,S_m4_r2} - {1'b0,delta_r2};  
    end
end

always @(S_m4_r2,delta_r2,en_r2) begin : get_n_d_r2p
    if(en_r2 == 1'b1) begin
        n_d_r2p <= {1'b0,delta_r2} - {1'b0,S_m4_r2};  
    end else begin 
        n_d_r2p <= 'd0; 
    end
end

always @(sl_num_r2,d_r2p) begin : get_d_sl_r2pp
  case(sl_num_r2)
    4'b0001 : d_sl_r2pp <= {{9{d_r2p[D_WIDTH-1]}},d_r2p[D_WIDTH-1:9]};
    4'b0010 : d_sl_r2pp <= {{6{d_r2p[D_WIDTH-1]}},d_r2p[D_WIDTH-1:6]};
    4'b0100 : d_sl_r2pp <= {{3{d_r2p[D_WIDTH-1]}},d_r2p[D_WIDTH-1:3]};
    4'b1000 : d_sl_r2pp <= d_r2p;
    default : d_sl_r2pp <= 'd0;
  endcase
end

always @(sl_num_r2,n_d_r2p) begin : get_n_d_sl_r2pp
  case(sl_num_r2)
    4'b0001 : n_d_sl_r2pp <= {{9{n_d_r2p[D_WIDTH-1]}},n_d_r2p[D_WIDTH-1:9]};
    4'b0010 : n_d_sl_r2pp <= {{6{n_d_r2p[D_WIDTH-1]}},n_d_r2p[D_WIDTH-1:6]};
    4'b0100 : n_d_sl_r2pp <= {{3{n_d_r2p[D_WIDTH-1]}},n_d_r2p[D_WIDTH-1:3]};
    4'b1000 : n_d_sl_r2pp <= n_d_r2p;
    default : n_d_sl_r2pp <= 'd0;
  endcase
end
/*
always @(scan_area_r,d_sl_r2pp) begin : get_d_sl_r2ppp
  if(scan_area_r[0] == 1'b1 || scan_area_r[3] == 1'b1) begin
    d_sl_r2ppp <= 'd0;
  end else begin
    d_sl_r2ppp <= d_sl_r2pp;
  end
end*/
/*
always @(scan_area_r,n_d_sl_r2pp) begin : get_n_d_sl_r2ppp
  if(scan_area_r[0] == 1'b1 || scan_area_r[3] == 1'b1) begin
    n_d_sl_r2ppp <= 'd0;
  end else begin
    n_d_sl_r2ppp <= n_d_sl_r2pp;
  end
end*/
 /***************************************************************************************/
 /**************************************regist3******************************************/
 /***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : register3
  if(rst_n == 1'b0) begin
    d_r3     <= 'd0;
//    d_sl_r3  <= 'd0;
//    n_d_sl_r3<= 'd0;
  end else if(en_r2 == 1'b1 || (en_r2 == 1'b0 && en_r3 == 1'b1)) begin
    d_r3     <= d_r2p;
//    d_sl_r3  <= d_sl_r2ppp;
//    n_d_sl_r3<= n_d_sl_r2ppp;
//  end else begin
//    d_r3     <= 'd0;
//    d_sl_r3  <= 'd0;
//    n_d_sl_r3<= 'd0;
  end
end
always @(posedge clk or negedge rst_n) begin : register3r
  if(rst_n == 1'b0) begin
    d_sl_r_r3  <= 'd0;
    n_d_sl_r_r3<= 'd0;
  end else if(en_r2 == 1'b1) begin
    d_sl_r_r3  <= d_sl_r2pp;
    n_d_sl_r_r3<= n_d_sl_r2pp;
  end
end
 /***************************************************************************************/
 /**************************************regist4******************************************/
 /***************************************************************************************/
 /*
always @(posedge clk or negedge rst_n) begin : register4
  if(rst_n == 1'b0) begin
    d_sl_r4  <= 'd0;
    n_d_sl_r4<= 'd0;
  end else if(en_r2 == 1'b0) begin
    d_sl_r4  <= 'd0;
    n_d_sl_r4<= 'd0;
  end else if(en_r3 == 1'b1) begin
    d_sl_r4  <= d_sl_r3;
    n_d_sl_r4<= n_d_sl_r3;
  end
end*/
always @(posedge clk or negedge rst_n) begin : register4r
  if(rst_n == 1'b0) begin
    d_sl_r_r4   <= 'd0;
    n_d_sl_r_r4 <= 'd0;
  end else if(en_r3 == 1'b1) begin
    d_sl_r_r4   <= d_sl_r_r3;
    n_d_sl_r_r4 <= n_d_sl_r_r3;
  end
end
 /***************************************************************************************/
 /**************************************  out  ******************************************/
 /***************************************************************************************/
 assign en_o    =  en_r3;
 assign d_o     =  d_r3;
// assign d_ls_o  =  d_sl_r4;
// assign n_d_ls_o=  n_d_sl_r4;
 assign d_ls_r_o  =  d_sl_r_r4;
 assign n_d_ls_r_o=  n_d_sl_r_r4;
 
endmodule