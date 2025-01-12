module top_CCSDS #(
    parameter           X_LEN = 14,
    parameter           Y_LEN = 6,
    parameter           Z_LEN = 8,
    parameter      DATA_WIDTH = 16,
    parameter      tx_type    = 0,
    parameter         D_WIDTH = 16+2+1,//15
    parameter             OHM = 19,
    parameter         W1_INIT = 3*(2**OHM)/4,//393216,//3072,
    parameter         W2_INIT = W1_INIT/4,//768,
    parameter         W3_INIT = W2_INIT/4,//192,
    parameter         W4_INIT = W3_INIT/4,//48,
    parameter         W_WIDTH = OHM+1,//21//12+2+1+16//dn_width+16
    parameter           GOLOMB_ENCODE_DATALENTH = 50,
    parameter           ZERO_NUM_MAN         = 16,
    parameter           CODEBOOK_LENGTH_MAX  = 64,
    parameter           CODE_DATALENGTH      = 21,      
    parameter           ENCODE_DATALENGTH    = CODE_DATALENGTH + ZERO_NUM_MAN + 18,//残差加一位
    parameter	        TOTAL_ENCODE_DATALENTH	    = 64
)
(
    input  wire                     sclk,
    input  wire                     rst_n,

    input  wire [X_LEN-1:0]         X_max,
    input  wire [Z_LEN-1:0]         Z_max,
    input  wire [1:0]               mode,
    input  wire [3:0]               id_ratio,
    output wire                     cmprs_rdf_data_ready,
    input  wire                     cfg_en,
    input  wire                     cmprs_rdf_data_valid,
    input  wire [15:0]              cmprs_rdf_rd_data,
    //ddr 
    // input  wire                     cmprs_fifo_grant,
    // output wire                     cmprs_dout_req,
    // output wire [23:0]              code_cnt,
    // output wire                     cnt_valid_lst,
    // output wire                     cnt_valid_fst,
    // output wire                     encode_data_valid,
    // output wire [255:0]             encode_data,
    // output wire                     cmprs_dout_end
    //axi-s
    input  wire                     encode_data_output_ready,
                                       
    // output wire [23:0]              cmprs_out_code_cnt_out, 
    output wire                     cmprs_out_ccsds_data_valid_out,     
    output wire [63:0]             cmprs_out_ccsds_data_out,   
    output wire [7:0]               cmprs_out_ccsds_keep_out,        
    output wire                     cmprs_out_ccsds_finish_flag_out,
    output wire [2:0]                    cmprs_out_ccsds_dest
    // output wire                     output_cpr_req           
    
    /*
    //for test
    output wire                     error_for_test,
    output wire [31:0]              correct_data_for_test,
    output wire [31:0]              input_data_for_test,
    output wire                     valid_for_test,
    output wire                     ready_for_test*/
);
//recive signal
    // integer                         file_pdt_weight_wdw_crt_out;
    wire     [X_LEN-1:0]            recive_X_MAX_out;
    wire     [Y_LEN-1:0]            recive_Y_MAX_out;
    wire     [Z_LEN-1:0]            recive_Z_MAX_out;
    wire     [2:0]                  recive_mode_out;
    wire     [3:0]                  recive_id_ratio_out;
    wire     [DATA_WIDTH-1:0]       recive_data_out;
    wire                            recive_en_out;
    wire                            recive_rst_n_s_out;
    wire                            recive_rst_n_f_out;
    wire                            recive_rst_f_out;
    wire                            clk;
    wire     [30:0]                 recive_rst_up_img_bit_out;
    wire     [30:0]                 recive_rst_low_img_bit_out;
//cpr_ratio_state
 //   wire     [DATA_WIDTH*2-1:0]     data_quant_o;
//z_rec  out  signal 
    wire     [DATA_WIDTH*2-1:0]     z_rec_data0_out;
    wire                            z_rec_en0_out;
    wire     [DATA_WIDTH*2-1:0]     z_rec_data1_out;
    wire                            z_rec_en1_out;
    wire     [DATA_WIDTH*2-1:0]     z_rec_data2_out;
    wire                            z_rec_en2_out;
    wire     [DATA_WIDTH*2-1:0]     z_rec_data3_out;
    wire                            z_rec_en3_out;
    wire     [DATA_WIDTH*2-1:0]     z_rec_data4_out;
    wire                            z_rec_en4_out;
//pixel_rec out sginal 
    wire     [DATA_WIDTH-1:0]       cj_band0_first;
    wire     [DATA_WIDTH-1:0]       cj_band1_first;
    wire     [DATA_WIDTH-1:0]       cj_band2_first;
    wire     [DATA_WIDTH-1:0]       cj_band3_first;
    wire     [DATA_WIDTH-1:0]       cj_band4_first;
    wire     [4:0]                  pixel0_rec_scan_area_out;
    wire     [3:0]                  pixel0_rec_sl_num_out;
    wire                            pixel0_rec_spec_fst_out;
    wire     [DATA_WIDTH-1:0]       pixel0_rec_S_out;
    wire     [DATA_WIDTH-1:0]       pixel0_rec_Sw_out;
    wire     [DATA_WIDTH-1:0]       pixel0_rec_Sne_out;
    wire     [DATA_WIDTH-1:0]       pixel0_rec_Sn_out;
    wire     [DATA_WIDTH-1:0]       pixel0_rec_Snw_out;
    wire                            pixel0_rec_en_out;
    wire                            pixel0_en_block_cnt_o;
    wire                            pixel0_en_fst_blo_o;

    wire                            delay_spec_fst_en_out;
    wire                            delay_en_block_cnt_out;
    wire                            delay_en_fst_blo_o;
    wire                            delay_spec_fst_out   ;


    wire     [4:0]                  pixel1_rec_scan_area_out;
    wire     [3:0]                  pixel1_rec_sl_num_out;
    wire     [DATA_WIDTH-1:0]       pixel1_rec_S_out;
    wire     [DATA_WIDTH-1:0]       pixel1_rec_Sw_out;
    wire     [DATA_WIDTH-1:0]       pixel1_rec_Sne_out;
    wire     [DATA_WIDTH-1:0]       pixel1_rec_Sn_out;
    wire     [DATA_WIDTH-1:0]       pixel1_rec_Snw_out;
    wire                            pixel1_rec_en_out;

    wire     [4:0]                  pixel2_rec_scan_area_out;
    wire     [3:0]                  pixel2_rec_sl_num_out;
    wire     [DATA_WIDTH-1:0]       pixel2_rec_S_out;
    wire     [DATA_WIDTH-1:0]       pixel2_rec_Sw_out;
    wire     [DATA_WIDTH-1:0]       pixel2_rec_Sne_out;
    wire     [DATA_WIDTH-1:0]       pixel2_rec_Sn_out;
    wire     [DATA_WIDTH-1:0]       pixel2_rec_Snw_out;
    wire                            pixel2_rec_en_out;

    wire     [4:0]                  pixel3_rec_scan_area_out;
    wire     [3:0]                  pixel3_rec_sl_num_out;
    wire     [DATA_WIDTH-1:0]       pixel3_rec_S_out;
    wire     [DATA_WIDTH-1:0]       pixel3_rec_Sw_out;
    wire     [DATA_WIDTH-1:0]       pixel3_rec_Sne_out;
    wire     [DATA_WIDTH-1:0]       pixel3_rec_Sn_out;
    wire     [DATA_WIDTH-1:0]       pixel3_rec_Snw_out;
    wire                            pixel3_rec_en_out;

    wire     [4:0]                  pixel4_rec_scan_area_out;
    wire     [3:0]                  pixel4_rec_sl_num_out;
    wire     [DATA_WIDTH-1:0]       pixel4_rec_S_out;
    wire     [DATA_WIDTH-1:0]       pixel4_rec_Sw_out;
    wire     [DATA_WIDTH-1:0]       pixel4_rec_Sne_out;
    wire     [DATA_WIDTH-1:0]       pixel4_rec_Sn_out;
    wire     [DATA_WIDTH-1:0]       pixel4_rec_Snw_out;
    wire                            pixel4_rec_en_out;

    wire                            cal_dn_delta_en_out;
    reg                             cal_dn_delta_en_out_r;
    wire     [D_WIDTH-1:0]          cal_dn_delta_dn_out;
    wire     [D_WIDTH-1:0]          cal_dn_delta_dw_out;
    wire     [D_WIDTH-1:0]          cal_dn_delta_dnw_out;
