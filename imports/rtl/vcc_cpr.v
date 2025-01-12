module vcc_cpr #(
  parameter  K           = 13,
  parameter  ACC_WIDTH   = 29,
  parameter  P_WIDTH     = 8,
  parameter  CNT49_WIDTH = 14
)
(
  input  wire                   clk,
  input  wire                   rst_n,

  input  wire                   en_i,
  input  wire [P_WIDTH-1:0]     pcnt_i,
  input  wire [CNT49_WIDTH-1:0] cnt49_i,
  input  wire [ACC_WIDTH-1:0]   acc_i,

  output wire                   bflag,
  output wire                   sflag,
  output wire [P_WIDTH-1:0]     pcnt_o,
  output wire [CNT49_WIDTH-1:0] cnt49_o,
  output wire [ACC_WIDTH-1:0]   acc_o
);
  parameter   PCNT_ZEROS = ACC_WIDTH-P_WIDTH-K;
  reg [ACC_WIDTH-1:0]   acc_value_u_p;
  reg                   bflag_pp;
  reg                   sflag_pp;
  reg                   bflag_r;
  reg                   sflag_r;
  reg [P_WIDTH-1:0]     pcnt_r;
  reg [CNT49_WIDTH-1:0] cnt49_r;
  reg [ACC_WIDTH-1:0]   acc_r;
  wire[ACC_WIDTH-1:0]   test_pcnt;
  wire[6:0]             test_cnt49;

  reg                   en_r;
  reg                   bflag_ppp;
  reg                   sflag_ppp;
  reg [P_WIDTH-1:0]     pcnt_p ;
  reg [CNT49_WIDTH-1:0] cnt49_p;
  reg [ACC_WIDTH-1:0]   acc_p  ;

always @(posedge clk or negedge rst_n) begin: register
  if(rst_n == 1'b0) begin
    en_r <= 1'b0;
  end else begin
    en_r <= en_i;
  end
end

assign test_pcnt = {{PCNT_ZEROS{1'b0}},pcnt_i,{K{1'b0}}};
assign test_cnt49 = cnt49_i[CNT49_WIDTH-1:7];
always @(test_pcnt,test_cnt49,pcnt_i) begin : get_acc_value_d_p
  acc_value_u_p <= test_pcnt + pcnt_i - test_cnt49;
end
always @(acc_value_u_p,acc_i) begin : get_bflag_pp
  if(acc_i < acc_value_u_p) begin
    bflag_pp <= 1'b0;
  end else begin
    bflag_pp <= 1'b1;
  end
end
always @(bflag_pp) begin : get_sflag_pp
  sflag_pp <= ~bflag_pp;
end

always @(en_i, bflag_pp, sflag_pp, pcnt_i, cnt49_i, acc_i) begin : get_select
  if(en_i == 1'b1) begin
    bflag_ppp <= bflag_pp;
    sflag_ppp <= sflag_pp;
    pcnt_p    <= pcnt_i ;
    cnt49_p   <= cnt49_i;
    acc_p     <= acc_i  ;
  end else begin
    bflag_ppp <= 1'd0;
    sflag_ppp <= 1'd0;
    pcnt_p    <= 'd0;
    cnt49_p   <= 'd0;
    acc_p     <= 'd0;
  end
end

always @(posedge clk or negedge rst_n) begin : get_flag
  if(rst_n == 1'b0) begin
    bflag_r <= 1'd0;
    sflag_r <= 1'd0;
    pcnt_r  <= 'd0;
    cnt49_r <= 'd0;
    acc_r   <= 'd0;
  end else if(en_i == 1'b1 || (en_i == 1'b0 && en_r == 1'b1) ) begin
    bflag_r <= bflag_ppp;
    sflag_r <= sflag_ppp;
    pcnt_r  <= pcnt_p   ;
    cnt49_r <= cnt49_p  ;
    acc_r   <= acc_p    ;
  end
end
assign bflag   =  bflag_r;
assign sflag   =  sflag_r;
assign pcnt_o  =  pcnt_r;
assign cnt49_o =  cnt49_r;
assign acc_o   =  acc_r;
endmodule