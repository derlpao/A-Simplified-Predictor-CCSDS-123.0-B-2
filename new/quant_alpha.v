module quant_alpha#(
    parameter     DATA_WIDTH = 16,
    parameter     tx_type = 0
)
(
    input  wire                             clk                 ,
    input  wire                             rst_n               ,
                
    input  wire                             en_i                ,
    input  wire [DATA_WIDTH-1:0]            S_i                 ,//16
                
    input  wire [7:0]                       quant_i             ,
    input  wire [DATA_WIDTH-1:0]            alpha_i             ,//16
    input  wire                             sgn_alpha_i         ,
    input  wire [2:0]                       sgn_img_r_i         ,
    input  wire [DATA_WIDTH+1-1:0]          vec_sl_ad_delta_i   ,//17
    
    output wire                             en_o                ,
    output wire [DATA_WIDTH+1-1:0]          alpha_quant_o       ,
    output wire [DATA_WIDTH+1-1:0]          S_o                 , //17 
    output wire [DATA_WIDTH+1-1:0]          cj_S_o 
);
//integer                                 file_alpha_r2p;
//get_en
    reg                                 en_r    ;
    reg                                 en_r2   ;
    reg                                 en_r3   ;
//regist1    
    reg  [DATA_WIDTH-1:0]               S_r             ;
    reg  [7:0]                          quant_r         ;
    reg  [DATA_WIDTH-1:0]               alpha_r         ;  
    reg                                 sgn_alpha_r     ;
    reg  [2:0]                          sgn_img_r       ;
    reg  [DATA_WIDTH+1-1:0]             vec_sl_ad_delta_r;//17
//regist2 
    reg  [DATA_WIDTH-1:0]               alpha_quant;
    reg  [7:0]                          quant_rp             ;
    reg                                 sgn_alpha_rp         ;
    reg  [2:0]                          sgn_img_rp           ;
    reg  [DATA_WIDTH+1-1:0]             vec_sl_ad_delta_rp   ;//17
    reg  [DATA_WIDTH-1:0]               S_r2                 ;
    reg  [DATA_WIDTH+1-1:0]             alpha_div_od_ev      ;//17
//regist3    
    reg   [DATA_WIDTH-1:0]              alpha_cj             ;//16                           
    reg                                 sgn_alpha_rpp        ;
   // reg   [2:0]                         sgn_img_rpp          ;
    reg   [DATA_WIDTH+1-1:0]            vec_sl_ad_delta_rpp  ;//17
    reg   [DATA_WIDTH+1-1:0]            alpha_div_od_ev_r3   ;//17
    reg   [DATA_WIDTH-1:0]              S_r3                 ;
    reg   [DATA_WIDTH+1-1:0]            cj_S_r               ;//17             