//    wire     [D_WIDTH-1:0]          cal_dn_delta_dn_sl_out;
//    wire     [D_WIDTH-1:0]          cal_dn_delta_dw_sl_out;
//    wire     [D_WIDTH-1:0]          cal_dn_delta_dnw_sl_out;
//    wire     [D_WIDTH-1:0]          cal_dn_delta_n_dn_sl_out;
//    wire     [D_WIDTH-1:0]          cal_dn_delta_n_dw_sl_out;
//    wire     [D_WIDTH-1:0]          cal_dn_delta_n_dnw_sl_out;
    wire     [D_WIDTH-1:0]          cal_dn_delta_dn_sl_r_out;
    wire     [D_WIDTH-1:0]          cal_dn_delta_dw_sl_r_out;
    wire     [D_WIDTH-1:0]          cal_dn_delta_dnw_sl_r_out;
    wire     [D_WIDTH-1:0]          cal_dn_delta_n_dn_sl_r_out;
    //wire     [D_WIDTH-1:0]          cal_dn_delta_n_dw_sl_r_out;
    wire     [D_WIDTH-1:0]          cal_dn_delta_n_dnw_sl_r_out;
    //wire     [D_WIDTH-2-1:0]        cal_dn_delta_Sm4_sub_delta_out;
   // wire     [D_WIDTH-2-1:0]        cal_dn_delta_Sm4_sub_delta1_out;
   // wire     [2:0]                  cal_dn_delta_S_med_num_out;
  //  wire     [1:0]                  cal_dn_delta_S_e0_num_out;
   // wire     [D_WIDTH-1:0]          cal_dn_delta_M_sub_delta_out;
   // wire     [D_WIDTH-1:0]          cal_dn_delta_M_sub_delta1_out;
 //   wire     [D_WIDTH-1:0]          cal_dn_delta_n_delta_out;
    wire     [DATA_WIDTH-1:0]       cal_dn_delta_S_out;
    wire     [DATA_WIDTH+2-1:0]     cal_dn_delta_delta_out;
  //  wire     [1:0]                  cal_dn_delta_delta_low2_out;

    wire                            cal_d1_delta_en_out;
    wire     [D_WIDTH-1:0]          cal_d1_delta_d1_out;
//    wire     [D_WIDTH-1:0]          cal_d1_delta_d1_sl_out;
//    wire     [D_WIDTH-1:0]          cal_d1_delta_n_d1_sl_out;
    wire     [D_WIDTH-1:0]          cal_d1_delta_d1_sl_r_out;
    wire     [D_WIDTH-1:0]          cal_d1_delta_n_d1_sl_r_out;

    wire                            cal_d2_delta_en_out;
    wire     [D_WIDTH-1:0]          cal_d2_delta_d2_out;
//    wire     [D_WIDTH-1:0]          cal_d2_delta_d2_sl_out;
//    wire     [D_WIDTH-1:0]          cal_d2_delta_n_d2_sl_out;
    wire     [D_WIDTH-1:0]          cal_d2_delta_d2_sl_r_out;
    wire     [D_WIDTH-1:0]          cal_d2_delta_n_d2_sl_r_out;

    wire                            cal_d3_delta_en_out;
    wire     [D_WIDTH-1:0]          cal_d3_delta_d3_out;
//    wire     [D_WIDTH-1:0]          cal_d3_delta_d3_sl_out;
//    wire     [D_WIDTH-1:0]          cal_d3_delta_n_d3_sl_out;
    wire     [D_WIDTH-1:0]          cal_d3_delta_d3_sl_r_out;
    wire     [D_WIDTH-1:0]          cal_d3_delta_n_d3_sl_r_out;

    wire                            cal_d4_delta_en_out;
    wire     [D_WIDTH-1:0]          cal_d4_delta_d4_out;
//    wire     [D_WIDTH-1:0]          cal_d4_delta_d4_sl_out;
//    wire     [D_WIDTH-1:0]          cal_d4_delta_n_d4_sl_out;
    wire     [D_WIDTH-1:0]          cal_d4_delta_d4_sl_r_out;
    wire     [D_WIDTH-1:0]          cal_d4_delta_n_d4_sl_r_out;
//  recover signal
    wire     [W_WIDTH-1:0]          recover_for_dn_data_out;
    wire                            recover_for_dn_en_out;
    wire     [W_WIDTH-1:0]          recover_for_dw_data_out;
    wire                            recover_for_dw_en_out;
    wire     [W_WIDTH-1:0]          recover_for_dnw_data_out;
    wire                            recover_for_dnw_en_out;
    wire     [W_WIDTH-1:0]          recover_for_d1_data_out;
    wire                            recover_for_d1_en_out;
    wire     [W_WIDTH-1:0]          recover_for_d2_data_out;
    wire                            recover_for_d2_en_out;
    wire     [W_WIDTH-1:0]          recover_for_d3_data_out;
    wire                            recover_for_d3_en_out;
    wire     [W_WIDTH-1:0]          recover_for_d4_data_out;
    wire                            recover_for_d4_en_out;
//  pdt_weight signal 

    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wdn_pdt1_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wdn_pdt2_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wdn_pdt3_out;
    wire                            pdt_weight_wdn_en_out;
    wire     [W_WIDTH-1:0]          pdt_weight_wdn_crt_out;
    wire                            pdt_weight_wdn_crt_en_out;

    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wdw_pdt1_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wdw_pdt2_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wdw_pdt3_out;
    wire                            pdt_weight_wdw_en_out;
    wire     [W_WIDTH-1:0]          pdt_weight_wdw_crt_out;
    wire                            pdt_weight_wdw_crt_en_out;

    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wdnw_pdt1_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wdnw_pdt2_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wdnw_pdt3_out;
    wire                            pdt_weight_wdnw_en_out;
    wire     [W_WIDTH-1:0]          pdt_weight_wdnw_crt_out;
    wire                            pdt_weight_wdnw_crt_en_out;

    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd1_pdt1_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd1_pdt2_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd1_pdt3_out;
    wire                            pdt_weight_wd1_en_out;
    wire     [W_WIDTH-1:0]          pdt_weight_wd1_crt_out;
    wire                            pdt_weight_wd1_crt_en_out;

    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd2_pdt1_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd2_pdt2_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd2_pdt3_out;
    wire                            pdt_weight_wd2_en_out;
    wire     [W_WIDTH-1:0]          pdt_weight_wd2_crt_out;
    wire                            pdt_weight_wd2_crt_en_out;

    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd3_pdt1_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd3_pdt2_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd3_pdt3_out;
    wire                            pdt_weight_wd3_en_out;
    wire     [W_WIDTH-1:0]          pdt_weight_wd3_crt_out;
    wire                            pdt_weight_wd3_crt_en_out;

    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd4_pdt1_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd4_pdt2_out;
    wire     [D_WIDTH+W_WIDTH-1:0]  pdt_weight_wd4_pdt3_out;
    wire                            pdt_weight_wd4_en_out;
    wire     [W_WIDTH-1:0]          pdt_weight_wd4_crt_out;
    wire                            pdt_weight_wd4_crt_en_out;
//add_for_vec signal
    wire                            add_for_vec1_en_out;
    wire    [W_WIDTH+D_WIDTH+3-1:0] add_for_vec1_out;
    wire                            add_for_vec2_en_out;
    wire    [W_WIDTH+D_WIDTH+3-1:0] add_for_vec2_out;
    wire                            add_for_vec3_en_out;
    wire    [W_WIDTH+D_WIDTH+3-1:0] add_for_vec3_out;
//delay1 signal 
    // wire    [D_WIDTH-2-1:0]         delay1_Sm4_sub_delta_out;
    // wire    [D_WIDTH-2-1:0]         delay1_Sm4_sub_delta1_out;
    // wire    [1:0]                   delay1_delta_low2_out;
    // wire    [2:0]                   delay1_S_med_num_out;
    // wire    [1:0]                   delay1_S_e0_num_out;
    // wire    [D_WIDTH-1:0]           delay1_M_sub_delta_out;
    // wire    [D_WIDTH-1:0]           delay1_M_sub_delta1_out;
    // wire    [D_WIDTH-1:0]           delay1_n_delta_out;
    // wire                            delay1_en_out;
//cal_vec signal
    wire                            cal_vec_en_out;
    wire    [2:0]                   cal_vec_num_out;
 //   wire                            cal_vec_uof_out;
//    wire                            cal_vec_dof_out;
//    wire    [W_WIDTH+D_WIDTH+3-OHM-1:0] cal_vec_out;
//delay2 signal
    wire    [DATA_WIDTH+DATA_WIDTH+2-1:0]delay2_out;
    wire    [DATA_WIDTH-1:0]        delay2_delta_S_out;
    wire    [DATA_WIDTH+2-1:0]      delay2_delta_delta_out;
//cal_alpha signal
    wire    [DATA_WIDTH-1:0]        cal_alpha_S_out     ;
    wire    [DATA_WIDTH-1+1:0]        cal_alpha_alpha_out ;
    wire                            cal_alpha_sgn_alpha_out;
    wire                            cal_alpha_en_out    ;
    wire    [7:0]                   quant_near_out      ;
    wire                            cal_cj_en_out       ;
    wire    [DATA_WIDTH+1-1:0]      cal_vec_sl_ad_delta_o;
    wire    [DATA_WIDTH+1-1:0]      cj_S_o;
    
//quant_alpha
    wire                            quant_alpha_en_out    ;
    wire    [DATA_WIDTH+1-1:0]      quant_alpha_quant_out ;
    wire    [DATA_WIDTH+1-1:0]      quant_alpha_S_out     ;
    wire    [DATA_WIDTH+1-1:0]      quant_alpha_cj_S_out  ;
    wire    [2:0]                   cal_alpha_sgn_img_r_out;
//cal_k signal
  //  wire                            cal_k_en_out;
  //  wire    [3:0]                   cal_k_k_out;
//    wire    [DATA_WIDTH+1-1:0]      cal_k_alpha_out;
//golomb signal
    wire    [17:0]                  golomb_data_out;//18位
    wire                            golomb_en_out;
    wire                            golomb_eob_out;
    wire    [30:0]                  golomb_byte_cnt_out;
    wire                            en_begin;
    wire                            en_recpr;
    wire    [3:0]                   cpr_ratio_o;
    wire    [2:0]                   up_mode;
     //integer                         file_d1;  
    //integer                         file_Wd1;
