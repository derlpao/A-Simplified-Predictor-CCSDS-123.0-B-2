module cmprs_receive # (
    parameter           X_LEN = 11,
    parameter           Y_LEN = 6,
    parameter           Z_LEN = 8,
    parameter   IN_DATA_WIDTH = 16,
    parameter  OUT_DATA_WIDTH = 16
)
(
  input  wire                sclk,
  input  wire                rst_n,
  input  wire [X_LEN-1:0]    X_max,
  input  wire [Z_LEN-1:0]    Z_max,
  input  wire [1:0]          mode,
  input  wire [3:0]          id_ratio,
  output wire                cmprs_rdf_data_ready,
  input  wire                cfg_en,
  input  wire                cmprs_rdf_data_valid,
  input  wire [IN_DATA_WIDTH-1:0]cmprs_rdf_rd_data,

  input  wire               encode_finish_ready,
  input  wire                wfifo_ready,

  output wire [X_LEN-1:0]    X_MAX_o,
  output wire [Y_LEN-1:0]    Y_MAX_o,
  output wire [Z_LEN-1:0]    Z_MAX_o,
  output wire [2:0]          mode_o,
  output wire [3:0]          id_ratio_o,
  output wire [OUT_DATA_WIDTH-1:0]data_o,
  output wire                en_o,
  output wire                rst_n_s_o,
  output wire                rst_n_f_o,
  output wire                rst_f_o,
  output wire [30:0]         up_img_bit_o,
  output wire [30:0]         low_img_bit_o,
  output wire                clk_ccsds

);
/*****rst*****/
  wire                       rst_n_f;
  wire                       rst_f;
  reg                        rst_n_f_r;
  reg                        rst_n_f_r2;
  reg                        rst_f_r;
  reg                        rst_f_r2;

  wire                       rst_n_s;
  reg                        rst_n_s_r;
  reg                        rst_n_s_r2;
/*****pll*****/
  // wire                       clk90m;
  // wire                       locked;
/*****sclk*****/
  reg  [X_LEN-1:0]           X_max_r;
  reg  [Z_LEN-1:0]           Z_max_r;
  reg  [Y_LEN-1:0]           Y_max_r;
  reg  [1:0]                 mode_r;
  reg  [3:0]                 id_ratio_r;
  reg  [1:0]                 mode_gray_rp;
  wire                       wfifo_ready_f;
  wire                       en_cnt;
  reg  [IN_DATA_WIDTH-1:0]   data_r;
  reg                        cmprs_data_valid_r;
  reg                        en_rp;
  reg  [X_LEN-1:0]           x_cnt_r;
  reg  [Y_LEN-1:0]           y_cnt_r;
  reg  [Z_LEN-1:0]           z_cnt_r;
  reg                        fifo_ready_r;
  reg                        fifo_ready_p;
  reg                        cmprs_ready_r;
  reg                         piexl_ready;

  reg  [OUT_DATA_WIDTH-1:0]  data_r2;
  reg                        en_r2;

/*****clk90m*****/
  reg                        wfifo_ready_s_r;
  reg                        data_valid;
  reg  [2:0]                 mode_onehot_s_r3p;
  reg  [2:0]                 mode_onehot_s_r4;
  reg  [30:0]                img_bit         ;
  reg  [30:0]                img_bit_r       ;
  reg  [30:0]                low_img_bit_r       ;
  reg  [30:0]                up_img_bit_r       ;
/*****CDC*****/
(* ASYNC_REG = "TRUE" *)reg  wfifo_ready_f_r;
(* ASYNC_REG = "TRUE" *)reg  wfifo_ready_f_r2;
(* ASYNC_REG = "TRUE" *)reg  wfifo_ready_f_r3;
(* ASYNC_REG = "TRUE" *)reg  [1:0] mode_gray_r2;
(* ASYNC_REG = "TRUE" *)reg  [1:0] mode_gray_s_r;
(* ASYNC_REG = "TRUE" *)reg  [1:0] mode_gray_s_r2;
(* ASYNC_REG = "TRUE" *)reg  [1:0] mode_gray_s_r3;
  wire [1:0]                 mode_gray_f;
  reg                          encode_finish_ready_r;
  reg                          encode_finish_ready_f_r2;
  reg                          encode_finish_ready_f_r3;
