module delay_spec_fst #(
        parameter           DATA_WIDTH = 12
)
(
  input  wire                 clk       ,
  input  wire                 rst_n     ,

  input  wire                 en_i      ,
  input  wire                 spec_fst_i,
  input  wire                 en_block_cnt_i,
  input  wire                 en_fst_blo_i,

  output wire                 en_o      ,
  output wire                 en_block_cnt_o,
  output wire                 en_fst_blo_o,
  output wire                 spec_fst_o
);
  reg                         en_r;
  reg                         en_r2;
  reg                         en_r3;
  reg                         en_r4;
  reg                         spec_fst_r    ;   
  reg                         spec_fst_r2   ;
  reg                         spec_fst_r3   ;
  reg                         spec_fst_r4   ;

  reg                         en_block_cnt_r ;
  reg                         en_block_cnt_r2;
  reg                         en_block_cnt_r3;
  reg                         en_block_cnt_r4;

  reg                         en_fst_blo_r ;
  reg                         en_fst_blo_r2;
  reg                         en_fst_blo_r3;
  reg                         en_fst_blo_r4;

always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    en_r  <= 1'b0;
    en_r2 <= 1'b0;
    en_r3 <= 1'b0;
    en_r4 <= 1'b0;
  end else begin
    en_r  <= en_i;
    en_r2 <= en_r;
    en_r3 <= en_r2;
    en_r4 <= en_r4;
  end
end
always @(posedge clk or negedge rst_n) begin : register1
  if(rst_n == 1'b0) begin
    spec_fst_r  <= 'd0;
    en_block_cnt_r<= 'd0;
    en_fst_blo_r<= 'd0;
  end else if(en_i == 1'b1) begin
    spec_fst_r  <= spec_fst_i;
    en_block_cnt_r<= en_block_cnt_i;
    en_fst_blo_r <= en_fst_blo_i;
  end
end
always @(posedge clk or negedge rst_n) begin : register2
  if(rst_n == 1'b0) begin
    spec_fst_r2  <= 'd0;
    en_block_cnt_r2<= 'd0;
    en_fst_blo_r2<= 'd0;
  end else if(en_r == 1'b1) begin
    spec_fst_r2  <= spec_fst_r;
    en_block_cnt_r2<= en_block_cnt_r;
    en_fst_blo_r2 <= en_fst_blo_r;
  end
end
always @(posedge clk or negedge rst_n) begin : register3
  if(rst_n == 1'b0) begin
    spec_fst_r3  <= 'd0;
    en_block_cnt_r3<= 'd0;
    en_fst_blo_r3<= 'd0;
  end else if(en_r2 == 1'b1) begin
    spec_fst_r3  <= spec_fst_r2;
    en_block_cnt_r3<= en_block_cnt_r2;
    en_fst_blo_r3 <= en_fst_blo_r2;
  end
end
always @(posedge clk or negedge rst_n) begin : register4
  if(rst_n == 1'b0) begin
    spec_fst_r4  <= 'd0;
    en_block_cnt_r4<= 'd0;
    en_fst_blo_r4<= 'd0;
  end else if(en_r3 == 1'b1) begin
    spec_fst_r4  <= spec_fst_r3;
    en_block_cnt_r4<= en_block_cnt_r3;
    en_fst_blo_r4 <= en_fst_blo_r3;
  end
end
assign en_o   = en_r2;
assign spec_fst_o = spec_fst_r4;
assign en_block_cnt_o = en_block_cnt_r4;
assign en_fst_blo_o = en_fst_blo_r4;
endmodule