/*******************cal_index***********************/
    wire   [4:0]                    cal_index_real_out       ;   //ç æœ¬ 
    wire   [3:0]                    cal_index_mby_out        ;
    wire   [4:0]                    cal_index_data_max_out   ;      
    wire                            cal_index_chge_spec_out  ;      
    wire                            cal_index_X_out          ;      
    wire                            cal_index_low_entropy_vaild_out;
    wire   [DATA_WIDTH+1-1:0]       cal_index_alpha_output   ; //[16：0]
    wire   [3:0]                    cal_index_k_output       ;
    wire   [6:0]                    golomb_data_len_out      ;
    wire                            cmprs_out_wfifo_ready_out;
    wire   [3:0]                    low_entropy_encode_index_now_out;
    wire                            low_entropy_encode_valid_out;
/*******************encode_proce*******************/
    wire   [7 : 0]                      low_entropy_encode_length_out;                
    wire   [ENCODE_DATALENGTH - 1 : 0]  low_entropu_encode_data_out  ;  
    wire   [TOTAL_ENCODE_DATALENTH-1:0] encode_proce_data_out      ;
    wire                                encode_proce_en_out        ;
    wire   [2:0]                         encode_proce_up_mode_out    ;
    wire                                 encode_proce_en_upmode_out  ;
    wire                                encode_proce_eob_out       ;
    wire   [30:0]                       encode_proce_byte_cnt_out  ;

    wire [63:0]    tx_beat_tdata  ;
    wire [7:0]     tx_beat_tkeep  ;
    wire           tx_beat_tvalid ;
    wire           tx_beat_tlast  ;
    wire           tx_beat_tready ;

    wire [63:0]    tx_bb_tdata    ;
    wire [7:0]     tx_bb_tkeep    ;
    wire           tx_bb_tuser    ;
    wire           tx_bb_tvalid   ;
    wire           tx_bb_tlast    ;
    wire           tx_bb_tready   ;

    wire           m_axis_tlast   ;
    wire           m_axis_tuser   ; 
    
assign delay2_delta_delta_out = delay2_out[DATA_WIDTH+DATA_WIDTH+2-1:DATA_WIDTH];
assign delay2_delta_S_out     = delay2_out[DATA_WIDTH-1:0];
//assign cmprs_out_ccsds_keep_out = 8'hff;
generate
    if(tx_type==0)begin
        assign cmprs_out_ccsds_dest  = 3'h0;
    end
    else if(tx_type==1)begin
        assign cmprs_out_ccsds_dest  = 3'h1;
    end
    else if(tx_type==2)begin
        assign cmprs_out_ccsds_dest  = 3'h2;
    end
    else if(tx_type==3)begin
        assign cmprs_out_ccsds_dest  = 3'h0;
    end
    else if(tx_type==4)begin
        assign cmprs_out_ccsds_dest  = 3'h1;
    end
endgenerate

// cmprs_receive #(
//     .X_LEN                 (X_LEN),
//     .Y_LEN                 (Y_LEN),
//     .Z_LEN                 (Z_LEN),
//     .IN_DATA_WIDTH         (DATA_WIDTH),
//     .OUT_DATA_WIDTH        (DATA_WIDTH)
// )cmprs_receive_inst
// (
//     .sclk                  (sclk),
//     .rst_n                 (rst_n),
//     .X_max                 (X_max),
//     .Z_max                 (Z_max),
//     .mode                  (mode),
//     .id_ratio              (id_ratio),
//     .cmprs_rdf_data_ready  (cmprs_rdf_data_ready),
//     .cfg_en                (cfg_en),
//     .cmprs_rdf_data_valid  (cmprs_rdf_data_valid),
//     .cmprs_rdf_rd_data     (cmprs_rdf_rd_data),
//     .encode_finish_ready    (encode_finish_ready_out),
//     .wfifo_ready           (cmprs_out_wfifo_ready_out),
//     .X_MAX_o               (recive_X_MAX_out),
//     .Y_MAX_o               (recive_Y_MAX_out),
//     .Z_MAX_o               (recive_Z_MAX_out),
//     .mode_o                (recive_mode_out),
//     .id_ratio_o            (recive_id_ratio_out),
//     .data_o                (recive_data_out),
//     .en_o                  (recive_en_out),
//     .rst_n_s_o             (recive_rst_n_s_out),
//     .rst_n_f_o             (recive_rst_n_f_out),
//     .rst_f_o               (recive_rst_f_out),
//     .up_img_bit_o          (recive_rst_up_img_bit_out),
//     .low_img_bit_o         (recive_rst_low_img_bit_out),
 
//     .clk_ccsds             (clk)
// );
cmprs_receive #(
    .X_LEN                 (X_LEN),
    .Y_LEN                 (Y_LEN),
    .Z_LEN                 (Z_LEN),
    .IN_DATA_WIDTH         (DATA_WIDTH),
    .OUT_DATA_WIDTH        (DATA_WIDTH)
 //   .tx_type               (tx_type)
)cmprs_receive_inst
(
    .sclk                  (sclk),
    .rst_n                 (rst_n),
    .X_max                 (X_max),
    .Z_max                 (Z_max),
    .mode                  (mode),
    .id_ratio              (id_ratio),
    .cmprs_rdf_data_ready  (cmprs_rdf_data_ready),
    .cfg_en                (cfg_en),
    .cmprs_rdf_data_valid  (cmprs_rdf_data_valid),
    .cmprs_rdf_rd_data     (cmprs_rdf_rd_data),
    .encode_finish_ready   (encode_finish_ready_out),
    .wfifo_ready           (cmprs_out_wfifo_ready_out),
    .X_MAX_o               (recive_X_MAX_out),
    .Y_MAX_o               (recive_Y_MAX_out),
    .Z_MAX_o               (recive_Z_MAX_out),
    .mode_o                (recive_mode_out),
    .id_ratio_o            (recive_id_ratio_out),
    .data_o                (recive_data_out),
    .en_o                  (recive_en_out),
    .rst_n_s_o             (recive_rst_n_s_out),
    .rst_n_f_o             (recive_rst_n_f_out),
    .rst_f_o               (recive_rst_f_out),
    .up_img_bit_o          (recive_rst_up_img_bit_out),
    .low_img_bit_o         (recive_rst_low_img_bit_out),
 
    .clk_ccsds             (clk)
);
z_rec  #(
    .tx_type       (tx_type),
    .X_LEN         (X_LEN),
    .Z_LEN         (Z_LEN),
    .Y_LEN         (Y_LEN),
    .DATA_WIDTH    (DATA_WIDTH)
)z_rec_inst
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),
    .data_i        (recive_data_out),
    .cj_S_i        (quant_alpha_cj_S_out),//é‡å»ºåƒç´ 
    .en_i          (recive_en_out),
    .en_alpha_i    (quant_alpha_en_out),
    .Nx            (recive_X_MAX_out),
    .Nz            (recive_Z_MAX_out),
    .Ny            (recive_Y_MAX_out),

    .data0_o       (z_rec_data0_out),
    .en0_o         (z_rec_en0_out  ),

    .data1_o       (z_rec_data1_out),
    .en1_o         (z_rec_en1_out  ),

    .data2_o       (z_rec_data2_out),
    .en2_o         (z_rec_en2_out  ),

    .data3_o       (z_rec_data3_out),
    .en3_o         (z_rec_en3_out  ),

    .data4_o       (z_rec_data4_out),
    .en4_o         (z_rec_en4_out  )
);

