module recover #(
    parameter                 X_LEN = 11,
    parameter                 Y_LEN = 5,
    parameter                 Z_LEN = 8,
    parameter                 W_WIDTH = 12+2+1+16,//dn_width+16
    parameter                 INI_DATA= 31'd0,
    parameter                 Z_INI = 8'd1
)
(
    input  wire               clk,
    input  wire               rst_n,

    input  wire [X_LEN-1:0]   Nx,
    input  wire [Y_LEN-1:0]   Ny,
    input  wire [Z_LEN-1:0]   Nz,

    input  wire [W_WIDTH-1:0] crt_data_i,//20
    input  wire               w_en_i,

    output wire [W_WIDTH-1:0] recover_data_o,
    input  wire               r_en_i,
    output wire               recover_en_o
);
/*************************************for write*****************************************/

    wire                w_en_r2;
    reg                 w_en_r3;
    reg  [X_LEN-1:0]    w_x_cnt_r2;
    reg                 w_x_full_r2p;
    reg                 w_x_full_r2pp;
    reg  [Y_LEN-1:0]    w_y_cnt_r2;
    reg                 w_y_full_r2p;
    reg  [Z_LEN-1:0]    w_z_cnt_r2;
    reg  [Z_LEN-1:0]    w_z_cnt_r2p;
    reg                 w_z_full_r2p;

    reg  [W_WIDTH-1:0]  crt_data_r3;
    reg                 w_RAM_en_r3;
    reg  [Z_LEN-1:0]    w_addr_r3;
/*************************************for read*****************************************/
    reg                 r_en_r;
    reg  [X_LEN-1:0]    r_x_cnt_r;
    reg                 r_x_zero_rp;
    reg                 r_x_full_rp;
    reg  [Y_LEN-1:0]    r_y_cnt_r;
    reg                 r_y_zero_rp;
    reg                 r_y_full_rp;
    reg  [Z_LEN-1:0]    r_z_cnt_r;
    reg                 r_z_full_rp;
    reg                 r_RAM_en_rpp;
    reg                 r_INI_en_rpp;

    reg                 r_en_r2;
    reg  [Z_LEN-1:0]    r_addr_r2;
    reg                 r_RAM_en_r2;
    reg                 r_INI_en_r2;

    reg                 r_en_r3;
    reg                 r_RAM_en_r3;
    reg                 r_INI_en_r3;
    wire [W_WIDTH-1:0]  r_RAM_data_r3;

    reg                 r_en_r4;
    reg                 r_RAM_en_r4;
    reg                 r_INI_en_r4;
    wire [1:0]          r_num_r4;
    reg  [W_WIDTH-1:0]  r_RAM_data_r4;
    reg  [W_WIDTH-1:0]  recover_data_r4p;
    reg                 recover_en_r4p;

    reg  [W_WIDTH-1:0]  recover_data_r5;
    reg                 recover_en_r5;

    // wire [19:0]         ram_din;
    // wire [19:0]         ram_dout;

    wire [W_WIDTH-1:0]         ram_din;
    wire [W_WIDTH-1:0]         ram_dout;
/*************************************common*****************************************/
    reg  [X_LEN-1:0]    Nx_r;
    reg  [Y_LEN-1:0]    Ny_r;
    reg  [Z_LEN-1:0]    Nz_r;
/***************************************************************************************/
/*                                      common                                         */
/***************************************************************************************/

