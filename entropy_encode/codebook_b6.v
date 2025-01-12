`timescale 1ns/1ps

module codebook_b6#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b6_r    ;
reg     [5 : 0]                         encode_length_b6_r  ;
reg                                     encode_match_b6_r   ;

assign encode_data_o    = encode_data_b6_r      ;
assign encode_length_o  = encode_length_b6_r    ;
assign encode_match_o   = encode_match_b6_r     ;

/**************************************************************************/
//codebook_b4 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h4, 'hF : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h01, 'h10, 'h12, 'h21, 'h22, 'h03, 'h04, 'h30, 'h13, 
                'h14, 'h0F, 'h23, 'h24, 'h31, 'h32, 'h1F, 'h2F, 'h33, 
                'h34, 'h3F : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h002, 'h200, 'h020, 'h022, 'h202, 'h111, 'h112, 'h003, 'h004, 
                'h00F, 'h023, 'h024, 'h203, 'h204, 'h113, 'h02F, 'h20F, 'h114, 
                'h11F : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h0000, 'h0210, 'h1100, 'h0011, 'h0012, 'h0211, 'h0212, 
                'h2011, 'h2012, 'h1101, 'h1102, 'h0003, 'h0004, 'h0013, 
                'h0014, 'h000F, 'h0213, 'h0214, 'h2013, 'h2014, 'h1103, 
                'h1104, 'h001F, 'h021F, 'h201F, 'h110F : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00100, 'h20100, 'h00011, 'h00012, 'h00021, 'h00022, 'h00101, 
                'h00102, 'h20101, 'h20102, 'h00013, 'h00014, 'h00023, 'h00103, 
                'h00104, 'h00024, 'h20103, 'h20104, 'h0001F, 'h0002F, 'h0010F, 
                'h2010F : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h000100, 'h000200, 'h000101, 'h000102, 'h000201, 'h000202, 'h000103, 
                'h000104, 'h000203, 'h000204, 'h00010F, 'h00020F : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        default : encode_match_b6_r = 1'd0;
    endcase
end

//codebook_b4 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h4 : encode_length_b6_r = 7;
                'hF : encode_length_b6_r = 9;
                default : encode_length_b6_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h01 : encode_length_b6_r = 3;
                'h10 : encode_length_b6_r = 3;
                'h12 : encode_length_b6_r = 5;
                'h21 : encode_length_b6_r = 5;
                'h22 : encode_length_b6_r = 5;
                'h03 : encode_length_b6_r = 7;
                'h04 : encode_length_b6_r = 7;
                'h30 : encode_length_b6_r = 7;
                'h13 : encode_length_b6_r = 9;
                'h14 : encode_length_b6_r = 9;
                'h0F : encode_length_b6_r = 9;
                'h23 : encode_length_b6_r = 9;
                'h24 : encode_length_b6_r = 9;
                'h31 : encode_length_b6_r = 9;
                'h32 : encode_length_b6_r = 9;
                'h1F : encode_length_b6_r = 11;
                'h2F : encode_length_b6_r = 11;
                'h33 : encode_length_b6_r = 13;
                'h34 : encode_length_b6_r = 13;
                'h3F : encode_length_b6_r = 15;
                default : encode_length_b6_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h002 : encode_length_b6_r = 4;
                'h200 : encode_length_b6_r = 4;
                'h020 : encode_length_b6_r = 4;
                'h022 : encode_length_b6_r = 6;
                'h202 : encode_length_b6_r = 6;
                'h111 : encode_length_b6_r = 7;
                'h112 : encode_length_b6_r = 7;
                'h003 : encode_length_b6_r = 8;
                'h004 : encode_length_b6_r = 8;
                'h00F : encode_length_b6_r = 10;
                'h023 : encode_length_b6_r = 10;
                'h024 : encode_length_b6_r = 10;
                'h203 : encode_length_b6_r = 10;
                'h204 : encode_length_b6_r = 10;
                'h113 : encode_length_b6_r = 11;
                'h02F : encode_length_b6_r = 12;
                'h20F : encode_length_b6_r = 12;
                'h114 : encode_length_b6_r = 12;
                'h11F : encode_length_b6_r = 13;
                default : encode_length_b6_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0000 : encode_length_b6_r = 3;
                'h0210 : encode_length_b6_r = 6;
                'h1100 : encode_length_b6_r = 6;
                'h0011 : encode_length_b6_r = 6;
                'h0012 : encode_length_b6_r = 6;
                'h0211 : encode_length_b6_r = 8;
                'h0212 : encode_length_b6_r = 8;
                'h2011 : encode_length_b6_r = 8;
                'h2012 : encode_length_b6_r = 8;
                'h1101 : encode_length_b6_r = 8;
                'h1102 : encode_length_b6_r = 8;
                'h0003 : encode_length_b6_r = 9;
                'h0004 : encode_length_b6_r = 9;
                'h0013 : encode_length_b6_r = 10;
                'h0014 : encode_length_b6_r = 11;
                'h000F : encode_length_b6_r = 11;
                'h0213 : encode_length_b6_r = 12;
                'h0214 : encode_length_b6_r = 12;
                'h2013 : encode_length_b6_r = 12;
                'h2014 : encode_length_b6_r = 12;
                'h1103 : encode_length_b6_r = 12;
                'h1104 : encode_length_b6_r = 12;
                'h001F : encode_length_b6_r = 13;
                'h021F : encode_length_b6_r = 14;
                'h201F : encode_length_b6_r = 14;
                'h110F : encode_length_b6_r = 14;
                default : encode_length_b6_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00100 : encode_length_b6_r = 5;
                'h20100 : encode_length_b6_r = 7;
                'h00011 : encode_length_b6_r = 7;
                'h00012 : encode_length_b6_r = 7;
                'h00021 : encode_length_b6_r = 7;
                'h00022 : encode_length_b6_r = 7;
                'h00101 : encode_length_b6_r = 7;
                'h00102 : encode_length_b6_r = 7;
                'h20101 : encode_length_b6_r = 9;
                'h20102 : encode_length_b6_r = 9;
                'h00013 : encode_length_b6_r = 11;
                'h00014 : encode_length_b6_r = 11;
                'h00023 : encode_length_b6_r = 11;
                'h00103 : encode_length_b6_r = 11;
                'h00104 : encode_length_b6_r = 11;
                'h00024 : encode_length_b6_r = 12;
                'h20103 : encode_length_b6_r = 13;
                'h20104 : encode_length_b6_r = 13;
                'h0001F : encode_length_b6_r = 13;
                'h0002F : encode_length_b6_r = 13;
                'h0010F : encode_length_b6_r = 13;
                'h2010F : encode_length_b6_r = 15;
                default : encode_length_b6_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h000100 : encode_length_b6_r = 6;
                'h000200 : encode_length_b6_r = 6;
                'h000101 : encode_length_b6_r = 8;
                'h000102 : encode_length_b6_r = 8;
                'h000201 : encode_length_b6_r = 8;
                'h000202 : encode_length_b6_r = 8;
                'h000103 : encode_length_b6_r = 12;
                'h000104 : encode_length_b6_r = 12;
                'h000203 : encode_length_b6_r = 12;
                'h000204 : encode_length_b6_r = 12;
                'h00010F : encode_length_b6_r = 14;
                'h00020F : encode_length_b6_r = 14;
                default : encode_length_b6_r = 1'd0;
            endcase
        end
        default : encode_length_b6_r = 0;
    endcase
end

//codebook_b4 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h4 : encode_data_b6_r = 'b1101000;
                'hF : encode_data_b6_r = 'b111101100;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h01 : encode_data_b6_r = 'b000;
                'h10 : encode_data_b6_r = 'b001;
                'h12 : encode_data_b6_r = 'b10010;
                'h21 : encode_data_b6_r = 'b10011;
                'h22 : encode_data_b6_r = 'b10100;
                'h03 : encode_data_b6_r = 'b1101001;
                'h04 : encode_data_b6_r = 'b1101010;
                'h30 : encode_data_b6_r = 'b1101011;
                'h13 : encode_data_b6_r = 'b111101110;
                'h14 : encode_data_b6_r = 'b111101111;
                'h0F : encode_data_b6_r = 'b111101101;
                'h23 : encode_data_b6_r = 'b111110000;
                'h24 : encode_data_b6_r = 'b111110001;
                'h31 : encode_data_b6_r = 'b111110010;
                'h32 : encode_data_b6_r = 'b111110011;
                'h1F : encode_data_b6_r = 'b11111101100;
                'h2F : encode_data_b6_r = 'b11111101101;
                'h33 : encode_data_b6_r = 'b1111111110100;
                'h34 : encode_data_b6_r = 'b1111111110101;
                'h3F : encode_data_b6_r = 'b111111111111110;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h002 : encode_data_b6_r = 'b0110;
                'h200 : encode_data_b6_r = 'b1000;
                'h020 : encode_data_b6_r = 'b0111;
                'h022 : encode_data_b6_r = 'b101100;
                'h202 : encode_data_b6_r = 'b101101;
                'h111 : encode_data_b6_r = 'b1101100;
                'h112 : encode_data_b6_r = 'b1101101;
                'h003 : encode_data_b6_r = 'b11101010;
                'h004 : encode_data_b6_r = 'b11101011;
                'h00F : encode_data_b6_r = 'b1111110000;
                'h023 : encode_data_b6_r = 'b1111110001;
                'h024 : encode_data_b6_r = 'b1111110010;
                'h203 : encode_data_b6_r = 'b1111110011;
                'h204 : encode_data_b6_r = 'b1111110100;
                'h113 : encode_data_b6_r = 'b11111101110;
                'h02F : encode_data_b6_r = 'b111111101100;
                'h20F : encode_data_b6_r = 'b111111101110;
                'h114 : encode_data_b6_r = 'b111111101101;
                'h11F : encode_data_b6_r = 'b1111111110110;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0000 : encode_data_b6_r = 'b010;
                'h0210 : encode_data_b6_r = 'b110000;
                'h1100 : encode_data_b6_r = 'b110001;
                'h0011 : encode_data_b6_r = 'b101110;
                'h0012 : encode_data_b6_r = 'b101111;
                'h0211 : encode_data_b6_r = 'b11101100;
                'h0212 : encode_data_b6_r = 'b11101101;
                'h2011 : encode_data_b6_r = 'b11110000;
                'h2012 : encode_data_b6_r = 'b11110001;
                'h1101 : encode_data_b6_r = 'b11101110;
                'h1102 : encode_data_b6_r = 'b11101111;
                'h0003 : encode_data_b6_r = 'b111110100;
                'h0004 : encode_data_b6_r = 'b111110101;
                'h0013 : encode_data_b6_r = 'b1111110101;
                'h0014 : encode_data_b6_r = 'b11111110000;
                'h000F : encode_data_b6_r = 'b11111101111;
                'h0213 : encode_data_b6_r = 'b111111101111;
                'h0214 : encode_data_b6_r = 'b111111110000;
                'h2013 : encode_data_b6_r = 'b111111110011;
                'h2014 : encode_data_b6_r = 'b111111110100;
                'h1103 : encode_data_b6_r = 'b111111110001;
                'h1104 : encode_data_b6_r = 'b111111110010;
                'h001F : encode_data_b6_r = 'b1111111110111;
                'h021F : encode_data_b6_r = 'b11111111111010;
                'h201F : encode_data_b6_r = 'b11111111111100;
                'h110F : encode_data_b6_r = 'b11111111111011;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h00100 : encode_data_b6_r = 'b10101;
                'h20100 : encode_data_b6_r = 'b1110100;
                'h00011 : encode_data_b6_r = 'b1101110;
                'h00012 : encode_data_b6_r = 'b1101111;
                'h00021 : encode_data_b6_r = 'b1110000;
                'h00022 : encode_data_b6_r = 'b1110001;
                'h00101 : encode_data_b6_r = 'b1110010;
                'h00102 : encode_data_b6_r = 'b1110011;
                'h20101 : encode_data_b6_r = 'b111110110;
                'h20102 : encode_data_b6_r = 'b111110111;
                'h00013 : encode_data_b6_r = 'b11111110001;
                'h00014 : encode_data_b6_r = 'b11111110010;
                'h00023 : encode_data_b6_r = 'b11111110011;
                'h00103 : encode_data_b6_r = 'b11111110100;
                'h00104 : encode_data_b6_r = 'b11111110101;
                'h00024 : encode_data_b6_r = 'b111111110101;
                'h20103 : encode_data_b6_r = 'b1111111111011;
                'h20104 : encode_data_b6_r = 'b1111111111100;
                'h0001F : encode_data_b6_r = 'b1111111111000;
                'h0002F : encode_data_b6_r = 'b1111111111001;
                'h0010F : encode_data_b6_r = 'b1111111111010;
                'h2010F : encode_data_b6_r = 'b111111111111111;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd6 : begin
            case(ap_data_i)
                'h000100 : encode_data_b6_r = 'b110010;
                'h000200 : encode_data_b6_r = 'b110011;
                'h000101 : encode_data_b6_r = 'b11110010;
                'h000102 : encode_data_b6_r = 'b11110011;
                'h000201 : encode_data_b6_r = 'b11110100;
                'h000202 : encode_data_b6_r = 'b11110101;
                'h000103 : encode_data_b6_r = 'b111111110110;
                'h000104 : encode_data_b6_r = 'b111111110111;
                'h000203 : encode_data_b6_r = 'b111111111000;
                'h000204 : encode_data_b6_r = 'b111111111001;
                'h00010F : encode_data_b6_r = 'b11111111111101;
                'h00020F : encode_data_b6_r = 'b11111111111110;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        default : encode_data_b6_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