pixel_rec #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .DATA_WIDTH    (DATA_WIDTH),
    .Z_INI         ('d0)
)pixel_rec_inst0
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),
    .data_i        (z_rec_data0_out),
    .en_i          (z_rec_en0_out),
    .Nx            (recive_X_MAX_out),
    .Ny            (recive_Y_MAX_out),
    .Nz            (recive_Z_MAX_out),

    .scan_area_o   (pixel0_rec_scan_area_out),
    .sl_num_o      (pixel0_rec_sl_num_out),
    .S_o           (pixel0_rec_S_out),
  //  .Sw_o          (pixel0_rec_Sw_out),
    .Sne_o         (pixel0_rec_Sne_out),
    .Sn_o          (pixel0_rec_Sn_out),
    .Snw_o         (pixel0_rec_Snw_out),
    .cj_fst_o      (cj_band0_first),
    .spec_fst_o    (pixel0_rec_spec_fst_out),
    .en_block_cnt_o(pixel0_en_block_cnt_o),
    .en_fst_blo_o  (pixel0_en_fst_blo_o),
    .en_o          (pixel0_rec_en_out)
);
delay_spec_fst #(
    .DATA_WIDTH    (DATA_WIDTH)
)
delay_spec_fst_inst(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),
                 
    .en_i          (pixel0_rec_en_out),
    .spec_fst_i    (pixel0_rec_spec_fst_out),
    .en_block_cnt_i(pixel0_en_block_cnt_o),
    .en_fst_blo_i  (pixel0_en_fst_blo_o),
                  
    .en_o          (delay_spec_fst_en_out),
    .en_block_cnt_o(delay_en_block_cnt_out),
    .en_fst_blo_o  (delay_en_fst_blo_o),
    .spec_fst_o    (delay_spec_fst_out   )

);
pixel_rec #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .DATA_WIDTH    (DATA_WIDTH),
    .Z_INI         ('d1)
)pixel_rec_inst1
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),
    .data_i        (z_rec_data1_out),
    .en_i          (z_rec_en1_out),
    .Nx            (recive_X_MAX_out),
    .Ny            (recive_Y_MAX_out),
    .Nz            (recive_Z_MAX_out),

    .scan_area_o   (pixel1_rec_scan_area_out),
    .sl_num_o      (pixel1_rec_sl_num_out),
    .S_o           (pixel1_rec_S_out),
 //   .Sw_o          (pixel1_rec_Sw_out),
    .Sne_o         (pixel1_rec_Sne_out),
    .Sn_o          (pixel1_rec_Sn_out),
    .Snw_o         (pixel1_rec_Snw_out),
    .cj_fst_o      (cj_band1_first),
    .en_o          (pixel1_rec_en_out)
);
pixel_rec #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .DATA_WIDTH    (DATA_WIDTH),
    .Z_INI         ('d2)
)pixel_rec_inst2
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),
    .data_i        (z_rec_data2_out),
    .en_i          (z_rec_en2_out),
    .Nx            (recive_X_MAX_out),
    .Ny            (recive_Y_MAX_out),
    .Nz            (recive_Z_MAX_out),

    .scan_area_o   (pixel2_rec_scan_area_out),
    .sl_num_o      (pixel2_rec_sl_num_out),
    .S_o           (pixel2_rec_S_out),
  //  .Sw_o          (pixel2_rec_Sw_out),
    .Sne_o         (pixel2_rec_Sne_out),
    .Sn_o          (pixel2_rec_Sn_out),
    .Snw_o         (pixel2_rec_Snw_out),
    .cj_fst_o      (cj_band2_first),
    .en_o          (pixel2_rec_en_out)
);
pixel_rec #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .DATA_WIDTH    (DATA_WIDTH),
    .Z_INI         ('d3)
)pixel_rec_inst3
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),
    .data_i        (z_rec_data3_out),
    .en_i          (z_rec_en3_out),
    .Nx            (recive_X_MAX_out),
    .Ny            (recive_Y_MAX_out),
    .Nz            (recive_Z_MAX_out),

    .scan_area_o   (pixel3_rec_scan_area_out),
    .sl_num_o      (pixel3_rec_sl_num_out),
    .S_o           (pixel3_rec_S_out),
  //  .Sw_o          (pixel3_rec_Sw_out),
    .Sne_o         (pixel3_rec_Sne_out),
    .Sn_o          (pixel3_rec_Sn_out),
    .Snw_o         (pixel3_rec_Snw_out),
    .cj_fst_o      (cj_band3_first),
    .en_o          (pixel3_rec_en_out)
);
pixel_rec #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .DATA_WIDTH    (DATA_WIDTH),
    .Z_INI         ('d4)
)pixel_rec_inst4
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),
    .data_i        (z_rec_data4_out),
    .en_i          (z_rec_en4_out),
    .Nx            (recive_X_MAX_out),
    .Ny            (recive_Y_MAX_out),
    .Nz            (recive_Z_MAX_out),

    .scan_area_o   (pixel4_rec_scan_area_out),
    .sl_num_o      (pixel4_rec_sl_num_out),
    .S_o           (pixel4_rec_S_out),
  //  .Sw_o          (pixel4_rec_Sw_out),
    .Sne_o         (pixel4_rec_Sne_out),
    .Sn_o          (pixel4_rec_Sn_out),
    .Snw_o         (pixel4_rec_Snw_out),
    .cj_fst_o      (cj_band4_first),
    .en_o          (pixel4_rec_en_out)
);

cal_dn_delta #(
    .DATA_WIDTH    (DATA_WIDTH),
    .D_WIDTH       (D_WIDTH)
)cal_dn_delta_inst0
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),

    .sl_num_i      (pixel0_rec_sl_num_out),
    .scan_area_i   (pixel0_rec_scan_area_out),

    .S_i           (pixel0_rec_S_out),
    .Sne_i         (pixel0_rec_Sne_out),
    .Sn_i          (pixel0_rec_Sn_out),
    .Snw_i         (pixel0_rec_Snw_out),
    .en_i          (pixel0_rec_en_out),
    .mode_i        (recive_mode_out),
    .cj_fst_i      (cj_band0_first),

    .en_o          (cal_dn_delta_en_out),
    .dn_o          (cal_dn_delta_dn_out),
    // .dw_o          (cal_dn_delta_dw_out),
    .dnw_o         (cal_dn_delta_dnw_out),
//    .dn_ls_o       (cal_dn_delta_dn_sl_out),
//    .dw_ls_o       (cal_dn_delta_dw_sl_out),
//    .dnw_ls_o      (cal_dn_delta_dnw_sl_out),
//    .n_dn_ls_o     (cal_dn_delta_n_dn_sl_out),
//    .n_dw_ls_o     (cal_dn_delta_n_dw_sl_out),
//    .n_dnw_ls_o    (cal_dn_delta_n_dnw_sl_out),
    .dn_ls_r_o     (cal_dn_delta_dn_sl_r_out),
    // .dw_ls_r_o     (cal_dn_delta_dw_sl_r_out),
    .dnw_ls_r_o    (cal_dn_delta_dnw_sl_r_out),
    .n_dn_ls_r_o   (cal_dn_delta_n_dn_sl_r_out),
    //.n_dw_ls_r_o   (cal_dn_delta_n_dw_sl_r_out),
    .n_dnw_ls_r_o  (cal_dn_delta_n_dnw_sl_r_out),
   // .S_med_num_o   (cal_dn_delta_S_med_num_out),
 //   .S_e0_num_o    (cal_dn_delta_S_e0_num_out),
  //  .M_sub_delta_o (cal_dn_delta_M_sub_delta_out),                         
  //  .M_sub_delta1_o(cal_dn_delta_M_sub_delta1_out),                        
  //  .n_delta_o     (cal_dn_delta_n_delta_out),                             
  //  .Sm4_sub_delta_o(cal_dn_delta_Sm4_sub_delta_out),                      
  //  .Sm4_sub_delta1_o(cal_dn_delta_Sm4_sub_delta1_out),                    
    .S_o           (cal_dn_delta_S_out),
   // .delta_low2_o  (cal_dn_delta_delta_low2_out),
    .delta_o       (cal_dn_delta_delta_out)
);
cal_d_delta #(
    .DATA_WIDTH    (DATA_WIDTH),
    .D_WIDTH       (D_WIDTH)
)cal_d1_delta_inst1
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),

    .sl_num_i      (pixel0_rec_sl_num_out),
    .scan_area_i   (pixel1_rec_scan_area_out),

    .S_i           (pixel1_rec_S_out),
    .Sne_i         (pixel1_rec_Sne_out),
    .Sn_i          (pixel1_rec_Sn_out),
    .Snw_i         (pixel1_rec_Snw_out),
    .en_i          (pixel1_rec_en_out),
    .cj_fst_i      (cj_band1_first),

    .en_o          (cal_d1_delta_en_out),
    .d_o           (cal_d1_delta_d1_out),
//    .d_ls_o        (cal_d1_delta_d1_sl_out),
//    .n_d_ls_o      (cal_d1_delta_n_d1_sl_out),
    .d_ls_r_o      (cal_d1_delta_d1_sl_r_out),
    .n_d_ls_r_o    (cal_d1_delta_n_d1_sl_r_out)
);
/*always @(posedge clk) begin
    if (cal_d1_delta_en_out) begin
        file_d1 = $fopen("D:/KEHU_ceshi/KEHU_test/jiemaceshi/guoke_7_12/duanbo_xince/d1.txt", "a"); // ä½¿ç”¨ "a" æ¨¡å¼ä»¥è¿½åŠ æ–¹å¼æ‰“å¼?æ–‡ä»¶
        
        if (file_d1 != 0) begin
            $fwrite(file_d1, "%19b\n", cal_d1_delta_d1_out);
            
            $fclose(file_d1);
        end
    end
end */
cal_d_delta #(
    .DATA_WIDTH    (DATA_WIDTH),
    .D_WIDTH       (D_WIDTH)
)cal_d2_delta_inst2
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),

    .sl_num_i      (pixel0_rec_sl_num_out),
    .scan_area_i   (pixel2_rec_scan_area_out),

    .S_i           (pixel2_rec_S_out),
    .Sne_i         (pixel2_rec_Sne_out),
    .Sn_i          (pixel2_rec_Sn_out),
    .Snw_i         (pixel2_rec_Snw_out),
    .en_i          (pixel2_rec_en_out),
    .cj_fst_i      (cj_band2_first),

    .en_o          (cal_d2_delta_en_out),
    .d_o           (cal_d2_delta_d2_out),
