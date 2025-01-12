module pixel_rec #(
    parameter           X_LEN = 11,
    parameter           Y_LEN = 5,
    parameter           Z_LEN = 8,
    parameter           DATA_WIDTH = 12,//16
    parameter           Z_INI = 8'd0
)
(
    input  wire                  clk,
    (* keep = "true" *)   input  wire                  rst_n,
    input  wire [31:0]           data_i,
     (* keep = "true" *)  input  wire                  en_i,
    input  wire [X_LEN-1:0]      Nx,
    input  wire [Y_LEN-1:0]      Ny,
    input  wire [Z_LEN-1:0]      Nz,

    output wire [4:0]            scan_area_o,
    output wire [3:0]            sl_num_o,
    output wire [DATA_WIDTH-1:0] S_o,
   // output wire [DATA_WIDTH-1:0] Sw_o,
    output wire [DATA_WIDTH-1:0] Sne_o,
    output wire [DATA_WIDTH-1:0] Sn_o,
    output wire [DATA_WIDTH-1:0] Snw_o,
    output wire [DATA_WIDTH-1:0] cj_fst_o,
    output wire                  spec_fst_o,
    output wire                  en_block_cnt_o,
    output wire                  en_fst_blo_o,
    output wire                  en_o
);

   (* keep = "true" *)  reg                          en_r;
  (* keep = "true" *)  reg    [X_LEN-1:0]           x_cnt_r;
    reg                          x_fst_rp;
    reg                          x_lst_rp;
    reg    [Y_LEN-1:0]           y_cnt_r;
    reg                          y_fst_rp;
    reg                          y_lst_rp;
    reg    [Z_LEN-1:0]           z_cnt_r;
    reg                          z_lst_rp;
    reg                          z_fst_rp;
    reg    [4:0]                 scan_area_rp;
    reg    [3:0]                 sl_num_rp;
  (* keep = "true" *)  reg    [31:0]                data_r;
    reg    [X_LEN-1:0]           Nx_r;
    reg    [Y_LEN-1:0]           Ny_r;
    reg    [Z_LEN-1:0]           Nz_r;

    reg                          en_r2;
    reg                          x_lst_r2;
    reg                          en_r2p;
    wire   [1:0]                 en_num;
    reg    [4:0]                 scan_area_r2;
    reg    [3:0]                 sl_num_r2;
    reg    [DATA_WIDTH-1:0]      S_r2;
    reg    [DATA_WIDTH-1:0]      Sw_r2;
    wire   [DATA_WIDTH-1:0]      Sne_r2;
    reg    [DATA_WIDTH-1:0]      Sn_r2;
    reg    [DATA_WIDTH-1:0]      Snw_r2;
   (* keep = "true" *) reg    [DATA_WIDTH-1:0]      cj_fst;
    reg                          spec_fst;
    reg                          block_fst;
    reg                          spec_fst_r2;
    reg[7:0]                     block_cnt;
    reg                          en_block_cnt;
    reg                          en_fst_blo_r;
    reg                          en_block_cnt_r2;
    reg                          en_fst_blo_r2;