always @(posedge clk or negedge rst_n) begin : common_regist1
  if(rst_n == 1'b0) begin
    Nx_r <= 'd0;
    Ny_r <= 'd0;
    Nz_r <= 'd0;
  end else if(r_en_i == 1'b1) begin
    Nx_r <= Nx;
    Ny_r <= Ny;
    Nz_r <= Nz;
  end
end

/***************************************************************************************/
/*                                    for write                                        */
/***************************************************************************************/

assign w_en_r2 = w_en_i;
always @(posedge clk or negedge rst_n) begin : get_w_en
  if(rst_n == 1'b0) begin
    w_en_r3 <= 1'b0;
  end else begin
    w_en_r3 <= w_en_r2;
  end
end
/***************************************************************************************/
/**************************************regist1******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : w_regist1
  if(rst_n == 1'b0) begin
    crt_data_r3 <= 'd0;
  end else if(w_en_r2 == 1'b1) begin
    crt_data_r3 <= crt_data_i;
  end
end
/***************************************************************************************/
/**************************************stream2******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : get_w_x_cnt_r2
  if(rst_n == 1'b0) begin
    w_x_cnt_r2 <= 'd0;
  end else if(w_en_r2 == 1'b1 && w_x_full_r2p == 1'b1) begin
    w_x_cnt_r2 <= 'd0;
  end else if(w_en_r2 == 1'b1) begin
    w_x_cnt_r2 <= w_x_cnt_r2 + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_w_z_cnt_r2
  if(rst_n == 1'b0) begin
    w_z_cnt_r2 <= Z_INI;
  end else if(w_en_r2 == 1'b1 && w_x_full_r2p == 1'b1 && w_z_full_r2p == 1'b1) begin
    w_z_cnt_r2 <= Z_INI;
  end else if(w_en_r2 == 1'b1 && w_x_full_r2p == 1'b1) begin
    w_z_cnt_r2 <= w_z_cnt_r2 + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_w_y_cnt_r2
  if(rst_n == 1'b0) begin
    w_y_cnt_r2 <= 'd0;
  end else if(w_en_r2 == 1'b1 && w_x_full_r2p == 1'b1 && w_z_full_r2p == 1'b1 && w_y_full_r2p == 1'b1) begin
    w_y_cnt_r2 <= 'd0;
  end else if(w_en_r2 == 1'b1 && w_x_full_r2p == 1'b1 && w_z_full_r2p == 1'b1) begin
    w_y_cnt_r2 <= w_y_cnt_r2 + 1'b1;
  end
end
always @(w_x_cnt_r2,Nx_r) begin : get_w_x_full_r2p
  if(w_x_cnt_r2 == Nx_r-1) begin
    w_x_full_r2p <= 1'b1;
  end else begin
    w_x_full_r2p <= 1'b0;
  end
end
always @(w_z_cnt_r2,Nz_r) begin : get_w_z_full_r2p
  if(w_z_cnt_r2 == Nz_r-1) begin
    w_z_full_r2p <= 1'b1;
  end else begin
    w_z_full_r2p <= 1'b0;
  end
end
always @(w_y_cnt_r2,Ny_r) begin : get_w_y_full_r2p
  if(w_y_cnt_r2 == Ny_r-1) begin
    w_y_full_r2p <= 1'b1;
  end else begin
    w_y_full_r2p <= 1'b0;
  end
end
always @(w_x_full_r2p, w_en_r2) begin : get_w_x_full_r2pp
  if(w_en_r2 == 1'b1) begin
    w_x_full_r2pp <= w_x_full_r2p;
  end else begin
    w_x_full_r2pp <= 1'b0;
  end
end
always @(w_z_cnt_r2, w_en_r2) begin : get_w_z_cnt_r2p
  if(w_en_r2 == 1'b1) begin
    w_z_cnt_r2p <= w_z_cnt_r2;
  end else begin
    w_z_cnt_r2p <= 'd0;
  end
end
/***************************************************************************************/
/**************************************regist3******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : w_regist3
  if(rst_n == 1'b0) begin
    w_addr_r3   <= 'd0;
    w_RAM_en_r3 <= 1'b0;
  end else if(w_en_r2 == 1'b1 || (w_en_r2 == 1'b0 && w_en_r3 == 1'b1) ) begin
    w_addr_r3   <= w_z_cnt_r2p;//w_z_cnt_r2;
    w_RAM_en_r3 <= w_x_full_r2pp;//w_x_full_r2p;
/*  end else begin
    w_addr_r3   <= 'd0;
    w_RAM_en_r3 <= 1'b0;*/
  end
end 
/***************************************************************************************/
/*                                    for   read                                       */
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : get_r_en
  if(rst_n == 1'b0) begin
    r_en_r <= 1'b0;
    r_en_r2<= 1'b0;
    r_en_r3<= 1'b0;
    r_en_r4<= 1'b0;
  end else begin
    r_en_r <= r_en_i;
    r_en_r2<= r_en_r;
    r_en_r3<= r_en_r2;
    r_en_r4<= r_en_r3;
  end
end
/***************************************************************************************/
/**************************************stream1******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : get_r_x_cnt_r
  if(rst_n == 1'b0) begin
    r_x_cnt_r <= 'd0;
  end else if(r_en_r == 1'b1 && r_x_full_rp == 1'b1) begin
    r_x_cnt_r <= 'd0;
  end else if(r_en_r == 1'b1) begin
    r_x_cnt_r <= r_x_cnt_r + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_r_z_cnt_r
  if(rst_n == 1'b0) begin
    r_z_cnt_r <= Z_INI;
  end else if(r_en_r == 1'b1 && r_z_full_rp == 1'b1 && r_x_full_rp == 1'b1) begin
    r_z_cnt_r <= Z_INI;
  end else if(r_en_r == 1'b1 && r_x_full_rp == 1'b1) begin
    r_z_cnt_r <= r_z_cnt_r + 1'b1;
  end
end
always @(posedge clk or negedge rst_n) begin : get_r_y_cnt_r
  if(rst_n == 1'b0) begin
    r_y_cnt_r <= 'd0;
  end else if(r_en_r == 1'b1 && r_z_full_rp == 1'b1 && r_x_full_rp == 1'b1 && r_y_full_rp == 1'b1) begin
    r_y_cnt_r <= 'd0;
  end else if(r_en_r == 1'b1 && r_z_full_rp == 1'b1 && r_x_full_rp == 1'b1) begin
    r_y_cnt_r <= r_y_cnt_r + 1'b1;
  end
end
always @(r_x_cnt_r,Nx_r) begin : get_r_x_full_rp
  if(r_x_cnt_r == Nx_r-1) begin
    r_x_full_rp <= 1'b1;
  end else begin
    r_x_full_rp <= 1'b0;
  end
end
always @(r_z_cnt_r,Nz_r) begin : get_r_z_full_rp
  if(r_z_cnt_r == Nz_r-1) begin
    r_z_full_rp <= 1'b1;
  end else begin
    r_z_full_rp <= 1'b0;
  end
end
always @(r_y_cnt_r,Ny_r) begin : get_r_y_full_rp
  if(r_y_cnt_r == Ny_r-1) begin
    r_y_full_rp <= 1'b1;
  end else begin
    r_y_full_rp <= 1'b0;
  end
end
always @(r_x_cnt_r) begin : get_r_x_zero_rp
  if(r_x_cnt_r == 'd0) begin
    r_x_zero_rp <= 1'b1;
  end else begin
    r_x_zero_rp <= 1'b0;
  end
end
always @(r_y_cnt_r) begin : get_r_y_zero_rp
  if(r_y_cnt_r == 'd0) begin
    r_y_zero_rp <= 1'b1;
  end else begin
    r_y_zero_rp <= 1'b0;
  end
end
always @(r_y_zero_rp,r_x_zero_rp,Nz_r) begin : get_r_RAM_en_rpp
  if(Nz_r < 2) begin
    r_RAM_en_rpp <= 1'b0;
  end else begin
    r_RAM_en_rpp <= (~r_y_zero_rp) & r_x_zero_rp;
  end
end
always @(r_y_zero_rp,r_x_zero_rp) begin : get_r_INI_en_rpp
  r_INI_en_rpp <=   r_y_zero_rp  & r_x_zero_rp;
end
/***************************************************************************************/
/**************************************regist2******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n)begin : regist2
  if(rst_n == 1'b0) begin
    r_addr_r2   <=  'd1;
    r_RAM_en_r2 <= 1'b0;
    r_INI_en_r2 <= 1'b0;
  end else if(r_en_r == 1'b1) begin
    r_addr_r2   <= r_z_cnt_r;
    r_RAM_en_r2 <= r_RAM_en_rpp;
    r_INI_en_r2 <= r_INI_en_rpp;
  end
end

/***************************************************************************************/
/**************************************regist3******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n)begin : regist3
  if(rst_n == 1'b0) begin
    r_RAM_en_r3 <= 1'b0;
    r_INI_en_r3 <= 1'b0;
  end else if(r_en_r2 == 1'b1) begin
    r_RAM_en_r3 <= r_RAM_en_r2;
    r_INI_en_r3 <= r_INI_en_r2;
  end
end
/***************************************************************************************/
/**************************************regist4******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n)begin : regist4
  if(rst_n == 1'b0) begin
    r_RAM_en_r4 <= 1'b0;
    r_INI_en_r4 <= 1'b0;
    r_RAM_data_r4 <= 'd0;
  end else if(r_en_r3 == 1'b1) begin
    r_RAM_en_r4 <= r_RAM_en_r3;
    r_INI_en_r4 <= r_INI_en_r3;
    r_RAM_data_r4 <= r_RAM_data_r3;
  end
end
/***************************************************************************************/
/**************************************stream4******************************************/
/***************************************************************************************/
assign r_num_r4 = {r_RAM_en_r4,r_INI_en_r4};
always @(r_num_r4,r_RAM_data_r4)begin : get_recover_data_r4p
  case (r_num_r4)
   2'b01  : recover_data_r4p <= INI_DATA;
   2'b10  : recover_data_r4p <= r_RAM_data_r4;
   default: recover_data_r4p <= 'd0;
  endcase
end
always @(r_RAM_en_r4,r_INI_en_r4) begin : get_recover_en_r4p
  recover_en_r4p <= r_RAM_en_r4 | r_INI_en_r4;
end
/***************************************************************************************/
/**************************************regist5******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n)begin : regist5
  if(rst_n == 1'b0) begin
    recover_en_r5   <= 1'b0;
    recover_data_r5 <=  'd0;
  end else if(r_en_r4 == 1'b1) begin
    recover_en_r5   <= recover_en_r4p;
    recover_data_r5 <= recover_data_r4p;
  end
end
/***************************************************************************************/
/**************************************  out  ******************************************/
/***************************************************************************************/
assign recover_en_o   = recover_en_r5;
assign recover_data_o = recover_data_r5;
/***************************************************************************************/
/**************************************  ram  ******************************************/
/***************************************************************************************/
 // assign ram_din  = {18'b0,crt_data_r3};
 // assign r_RAM_data_r3 =ram_dout[W_WIDTH-1:0];

assign ram_din  = crt_data_r3;
assign r_RAM_data_r3 =ram_dout;

wight_ram_31x160 wight_ram_inst(
  .clka(clk),    // input wire clka
  .ena(w_RAM_en_r3),      // input wire ena
  .wea(w_RAM_en_r3),      // input wire [0 : 0] wea
  .addra(w_addr_r3),  // input wire [7 : 0] addra
  .dina(ram_din),    // input wire [30 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(r_RAM_en_r2),      // input wire enb
  .addrb(r_addr_r2),  // input wire [7 : 0] addrb
  .doutb(ram_dout)  // output wire [30 : 0] doutb
);

endmodule