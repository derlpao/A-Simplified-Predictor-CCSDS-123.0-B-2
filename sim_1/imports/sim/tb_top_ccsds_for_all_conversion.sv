`timescale  1ns/1ns

module  tb_top_ccsds_for_all_conversion;



string  file_path;



parameter      X_LEN = 14;
parameter      Y_LEN = 6;
parameter      Z_LEN = 8;
//ccsds signal
logic             clk;
logic             rst_n;
logic             cmprs_rdf_data_valid;
logic [X_LEN-1:0] X_max;
logic [Z_LEN-1:0] Z_max;
logic [1:0]       mode;
logic [3:0]       id_ratio;
logic             cmprs_rdf_data_ready;
logic             cfg_en;
logic             cmprs_rdf_data_end;
//ddr interface
logic                cmprs_fifo_grant;
logic                cmprs_dout_req;
logic [23:0]         code_cnt;
logic                cnt_valid_lst;
logic                cnt_valid_fst;
logic                encode_data_valid;
logic [255:0]        encode_data;
logic                cmprs_dout_end;

//AXI-S
logic [23:0]        cmprs_out_code_cnt_out;             
logic               receive_output_code_ready;
logic               cmprs_out_ccsds_data_valid_out;    
logic [63:0]       cmprs_out_ccsds_data_out;           
logic               cmprs_out_ccsds_finish_flag_out;    


//for tb
logic             cnt_rst_n;
logic [X_LEN+Y_LEN+Z_LEN-1:0] all_cnt;
logic [X_LEN+Z_LEN-1:0] col_cnt;
logic [12:0]      random_cnt;
logic             random_en;
logic             ccsds_clk;
logic             data_valid;
logic             can_writing;
logic             grant_r;
logic             grant_r2;
logic [23:0]      out_cnt;
logic             cnt_valid_lst_r;
logic [23:0]      req_random_cnt;
//for file
integer fd_file_path;
integer fd_high;
integer fd_low;
integer fd_file_path_name;
integer fd_x_max;
integer fd_z_max;
integer fd_mode;
integer fd_ratio;
integer fd_parameter;
integer code;
integer fd_alpha_o;
integer fd_k_o;
integer fd_encode_data;
integer fd_vec_crt_test;
integer fd_acc_crt_r2;
integer fd_encode_output;//scp修改
logic  [15:0]     data_high;
logic  [15:0]     data_low;
logic  [31:0]     cmprs_data;
logic             output_cpr_req;
integer parameternn;
integer parameterareax;
integer parameterareay;

string  file_path_name;

//open file parameter
initial begin
 // fd_encode_output = $fopen("D:/ccsds/ccsds/testdata/for_multiple_data_modezp/mydata60P160x32/data1/test/test3.31/encode_output.txt", "w");//scp
  //fd_file_path       = $fopen("../../../../../sim/test_data_path.txt", "r");
  fd_file_path       = $fopen("D:/ccsds/ccsds/sim/test_data_path.txt", "r");
  $fgets(file_path,fd_file_path);//file_path = D:/ccsds/ccsds/testdata/for_multiple_data_mode0/
  $fclose(fd_file_path);

  cnt_rst_n = 1'b1;
  fd_file_path_name  = $fopen({file_path,"file_path_name.txt"},"r");//打开D:/ccsds/ccsds/testdata/for_multiple_data_mode0/file_path_name.txt 内容是mydata60P160x32/data1/
  fd_x_max           = $fopen({file_path,"x_max.txt"},"r");//打开D:/ccsds/ccsds/testdata/for_multiple_data_mode0/x_max.txt内容�?160
  fd_z_max           = $fopen({file_path,"z_max.txt"},"r");//打开D:/ccsds/ccsds/testdata/for_multiple_data_mode0/z_max.txt内容�?60
  fd_mode            = $fopen({file_path,"mode.txt"},"r");//打开D:/ccsds/ccsds/testdata/for_multiple_data_mode0/mode.txt内容�?0 全模�?
  fd_ratio            = $fopen({file_path,"ratio.txt"},"r");
  code = $fscanf(fd_file_path_name,"%s",file_path_name);
  $fscanf(fd_x_max,"%d",X_max);
  $fscanf(fd_z_max,"%d",Z_max);
  $fscanf(fd_mode,"%d",mode);
  $fscanf(fd_ratio,"%d",id_ratio);
  fd_parameter       = $fopen({file_path,file_path_name,"matlab_parameter.txt"},"r");
  $fscanf(fd_parameter,"%d",parameternn);
  $fscanf(fd_parameter,"%d",parameterareax);
  $fscanf(fd_parameter,"%d",parameterareay);
//open file data 
  fd_high            = $fopen({file_path,file_path_name,"data_high.txt"},"r");
  fd_low             = $fopen({file_path,file_path_name,"data_low.txt"},"r");
  fd_encode_data     = $fopen({file_path,file_path_name,"dataout_128bit.txt"},"r");
  fd_alpha_o         = $fopen({file_path,file_path_name,"alpha_data.txt"},"r");
  fd_k_o             = $fopen({file_path,file_path_name,"k_data.txt"},"r");
  fd_vec_crt_test    = $fopen({file_path,file_path_name,"vec_pre_data.txt"},"r");
  fd_acc_crt_r2      = $fopen({file_path,file_path_name,"acc_data.txt"},"r");

  $fscanf(fd_high,"%04h",data_high);
  $fscanf(fd_low ,"%04h",data_low);
  $fscanf(fd_encode_data,"%064h",matlab_encode_data);
  $fscanf(fd_alpha_o,"%04h",matlab_alpha_o);
  $fscanf(fd_k_o,"%01h",matlab_k_o);
  $fscanf(fd_vec_crt_test,"%013h",matlab_vec_crt_test);
  $fscanf(fd_acc_crt_r2,"%08h",matlab_acc_crt_r2);

  while (code != -1) begin
    wait(cnt_valid_lst == 1'b1);
    @(posedge clk);
    @(posedge clk);
    code = $fscanf(fd_file_path_name,"%s",file_path_name);
    $fscanf(fd_x_max,"%d",X_max);//修改
    $fscanf(fd_z_max,"%d",Z_max);
    $fscanf(fd_mode,"%d",mode);
    $fscanf(fd_ratio,"%d",id_ratio);
    $fclose(fd_high);
    $fclose(fd_low);
    $fclose(fd_parameter);
    fd_high            = $fopen({file_path,file_path_name,"data_high.txt"},"r");
    fd_low             = $fopen({file_path,file_path_name,"data_low.txt"},"r");
    fd_parameter       = $fopen({file_path,file_path_name,"matlab_parameter.txt"},"r");
    fd_encode_data     = $fopen({file_path,file_path_name,"dataout_128bit.txt"},"r");
    fd_alpha_o         = $fopen({file_path,file_path_name,"alpha_data.txt"},"r");
    fd_k_o             = $fopen({file_path,file_path_name,"k_data.txt"},"r");
    fd_vec_crt_test    = $fopen({file_path,file_path_name,"vec_pre_data.txt"},"r");
    fd_acc_crt_r2      = $fopen({file_path,file_path_name,"acc_data.txt"},"r");
    $fscanf(fd_parameter,"%d",parameternn);
    $fscanf(fd_parameter,"%d",parameterareax);
    $fscanf(fd_parameter,"%d",parameterareay);
    $fscanf(fd_high,"%04h",data_high);
    $fscanf(fd_low ,"%04h",data_low);
    $fscanf(fd_encode_data,"%064h",matlab_encode_data);
    $fscanf(fd_alpha_o,"%04h",matlab_alpha_o);
    $fscanf(fd_k_o,"%01h",matlab_k_o);
    $fscanf(fd_vec_crt_test,"%013h",matlab_vec_crt_test);
    $fscanf(fd_acc_crt_r2,"%08h",matlab_acc_crt_r2);

    @(posedge clk);
    cnt_rst_n = 1'b0;
    @(posedge clk);
    cnt_rst_n = 1'b1;
    
    @(posedge clk);
    cfg_en <= 1'b1;
    @(posedge clk);
    cfg_en <= 1'b0;

  end


  wait(cnt_valid_lst == 1'b1);
  #500;
  @(posedge clk);
  @(posedge clk);
  $fclose(fd_file_path_name);
  $fclose(fd_x_max);
  $fclose(fd_z_max);
  $fclose(fd_mode);
  $fclose(fd_ratio);
  $fclose(fd_parameter);
  $fclose(fd_high);
  $fclose(fd_low);
  $fclose(fd_encode_data);
  $fclose(fd_alpha_o);
  $fclose(fd_k_o);
  $fclose(fd_vec_crt_test);
  $fclose(fd_acc_crt_r2);
  $stop;
end

initial begin
  force ccsds_clk = top_CCSDS_inst.clk;
end

initial begin
  clk    = 1'b0;
  rst_n <= 1'b0;
  receive_output_code_ready <= 1'b0;
  random_en <= 1'b1;
  # 500;
  rst_n <= 1'b1;
  # 500;
  receive_output_code_ready <= 1'b1;
  // # 900000;
  // receive_output_code_ready <= 1'b0;
  // # 100000;
  // receive_output_code_ready <= 1'b1;
end
always #2.5 clk = ~clk;


//scp修改
// always @(posedge clk) begin
    
    // if (cmprs_out_ccsds_data_valid_out) begin
        // �? encode_data 写入到文件中
        // $fwrite(fd_encode_output, "%h\n", cmprs_out_ccsds_data_out );
    // end
// end

// always @(posedge clk) begin
    // 在仿真结束时关闭文件
    // if (cmprs_out_ccsds_finish_flag_out==1) begin
        // $fclose(fd_encode_output);
    // end
// end
/////////////////


initial begin
  cfg_en <= 1'b0;
  wait (rst_n == 1'b1);
  wait (cmprs_rdf_data_ready == 1'b1);
  @(posedge clk);
  cfg_en <= 1'b1;
  @(posedge clk);
  cfg_en <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin : get_cmprs_rdf_data_end
  if(rst_n == 1'b0) begin
    cmprs_rdf_data_end <= 1'b0;
  end else if(cmprs_rdf_data_valid == 1'b1 && col_cnt == X_max*Z_max-2) begin
    cmprs_rdf_data_end <= 1'b1;
  end else begin
    cmprs_rdf_data_end <= 1'b0;
  end
end
always @(posedge clk or negedge rst_n) begin : get_random_cnt
  if(rst_n == 1'b0) begin
    random_cnt <= 'd0;
  end else if(random_en == 1'b1) begin
    random_cnt <= random_cnt + {$random}%10;
  end
end
always @(posedge clk or negedge rst_n) begin : get_en_i
  if(rst_n == 1'b0) begin
    data_valid <= 1'b0;
  end else if(cmprs_rdf_data_valid && all_cnt == X_max*32*Z_max-1) begin//修改
    data_valid <= 1'b0;
  end else if(cmprs_rdf_data_valid && col_cnt == X_max*Z_max-1) begin
    data_valid <= 1'b0;
  end else if(all_cnt < X_max*32*Z_max-1 && can_writing == 1'b1) begin
    data_valid <= 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_can_writing
  if(rst_n == 1'b0) begin
    can_writing <= 1'b0;
  end else if(cfg_en == 1'b1) begin
    can_writing <= 1'b1;
  end else if(cnt_valid_lst == 1'b1) begin
    can_writing <= 1'b0;
  end
end

always @(posedge clk or negedge rst_n) begin:get_all_cnt
  if(rst_n == 1'b0) begin
    all_cnt <= 'd0;
  end else if(cnt_rst_n == 1'b0) begin
    all_cnt <= 'd0;
  end else if(cmprs_rdf_data_valid == 1'b1) begin
    all_cnt <= all_cnt + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_raw_cnt
  if(rst_n == 1'b0) begin
    col_cnt <= 'd0;
  end else if(cnt_rst_n == 1'b0) begin
    col_cnt <= 'd0;
  end else if(cmprs_rdf_data_valid == 1'b1 && col_cnt == X_max*Z_max-1) begin
    col_cnt <= 'd0;
  end else if(cmprs_rdf_data_valid == 1'b1) begin
    col_cnt <= col_cnt + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin:get_data
  if(cmprs_rdf_data_valid == 1'b1) begin
    $fscanf(fd_high,"%04h",data_high);
    $fscanf(fd_low ,"%04h",data_low);
  end
end
always @(posedge clk or negedge rst_n) begin : get_req_random_cnt
  if(rst_n == 1'b0) begin
    req_random_cnt <= 'd0;
  end else if(output_cpr_req == 1'b1) begin
    req_random_cnt <= req_random_cnt + {$random}%100;
  end else begin
    req_random_cnt <= 'd0;
  end
end
// always @(posedge clk or negedge rst_n) begin : get_grant_r
  // if(rst_n == 1'b0) begin
    // receive_output_code_ready <= 1'b0;
  // end else if(output_cpr_req == 1'b1 && req_random_cnt > 200) begin
    // receive_output_code_ready <= 1'b0;
  // end else begin
    // receive_output_code_ready <= 1'b1;
  // end
// end
// always @(posedge clk or negedge rst_n) begin : get_grant_r
  // if(rst_n == 1'b0) begin
    // grant_r <= 1'b0;
  // end else if(cmprs_dout_req == 1'b1 && req_random_cnt > 4000) begin
    // grant_r <= 1'b1;
  // end else begin
    // grant_r <= 1'b0;
  // end
// end
always @(posedge clk or negedge rst_n) begin : get_grant_r2
  if(rst_n == 1'b0) begin
    grant_r2 <= 1'b0;
  end else begin
    grant_r2 <= grant_r;
  end
end
always @(posedge clk or negedge rst_n) begin : get_out_cnt
  if(rst_n == 1'b0) begin
    out_cnt <= 'd0;
  end else if(encode_data_valid == 1'b1) begin
    out_cnt <= out_cnt + 1'b1;
  end else if(cnt_valid_lst_r == 1'b1) begin
    out_cnt <= 'd0;
  end
end
always @(posedge clk or negedge rst_n) begin : get_cnt_valid_lst_r
  if(rst_n == 1'b0) begin
    cnt_valid_lst_r <= 1'b0;
  end else begin
    cnt_valid_lst_r <= cnt_valid_lst;
  end
end
assign cmprs_fifo_grant = grant_r & ~grant_r2;
assign cmprs_rdf_data_valid = (random_en == 1'b1)?data_valid & cmprs_rdf_data_ready & random_cnt[9]:data_valid & cmprs_rdf_data_ready;

/*compare*/
//定义信号
logic [255:0] matlab_encode_data;
logic [255:0] matlab_encode_data_dis;
logic [255:0] fpga_encode_data;
logic        fpga_encode_data_en;
logic        error_for_encode_data;
logic [31:0] cnt_for_encode_data;
//fpga连接内部信号
// initial begin
  // force fpga_encode_data = top_CCSDS_inst.encode_data;
  // force fpga_encode_data_en = top_CCSDS_inst.encode_data_valid;
// end
//dis信号赋�??
assign matlab_encode_data_dis = matlab_encode_data[255:0];
//文件读数�?
always @(posedge clk) begin : get_matlab_encode_data
  if(fpga_encode_data_en == 1'b1) begin
    $fscanf(fd_encode_data,"%064h",matlab_encode_data);
  end
end
//文件读数据计数器
always @(posedge clk or negedge rst_n) begin : get_cnt_for_encode_data
  if(rst_n == 1'b0) begin
    cnt_for_encode_data <= 'd0;
  end else if(fpga_encode_data_en == 1'b1) begin
    cnt_for_encode_data <= cnt_for_encode_data + 1'b1;
  end
end

//for error
// always @(negedge clk or negedge rst_n) begin : get_error_for_encode_data
  // if(rst_n == 1'b0) begin
    // error_for_encode_data <= 1'b0;
  // end else if(fpga_encode_data_en == 1'b1 && fpga_encode_data == matlab_encode_data_dis) begin
    // error_for_encode_data <= 1'b0;
  // end else if(fpga_encode_data_en == 1'b1) begin
    // error_for_encode_data <= 1'b1;
  // end
// end

/*compare*/
//å®šä¹‰ä¿¡å�?
logic [15:0] matlab_alpha_o;
logic [12:0] matlab_alpha_o_dis;
logic [12:0] fpga_alpha_o;
logic        fpga_alpha_o_en;
logic        error_for_alpha_o;
logic [31:0] cnt_for_alpha_o;
//fpgaè¿žæŽ¥å†�?�éƒ¨ä¿¡å�?
initial begin
  force fpga_alpha_o = top_CCSDS_inst.cal_k_inst.alpha_o;
  force fpga_alpha_o_en = top_CCSDS_inst.cal_k_inst.en_o;
end
//disä¿¡å·èµ‹�???
assign matlab_alpha_o_dis = matlab_alpha_o[12:0];
//æ–�?�ä»¶è¯»æ�?�°æ�??
always @(posedge ccsds_clk) begin : get_matlab_alpha_o
  if(fpga_alpha_o_en == 1'b1) begin
    $fscanf(fd_alpha_o,"%04h",matlab_alpha_o);
  end
end
//æ–�?�ä»¶è¯»æ�?�°æ®è®¡æ�?�°å™¨
always @(posedge ccsds_clk or negedge rst_n) begin : get_cnt_for_alpha_o
  if(rst_n == 1'b0) begin
    cnt_for_alpha_o <= 'd0;
  end else if(cnt_rst_n == 1'b0) begin
    cnt_for_alpha_o <= 'd0;
  end else if(fpga_alpha_o_en == 1'b1) begin
    cnt_for_alpha_o <= cnt_for_alpha_o + 1'b1;
  end
end
//for error
always @(negedge ccsds_clk or negedge rst_n) begin : get_error_for_alpha_o
  if(rst_n == 1'b0) begin
    error_for_alpha_o <= 1'b0;
  end else if(fpga_alpha_o_en == 1'b1 && fpga_alpha_o == matlab_alpha_o_dis) begin
    error_for_alpha_o <= 1'b0;
  end else if(fpga_alpha_o_en == 1'b1) begin
    error_for_alpha_o <= 1'b1;
  end
end
/*compare*/
//å®šä¹‰ä¿¡å�?
logic [3:0]  matlab_k_o;
logic [3:0]  matlab_k_o_dis;
logic [3:0]  fpga_k_o;
logic        fpga_k_o_en;
logic        error_for_k_o;
logic [31:0] cnt_for_k_o;
//fpgaè¿žæŽ¥å†�?�éƒ¨ä¿¡å�?
initial begin
  force fpga_k_o = top_CCSDS_inst.cal_k_inst.k_o;
  force fpga_k_o_en = top_CCSDS_inst.cal_k_inst.en_o;
end
//disä¿¡å·èµ‹�???
assign matlab_k_o_dis = matlab_k_o[3:0];
//æ–�?�ä»¶è¯»æ�?�°æ�??
always @(posedge ccsds_clk) begin : get_matlab_k_o
  if(fpga_k_o_en == 1'b1) begin
    $fscanf(fd_k_o,"%01h",matlab_k_o);
  end
end
//æ–�?�ä»¶è¯»æ�?�°æ®è®¡æ�?�°å™¨
always @(posedge ccsds_clk or negedge rst_n) begin : get_cnt_for_k_o
  if(rst_n == 1'b0) begin
    cnt_for_k_o <= 'd0;
  end else if(cnt_rst_n == 1'b0) begin
    cnt_for_k_o <= 'd0;
  end else if(fpga_k_o_en == 1'b1) begin
    cnt_for_k_o <= cnt_for_k_o + 1'b1;
  end
end
//for error
always @(negedge ccsds_clk or negedge rst_n) begin : get_error_for_k_o
  if(rst_n == 1'b0) begin
    error_for_k_o <= 1'b0;
  end else if(fpga_k_o_en == 1'b1 && fpga_k_o == matlab_k_o_dis) begin
    error_for_k_o <= 1'b0;
  end else if(fpga_k_o_en == 1'b1) begin
    error_for_k_o <= 1'b1;
  end
end

/*compare*/
//å®šä¹‰ä¿¡å�?
logic [51:0] matlab_vec_crt_test;
logic [20+15+3-1:0] matlab_vec_crt_test_dis;
logic [20+15+3-1:0] fpga_vec_crt_test;
logic        fpga_vec_crt_test_en;
logic        error_for_vec_crt_test;
logic [31:0] cnt_for_vec_crt_test;
//fpgaè¿žæŽ¥å†�?�éƒ¨ä¿¡å�?
initial begin
  force fpga_vec_crt_test = top_CCSDS_inst.cal_vec_inst.vec_crt_test;
  force fpga_vec_crt_test_en = top_CCSDS_inst.cal_vec_inst.en_i;
end
//disä¿¡å·èµ‹�???
assign matlab_vec_crt_test_dis = matlab_vec_crt_test[20+15+3-1:0];
//æ–�?�ä»¶è¯»æ�?�°æ�??
always @(posedge ccsds_clk) begin : get_matlab_vec_crt_test
  if(fpga_vec_crt_test_en == 1'b1) begin
    $fscanf(fd_vec_crt_test,"%013h",matlab_vec_crt_test);
  end
end
//æ–�?�ä»¶è¯»æ�?�°æ®è®¡æ�?�°å™¨
always @(posedge ccsds_clk or negedge rst_n) begin : get_cnt_for_vec_crt_test
  if(rst_n == 1'b0) begin
    cnt_for_vec_crt_test <= 'd0;
  end else if(cnt_rst_n == 1'b0) begin
    cnt_for_vec_crt_test <= 'd0;
  end else if(fpga_vec_crt_test_en == 1'b1) begin
    cnt_for_vec_crt_test <= cnt_for_vec_crt_test + 1'b1;
  end
end
//for error
always @(negedge ccsds_clk or negedge rst_n) begin : get_error_for_vec_crt_test
  if(rst_n == 1'b0) begin
    error_for_vec_crt_test <= 1'b0;
  end else if(fpga_vec_crt_test_en == 1'b1 && fpga_vec_crt_test == matlab_vec_crt_test_dis) begin
    error_for_vec_crt_test <= 1'b0;
  end else if(fpga_vec_crt_test_en == 1'b1) begin
    error_for_vec_crt_test <= 1'b1;
  end
end

assign cmprs_data = {data_high,data_low};

/*compare*/
//å®šä¹‰ä¿¡å�?
logic [31:0] matlab_acc_crt_r2;
logic [28:0] matlab_acc_crt_r2_dis;
logic [28:0] fpga_acc_crt_r2;
logic        fpga_acc_crt_r2_en;
logic        error_for_acc_crt_r2;
logic [31:0] cnt_for_acc_crt_r2;
//fpgaè¿žæŽ¥å†�?�éƒ¨ä¿¡å�?
initial begin
  force fpga_acc_crt_r2 = top_CCSDS_inst.cal_k_inst.acc_crt_r2;
  force fpga_acc_crt_r2_en = top_CCSDS_inst.cal_k_inst.en_r2;
end
//disä¿¡å·èµ‹�???
assign matlab_acc_crt_r2_dis = matlab_acc_crt_r2[28:0];
//æ–�?�ä»¶è¯»æ�?�°æ�??
always @(posedge ccsds_clk) begin : get_matlab_acc_crt_r2
  if(fpga_acc_crt_r2_en == 1'b1) begin
    $fscanf(fd_acc_crt_r2,"%08h",matlab_acc_crt_r2);
  end
end
//æ–�?�ä»¶è¯»æ�?�°æ®è®¡æ�?�°å™¨
always @(posedge ccsds_clk or negedge rst_n) begin : get_cnt_for_acc_crt_r2
  if(rst_n == 1'b0) begin
    cnt_for_acc_crt_r2 <= 'd0;
  end else if(cnt_rst_n == 1'b0) begin
    cnt_for_acc_crt_r2 <= 'd0;
  end else if(fpga_acc_crt_r2_en == 1'b1) begin
    cnt_for_acc_crt_r2 <= cnt_for_acc_crt_r2 + 1'b1;
  end
end
//for error
always @(negedge ccsds_clk or negedge rst_n) begin : get_error_for_acc_crt_r2
  if(rst_n == 1'b0) begin
    error_for_acc_crt_r2 <= 1'b0;
  end else if(fpga_acc_crt_r2_en == 1'b1 && fpga_acc_crt_r2 == matlab_acc_crt_r2_dis) begin
    error_for_acc_crt_r2 <= 1'b0;
  end else if(fpga_acc_crt_r2_en == 1'b1) begin
    error_for_acc_crt_r2 <= 1'b1;
  end
end

always @(posedge clk) begin
  if(error_for_encode_data == 1'b1 && encode_data_valid == 1'b1) begin
    $display("error on X_max = %d,Z_max = %d,nn = %d , areax = %d , areay = %d",X_max,Z_max,parameternn,parameterareax,parameterareay);
  end
end
always @(posedge clk) begin
  if(cnt_valid_lst == 1'b1 && code_cnt != out_cnt) begin
    $display("error on code_cnt!!!");
  end
end
always @(posedge clk) begin
  if(cnt_valid_lst == 1'b1) begin
    $display("finish X_max = %d,Z_max = %d,code_cnt = %d,out_cnt = %d,nn = %d , areax = %d , areay = %d",X_max,Z_max,code_cnt,out_cnt,parameternn,parameterareax,parameterareay);
  end
end
top_CCSDS#(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN)
)top_CCSDS_inst
(
    .sclk          (clk  ),
    .rst_n         (rst_n),

    .X_max                (X_max),
    .Z_max                (Z_max),
    .mode                 (mode),
    .cmprs_rdf_data_ready (cmprs_rdf_data_ready),
    .cfg_en               (cfg_en),
    .cmprs_rdf_data_valid (cmprs_rdf_data_valid),
    .cmprs_rdf_rd_data    (cmprs_data),
    .id_ratio             (id_ratio),
    //ddr interface
    // .cmprs_fifo_grant     (cmprs_fifo_grant ),
    // .cmprs_dout_req       (cmprs_dout_req   ),
    // .code_cnt             (code_cnt         ),
    // .cnt_valid_lst        (cnt_valid_lst    ),
    // .cnt_valid_fst        (cnt_valid_fst    ),
    // .encode_data_valid    (encode_data_valid),
    // .encode_data          (encode_data      ),
    // .cmprs_dout_end       (cmprs_dout_end   )
    // .cmprs_out_code_cnt_out                 (cmprs_out_code_cnt_out             ),
    .encode_data_output_ready               (receive_output_code_ready),
    .cmprs_out_ccsds_data_valid_out         (cmprs_out_ccsds_data_valid_out     ),
    .cmprs_out_ccsds_data_out               (cmprs_out_ccsds_data_out           ),
    .cmprs_out_ccsds_finish_flag_out        (cmprs_out_ccsds_finish_flag_out    )
    // .output_cpr_req                         (output_cpr_req)    
);

endmodule