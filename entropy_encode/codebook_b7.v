`timescale 1ns/1ps

module codebook_b7#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b7_r    ;
reg     [5 : 0]                         encode_length_b7_r  ;
reg                                     encode_match_b7_r   ;

assign encode_data_o    = encode_data_b7_r      ;
assign encode_length_o  = encode_length_b7_r    ;
assign encode_match_o   = encode_match_b7_r     ;

/**************************************************************************/
//codebook_b4 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h2, 'h4, 'hF : encode_match_b7_r = 1'd1;
                default : encode_match_b7_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h00, 'h12, 'h03, 'h04, 'h30, 'h0F, 'h13, 'h14, 
                'h31, 'h32, 'h1F, 'h33, 'h34, 'h3F : encode_match_b7_r = 1'd1;
                default : encode_match_b7_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h020, 'h110, 'h011, 'h012, 'h021, 'h101, 'h102, 'h111, 
                'h103, 'h104, 'h023, 'h024, 'h013, 'h014, 'h10F, 'h02F, 
                'h113, 'h114, 'h01F, 'h11F : encode_match_b7_r = 1'd1;
                default : encode_match_b7_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h0100, 'h1000, 'h0220, 'h1120, 'h0221, 'h0222, 'h1121, 'h1122, 
                'h0103, 'h0104, 'h1003, 'h1004, 'h010F, 'h100F, 'h0223, 'h0224, 
                'h022F, 'h1123, 'h1124, 'h112F : encode_match_b7_r = 1'd1;
                default : encode_match_b7_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h01010, 'h01020, 'h10010, 'h10020, 'h01011, 'h01012, 'h01021, 
                'h10011, 'h10012, 'h10021, 'h01022, 'h10022, 'h01013, 'h01014, 
                'h01023, 'h01024, 'h10013, 'h10014, 'h10023, 'h10024, 'h1001F, 
                'h0101F, 'h0102F, 'h1002F : encode_match_b7_r = 1'd1;
                default : encode_match_b7_r = 1'd0;
            endcase
        end
        default : encode_match_b7_r = 1'd0;
    endcase
end

//codebook_b4 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h2 : encode_length_b7_r = 3;
                'h4 : encode_length_b7_r = 9;
                'hF : encode_length_b7_r = 10;
                default : encode_length_b7_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h00 : encode_length_b7_r = 1;
                'h12 : encode_length_b7_r = 6;
                'h03 : encode_length_b7_r = 9;
                'h04 : encode_length_b7_r = 9;
                'h30 : encode_length_b7_r = 9;
                'h0F : encode_length_b7_r = 11;
                'h13 : encode_length_b7_r = 11;
                'h14 : encode_length_b7_r = 11;
                'h31 : encode_length_b7_r = 11;
                'h32 : encode_length_b7_r = 11;
                'h1F : encode_length_b7_r = 13;
                'h33 : encode_length_b7_r = 16;
                'h34 : encode_length_b7_r = 17;
                'h3F : encode_length_b7_r = 18;
                default : encode_length_b7_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h020 : encode_length_b7_r = 4;
                'h110 : encode_length_b7_r = 6;
                'h011 : encode_length_b7_r = 6;
                'h012 : encode_length_b7_r = 6;
                'h021 : encode_length_b7_r = 6;
                'h101 : encode_length_b7_r = 6;
                'h102 : encode_length_b7_r = 6;
                'h111 : encode_length_b7_r = 8;
                'h103 : encode_length_b7_r = 12;
                'h104 : encode_length_b7_r = 12;
                'h023 : encode_length_b7_r = 12;
                'h024 : encode_length_b7_r = 12;
                'h013 : encode_length_b7_r = 12;
                'h014 : encode_length_b7_r = 12;
                'h10F : encode_length_b7_r = 14;
                'h02F : encode_length_b7_r = 14;
                'h113 : encode_length_b7_r = 14;
                'h114 : encode_length_b7_r = 14;
                'h01F : encode_length_b7_r = 14;
                'h11F : encode_length_b7_r = 16;
                default : encode_length_b7_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0100 : encode_length_b7_r = 4;
                'h1000 : encode_length_b7_r = 4;
                'h0220 : encode_length_b7_r = 7;
                'h1120 : encode_length_b7_r = 9;
                'h0221 : encode_length_b7_r = 9;
                'h0222 : encode_length_b7_r = 9;
                'h1121 : encode_length_b7_r = 11;
                'h1122 : encode_length_b7_r = 11;
                'h0103 : encode_length_b7_r = 12;
                'h0104 : encode_length_b7_r = 12;
                'h1003 : encode_length_b7_r = 12;
                'h1004 : encode_length_b7_r = 12;
                'h010F : encode_length_b7_r = 14;
                'h100F : encode_length_b7_r = 14;
                'h0223 : encode_length_b7_r = 15;
                'h0224 : encode_length_b7_r = 15;
                'h022F : encode_length_b7_r = 16;
                'h1123 : encode_length_b7_r = 16;
                'h1124 : encode_length_b7_r = 17;
                'h112F : encode_length_b7_r = 18;
                default : encode_length_b7_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h01010 : encode_length_b7_r = 7;
                'h01020 : encode_length_b7_r = 7;
                'h10010 : encode_length_b7_r = 7;
                'h10020 : encode_length_b7_r = 7;
                'h01011 : encode_length_b7_r = 9;
                'h01012 : encode_length_b7_r = 9;
                'h01021 : encode_length_b7_r = 9;
                'h10011 : encode_length_b7_r = 9;
                'h10012 : encode_length_b7_r = 9;
                'h10021 : encode_length_b7_r = 9;
                'h01022 : encode_length_b7_r = 10;
                'h10022 : encode_length_b7_r = 10;
                'h01013 : encode_length_b7_r = 15;
                'h01014 : encode_length_b7_r = 15;
                'h01023 : encode_length_b7_r = 15;
                'h01024 : encode_length_b7_r = 15;
                'h10013 : encode_length_b7_r = 15;
                'h10014 : encode_length_b7_r = 15;
                'h10023 : encode_length_b7_r = 15;
                'h10024 : encode_length_b7_r = 15;
                'h1001F : encode_length_b7_r = 16;
                'h0101F : encode_length_b7_r = 17;
                'h0102F : encode_length_b7_r = 17;
                'h1002F : encode_length_b7_r = 17;
                default : encode_length_b7_r = 1'd0;
            endcase
        end
        default : encode_length_b7_r = 0;
    endcase
end

//codebook_b4 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h2 : encode_data_b7_r = 'b100;
                'h4 : encode_data_b7_r = 'b111101110;
                'hF : encode_data_b7_r = 'b1111110110;

                default : encode_data_b7_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h00 : encode_data_b7_r = 'b0;
                'h12 : encode_data_b7_r = 'b110100;
                'h03 : encode_data_b7_r = 'b111101111;
                'h04 : encode_data_b7_r = 'b111110000;
                'h30 : encode_data_b7_r = 'b111110001;
                'h0F : encode_data_b7_r = 'b11111110010;
                'h13 : encode_data_b7_r = 'b11111110011;
                'h14 : encode_data_b7_r = 'b11111110100;
                'h31 : encode_data_b7_r = 'b11111110101;
                'h32 : encode_data_b7_r = 'b11111110110;
                'h1F : encode_data_b7_r = 'b1111111111000;
                'h33 : encode_data_b7_r = 'b1111111111111000;
                'h34 : encode_data_b7_r = 'b11111111111111010;
                'h3F : encode_data_b7_r = 'b111111111111111110;

                default : encode_data_b7_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h020 : encode_data_b7_r = 'b1010;
                'h110 : encode_data_b7_r = 'b111010;
                'h011 : encode_data_b7_r = 'b110101;
                'h012 : encode_data_b7_r = 'b110110;
                'h021 : encode_data_b7_r = 'b110111;
                'h101 : encode_data_b7_r = 'b111000;
                'h102 : encode_data_b7_r = 'b111001;
                'h111 : encode_data_b7_r = 'b11110110;
                'h103 : encode_data_b7_r = 'b111111110110;
                'h104 : encode_data_b7_r = 'b111111110111;
                'h023 : encode_data_b7_r = 'b111111110100;
                'h024 : encode_data_b7_r = 'b111111110101;
                'h013 : encode_data_b7_r = 'b111111110010;
                'h014 : encode_data_b7_r = 'b111111110011;
                'h10F : encode_data_b7_r = 'b11111111110100;
                'h02F : encode_data_b7_r = 'b11111111110011;
                'h113 : encode_data_b7_r = 'b11111111110101;
                'h114 : encode_data_b7_r = 'b11111111110110;
                'h01F : encode_data_b7_r = 'b11111111110010;
                'h11F : encode_data_b7_r = 'b1111111111111001;

                default : encode_data_b7_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0100 : encode_data_b7_r = 'b1011;
                'h1000 : encode_data_b7_r = 'b1100;
                'h0220 : encode_data_b7_r = 'b1110110;
                'h1120 : encode_data_b7_r = 'b111110100;
                'h0221 : encode_data_b7_r = 'b111110010;
                'h0222 : encode_data_b7_r = 'b111110011;
                'h1121 : encode_data_b7_r = 'b11111110111;
                'h1122 : encode_data_b7_r = 'b11111111000;
                'h0103 : encode_data_b7_r = 'b111111111000;
                'h0104 : encode_data_b7_r = 'b111111111001;
                'h1003 : encode_data_b7_r = 'b111111111010;
                'h1004 : encode_data_b7_r = 'b111111111011;
                'h010F : encode_data_b7_r = 'b11111111110111;
                'h100F : encode_data_b7_r = 'b11111111111000;
                'h0223 : encode_data_b7_r = 'b111111111110010;
                'h0224 : encode_data_b7_r = 'b111111111110011;
                'h022F : encode_data_b7_r = 'b1111111111111010;
                'h1123 : encode_data_b7_r = 'b1111111111111011;
                'h1124 : encode_data_b7_r = 'b11111111111111011;
                'h112F : encode_data_b7_r = 'b111111111111111111;

                default : encode_data_b7_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h01010 : encode_data_b7_r = 'b1110111;
                'h01020 : encode_data_b7_r = 'b1111000;
                'h10010 : encode_data_b7_r = 'b1111001;
                'h10020 : encode_data_b7_r = 'b1111010;
                'h01011 : encode_data_b7_r = 'b111110101;
                'h01012 : encode_data_b7_r = 'b111110110;
                'h01021 : encode_data_b7_r = 'b111110111;
                'h10011 : encode_data_b7_r = 'b111111000;
                'h10012 : encode_data_b7_r = 'b111111001;
                'h10021 : encode_data_b7_r = 'b111111010;
                'h01022 : encode_data_b7_r = 'b1111110111;
                'h10022 : encode_data_b7_r = 'b1111111000;
                'h01013 : encode_data_b7_r = 'b111111111110100;
                'h01014 : encode_data_b7_r = 'b111111111110101;
                'h01023 : encode_data_b7_r = 'b111111111110110;
                'h01024 : encode_data_b7_r = 'b111111111110111;
                'h10013 : encode_data_b7_r = 'b111111111111000;
                'h10014 : encode_data_b7_r = 'b111111111111001;
                'h10023 : encode_data_b7_r = 'b111111111111010;
                'h10024 : encode_data_b7_r = 'b111111111111011;
                'h1001F : encode_data_b7_r = 'b1111111111111100;
                'h0101F : encode_data_b7_r = 'b11111111111111100;
                'h0102F : encode_data_b7_r = 'b11111111111111101;
                'h1002F : encode_data_b7_r = 'b11111111111111110;
                default : encode_data_b7_r = 'b0;
            endcase
        end
        default : encode_data_b7_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
