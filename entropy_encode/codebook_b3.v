`timescale 1ns/1ps

module codebook_b3#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b3_r    ;
reg     [5 : 0]                         encode_length_b3_r  ;
reg                                     encode_match_b3_r   ;

assign encode_data_o    = encode_data_b3_r      ;
assign encode_length_o  = encode_length_b3_r    ;
assign encode_match_o   = encode_match_b3_r     ;

/**************************************************************************/
//codebook_b3 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
               'h1,'h5,'hF : encode_match_b3_r = 1'd1;
                default : encode_match_b3_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h01, 'h02, 'h20, 'h40, 'h03, 'h04, 'h30, 'h42, 
                'h24, 'h33, 'h34, 'h43, 'h05, 'h44, 'h06, 'h60, 
                'h0F, 'h25, 'h26, 'h2F, 'h61, 'h62, 'h35, 'h36, 
                'h3F, 'h45, 'h46, 'h63, 'h64, 'h4F, 'h65, 'h66, 
                'h6F : encode_match_b3_r = 1'd1;
                default : encode_match_b3_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h000,'h220,'h210,'h212,'h320,'h222,'h410,'h003,'h004,'h230,
                'h310,'h213,'h214,'h321,'h322,'h223,'h224,'h411,'h412,'h231,
                'h232,'h311,'h312,'h323,'h324,'h005,'h413,'h006,'h414,'h00F,
                'h233,'h234,'h313,'h314,'h215,'h216,'h225,'h226,'h316,'h21F,
                'h325,'h326,'h22F,'h415,'h416,'h235,'h236,'h315,'h31F,
                'h32F,'h41F,'h23F : encode_match_b3_r = 1'd1;
                default : encode_match_b3_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0010, 'h0020, 'h0011, 'h0012, 'h2210, 'h0021, 'h0022, 'h2110, 'h0013, 
                'h0014, 'h2211, 'h2212, 'h0023, 'h0024, 'h2111, 'h2112, 'h2213, 'h2214, 
                'h2113, 'h2114, 'h0015, 'h0016, 'h0025, 'h0026, 'h001F, 'h2215, 'h2216, 
                'h002F, 'h2115, 'h2116, 'h221F, 'h211F : encode_match_b3_r = 1'd1;
                default : encode_match_b3_r = 1'd0;
            endcase
        end
        default : encode_match_b3_r = 1'd0;
    endcase
end

//codebook_b3 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1 :   encode_length_b3_r = 2;
                'h5 :   encode_length_b3_r = 5;
                'hF :   encode_length_b3_r = 6;
                default : encode_length_b3_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h01, 'h02, 'h20 : encode_length_b3_r = 4;
                'h40, 'h03, 'h04, 'h30 : encode_length_b3_r = 5;
                'h42, 'h24 : encode_length_b3_r = 6;
                'h33, 'h34, 'h43, 'h05, 'h44, 'h06, 'h60 : encode_length_b3_r = 7;
                'h0F, 'h25, 'h26, 'h2F, 'h61, 'h62 : encode_length_b3_r = 8;
                'h35, 'h36, 'h3F, 'h45, 'h46, 'h63, 'h64 : encode_length_b3_r = 9;
                'h4F : encode_length_b3_r = 10;
                'h65, 'h66 : encode_length_b3_r = 11;
                'h6F : encode_length_b3_r = 12;
                default : encode_length_b3_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h000 : encode_length_b3_r = 5;
                'h220, 'h210 : encode_length_b3_r = 6;
                'h212, 'h320, 'h222, 'h410, 'h003, 'h004, 'h230, 'h310 : encode_length_b3_r = 7;
                'h213, 'h214, 'h321, 'h322, 'h223, 'h224, 'h411, 'h412, 
                'h231, 'h232, 'h311, 'h312 : encode_length_b3_r = 8;
                'h323, 'h324, 'h005, 'h413, 'h006, 'h414, 'h00F, 'h233, 
                'h234, 'h313, 'h314 : encode_length_b3_r = 9;
                'h215, 'h216, 'h225, 'h226 : encode_length_b3_r = 10;
                'h316, 'h21F, 'h325, 'h326, 'h22F, 'h415, 'h416, 'h235, 'h236, 'h315 : encode_length_b3_r = 11;
                'h31F, 'h32F, 'h41F, 'h23F : encode_length_b3_r = 12;
                default : encode_length_b3_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0010, 'h0020 : encode_length_b3_r = 7;
                'h0011, 'h0012, 'h2210, 'h0021, 'h0022, 'h2110 : encode_length_b3_r = 8;
                'h0013, 'h0014, 'h2211, 'h2212, 'h0023, 'h0024, 'h2111, 'h2112 : encode_length_b3_r = 9;
                'h2213, 'h2214, 'h2113, 'h2114 : encode_length_b3_r = 10;
                'h0015, 'h0016, 'h0025, 'h0026 : encode_length_b3_r = 11;
                'h001F, 'h2215, 'h2216, 'h002F, 'h2115, 'h2116 : encode_length_b3_r = 12;
                'h221F, 'h211F : encode_length_b3_r = 13;
                default : encode_length_b3_r = 0;
            endcase
        end
        default : encode_length_b3_r = 0;
    endcase
end


//codebook_b3 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
               'h1 : encode_data_b3_r = 'b00;
               'h5 : encode_data_b3_r = 'b01110;
               'hF : encode_data_b3_r = 'b101000;
                default : encode_data_b3_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
               'h01 : encode_data_b3_r = 'b0100;
               'h02 : encode_data_b3_r = 'b0101;
               'h20 : encode_data_b3_r = 'b0110;
               'h40 : encode_data_b3_r = 'b10010;
               'h03 : encode_data_b3_r = 'b01111;
               'h04 : encode_data_b3_r = 'b10000;
               'h30 : encode_data_b3_r = 'b10001;
               'h42 : encode_data_b3_r = 'b101010;
               'h24 : encode_data_b3_r = 'b101001;
               'h33 : encode_data_b3_r = 'b1011100;
               'h34 : encode_data_b3_r = 'b1011101;
               'h43 : encode_data_b3_r = 'b1011110;
               'h05 : encode_data_b3_r = 'b1011010;
               'h44 : encode_data_b3_r = 'b1011111;
               'h06 : encode_data_b3_r = 'b1011011;
               'h60 : encode_data_b3_r = 'b1100000;
               'h0F : encode_data_b3_r = 'b11010110;
               'h25 : encode_data_b3_r = 'b11010111;
               'h26 : encode_data_b3_r = 'b11011000;
               'h2F : encode_data_b3_r = 'b11011001;
               'h61 : encode_data_b3_r = 'b11011010;
               'h62 : encode_data_b3_r = 'b11011011;
               'h35 : encode_data_b3_r = 'b111011100;
               'h36 : encode_data_b3_r = 'b111011101;
               'h3F : encode_data_b3_r = 'b111011110;
               'h45 : encode_data_b3_r = 'b111011111;
               'h46 : encode_data_b3_r = 'b111100000;
               'h63 : encode_data_b3_r = 'b111100001;
               'h64 : encode_data_b3_r = 'b111100010;
               'h4F : encode_data_b3_r = 'b1111101100;
               'h65 : encode_data_b3_r = 'b11111101010;
               'h66 : encode_data_b3_r = 'b11111101011;
               'h6F : encode_data_b3_r = 'b111111110100;               
                default : encode_data_b3_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
               'h000 : encode_data_b3_r = 'b10011;
               'h220 : encode_data_b3_r = 'b101100;
               'h210 : encode_data_b3_r = 'b101011;
               'h212 : encode_data_b3_r = 'b1100011;
               'h320 : encode_data_b3_r = 'b1100111;
               'h222 : encode_data_b3_r = 'b1100100;
               'h410 : encode_data_b3_r = 'b1101000;
               'h003 : encode_data_b3_r = 'b1100001;
               'h004 : encode_data_b3_r = 'b1100010;
               'h230 : encode_data_b3_r = 'b1100101;
               'h310 : encode_data_b3_r = 'b1100110;
               'h213 : encode_data_b3_r = 'b11011100;
               'h214 : encode_data_b3_r = 'b11011101;
               'h321 : encode_data_b3_r = 'b11100100;
               'h322 : encode_data_b3_r = 'b11100101;
               'h223 : encode_data_b3_r = 'b11011110;
               'h224 : encode_data_b3_r = 'b11011111;
               'h411 : encode_data_b3_r = 'b11100110;
               'h412 : encode_data_b3_r = 'b11100111;
               'h231 : encode_data_b3_r = 'b11100000;
               'h232 : encode_data_b3_r = 'b11100001;
               'h311 : encode_data_b3_r = 'b11100010;
               'h312 : encode_data_b3_r = 'b11100011;
               'h323 : encode_data_b3_r = 'b111101010;
               'h324 : encode_data_b3_r = 'b111101011;
               'h005 : encode_data_b3_r = 'b111100011;
               'h413 : encode_data_b3_r = 'b111101100;
               'h006 : encode_data_b3_r = 'b111100100;
               'h414 : encode_data_b3_r = 'b111101101;
               'h00F : encode_data_b3_r = 'b111100101;
               'h233 : encode_data_b3_r = 'b111100110;
               'h234 : encode_data_b3_r = 'b111100111;
               'h313 : encode_data_b3_r = 'b111101000;
               'h314 : encode_data_b3_r = 'b111101001;
               'h215 : encode_data_b3_r = 'b1111101101;
               'h216 : encode_data_b3_r = 'b1111101110;
               'h225 : encode_data_b3_r = 'b1111101111;
               'h226 : encode_data_b3_r = 'b1111110000;
               'h316 : encode_data_b3_r = 'b11111110001;
               'h21F : encode_data_b3_r = 'b11111101100;
               'h325 : encode_data_b3_r = 'b11111110010;
               'h326 : encode_data_b3_r = 'b11111110011;
               'h22F : encode_data_b3_r = 'b11111101101;
               'h415 : encode_data_b3_r = 'b11111110100;
               'h416 : encode_data_b3_r = 'b11111110101;
               'h235 : encode_data_b3_r = 'b11111101110;
               'h236 : encode_data_b3_r = 'b11111101111;
               'h315 : encode_data_b3_r = 'b11111110000;
               'h31F : encode_data_b3_r = 'b111111110110;
               'h32F : encode_data_b3_r = 'b111111110111;
               'h41F : encode_data_b3_r = 'b111111111000;
               'h23F : encode_data_b3_r = 'b111111110101;
                default : encode_data_b3_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
               'h0010 : encode_data_b3_r = 'b1101001;
               'h0020 : encode_data_b3_r = 'b1101010;
               'h0011 : encode_data_b3_r = 'b11101000;
               'h0012 : encode_data_b3_r = 'b11101001;
               'h2210 : encode_data_b3_r = 'b11101101;
               'h0021 : encode_data_b3_r = 'b11101010;
               'h0022 : encode_data_b3_r = 'b11101011;
               'h2110 : encode_data_b3_r = 'b11101100;
               'h0013 : encode_data_b3_r = 'b111101110;
               'h0014 : encode_data_b3_r = 'b111101111;
               'h2211 : encode_data_b3_r = 'b111110100;
               'h2212 : encode_data_b3_r = 'b111110101;
               'h0023 : encode_data_b3_r = 'b111110000;
               'h0024 : encode_data_b3_r = 'b111110001;
               'h2111 : encode_data_b3_r = 'b111110010;
               'h2112 : encode_data_b3_r = 'b111110011;
               'h2213 : encode_data_b3_r = 'b1111110011;
               'h2214 : encode_data_b3_r = 'b1111110100;
               'h2113 : encode_data_b3_r = 'b1111110001;
               'h2114 : encode_data_b3_r = 'b1111110010;
               'h0015 : encode_data_b3_r = 'b11111110110;
               'h0016 : encode_data_b3_r = 'b11111110111;
               'h0025 : encode_data_b3_r = 'b11111111000;
               'h0026 : encode_data_b3_r = 'b11111111001;
               'h001F : encode_data_b3_r = 'b111111111001;
               'h2215 : encode_data_b3_r = 'b111111111101;
               'h2216 : encode_data_b3_r = 'b111111111110;
               'h002F : encode_data_b3_r = 'b111111111010;
               'h2115 : encode_data_b3_r = 'b111111111011;
               'h2116 : encode_data_b3_r = 'b111111111100;
               'h221F : encode_data_b3_r = 'b1111111111111;
               'h211F : encode_data_b3_r = 'b1111111111110;
                default : encode_data_b3_r = 'b0;
            endcase
        end
        default : encode_data_b3_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
