`timescale 1ns/1ps
module tb_conversion_out;
logic                clk;
logic                rst_n;

// ccsds interface
logic [23:0]         ccsds_code_cnt;
logic                ccsds_data_ready;
logic                ccsds_data_valid;
logic [127:0]        ccsds_data;
logic                ccsds_finish_flag;

//ddr interface
logic                cmprs_fifo_grant;
logic                cmprs_dout_req;
logic [23:0]         code_cnt;
logic                cnt_valid_lst;
logic                cnt_valid_fst;
logic                encode_data_valid;
logic [255:0]        encode_data;
logic                cmprs_dout_end;
//for tb
logic [23:0]         all_cnt;
logic                grant_r;
logic                grant_r2;
logic [23:0]         random_cnt;
logic [23:0]         out_cnt;
initial begin
  clk = 1'b0;
end
always #2.5 clk = ~clk;
initial begin
  rst_n <= 1'b0;
  ccsds_code_cnt <= 'd0;
  #200;
  rst_n <= 1'b1;
end
always @(posedge clk or negedge rst_n) begin : get_random_cnt
  if(rst_n == 1'b0) begin
    random_cnt <= 'd0;
  end else if(random_cnt == 11) begin
    random_cnt <= 'd0;
  end else begin
    random_cnt <= random_cnt + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_ccsds_data_valid
  if(rst_n == 1'b0) begin
    ccsds_data_valid <= 1'b0;
  end else if(ccsds_data_ready == 1'b1 && ccsds_data_valid == 1'b1 && all_cnt == 325) begin
    ccsds_data_valid <= 1'b0;
  end else if(random_cnt == 10) begin
    ccsds_data_valid <= 1'b1;
  end else begin
    ccsds_data_valid <= 1'b0;
  end
end
always @(posedge clk or negedge rst_n) begin : get_ccsds_data
  if(rst_n == 1'b0) begin
    ccsds_data <= 'd0;
  end else if(ccsds_data_ready == 1'b1 && ccsds_data_valid == 1'b1 && ccsds_data == 63) begin
    ccsds_data <= 'd0;
  end else if(ccsds_data_ready == 1'b1 && ccsds_data_valid == 1'b1) begin
    ccsds_data <= ccsds_data + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_all_cnt
  if(rst_n == 1'b0) begin
    all_cnt <= 'd0;
  end else if(ccsds_data_ready == 1'b1 && ccsds_data_valid == 1'b1 && all_cnt == 128+128+51-1) begin
    all_cnt <= 'd0;
  end else if(ccsds_data_ready == 1'b1 && ccsds_data_valid == 1'b1) begin
    all_cnt <= all_cnt + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_ccsds_finish_flag
  if(rst_n == 1'b0) begin
    ccsds_finish_flag <= 1'b0;
  end else if(ccsds_data_ready == 1'b1 && ccsds_data_valid == 1'b1 && all_cnt == 128+128+51-1) begin
    ccsds_finish_flag <= 1'b1;
  end else begin
    ccsds_finish_flag <= 1'b0;
  end
end
always @(posedge clk or negedge rst_n) begin : get_grant_r
  if(rst_n == 1'b0) begin
    grant_r <= 1'b0;
  end else if(cmprs_dout_req == 1'b1) begin
    grant_r <= 1'b1;
  end else begin
    grant_r <= 1'b0;
  end
end
always @(posedge clk or negedge rst_n) begin : get_grant_r2
  if(rst_n == 1'b0) begin
    grant_r2 <= 1'b0;
  end else begin
    grant_r2 <= grant_r;
  end
end
always @(posedge clk or negedge rst_n) begin : get_out_cnt
  if(rst_n == 1'b0) begin
    out_cnt <= 'd1;
  end else if(encode_data_valid == 1'b1) begin
    out_cnt <= out_cnt + 1'b1;
  end else begin
    out_cnt <= 'd1;
  end
end
assign cmprs_fifo_grant = grant_r & ~grant_r2;
conversion_out conversion_out_inst(
  .clk                  (clk),
  .rst_n                (rst_n),

  // ccsds interface
  .ccsds_code_cnt       (ccsds_code_cnt   ),
  .ccsds_data_ready     (ccsds_data_ready ),
  .ccsds_data_valid     (ccsds_data_valid ),
  .ccsds_data           (ccsds_data       ),
  .ccsds_finish_flag    (ccsds_finish_flag),

  //ddr interface
  .cmprs_fifo_grant     (cmprs_fifo_grant ),
  .cmprs_dout_req       (cmprs_dout_req   ),
  .code_cnt             (code_cnt         ),
  .cnt_valid_lst        (cnt_valid_lst    ),
  .cnt_valid_fst        (cnt_valid_fst    ),
  .encode_data_valid    (encode_data_valid),
  .encode_data          (encode_data      ),
  .cmprs_dout_end       (cmprs_dout_end   )
);
endmodule