/***************************************************************************************/
/**************************************regist1******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin:register1
  if(rst_n == 1'b0) begin
    data_r <= 'd0;
    Nx_r   <= 'd0;
    Ny_r   <= 'd0;
    Nz_r   <= 'd0;
  end else if(en_i == 1'b1) begin
    data_r <= data_i;
    Nx_r   <= Nx;
    Ny_r   <= Ny;
    Nz_r   <= Nz;
  end
end

always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    en_r  <= 1'b0;
    en_r2 <= 1'b0;
  end else begin
    en_r  <= en_i;
    en_r2 <= en_r;
  end
end
/***************************************************************************************/
/**************************************stream1******************************************/
/***************************************************************************************/
always @(x_cnt_r) begin:get_x_fst_rp
   if(x_cnt_r == 'd0) begin
     x_fst_rp <= 1'b1;
   end else begin
     x_fst_rp <= 1'b0;
   end
end
always @(x_cnt_r,Nx_r) begin:get_x_lst_rp
   if(x_cnt_r == Nx_r-1'd1) begin
     x_lst_rp <= 1'b1;
   end else begin
     x_lst_rp <= 1'b0;
   end
end
always @(y_cnt_r) begin:get_y_fst_rp
   if(y_cnt_r == 'd0) begin
     y_fst_rp <= 1'b1;
   end else begin
     y_fst_rp <= 1'b0;
   end
end
always @(y_cnt_r,Ny_r) begin:get_y_lst_rp
   if(y_cnt_r == Ny_r-1'd1) begin
     y_lst_rp <= 1'b1;
   end else begin
     y_lst_rp <= 1'b0;
   end
end
always @(z_cnt_r,Nz_r) begin:get_z_lst_rp
   if(z_cnt_r == Nz_r-1'd1) begin
     z_lst_rp <= 1'b1;
   end else begin
     z_lst_rp <= 1'b0;
   end
end
always @(z_cnt_r) begin:get_z_fst_rp
   if(z_cnt_r == 'd0) begin
     z_fst_rp <= 1'b1;
   end else begin
     z_fst_rp <= 1'b0;
   end
end
always @(x_fst_rp,y_fst_rp) begin:get_spec_fst
   if(x_fst_rp == 1'b1 && y_fst_rp == 1'b1 ) begin
     spec_fst <= 1'b1;
   end else begin
     spec_fst <= 1'b0;
   end
end
always @(x_fst_rp,y_fst_rp,z_fst_rp) begin:get_block_fst
   if(x_fst_rp == 1'b1 && y_fst_rp == 1'b1 && z_fst_rp == 1'b1) begin//每一块的第一个数
     block_fst <= 1'b1;
   end else begin
     block_fst <= 1'b0;
   end
end
always @(x_fst_rp,x_lst_rp,y_fst_rp) begin:get_scan_area_rp
   scan_area_rp[0] <= ( x_fst_rp) & (~x_lst_rp) & ( y_fst_rp); //INI   -- 101 y ==0 x == 0 
   scan_area_rp[1] <= (~x_fst_rp) & (~x_lst_rp) & (~y_fst_rp); //area1 -- 000 y>0   x>0 x<Nx
   scan_area_rp[2] <= (~x_fst_rp) &               ( y_fst_rp); //area2 -- 0x1 y ==0 x >0
   scan_area_rp[3] <= ( x_fst_rp) & (~x_lst_rp) & (~y_fst_rp); //area3 -- 100 y > 0 x== 0
   scan_area_rp[4] <= (~x_fst_rp) & ( x_lst_rp) & (~y_fst_rp); //area4 -- 010 y > 0 x== Nx
end
always @(posedge clk or negedge rst_n) begin:get_x_cnt_r
  if(rst_n == 1'b0) begin
    x_cnt_r <= 'd0;
  end else if(en_r == 1'b1 && x_lst_rp == 1'b1) begin
    x_cnt_r <= 'd0;
  end else if(en_r == 1'b1) begin
    x_cnt_r <= x_cnt_r + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin:get_y_cnt_r
  if(rst_n == 1'b0) begin
    y_cnt_r <= 'd0;
  end else if(en_r == 1'b1 && y_lst_rp == 1'b1 && z_lst_rp == 1'b1 && x_lst_rp == 1'b1) begin
    y_cnt_r <= 'd0;
  end else if(en_r == 1'b1 && z_lst_rp == 1'b1 && x_lst_rp == 1'b1) begin
    y_cnt_r <= y_cnt_r + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin:get_z_cnt_r
  if(rst_n == 1'b0) begin
    z_cnt_r <= Z_INI;
  end else if(en_r == 1'b1 && z_lst_rp == 1'b1 && x_lst_rp == 1'b1) begin
    z_cnt_r <= Z_INI;
  end else if(en_r == 1'b1 && x_lst_rp == 1'b1) begin
    z_cnt_r <= z_cnt_r + 1'b1;
  end
end

always @(posedge clk or negedge rst_n)begin :get_block_cnt
    if(rst_n == 1'b0)begin
        block_cnt <= 'd0;
    end else if(z_cnt_r== 'd0 && y_cnt_r =='d0&& x_cnt_r == 'd0 && en_r == 1'b1)begin
        block_cnt <= block_cnt+1;
    end 
end
always @(x_fst_rp,z_fst_rp,y_fst_rp,en_r,block_cnt) begin:get_en_fst_blo_r
    //if(block_cnt == 1'b0 && y_lst_rp == 1'b0 && en_r)begin
    if(block_cnt == 'd0 &&x_fst_rp == 1'b1 &&y_fst_rp == 1'b1 &&z_fst_rp == 1'b1 && en_r)begin
        en_fst_blo_r <= 1'b1;//拉高换量化步长
    end else begin
        en_fst_blo_r <= 1'b0;
    end
end
always @(y_lst_rp,en_r) begin:get_en_block_cnt
    //if(block_cnt == 1'b0 && y_lst_rp == 1'b0 && en_r)begin
    if(y_lst_rp == 1'b0 && en_r)begin
        en_block_cnt <= 1'b1;//拉高换量化步长
    end else begin
        en_block_cnt <= 1'b0;
    end
end
always @(z_cnt_r) begin:get_sl_num_rp
  if(z_cnt_r == 0) begin
    sl_num_rp <= 4'b0001;
  end else if(z_cnt_r == 1) begin
    sl_num_rp <= 4'b0010;
  end else if(z_cnt_r == 2) begin
    sl_num_rp <= 4'b0100;
  end else begin
    sl_num_rp <= 4'b1000;
  end
end
/***************************************************************************************/
/**************************************regist2******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin:register2
  if(rst_n == 1'b0) begin
    scan_area_r2 <=  'd0;
    S_r2         <=  'd0;
    Sn_r2        <=  'd0;
    Snw_r2       <=  'd0;
    sl_num_r2    <=  'd0;
    x_lst_r2     <=  'd0;
    spec_fst_r2  <=  'd0;
    en_block_cnt_r2<= 'd0;
    en_fst_blo_r2 <= 'd0;
  end else if(en_r == 1'b1) begin
    scan_area_r2 <=  scan_area_rp;
    S_r2         <=  data_r[15:0];
    Sn_r2        <=  Sne_r2;
    Snw_r2       <=  Sn_r2;
    sl_num_r2    <=  sl_num_rp;
    x_lst_r2     <=  x_lst_rp;
    spec_fst_r2  <=  spec_fst;
    en_block_cnt_r2<= en_block_cnt;
    en_fst_blo_r2 <= en_fst_blo_r;
  end
end
assign Sne_r2 = data_r[31:16];

always @(posedge clk or negedge rst_n) begin: get_cj_fst
    if(rst_n == 1'b0)begin
        cj_fst <= 'd0;
    end else if(en_r == 1'b1 && y_cnt_r == 'd0 && x_cnt_r == 'd0)  begin//第一行的时候
        cj_fst <= data_r[15:0];
    end 
end
/***************************************************************************************/
/**************************************stream2******************************************/
/***************************************************************************************/
assign en_num = {en_r,en_r2};
always @(en_num,x_lst_r2,en_r2,x_fst_rp) begin : get_en_r2p
  case (en_num)
    2'b00  : en_r2p <= 1'b0;
    2'b01  :  if(x_lst_r2 == 1'b1 && en_r2 == 1'b1) begin
                en_r2p <= 1'b1;
              end else begin
                en_r2p <= 1'b0;
              end
    2'b10  :  if(x_fst_rp == 1'b1) begin
                en_r2p <= 1'b0;
              end else begin
                en_r2p <= 1'b1;
              end
    2'b11  : en_r2p <= 1'b1;
    default: en_r2p <= 1'b0;
  endcase
end
/***************************************************************************************/
/**************************************  out  ******************************************/
/***************************************************************************************/

assign sl_num_o    = sl_num_r2;
assign scan_area_o = scan_area_r2;
assign S_o         = S_r2;
assign Sne_o       = Sne_r2;
assign Sn_o        = Sn_r2;
assign Snw_o       = Snw_r2;
assign cj_fst_o    = cj_fst;
assign en_o        = en_r2p;
assign spec_fst_o  = spec_fst_r2;
assign en_block_cnt_o = en_block_cnt_r2;
assign en_fst_blo_o = en_fst_blo_r2;
endmodule