/*****FIFO*****/
  wire [OUT_DATA_WIDTH-1:0]  fifo_din;
  wire                       fifo_wr_en;
  reg                        fifo_rd_en;
  wire [OUT_DATA_WIDTH-1:0]  fifo_dout;
  wire                       fifo_full;
  wire                       fifo_empty;
  wire                       fifo_wr_rst_busy;
  wire                       fifo_rd_rst_busy;

/***************************************************************************************/
/************************************ sclk200m  ****************************************/
/***************************************************************************************/

always @(posedge sclk or negedge rst_n) begin : get_f_rst
  if(rst_n == 1'b0)begin
    rst_n_f_r  <= 1'b0;
    rst_n_f_r2 <= 1'b0;
    rst_f_r    <= 1'b1;
    rst_f_r2   <= 1'b1;
  end else begin
    rst_n_f_r  <= 1'b1;
    rst_n_f_r2 <= rst_n_f_r;
    rst_f_r    <= 1'b0;
    rst_f_r2   <= rst_f_r;
  end
end
assign rst_n_f       = rst_n_f_r2;
assign rst_f         = rst_f_r2;
// assign wfifo_ready_f = wfifo_ready_f_r3;
// always @(posedge sclk or negedge rst_n_f) begin : f_register
//   if(rst_n_f == 1'b0) begin
//     cmprs_data_valid_r <= 1'b0;
//     en_r2<= 1'b0;
//   end else begin
//     cmprs_data_valid_r <= cmprs_rdf_data_valid;
//     en_r2<= en_rp;
//   end
// end

/*always @(cmprs_data_valid_r,fifo_ready_r,piexl_ready) begin : get_en_rp
  en_rp <= cmprs_data_valid_r & fifo_ready_r&piexl_ready;
end*/

// always @(cmprs_data_valid_r,cmprs_ready_r) begin : get_en_rp
//   en_rp <= cmprs_data_valid_r & cmprs_ready_r;//ready和valid同时有效，才写入FIFO
// end

/*stream1*/
// always @(fifo_wr_rst_busy,fifo_full) begin : f_get_fifo_ready_p
//   if(fifo_wr_rst_busy == 1'b0) begin
//     fifo_ready_p <= ~fifo_full;
//   end else begin
//     fifo_ready_p <= 1'b0;
//   end
// end
always @(posedge sclk or negedge rst_n_f) begin : f_max_temp
  if(rst_n_f == 1'b0) begin
    X_max_r <= 'd0;
    Z_max_r <= 'd0;
    Y_max_r <= 'd32;//修改
    mode_r  <= 'd0;
    id_ratio_r<= 'd0;
  end else if(cfg_en == 1'b1) begin
    X_max_r <= X_max;
    Z_max_r <= Z_max;
    Y_max_r <= 'd32;
    mode_r  <= mode;
    id_ratio_r<= id_ratio;
  end
end

// always @(posedge sclk or negedge rst_n_f) begin : f_get_data_r
//   if(rst_n_f == 1'b0) begin
//     data_r <= 'd0;
//   end else if(cmprs_rdf_data_valid == 1'b1) begin
//     data_r <= cmprs_rdf_rd_data;
//   end
// end

assign  en_cnt =  fifo_rd_en;//FIFO读-计数器

always @(posedge sclk or negedge rst_n_f) begin : f_get_x_cnt_r
  if(rst_n_f == 1'b0) begin
    x_cnt_r <= 'd0;
  end else if(en_cnt == 1'b1 && x_cnt_r == X_max_r-1) begin
    x_cnt_r <= 'd0;
  end else if(en_cnt == 1'b1) begin
    x_cnt_r <= x_cnt_r + 1'b1;
  end
end
always @(posedge sclk or negedge rst_n_f) begin : f_get_y_cnt_r
  if(rst_n_f == 1'b0) begin
    y_cnt_r <= 'd0;
  end else if(en_cnt == 1'b1 && x_cnt_r == X_max_r-1 && z_cnt_r == Z_max_r-1 && y_cnt_r == Y_max_r-1) begin
    y_cnt_r <= 'd0;
  end else if(en_cnt == 1'b1 && x_cnt_r == X_max_r-1 && z_cnt_r == Z_max_r-1) begin
    y_cnt_r <= y_cnt_r + 1'b1;
  end
end
always @(posedge sclk or negedge rst_n_f) begin : f_get_z_cnt_r
  if(rst_n_f == 1'b0) begin
    z_cnt_r <= 'd0;
  end else if(en_cnt == 1'b1 && x_cnt_r == X_max_r-1 && z_cnt_r == Z_max_r-1) begin
    z_cnt_r <= 'd0;
  end else if(en_cnt == 1'b1 && x_cnt_r == X_max_r-1) begin
    z_cnt_r <= z_cnt_r + 1'b1;
  end
end

// always @(posedge sclk or negedge rst_n_f) begin : f_get_fifo_ready_r
//   if(rst_n_f == 1'b0) begin
//     fifo_ready_r <= 1'b0;
//   end else begin
//     fifo_ready_r <= fifo_ready_p & wfifo_ready_f;//当前块FIFO以及最后模块fifo准备信号
//   end
// end

// always @(posedge sclk or negedge rst_n_f) begin : f_get_cmprs_ready_r
//   if(rst_n_f == 1'b0) begin
//     cmprs_ready_r <= 1'b0;
//   end else begin
//     cmprs_ready_r <= fifo_ready_r;//8_10gai 8_11gai
//   end
// end

//将mode_r灰度编码
always @(mode_r) begin : f_get_mode_gray_rp
  mode_gray_rp[1] <= mode_r[1];
  mode_gray_rp[0] <= mode_r[1] ^ mode_r[0];
end

/*stream2*/
always @(posedge sclk or negedge rst_n_f) begin : f_get_mode_gray_r2
  if(rst_n_f == 1'b0) begin
    mode_gray_r2 <= 'd0;
  end else begin
    mode_gray_r2 <= mode_gray_rp;
  end
end

/*always @(posedge sclk or negedge rst_n_f) begin : f_get_data_r2
  if(rst_n_f == 1'b0) begin
    data_r2 <= 'd0;
  end else begin
    data_r2 <= data_r;
data_r2  end
end*/

//scp 8_7 根据位宽截断
always @(*) begin : f_get_data_r2
   if(mode_r==2'd0)begin//12bit
    data_r2 <= {4'b0,fifo_dout[11:0]};
  end else if(mode_r==2'd1)begin//14bit
    data_r2 <= {2'b0,fifo_dout[13:0]};
  end else if(mode_r==2'd2)begin//16bit
    data_r2 <= fifo_dout;
  end
end

/***************************************************************************************/
/************************************ clk  90m  ****************************************/
/***************************************************************************************/
/**************************************get_rst******************************************/
assign rst_n_s  = rst_n_s_r2;
always @(posedge sclk or negedge rst_n) begin : get_s_rst
  if(rst_n == 1'b0)begin
    rst_n_s_r  <= 1'b0;
    rst_n_s_r2 <= 1'b0;
  end else begin
    rst_n_s_r  <= 1'b1;
    rst_n_s_r2 <= rst_n_s_r;
  end
end
/***************************************************************************************/
// always @(posedge sclk or negedge rst_n_s) begin : s_register
//   if(rst_n_s == 1'b0) begin
//     wfifo_ready_s_r <= 1'b0;
//     data_valid      <= 1'b0;
//   end else begin
//     wfifo_ready_s_r <= wfifo_ready;
//     data_valid      <= fifo_rd_en;
//   end
// end
always @(*) begin : s_get_fifo_rd_en
  if(fifo_rd_rst_busy == 1'b0) begin
    fifo_rd_en <= wfifo_ready & ~fifo_empty & piexl_ready;//8_11gai 像素计满一块就不读
  end else begin
    fifo_rd_en <= 1'b0;
  end
end

always @(mode_gray_s_r3) begin : get_mode_onehot_s_r3p
  case (mode_gray_s_r3)
    2'b00   : mode_onehot_s_r3p <= 3'b001;
    2'b01   : mode_onehot_s_r3p <= 3'b010;
    2'b11   : mode_onehot_s_r3p <= 3'b100;
    default : mode_onehot_s_r3p <= 3'b001;
  endcase
end

// always @(mode_r,X_max_r,Y_max_r,Z_max_r) begin : get_img_bit
//   case (mode_r)
//     2'd0   :  img_bit <= X_max_r*(Y_max_r-1)*Z_max_r*12;
//     2'd1   :  img_bit <= X_max_r*(Y_max_r-1)*Z_max_r*14;
//     2'd2   :  img_bit <= X_max_r*(Y_max_r-1)*Z_max_r*16;
//     default :  img_bit <= 'd0;            
//   endcase
// end
always @(mode_r,X_max_r,Y_max_r,Z_max_r) begin : get_img_bit
  reg [27:0] temp;
  temp = X_max_r*(Y_max_r-1)*Z_max_r;  
  case (mode_r)
    2'd0   :  img_bit <= temp << 3 + temp << 2;  // 相当于 temp * 12 (temp * 8 + temp * 4)
    2'd1   :  img_bit <= (temp << 3) + (temp << 2) + temp << 1;  // 相当于 temp * 14 (temp * 8 + temp * 4 + temp * 2)
    2'd2   :  img_bit <= temp << 4;  // 相当于 temp * 16 (temp * 16)
    default :  img_bit <= 'd0;
  endcase
end

always @(posedge sclk or negedge rst_n_s) begin : get_mode_onehot_s_r4
  if (rst_n_s == 1'b0) begin
    mode_onehot_s_r4 <= 'd0;
  end else begin
    mode_onehot_s_r4 <= mode_onehot_s_r3p;
  end
end

/***************************************************************************************/
/**************************************  CDC  ******************************************/
/***************************************************************************************/
/**********************************sclk to clk90m**************************************/
assign mode_gray_f = mode_gray_r2;
always @(posedge sclk or negedge rst_n_s) begin : CDC_mode_gray
  if(rst_n_s == 1'b0) begin
    mode_gray_s_r  <= 'd0;
    mode_gray_s_r2 <= 'd0;
    mode_gray_s_r3 <= 'd0;
     img_bit_r      <= 'd0;
  end else begin
    mode_gray_s_r  <= mode_gray_f;
    mode_gray_s_r2 <= mode_gray_s_r;
    mode_gray_s_r3 <= mode_gray_s_r2;
     img_bit_r      <= img_bit       ;
  end
end
always @(posedge sclk or negedge rst_n_s) begin : get_img_bit_r
  if(rst_n_s == 1'b0) begin
    up_img_bit_r      <= 'd0;
    low_img_bit_r     <= 'd0;
  end else begin
    case(id_ratio_r)
     //   'd1    img_bit_r      <= img_bit       ;
        'd4 : begin  up_img_bit_r      <= {2'b00,img_bit_r[30:2]};
               low_img_bit_r     <= {2'b00,img_bit_r[30:2]} - {4'b0000,img_bit_r[30:4]};//gai8_13  
               end
        'd8 :  begin up_img_bit_r      <= {3'b00,img_bit_r[30:3]};
               low_img_bit_r     <= {3'b000,img_bit_r[30:3]} - {5'b00000,img_bit_r[30:5]};  
               end
        default : begin up_img_bit_r   <= 'd0;
                  low_img_bit_r  <= 'd0; 
                  end
    endcase
  end
end
/**********************************clk90m to sclk**************************************/
// always @(posedge sclk or negedge rst_n_f) begin : CDC_w_fifo_ready
//   if(rst_n_f == 1'b0) begin
//     wfifo_ready_f_r  <= 1'b0;
//     wfifo_ready_f_r2 <= 1'b0;
//     wfifo_ready_f_r3 <= 1'b0;
//   end else begin
//     wfifo_ready_f_r  <= wfifo_ready;
//     wfifo_ready_f_r2 <= wfifo_ready_f_r;
//     wfifo_ready_f_r3 <= wfifo_ready_f_r2;
//   end
// end

always @(posedge sclk or negedge rst_n_f) begin : CDC_encode_finish_flag_ready
  if(rst_n_f == 1'b0) begin
    encode_finish_ready_r  <= 1'b0;
    encode_finish_ready_f_r2 <= 1'b0;
    encode_finish_ready_f_r3 <= 1'b0;
  end else begin
    encode_finish_ready_r  <= encode_finish_ready;
    encode_finish_ready_f_r2 <= encode_finish_ready_r;
    encode_finish_ready_f_r3 <= encode_finish_ready_f_r2;
  end
end



/*fifo*/
assign fifo_din = cmprs_rdf_rd_data;
assign fifo_wr_en = cmprs_rdf_data_valid & ~fifo_full;


/*always @(*) begin
  if (encode_finish_ready_f_r3 == 1'b1) begin
    piexl_ready = 'd1;
  end else if (x_cnt_r == X_max_r-1 && z_cnt_r == Z_max_r-1 && y_cnt_r == Y_max_r-1) begin
    piexl_ready = 'd0;
  end else begin
    piexl_ready = 'd1; 
  end
end*/

always @(posedge sclk or negedge rst_n_s) begin : get_piexl_read//新增控制ready
  if (rst_n_s == 1'b0) begin
    piexl_ready <='d1;
  end else if(encode_finish_ready_f_r3==1'b1)begin
    piexl_ready <='d1;
  end else if(x_cnt_r == X_max_r-1 && z_cnt_r == Z_max_r-1 && y_cnt_r == Y_max_r-1)begin //一块图像接收完毕
    piexl_ready <='d0;
  end 
end

/***************************************************************************************/
/**************************************  out  ******************************************/
/***************************************************************************************/

assign cmprs_rdf_data_ready  = ~fifo_full;//8_11gai
assign X_MAX_o   = X_max_r;
assign Y_MAX_o   = Y_max_r;
assign Z_MAX_o   = Z_max_r;
assign data_o    = data_r2;
assign en_o      = fifo_rd_en;
assign rst_n_s_o = rst_n_s;
assign rst_n_f_o = rst_n_f;
assign rst_f_o   = rst_f;
assign clk_ccsds = sclk;
assign mode_o    = mode_onehot_s_r4;
assign id_ratio_o= id_ratio_r;
assign up_img_bit_o = up_img_bit_r;
assign low_img_bit_o = low_img_bit_r;

fifo_16bit rfifo_13_2 (
  .rst(rst_f),                  // input wire rst
  .wr_clk(sclk),            // input wire wr_clk
  .rd_clk(sclk),            // input wire rd_clk
  .din(fifo_din),                  // input wire [23 : 0] din
  .wr_en(fifo_wr_en),              // input wire wr_en
  .rd_en(fifo_rd_en),              // input wire rd_en
  .dout(fifo_dout),                // output wire [23 : 0] dout
  .full(),
  .empty(fifo_empty),              // output wire empty
  .prog_full(fifo_full),           // output wire full
  .wr_rst_busy(fifo_wr_rst_busy),  // output wire wr_rst_busy
  .rd_rst_busy(fifo_rd_rst_busy)  // output wire rd_rst_busy
);
endmodule
