module encode_proce #(
    parameter      X_LEN                        = 11   ,
    parameter      Y_LEN                        = 6    ,
    parameter      Z_LEN                        = 8    ,
    parameter      WIDTH                        = 16   ,

    parameter      GOLOMB_ENCODE_DATALENTH      = 50,
    parameter      TOTAL_ENCODE_DATALENTH       = 64,
    parameter      ZERO_NUM_MAN                 = 16,
    parameter      CODE_DATALENGTH              = 21,      
    parameter      ENTROPY_ENCODE_DATALENGTH    = CODE_DATALENGTH + ZERO_NUM_MAN + 17+1
)
(
    input   wire                                         clk                ,
    input   wire                                         rst_n              ,
    input   wire                                         en_i               ,
    
    
    input   wire   [X_LEN-1:0]                           Nx_i               ,
    input   wire   [Y_LEN-1:0]                           Ny_i               ,
    input   wire   [Z_LEN-1:0]                           Nz_i               ,
    input   wire   [2:0]                                 mode_i             ,
    
    input   wire   [30:0]                                up_img_bit_i          ,
    input   wire   [30:0]                                low_img_bit_i         ,
    input   wire   [WIDTH+1:0]                              encode_golo_i      ,//哥伦布编�? 修改为WIDTH+1
    input   wire                                         golo_valid_i       ,//哥伦布编码有�?
    input   wire   [5 : 0]                               golo_len_i         ,//哥伦布编码长�?
    
    input   wire   [3:0]                                 index_now_i        ,
    input   wire   [ENTROPY_ENCODE_DATALENGTH - 1 : 0]   encode_low_entpy_i ,//低熵编码 
    input   wire                                         low_entpy_valid_i  ,//低熵编码有效
    input   wire   [5 : 0]                               low_entpy_len_i    ,//低熵编码长度
    
    output  wire   [TOTAL_ENCODE_DATALENTH-1:0]          data_o             ,
    output  wire                                         en_o               ,
    output  wire                                         eob_o              ,
    output  wire    [30:0]                               byte_cnt_o         ,
    output  wire    [2:0]                                up_mode_o          ,
    output  wire                                         en_upmode_o        ,
    
    output  wire                                         en_b_o             

);
parameter     TEMP_WIDTH  = 64;
reg  [30:0]                                             img_bit_r          ;
reg  [30:0]                                             img_bit_rp         ;
/***********golomb**************/
reg  [WIDTH+1:0]                                          encode_golo_r      ;
reg  [WIDTH:0]                                          new_encoded_data   ;
reg                                                     golo_valid_r       ;
reg  [5 : 0]                                            golo_len_r         ;
/***********entropy**************/                                          
reg  [ENTROPY_ENCODE_DATALENGTH - 1 : 0]                encode_low_entpy_r ;
reg                                                     low_entpy_valid_r  ;
reg  [5 : 0]                                            low_entpy_len_r    ;
reg  [3 : 0]                                            index_now_r        ;

reg                            en_r  ;
reg                            en_r2 ;
reg                            en_r3 ;
reg                            w_en_r2p  ;
reg                            w_en_r2pp ;
reg                            w_en_r3pp;
reg [TEMP_WIDTH*2-1:0]  next_all_reg_r2pp  ;
wire[TEMP_WIDTH*2-1:0]  pre_all_reg_r      ;
reg [6:0]               next_len_r2pp      ;            
wire[5:0]               pre_len_r          ;            
                                           
reg [6:0]               now_len_r2         ;
reg [6:0]               now_len_r2p        ;
reg [5:0]               next_len_r2p       ;
reg                     en_now_len_r2p     ;
reg [TEMP_WIDTH*2-1:0]  now_all_reg_r2     ;
reg [TEMP_WIDTH*2-1:0]  now_all_reg_r2p    ;
reg [TEMP_WIDTH*2-1:0]  next_all_reg_r2p   ;
reg                     en_b               ;
//reg                     en_b_r             ;
reg [TEMP_WIDTH-1:0]    data_out_r2        ;
//reg [TEMP_WIDTH-1:0]    data_out_r3        ;
reg [X_LEN-1:0]         x_cnt_r            ;
reg                     x_lst_rp           ;
reg                     x_fst_rp           ;
reg [Z_LEN-1:0]         z_cnt_r            ;
reg                     z_fst_rp           ;
reg                     z_lst_rp           ;
reg [Y_LEN-1:0]         y_cnt_r            ;
reg                     y_lst_rp           ;
reg                     eob_rp             ;
reg                     eob_r2             ;
reg                     eob_r3             ;
//reg                     eob_r4             ;

reg [30:0]              byte_cnt_r         ;
reg [30:0]              byte_cnt_r2        ;
reg [30:0]              byte_cnt_r_p       ;

reg [2:0]               mode_r             ;
reg [30:0]              up_block_byte_cnt_r;
reg [30:0]              up_img_bit_r   ;
reg [30:0]              low_img_bit_r  ; 
reg [30:0]              up_img_bit_rp  ;
reg [30:0]              low_img_bit_rp ;
reg [2:0]               up_mode_r      ;
reg [2:0]               up_mode_rp     ;

reg [X_LEN-1:0]         Nx_r               ;
reg [Y_LEN-1:0]         Ny_r               ;
reg [Z_LEN-1:0]         Nz_r               ;
/*****************control cpr ratio****************/
reg                     en_last_spec_rppp;
reg                     en_last_spec_rpp;
reg                     en_last_spec_rp;
reg                     en_test        ;
//integer                 file_data_out_new  ; 
 