always @(posedge clk or negedge rst_n) begin : get_en
  if(rst_n == 1'b0) begin
    en_r  <= 'd0;
    en_r2 <= 'd0;
    en_r3 <= 'd0;
  end else begin
    en_r  <= en_i;
    en_r2 <= en_r;
    en_r3 <= en_r2;
  end
end   

always @(posedge clk or negedge rst_n) begin : regist1
  if(rst_n == 1'b0) begin
    S_r         <= 'd0;
    quant_r     <= 'd0;
    alpha_r     <= 'd0;
    sgn_alpha_r <= 'd0;
    sgn_img_r   <= 'd0;
    vec_sl_ad_delta_r<='d0;
  end else if(en_i == 1'b1)begin
    S_r         <= S_i          ;
    quant_r     <= quant_i      ;
    alpha_r     <= alpha_i      ;
    sgn_alpha_r <= sgn_alpha_i  ;
    sgn_img_r   <= sgn_img_r_i    ;
    vec_sl_ad_delta_r<= vec_sl_ad_delta_i;
  end
end
generate
    if((tx_type==0)||(tx_type==1)||(tx_type==2)||(tx_type==3)||(tx_type==4)) begin //qs

        always @(posedge clk or negedge rst_n) begin : get_alpha_quant
                if(rst_n == 1'b0)begin
                    alpha_quant <= 'd0;
                end else if(en_r) begin
                   // alpha_quant <= (alpha_r+quant_r)/((quant_r<<1)+'d1);
                    case(quant_r)//閲忓寲
                        8'd0   :    alpha_quant <= alpha_r;
                        // 4'd6   :    alpha_quant <= {(alpha_r+quant_n_near_r),{28{1'b0}}}  + {(alpha_r+quant_near_r),{25{1'b0}}}  + {(alpha_r+quant_near_r),{24{1'b0}}} + {(alpha_r+quant_near_r),{23{1'b0}}} + {(alpha_r+quant_near_r),{22{1'b0}}};
                        // 6'd1   :    alpha_quant <= (alpha_r+1)/3;
                        8'd2   :    alpha_quant <= (alpha_r+2)/5;
                        // 6'd3   :    alpha_quant <= (alpha_r+3)/7;
                        8'd4   :    alpha_quant <= (alpha_r+4)/9;
                        // 6'd5   :    alpha_quant <= (alpha_r+5)/11;
                        8'd6   :    alpha_quant <= (alpha_r+6)/13;
                        // 6'd7   :    alpha_quant <= (alpha_r+7)/15;
                        8'd8   :    alpha_quant <= (alpha_r+8)/17;
                        // 6'd9   :    alpha_quant <= (alpha_r+9)/19;
                        8'd10   :    alpha_quant <= (alpha_r+10)/21;
                        // 6'd11   :    alpha_quant <= (alpha_r+11)/23;3;
                        8'd12   :    alpha_quant <= (alpha_r+12)/25;
                        // 6'd13   :    alpha_quant <= (alpha_r+13)/27;7;
                        8'd14   :    alpha_quant <= (alpha_r+14)/29;
                        // 6'd15   :    alpha_quant <= (alpha_r+15)/31;1;
                        8'd16  :    alpha_quant <= (alpha_r+16)/33;
                        // 6'd17  :    alpha_quant <= (alpha_r+17)/35;;
                        8'd18  :    alpha_quant <= (alpha_r+18)/37;
                        // 6'd19  :    alpha_quant <= (alpha_r+19)/39;;
                        8'd20  :    alpha_quant <= (alpha_r+20)/41;
                        // 6'd21  :    alpha_quant <= (alpha_r+21)/43;;
                        8'd22  :    alpha_quant <= (alpha_r+22)/45;
                        // 6'd23  :    alpha_quant <= (alpha_r+23)/47;;
                        8'd24  :    alpha_quant <= (alpha_r+24)/49;
                        // 6'd25  :    alpha_quant <= (alpha_r+25)/51;;
                        8'd26  :    alpha_quant <= (alpha_r+26)/53;
                        // 6'd27  :    alpha_quant <= (alpha_r+27)/55;;
                        8'd28  :    alpha_quant <= (alpha_r+28)/57;
                        // 6'd29  :    alpha_quant <= (alpha_r+29)/59;;
                        8'd30  :    alpha_quant <= (alpha_r+30)/61;
                        // 6'd31  :    alpha_quant <= (alpha_r+31)/63;;
                        8'd32  :    alpha_quant <= (alpha_r+32)/65;
                        8'd34  :    alpha_quant <= (alpha_r+34)/69;
                        8'd36  :    alpha_quant <= (alpha_r+36)/73;
                        8'd38  :    alpha_quant <= (alpha_r+38)/77;
                        8'd40  :    alpha_quant <= (alpha_r+40)/81;
                        8'd42  :    alpha_quant <= (alpha_r+42)/85;
                        8'd44  :    alpha_quant <= (alpha_r+44)/89;
                        8'd46  :    alpha_quant <= (alpha_r+46)/93;
                        8'd48  :    alpha_quant <= (alpha_r+48)/97;
                        8'd50  :    alpha_quant <= (alpha_r+50)/101;
                        8'd52  :    alpha_quant <= (alpha_r+52)/105;
                        8'd54  :    alpha_quant <= (alpha_r+54)/109;
                        8'd56  :    alpha_quant <= (alpha_r+56)/113;
                        8'd58  :    alpha_quant <= (alpha_r+58)/117;
                        8'd60  :    alpha_quant <= (alpha_r+60)/121;
                        8'd62  :    alpha_quant <= (alpha_r+62)/125;
                        8'd64  :    alpha_quant <= (alpha_r+64)/129;
                        8'd255  :    alpha_quant <= (alpha_r+255)/511;
                        default:    alpha_quant <= 'd0;
                    endcase 
                   
                end
            end
    end
    else  begin //kj dbpj db1 db2
        always @(posedge clk or negedge rst_n) begin : get_alpha_quant
            if(rst_n == 1'b0)begin
                alpha_quant <= 'd0;
            end else if(en_r) begin
               // alpha_quant <= (alpha_r+quant_r)/((quant_r<<1)+'d1);
                case(quant_r)//闁插繐瀵²
                    6'd0   :    alpha_quant <= alpha_r;
                    // 4'd6   :    alpha_quant <= {(alpha_r+quant_near_r),{28{1'b0}}}  + {(alpha_r+quant_near_r),{25{1'b0}}}  + {(alpha_r+quant_near_r),{24{1'b0}}} + {(alpha_r+quant_near_r),{23{1'b0}}} + {(alpha_r+quant_near_r),{22{1'b0}}};
                    6'd1   :    alpha_quant <= (alpha_r+1)/3;
                    6'd2   :    alpha_quant <= (alpha_r+2)/5;
                    6'd3   :    alpha_quant <= (alpha_r+3)/7;
                    6'd4   :    alpha_quant <= (alpha_r+4)/9;
                    6'd5   :    alpha_quant <= (alpha_r+5)/11;
                    6'd6   :    alpha_quant <= (alpha_r+6)/13;
                    6'd7   :    alpha_quant <= (alpha_r+7)/15;
                    6'd8   :    alpha_quant <= (alpha_r+8)/17;
                    6'd9   :    alpha_quant <= (alpha_r+9)/19;
                    6'd10   :    alpha_quant <= (alpha_r+10)/21;
                    6'd11   :    alpha_quant <= (alpha_r+11)/23;
                    6'd12   :    alpha_quant <= (alpha_r+12)/25;
                    6'd13   :    alpha_quant <= (alpha_r+13)/27;
                    6'd14   :    alpha_quant <= (alpha_r+14)/29;
                    6'd15   :    alpha_quant <= (alpha_r+15)/31;
                    6'd16  :    alpha_quant <= (alpha_r+16)/33;
                    6'd17  :    alpha_quant <= (alpha_r+17)/35;
                    6'd18  :    alpha_quant <= (alpha_r+18)/37;
                    6'd19  :    alpha_quant <= (alpha_r+19)/39;
                    6'd20  :    alpha_quant <= (alpha_r+20)/41;
                    6'd21  :    alpha_quant <= (alpha_r+21)/43;
                    6'd22  :    alpha_quant <= (alpha_r+22)/45;
                    6'd23  :    alpha_quant <= (alpha_r+23)/47;
                    6'd24  :    alpha_quant <= (alpha_r+24)/49;
                    6'd25  :    alpha_quant <= (alpha_r+25)/51;
                    6'd26  :    alpha_quant <= (alpha_r+26)/53;
                    6'd27  :    alpha_quant <= (alpha_r+27)/55;
                    6'd28  :    alpha_quant <= (alpha_r+28)/57;
                    6'd29  :    alpha_quant <= (alpha_r+29)/59;
                    6'd30  :    alpha_quant <= (alpha_r+30)/61;
                    6'd31  :    alpha_quant <= (alpha_r+31)/63;
                    6'd32  :    alpha_quant <= (alpha_r+32)/65;
                    default:    alpha_quant <= 'd0;
                endcase 
               
            end
        end
        
    end
    
endgenerate

always @(posedge clk or negedge rst_n) begin : regist2
  if(rst_n == 1'b0) begin
    quant_rp     <= 'd0;
    sgn_alpha_rp <= 'd0;
    sgn_img_rp   <= 'd0    ;
    vec_sl_ad_delta_rp<= 'd0;
    S_r2         <= 'd0          ;
  end else if(en_r == 1'b1)begin
    quant_rp            <= quant_r      ;
    sgn_alpha_rp        <= sgn_alpha_r  ;
    sgn_img_rp          <= sgn_img_r    ;
    vec_sl_ad_delta_rp  <= vec_sl_ad_delta_r;
    S_r2                <= S_r          ;
  end
end
always @(alpha_quant,sgn_img_rp) begin : get_sgn_cj_Sr
    case(sgn_img_rp[2])
        1'b0:   alpha_div_od_ev <= {alpha_quant[15:0],1'b0};
        1'b1:   alpha_div_od_ev <= {alpha_quant[15:0],1'b0}-1;
        default : alpha_div_od_ev <= 'd0;
    endcase
end
generate
    if((tx_type==0)||(tx_type==1)||(tx_type==2)||(tx_type==3)||(tx_type==4)) begin
        always @(posedge clk or negedge rst_n) begin : get_alpha_cj
            if(rst_n == 1'b0)begin
                alpha_cj <= 'd0;
            end else if(en_r2) begin
                //alpha_cj <= (alpha_quant)*((quant_rp<<1)+'d1);
                 case(quant_rp) //鍙嶉噺鍖�
                    8'd0   :    alpha_cj <= alpha_quant;
                    // 6'd1   :    alpha_cj <= alpha_quant*3;
                    8'd2   :    alpha_cj <= alpha_quant*5;
                    // 6'd3   :    alpha_cj <= alpha_quant*7;
                    //6'd4   :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-3:0]TH-1-3:0],3'b000}+alpha_quant;
                    8'd4   :    alpha_cj <= alpha_quant*9;
                    // 6'd5   :    alpha_cj <= alpha_quant*11;
                    8'd6   :    alpha_cj <= alpha_quant*13;
                    // 6'd7   :    alpha_cj <= alpha_quant*15;
                    8'd8   :    alpha_cj <= alpha_quant*17;
                    //6'd8   :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-4:0]TH-1-4:0],4'b000}+alpha_quant;
                    // 6'd9   :    alpha_cj <= alpha_quant*19;
                    8'd10   :    alpha_cj <= alpha_quant*21;
                    // 6'd11   :    alpha_cj <= alpha_quant*23;
                    8'd12   :    alpha_cj <= alpha_quant*25;
                    //6'd12   :    alpha_cj <= {alpha_quant[DATA_WIDTH-4-1:0DTH-4-1:0],4'b000}+{alpha_quant[DATA_WIDTH-1-3:0],3'b000}+alpha_quant;
                    // 6'd13   :    alpha_cj <= alpha_quant*27;
                    8'd14   :    alpha_cj <= alpha_quant*29;
                    // 6'd15   :    alpha_cj <= alpha_quant*31;
                    8'd16   :    alpha_cj <= alpha_quant*33;
                    //6'd16   :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-5:0DTH-1-5:0],5'b000}+alpha_quant;
                    // 6'd17   :    alpha_cj <= alpha_quant*35;
                    8'd18   :    alpha_cj <= alpha_quant*37;
                    // 6'd19   :    alpha_cj <= alpha_quant*39;
                    8'd20   :    alpha_cj <= alpha_quant*41;
                    //6'd20   :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-5:0DTH-1-5:0],5'b000}+{alpha_quant[DATA_WIDTH-3-1:0],3'b000}+alpha_quant;
                    // 6'd21   :    alpha_cj <= alpha_quant*43;
                    8'd22  :    alpha_cj <= alpha_quant*45;
                    // 6'd23  :    alpha_cj <= alpha_quant*47;
                    8'd24  :    alpha_cj <= alpha_quant*49;
                    //6'd24  :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-5:0]TH-1-5:0],5'b000}+{alpha_quant[DATA_WIDTH-4-1:0],4'b000}+alpha_quant;
                    // 6'd25  :    alpha_cj <= alpha_quant*51;
                    8'd26  :    alpha_cj <= alpha_quant*53;
                    // 6'd27  :    alpha_cj <= alpha_quant*55;
                    8'd28  :    alpha_cj <= alpha_quant*57;
                    8'd30  :    alpha_cj <= alpha_quant*61;
                    8'd32  :    alpha_cj <= alpha_quant*65;
                    8'd34  :    alpha_cj <= alpha_quant*69;
                    8'd36  :    alpha_cj <= alpha_quant*73;
                    8'd38  :    alpha_cj <= alpha_quant*77;
                    8'd40  :    alpha_cj <= alpha_quant*81;
                    8'd42  :    alpha_cj <= alpha_quant*85;
                    8'd44  :    alpha_cj <= alpha_quant*89;
                    8'd46  :    alpha_cj <= alpha_quant*93;
                    8'd48  :    alpha_cj <= alpha_quant*97;
                    8'd50  :    alpha_cj <= alpha_quant*101;
                    8'd52  :    alpha_cj <= alpha_quant*105;
                    8'd54  :    alpha_cj <= alpha_quant*109;
                    8'd56  :    alpha_cj <= alpha_quant*113;
                    8'd58  :    alpha_cj <= alpha_quant*117;
                    8'd60  :    alpha_cj <= alpha_quant*121;
                    8'd62  :    alpha_cj <= alpha_quant*125;
                    8'd64  :    alpha_cj <= alpha_quant*129;
                    8'd255  :    alpha_cj <= alpha_quant*511;
                    default:    alpha_cj <= 'd0;
                endcase 
            end
        end
    end
    else begin
        always @(posedge clk or negedge rst_n) begin : get_alpha_cj
            if(rst_n == 1'b0)begin
                alpha_cj <= 'd0;
            end else if(en_r2) begin
                //alpha_cj <= (alpha_quant)*((quant_rp<<1)+'d1);
                 case(quant_rp) //閸欏秹鍣洪崠锟½
                    6'd0   :    alpha_cj <= alpha_quant;
                    6'd1   :    alpha_cj <= alpha_quant*3;
                    6'd2   :    alpha_cj <= alpha_quant*5;
                    6'd3   :    alpha_cj <= alpha_quant*7;
                    //6'd4   :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-3:0],3'b000}+alpha_quant;
                    6'd4   :    alpha_cj <= alpha_quant*9;
                    6'd5   :    alpha_cj <= alpha_quant*11;
                    6'd6   :    alpha_cj <= alpha_quant*13;
                    6'd7   :    alpha_cj <= alpha_quant*15;
                    6'd8   :    alpha_cj <= alpha_quant*17;
                    //6'd8   :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-4:0],4'b000}+alpha_quant;
                    6'd9   :    alpha_cj <= alpha_quant*19;
                    6'd10   :    alpha_cj <= alpha_quant*21;
                    6'd11   :    alpha_cj <= alpha_quant*23;
                    6'd12   :    alpha_cj <= alpha_quant*25;
                    //6'd12   :    alpha_cj <= {alpha_quant[DATA_WIDTH-4-1:0],4'b000}+{alpha_quant[DATA_WIDTH-1-3:0],3'b000}+alpha_quant;
                    6'd13   :    alpha_cj <= alpha_quant*27;
                    6'd14   :    alpha_cj <= alpha_quant*29;
                    6'd15   :    alpha_cj <= alpha_quant*31;
                    6'd16   :    alpha_cj <= alpha_quant*33;
                    //6'd16   :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-5:0],5'b000}+alpha_quant;
                    6'd17   :    alpha_cj <= alpha_quant*35;
                    6'd18   :    alpha_cj <= alpha_quant*37;
                    6'd19   :    alpha_cj <= alpha_quant*39;
                    6'd20   :    alpha_cj <= alpha_quant*41;
                    //6'd20   :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-5:0],5'b000}+{alpha_quant[DATA_WIDTH-3-1:0],3'b000}+alpha_quant;
                    6'd21   :    alpha_cj <= alpha_quant*43;
                    6'd22  :    alpha_cj <= alpha_quant*45;
                    6'd23  :    alpha_cj <= alpha_quant*47;
                    6'd24  :    alpha_cj <= alpha_quant*49;
                    //6'd24  :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-5:0],5'b000}+{alpha_quant[DATA_WIDTH-4-1:0],4'b000}+alpha_quant;
                    6'd25  :    alpha_cj <= alpha_quant*51;
                    6'd26  :    alpha_cj <= alpha_quant*53;
                    6'd27  :    alpha_cj <= alpha_quant*55;
                    6'd28  :    alpha_cj <= alpha_quant*57;
                    //6'd28  :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-5:0],5'b000}+{alpha_quant[DATA_WIDTH-4-1:0],4'b000}+{alpha_quant[DATA_WIDTH-3-1:0],3'b000}+alpha_quant;
                    6'd29  :    alpha_cj <= alpha_quant*59;
                    6'd30  :    alpha_cj <= alpha_quant*61;
                    6'd31  :    alpha_cj <= alpha_quant*63;
                    6'd32  :    alpha_cj <= alpha_quant*65;
                    //6'd32  :    alpha_cj <= {alpha_quant[DATA_WIDTH-1-6:0],6'b000}+alpha_quant;
                    default:    alpha_cj <= 'd0;
                endcase 
            end
        end
        
    end
endgenerate

always @(posedge clk or negedge rst_n) begin : regist3
  if(rst_n == 1'b0) begin
    sgn_alpha_rpp       <= 'd0;
    vec_sl_ad_delta_rpp <= 'd0;
    alpha_div_od_ev_r3  <= 'd0;
    S_r3                <= 'd0          ;
  end else if(en_r2 == 1'b1)begin
    sgn_alpha_rpp       <= sgn_alpha_rp;
    vec_sl_ad_delta_rpp <= vec_sl_ad_delta_rp;
    alpha_div_od_ev_r3  <= alpha_div_od_ev;
    S_r3                <= S_r2          ;
  end
end
always @(alpha_cj,sgn_alpha_rpp,vec_sl_ad_delta_rpp) begin : get_cj_S_r
    case(sgn_alpha_rpp)
        1'b0:   cj_S_r <= vec_sl_ad_delta_rpp + alpha_cj;
        1'b1:   cj_S_r <= vec_sl_ad_delta_rpp - alpha_cj;
        default : cj_S_r <= 'd0;
    endcase
end
/*always @(posedge clk) begin
    if (en_r3 == 1'b1) begin
        file_alpha_r2p = $fopen("D:/KEHU_ceshi/KEHU_test/jiemaceshi/ccsds_ceshi000/KEJAIN_GAOSI/alpha_div_od_ev.txt", "a"); 
        if (file_alpha_r2p != 0 ) begin
            $fwrite(file_alpha_r2p, "%05h\n", alpha_div_od_ev_r3);
            $fclose(file_alpha_r2p);
        end
    end
end*/
assign en_o           = en_r3;
assign alpha_quant_o  = alpha_div_od_ev_r3;
assign S_o            = {1'b0,S_r3};
assign cj_S_o         = cj_S_r;
endmodule
