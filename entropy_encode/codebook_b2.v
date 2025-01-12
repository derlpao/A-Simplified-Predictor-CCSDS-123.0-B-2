`timescale 1ns/1ps

module codebook_b2#(
    parameter                                       CODEBOOK_LENGTH_MAX = 64,
    parameter                                       ENCODE_DATALENGTH   = 21
)(
    //input wire                                    codebook_select_i   ,
    input   wire    [5 : 0]                         ap_cnt_i            ,
    input   wire    [CODEBOOK_LENGTH_MAX - 1 : 0]   ap_data_i           ,

    output  wire                                    encode_match_o      ,
    output  wire    [5 : 0]                         encode_length_o     ,
    output  wire    [ENCODE_DATALENGTH - 1 : 0]     encode_data_o
);

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b2_r    ;
reg     [5 : 0]                         encode_length_b2_r  ;
reg                                     encode_match_b2_r   ;

assign encode_data_o    = encode_data_b2_r      ;
assign encode_length_o  = encode_length_b2_r    ;
assign encode_match_o   = encode_match_b2_r     ;

/**************************************************************************/
//codebook_b2 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h0,'h3,'h4,'h7,'h8,'hF : encode_match_b2_r = 1'd1;
                default : encode_match_b2_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h10,'h22,'h50,'h15,'h16,'h25,'h26,'h51,'h52,'h60,
                'h61,'h62,'h17,'h27,'h53,'h54,'h63,'h64,'h18,'h1F,
                'h28,'h2F,'h55,'h56,'h65,'h66,'h57,'h58,'h5F,'h67,
                'h68,'h6F : encode_match_b2_r = 1'd1;
                default : encode_match_b2_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h200,'h110,'h111,'h112,'h201,'h202,'h120,'h121,'h122,
                'h210,'h211,'h212,'h130,'h242,'h113,'h114,'h203,'h204,
                'h123,'h124,'h213,'h214,'h131,'h132,'h230,'h231,'h232,
                'h140,'h141,'h142,'h240,'h241,'h243,'h244,'h115,'h116,
                'h205,'h206,'h125,'h126,'h215,'h216,'h133,'h134,'h233,
                'h234,'h143,'h144,'h245,'h246,'h135,'h136,'h235,'h236,
                'h145,'h146,'h117,'h118,'h11F,'h207,'h208,'h20F,'h127,
                'h128,'h12F,'h217,'h218,'h21F,'h148,'h14F,'h247,'h248,
                'h24F,'h137,'h138,'h13F,'h237,'h238,'h23F,'h147 : encode_match_b2_r = 1'd1;
                default : encode_match_b2_r = 1'd0;
            endcase
        end
        default : encode_match_b2_r = 1'd0;
    endcase
end

//codebook_b2 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h0 :           encode_length_b2_r = 2;
                'h3,'h4 :       encode_length_b2_r = 3;
                'h7,'h8,'hF :   encode_length_b2_r = 6;
                default : encode_length_b2_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h10 :                                              encode_length_b2_r = 4;
                'h22 :                                              encode_length_b2_r = 5;
                'h50 :                                              encode_length_b2_r = 6;
                'h15,'h16,'h25,'h26,'h51,'h52,'h60,'h61,'h62 :      encode_length_b2_r = 7;
                'h17,'h27,'h53,'h54,'h63,'h64 :                     encode_length_b2_r = 8;
                'h18,'h1F,'h28,'h2F,'h55,'h56,'h65,'h66 :           encode_length_b2_r = 9;
                'h57,'h58,'h5F,'h67,'h68,'h6F :                     encode_length_b2_r = 11;
                default : encode_length_b2_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h200 :                                             encode_length_b2_r = 6;
                'h110,'h111,'h112,'h201,'h202,'h120,'h121,'h122,
                'h210,'h211,'h212,'h130 :                           encode_length_b2_r = 7;
                'h242,'h113,'h114,'h203,'h204,'h123,'h124,'h213,
                'h214,'h131,'h132,'h230,'h231,'h232,'h140,'h141,
                'h142,'h240,'h241 :                                 encode_length_b2_r = 8;
                'h243,'h244,'h115,'h116,'h205,'h206,'h125,'h126,
                'h215,'h216,'h133,'h134,'h233,'h234,'h143,'h144 :   encode_length_b2_r = 9;
                'h245,'h246,'h135,'h136,'h235,'h236,'h145,'h146 :   encode_length_b2_r = 10;
                'h117,'h118,'h11F,'h207,'h208,'h20F,'h127,'h128,
                'h12F,'h217,'h218,'h21F :                           encode_length_b2_r = 11;
                'h148,'h14F,'h247,'h248,'h24F,'h137,'h138,'h13F,
                'h237,'h238,'h23F,'h147 :                           encode_length_b2_r = 12;
                default : encode_length_b2_r = 0;
            endcase
        end
        default : encode_length_b2_r = 0;
    endcase
end

//codebook_b2 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h0 : encode_data_b2_r = 'b00    ;
                'h3 : encode_data_b2_r = 'b010   ;
                'h4 : encode_data_b2_r = 'b011   ;
                'h7 : encode_data_b2_r = 'b100110;
                'h8 : encode_data_b2_r = 'b100111;
                'hF : encode_data_b2_r = 'b101000;                
                default : encode_data_b2_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h10 : encode_data_b2_r = 'b1000        ;
                'h22 : encode_data_b2_r = 'b10010       ;
                'h50 : encode_data_b2_r = 'b101001      ;
                'h15 : encode_data_b2_r = 'b1010110     ;
                'h16 : encode_data_b2_r = 'b1010111     ;
                'h25 : encode_data_b2_r = 'b1011000     ;
                'h26 : encode_data_b2_r = 'b1011001     ;
                'h51 : encode_data_b2_r = 'b1011010     ;
                'h52 : encode_data_b2_r = 'b1011011     ;
                'h60 : encode_data_b2_r = 'b1011100     ;
                'h61 : encode_data_b2_r = 'b1011101     ;
                'h62 : encode_data_b2_r = 'b1011110     ;
                'h17 : encode_data_b2_r = 'b11010110    ;
                'h27 : encode_data_b2_r = 'b11010111    ;
                'h53 : encode_data_b2_r = 'b11011000    ;
                'h54 : encode_data_b2_r = 'b11011001    ;
                'h63 : encode_data_b2_r = 'b11011010    ;
                'h64 : encode_data_b2_r = 'b11011011    ;
                'h18 : encode_data_b2_r = 'b111011110   ;
                'h1F : encode_data_b2_r = 'b111011111   ;
                'h28 : encode_data_b2_r = 'b111100000   ;
                'h2F : encode_data_b2_r = 'b111100001   ;
                'h55 : encode_data_b2_r = 'b111100010   ;
                'h56 : encode_data_b2_r = 'b111100011   ;
                'h65 : encode_data_b2_r = 'b111100100   ;
                'h66 : encode_data_b2_r = 'b111100101   ;
                'h57 : encode_data_b2_r = 'b11111101000 ;
                'h58 : encode_data_b2_r = 'b11111101001 ;
                'h5F : encode_data_b2_r = 'b11111101010 ;
                'h67 : encode_data_b2_r = 'b11111101011 ;
                'h68 : encode_data_b2_r = 'b11111101100 ;
                'h6F : encode_data_b2_r = 'b11111101101 ;
                default : encode_data_b2_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h200 : encode_data_b2_r = 'b101010        ;
                'h110 : encode_data_b2_r = 'b1011111       ;
                'h111 : encode_data_b2_r = 'b1100000       ;
                'h112 : encode_data_b2_r = 'b1100001       ;
                'h201 : encode_data_b2_r = 'b1100110       ;
                'h202 : encode_data_b2_r = 'b1100111       ;
                'h120 : encode_data_b2_r = 'b1100010       ;
                'h121 : encode_data_b2_r = 'b1100011       ;
                'h122 : encode_data_b2_r = 'b1100100       ;
                'h210 : encode_data_b2_r = 'b1101000       ;
                'h211 : encode_data_b2_r = 'b1101001       ;
                'h212 : encode_data_b2_r = 'b1101010       ;
                'h130 : encode_data_b2_r = 'b1100101       ;
                'h242 : encode_data_b2_r = 'b11101110      ;
                'h113 : encode_data_b2_r = 'b11011100      ;
                'h114 : encode_data_b2_r = 'b11011101      ;
                'h203 : encode_data_b2_r = 'b11100101      ;
                'h204 : encode_data_b2_r = 'b11100110      ;
                'h123 : encode_data_b2_r = 'b11011110      ;
                'h124 : encode_data_b2_r = 'b11011111      ;
                'h213 : encode_data_b2_r = 'b11100111      ;
                'h214 : encode_data_b2_r = 'b11101000      ;
                'h131 : encode_data_b2_r = 'b11100000      ;
                'h132 : encode_data_b2_r = 'b11100001      ;
                'h230 : encode_data_b2_r = 'b11101001      ;
                'h231 : encode_data_b2_r = 'b11101010      ;
                'h232 : encode_data_b2_r = 'b11101011      ;
                'h140 : encode_data_b2_r = 'b11100010      ;
                'h141 : encode_data_b2_r = 'b11100011      ;
                'h142 : encode_data_b2_r = 'b11100100      ;
                'h240 : encode_data_b2_r = 'b11101100      ;
                'h241 : encode_data_b2_r = 'b11101101      ;
                'h243 : encode_data_b2_r = 'b111110100     ;
                'h244 : encode_data_b2_r = 'b111110101     ;
                'h115 : encode_data_b2_r = 'b111100110     ;
                'h116 : encode_data_b2_r = 'b111100111     ;
                'h205 : encode_data_b2_r = 'b111101110     ;
                'h206 : encode_data_b2_r = 'b111101111     ;
                'h125 : encode_data_b2_r = 'b111101000     ;
                'h126 : encode_data_b2_r = 'b111101001     ;
                'h215 : encode_data_b2_r = 'b111110000     ;
                'h216 : encode_data_b2_r = 'b111110001     ;
                'h133 : encode_data_b2_r = 'b111101010     ;
                'h134 : encode_data_b2_r = 'b111101011     ;
                'h233 : encode_data_b2_r = 'b111110010     ;
                'h234 : encode_data_b2_r = 'b111110011     ;
                'h143 : encode_data_b2_r = 'b111101100     ;
                'h144 : encode_data_b2_r = 'b111101101     ;
                'h245 : encode_data_b2_r = 'b1111110010    ;
                'h246 : encode_data_b2_r = 'b1111110011    ;
                'h135 : encode_data_b2_r = 'b1111101100    ;
                'h136 : encode_data_b2_r = 'b1111101101    ;
                'h235 : encode_data_b2_r = 'b1111110000    ;
                'h236 : encode_data_b2_r = 'b1111110001    ;
                'h145 : encode_data_b2_r = 'b1111101110    ;
                'h146 : encode_data_b2_r = 'b1111101111    ;
                'h117 : encode_data_b2_r = 'b11111101110   ;
                'h118 : encode_data_b2_r = 'b11111101111   ;
                'h11F : encode_data_b2_r = 'b11111110000   ;
                'h207 : encode_data_b2_r = 'b11111110100   ;
                'h208 : encode_data_b2_r = 'b11111110101   ;
                'h20F : encode_data_b2_r = 'b11111110110   ;
                'h127 : encode_data_b2_r = 'b11111110001   ;
                'h128 : encode_data_b2_r = 'b11111110010   ;
                'h12F : encode_data_b2_r = 'b11111110011   ;
                'h217 : encode_data_b2_r = 'b11111110111   ;
                'h218 : encode_data_b2_r = 'b11111111000   ;
                'h21F : encode_data_b2_r = 'b11111111001   ;
                'h148 : encode_data_b2_r = 'b111111111000  ;
                'h14F : encode_data_b2_r = 'b111111111001  ;
                'h247 : encode_data_b2_r = 'b111111111101  ;
                'h248 : encode_data_b2_r = 'b111111111110  ;
                'h24F : encode_data_b2_r = 'b111111111111  ;
                'h137 : encode_data_b2_r = 'b111111110100  ;
                'h138 : encode_data_b2_r = 'b111111110101  ;
                'h13F : encode_data_b2_r = 'b111111110110  ;
                'h237 : encode_data_b2_r = 'b111111111010  ;
                'h238 : encode_data_b2_r = 'b111111111011  ;
                'h23F : encode_data_b2_r = 'b111111111100  ;
                'h147 : encode_data_b2_r = 'b111111110111  ;
                default : encode_data_b2_r = 'b0;
            endcase
        end
        default : encode_data_b2_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
