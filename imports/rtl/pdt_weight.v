module pdt_weight #(
    parameter     W_WIDTH    = 12+2+1+16,//dn_width+16
    parameter     D_WIDTH    = 12+2+1
)
(
    input  wire                       clk,
    input  wire                       rst_n,
    input  wire [D_WIDTH-1:0]         dn_i,
    //input  wire [D_WIDTH-1:0]         dn_sl_i,
    //input  wire [D_WIDTH-1:0]         n_dn_sl_i,
    input  wire [D_WIDTH-1:0]         dn_sl_r_i,
    input  wire [D_WIDTH-1:0]         n_dn_sl_r_i,
    input  wire                       dn_en_i,
    input  wire [2:0]                 vec_num_i,

    input  wire [W_WIDTH-1:0]         recover_data_i,
    input  wire                       recover_en_i,

    output wire [D_WIDTH+W_WIDTH-1:0] dw_pdt1_o,
    output wire [D_WIDTH+W_WIDTH-1:0] dw_pdt2_o,
    output wire [D_WIDTH+W_WIDTH-1:0] dw_pdt3_o,
    output wire                       dw_en_o,
    output wire [W_WIDTH-1:0]         weight_crt_o,
    output wire                       crt_en_o
);

    reg         [W_WIDTH-1:0] recover_data_r;
    reg                       recover_en_r;
    reg         [W_WIDTH-1:0] weight_crt_p;
    reg       [W_WIDTH+1-1:0] weight_prd1_pp;
    reg       [W_WIDTH+1-1:0] weight_prd2_pp;
    reg       [W_WIDTH+1-1:0] weight_prd3_pp;
    reg         [W_WIDTH-1:0] weight_prd1_clip_ppp;
    reg         [W_WIDTH-1:0] weight_prd2_clip_ppp;
    reg         [W_WIDTH-1:0] weight_prd3_clip_ppp;
    reg [D_WIDTH+W_WIDTH-1:0] dw1_pppp;
    reg [D_WIDTH+W_WIDTH-1:0] dw2_pppp;
    reg [D_WIDTH+W_WIDTH-1:0] dw3_pppp;
    wire[D_WIDTH+W_WIDTH-1:0] dn_signed_pp;
    reg         [D_WIDTH-1:0] dn_sl_pp;
    reg         [D_WIDTH-1:0] n_dn_sl_pp;
    wire[D_WIDTH+W_WIDTH-1:0] weight_prd1_clip_signed_ppp;
    wire[D_WIDTH+W_WIDTH-1:0] weight_prd2_clip_signed_ppp;
    wire[D_WIDTH+W_WIDTH-1:0] weight_prd3_clip_signed_ppp;
    reg                       dn_en_r;
    reg                       dn_en_r2;
    /*for ram*/

    reg         [W_WIDTH-1:0] weight_pre_rp;
    reg       [W_WIDTH+1-1:0] weight_upt_rpp;
    reg         [W_WIDTH-1:0] weight_upt_clip_rppp;
    reg         [W_WIDTH-1:0] weight_upt_r2;
    reg         [W_WIDTH-1:0] weight_upt_o_r2;

 /***************************************************************************************/
 /**************************************common ******************************************/
 /***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    dn_en_r  <= 'd0;
    dn_en_r2 <= 'd0;
  end else begin
    dn_en_r  <= dn_en_i;
    dn_en_r2 <= dn_en_r;
  end
end
 /***************************************************************************************/
 /**************************************stream0******************************************/
 /***************************************************************************************/