//    .d_ls_o        (cal_d2_delta_d2_sl_out),
//    .n_d_ls_o      (cal_d2_delta_n_d2_sl_out),
    .d_ls_r_o      (cal_d2_delta_d2_sl_r_out),
    .n_d_ls_r_o    (cal_d2_delta_n_d2_sl_r_out)
);
cal_d_delta #(
    .DATA_WIDTH    (DATA_WIDTH),
    .D_WIDTH       (D_WIDTH)
)cal_d3_delta_inst3
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),

    .sl_num_i      (4'b1000),//>>0
    .scan_area_i   (pixel3_rec_scan_area_out),

    .S_i           (pixel3_rec_S_out),
    .Sne_i         (pixel3_rec_Sne_out),
    .Sn_i          (pixel3_rec_Sn_out),
    .Snw_i         (pixel3_rec_Snw_out),
    .en_i          (pixel3_rec_en_out),
    .cj_fst_i      (cj_band3_first),

    .en_o          (cal_d3_delta_en_out),
    .d_o           (cal_d3_delta_d3_out),
//    .d_ls_o        (cal_d3_delta_d3_sl_out),
//    .n_d_ls_o      (cal_d3_delta_n_d3_sl_out),
    .d_ls_r_o      (cal_d3_delta_d3_sl_r_out),
    .n_d_ls_r_o    (cal_d3_delta_n_d3_sl_r_out)
);
cal_d_delta #(
    .DATA_WIDTH    (DATA_WIDTH),
    .D_WIDTH       (D_WIDTH)
)cal_d4_delta_inst4
(
    .clk           (clk),
    .rst_n         (recive_rst_n_s_out),

    .sl_num_i      (4'b1000),//>>0
    .scan_area_i   (pixel4_rec_scan_area_out),

    .S_i           (pixel4_rec_S_out),
    .Sne_i         (pixel4_rec_Sne_out),
    .Sn_i          (pixel4_rec_Sn_out),
    .Snw_i         (pixel4_rec_Snw_out),
    .en_i          (pixel4_rec_en_out),
    .cj_fst_i      (cj_band4_first),

    .en_o          (cal_d4_delta_en_out),
    .d_o           (cal_d4_delta_d4_out),
//    .d_ls_o        (cal_d4_delta_d4_sl_out),
//    .n_d_ls_o      (cal_d4_delta_n_d4_sl_out),
    .d_ls_r_o      (cal_d4_delta_d4_sl_r_out),
    .n_d_ls_r_o    (cal_d4_delta_n_d4_sl_r_out)
);
recover #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .W_WIDTH       (W_WIDTH),
    .INI_DATA      ('d0),
    .Z_INI         ('d0)
)recover_for_dn
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),

    .Nx             (recive_X_MAX_out),
    .Ny             (recive_Y_MAX_out),
    .Nz             (recive_Z_MAX_out),

    .crt_data_i     (pdt_weight_wdn_crt_out),
    .w_en_i         (pdt_weight_wdn_crt_en_out),

    .recover_data_o (recover_for_dn_data_out),
    .r_en_i         (z_rec_en0_out),
    .recover_en_o   (recover_for_dn_en_out)
);
// recover #(
    // .X_LEN         (X_LEN),
    // .Y_LEN         (Y_LEN),
    // .Z_LEN         (Z_LEN),
    // .W_WIDTH       (W_WIDTH),
    // .INI_DATA      ('d0),
    // .Z_INI         ('d0)
// )recover_for_dw
// (
    // .clk            (clk),
    // .rst_n          (recive_rst_n_s_out),

    // .Nx             (recive_X_MAX_out),
    // .Ny             (recive_Y_MAX_out),
    // .Nz             (recive_Z_MAX_out),

    // .crt_data_i     (pdt_weight_wdw_crt_out),
    // .w_en_i         (pdt_weight_wdw_crt_en_out),

    // .recover_data_o (recover_for_dw_data_out),
    // .r_en_i         (z_rec_en0_out),
    // .recover_en_o   (recover_for_dw_en_out)
// );
recover #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .W_WIDTH       (W_WIDTH),
    .INI_DATA      ('d0),
    .Z_INI         ('d0)
)recover_for_dnw
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),

    .Nx             (recive_X_MAX_out),
    .Ny             (recive_Y_MAX_out),
    .Nz             (recive_Z_MAX_out),

    .crt_data_i     (pdt_weight_wdnw_crt_out),
    .w_en_i         (pdt_weight_wdnw_crt_en_out),

    .recover_data_o (recover_for_dnw_data_out),
    .r_en_i         (z_rec_en0_out),
    .recover_en_o   (recover_for_dnw_en_out)
);
recover #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .W_WIDTH       (W_WIDTH),
    .INI_DATA      (W1_INIT),
    .Z_INI         ('d1)
)recover_for_d1
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),

    .Nx             (recive_X_MAX_out),
    .Ny             (recive_Y_MAX_out),
    .Nz             (recive_Z_MAX_out),

    .crt_data_i     (pdt_weight_wd1_crt_out),
    .w_en_i         (pdt_weight_wd1_crt_en_out),

    .recover_data_o (recover_for_d1_data_out),
    .r_en_i         (z_rec_en1_out),
    .recover_en_o   (recover_for_d1_en_out)
);
recover #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .W_WIDTH       (W_WIDTH),
    .INI_DATA      (W2_INIT),
    .Z_INI         ('d2)
)recover_for_d2
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),

    .Nx             (recive_X_MAX_out),
    .Ny             (recive_Y_MAX_out),
    .Nz             (recive_Z_MAX_out),

    .crt_data_i     (pdt_weight_wd2_crt_out),
    .w_en_i         (pdt_weight_wd2_crt_en_out),

    .recover_data_o (recover_for_d2_data_out),
    .r_en_i         (z_rec_en2_out),
    .recover_en_o   (recover_for_d2_en_out)
);
recover #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .W_WIDTH       (W_WIDTH),
    .INI_DATA      (W3_INIT),
    .Z_INI         ('d3)
)recover_for_d3
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),

    .Nx             (recive_X_MAX_out),
    .Ny             (recive_Y_MAX_out),
    .Nz             (recive_Z_MAX_out),

    .crt_data_i     (pdt_weight_wd3_crt_out),
    .w_en_i         (pdt_weight_wd3_crt_en_out),

    .recover_data_o (recover_for_d3_data_out),
    .r_en_i         (z_rec_en3_out),
    .recover_en_o   (recover_for_d3_en_out)
);
recover #(
    .X_LEN         (X_LEN),
    .Y_LEN         (Y_LEN),
    .Z_LEN         (Z_LEN),
    .W_WIDTH       (W_WIDTH),
    .INI_DATA      (W4_INIT),
    .Z_INI         ('d4)
)recover_for_d4
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),

    .Nx             (recive_X_MAX_out),
    .Ny             (recive_Y_MAX_out),
    .Nz             (recive_Z_MAX_out),

    .crt_data_i     (pdt_weight_wd4_crt_out),
    .w_en_i         (pdt_weight_wd4_crt_en_out),

    .recover_data_o (recover_for_d4_data_out),
    .r_en_i         (z_rec_en4_out),
    .recover_en_o   (recover_for_d4_en_out)
);
pdt_weight #(
    .W_WIDTH        (W_WIDTH),
    .D_WIDTH        (D_WIDTH)
)pdt_weight_for_dn
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),
    .dn_i           (cal_dn_delta_dn_out),
//    .dn_sl_i        (cal_dn_delta_dn_sl_out),
//    .n_dn_sl_i      (cal_dn_delta_n_dn_sl_out),
    .dn_sl_r_i      (cal_dn_delta_dn_sl_r_out),
    .n_dn_sl_r_i    (cal_dn_delta_n_dn_sl_r_out),
    .dn_en_i        (cal_dn_delta_en_out),
    .vec_num_i      (cal_vec_num_out),

    .recover_data_i (recover_for_dn_data_out),
    .recover_en_i   (recover_for_dn_en_out),

    .dw_pdt1_o      (pdt_weight_wdn_pdt1_out),
    .dw_pdt2_o      (pdt_weight_wdn_pdt2_out),
    .dw_pdt3_o      (pdt_weight_wdn_pdt3_out),
    .dw_en_o        (pdt_weight_wdn_en_out),
    .weight_crt_o   (pdt_weight_wdn_crt_out),
    .crt_en_o       (pdt_weight_wdn_crt_en_out)
);
/*always @(posedge clk) begin
    if (pdt_weight_wdn_crt_en_out) begin
        file_Wdn = $fopen("D:/ccsds/CCSDS_narrow/narrow_test_5_16/test5_19/Wdn.txt", "a"); // ä½¿ç”¨ "a" æ¨¡å¼ä»¥è¿½åŠ æ–¹å¼æ‰“å¼?æ–‡ä»¶
        
        if (file_Wdn != 0) begin
            $fwrite(file_Wdn, "%20b\n", pdt_weight_wdn_crt_out);
            
            $fclose(file_Wdn);
        end
    end
end */
// pdt_weight #(
    // .W_WIDTH        (W_WIDTH),
    // .D_WIDTH        (D_WIDTH)
// )pdt_weight_for_dw
// (
    // .clk            (clk),
    // .rst_n          (recive_rst_n_s_out),
    // .dn_i           (cal_dn_delta_dw_out),

    // .dn_sl_r_i      (cal_dn_delta_dw_sl_r_out),
    // .n_dn_sl_r_i    (cal_dn_delta_n_dw_sl_r_out),
    // .dn_en_i        (cal_dn_delta_en_out),
    // .vec_num_i      (cal_vec_num_out),

    // .recover_data_i (recover_for_dw_data_out),
    // .recover_en_i   (recover_for_dw_en_out),

    // .dw_pdt1_o      (pdt_weight_wdw_pdt1_out),
    // .dw_pdt2_o      (pdt_weight_wdw_pdt2_out),
    // .dw_pdt3_o      (pdt_weight_wdw_pdt3_out),
    // .dw_en_o        (pdt_weight_wdw_en_out),
    // .weight_crt_o   (pdt_weight_wdw_crt_out),
    // .crt_en_o       (pdt_weight_wdw_crt_en_out)
