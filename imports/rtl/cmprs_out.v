module cmprs_out (
  input  wire                clk_ccsds,
  input  wire                sclk,
  input  wire                rst_n_s,
  input  wire                rst_n_f,
  // sscds write
  input  wire                w_en,//一块图像处理结束，或当前64bit码流存满 使能
  input  wire [63:0]         w_data,//压缩码流输入
  input  wire                eob,//当前块图像压缩结束 
  input  wire                en_b_i,//包头 拼到八个字节的时候
  input  wire [30:0]         byte_cnt,//统计压缩码流的字节
  input  wire   [5:0]        quant_near_i,//写入包头的near

  output wire                wfifo_ready,//两个FIFO准备好写入信号
  output wire                encode_finish_ready,
  // out control
  // output wire [23:0]         code_cnt,
 (*keep="true"*) input  wire                encode_data_ready,//从机ready信号
  output wire                encode_data_valid,//输出码流有效信号
  output wire [63:0]         encode_data,//输出码流
  output wire                encode_finish_flag//一块图像结束标志
  // output wire                output_cpr_req
);
/****clk ccsds****/
  integer                    file_pdt_encode_data;
 // wire                       TEST_full;
  reg                        rst_s_r;
  reg         [63:0]         w_data_r;
  reg                        w_en_r;
  reg                        eob_r;
  reg         [30:0]         byte_cnt_r;
  reg         [30:0]         byte_cnt_rp;
  (*keep="true"*)reg                        wfifo_ready_r;
/****sclk****/
  reg                        finish;
  reg                        finish_r;
  reg                        finish_one;
  reg                        data_fifo_ready;
  reg                        cnt_fifo_ready;
  (*keep="true"*)wire                        fifo_ready;
  reg                        fifo_ready_r;
  wire         [30:0]        byte_cnt_f;
  reg                        en_fin;
  reg          [63:0]        encode_data_r;
  reg                        en_first_d;
  reg                        en_first_r;
  wire                       en_first_clk;
  wire                       en_last_clk;
  reg                       en_baotou_valid;
  (*keep="true"*)reg                       en_baotou_ready;
  reg                       en_baowei_valid;
  wire                       en_baowei_empty;
  reg                       en_baowei_empty_r;
  reg                        finish_p; 
  reg                        finish_pp;
  wire                        finish_last;
  reg                     encode_finish_ready_r;
 // reg                        finish_ppp;
/****FIFO****/
  wire         [63:0]       data_fifo_din;
  (*keep="true"*)wire                       data_fifo_wr_en;
  wire         [63:0]       data_fifo_dout;
 (*keep="true"*) wire                       data_fifo_rd_en;

 (*keep="true"*) wire                       data_fifo_full;
  wire                       data_fifo_empty;
  wire                       data_fifo_wr_rst_busy;
  wire                       data_fifo_rd_rst_busy;

  wire         [30:0]        cnt_fifo_din;
(*keep="true"*)  wire                       cnt_fifo_wr_en;
  wire                       cnt_fifo_rd_en;
  wire         [30:0]        cnt_fifo_dout;
(*keep="true"*)  wire                       cnt_fifo_full;
  wire                       cnt_fifo_empty;
  wire                       cnt_fifo_wr_rst_busy;
  wire                       cnt_fifo_rd_rst_busy;
  reg                        en_first_clk_r;
  reg                        en_last_clk_r;
  reg                        finish_last_r;