always @(recover_en_i,weight_upt_r2,recover_data_i) begin : get_weight_crt_p
  if(recover_en_i == 1'b1) begin
    weight_crt_p <= recover_data_i;
  end else begin
    weight_crt_p <= weight_upt_r2;
  end
end
always @(recover_en_i,dn_sl_r_i,n_dn_sl_r_i) begin : get_dn_sl_signed_pp_and_n_dn_sl_signed_pp
  if(recover_en_i == 1'b1) begin
    dn_sl_pp   <= 'd0;
    n_dn_sl_pp <= 'd0;
  end else begin
    dn_sl_pp   <= dn_sl_r_i;
    n_dn_sl_pp <= n_dn_sl_r_i;
  end
end
// predict
always @(weight_crt_p) begin : get_weight_prd1_pp
  weight_prd1_pp <= {weight_crt_p[W_WIDTH-1], weight_crt_p};
end
always @(weight_crt_p,dn_sl_pp) begin : get_weight_prd2_pp
  weight_prd2_pp <= {weight_crt_p[W_WIDTH-1], weight_crt_p} + {{W_WIDTH+1-D_WIDTH{dn_sl_pp[D_WIDTH-1]}},dn_sl_pp};
end
always @(weight_crt_p,n_dn_sl_pp) begin : get_weight_prd3_pp
  weight_prd3_pp <= {weight_crt_p[W_WIDTH-1], weight_crt_p} + {{W_WIDTH+1-D_WIDTH{n_dn_sl_pp[D_WIDTH-1]}},n_dn_sl_pp}; // [singed, u/dof, data]
end
// clip
always @(weight_prd1_pp) begin : get_weight_prd1_clip_ppp
  weight_prd1_clip_ppp <= {weight_prd1_pp[W_WIDTH+1-1 -0],weight_prd1_pp[W_WIDTH+1-1 -2:0]};
end
always @(weight_prd2_pp) begin : get_weight_prd2_clip_ppp
  case (weight_prd2_pp[W_WIDTH+1-1 -0 : W_WIDTH+1-1 -1])
    2'b01   : weight_prd2_clip_ppp <= {1'b0,{W_WIDTH+1-2{1'b1}}};// uof
    2'b10   : weight_prd2_clip_ppp <= {1'b1,{W_WIDTH+1-2{1'b0}}};// dof
    default : weight_prd2_clip_ppp <= {weight_prd2_pp[W_WIDTH+1-1 -0],weight_prd2_pp[W_WIDTH+1-1 -2:0]}; //[singed, data]
  endcase
end
always @(weight_prd3_pp) begin : get_weight_prd3_clip_ppp
  case (weight_prd3_pp[W_WIDTH+1-1 -0 : W_WIDTH+1-1 -1])
    2'b01   : weight_prd3_clip_ppp <= {1'b0,{W_WIDTH+1-2{1'b1}}};// uof
    2'b10   : weight_prd3_clip_ppp <= {1'b1,{W_WIDTH+1-2{1'b0}}};// dof
    default : weight_prd3_clip_ppp <= {weight_prd3_pp[W_WIDTH+1-1 -0],weight_prd3_pp[W_WIDTH+1-1 -2:0]};
  endcase
end
// signed
assign dn_signed_pp         = {{W_WIDTH{dn_i[D_WIDTH-1]}},dn_i};
assign weight_prd1_clip_signed_ppp = {{D_WIDTH{weight_prd1_clip_ppp[W_WIDTH-1]}},weight_prd1_clip_ppp};
assign weight_prd2_clip_signed_ppp = {{D_WIDTH{weight_prd2_clip_ppp[W_WIDTH-1]}},weight_prd2_clip_ppp};
assign weight_prd3_clip_signed_ppp = {{D_WIDTH{weight_prd3_clip_ppp[W_WIDTH-1]}},weight_prd3_clip_ppp};

// mul
always @(weight_prd1_clip_signed_ppp,dn_signed_pp) begin : get_dw1_pp
  dw1_pppp <= weight_prd1_clip_signed_ppp * dn_signed_pp;
end
always @(weight_prd2_clip_signed_ppp,dn_signed_pp) begin : get_dw2_pp
  dw2_pppp <= weight_prd2_clip_signed_ppp * dn_signed_pp;
end
always @(weight_prd3_clip_signed_ppp,dn_signed_pp) begin : get_dw3_pp
  dw3_pppp <= weight_prd3_clip_signed_ppp * dn_signed_pp;
end
 /***************************************************************************************/
 /**************************************regist1******************************************/
 /***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : regist1
  if(rst_n == 1'b0) begin
    recover_data_r<= 'd0;
    recover_en_r <= 'd0;
  end else if(dn_en_i == 1'b1) begin
    recover_data_r<= recover_data_i;
    recover_en_r <= recover_en_i;
  end
end
 /***************************************************************************************/
 /**************************************stream1******************************************/
 /***************************************************************************************/
always @(recover_data_r,recover_en_r,weight_upt_r2) begin : get_weight_pre_rp
  if(recover_en_r == 1'b1) begin
    weight_pre_rp <= recover_data_r;
  end else begin
    weight_pre_rp <= weight_upt_r2;
  end
end
always @(vec_num_i,weight_pre_rp,dn_sl_r_i,n_dn_sl_r_i) begin : get_weight_upt_rpp
  case(vec_num_i)
    3'b001 : weight_upt_rpp <= {weight_pre_rp[W_WIDTH-1],weight_pre_rp};
    3'b010 : weight_upt_rpp <= {weight_pre_rp[W_WIDTH-1],weight_pre_rp}+{{W_WIDTH+1-D_WIDTH{dn_sl_r_i[D_WIDTH-1]}},dn_sl_r_i};
    3'b100 : weight_upt_rpp <= {weight_pre_rp[W_WIDTH-1],weight_pre_rp}+{{W_WIDTH+1-D_WIDTH{n_dn_sl_r_i[D_WIDTH-1]}},n_dn_sl_r_i};
    default: weight_upt_rpp <= 'd0;
  endcase
end
always @(weight_upt_rpp) begin : get_weight_upt_clip_rppp
  case({weight_upt_rpp[W_WIDTH+1-1 -0], weight_upt_rpp[W_WIDTH+1-1 -1]})
    2'b01  : weight_upt_clip_rppp <= {1'b0,{W_WIDTH+1-2{1'b1}}};//uof
    2'b10  : weight_upt_clip_rppp <= {1'b1,{W_WIDTH+1-2{1'b0}}};//dof
    default: weight_upt_clip_rppp <= {weight_upt_rpp[W_WIDTH+1-1 -0],weight_upt_rpp[W_WIDTH+1-1 -2:0]};
  endcase
end
 /***************************************************************************************/
 /**************************************regist2******************************************/
 /***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : get_weight_upt_r2
  if(rst_n == 1'b0) begin
    weight_upt_r2 <= 'd0;
  end else if(recover_en_i == 1'b1 && recover_en_r == 1'b0) begin
    weight_upt_r2 <= recover_data_i;
  end else if(dn_en_r == 1'b1) begin
    weight_upt_r2 <= weight_upt_clip_rppp;
  end
end
always @(posedge clk or negedge rst_n) begin : regist2
  if(rst_n == 1'b0) begin
    weight_upt_o_r2 <= 'd0;
  end else if(dn_en_r == 1'b1) begin
    weight_upt_o_r2 <= weight_upt_clip_rppp;
  end
end
 /***************************************************************************************/
 /**************************************  out  ******************************************/
 /***************************************************************************************/
assign dw_pdt1_o   = dw1_pppp;
assign dw_pdt2_o   = dw2_pppp;
assign dw_pdt3_o   = dw3_pppp;
assign weight_crt_o= weight_upt_o_r2;
assign crt_en_o    = dn_en_r2;
assign dw_en_o     = dn_en_i;
endmodule