module delay2_new #(
  parameter         DATA_WIDH = 20
)
(
  input  wire                 clk,
  input  wire                 rst_n,

  input  wire                 en_i,
  input  wire [DATA_WIDH-1:0] data_i,

  output wire                 en_o,
  output wire [DATA_WIDH-1:0] data_o
);
  reg                         en_r;
  reg                         en_r2;
  reg         [DATA_WIDH-1:0] data_r;
  reg         [DATA_WIDH-1:0] data_r2;
always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    en_r  <= 1'b0;
    en_r2 <= 1'b0;
  end else begin
    en_r  <= en_i;
    en_r2 <= en_r;
  end
end
always @(posedge clk or negedge rst_n) begin : register1
  if(rst_n == 1'b0) begin
    data_r  <= 'd0;
  end else if(en_i == 1'b1) begin
    data_r  <= data_i;
  end
end
always @(posedge clk or negedge rst_n) begin : register2
  if(rst_n == 1'b0) begin
    data_r2  <= 'd0;
  end else if(en_r == 1'b1) begin
    data_r2  <= data_r;
  end
end
assign en_o   = en_r2;
assign data_o = data_r2;
endmodule