always @(posedge clk or negedge rst_n)begin: resist1
    if(rst_n == 1'b0) begin 
        Nx_r                <= 'd0;
        Ny_r                <= 'd0;
        Nz_r                <= 'd0;
    
        encode_golo_r       <= 'd0;
        golo_valid_r        <= 'd0;
        golo_len_r          <= 'd0;

        encode_low_entpy_r  <= 'd0;
        low_entpy_valid_r   <= 'd0;
        low_entpy_len_r     <= 'd0;
        
        up_img_bit_r           <= 'd0;
        low_img_bit_r           <= 'd0;
        index_now_r         <= 'd0;
        mode_r              <= 'd0;
    end else if(en_i == 1'b1) begin
        Nx_r                <=   Nx_i;
        Ny_r                <=   Ny_i;
        Nz_r                <=   Nz_i;
    
        encode_golo_r       <=   encode_golo_i      ;
        golo_valid_r        <=   golo_valid_i       ;
        golo_len_r          <=   golo_len_i         ;
                                                    
        encode_low_entpy_r  <=   encode_low_entpy_i ;
        low_entpy_valid_r   <=   low_entpy_valid_i  ;
        low_entpy_len_r     <=   low_entpy_len_i    ;
        
        up_img_bit_r           <= up_img_bit_i;
        low_img_bit_r           <= low_img_bit_i;
        index_now_r         <= index_now_i  ;
        mode_r              <= mode_i;
    end
end

always @(posedge clk or negedge rst_n)begin: get_en
    if(rst_n == 1'b0) begin 
        en_r    <= 'd0;
        en_r2   <= 'd0;
        en_r3   <= 'd0;
        w_en_r2pp<='d0;
        w_en_r3pp<='d0;
        en_last_spec_rpp<= 'd0;
        en_last_spec_rppp<= 'd0;
    end else begin
        en_r    <= en_i;
        en_r2   <= en_r;
        en_r3   <= en_r2;
        w_en_r2pp<=w_en_r2p;
        w_en_r3pp<=w_en_r2pp;
        en_last_spec_rpp<= en_last_spec_rp;
        en_last_spec_rppp<= en_last_spec_rpp;
    end
end
assign pre_all_reg_r = next_all_reg_r2pp;//之前编的�?
assign pre_len_r = next_len_r2pp;//之前码的码长

/*always @(en_r == 1'b1,golo_valid_r,index_now_r)begin
    if(en_r == 1'b1&&golo_valid_r== 1'b1&& index_now_r == 'd15)begin
        en_test <= 1'b1;
    end else begin
        en_test <= 1'b0;
    end    
end*/

always @(pre_len_r,golo_len_r,en_r,golo_valid_r,low_entpy_valid_r,low_entpy_len_r,index_now_r,now_len_r2p) begin : get_now_len_r //两种编码模式共享
  if(en_r == 1'b1&&low_entpy_valid_r== 1'b1) begin//低熵编码长度计数
    now_len_r2 <= pre_len_r + low_entpy_len_r;
  end else if(en_r == 1'b1&&golo_valid_r== 1'b1&& index_now_r == 'd15) begin//哥伦布编码长度计�?
    now_len_r2 <= pre_len_r + golo_len_r;//加上当前残差的码流后的码�?
  // end else if(en_r == 1'b1&&low_entpy_valid_r== 1'b1) begin//低熵编码长度计数
    // now_len_r2 <= pre_len_r + low_entpy_len_r;
  end else begin
    now_len_r2 <= now_len_r2p;//scp xiugai
  end
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)begin
        now_len_r2p <= 'd0;
    end else begin
        now_len_r2p <= now_len_r2;
    end
end 

always @(now_len_r2,eob_r2) begin : get_next_len_r2
  if(eob_r2 == 1'b1) begin
    next_len_r2p <= 'd0;
  end else begin
    next_len_r2p <= now_len_r2[5:0];//7�?6
  end
end

always @(now_len_r2,pre_all_reg_r,encode_golo_r, encode_low_entpy_r, golo_valid_r, low_entpy_valid_r,index_now_r) begin : get_now_all_reg_r2
    if (golo_valid_r== 1'b1 && index_now_r == 'd15) begin     
  case (now_len_r2) //拼接完之后的码流长度
    7'd1   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[0:0],{TEMP_WIDTH*2-1{1'b0}}};
    7'd2   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[1:0],{TEMP_WIDTH*2-2{1'b0}}};
    7'd3   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[2:0],{TEMP_WIDTH*2-3{1'b0}}};
    7'd4   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[3:0],{TEMP_WIDTH*2-4{1'b0}}};
    7'd5   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[4:0],{TEMP_WIDTH*2-5{1'b0}}};
    7'd6   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[5:0],{TEMP_WIDTH*2-6{1'b0}}};
    7'd7   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[6:0],{TEMP_WIDTH*2-7{1'b0}}};
    7'd8   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[7:0],{TEMP_WIDTH*2-8{1'b0}}};
    7'd9   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[8:0],{TEMP_WIDTH*2-9{1'b0}}};
    7'd10   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[9:0],{TEMP_WIDTH*2-10{1'b0}}};
    7'd11   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[10:0],{TEMP_WIDTH*2-11{1'b0}}};
    7'd12   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[11:0],{TEMP_WIDTH*2-12{1'b0}}};
    7'd13   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[12:0],{TEMP_WIDTH*2-13{1'b0}}};
    7'd14   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[13:0],{TEMP_WIDTH*2-14{1'b0}}};
    7'd15   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[14:0],{TEMP_WIDTH*2-15{1'b0}}};
    7'd16   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[15:0],{TEMP_WIDTH*2-16{1'b0}}};
    7'd17   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[16:0],{TEMP_WIDTH*2-17{1'b0}}};
    7'd18   : now_all_reg_r2 <= pre_all_reg_r | {encode_golo_r[17:0],{TEMP_WIDTH*2-18{1'b0}}};//位宽修改 7_16
    7'd19   : now_all_reg_r2 <= pre_all_reg_r | {{19-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-19{1'b0}}};
    7'd20   : now_all_reg_r2 <= pre_all_reg_r | {{20-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-20{1'b0}}};
    7'd21   : now_all_reg_r2 <= pre_all_reg_r | {{21-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-21{1'b0}}};
    7'd22   : now_all_reg_r2 <= pre_all_reg_r | {{22-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-22{1'b0}}};
    7'd23   : now_all_reg_r2 <= pre_all_reg_r | {{23-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-23{1'b0}}};
    7'd24   : now_all_reg_r2 <= pre_all_reg_r | {{24-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-24{1'b0}}};
    7'd25   : now_all_reg_r2 <= pre_all_reg_r | {{25-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-25{1'b0}}};
    7'd26   : now_all_reg_r2 <= pre_all_reg_r | {{26-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-26{1'b0}}};
    7'd27   : now_all_reg_r2 <= pre_all_reg_r | {{27-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-27{1'b0}}};
    7'd28   : now_all_reg_r2 <= pre_all_reg_r | {{28-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-28{1'b0}}};
    7'd29   : now_all_reg_r2 <= pre_all_reg_r | {{29-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-29{1'b0}}};
    7'd30   : now_all_reg_r2 <= pre_all_reg_r | {{30-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-30{1'b0}}};
    7'd31   : now_all_reg_r2 <= pre_all_reg_r | {{31-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-31{1'b0}}};
    7'd32   : now_all_reg_r2 <= pre_all_reg_r | {{32-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-32{1'b0}}};
    7'd33   : now_all_reg_r2 <= pre_all_reg_r | {{33-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-33{1'b0}}};
    7'd34   : now_all_reg_r2 <= pre_all_reg_r | {{34-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-34{1'b0}}};
    7'd35   : now_all_reg_r2 <= pre_all_reg_r | {{35-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-35{1'b0}}};
    7'd36   : now_all_reg_r2 <= pre_all_reg_r | {{36-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-36{1'b0}}};
    7'd37   : now_all_reg_r2 <= pre_all_reg_r | {{37-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-37{1'b0}}};
    7'd38   : now_all_reg_r2 <= pre_all_reg_r | {{38-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-38{1'b0}}};
    7'd39   : now_all_reg_r2 <= pre_all_reg_r | {{39-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-39{1'b0}}};
    7'd40   : now_all_reg_r2 <= pre_all_reg_r | {{40-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-40{1'b0}}};
    7'd41   : now_all_reg_r2 <= pre_all_reg_r | {{41-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-41{1'b0}}};
    7'd42   : now_all_reg_r2 <= pre_all_reg_r | {{42-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-42{1'b0}}};
    7'd43   : now_all_reg_r2 <= pre_all_reg_r | {{43-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-43{1'b0}}};
    7'd44   : now_all_reg_r2 <= pre_all_reg_r | {{44-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-44{1'b0}}};
    7'd45   : now_all_reg_r2 <= pre_all_reg_r | {{45-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-45{1'b0}}};
    7'd46   : now_all_reg_r2 <= pre_all_reg_r | {{46-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-46{1'b0}}};
    7'd47   : now_all_reg_r2 <= pre_all_reg_r | {{47-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-47{1'b0}}};
    7'd48   : now_all_reg_r2 <= pre_all_reg_r | {{48-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-48{1'b0}}};
    7'd49   : now_all_reg_r2 <= pre_all_reg_r | {{49-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-49{1'b0}}};
    7'd50   : now_all_reg_r2 <= pre_all_reg_r | {{50-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-50{1'b0}}};
    7'd51   : now_all_reg_r2 <= pre_all_reg_r | {{51-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-51{1'b0}}};
    7'd52   : now_all_reg_r2 <= pre_all_reg_r | {{52-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-52{1'b0}}};
    7'd53   : now_all_reg_r2 <= pre_all_reg_r | {{53-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-53{1'b0}}};
    7'd54   : now_all_reg_r2 <= pre_all_reg_r | {{54-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-54{1'b0}}};
    7'd55   : now_all_reg_r2 <= pre_all_reg_r | {{55-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-55{1'b0}}};
    7'd56   : now_all_reg_r2 <= pre_all_reg_r | {{56-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-56{1'b0}}};
    7'd57   : now_all_reg_r2 <= pre_all_reg_r | {{57-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-57{1'b0}}};
    7'd58   : now_all_reg_r2 <= pre_all_reg_r | {{58-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-58{1'b0}}};
    7'd59   : now_all_reg_r2 <= pre_all_reg_r | {{59-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-59{1'b0}}};
    7'd60   : now_all_reg_r2 <= pre_all_reg_r | {{60-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-60{1'b0}}};
    7'd61   : now_all_reg_r2 <= pre_all_reg_r | {{61-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-61{1'b0}}};
    7'd62   : now_all_reg_r2 <= pre_all_reg_r | {{62-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-62{1'b0}}};
    7'd63   : now_all_reg_r2 <= pre_all_reg_r | {{63-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-63{1'b0}}};
    7'd64   : now_all_reg_r2 <= pre_all_reg_r | {{64-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-64{1'b0}}};
    7'd65   : now_all_reg_r2 <= pre_all_reg_r | {{65-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-65{1'b0}}};
    7'd66   : now_all_reg_r2 <= pre_all_reg_r | {{66-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-66{1'b0}}};
    7'd67   : now_all_reg_r2 <= pre_all_reg_r | {{67-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-67{1'b0}}};
    7'd68   : now_all_reg_r2 <= pre_all_reg_r | {{68-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-68{1'b0}}};
    7'd69   : now_all_reg_r2 <= pre_all_reg_r | {{69-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-69{1'b0}}};
    7'd70   : now_all_reg_r2 <= pre_all_reg_r | {{70-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-70{1'b0}}};
    7'd71   : now_all_reg_r2 <= pre_all_reg_r | {{71-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-71{1'b0}}};
    7'd72   : now_all_reg_r2 <= pre_all_reg_r | {{72-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-72{1'b0}}};
    7'd73   : now_all_reg_r2 <= pre_all_reg_r | {{73-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-73{1'b0}}};
    7'd74   : now_all_reg_r2 <= pre_all_reg_r | {{74-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-74{1'b0}}};
    7'd75   : now_all_reg_r2 <= pre_all_reg_r | {{75-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-75{1'b0}}};
    7'd76   : now_all_reg_r2 <= pre_all_reg_r | {{76-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-76{1'b0}}};
    7'd77   : now_all_reg_r2 <= pre_all_reg_r | {{77-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-77{1'b0}}};
    7'd78   : now_all_reg_r2 <= pre_all_reg_r | {{78-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-78{1'b0}}};
    7'd79   : now_all_reg_r2 <= pre_all_reg_r | {{79-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-79{1'b0}}};
    7'd80   : now_all_reg_r2 <= pre_all_reg_r | {{80-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-80{1'b0}}};
    7'd81   : now_all_reg_r2 <= pre_all_reg_r | {{81-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-81{1'b0}}};
    7'd82   : now_all_reg_r2 <= pre_all_reg_r | {{82-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-82{1'b0}}};
    7'd83   : now_all_reg_r2 <= pre_all_reg_r | {{83-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-83{1'b0}}};
    7'd84   : now_all_reg_r2 <= pre_all_reg_r | {{84-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-84{1'b0}}};
    7'd85   : now_all_reg_r2 <= pre_all_reg_r | {{85-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-85{1'b0}}};
    7'd86   : now_all_reg_r2 <= pre_all_reg_r | {{86-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-86{1'b0}}};
    7'd87   : now_all_reg_r2 <= pre_all_reg_r | {{87-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-87{1'b0}}};
    7'd88   : now_all_reg_r2 <= pre_all_reg_r | {{88-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-88{1'b0}}};
    7'd89   : now_all_reg_r2 <= pre_all_reg_r | {{89-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-89{1'b0}}};
    7'd90   : now_all_reg_r2 <= pre_all_reg_r | {{90-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-90{1'b0}}};
    7'd91   : now_all_reg_r2 <= pre_all_reg_r | {{91-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-91{1'b0}}};
    7'd92   : now_all_reg_r2 <= pre_all_reg_r | {{92-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-92{1'b0}}};
    7'd93   : now_all_reg_r2 <= pre_all_reg_r | {{93-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-93{1'b0}}};
    7'd94   : now_all_reg_r2 <= pre_all_reg_r | {{94-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-94{1'b0}}};
    7'd95   : now_all_reg_r2 <= pre_all_reg_r | {{95-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-95{1'b0}}};
    7'd96   : now_all_reg_r2 <= pre_all_reg_r | {{96-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-96{1'b0}}};
    7'd97   : now_all_reg_r2 <= pre_all_reg_r | {{97-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-97{1'b0}}};
    7'd98   : now_all_reg_r2 <= pre_all_reg_r | {{98-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-98{1'b0}}};
    7'd99   : now_all_reg_r2 <= pre_all_reg_r | {{99-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-99{1'b0}}};
    7'd100   : now_all_reg_r2 <= pre_all_reg_r | {{100-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-100{1'b0}}};
    7'd101   : now_all_reg_r2 <= pre_all_reg_r | {{101-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-101{1'b0}}};
    7'd102   : now_all_reg_r2 <= pre_all_reg_r | {{102-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-102{1'b0}}};
    7'd103   : now_all_reg_r2 <= pre_all_reg_r | {{103-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-103{1'b0}}};
    7'd104   : now_all_reg_r2 <= pre_all_reg_r | {{104-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-104{1'b0}}};
    7'd105   : now_all_reg_r2 <= pre_all_reg_r | {{105-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-105{1'b0}}};
    7'd106   : now_all_reg_r2 <= pre_all_reg_r | {{106-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-106{1'b0}}};
    7'd107   : now_all_reg_r2 <= pre_all_reg_r | {{107-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-107{1'b0}}};
    7'd108   : now_all_reg_r2 <= pre_all_reg_r | {{108-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-108{1'b0}}};
    7'd109   : now_all_reg_r2 <= pre_all_reg_r | {{109-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-109{1'b0}}};
    7'd110   : now_all_reg_r2 <= pre_all_reg_r | {{110-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-110{1'b0}}};
    7'd111   : now_all_reg_r2 <= pre_all_reg_r | {{111-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-111{1'b0}}};
    7'd112   : now_all_reg_r2 <= pre_all_reg_r | {{112-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-112{1'b0}}};
    7'd113   : now_all_reg_r2 <= pre_all_reg_r | {{113-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-113{1'b0}}};
    7'd114   : now_all_reg_r2 <= pre_all_reg_r | {{114-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-114{1'b0}}};
    7'd115   : now_all_reg_r2 <= pre_all_reg_r | {{115-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-115{1'b0}}};
    7'd116   : now_all_reg_r2 <= pre_all_reg_r | {{116-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-116{1'b0}}};
    7'd117   : now_all_reg_r2 <= pre_all_reg_r | {{117-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-117{1'b0}}};
    7'd118   : now_all_reg_r2 <= pre_all_reg_r | {{118-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-118{1'b0}}};
    7'd119   : now_all_reg_r2 <= pre_all_reg_r | {{119-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-119{1'b0}}};
    7'd120   : now_all_reg_r2 <= pre_all_reg_r | {{120-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-120{1'b0}}};
    7'd121   : now_all_reg_r2 <= pre_all_reg_r | {{121-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-121{1'b0}}};
    7'd122   : now_all_reg_r2 <= pre_all_reg_r | {{122-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-122{1'b0}}};
    7'd123   : now_all_reg_r2 <= pre_all_reg_r | {{123-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-123{1'b0}}};
    7'd124   : now_all_reg_r2 <= pre_all_reg_r | {{124-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-124{1'b0}}};
    7'd125   : now_all_reg_r2 <= pre_all_reg_r | {{125-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-125{1'b0}}};
    7'd126   : now_all_reg_r2 <= pre_all_reg_r | {{126-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-126{1'b0}}};
    7'd127   : now_all_reg_r2 <= pre_all_reg_r | {{127-18{1'b0}},encode_golo_r,{TEMP_WIDTH*2-127{1'b0}}};
    default : now_all_reg_r2 <= 'd0;
  endcase
end else if (low_entpy_valid_r== 1'b1) begin//低熵模式

case (now_len_r2) //低熵编码拼接
    7'd1   : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[0:0],{TEMP_WIDTH*2-1{1'b0}}};
    7'd2   : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[1:0],{TEMP_WIDTH*2-2{1'b0}}};
    7'd3   : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[2:0],{TEMP_WIDTH*2-3{1'b0}}};
    7'd4   : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[3:0],{TEMP_WIDTH*2-4{1'b0}}};
    7'd5   : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[4:0],{TEMP_WIDTH*2-5{1'b0}}};
    7'd6   : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[5:0],{TEMP_WIDTH*2-6{1'b0}}};
    7'd7   : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[6:0],{TEMP_WIDTH*2-7{1'b0}}};
    7'd8   : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[7:0],{TEMP_WIDTH*2-8{1'b0}}};
    7'd9   : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[8:0],{TEMP_WIDTH*2-9{1'b0}}};
    7'd10  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[9:0],{TEMP_WIDTH*2-10{1'b0}}};
    7'd11  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[10:0],{TEMP_WIDTH*2-11{1'b0}}};
    7'd12  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[11:0],{TEMP_WIDTH*2-12{1'b0}}};
    7'd13  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[12:0],{TEMP_WIDTH*2-13{1'b0}}};
    7'd14  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[13:0],{TEMP_WIDTH*2-14{1'b0}}};
    7'd15  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[14:0],{TEMP_WIDTH*2-15{1'b0}}};
    7'd16  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[15:0],{TEMP_WIDTH*2-16{1'b0}}};
    7'd17  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[16:0],{TEMP_WIDTH*2-17{1'b0}}};
    7'd18  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[17:0],{TEMP_WIDTH*2-18{1'b0}}};
    7'd19  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[18:0],{TEMP_WIDTH*2-19{1'b0}}};
    7'd20  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[19:0],{TEMP_WIDTH*2-20{1'b0}}};
    7'd21  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[20:0],{TEMP_WIDTH*2-21{1'b0}}};
    7'd22  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[21:0],{TEMP_WIDTH*2-22{1'b0}}};
    7'd23  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[22:0],{TEMP_WIDTH*2-23{1'b0}}};
    7'd24  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[23:0],{TEMP_WIDTH*2-24{1'b0}}};
    7'd25  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[24:0],{TEMP_WIDTH*2-25{1'b0}}};
    7'd26  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[25:0],{TEMP_WIDTH*2-26{1'b0}}};
    7'd27  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[26:0],{TEMP_WIDTH*2-27{1'b0}}};
    7'd28  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[27:0],{TEMP_WIDTH*2-28{1'b0}}};
    7'd29  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[28:0],{TEMP_WIDTH*2-29{1'b0}}};
    7'd30  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[29:0],{TEMP_WIDTH*2-30{1'b0}}};
    7'd31  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[30:0],{TEMP_WIDTH*2-31{1'b0}}};
    7'd32  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[31:0],{TEMP_WIDTH*2-32{1'b0}}};
    7'd33  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[32:0],{TEMP_WIDTH*2-33{1'b0}}};
    7'd34  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[33:0],{TEMP_WIDTH*2-34{1'b0}}};
    7'd35  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[34:0],{TEMP_WIDTH*2-35{1'b0}}};
    7'd36  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[35:0],{TEMP_WIDTH*2-36{1'b0}}};
    7'd37  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[36:0],{TEMP_WIDTH*2-37{1'b0}}};
    7'd38  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[37:0],{TEMP_WIDTH*2-38{1'b0}}};
    7'd39  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[38:0],{TEMP_WIDTH*2-39{1'b0}}};
    7'd40  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[39:0],{TEMP_WIDTH*2-40{1'b0}}};
    7'd41  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[40:0],{TEMP_WIDTH*2-41{1'b0}}};
    7'd42  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[41:0],{TEMP_WIDTH*2-42{1'b0}}};
    7'd43  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[42:0],{TEMP_WIDTH*2-43{1'b0}}};
    7'd44  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[43:0],{TEMP_WIDTH*2-44{1'b0}}};
    7'd45  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[44:0],{TEMP_WIDTH*2-45{1'b0}}};
    7'd46  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[45:0],{TEMP_WIDTH*2-46{1'b0}}};
    7'd47  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[46:0],{TEMP_WIDTH*2-47{1'b0}}};
    7'd48  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[47:0],{TEMP_WIDTH*2-48{1'b0}}};
    7'd49  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[48:0],{TEMP_WIDTH*2-49{1'b0}}};
    7'd50  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[49:0],{TEMP_WIDTH*2-50{1'b0}}};
    7'd51  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[50:0],{TEMP_WIDTH*2-51{1'b0}}};
    7'd52  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[51:0],{TEMP_WIDTH*2-52{1'b0}}};
    7'd53  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[52:0],{TEMP_WIDTH*2-53{1'b0}}};
    // 7'd54  : now_all_reg_r2 <= pre_all_reg_r | {{54-53{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-54{1'b0}}};
    // 7'd55  : now_all_reg_r2 <= pre_all_reg_r | {{55-53{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-55{1'b0}}};
    7'd54  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[53:0],{TEMP_WIDTH*2-54{1'b0}}};
    7'd55  : now_all_reg_r2 <= pre_all_reg_r | {encode_low_entpy_r[54:0],{TEMP_WIDTH*2-55{1'b0}}};
    7'd56  : now_all_reg_r2 <= pre_all_reg_r | {{56-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-56{1'b0}}};
    7'd57  : now_all_reg_r2 <= pre_all_reg_r | {{57-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-57{1'b0}}};
    7'd58  : now_all_reg_r2 <= pre_all_reg_r | {{58-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-58{1'b0}}};
    7'd59  : now_all_reg_r2 <= pre_all_reg_r | {{59-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-59{1'b0}}};
    7'd60  : now_all_reg_r2 <= pre_all_reg_r | {{60-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-60{1'b0}}};
    7'd61  : now_all_reg_r2 <= pre_all_reg_r | {{61-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-61{1'b0}}};
    7'd62  : now_all_reg_r2 <= pre_all_reg_r | {{62-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-62{1'b0}}};
    7'd63  : now_all_reg_r2 <= pre_all_reg_r | {{63-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-63{1'b0}}};
    7'd64  : now_all_reg_r2 <= pre_all_reg_r | {{64-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-64{1'b0}}};
    7'd65  : now_all_reg_r2 <= pre_all_reg_r | {{65-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-65{1'b0}}};
    7'd66  : now_all_reg_r2 <= pre_all_reg_r | {{66-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-66{1'b0}}};
    7'd67  : now_all_reg_r2 <= pre_all_reg_r | {{67-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-67{1'b0}}};
    7'd68  : now_all_reg_r2 <= pre_all_reg_r | {{68-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-68{1'b0}}};
    7'd69  : now_all_reg_r2 <= pre_all_reg_r | {{69-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-69{1'b0}}};
    7'd70  : now_all_reg_r2 <= pre_all_reg_r | {{70-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-70{1'b0}}};
    7'd71  : now_all_reg_r2 <= pre_all_reg_r | {{71-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-71{1'b0}}};
    7'd72  : now_all_reg_r2 <= pre_all_reg_r | {{72-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-72{1'b0}}};
    7'd73  : now_all_reg_r2 <= pre_all_reg_r | {{73-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-73{1'b0}}};
    7'd74  : now_all_reg_r2 <= pre_all_reg_r | {{74-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-74{1'b0}}};
    7'd75  : now_all_reg_r2 <= pre_all_reg_r | {{75-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-75{1'b0}}};
    7'd76  : now_all_reg_r2 <= pre_all_reg_r | {{76-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-76{1'b0}}};
    7'd77  : now_all_reg_r2 <= pre_all_reg_r | {{77-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-77{1'b0}}};
    7'd78  : now_all_reg_r2 <= pre_all_reg_r | {{78-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-78{1'b0}}};
    7'd79  : now_all_reg_r2 <= pre_all_reg_r | {{79-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-79{1'b0}}};
    7'd80  : now_all_reg_r2 <= pre_all_reg_r | {{80-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-80{1'b0}}};
    7'd81  : now_all_reg_r2 <= pre_all_reg_r | {{81-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-81{1'b0}}};
    7'd82  : now_all_reg_r2 <= pre_all_reg_r | {{82-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-82{1'b0}}};
    7'd83  : now_all_reg_r2 <= pre_all_reg_r | {{83-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-83{1'b0}}};
    7'd84  : now_all_reg_r2 <= pre_all_reg_r | {{84-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-84{1'b0}}};
    7'd85  : now_all_reg_r2 <= pre_all_reg_r | {{85-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-85{1'b0}}};
    7'd86  : now_all_reg_r2 <= pre_all_reg_r | {{86-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-86{1'b0}}};
    7'd87  : now_all_reg_r2 <= pre_all_reg_r | {{87-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-87{1'b0}}};
    7'd88  : now_all_reg_r2 <= pre_all_reg_r | {{88-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-88{1'b0}}};
    7'd89  : now_all_reg_r2 <= pre_all_reg_r | {{89-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-89{1'b0}}};
    7'd90  : now_all_reg_r2 <= pre_all_reg_r | {{90-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-90{1'b0}}};
    7'd91  : now_all_reg_r2 <= pre_all_reg_r | {{91-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-91{1'b0}}};
    7'd92  : now_all_reg_r2 <= pre_all_reg_r | {{92-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-92{1'b0}}};
    7'd93  : now_all_reg_r2 <= pre_all_reg_r | {{93-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-93{1'b0}}};
    7'd94  : now_all_reg_r2 <= pre_all_reg_r | {{94-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-94{1'b0}}};
    7'd95  : now_all_reg_r2 <= pre_all_reg_r | {{95-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-95{1'b0}}};
    7'd96  : now_all_reg_r2 <= pre_all_reg_r | {{96-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-96{1'b0}}};
    7'd97  : now_all_reg_r2 <= pre_all_reg_r | {{97-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-97{1'b0}}};
    7'd98  : now_all_reg_r2 <= pre_all_reg_r | {{98-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-98{1'b0}}};
    7'd99  : now_all_reg_r2 <= pre_all_reg_r | {{99-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-99{1'b0}}};
    7'd100 : now_all_reg_r2 <= pre_all_reg_r | {{100-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-100{1'b0}}};
    7'd101 : now_all_reg_r2 <= pre_all_reg_r | {{101-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-101{1'b0}}};
    7'd102 : now_all_reg_r2 <= pre_all_reg_r | {{102-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-102{1'b0}}};
    7'd103 : now_all_reg_r2 <= pre_all_reg_r | {{103-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-103{1'b0}}};
    7'd104 : now_all_reg_r2 <= pre_all_reg_r | {{104-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-104{1'b0}}};
    7'd105 : now_all_reg_r2 <= pre_all_reg_r | {{105-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-105{1'b0}}};
    7'd106 : now_all_reg_r2 <= pre_all_reg_r | {{106-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-106{1'b0}}};
    7'd107 : now_all_reg_r2 <= pre_all_reg_r | {{107-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-107{1'b0}}};
    7'd108 : now_all_reg_r2 <= pre_all_reg_r | {{108-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-108{1'b0}}};
    7'd109 : now_all_reg_r2 <= pre_all_reg_r | {{109-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-109{1'b0}}};
    7'd110 : now_all_reg_r2 <= pre_all_reg_r | {{110-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-110{1'b0}}};
    7'd111 : now_all_reg_r2 <= pre_all_reg_r | {{111-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-111{1'b0}}};
    7'd112 : now_all_reg_r2 <= pre_all_reg_r | {{112-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-112{1'b0}}};
    7'd113 : now_all_reg_r2 <= pre_all_reg_r | {{113-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-113{1'b0}}};
    7'd114 : now_all_reg_r2 <= pre_all_reg_r | {{114-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-114{1'b0}}};
    7'd115 : now_all_reg_r2 <= pre_all_reg_r | {{115-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-115{1'b0}}};
    7'd116 : now_all_reg_r2 <= pre_all_reg_r | {{116-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-116{1'b0}}};
    7'd117 : now_all_reg_r2 <= pre_all_reg_r | {{117-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-117{1'b0}}};
    7'd118 : now_all_reg_r2 <= pre_all_reg_r | {{118-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-118{1'b0}}};
    7'd119 : now_all_reg_r2 <= pre_all_reg_r | {{119-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-119{1'b0}}};
    7'd120 : now_all_reg_r2 <= pre_all_reg_r | {{120-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-120{1'b0}}};
    7'd121 : now_all_reg_r2 <= pre_all_reg_r | {{121-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-121{1'b0}}};
    7'd122 : now_all_reg_r2 <= pre_all_reg_r | {{122-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-122{1'b0}}};
    7'd123 : now_all_reg_r2 <= pre_all_reg_r | {{123-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-123{1'b0}}};
    7'd124 : now_all_reg_r2 <= pre_all_reg_r | {{124-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-124{1'b0}}};
    7'd125 : now_all_reg_r2 <= pre_all_reg_r | {{125-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-125{1'b0}}};
    7'd126 : now_all_reg_r2 <= pre_all_reg_r | {{126-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-126{1'b0}}};
    7'd127 : now_all_reg_r2 <= pre_all_reg_r | {{127-55{1'b0}},encode_low_entpy_r,{TEMP_WIDTH*2-127{1'b0}}};

    default : now_all_reg_r2 <= 'd0;
endcase
end else begin
    now_all_reg_r2 <= 'd0;
end
end

// always @(posedge clk or negedge rst_n )begin :get_now_all_reg_r2p
//     if(rst_n == 1'b0)begin
//         now_all_reg_r2p <= 'd0;
//     end else begin
//         now_all_reg_r2p <= now_all_reg_r2;
//     end
// end

// always @(posedge clk or negedge rst_n )begin :get_now_all_reg_r2p
    // if(rst_n == 1'b0)begin
        // now_all_reg_r2p <= 'd0;
    // end else if( (golo_valid_r== 1'b1 && index_now_r == 'd15) | (low_entpy_valid_r== 1'b1))begin
        // now_all_reg_r2p <= now_all_reg_r2;
    // end
    // else begin
        // now_all_reg_r2p <= now_all_reg_r2p;
    // end
// end

// always @(now_len_r2,now_all_reg_r2,eob_r2,golo_valid_r,index_now_r,low_entpy_valid_r,now_all_reg_r2p) begin : get_next_all_reg_r2p
  // if(eob_r2 == 1'b1) begin
    // next_all_reg_r2p <= 'd0;
  // end else if(now_len_r2[6] == 1'b1) begin//4.1gai
    // next_all_reg_r2p[TEMP_WIDTH-1:0]            <= 'd0; 
    // if( (golo_valid_r== 1'b1 && index_now_r == 'd15) | (low_entpy_valid_r== 1'b1))
        // next_all_reg_r2p[TEMP_WIDTH*2-1:TEMP_WIDTH] <= now_all_reg_r2[TEMP_WIDTH-1:0];
    // else 
        // next_all_reg_r2p[TEMP_WIDTH*2-1:TEMP_WIDTH] <= now_all_reg_r2p[TEMP_WIDTH-1:0];
  // end else  begin
    // if( (golo_valid_r== 1'b1 && index_now_r == 'd15) | (low_entpy_valid_r== 1'b1))
         // next_all_reg_r2p <= now_all_reg_r2;
     // else 
        // next_all_reg_r2p <= now_all_reg_r2p;
  // end
// end
always @(now_len_r2,now_all_reg_r2,eob_r2) begin : get_next_all_reg_r2p
  if(eob_r2 == 1'b1) begin
    next_all_reg_r2p <= 'd0;
  end else if(now_len_r2[6] == 1'b1) begin//4.1gai
    next_all_reg_r2p[TEMP_WIDTH-1:0]            <= 'd0; 
    next_all_reg_r2p[TEMP_WIDTH*2-1:TEMP_WIDTH] <= now_all_reg_r2[TEMP_WIDTH-1:0];
  end else begin
    next_all_reg_r2p <= now_all_reg_r2;
  end
end
 
//assign w_en_r2p = (now_len_r2[6] & en_r) | eob_r2;

//assign w_en_r2p = ((now_len_r2[6]^en_now_len_r2p&now_len_r2[6]) & en_r) | eob_r2;
always @(now_len_r2,now_len_r2p,en_r,eob_r2) begin
    if((now_len_r2 != now_len_r2p)&&now_len_r2[6])begin
        w_en_r2p <= en_r;
    end else if(eob_r2)begin
        w_en_r2p <= 1'b1;
    end else begin
        w_en_r2p <= 'd0;
    end
end
// always @(byte_cnt_r) begin : get_en_b
    // if(byte_cnt_r == 'd8) begin
      // en_b <= 1'b1;
    // end else begin
      // en_b <= 1'b0;
    // end
// end
/***************************************************************************************/
/**************************************regist2******************************************/
/***************************************************************************************/
always @(posedge clk or negedge rst_n) begin : regist2
  if(rst_n == 1'b0) begin
    next_len_r2pp     <=  'd0;
    next_all_reg_r2pp <=  'd0;
  end else if(en_r == 1'b1 &&((golo_valid_r== 1'b1 && index_now_r == 'd15) | (low_entpy_valid_r== 1'b1))|| eob_r2 == 1'b1) begin
    next_len_r2pp     <= next_len_r2p;
    next_all_reg_r2pp <= next_all_reg_r2p;
  end
end

always @(posedge clk or negedge rst_n) begin : get_data_out_r2
  if(rst_n == 1'b0) begin
    data_out_r2     <=  'd0;
  end else if(en_r == 1'b1) begin
    data_out_r2     <= now_all_reg_r2[TEMP_WIDTH*2-1:TEMP_WIDTH];
  end else if(eob_r2 == 1'b1) begin
    data_out_r2     <= pre_all_reg_r[TEMP_WIDTH*2-1:TEMP_WIDTH];
  end
end

/*always @(posedge clk or negedge rst_n) begin : get_data_out_r3
  if(rst_n == 1'b0) begin
   byte_cnt_r_p         <=  'd0;
    data_out_r3    <=  'd0;
  end else if(en_r2 == 1'b1) begin
    data_out_r3    <= data_out_r2 ;
    byte_cnt_r_p       <=byte_cnt_r ;
  end 
end
*/

/**************************************regist1******************************************/
always @(posedge clk or negedge rst_n) begin: get_x_cnt_r
  if(rst_n == 1'b0) begin
    x_cnt_r <= 'd0;
  end else if(en_r  == 1'b1 && x_lst_rp == 1'b1) begin
    x_cnt_r <= 'd0;
  end else if(en_r  == 1'b1) begin
    x_cnt_r <= x_cnt_r + 1'b1;
  end
end
always @(x_cnt_r) begin : get_x_fst_rp
  if(x_cnt_r == 1'b0) begin
    x_fst_rp <= 1'b1;
  end else begin
    x_fst_rp <= 1'b0;
  end
end
always @(x_cnt_r,Nx_r) begin : get_x_lst_rp
  if(x_cnt_r == Nx_r - 1) begin
    x_lst_rp <= 1'b1;
  end else begin
    x_lst_rp <= 1'b0;
  end
end
always @(posedge clk or negedge rst_n) begin: get_z_cnt_r
  if(rst_n == 1'b0) begin
    z_cnt_r <= 'd0;
  end else if(en_r  == 1'b1 && x_lst_rp == 1'b1 && z_lst_rp == 1'b1) begin
    z_cnt_r <= 'd0;
  end else if(en_r  == 1'b1 && x_lst_rp == 1'b1) begin
    z_cnt_r <= z_cnt_r + 1'b1;
  end
end
always @(z_cnt_r) begin : get_z_fst_rp
  if(z_cnt_r == 'd0) begin
    z_fst_rp <= 1'b1;
  end else begin
    z_fst_rp <= 1'b0;
  end
end
always @(z_cnt_r,Nz_r) begin : get_z_lst_rp
  if(z_cnt_r == Nz_r - 1) begin
    z_lst_rp <= 1'b1;
  end else begin
    z_lst_rp <= 1'b0;
  end
end
always @(posedge clk or negedge rst_n) begin: get_y_cnt_r
  if(rst_n == 1'b0) begin
    y_cnt_r <= 'd0;
  end else if(en_r  == 1'b1 && x_lst_rp == 1'b1 && z_lst_rp == 1'b1 && y_lst_rp == 1'b1) begin
    y_cnt_r <= 'd0;
  end else if(en_r  == 1'b1 && x_lst_rp == 1'b1 && z_lst_rp == 1'b1) begin
    y_cnt_r <= y_cnt_r + 1'b1;
  end
end
always @(y_cnt_r,Ny_r) begin : get_y_lst_rp
  if(y_cnt_r == Ny_r - 1) begin
    y_lst_rp <= 1'b1;
  end else begin
    y_lst_rp <= 1'b0;
  end
end

always @(y_lst_rp,z_fst_rp,x_fst_rp,en_r) begin : get_en_last_spec_rp
    en_last_spec_rp <= y_lst_rp & z_fst_rp & x_fst_rp & en_r;
end

always @(y_lst_rp,z_lst_rp,x_lst_rp,en_r) begin : get_eob_rp
  eob_rp <= y_lst_rp & z_lst_rp & x_lst_rp & en_r;
end

/**************************************regist2******************************************/
/*always @(posedge clk or negedge rst_n) begin : get_eob_r2
  if(rst_n == 1'b0) begin
    eob_r2 <= 1'b0;
    en_last_spec_rpp<= 1'b0;
  end else begin
    eob_r2 <= eob_rp;
    en_last_spec_rpp<= en_last_spec_rp;
  end
end*/

always @(posedge clk or negedge rst_n) begin : get_eob_r3
  if(rst_n == 1'b0) begin
    eob_r2 <= 1'b0;
  end else if(now_len_r2 == 64) begin
    eob_r2 <= 1'b0;
  end else begin
    eob_r2 <= eob_rp;
  end
end

always @(posedge clk or negedge rst_n) begin : get_eob_r4
  if(rst_n == 1'b0) begin
    eob_r3 <= 1'b0;
  end else if(now_len_r2 == 64) begin
    eob_r3 <= eob_rp;
  end else begin
    eob_r3 <= eob_r2;
  end
end
// always @(posedge clk or negedge rst_n) begin : get_eob_r4
  // if(rst_n == 1'b0) begin
    // eob_r4 <= 1'b0;
  // end else begin
    // eob_r4 <= eob_r3;
  // end
// end
always @(eob_r3, eob_r2, byte_cnt_r, now_len_r2) begin : get_byte_cnt_r2
  if(eob_r3 == 1'b1) begin
    byte_cnt_r2 <= 'd0;
  end else if(eob_r2 == 1'b1) begin
    byte_cnt_r2 <= byte_cnt_r + now_len_r2[6:3] + (now_len_r2[0]|now_len_r2[1]|now_len_r2[2]);
  end else begin
    byte_cnt_r2 <= byte_cnt_r + 'd8;
  end
end
always @(posedge clk or negedge rst_n) begin : get_byte_cnt_r
  if(rst_n == 1'b0) begin
    byte_cnt_r <= 'd0;
  end else if(w_en_r2p == 1'b1 || eob_r2 == 1'b1 || eob_r3 == 1'b1) begin
    byte_cnt_r <= byte_cnt_r2;
  end
end
// always @(byte_cnt_r,en_last_spec_rpp) begin : get_up_img_bit_r
    // if(en_last_spec_rpp == 1'b1) begin
        // up_img_bit_r<= byte_cnt_r;
    // end else begin
        // up_img_bit_r <= 'd0;
    // end
// end
// always @(img_bit_r,en_last_spec_rpp) begin : get_up_img_bit_r
    // if(en_last_spec_rpp == 1'b1) begin
        // up_img_bit_r<= img_bit_r+{3'b000,img_bit_r[33:3]};
    // end else begin
        // up_img_bit_r <= 'd0;
    // end
// end
// always @(img_bit_r,en_last_spec_rpp) begin : get_low_img_bit_r
    // if(en_last_spec_rpp == 1'b1) begin
        // low_img_bit_r<= img_bit_r-{3'b000,img_bit_r[33:3]};
    // end else begin
        // low_img_bit_r<= 'd0;
    // end
// end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        up_block_byte_cnt_r<= 'd0;
    end else if(en_last_spec_rp) begin
      /*  case(mode_r)
             3'b000   :  up_block_byte_cnt_r <= byte_cnt_r*12;
             3'b010   :  up_block_byte_cnt_r <= byte_cnt_r*14;
             3'b100   :  up_block_byte_cnt_r <= byte_cnt_r*16;
            default :  up_block_byte_cnt_r <= 'd0;            
        endcase*/
        up_block_byte_cnt_r<= {byte_cnt_r,3'b000};
    end
end
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        low_img_bit_rp<= 'd0;
        up_img_bit_rp <= 'd0;
    end else if(en_r2)begin
        low_img_bit_rp<= low_img_bit_r;
        up_img_bit_rp <= up_img_bit_r;
    end
end
always @(up_img_bit_rp,low_img_bit_rp,up_block_byte_cnt_r) begin:get_up_mode
    if(up_block_byte_cnt_r > up_img_bit_rp)begin//压缩码流比特数大，压缩比小，增大量化步长
        up_mode_r = 3'b001;
    end else if(up_block_byte_cnt_r < low_img_bit_rp)begin//压缩码流比特数小，压缩比大，减小量化步长
        up_mode_r = 3'b010;
    end else begin
        up_mode_r = 3'b000;//量化步长不变
    end
end
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        up_mode_rp<= 'd0;
    end else if(en_last_spec_rpp)begin
        up_mode_rp<= up_mode_r;
    end
end
/*always @(low_block_byte_cnt_r,up_block_byte_cnt_r) begin:get_up_mode
    if(up_block_byte_cnt_r > img_bit_r)
end
always @(byte_cnt_r) begin : get_en_b
    if(byte_cnt_r == 'd8) begin
      en_b <= 1'b1;
    end else begin
      en_b <= 1'b0;
    end
end */
// always @(posedge clk) begin
    // if (w_en_r2pp == 1'b1) begin
        // file_data_out_new = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test6_6/data_out_r2.txt", "a"); 
        // if (file_data_out_new != 0 ) begin
            // $fwrite(file_data_out_new, "%h\n", data_out_r2);
            // $fclose(file_data_out_new);
        // end
    // end
// end

always @(byte_cnt_r) begin : get_en_b
    if(byte_cnt_r == 'd8) begin
      en_b <= 1'b1;
    end else begin
      en_b <= 1'b0;
    end
end

/*always @(posedge clk or negedge rst_n) begin : get_en_b_r
     if(rst_n == 1'b0) begin
      en_b_r <= 1'b0;
    end else begin
      en_b_r <= en_b;
    end
end 
*/

assign data_o = data_out_r2;
assign en_o   = w_en_r2pp;
assign eob_o  = eob_r3;
assign en_b_o = en_b;
assign byte_cnt_o = byte_cnt_r;
// assign en_recpr = en_recpr_r;
assign up_mode_o = up_mode_rp;
assign en_upmode_o = en_last_spec_rppp;
// assign cpr_ratio_o = cpr_ratio_r;
endmodule