// );
// always @(posedge clk) begin
    // if (pdt_weight_wdw_crt_en_out == 1'b1) begin
        // file_pdt_weight_wdw_crt_out = $fopen("D:/ccsds/ccsds/testdata/for_multiple_data_modezp/mydata60P160x32/data1/test/test3.31/pdt_weight_wdw_crt_out.txt", "a"); 
        // if (file_pdt_weight_wdw_crt_out != 0 ) begin
            // $fwrite(file_pdt_weight_wdw_crt_out, "%20b\n", pdt_weight_wdw_crt_out);
            // $fclose(file_pdt_weight_wdw_crt_out);
        // end
    // end
// end
pdt_weight #(
    .W_WIDTH        (W_WIDTH),
    .D_WIDTH        (D_WIDTH)
)pdt_weight_for_dnw
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),
    .dn_i           (cal_dn_delta_dnw_out),
 //   .dn_sl_i        (cal_dn_delta_dnw_sl_out),
 //   .n_dn_sl_i      (cal_dn_delta_n_dnw_sl_out),
    .dn_sl_r_i      (cal_dn_delta_dnw_sl_r_out),
    .n_dn_sl_r_i    (cal_dn_delta_n_dnw_sl_r_out),
    .dn_en_i        (cal_dn_delta_en_out),
    .vec_num_i      (cal_vec_num_out),

    .recover_data_i (recover_for_dnw_data_out),
    .recover_en_i   (recover_for_dnw_en_out),

    .dw_pdt1_o      (pdt_weight_wdnw_pdt1_out),
    .dw_pdt2_o      (pdt_weight_wdnw_pdt2_out),
    .dw_pdt3_o      (pdt_weight_wdnw_pdt3_out),
    .dw_en_o        (pdt_weight_wdnw_en_out),
    .weight_crt_o   (pdt_weight_wdnw_crt_out),
    .crt_en_o       (pdt_weight_wdnw_crt_en_out)
);
pdt_weight #(
    .W_WIDTH        (W_WIDTH),
    .D_WIDTH        (D_WIDTH)
)pdt_weight_for_d1
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),
    .dn_i           (cal_d1_delta_d1_out),
 //   .dn_sl_i        (cal_d1_delta_d1_sl_out),
 //   .n_dn_sl_i      (cal_d1_delta_n_d1_sl_out),
    .dn_sl_r_i      (cal_d1_delta_d1_sl_r_out),
    .n_dn_sl_r_i    (cal_d1_delta_n_d1_sl_r_out),
    .dn_en_i        (cal_d1_delta_en_out),
    .vec_num_i      (cal_vec_num_out),

    .recover_data_i (recover_for_d1_data_out),
    .recover_en_i   (recover_for_d1_en_out),

    .dw_pdt1_o      (pdt_weight_wd1_pdt1_out),
    .dw_pdt2_o      (pdt_weight_wd1_pdt2_out),
    .dw_pdt3_o      (pdt_weight_wd1_pdt3_out),
    .dw_en_o        (pdt_weight_wd1_en_out),
    .weight_crt_o   (pdt_weight_wd1_crt_out),
    .crt_en_o       (pdt_weight_wd1_crt_en_out)
);

/*always @(posedge clk) begin
    if (pdt_weight_wd1_crt_en_out) begin
        file_Wd1 = $fopen("D:/KEHU_ceshi/KEHU_test/jiemaceshi/guoke_7_12/duanbo_xince/Wd1.txt", "a"); // ä½¿ç”¨ "a" æ¨¡å¼ä»¥è¿½åŠ æ–¹å¼æ‰“å¼?æ–‡ä»¶
        
        if (file_Wd1 != 0) begin
            $fwrite(file_Wd1, "%20b\n", pdt_weight_wd1_crt_out);
            
            $fclose(file_Wd1);
        end
    end
end*/ 


pdt_weight #(
    .W_WIDTH        (W_WIDTH),
    .D_WIDTH        (D_WIDTH)
)pdt_weight_for_d2
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),
    .dn_i           (cal_d2_delta_d2_out),
 //   .dn_sl_i        (cal_d2_delta_d2_sl_out),
 //   .n_dn_sl_i      (cal_d2_delta_n_d2_sl_out),
    .dn_sl_r_i      (cal_d2_delta_d2_sl_r_out),
    .n_dn_sl_r_i    (cal_d2_delta_n_d2_sl_r_out),
    .dn_en_i        (cal_d2_delta_en_out),
    .vec_num_i      (cal_vec_num_out),

    .recover_data_i (recover_for_d2_data_out),
    .recover_en_i   (recover_for_d2_en_out),

    .dw_pdt1_o      (pdt_weight_wd2_pdt1_out),
    .dw_pdt2_o      (pdt_weight_wd2_pdt2_out),
    .dw_pdt3_o      (pdt_weight_wd2_pdt3_out),
    .dw_en_o        (pdt_weight_wd2_en_out),
    .weight_crt_o   (pdt_weight_wd2_crt_out),
    .crt_en_o       (pdt_weight_wd2_crt_en_out)
);
pdt_weight #(
    .W_WIDTH        (W_WIDTH),
    .D_WIDTH        (D_WIDTH)
)pdt_weight_for_d3
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),
    .dn_i           (cal_d3_delta_d3_out),
 //   .dn_sl_i        (cal_d3_delta_d3_sl_out),
 //   .n_dn_sl_i      (cal_d3_delta_n_d3_sl_out),
    .dn_sl_r_i      (cal_d3_delta_d3_sl_r_out),
    .n_dn_sl_r_i    (cal_d3_delta_n_d3_sl_r_out),
    .dn_en_i        (cal_d3_delta_en_out),
    .vec_num_i      (cal_vec_num_out),

    .recover_data_i (recover_for_d3_data_out),
    .recover_en_i   (recover_for_d3_en_out),

    .dw_pdt1_o      (pdt_weight_wd3_pdt1_out),
    .dw_pdt2_o      (pdt_weight_wd3_pdt2_out),
    .dw_pdt3_o      (pdt_weight_wd3_pdt3_out),
    .dw_en_o        (pdt_weight_wd3_en_out),
    .weight_crt_o   (pdt_weight_wd3_crt_out),
    .crt_en_o       (pdt_weight_wd3_crt_en_out)
);
pdt_weight #(
    .W_WIDTH        (W_WIDTH),
    .D_WIDTH        (D_WIDTH)
)pdt_weight_for_d4
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),
    .dn_i           (cal_d4_delta_d4_out),
 //   .dn_sl_i        (cal_d4_delta_d4_sl_out),
 //   .n_dn_sl_i      (cal_d4_delta_n_d4_sl_out),
    .dn_sl_r_i      (cal_d4_delta_d4_sl_r_out),
    .n_dn_sl_r_i    (cal_d4_delta_n_d4_sl_r_out),
    .dn_en_i        (cal_d4_delta_en_out),
    .vec_num_i      (cal_vec_num_out),

    .recover_data_i (recover_for_d4_data_out),
    .recover_en_i   (recover_for_d4_en_out),

    .dw_pdt1_o      (pdt_weight_wd4_pdt1_out),
    .dw_pdt2_o      (pdt_weight_wd4_pdt2_out),
    .dw_pdt3_o      (pdt_weight_wd4_pdt3_out),
    .dw_en_o        (pdt_weight_wd4_en_out),
    .weight_crt_o   (pdt_weight_wd4_crt_out),
    .crt_en_o       (pdt_weight_wd4_crt_en_out)
);
add_for_vec #(
    .W_WIDTH        (W_WIDTH),
    .D_WIDTH        (D_WIDTH)
)add_for_vec1
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),

    .dw_en          (cal_dn_delta_en_out),
    .dw1            (pdt_weight_wdn_pdt1_out),
    // .dw2            (pdt_weight_wdw_pdt1_out),
    .dw3            (pdt_weight_wdnw_pdt1_out),
    .dw4            (pdt_weight_wd1_pdt1_out),
    .dw5            (pdt_weight_wd2_pdt1_out),
    .dw6            (pdt_weight_wd3_pdt1_out),
    .dw7            (pdt_weight_wd4_pdt1_out),

    .vec_en         (add_for_vec1_en_out),
    .vec            (add_for_vec1_out)
);
add_for_vec #(
    .W_WIDTH        (W_WIDTH),
    .D_WIDTH        (D_WIDTH)
)add_for_vec2
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),

    .dw_en          (cal_dn_delta_en_out),
    .dw1            (pdt_weight_wdn_pdt2_out),
    // .dw2            (pdt_weight_wdw_pdt2_out),
    .dw3            (pdt_weight_wdnw_pdt2_out),
    .dw4            (pdt_weight_wd1_pdt2_out),
    .dw5            (pdt_weight_wd2_pdt2_out),
    .dw6            (pdt_weight_wd3_pdt2_out),
    .dw7            (pdt_weight_wd4_pdt2_out),

    .vec_en         (add_for_vec2_en_out),
    .vec            (add_for_vec2_out)
);
add_for_vec #(
    .W_WIDTH        (W_WIDTH),
    .D_WIDTH        (D_WIDTH)
)add_for_vec3
(
    .clk            (clk),
    .rst_n          (recive_rst_n_s_out),

    .dw_en          (cal_dn_delta_en_out),
    .dw1            (pdt_weight_wdn_pdt3_out),
    // .dw2            (pdt_weight_wdw_pdt3_out),
    .dw3            (pdt_weight_wdnw_pdt3_out),
    .dw4            (pdt_weight_wd1_pdt3_out),
    .dw5            (pdt_weight_wd2_pdt3_out),
    .dw6            (pdt_weight_wd3_pdt3_out),
    .dw7            (pdt_weight_wd4_pdt3_out),

    .vec_en         (add_for_vec3_en_out),
    .vec            (add_for_vec3_out)
);
// delay1 #(
    // .D_WIDTH        (D_WIDTH)