/****clk ccsds****/
//rst
always @(posedge clk_ccsds or negedge rst_n_s) begin : s_get_rst
  if(rst_n_s == 1'b0) begin
    rst_s_r <= 1'b1;
  end else begin
    rst_s_r <= ~rst_n_s;
  end
end
always @(posedge clk_ccsds or negedge rst_n_s) begin : s_register
  if(rst_n_s == 1'b0) begin
    w_en_r <= 1'b0;
  end else begin
    w_en_r <= w_en;//64bit使能
  end
end
always @(posedge clk_ccsds or negedge rst_n_s) begin : s_get_w_data_r
  if(rst_n_s == 1'b0) begin
    w_data_r  <= 'd0;
    eob_r     <= 'd0;
    byte_cnt_r<= 'd0;
    // en_r      <= 'd0;
  end else if(w_en == 1'b1) begin
    w_data_r  <= w_data;
    eob_r     <= eob;
    byte_cnt_r<= byte_cnt;
    // en_r      <= 'd1;
  end
end

// assign en_t = (en_r ^ en_r_p) & w_en_r;
// assign en_t = en_b_i ^ en_r;
// always @(posedge clk_ccsds or negedge rst_n_s) begin : s_get_w_data_t
  // if(rst_n_s == 1'b0) begin
    // w_data_t = {{28{1'b1}}, {36{1'b0}}};
  // end else if(en_t == 1'b1) begin
    // w_data_t <= {{28{1'b1}}, {4{1'b0}},w_data[63:32]};
  // end else if(w_en == 1'b1) begin
    // w_data_t <= {w_data_r[31:0],w_data[63:32]};
  // end else if(en_fin_t == 1'b1) begin
    // w_data_t <= {{8{'b0}},cnt_fifo_dout, 'hFFEEDDC9};
  // end
// end

always @(posedge clk_ccsds or negedge rst_n_s) begin : s_get_wfifo_ready_r
  if(rst_n_s == 1'b0) begin
    wfifo_ready_r <= 1'b0;
  end else if(data_fifo_wr_rst_busy == 1'b0 && cnt_fifo_wr_rst_busy == 1'b0) begin//数据fifo和计数器fifo都可以写入数据
    wfifo_ready_r <= (~data_fifo_full) & (~cnt_fifo_full);//数据FIFO和计数FIFO都不满，那么就允许向它们写入数据，wfifo_ready_r会被设置为高电平（1），表示写入就绪
  end else begin
    wfifo_ready_r <= 1'b0;
  end
end
always @(eob_r,byte_cnt_r) begin : s_get_byte_cnt_rp
  if(eob_r == 1'b1) begin//一块图像处理结束
    byte_cnt_rp <= byte_cnt_r;//字节数
  end else begin
    byte_cnt_rp <= 'd0;
  end
end
// always @(posedge clk_ccsds or negedge rst_n_s) begin : s_get_en_fin_test
  // if(rst_n_s == 1'b0) begin
    // en_fin_test   <= 1'b0;
    // en_fin_test_r <= 1'b0;
  // end else if(en_fin == 1'b1) begin
    // en_fin_test   <= 1'b1;
    // en_fin_test_r <= en_fin_test;
  // end
// end
// assign en_fin_t = en_fin_test ^ en_fin_test_r;
// always @(posedge clk_ccsds or negedge rst_n_s) begin : s_get_en_fifo_fin_w
  // if(rst_n_s == 1'b0) begin
    // en_fifo_fin_w   <= 1'b0;
    // en_fifo_fin_w_r <= 1'd0;
  // end else if(en_fin_test == 1'b1) begin
    // en_fifo_fin_w     <= en_fin_t;
    // en_fifo_fin_w_r   <= en_fifo_fin_w;
  // end
// end

/****sclk****/
always @(byte_cnt_f,fifo_ready_r) begin : f_get_finish
  if(byte_cnt_f != 0) begin//
    finish <= fifo_ready_r ;//去掉encode_data_ready 代表一块图像压缩完毕
  end else begin
    finish <= 1'b0;
  end
end

// always @(fifo_ready,en_baotou_ready,encode_data_ready) begin : f_get_data_fifo_rd_en  
//         data_fifo_rd_en <= fifo_ready & en_baotou_ready& encode_data_ready;//读 数据fifo使能 ； //两个fifo读准备好信号，从机ready信号 ；先检测到从机ready信号，再读压缩数据
// end                                                        //axi修改 去掉了下级ready信号，当包头输出数据后Valid拉低，才可以读数据
                                                            //再次修改，恢复ready信号，当ready信号为高时，读fifo才读
// always @(data_fifo_rd_rst_busy,data_fifo_empty) begin : f_get_data_fifo_ready
//   if(data_fifo_rd_rst_busy == 1'b0) begin//数据fifo可读 
//     data_fifo_ready <= ~data_fifo_empty;//数据fifo不是空的 data_fifo_ready为1  写准备好信号
//   end else begin
//     data_fifo_ready <= 1'b0;
//   end
// end
assign data_fifo_rd_en = fifo_ready & en_baotou_ready& encode_data_ready;

// always @(cnt_fifo_rd_rst_busy,cnt_fifo_empty) begin : f_get_cnt_fifo_ready
//   if(cnt_fifo_rd_rst_busy == 1'b0) begin//计数FIFO，准备好读的信号
//     cnt_fifo_ready <= ~cnt_fifo_empty;//计数fifo不是空的 cnt_fifo_ready为1 读准备好信号
//   end else begin
//     cnt_fifo_ready <= 1'b0;
//   end
// end

//always @(cnt_fifo_empty,cnt_fifo_ready) begin : get_fifo_ready
assign  fifo_ready = (~cnt_fifo_empty) & (~data_fifo_empty);//两个fifo读准备好信号 
//end

always @(posedge sclk or negedge rst_n_f) begin : f_get_register
  if(rst_n_f == 1'b0) begin
     finish_r <= 1'b0;
     finish_p <= 1'd0;
     finish_pp <= 1'd0;
    // finish_ppp <= 1'd0;
  end else begin
     finish_r <= finish;
     finish_p <= finish_r;
     finish_pp <= finish_p;
    // finish_ppp <= finish_pp;
  end
end
//
always @(posedge sclk or negedge rst_n_f) begin : get_en_baowei_valid
    if(rst_n_f == 1'b0) begin
        en_baowei_valid <= 1'b0;
    end else if(en_last_clk_r== 1'b1)begin//拼包尾信号
        en_baowei_valid <= 1'b1; //包尾valid拉高
    end else if(encode_data_ready == 1'b1)begin
        en_baowei_valid <= 1'b0;//把valid拉低
end
end


/*always @(posedge sclk or negedge rst_n_f) begin : get_en_baowei_valid_
    if(encode_data_ready == 1'b1) begin//下级的ready信号
        en_baowei_valid <= 1'b0;//把valid拉低
    end 
end
*/

always @(posedge sclk or negedge rst_n_f) begin : get_data_fifo_ready_r
  if(rst_n_f == 1'b0) begin
     fifo_ready_r <= 1'b0;
  end else if(data_fifo_rd_en == 1'b1) begin//检测到从机的ready信号  ；//axi修改，先不检测ready ，准备好就先拉高ready信号
     fifo_ready_r <= 1'b1;//fifo_ready_r为读数据FIFO使能，将其作为valid信号
  end else if(encode_data_ready == 1'b1) begin//检测到下一级的ready信号后才拉低valid信号
     fifo_ready_r <= 1'b0;
  end 
end

always @(posedge sclk or negedge rst_n_f) begin : get_first_data_en
    if(rst_n_f == 1'b0) begin
        en_first_d <= 'd0;
        en_first_r <= 'd0;
    end else begin
        en_first_d <= en_b_i;
        en_first_r <= en_first_d;
    end
end


//assign en_first_clk = en_first_d ^ en_first_r & en_first_d;//AXI修改第一个包头信号 只拉高一次
assign en_first_clk = (en_first_d ^ en_first_r )& en_first_d;//AXI修改第一个包头信号 只拉高一次

always @(posedge sclk or negedge rst_n_f) begin
    if (rst_n_f == 1'b0) begin
        en_first_clk_r <= 1'b0;
    end else begin
        en_first_clk_r <= en_first_clk;//确保延迟完整一个周期
    end
end
//7_20
assign finish_last = (finish_p ^ finish_pp) & finish_pp;//可以处理包尾了

always @(posedge sclk or negedge rst_n_f) begin
    if (rst_n_f == 1'b0) begin
        en_last_clk_r <= 1'b0;
    end else begin
        en_last_clk_r <= en_last_clk;//确保延迟完整一个周期
    end
end

// always @(posedge sclk or negedge rst_n_f) begin
//     if (rst_n_f == 1'b0) begin
//         finish_last_r <= 1'b0;
//     end else begin
//         finish_last_r <= finish_last;//确保延迟完整一个周期
//     end
// end

always @(posedge sclk or negedge rst_n_f) begin
    if (rst_n_f == 1'b0) begin
        finish_one <= 1'b0;
    end else if (finish_last) begin
        finish_one <= 1'b1;//压缩结束，持续多个周期
    end else if(encode_finish_flag) begin//输出包尾后
        finish_one <= 1'b0;
    end
end

//assign en_baowei_empty =finish_one&data_fifo_empty&encode_data_ready;//FIFO为空,且最后一个数据输出了，才能准备输出包尾。
assign en_baowei_empty =finish_one&encode_data_ready;//,且最后一个数据输出了，才能准备输出包尾。//8_10gai

always @(posedge sclk or negedge rst_n_f) begin
    if (rst_n_f == 1'b0) begin
        en_baowei_empty_r <= 1'b0;
    end else  begin
        en_baowei_empty_r <= en_baowei_empty;
    end
end

//assign en_last_clk = (finish_p ^ finish_pp) & finish_pp;////AXI修改最后一个包尾信号 只拉高一次
assign en_last_clk = (en_baowei_empty ^ en_baowei_empty_r) & en_baowei_empty;////AXI修改最后一个包尾信号 只拉高一次
// 7_20 end

always @(posedge sclk or negedge rst_n_f) begin : get_en_baotou_valid
    if(rst_n_f == 1'b0) begin
        en_baotou_valid <= 1'b0;
    end else if(en_first_clk_r== 1'b1)begin//拼包头信号
        en_baotou_valid <= 1'b1; //包头valid拉高
    end else if(encode_data_ready == 1'b1) begin//下级的ready信号
        en_baotou_valid <= 1'b0;//把valid拉低
    end
end

always @(posedge sclk or negedge rst_n_f) begin : get_en_baotou_ready
    if(rst_n_f == 1'b0) begin
        en_baotou_ready <= 1'b0; //包头输出出去信号
    end else if(en_first_clk_r== 1'b1)begin//包头已经输出
        en_baotou_ready <= 1'b1; //包头ready拉高
    end else if(encode_finish_flag == 1'b1) begin//一块结束
        en_baotou_ready<= 1'b0;//拉低
    end
end
/*always @(posedge sclk or negedge rst_n_f) begin : get_en_baotou_valid_
    if(encode_data_ready == 1'b1) begin//下级的ready信号
        en_baotou_valid <= 1'b0;//把valid拉低
    end 
end*/

always @(en_baotou_valid,cnt_fifo_dout,en_baowei_valid,data_fifo_dout,fifo_ready_r,quant_near_i) begin : get_encode_data_r
    if(en_baotou_valid == 1'b1) begin//先输出包头
        encode_data_r <= {{28{1'b1}}, {30{1'b0}},quant_near_i};
    end else if(en_baowei_valid == 1'd1) begin//最后输出包尾  finish_pp
        encode_data_r <= {{8{1'b0}},cnt_fifo_dout, 32'hFFEEDDC9};
    end else if(fifo_ready_r == 1'b1)begin
        encode_data_r <= data_fifo_dout;
    end else begin
        encode_data_r <= data_fifo_dout;
    end
end


always @(posedge sclk or negedge rst_n_f) begin : get_encode_finish_ready_r
    if(rst_n_f == 1'b0) begin
        encode_finish_ready_r <= 1'b0; //包头输出出去信号
    end else if(encode_finish_flag== 1'b1&&encode_data_ready== 1'b1)begin//包头已经输出
        encode_finish_ready_r <= 1'b1; //包头ready拉高
    end else  begin//一块结束
        encode_finish_ready_r<= 1'b0;//把valid拉低
    end
end



/****out****/

// assign code_cnt           = byte_cnt_f;
assign encode_data_valid  = en_baotou_valid | fifo_ready_r | en_baowei_valid;
assign encode_data        = encode_data_r;
//assign encode_finish_flag = finish_pp;
assign encode_finish_flag = en_baowei_valid;
assign wfifo_ready        = wfifo_ready_r;//允许对两个fifo写入数据信号，wfifo准备好写的信号
// assign output_cpr_req     = en_first_clk | w_en_r | finish_pp;
assign encode_finish_ready        = encode_finish_ready_r;
/****fifo****/
assign data_fifo_din   = w_data_r;//压缩数据
assign data_fifo_wr_en = w_en_r ;

assign cnt_fifo_din   = byte_cnt_rp;//字节计数数据
assign cnt_fifo_wr_en = w_en_r;
assign cnt_fifo_rd_en = data_fifo_rd_en;
assign byte_cnt_f     = cnt_fifo_dout;
// always @(posedge sclk) begin
    // if (encode_data_valid == 1'b1) begin
        // file_pdt_encode_data = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_19/encode_data.txt", "a"); 
        // if (file_pdt_encode_data != 0 ) begin
            // $fwrite(file_pdt_encode_data, "%16h\n", encode_data);
            // $fclose(file_pdt_encode_data);
        // end
    // end
// end
fifo128bit fifo128bit_inst (
  .rst         (rst_s_r),                    // input wire rst
  .wr_clk      (clk_ccsds),              // input wire wr_clk
  .rd_clk      (sclk),              // input wire rd_clk
  .din         (data_fifo_din),                    // input wire [127 : 0] din
  .wr_en       (data_fifo_wr_en),                // input wire wr_en
  .rd_en       (data_fifo_rd_en),                // input wire rd_en
  .dout        (data_fifo_dout),                  // output wire [127 : 0] dout
  .full        (),                  // output wire full
  .prog_full   (data_fifo_full),        // output wire prog_full ； fifo将满标志
  .empty       (data_fifo_empty),                // output wire empty
  .wr_rst_busy (data_fifo_wr_rst_busy),    // output wire wr_rst_busy 当fifo可写状态时wr_rst_busy为0，fifo写入重置时wr_rst_busy为1表示忙碌，不能进行写入操做
  .rd_rst_busy (data_fifo_rd_rst_busy)    // output wire rd_rst_busy fifo可读时rd_rst_busy为0
);

fifo_forcnt fifo_forcnt_inst (
  .rst         (rst_s_r),                  // input wire rst
  .wr_clk      (clk_ccsds),            // input wire wr_clk
  .rd_clk      (sclk),            // input wire rd_clk
  .din         (cnt_fifo_din),                  // input wire [23 : 0] din
  .wr_en       (cnt_fifo_wr_en),              // input wire wr_en
  .rd_en       (cnt_fifo_rd_en),              // input wire rd_en
  .dout        (cnt_fifo_dout),                // output wire [23 : 0] dout
  .full        (cnt_fifo_full),                // output wire full
  .empty       (cnt_fifo_empty),              // output wire empty
  .wr_rst_busy (cnt_fifo_wr_rst_busy),  // output wire wr_rst_busy
  .rd_rst_busy (cnt_fifo_rd_rst_busy)  // output wire rd_rst_busy
);
//fifo_ready & en_baotou_ready& encode_data_ready;
// ila_0 ila_cmpr (
//     .clk(sclk), // input wire clk


//     .probe0(fifo_ready), // input wire [0:0]  probe0  
//     .probe1(en_baotou_ready), // input wire [0:0]  probe1 
//     .probe2(encode_data_ready), // input wire [0:0]  probe2 
//     .probe3(wfifo_ready_r), // input wire [0:0]  probe3 
//     .probe4(data_fifo_full), // input wire [0:0]  probe4 
//     .probe5(cnt_fifo_full), // input wire [0:0]  probe5 
//     .probe6(data_fifo_wr_en) // input wire [0:0]  probe6
// );
endmodule