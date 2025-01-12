module z_rec #(
    parameter           tx_type =0,
    parameter           X_LEN = 11,
    parameter           Z_LEN = 8,
    parameter           Y_LEN = 5,
    parameter           DATA_WIDTH = 16
)
(
    input    wire                    clk,
    input    wire                    rst_n,
    input    wire [DATA_WIDTH-1:0]   data_i,//真实像素
    input    wire                    en_i,
    input    wire                    en_alpha_i,//重建像素有效使能
    input    wire [X_LEN-1:0]        Nx,
    input    wire [Z_LEN-1:0]        Nz,
    input    wire [Y_LEN-1:0]        Ny,
    input    wire [DATA_WIDTH+1-1:0]   cj_S_i,//重建像素

    output   wire [DATA_WIDTH*2-1:0] data0_o,
    output   wire                    en0_o,

    output   wire [DATA_WIDTH*2-1:0] data1_o,
    output   wire                    en1_o,

    output   wire [DATA_WIDTH*2-1:0] data2_o,
    output   wire                    en2_o,

    output   wire [DATA_WIDTH*2-1:0] data3_o,
    output   wire                    en3_o,

    output   wire [DATA_WIDTH*2-1:0] data4_o,
    output   wire                    en4_o
);
    reg                              en_r;
    reg      [DATA_WIDTH-1:0]        data_r;
    reg      [DATA_WIDTH-1:0]        data_band_fst_r2;
    reg      [DATA_WIDTH-1:0]        cj_S_r;//重建
    reg      [X_LEN-1:0]             x_cnt_r;
    reg                              x_lst_rp;
    reg      [Z_LEN-1:0]             z_cnt_r;
    reg                              z_lst_rp;
    reg      [Y_LEN-1:0]             y_cnt_r;
    reg      [Y_LEN-1:0]             y_cnt_rp;
    reg      [X_LEN-1:0]             alpha_x_cnt_r;
    reg      [X_LEN-1:0]             alpha_z_cnt_r;
    reg      [X_LEN-1:0]             alpha_y_cnt_r;
    reg                              alpha_x_lst_rp;
    reg                              alpha_z_lst_rp;//重建像素计数
    reg                              en_band_fst  ;
    reg                              en_cjband_fst;
    reg      [X_LEN-1:0]             Nx_r;
    reg      [Z_LEN-1:0]             Nz_r;
    reg      [Z_LEN-1:0]             Ny_r;

    reg                              en_r2;
    reg                              en_r3;
    reg      [DATA_WIDTH-1:0]        data_r2;
    reg      [DATA_WIDTH-1:0]        cj_S_r2;
    reg      [DATA_WIDTH-1:0]        data_r3;

/*fifo signal*/
    reg                              wfifo1_en_r2;
    reg                              wfifo2_en_r2;
    reg                              wfifo3_en_r2;
    reg                              wfifo4_en_r2;
    reg                              wfifo1_en_r2_p;
    reg                              wfifo2_en_r2_p;
    reg                              wfifo3_en_r2_p;
    reg                              wfifo4_en_r2_p;
    reg                              wfifoN_en_r2;
    reg                              rfifo1_en_r2;
    reg                              rfifo2_en_r2;
    reg                              rfifo3_en_r2;
    reg                              rfifo4_en_r2;
    
    reg                              rfifo1_en_r3;
    reg                              rfifo2_en_r3;
    reg                              rfifo3_en_r3;
    reg                              rfifo4_en_r3;
    
    reg                              rfifoN_en_r2;
    wire                              rfifoN_en_r2_reg;
    reg                            cj_rfifoN_en_r2;
    reg                              rfifoN_en_r3;
    reg                            rfifoN_en_r2_test;//test
    
    reg                              rst;
    wire     [DATA_WIDTH*2-1:0]      data1_r2;
    wire     [DATA_WIDTH*2-1:0]      data2_r2;
    wire     [DATA_WIDTH*2-1:0]      data3_r2;
    wire     [DATA_WIDTH*2-1:0]      data4_r2;
    
    reg     [DATA_WIDTH*2-1:0]      data1_r3;
    reg     [DATA_WIDTH*2-1:0]      data2_r3;
    reg     [DATA_WIDTH*2-1:0]      data3_r3;
    reg     [DATA_WIDTH*2-1:0]      data4_r3;
    
    wire     [DATA_WIDTH-1:0]        dataN_r2;
    wire     [DATA_WIDTH-1:0]        dataN_r2_reg;
    wire     [DATA_WIDTH-1:0]    dataN_r2_delay;
   // reg      [DATA_WIDTH-1:0]        dataN_r2p;
    reg       [DATA_WIDTH-1:0]       dataN_r3;
    //wire     [DATA_WIDTH*2-1:0]      dataN_r3_32;
     reg     [DATA_WIDTH*2-1:0]      dataN_r3_32;
   reg     [DATA_WIDTH*2-1:0]      cj_dataN_r3_32;
    reg                              en_alpha_r;

    wire fifo_zN_empty;
    wire fifo_zN_buf_full;
   // reg                              en_alpha_r2;
   // reg                              en_cj_r;
    //wire                             en_cj_fifo;
   // reg                              en_cj_fifo_r;
   // reg [DATA_WIDTH-1:0]             cj_fst;
   // wire                             en_test;
    // integer                file_data_i   ;
    // integer                file_dataN_r2;
    // integer                file_cjalpha_i;
    // integer                file_data0_o;
    // integer                file_data1_o;
    // integer                file_data1_r3;   
    // integer                file_data2_r3;
    // integer                file_data3_r3;
    // integer                file_data4_r3;
    // integer                file_data2_o;
    // integer                file_data3_o;
    // integer                file_data4_o;