// )delay1_for_Sm4_sub_delta
// (
    // .clk            (clk),
    // .rst_n          (recive_rst_n_s_out),

    // .Sm4_sub_delta_i(cal_dn_delta_Sm4_sub_delta_out),
    // .Sm4_sub_delta1_i(cal_dn_delta_Sm4_sub_delta1_out),
    // .delta_low2_i   (cal_dn_delta_delta_low2_out),
    // .S_med_num_i    (cal_dn_delta_S_med_num_out),
    // .S_e0_num_i     (cal_dn_delta_S_e0_num_out),
    // .M_sub_delta_i  (cal_dn_delta_M_sub_delta_out),
    // .M_sub_delta1_i (cal_dn_delta_M_sub_delta1_out),
    // .n_delta_i      (cal_dn_delta_n_delta_out),
    // .en_i           (cal_dn_delta_en_out),

    // .Sm4_sub_delta_o(delay1_Sm4_sub_delta_out),
    // .Sm4_sub_delta1_o(delay1_Sm4_sub_delta1_out),
    // .delta_low2_o   (delay1_delta_low2_out),
    // .S_med_num_o    (delay1_S_med_num_out),
    // .S_e0_num_o     (delay1_S_e0_num_out),
    // .M_sub_delta_o  (delay1_M_sub_delta_out),
    // .M_sub_delta1_o (delay1_M_sub_delta1_out),
    // .n_delta_o      (delay1_n_delta_out),
    // .en_o           (delay1_en_out)
// );
// cal_vec #(
    // .W_WIDTH        (W_WIDTH),
    // .D_WIDTH        (D_WIDTH),
    // .OHM            (OHM)
// )cal_vec_inst
// (
    // .clk            (clk),
    // .rst_n          (recive_rst_n_s_out),

    // .vec1_i         (add_for_vec1_out),
    // .vec2_i         (add_for_vec2_out),
    // .vec3_i         (add_for_vec3_out),
    // .Sm4_sub_delta_i(delay1_Sm4_sub_delta_out),
    // .Sm4_sub_delta1_i(delay1_Sm4_sub_delta1_out),
    // .delta_low2_i   (delay1_delta_low2_out),
    // .S_med_num_i    (delay1_S_med_num_out),
    // .S_e0_num_i     (delay1_S_e0_num_out),
    // .M_sub_delta_i  (delay1_M_sub_delta_out),
    // .M_sub_delta1_i (delay1_M_sub_delta1_out),
    // .n_delta_i      (delay1_n_delta_out),
    // .en_i           (delay1_en_out),

    // .en_o           (cal_vec_en_out),
    // .vec_num_o      (cal_vec_num_out),
    // .uof_o          (cal_vec_uof_out),
    // .dof_o          (cal_vec_dof_out),
    // .vec_o          (cal_vec_out)
// );
delay2 #(
  .DATA_WIDH        (DATA_WIDTH+DATA_WIDTH+2)
)delay2_for_alpha_inst
(
  .clk              (clk),
  .rst_n            (recive_rst_n_s_out),

  .en_i             (cal_dn_delta_en_out),
  .data_i           ({cal_dn_delta_delta_out,cal_dn_delta_S_out}),

  .en_o             (),
  .data_o           (delay2_out)
);
always @(posedge clk or negedge rst_n) begin :get_cal_dn_delta_en_out_r
    if(rst_n == 1'b0)begin
        cal_dn_delta_en_out_r <= 'd0;
    end else begin
        cal_dn_delta_en_out_r <= cal_dn_delta_en_out;
    end
end
cal_alpha #(
    .W_WIDTH        (W_WIDTH   ),
    .D_WIDTH        (D_WIDTH   ),
    .DATA_WIDTH     (DATA_WIDTH),
    .OHM            (OHM       ),
    .tx_type        (tx_type)
)cal_alpha_inst
(
  .clk              (clk),
  .rst_n            (recive_rst_n_s_out),
  
  .mode_i           (recive_mode_out),
  
  .en_i             (cal_dn_delta_en_out_r),
  
  // .vec_crt_sl_ohm_i (cal_vec_out),
  .S_i              (delay2_delta_S_out),
  .delta_i          (delay2_delta_delta_out),
  .up_mode_i         (encode_proce_up_mode_out)      ,
  .en_upmode_i       (encode_proce_en_upmode_out)    ,
  .en_block_cnt_i   (delay_en_block_cnt_out),
  .en_fst_blo_i     (delay_en_fst_blo_o),
  .id_ratio_i       (recive_id_ratio_out),
  /////////////////5_18zp////////////
  .vec1_i           (add_for_vec1_out),
  .vec2_i           (add_for_vec2_out),
  .vec3_i           (add_for_vec3_out),
  .spec_fst_i       (delay_spec_fst_out),

  .S_o              (cal_alpha_S_out),
  .quant_near_o     (quant_near_out),
  .alpha_o          (cal_alpha_alpha_out),
  .sgn_alpha_o      (cal_alpha_sgn_alpha_out),
  .sgn_img_o        (cal_vec_num_out),
  .sgn_img_r_o      (cal_alpha_sgn_img_r_out),
  .vec_sl_ad_delta_o(cal_vec_sl_ad_delta_o),
  //.cj_S_o           (cj_S_o),
  .en_o             (cal_alpha_en_out),
  .en_cj_o          (cal_cj_en_out)
);
quant_alpha #(
    .DATA_WIDTH     (DATA_WIDTH),
    .tx_type        (tx_type)
)quant_alpha_inst
(
  .clk                (clk) ,
  .rst_n              (recive_rst_n_s_out) ,
                         
  .en_i               (cal_cj_en_out) ,
  .S_i                (cal_alpha_S_out) ,
                         
  .quant_i            (quant_near_out) ,
  .alpha_i            (cal_alpha_alpha_out) ,
  .sgn_alpha_i        (cal_alpha_sgn_alpha_out) ,
  .sgn_img_r_i        (cal_alpha_sgn_img_r_out) ,
  .vec_sl_ad_delta_i  (cal_vec_sl_ad_delta_o) ,
                         
  .en_o               (quant_alpha_en_out       ) ,
  .alpha_quant_o      (quant_alpha_quant_out    ) ,
  .S_o                (quant_alpha_S_out        ) ,
  .cj_S_o             (quant_alpha_cj_S_out     )

);

cal_index #(
    .X_LEN      (X_LEN),
    .Y_LEN      (Y_LEN),
    .Z_LEN      (Z_LEN),
    .DATA_WIDTH (DATA_WIDTH)
)
cal_index_inst(
    .clk          (clk                   ),
    .rst_n        (recive_rst_n_s_out                 ),
                                          
    .Nx           (recive_X_MAX_out                  ),
    .Ny           (recive_Y_MAX_out                  ),
    .Nz           (recive_Z_MAX_out                  ),
    .S_i          (quant_alpha_S_out                 ),
    .alpha_i      (quant_alpha_quant_out              ),
    // .AP_empty_i   (low_entropy_AP_empty_out              ),
    .en_i         (quant_alpha_en_out                  ),
                                    
    .en_o         (cal_index_en_output   ),
    .k_o          (cal_index_k_output    ),
    .alpha_o      (cal_index_alpha_output),
    /**************entropy*******************/
    // .index_real_o       (cal_index_real_out              ),
    // .index_data_max_o   (cal_index_data_max_out          ),
    .en_last_o        (cal_index_chge_spec_out         ),
    // .en_x_o             (cal_index_X_out                 ),
    // .low_entropy_vaild_o(cal_index_low_entropy_vaild_out )
    .index_mby_o   (cal_index_mby_out)
    // .alpha_delta_o (cal_index_detla_out)
);
encode_top #(
    .ZERO_NUM_MAN        (ZERO_NUM_MAN       ),
    .CODEBOOK_LENGTH_MAX (CODEBOOK_LENGTH_MAX),
    .CODE_DATALENGTH     (CODE_DATALENGTH    ),
    .ENCODE_DATALENGTH   (ENCODE_DATALENGTH  )

)
encode_top_inst(
    .clk_i           	      (clk)                           ,
    .rst_i           	      (~recive_rst_n_s_out)            ,
                                                              
    .en_i                     (cal_index_en_output)           ,
    .index_i                  (cal_index_mby_out)             ,
    .delta_i                  (cal_index_alpha_output)  ,
    .last_i                   (cal_index_chge_spec_out)       ,
    
    .index_now_o              (low_entropy_encode_index_now_out),
    .encode_match_o           (low_entropy_encode_valid_out  ),
    .encode_match_length_o    (low_entropy_encode_length_out ),
    .encode_match_data_o      (low_entropu_encode_data_out)

);

