module add_for_vec #(
    parameter     W_WIDTH = 12+2+1+16,//dn_width+16
    parameter     D_WIDTH    = 12+2+1
)
(
    input  wire                       clk,
    input  wire                       rst_n,

    input  wire                       dw_en,
    input  wire [W_WIDTH+D_WIDTH-1:0] dw1,
    // input  wire [W_WIDTH+D_WIDTH-1:0] dw2,
    input  wire [W_WIDTH+D_WIDTH-1:0] dw3,
    input  wire [W_WIDTH+D_WIDTH-1:0] dw4,
    input  wire [W_WIDTH+D_WIDTH-1:0] dw5,
    input  wire [W_WIDTH+D_WIDTH-1:0] dw6,
    input  wire [W_WIDTH+D_WIDTH-1:0] dw7,

    output wire                         vec_en,
    output wire [W_WIDTH+D_WIDTH+3-1:0] vec
);
    reg         [W_WIDTH+D_WIDTH-1:0]   dw1_r;
    reg         [W_WIDTH+D_WIDTH-1:0]   dw2_r;
    reg         [W_WIDTH+D_WIDTH-1:0]   dw3_r;
    reg         [W_WIDTH+D_WIDTH-1:0]   dw4_r;
    reg         [W_WIDTH+D_WIDTH-1:0]   dw5_r;
    reg         [W_WIDTH+D_WIDTH-1:0]   dw6_r;
    reg         [W_WIDTH+D_WIDTH-1:0]   dw7_r;

    reg         [W_WIDTH+D_WIDTH+1-1:0] dw1_ad_dw7_rp;
    reg         [W_WIDTH+D_WIDTH+1-1:0] dw3_ad_dw4_rp;
    reg         [W_WIDTH+D_WIDTH+1-1:0] dw5_ad_dw6_rp;
    reg         [W_WIDTH+D_WIDTH+2-1:0] dw17_ad_dw34_rpp;
    reg         [W_WIDTH+D_WIDTH+2-1:0] dw56_ad_dw7_rpp;
    reg         [W_WIDTH+D_WIDTH+3-1:0] vec_rppp;
    reg                                 vec_en_r;
always @(posedge clk or negedge rst_n) begin : register1
  if(rst_n == 1'b0) begin
    dw1_r <=  'd0;
    // dw2_r <=  'd0;//6.19 gai
    dw3_r <=  'd0;
    dw4_r <=  'd0;
    dw5_r <=  'd0;
    dw6_r <=  'd0;
    dw7_r <=  'd0;
  end else if(dw_en == 1'b1) begin
    dw1_r <=  dw1;
    // dw2_r <=  dw2;//6.19 gai
    dw3_r <=  dw3;
    dw4_r <=  dw4;
    dw5_r <=  dw5;
    dw6_r <=  dw6;
    dw7_r <=  dw7;
  end
end
always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    vec_en_r <= 1'b0;
  end else begin
    vec_en_r <= dw_en;
  end
end

// always @(dw1_r,dw2_r) begin : get_dw1_ad_dw2_rp
  // dw1_ad_dw2_rp <= {dw1_r[W_WIDTH+D_WIDTH-1],dw1_r} + {dw2_r[W_WIDTH+D_WIDTH-1],dw2_r};
// end
// always @(dw3_r,dw4_r) begin : get_dw3_ad_dw4_p
  // dw3_ad_dw4_rp <= {dw3_r[W_WIDTH+D_WIDTH-1],dw3_r} + {dw4_r[W_WIDTH+D_WIDTH-1],dw4_r};
// end
// always @(dw5_r,dw6_r) begin : get_dw5_ad_dw6_p
  // dw5_ad_dw6_rp <= {dw5_r[W_WIDTH+D_WIDTH-1],dw5_r} + {dw6_r[W_WIDTH+D_WIDTH-1],dw6_r};
// end

// always @(dw1_ad_dw2_rp,dw3_ad_dw4_rp) begin : get_dw12_ad_dw34_rpp
  // dw12_ad_dw34_rpp <= {dw1_ad_dw2_rp[W_WIDTH+D_WIDTH+1-1],dw1_ad_dw2_rp} + {dw3_ad_dw4_rp[W_WIDTH+D_WIDTH+1-1],dw3_ad_dw4_rp};
// end
// always @(dw5_ad_dw6_rp,dw7_r) begin : get_dw56_ad_dw7_rpp
  // dw56_ad_dw7_rpp <= {dw5_ad_dw6_rp[W_WIDTH+D_WIDTH+1-1],dw5_ad_dw6_rp} + {dw7_r[W_WIDTH+D_WIDTH-1],dw7_r[W_WIDTH+D_WIDTH-1],dw7_r};
// end

// always @(dw12_ad_dw34_rpp,dw56_ad_dw7_rpp) begin : get_vec_rppp
  // vec_rppp <= {dw12_ad_dw34_rpp[W_WIDTH+D_WIDTH+2-1],dw12_ad_dw34_rpp} + {dw56_ad_dw7_rpp[W_WIDTH+D_WIDTH+2-1],dw56_ad_dw7_rpp};
// end
always @(dw1_r,dw7_r) begin : get_dw1_ad_dw2_rp
  dw1_ad_dw7_rp <= {dw1_r[W_WIDTH+D_WIDTH-1],dw1_r} + {dw7_r[W_WIDTH+D_WIDTH-1],dw7_r};
end
always @(dw3_r,dw4_r) begin : get_dw3_ad_dw4_p
  dw3_ad_dw4_rp <= {dw3_r[W_WIDTH+D_WIDTH-1],dw3_r} + {dw4_r[W_WIDTH+D_WIDTH-1],dw4_r};
end
always @(dw5_r,dw6_r) begin : get_dw5_ad_dw6_p
  dw5_ad_dw6_rp <= {dw5_r[W_WIDTH+D_WIDTH-1],dw5_r} + {dw6_r[W_WIDTH+D_WIDTH-1],dw6_r};
end

always @(dw1_ad_dw7_rp,dw3_ad_dw4_rp) begin : get_dw12_ad_dw34_rpp
  dw17_ad_dw34_rpp <= {dw1_ad_dw7_rp[W_WIDTH+D_WIDTH+1-1],dw1_ad_dw7_rp} + {dw3_ad_dw4_rp[W_WIDTH+D_WIDTH+1-1],dw3_ad_dw4_rp};
end
always @(dw17_ad_dw34_rpp,dw5_ad_dw6_rp) begin : get_vec_rppp
  vec_rppp <= {dw17_ad_dw34_rpp[W_WIDTH+D_WIDTH+2-1],dw17_ad_dw34_rpp} + {dw5_ad_dw6_rp[W_WIDTH+D_WIDTH+1-1],dw5_ad_dw6_rp[W_WIDTH+D_WIDTH+1-1],dw5_ad_dw6_rp};
end

assign vec    = vec_rppp;
assign vec_en = vec_en_r;

endmodule