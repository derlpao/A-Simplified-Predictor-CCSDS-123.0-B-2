`timescale 1ns/1ps
module tb_top_ccsds_for_c;

//ini_file_path
string  ini_file_path = "E:/project/CCSDS_3mode/ccsds_3mode/c_prj/接口演示程序-推扫模式/Release/test_ini.ini";
integer fd_ini;

//ccsds ip parameter
parameter      X_LEN = 11;
parameter      Y_LEN = 6;
parameter      Z_LEN = 8;
//ccsds signal
logic             clk;
logic             rst_n;
logic             cmprs_rdf_data_valid;
logic [X_LEN-1:0] X_max;
logic [Z_LEN-1:0] Z_max;
logic [1:0]       mode;
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

// ccsds input clk and rst_n
initial begin
    clk    = 1'b0;
    rst_n <= 1'b0;
    # 500;
    rst_n <= 1'b1;
    # 500;
end
always #2.5 clk = ~clk;

// ccsds internal clk
initial begin
    force ccsds_clk = top_CCSDS_inst.clk;
end

// read ini
string ini_data;
initial begin
    fd_ini = $fopen(ini_file_path, "r");
    while($fgets(ini_data,fd_ini)) begin
        $display(ini_data);
    end
    $fclose(fd_ini);
end








// ccsds ip
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
    .cmprs_rdf_rd_data    ({4'd0,data_high,4'd0,data_low}),

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