/***************************************************************************************/
/**************************************regist1******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin: register1
  if(rst_n == 1'b0) begin
    data_r  <=  'd0;
    Nx_r    <=  'd0;
    Nz_r    <=  'd0; 
    Ny_r    <=  'd0;
  end else if(en_i == 1'b1) begin
    data_r  <= data_i;
    Nx_r    <= Nx;
    Nz_r    <= Nz;
    Ny_r    <= Ny;
  end
end

// always @(posedge clk or negedge rst_n) begin: register_cj
  // if(rst_n == 1'b0) begin
   // cj_S_r  <=  'd0;
  // end else if(en_alpha_i == 1'b1) begin
   // cj_S_r  <=  cj_S_i;
  // end
// end

always @(posedge clk or negedge rst_n) begin: register_cj
  if(rst_n == 1'b0) begin
   cj_S_r  <=  'd0;
  end else if(en_alpha_i == 1'b1 && cj_S_i[DATA_WIDTH+1-1] == 1'b0) begin
   cj_S_r  <=  cj_S_i[DATA_WIDTH-1:0];
  end else if(en_alpha_i == 1'b1 && cj_S_i[DATA_WIDTH+1-1] == 1'b1)begin
   cj_S_r <= 'd0;
  end 
end

// always @(posedge clk) begin
    // if (en_i == 1'b1) begin
        // file_data_i = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_23/S_i.txt", "a"); 
        // if (file_data_i != 0 ) begin
            // $fwrite(file_data_i, "%04h\n", data_i);
            // $fclose(file_data_i);
        // end
    // end
// end

always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    en_r  <= 1'b0;
    en_r2 <= 1'b0;
    en_r3 <= 1'b0;
    en_alpha_r<= 1'b0;
   // en_alpha_r2<=1'b0;
  end else begin
    en_r  <= en_i;
    en_r2 <= en_r;
    en_r3 <= en_r2;
    en_alpha_r<= en_alpha_i;
    //en_alpha_r2<= en_alpha_r;
  end
end

/*always @(posedge clk or negedge rst_n) begin : get_en_alpha_r
  if(rst_n == 1'b0) begin
    en_cj_r<= 1'b0;
  end else if(y_cnt_r == Ny_r-1)begin
    en_cj_r<= 1'b0;
  end else begin
    en_cj_r<= en_alpha_i;
  end
end*/
/*always @(posedge clk or negedge rst_n) begin : get_en_alpha_r2
  if(rst_n == 1'b0) begin
    en_alpha_r2<= 1'b0;
  end else begin
    en_alpha_r2<= en_alpha_r;
  end
end*/
/***************************************************************************************/
/**************************************stream1******************************************/
/***************************************************************************************/
//重建像素计数使能
always @(posedge clk or negedge rst_n) begin: get_alpha_x_cnt_r
  if(rst_n == 1'b0) begin
    alpha_x_cnt_r <= 'd0;
  end else if(en_alpha_r == 1'b1 && alpha_x_lst_rp == 1'b1) begin
    alpha_x_cnt_r <= 'd0;
  end else if(en_alpha_r == 1'b1) begin
    alpha_x_cnt_r <= alpha_x_cnt_r + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin: get_alpha_z_cnt_r
  if(rst_n == 1'b0) begin
    alpha_z_cnt_r <= 'd0;
  end else if(en_alpha_r == 1'b1 && alpha_x_lst_rp == 1'b1 && alpha_z_lst_rp == 1'b1) begin
    alpha_z_cnt_r <= 'd0;
  end else if(en_alpha_r == 1'b1 && alpha_x_lst_rp == 1'b1) begin
    alpha_z_cnt_r <= alpha_z_cnt_r + 1'b1;
  end
end


always @(posedge clk or negedge rst_n) begin : f_get_alpha_y_cnt_r
  if(rst_n == 1'b0) begin
    alpha_y_cnt_r <= 'd0;
  end else if(en_alpha_r == 1'b1 && alpha_x_lst_rp == 1'b1 && alpha_z_lst_rp == 1'b1 && alpha_y_cnt_r == 'd32-1) begin
    alpha_y_cnt_r <= 'd0;
  end else if(en_alpha_r == 1'b1 && alpha_x_lst_rp == 1'b1 && alpha_z_lst_rp == 1'b1) begin
    alpha_y_cnt_r <= alpha_y_cnt_r + 1'b1;
  end
end

always @(alpha_x_cnt_r,Nx_r) begin: get_alpha_x_lst_rp
  if(alpha_x_cnt_r == Nx_r-1'b1) begin
    alpha_x_lst_rp <= 1'b1;
  end else begin
    alpha_x_lst_rp <= 1'b0;
  end
end
always @(alpha_z_cnt_r,Nz_r) begin: get_alpha_z_lst_rp
  if(alpha_z_cnt_r == Nz_r-1'b1) begin
    alpha_z_lst_rp <= 1'b1;
  end else begin
    alpha_z_lst_rp <= 1'b0;
  end
end

/***************************************************************************************/
/**************************************stream2******************************************/
/***************************************************************************************/

always @(posedge clk or negedge rst_n) begin: get_x_cnt_r
  if(rst_n == 1'b0) begin
    x_cnt_r <= 'd0;
  end else if(en_r == 1'b1 && x_lst_rp == 1'b1) begin
    x_cnt_r <= 'd0;
  end else if(en_r == 1'b1) begin
    x_cnt_r <= x_cnt_r + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin: get_z_cnt_r
  if(rst_n == 1'b0) begin
    z_cnt_r <= 'd0;
  end else if(en_r == 1'b1 && x_lst_rp == 1'b1 && z_lst_rp == 1'b1) begin
    z_cnt_r <= 'd0;
  end else if(en_r == 1'b1 && x_lst_rp == 1'b1) begin
    z_cnt_r <= z_cnt_r + 1'b1;
  end
end

//scp
always @(posedge clk or negedge rst_n) begin : f_get_y_cnt_r
  if(rst_n == 1'b0) begin
    y_cnt_r <= 'd0;
  end else if(en_r == 1'b1 && x_lst_rp == 1'b1 && z_lst_rp == 1'b1 && y_cnt_r == 'd32-1) begin
    y_cnt_r <= 'd0;
  end else if(en_r == 1'b1 && x_lst_rp == 1'b1 && z_lst_rp == 1'b1) begin
    y_cnt_r <= y_cnt_r + 1'b1;
  end
end

always @(posedge clk or negedge rst_n) begin : f_get_y_cnt_rp
  if(rst_n == 1'b0) begin
    y_cnt_rp <= 'd0;
  end else if(en_r == 1'b1) begin
    y_cnt_rp <= y_cnt_r;
  end 
end
//scp

always @(x_cnt_r,Nx_r) begin: get_x_lst_rp
  if(x_cnt_r == Nx_r-1'b1) begin
    x_lst_rp <= 1'b1;
  end else begin
    x_lst_rp <= 1'b0;
  end
end
always @(z_cnt_r,Nz_r) begin: get_z_lst_rp
  if(z_cnt_r == Nz_r-1'b1) begin
    z_lst_rp <= 1'b1;
  end else begin
    z_lst_rp <= 1'b0;
  end
end

always @(en_r,y_cnt_r,x_cnt_r) begin: get_en_band_fst //每个谱段原始第一个数的使能
    if(en_r == 1'b1 && y_cnt_r == 'd0 && x_cnt_r == 'd0) begin
        en_band_fst <= 1'b1;  //对齐data_r
    end else begin
        en_band_fst <= 1'b0;
    end
end

always @(en_alpha_r,alpha_y_cnt_r,alpha_x_cnt_r) begin: get_en_cjband_fst //每个谱段重建第一个数的使能
    if(en_alpha_r == 1'b1 && alpha_y_cnt_r == 'd0 && alpha_x_cnt_r == 'd0) begin
        en_cjband_fst <= 1'b1;//对齐cj_s_r
    end else begin
        en_cjband_fst <= 1'b0;
    end
end


/***************************************************************************************/
/**************************************regist2******************************************/
/***************************************************************************************/

always @(posedge clk or negedge rst_n) begin: get_data_band_fst //每个谱段第一个数，数据的寄存器
    if(rst_n == 1'b0) begin
        data_band_fst_r2 <= 'd0;
    end else if(en_band_fst == 1'b1) begin
        data_band_fst_r2 <= data_r;
    end
end


always @(posedge clk or negedge rst_n) begin: register2
  if(rst_n == 1'b0) begin
    data_r2 <=  'd0;
  end else if(en_r == 1'b1) begin
    data_r2 <= data_r;
  end
end
// assign en_cj_fifo = en_i ^ en_r | en_alpha_r;//只写重建值 fifo写使能
// assign en_test = en_i ^ en_r;//第一个像素使能(一块图像)

always @(posedge clk or negedge rst_n) begin: get_cj_S_r2
  if(rst_n == 1'b0) begin
    cj_S_r2   <= 'd0;
  end else if(en_cjband_fst) begin//当是每一谱段的第一个像素赋予原值
    cj_S_r2   <= data_band_fst_r2;
  end else if(en_alpha_r) begin//除了每一个谱段第一个像素写重建值
    cj_S_r2 <= cj_S_r;
  end
end
/*always @(posedge clk or negedge rst_n) begin: get_en_cj_fifo_r
  if(rst_n == 1'b0) begin
    en_cj_fifo_r <= 'd0;
    // en_cj_fifo<= 'd0;
  end else begin
    en_cj_fifo_r <= en_cj_fifo; //FIFO写使能
  end
end*/
/***************************************************************************************/
/**************************************regist3******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin: register3
  if(rst_n == 1'b0) begin
    data_r3 <=  'd0;
  end else if(en_r == 1'b1) begin
    data_r3 <= data_r2;
  end
end

/***************************************************************************************/
/**************************************stream3******************************************/
/***************************************************************************************/


/*************************************wfifo_ctrl*****************************************/

//从en_alpha_r开始拉高直到重建值计数器到最后一层拉低，存入fifo，高16拼0，低16重建值
always @(posedge clk or negedge rst_n) begin: get_wfifo1_en_r2
  if(rst_n == 1'b0) begin
    wfifo1_en_r2 <= 1'b0;
  end else if(en_alpha_r == 1'b1 && alpha_z_lst_rp == 1'b1) begin
    wfifo1_en_r2 <= 1'b0;
  end else begin
    wfifo1_en_r2 <= en_alpha_r;
  end
end
always @(posedge clk or negedge rst_n) begin: get_wfifo2_en_r2
  if(rst_n == 1'b0) begin
    wfifo2_en_r2 <= 1'b0;
  end else if(en_r == 1'b1 && z_lst_rp == 1'b1) begin
    wfifo2_en_r2 <= 1'b0;
  end else if(z_cnt_r > 0) begin
    wfifo2_en_r2 <= en_r;
  end
end
always @(posedge clk or negedge rst_n) begin: get_wfifo3_en_r2
  if(rst_n == 1'b0) begin
    wfifo3_en_r2 <= 1'b0;
  end else if(en_r == 1'b1 && z_lst_rp == 1'b1) begin
    wfifo3_en_r2 <= 1'b0;
  end else if(z_cnt_r > 1) begin
    wfifo3_en_r2 <= en_r;
  end
end
always @(posedge clk or negedge rst_n) begin: get_wfifo4_en_r2
  if(rst_n == 1'b0) begin
    wfifo4_en_r2 <= 1'b0;
  end else if(en_r == 1'b1 && z_lst_rp == 1'b1) begin
    wfifo4_en_r2 <= 1'b0;
  end else if(z_cnt_r > 2) begin
    wfifo4_en_r2 <= en_r;
  end
end

always @(posedge clk or negedge rst_n) begin: register_fifo_en
  if(rst_n == 1'b0) begin
    wfifo1_en_r2_p <= 1'b0;
    wfifo2_en_r2_p <= 1'b0;
    wfifo3_en_r2_p <= 1'b0;
    wfifo4_en_r2_p <= 1'b0;
  end else begin
    wfifo1_en_r2_p <= wfifo1_en_r2;
    wfifo2_en_r2_p <= wfifo2_en_r2;
    wfifo3_en_r2_p <= wfifo3_en_r2;
    wfifo4_en_r2_p <= wfifo4_en_r2;
  end
end
//scp
// always @(posedge clk or negedge rst_n) begin: get_wfifoN_en_r2
  // if(rst_n == 1'b0) begin
    // wfifoN_en_r2 <= 1'b0;
  // end else if (en_alpha_r2==1'b1||(y_cnt_r=='d0 &&x_cnt_r =='d0))  begin//只写入每个谱段第一个原像素或者是重建值
    // wfifoN_en_r2 <= en_r;
  // end else begin
    // wfifoN_en_r2 <= 1'b0;
  // end
  
// end
always @(posedge clk or negedge rst_n) begin: get_wfifoN_en_r2
  if(rst_n == 1'b0) begin
    wfifoN_en_r2 <= 1'b0;
  end else if(alpha_y_cnt_r == Ny_r-1) begin//只写入每个谱段第一个原像素或者是重建值
    wfifoN_en_r2 <= 1'b0;
  end else begin
    wfifoN_en_r2 <= en_alpha_r;
  end
end
//scp
/*************************************rfifo_ctrl*****************************************/

always @(posedge clk or negedge rst_n) begin: get_rfifo1_en_r2
  if(rst_n == 1'b0) begin
    rfifo1_en_r2 <= 1'b0;
  end else if(en_r == 1'b1 && z_cnt_r == 0) begin
    rfifo1_en_r2 <= 1'b0;
  end else begin
    rfifo1_en_r2 <= en_r;
  end
end
always @(posedge clk or negedge rst_n) begin: get_rfifo2_en_r2
  if(rst_n == 1'b0) begin
    rfifo2_en_r2 <= 1'b0;
  end else if(en_r == 1'b1 && z_cnt_r < 2) begin
    rfifo2_en_r2 <= 1'b0;
  end else begin
    rfifo2_en_r2 <= en_r;
  end
end
always @(posedge clk or negedge rst_n) begin: get_rfifo3_en_r2
  if(rst_n == 1'b0) begin
    rfifo3_en_r2 <= 1'b0;
  end else if(en_r == 1'b1 && z_cnt_r < 3) begin
    rfifo3_en_r2 <= 1'b0;
  end else begin
    rfifo3_en_r2 <= en_r;
  end
end
always @(posedge clk or negedge rst_n) begin: get_rfifo4_en_r2
  if(rst_n == 1'b0) begin
    rfifo4_en_r2 <= 1'b0;
  end else if(en_r == 1'b1 && z_cnt_r < 4) begin
    rfifo4_en_r2 <= 1'b0;
  end else begin
    rfifo4_en_r2 <= en_r;
  end
end

//scp

// always @(posedge clk or negedge rst_n) begin: get_rfifoN_en_r2
  // if(rst_n == 1'b0) begin
    // rfifoN_en_r2 <= 1'b0;
  // end else if(en_r == 1'b1 && (y_cnt_r == 1'b0 && z_cnt_r < (Nz_r - 1'b1)) || (y_cnt_r == 0 && z_cnt_r == (Nz_r - 1'b1) && x_cnt_r < (Nx_r - 1'b1))) begin//第一行的时候不读
    // rfifoN_en_r2 <= 1'b0;
  // end else begin
    // rfifoN_en_r2 <= en_r;
  // end
// end

always @(posedge clk or negedge rst_n) begin: get_rfifoN_en_r3
  if(rst_n == 1'b0) begin
    rfifoN_en_r3 <= 1'b0;
  end else begin
    rfifoN_en_r3 <= rfifoN_en_r2;
     
  end 
  
end

always @(posedge clk or negedge rst_n) begin: get_rfifoN_en_r2
  if(rst_n == 1'b0) begin
    rfifoN_en_r2 <= 1'b0;
  end else if(en_r == 1'b1 && y_cnt_r == 'd0) begin//第一行的时候不读
    rfifoN_en_r2 <= 1'b0;//真实像素第一行
  end else begin
    rfifoN_en_r2 <= en_r;
  end
end
// scp 根据重建像素的索引来判断
always @(posedge clk or negedge rst_n) begin: get_cj_rfifoN_en_r2
  if(rst_n == 1'b0) begin
    cj_rfifoN_en_r2 <= 1'b0;
  end else if(en_alpha_r == 1'b1 && alpha_y_cnt_r == 'd0) begin//重建第一行的时候不读
    cj_rfifoN_en_r2 <= 1'b0;//重建像素第一行
  end else begin
    cj_rfifoN_en_r2 <= en_alpha_r;
  end
end


always @(y_cnt_r,en_r) begin: get_rfifoN_en_r2_test
   if( y_cnt_r < 'd1) begin
    rfifoN_en_r2_test <= 1'b0;
  end else begin
    rfifoN_en_r2_test <= en_r;
  end
end


always @(posedge clk or negedge rst_n) begin: register_fifo_en_2
  if(rst_n == 1'b0) begin
    rfifo1_en_r3 <= 1'b0;
    rfifo2_en_r3 <= 1'b0;
    rfifo3_en_r3 <= 1'b0;
    rfifo4_en_r3 <= 1'b0;
  end else begin
    rfifo1_en_r3 <= rfifo1_en_r2;
    rfifo2_en_r3 <= rfifo2_en_r2;
    rfifo3_en_r3 <= rfifo3_en_r2;
    rfifo4_en_r3 <= rfifo4_en_r2;
  end
end

// always @(posedge clk or negedge rst_n) begin: get_dataN_r3
  // if(rst_n == 1'b0) begin
    // dataN_r3 <= 16'b0;
  // end else if(en_r == 1'b1 && y_cnt_r == 'd0) begin
    // dataN_r3 <= 16'b0;
  // end else if(en_r == 1'b1 && y_cnt_r > 'd0) begin
    // dataN_r3 <= dataN_r2;
  // end 
// end

// always @(posedge clk or posedge rst_n) begin: get_dataN_r2p
    // if(rst_n == 1'b0)begin
        // dataN_r2p <= 'd0;
    // end else begin
        // dataN_r2p <= dataN_r2;
    // end
// end

// always @(posedge clk or negedge rst_n) begin: get_dataN_r2p
    // if(rst_n == 1'b0)begin
        // dataN_r2p <= 'd0;
    // end else if(rfifoN_en_r2 == 1'b0 && y_cnt_r == 'd0)  begin
        // dataN_r2p <= data_r2
    // end else if(rfifoN_en_r2 == 1'b1) begin
        // dataN_r2p <= dataN_r2;
    // end
// end
/*************************************data_out*****************************************/
always @(posedge clk or negedge rst_n) begin: register_data
  if(rst_n == 1'b0) begin
    data1_r3 <= 1'b0;
    data2_r3 <= 1'b0;
    data3_r3 <= 1'b0;
    data4_r3 <= 1'b0;
  end else begin
    data1_r3 <= data1_r2;
    data2_r3 <= data2_r2;
    data3_r3 <= data3_r2;
    data4_r3 <= data4_r2;
  end
end

//当前谱段 ，可以用真实像素，真实像素用来求残差
always @(posedge clk or negedge rst_n) begin: get_dataN_r2p
    if(rst_n == 1'b0)begin
        dataN_r3_32 <= 'd0;
    end else if(rfifoN_en_r2 == 1'b0 && y_cnt_rp == 'd0)  begin//第一行的时候
        dataN_r3_32 <= {16'b0,data_r2};
    end else if(rfifoN_en_r2 == 1'b1) begin//除了第一行
        dataN_r3_32 <= {dataN_r2,data_r2};
    end
end

//scp 前几层谱段，对应位置像素需是重建值
always @(posedge clk or negedge rst_n) begin: get_cj_dataN_r2p
    if(rst_n == 1'b0)begin
        cj_dataN_r3_32 <= 'd0;
    end else if(cj_rfifoN_en_r2 == 1'b0 && alpha_y_cnt_r == 'd0)  begin// 读FIFO信号根据真实像素的位置索引；重建像素是第一行的时候 
        cj_dataN_r3_32 <= {16'b0,cj_S_r2}; //前几个谱段是第一行像素重建值高位拼0
    end else if(cj_rfifoN_en_r2 == 1'b1) begin
        cj_dataN_r3_32 <= {dataN_r2_delay,cj_S_r2};
    end
end


// always @(dataN_r2,data_r2) begin: get_dataN_r2p
    // if(rfifoN_en_r2 == 1'b0 && y_cnt_r == 'd0)  begin
        // dataN_r3_32 <= {16'b0,data_r2};
    // end else if(rfifoN_en_r2 == 1'b1) begin
        // dataN_r3_32 <= {dataN_r2,data_r2};
    // end
// end

// always @(rfifoN_en_r2,dataN_r2p) begin: get_dataN_r3
//   if(rfifoN_en_r2 == 1'b0 && y_cnt_r == 'd0) begin
//     dataN_r3 <= 16'b0;
//   end else if(rfifoN_en_r2 == 1'b1 ) begin
//     dataN_r3 <= dataN_r2p;
//   end 
// end


//scp

always @(posedge clk or negedge rst_n) begin:get_rst
  if(rst_n == 1'b0) begin
    rst <= 1'b1;
  end else begin
    rst <= 1'b0;
  end
end
// always @(posedge clk) begin
    // if (en0_o == 1'b1) begin
        // file_data0_o = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/dataN_r_low.txt", "a"); 
        // file_data1_o = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/dataN_r_high.txt", "a"); 
        // if (file_data0_o != 0 ) begin
            // $fwrite(file_data0_o, "%04h\n", dataN_r3_32[15:0]);
            // $fwrite(file_data1_o, "%04h\n", dataN_r3_32[31:16]);
            // $fclose(file_data1_o);
            // $fclose(file_data0_o);
        // end
    // end
// end
// always @(posedge clk) begin
    // if (rfifo1_en_r3 == 1'b1) begin
        // file_data1_r3 = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_23/data1_r3.txt", "a"); 
        // if (file_data1_r3 != 0 ) begin
            // $fwrite(file_data1_r3, "%04h\n", data1_r3[15:0]);
            // $fclose(file_data1_r3);
        // end
    // end
// end
// always @(posedge clk) begin
    // if (rfifo2_en_r3 == 1'b1) begin
        // file_data2_r3 = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_23/data2_r3.txt", "a"); 
        // if (file_data2_r3 != 0 ) begin
            // $fwrite(file_data2_r3, "%04h\n", data2_r3[15:0]);
            // $fclose(file_data2_r3);
        // end
    // end
// end
// always @(posedge clk) begin
    // if (rfifo3_en_r3 == 1'b1) begin
        // file_data3_r3 = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_23/data3_r3.txt", "a"); 
        // if (file_data3_r3 != 0 ) begin
            // $fwrite(file_data3_r3, "%04h\n", data3_r3[15:0]);
            // $fclose(file_data3_r3);
        // end
    // end
// end

// always @(posedge clk) begin
    // if (rfifo4_en_r3 == 1'b1) begin
        // file_data4_r3 = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_23/data4_r3.txt", "a"); 
        // if (file_data4_r3 != 0 ) begin
            // $fwrite(file_data4_r3, "%04h\n", data4_r3[15:0]);
            // $fclose(file_data4_r3);
        // end
    // end
// end
/***************************************************************************************/
/**************************************  out  ******************************************/
/***************************************************************************************/
//assign dataN_r3_32 = {dataN_r3,data_r3};//32
//assign dataN_r3_32 = {dataN_r2p,data_r2};//32
//assign dataN_r3_32 =dataN_r2p;
assign data0_o = dataN_r3_32;
assign en0_o   = en_r3;
assign data1_o = data1_r3;
assign en1_o   = rfifo1_en_r3;
assign data2_o = data2_r3;
assign en2_o   = rfifo2_en_r3;
assign data3_o = data3_r3;
assign en3_o   = rfifo3_en_r3;
assign data4_o = data4_r3;
assign en4_o   = rfifo4_en_r3;
generate
  if(tx_type==0) begin

      fifo_forz_13_2 fifo_z1 (
      .clk(clk),      // input wire clk
      .srst(rst),    // input wire srst
      .din(cj_dataN_r3_32),      // input wire [DATA_WIDTH*2-1 : 0] din                          
      .wr_en(wfifo1_en_r2_p),  // input wire wr_en                                            
      .rd_en(rfifo1_en_r2),  // input wire rd_en                                              
      .dout(data1_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout                            
      .full(),    // output wire full                                                         
      .empty()  // output wire empty                                                          
      );                                                                                        
      fifo_forz_13_2 fifo_z2 (                                                                  
        .clk(clk),      // input wire clk                                                       
        .srst(rst),    // input wire srst                                                       
        .din(data1_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
        .wr_en(wfifo2_en_r2),  // input wire wr_en
        .rd_en(rfifo2_en_r2),  // input wire rd_en
        .dout(data2_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
        .full(),    // output wire full
        .empty()  // output wire empty
      );
      fifo_forz_13_2 fifo_z3 (
        .clk(clk),      // input wire clk
        .srst(rst),    // input wire srst
        .din(data2_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
        .wr_en(wfifo3_en_r2),  // input wire wr_en
        .rd_en(rfifo3_en_r2),  // input wire rd_en
        .dout(data3_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
        .full(),    // output wire full
        .empty()  // output wire empty
      );
      fifo_forz_13_2 fifo_z4 (
        .clk(clk),      // input wire clk
        .srst(rst),    // input wire srst
        .din(data3_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
        .wr_en(wfifo4_en_r2),  // input wire wr_en
        .rd_en(rfifo4_en_r2),  // input wire rd_en
        .dout(data4_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
        .full(),    // output wire full
        .empty()  // output wire empty
      );
          
      fifo_forz_16_2 fifo_zN (
      .clk(clk),      // input wire clk
      .srst(rst),    // input wire srst
      .din(cj_S_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
      .wr_en(wfifoN_en_r2),  // input wire wr_en
      .rd_en(rfifoN_en_r2),  // input wire rd_en
      .dout(dataN_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
      .full(),    // output wire full
      .empty()  // output wire empty
    );
  end
  else if(tx_type==1)begin

      fifo_forz_13_3 fifo_z1 (
      .clk(clk),      // input wire clk
      .srst(rst),    // input wire srst
      .din(cj_dataN_r3_32),      // input wire [DATA_WIDTH*2-1 : 0] din                          
      .wr_en(wfifo1_en_r2_p),  // input wire wr_en                                            
      .rd_en(rfifo1_en_r2),  // input wire rd_en                                              
      .dout(data1_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout                            
      .full(),    // output wire full                                                         
      .empty()  // output wire empty                                                          
      );                                                                                        
      fifo_forz_13_3 fifo_z2 (                                                                  
        .clk(clk),      // input wire clk                                                       
        .srst(rst),    // input wire srst                                                       
        .din(data1_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
        .wr_en(wfifo2_en_r2),  // input wire wr_en
        .rd_en(rfifo2_en_r2),  // input wire rd_en
        .dout(data2_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
        .full(),    // output wire full
        .empty()  // output wire empty
      );
      fifo_forz_13_3 fifo_z3 (
        .clk(clk),      // input wire clk
        .srst(rst),    // input wire srst
        .din(data2_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
        .wr_en(wfifo3_en_r2),  // input wire wr_en
        .rd_en(rfifo3_en_r2),  // input wire rd_en
        .dout(data3_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
        .full(),    // output wire full
        .empty()  // output wire empty
      );
      fifo_forz_13_3 fifo_z4 (
        .clk(clk),      // input wire clk
        .srst(rst),    // input wire srst
        .din(data3_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
        .wr_en(wfifo4_en_r2),  // input wire wr_en
        .rd_en(rfifo4_en_r2),  // input wire rd_en
        .dout(data4_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
        .full(),    // output wire full
        .empty()  // output wire empty
      );
          


      assign rfifoN_en_r2_reg = ~fifo_zN_empty & ~fifo_zN_buf_full;


      fifo_forz_16_1 fifo_zN (
      .clk(clk),      // input wire clk
      .srst(rst),    // input wire srst
      .din(cj_S_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
      .wr_en(wfifoN_en_r2),  // input wire wr_en
      .rd_en(rfifoN_en_r2_reg),  // input wire rd_en
      .dout(dataN_r2_reg),    // output wire [DATA_WIDTH*2-1 : 0] dout
      .full(),    // output wire full
      .empty(fifo_zN_empty)  // output wire empty
     );

       fifo_forz_16_4 fifo_zN_buf (
      .clk(clk),      // input wire clk
      .srst(rst),    // input wire srst
      .din(dataN_r2_reg),      // input wire [DATA_WIDTH*2-1 : 0] din
      .wr_en(rfifoN_en_r2_reg),  // input wire wr_en
      .rd_en(rfifoN_en_r2),  // input wire rd_en
      .dout(dataN_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
      .full(fifo_zN_buf_full),    // output wire full
      .empty()  // output wire empty
     );
    
  end
  else if(tx_type==2)begin

        fifo_forz_13_3 fifo_z1 (
        .clk(clk),      // input wire clk
        .srst(rst),    // input wire srst
        .din(cj_dataN_r3_32),      // input wire [DATA_WIDTH*2-1 : 0] din                          
        .wr_en(wfifo1_en_r2_p),  // input wire wr_en                                            
        .rd_en(rfifo1_en_r2),  // input wire rd_en                                              
        .dout(data1_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout                            
        .full(),    // output wire full                                                         
        .empty()  // output wire empty                                                          
        );                                                                                        
        fifo_forz_13_3 fifo_z2 (                                                                  
          .clk(clk),      // input wire clk                                                       
          .srst(rst),    // input wire srst                                                       
          .din(data1_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
          .wr_en(wfifo2_en_r2),  // input wire wr_en
          .rd_en(rfifo2_en_r2),  // input wire rd_en
          .dout(data2_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
          .full(),    // output wire full
          .empty()  // output wire empty
        );
        fifo_forz_13_3 fifo_z3 (
          .clk(clk),      // input wire clk
          .srst(rst),    // input wire srst
          .din(data2_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
          .wr_en(wfifo3_en_r2),  // input wire wr_en
          .rd_en(rfifo3_en_r2),  // input wire rd_en
          .dout(data3_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
          .full(),    // output wire full
          .empty()  // output wire empty
        );
        fifo_forz_13_3 fifo_z4 (
          .clk(clk),      // input wire clk
          .srst(rst),    // input wire srst
          .din(data3_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
          .wr_en(wfifo4_en_r2),  // input wire wr_en
          .rd_en(rfifo4_en_r2),  // input wire rd_en
          .dout(data4_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
          .full(),    // output wire full
          .empty()  // output wire empty
        );
            
        fifo_forz_16_3 fifo_zN (
        .clk(clk),      // input wire clk
        .srst(rst),    // input wire srst
        .din(cj_S_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
        .wr_en(wfifoN_en_r2),  // input wire wr_en
        .rd_en(rfifoN_en_r2),  // input wire rd_en
        .dout(dataN_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
        .full(),    // output wire full
        .empty()  // output wire empty
       );
    
  end
  else if(tx_type==3 || tx_type==4) begin

         fifo_forz_13_4 fifo_z1 (
        .clk(clk),      // input wire clk
        .srst(rst),    // input wire srst
        .din(cj_dataN_r3_32),      // input wire [DATA_WIDTH*2-1 : 0] din                          
        .wr_en(wfifo1_en_r2_p),  // input wire wr_en                                            
        .rd_en(rfifo1_en_r2),  // input wire rd_en                                              
        .dout(data1_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout                            
        .full(),    // output wire full                                                         
        .empty()  // output wire empty                                                          
        );                                                                                        
        fifo_forz_13_4 fifo_z2 (                                                                  
          .clk(clk),      // input wire clk                                                       
          .srst(rst),    // input wire srst                                                       
          .din(data1_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
          .wr_en(wfifo2_en_r2),  // input wire wr_en
          .rd_en(rfifo2_en_r2),  // input wire rd_en
          .dout(data2_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
          .full(),    // output wire full
          .empty()  // output wire empty
        );
        fifo_forz_13_4 fifo_z3 (
          .clk(clk),      // input wire clk
          .srst(rst),    // input wire srst
          .din(data2_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
          .wr_en(wfifo3_en_r2),  // input wire wr_en
          .rd_en(rfifo3_en_r2),  // input wire rd_en
          .dout(data3_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
          .full(),    // output wire full
          .empty()  // output wire empty
        );
        fifo_forz_13_4 fifo_z4 (
          .clk(clk),      // input wire clk
          .srst(rst),    // input wire srst
          .din(data3_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
          .wr_en(wfifo4_en_r2),  // input wire wr_en
          .rd_en(rfifo4_en_r2),  // input wire rd_en
          .dout(data4_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
          .full(),    // output wire full
          .empty()  // output wire empty
        );
            
      assign rfifoN_en_r2_reg = ~fifo_zN_empty & ~fifo_zN_buf_full;


        fifo_forz_16_1 fifo_zN (
        .clk(clk),      // input wire clk
        .srst(rst),    // input wire srst
        .din(cj_S_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
        .wr_en(wfifoN_en_r2),  // input wire wr_en
        .rd_en(rfifoN_en_r2_reg),  // input wire rd_en
        .dout(dataN_r2_reg),    // output wire [DATA_WIDTH*2-1 : 0] dout
        .full(),    // output wire full
        .empty(fifo_zN_empty)  // output wire empty
       );

         fifo_forz_16_5 fifo_zN_buf (
        .clk(clk),      // input wire clk
        .srst(rst),    // input wire srst
        .din(dataN_r2_reg),      // input wire [DATA_WIDTH*2-1 : 0] din
        .wr_en(rfifoN_en_r2_reg),  // input wire wr_en
        .rd_en(rfifoN_en_r2),  // input wire rd_en
        .dout(dataN_r2),    // output wire [DATA_WIDTH*2-1 : 0] dout
        .full(fifo_zN_buf_full),    // output wire full
        .empty()  // output wire empty
       );
    
  end
endgenerate




fifo_zN_1 fifo_zN_1  (
  .clk(clk),      // input wire clk
  .srst(rst),    // input wire srst
  .din(dataN_r2),      // input wire [DATA_WIDTH*2-1 : 0] din
  .wr_en(rfifoN_en_r2),  // input wire wr_en
  .rd_en(cj_rfifoN_en_r2),  // input wire rd_en
  .dout(dataN_r2_delay),    // output wire [DATA_WIDTH*2-1 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);

endmodule