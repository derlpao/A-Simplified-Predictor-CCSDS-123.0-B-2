`timescale 1ns/1ps

module codebook_b4#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b4_r    ;
reg     [5 : 0]                         encode_length_b4_r  ;
reg                                     encode_match_b4_r   ;

assign encode_data_o    = encode_data_b4_r      ;
assign encode_length_o  = encode_length_b4_r    ;
assign encode_match_o   = encode_match_b4_r     ;

/**************************************************************************/
//codebook_b4 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1,'h2,'h3,'h4,'h5,'h6,'hF : encode_match_b4_r = 1'd1;
                default : encode_match_b4_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h05, 'h06, 'h0F : encode_match_b4_r = 1'd1;
                default : encode_match_b4_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h000,'h002,'h020,'h030,'h003,'h004,'h040,
                'h024,'h031,'h032,'h013,'h014,'h041,'h042,
                'h023,'h033,'h005,'h025,'h034,'h015,'h016,
                'h006,'h00F,'h043,'h044,'h026,'h02F,'h01F,
                'h035,'h036,'h045,'h03F,'h046,'h04F : encode_match_b4_r = 1'd1;
                default : encode_match_b4_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h0010,'h0100,'h0120,'h0011,'h0012,'h0210,'h0101,
                'h0102,'h0220,'h0110,'h0121,'h0122,'h0211,'h0212,
                'h0221,'h0111,'h0222,'h0112,'h0013,'h0014,'h0103,
                'h0104,'h0123,'h0124,'h0213,'h0214,'h0223,'h0113,
                'h0224,'h0114,'h0125,'h0015,'h0016,'h001F,'h0215,
                'h0105,'h0106,'h010F,'h0115,'h0126,'h012F,'h0216,
                'h021F,'h0225,'h0226,'h0116,'h022F,'h011F : encode_match_b4_r = 1'd1;
                default : encode_match_b4_r = 1'd0;
            endcase
        end
        default : encode_match_b4_r = 1'd0;
    endcase
end

//codebook_b4 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1, 'h2 : encode_length_b4_r = 2;
                'h3, 'h4 : encode_length_b4_r = 4;
                'h5, 'h6 : encode_length_b4_r = 7;
                'hF : encode_length_b4_r = 8;

                default : encode_length_b4_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h05, 'h06 : encode_length_b4_r = 8;
                'h0F : encode_length_b4_r = 9;
                default : encode_length_b4_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h000 : encode_length_b4_r = 4;
                'h002, 'h020 : encode_length_b4_r = 5;
                'h030, 'h003, 'h004, 'h040 : encode_length_b4_r = 7;
                'h024, 'h031, 'h032, 'h013, 'h014, 'h041, 'h042, 'h023 : encode_length_b4_r = 8;
                'h033, 'h005 : encode_length_b4_r =      9;
                'h025, 'h034, 'h015, 'h016, 'h006, 'h00F, 'h043, 'h044 : encode_length_b4_r = 10;
                'h026, 'h02F, 'h01F : encode_length_b4_r = 11;
                'h035, 'h036, 'h045 : encode_length_b4_r = 12;
                'h03F, 'h046, 'h04F : encode_length_b4_r = 13;                
                default : encode_length_b4_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0010, 'h0100 : encode_length_b4_r =      6;
                'h0120, 'h0011, 'h0012, 'h0210, 'h0101, 'h0102, 'h0220, 'h0110 : encode_length_b4_r = 7;
                'h0121, 'h0122, 'h0211, 'h0212, 'h0221, 'h0111, 'h0222, 'h0112 : encode_length_b4_r = 8;
                'h0013, 'h0014, 'h0103, 'h0104 : encode_length_b4_r =      9;
                'h0123, 'h0124, 'h0213, 'h0214, 'h0223, 'h0113, 'h0224, 'h0114 : encode_length_b4_r = 10;
                'h0125, 'h0015, 'h0016, 'h001F, 'h0215, 'h0105, 'h0106, 'h010F, 'h0115 : encode_length_b4_r = 12;
                'h0126, 'h012F, 'h0216, 'h021F, 'h0225, 'h0226, 'h0116, 'h022F, 'h011F : encode_length_b4_r = 13;                
                default : encode_length_b4_r = 0;
            endcase
        end
        default : encode_length_b4_r = 0;
    endcase
end

//codebook_b4 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1 : encode_data_b4_r = 'b00              ;
                'h2 : encode_data_b4_r = 'b01              ;
                'h3 : encode_data_b4_r = 'b1000            ;
                'h4 : encode_data_b4_r = 'b1001            ;
                'h5 : encode_data_b4_r = 'b1100100         ;
                'h6 : encode_data_b4_r = 'b1100101         ;
                'hF : encode_data_b4_r = 'b11100100        ;
                default : encode_data_b4_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h05 : encode_data_b4_r = 'b11100101       ;
                'h06 : encode_data_b4_r = 'b11100110       ;
                'h0F : encode_data_b4_r = 'b111101110      ;                
                default : encode_data_b4_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h000 : encode_data_b4_r = 'b1010              ;     
                'h002 : encode_data_b4_r = 'b10110             ;     
                'h020 : encode_data_b4_r = 'b10111             ;     
                'h030 : encode_data_b4_r = 'b1101000           ;     
                'h003 : encode_data_b4_r = 'b1100110           ;     
                'h004 : encode_data_b4_r = 'b1100111           ;     
                'h040 : encode_data_b4_r = 'b1101001           ;     
                'h024 : encode_data_b4_r = 'b11101010          ;     
                'h031 : encode_data_b4_r = 'b11101011          ;     
                'h032 : encode_data_b4_r = 'b11101100          ;     
                'h013 : encode_data_b4_r = 'b11100111          ;     
                'h014 : encode_data_b4_r = 'b11101000          ;     
                'h041 : encode_data_b4_r = 'b11101101          ;     
                'h042 : encode_data_b4_r = 'b11101110          ;     
                'h023 : encode_data_b4_r = 'b11101001          ;     
                'h033 : encode_data_b4_r = 'b111110000         ;     
                'h005 : encode_data_b4_r = 'b111101111         ;     
                'h025 : encode_data_b4_r = 'b1111101110        ;     
                'h034 : encode_data_b4_r = 'b1111101111        ;     
                'h015 : encode_data_b4_r = 'b1111101100        ;     
                'h016 : encode_data_b4_r = 'b1111101101        ;     
                'h006 : encode_data_b4_r = 'b1111101010        ;     
                'h00F : encode_data_b4_r = 'b1111101011        ;     
                'h043 : encode_data_b4_r = 'b1111110000        ;     
                'h044 : encode_data_b4_r = 'b1111110001        ;     
                'h026 : encode_data_b4_r = 'b11111110101       ;     
                'h02F : encode_data_b4_r = 'b11111110110       ;     
                'h01F : encode_data_b4_r = 'b11111110100       ;     
                'h035 : encode_data_b4_r = 'b111111101110      ;     
                'h036 : encode_data_b4_r = 'b111111101111      ;     
                'h045 : encode_data_b4_r = 'b111111110000      ;     
                'h03F : encode_data_b4_r = 'b1111111110100     ;     
                'h046 : encode_data_b4_r = 'b1111111110101     ;     
                'h04F : encode_data_b4_r = 'b1111111110110     ;     
                default : encode_data_b4_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0010 : encode_data_b4_r = 'b110000           ;
                'h0100 : encode_data_b4_r = 'b110001           ;
                'h0120 : encode_data_b4_r = 'b1101111          ;
                'h0011 : encode_data_b4_r = 'b1101010          ;
                'h0012 : encode_data_b4_r = 'b1101011          ;
                'h0210 : encode_data_b4_r = 'b1110000          ;
                'h0101 : encode_data_b4_r = 'b1101100          ;
                'h0102 : encode_data_b4_r = 'b1101101          ;
                'h0220 : encode_data_b4_r = 'b1110001          ;
                'h0110 : encode_data_b4_r = 'b1101110          ;
                'h0121 : encode_data_b4_r = 'b11110001         ;
                'h0122 : encode_data_b4_r = 'b11110010         ;
                'h0211 : encode_data_b4_r = 'b11110011         ;
                'h0212 : encode_data_b4_r = 'b11110100         ;
                'h0221 : encode_data_b4_r = 'b11110101         ;
                'h0111 : encode_data_b4_r = 'b11101111         ;
                'h0222 : encode_data_b4_r = 'b11110110         ;
                'h0112 : encode_data_b4_r = 'b11110000         ;
                'h0013 : encode_data_b4_r = 'b111110001        ;
                'h0014 : encode_data_b4_r = 'b111110010        ;
                'h0103 : encode_data_b4_r = 'b111110011        ;
                'h0104 : encode_data_b4_r = 'b111110100        ;
                'h0123 : encode_data_b4_r = 'b1111110100       ;
                'h0124 : encode_data_b4_r = 'b1111110101       ;
                'h0213 : encode_data_b4_r = 'b1111110110       ;
                'h0214 : encode_data_b4_r = 'b1111110111       ;
                'h0223 : encode_data_b4_r = 'b1111111000       ;
                'h0113 : encode_data_b4_r = 'b1111110010       ;
                'h0224 : encode_data_b4_r = 'b1111111001       ;
                'h0114 : encode_data_b4_r = 'b1111110011       ;
                'h0125 : encode_data_b4_r = 'b111111111000     ;
                'h0015 : encode_data_b4_r = 'b111111110001     ;
                'h0016 : encode_data_b4_r = 'b111111110010     ;
                'h001F : encode_data_b4_r = 'b111111110011     ;
                'h0215 : encode_data_b4_r = 'b111111111001     ;
                'h0105 : encode_data_b4_r = 'b111111110100     ;
                'h0106 : encode_data_b4_r = 'b111111110101     ;
                'h010F : encode_data_b4_r = 'b111111110110     ;
                'h0115 : encode_data_b4_r = 'b111111110111     ;
                'h0126 : encode_data_b4_r = 'b1111111111001    ;
                'h012F : encode_data_b4_r = 'b1111111111010    ;
                'h0216 : encode_data_b4_r = 'b1111111111011    ;
                'h021F : encode_data_b4_r = 'b1111111111100    ;
                'h0225 : encode_data_b4_r = 'b1111111111101    ;
                'h0226 : encode_data_b4_r = 'b1111111111110    ;
                'h0116 : encode_data_b4_r = 'b1111111110111    ;
                'h022F : encode_data_b4_r = 'b1111111111111    ;
                'h011F : encode_data_b4_r = 'b1111111111000    ;
                default : encode_data_b4_r = 'b0;
            endcase
        end
        default : encode_data_b4_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