golomb_encode #(
    .X_LEN      (X_LEN     ),
    .Y_LEN      (Y_LEN     ),
    .Z_LEN      (Z_LEN     ),
    .WIDTH      (DATA_WIDTH)
)
golomb_encode_inst(
    .clk           (clk                         ),
    .rst_n         (rst_n                       ),
                                                
    .k_i           (cal_index_k_output          ),
    .data_i        (cal_index_alpha_output),
    .golomb_valid_i(cal_index_en_output         ),
    .en_i          (cal_index_en_output         ),
    .mode_i        (recive_mode_out                       ),
    .id_ratio_i    (recive_id_ratio_out                   ),
        
    .en_o          (golomb_en_out               ),
    .encode_data_o (golomb_data_out             ),
    .encode_len_o  (golomb_data_len_out         ),
    .golomb_valid_o(golomb_en_out               ) 
);
encode_proce #(
    .X_LEN                     (X_LEN     ),
    .Y_LEN                     (Y_LEN     ),
    .Z_LEN                     (Z_LEN     ),
    .WIDTH                     (DATA_WIDTH),
                               
    .GOLOMB_ENCODE_DATALENTH   (GOLOMB_ENCODE_DATALENTH         ),
    .TOTAL_ENCODE_DATALENTH	   (TOTAL_ENCODE_DATALENTH          ),
    .ZERO_NUM_MAN              (ZERO_NUM_MAN                    ),
    .CODE_DATALENGTH           (CODE_DATALENGTH                 ),
    .ENTROPY_ENCODE_DATALENGTH (ENCODE_DATALENGTH               )

)
encode_proce_inst(                                    
    .clk               (clk  )                        ,
    .rst_n             (rst_n)                        ,
    .en_i              (golomb_en_out)                ,
    
    //.img_bit_i         (recive_rst_img_bit_out)       , 
    .up_img_bit_i          (recive_rst_up_img_bit_out),
    .low_img_bit_i         (recive_rst_low_img_bit_out),   
    .Nx_i              (recive_X_MAX_out)             ,
    .Ny_i              (recive_Y_MAX_out)             ,
    .Nz_i              (recive_Z_MAX_out)             ,
    .mode_i            (recive_mode_out)              ,  
                                      
    .encode_golo_i     (golomb_data_out)              ,
    .golo_valid_i      (golomb_en_out)                ,
    .golo_len_i        (golomb_data_len_out)          ,
        
    .index_now_i       (low_entropy_encode_index_now_out) ,       
    .encode_low_entpy_i(low_entropu_encode_data_out   ),//low_entropu_encode_data_out   
    .low_entpy_valid_i (low_entropy_encode_valid_out  ), //low_entropy_encode_valid_out  
    .low_entpy_len_i   (low_entropy_encode_length_out ),  //low_entropy_encode_length_out 
                                                     
    .data_o            (encode_proce_data_out       )  ,
    .en_o              (encode_proce_en_out         )  ,
    .eob_o             (encode_proce_eob_out        )  ,
    .up_mode_o         (encode_proce_up_mode_out)      ,
    .en_upmode_o       (encode_proce_en_upmode_out)    ,
    .byte_cnt_o        (encode_proce_byte_cnt_out   )  ,
    .en_b_o            (en_begin)

);
// cmprs_out cmprs_out_inst(
//   .clk_ccsds            (clk),
//   .sclk                 (sclk),
//   .rst_n_s              (recive_rst_n_s_out),
//   .rst_n_f              (recive_rst_n_f_out),
//   // sscds write
//   .w_en                 (encode_proce_en_out),
//   .w_data               (encode_proce_data_out),
//   .eob                  (encode_proce_eob_out),
//   .en_b_i               (en_begin),
//   .byte_cnt             (encode_proce_byte_cnt_out),
//   .quant_near_i          (quant_near_out),

//   .wfifo_ready          (cmprs_out_wfifo_ready_out),
//    .encode_finish_ready  (encode_finish_ready_out),

//   // out control
//   // .code_cnt             (cmprs_out_code_cnt_out             ),
//   .encode_data_ready    (encode_data_output_ready),
//   .encode_data_valid    (cmprs_out_ccsds_data_valid_out     ),
//   .encode_data          (cmprs_out_ccsds_data_out           ),
//   .encode_finish_flag   (cmprs_out_ccsds_finish_flag_out    )
//   // .output_cpr_req       (output_cpr_req)
// );



cmps_out_new cmps_out_new_inst(
  .clk                 (clk),
  .rst                 (~recive_rst_n_s_out),
  // sscds write
  .w_en                 (encode_proce_en_out),
  .w_data               (encode_proce_data_out),
  .eob                  (encode_proce_eob_out),
  .byte_cnt             (encode_proce_byte_cnt_out),
  .quant_near_i          (quant_near_out),

  .wfifo_ready          (cmprs_out_wfifo_ready_out),
  .encode_finish_ready  (encode_finish_ready_out),

  // out control
  // .code_cnt             (cmprs_out_code_cnt_out             ),
  .xc_tready         (tx_beat_tready),
  .xc_tvalid         (tx_beat_tvalid     ),
  .xc_tdata          (tx_beat_tdata           ),
  .xc_tlast          (tx_beat_tlast    )
  // .output_cpr_req       (output_cpr_req)
);


assign tx_beat_tkeep = 8'hff;
breakup_packet_v3_1 breakup_packet_v3_1_inst (
    .clk            (clk),
    .rstn           (recive_rst_n_s_out),
   
    .byte_limit     (32'd2048),
    .pkt_gap        (32'd10),
  
    .tx_beat_tdata  (tx_beat_tdata),
    .tx_beat_tkeep  (tx_beat_tkeep),
    .tx_beat_tvalid (tx_beat_tvalid),
    .tx_beat_tlast  (tx_beat_tlast),
    .tx_beat_tready (tx_beat_tready),
    .tx_bb_tdata    (tx_bb_tdata),
    .tx_bb_tkeep    (tx_bb_tkeep),
    .tx_bb_tuser    (tx_bb_tuser),
    .tx_bb_tvalid   (tx_bb_tvalid),
    .tx_bb_tlast    (tx_bb_tlast),
    .tx_bb_tready   (tx_bb_tready)
  );

axis_data_fifo_block axis_data_fifo_block_inst (
  .s_axis_aresetn(recive_rst_n_s_out),  // input wire s_axis_aresetn
  .s_axis_aclk(clk),        // input wire s_axis_aclk
  .s_axis_tvalid(tx_bb_tvalid),    // input wire s_axis_tvalid
  .s_axis_tready(tx_bb_tready),    // output wire s_axis_tready
  .s_axis_tdata(tx_bb_tdata),      // input wire [63 : 0] s_axis_tdata
  .s_axis_tkeep(tx_bb_tkeep),      // input wire [7 : 0] s_axis_tkeep
  .s_axis_tlast(tx_bb_tlast),      // input wire s_axis_tlast
  .s_axis_tuser(tx_bb_tuser),      // input wire [0 : 0] s_axis_tuser
  .m_axis_tvalid(cmprs_out_ccsds_data_valid_out),    // output wire m_axis_tvalid
  .m_axis_tready(encode_data_output_ready),    // input wire m_axis_tready
  .m_axis_tdata(cmprs_out_ccsds_data_out),      // output wire [63 : 0] m_axis_tdata
  .m_axis_tkeep(cmprs_out_ccsds_keep_out),      // output wire [7 : 0] m_axis_tkeep
  .m_axis_tlast(m_axis_tlast),      // output wire m_axis_tlast
  .m_axis_tuser(m_axis_tuser)      // output wire [0 : 0] m_axis_tuser
);
assign cmprs_out_ccsds_finish_flag_out = m_axis_tlast & m_axis_tuser;
// conversion_out conversion_out_inst( 
  // .clk                  (sclk),
  // .rst_n                (recive_rst_n_f_out),
  // .rst                  (recive_rst_f_out),

  // ccsds interface
  // .ccsds_code_cnt       (cmprs_out_code_cnt_out),
  // .ccsds_data_ready     (conversion_out_ccsds_data_ready_out),
  // .ccsds_data_valid     (cmprs_out_ccsds_data_valid_out ),
  // .ccsds_data           (cmprs_out_ccsds_data_out),
  // .ccsds_finish_flag    (cmprs_out_ccsds_finish_flag_out),

  // ddr interface
  // .cmprs_fifo_grant     (cmprs_fifo_grant ),
  // .cmprs_dout_req       (cmprs_dout_req   ),
  // .code_cnt             (code_cnt         ),
  // .cnt_valid_lst        (cnt_valid_lst    ),
  // .cnt_valid_fst        (cnt_valid_fst    ),
  // .encode_data_valid    (encode_data_valid),
  // .encode_data          (encode_data      ),
  // .cmprs_dout_end       (cmprs_dout_end   )
// );

endmodule