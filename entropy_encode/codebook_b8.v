`timescale 1ns/1ps

module codebook_b8#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b8_r    ;
reg     [5 : 0]                         encode_length_b8_r  ;
reg                                     encode_match_b8_r   ;

assign encode_data_o    = encode_data_b8_r      ;
assign encode_length_o  = encode_length_b8_r    ;
assign encode_match_o   = encode_match_b8_r     ;

/**************************************************************************/
//codebook_b4 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h02, 'h12, 'h22, 'h0F, 'h1F, 'h2F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h010, 'h100, 'h200, 'h001, 'h002, 'h011, 'h012, 'h101, 'h102, 
                'h110, 'h201, 'h202, 'h210, 'h00F, 'h111, 'h112, 'h211, 'h212, 
                'h10F, 'h01F, 'h20F, 'h11F, 'h21F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h0001, 'h000F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00022, 'h0000F, 'h0002F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h000001, 'h000002, 'h000010, 'h000020, 'h000200, 'h000011, 
                'h000012, 'h000021, 'h000022, 'h000201, 'h000202, 'h000210, 
                'h00000F, 'h000211, 'h000212, 'h00001F, 'h00002F, 'h00020F, 
                'h00021F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case (ap_data_i)
                'h0000001, 'h000000F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd8 : begin
            case (ap_data_i)
                'h00000021, 'h00000022, 'h0000000F, 'h0000002F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd9 : begin
            case (ap_data_i)
                'h000000001, 'h000000002, 'h000000020, 'h000000200, 'h000000011, 
                'h000000012, 'h000000021, 'h000000022, 'h000000201, 'h000000202, 
                'h00000000F, 'h00000001F, 'h00000020F, 'h00000002F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd10 : begin
            case (ap_data_i)
                'h0000000000, 'h0000000001, 'h0000000100, 'h0000000101, 'h0000000102, 
                'h000000000F, 'h000000010F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h00000000021, 'h00000000022, 'h0000000002F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h000000000200, 'h000000000201, 'h000000000202, 'h00000000020F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        default : encode_match_b8_r = 1'd0;
    endcase
end

//codebook_b4 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_length_b8_r = 9;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h02 : encode_length_b8_r = 4;
                'h12 : encode_length_b8_r = 7;
                'h22 : encode_length_b8_r = 7;
                'h0F : encode_length_b8_r = 9;
                'h1F : encode_length_b8_r = 12;
                'h2F : encode_length_b8_r = 12;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h010 : encode_length_b8_r = 4;
                'h100 : encode_length_b8_r = 4;
                'h200 : encode_length_b8_r = 4;
                'h001 : encode_length_b8_r = 4;
                'h002 : encode_length_b8_r = 4;
                'h011 : encode_length_b8_r = 7;
                'h012 : encode_length_b8_r = 7;
                'h101 : encode_length_b8_r = 7;
                'h102 : encode_length_b8_r = 7;
                'h110 : encode_length_b8_r = 7;
                'h201 : encode_length_b8_r = 7;
                'h202 : encode_length_b8_r = 7;
                'h210 : encode_length_b8_r = 7;
                'h00F : encode_length_b8_r = 10;
                'h111 : encode_length_b8_r = 10;
                'h112 : encode_length_b8_r = 10;
                'h211 : encode_length_b8_r = 10;
                'h212 : encode_length_b8_r = 10;
                'h10F : encode_length_b8_r = 12;
                'h01F : encode_length_b8_r = 13;
                'h20F : encode_length_b8_r = 13;
                'h11F : encode_length_b8_r = 15;
                'h21F : encode_length_b8_r = 16;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0001 : encode_length_b8_r = 4;
                'h000F : encode_length_b8_r = 10;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00022 : encode_length_b8_r = 8;
                'h0000F : encode_length_b8_r = 10;
                'h0002F : encode_length_b8_r = 13;
                default : encode_length_b8_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h000001 : encode_length_b8_r = 5;
                'h000002 : encode_length_b8_r = 5;
                'h000010 : encode_length_b8_r = 5;
                'h000020 : encode_length_b8_r = 5;
                'h000200 : encode_length_b8_r = 5;
                'h000011 : encode_length_b8_r = 8;
                'h000012 : encode_length_b8_r = 8;
                'h000021 : encode_length_b8_r = 8;
                'h000022 : encode_length_b8_r = 8;
                'h000201 : encode_length_b8_r = 8;
                'h000202 : encode_length_b8_r = 8;
                'h000210 : encode_length_b8_r = 8;
                'h00000F : encode_length_b8_r = 11;
                'h000211 : encode_length_b8_r = 11;
                'h000212 : encode_length_b8_r = 11;
                'h00001F : encode_length_b8_r = 13;
                'h00002F : encode_length_b8_r = 14;
                'h00020F : encode_length_b8_r = 14;
                'h00021F : encode_length_b8_r = 16;
                default : encode_length_b8_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h0000001 : encode_length_b8_r = 5;
                'h000000F : encode_length_b8_r = 11;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h00000021 : encode_length_b8_r = 9;
                'h00000022 : encode_length_b8_r = 9;
                'h0000000F : encode_length_b8_r = 11;
                'h0000002F : encode_length_b8_r = 14;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h000000001 : encode_length_b8_r = 6;
                'h000000002 : encode_length_b8_r = 6;
                'h000000020 : encode_length_b8_r = 6;
                'h000000200 : encode_length_b8_r = 6;
                'h000000011 : encode_length_b8_r = 9;
                'h000000012 : encode_length_b8_r = 9;
                'h000000021 : encode_length_b8_r = 9;
                'h000000022 : encode_length_b8_r = 9;
                'h000000201 : encode_length_b8_r = 9;
                'h000000202 : encode_length_b8_r = 9;
                'h00000000F : encode_length_b8_r = 11;
                'h00000001F : encode_length_b8_r = 14;
                'h00000020F : encode_length_b8_r = 14;
                'h00000002F : encode_length_b8_r = 15;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h0000000000 : encode_length_b8_r = 3;
                'h0000000001 : encode_length_b8_r = 6;
                'h0000000100 : encode_length_b8_r = 6;
                'h0000000101 : encode_length_b8_r = 9;
                'h0000000102 : encode_length_b8_r = 9;
                'h000000000F : encode_length_b8_r = 12;
                'h000000010F : encode_length_b8_r = 15;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h00000000021 : encode_length_b8_r = 10;
                'h00000000022 : encode_length_b8_r = 10;
                'h0000000002F : encode_length_b8_r = 15;
                default : encode_length_b8_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h000000000200 : encode_length_b8_r = 7;
                'h000000000201 : encode_length_b8_r = 10;
                'h000000000202 : encode_length_b8_r = 10;
                'h00000000020F : encode_length_b8_r = 15;
                default : encode_length_b8_r = 1'd0;
            endcase
        end
        default : encode_length_b8_r = 0;
    endcase
end

//codebook_b4 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_data_b8_r = 'b111101100;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h02 : encode_data_b8_r = 'b0010;
                'h12 : encode_data_b8_r = 'b1101100;
                'h22 : encode_data_b8_r = 'b1101101;
                'h0F : encode_data_b8_r = 'b111101101;
                'h1F : encode_data_b8_r = 'b111111111000;
                'h2F : encode_data_b8_r = 'b111111111001;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h010 : encode_data_b8_r = 'b0101;
                'h100 : encode_data_b8_r = 'b0110;
                'h200 : encode_data_b8_r = 'b0111;
                'h001 : encode_data_b8_r = 'b0011;
                'h002 : encode_data_b8_r = 'b0100;
                'h011 : encode_data_b8_r = 'b1101110;
                'h012 : encode_data_b8_r = 'b1101111;
                'h101 : encode_data_b8_r = 'b1110000;
                'h102 : encode_data_b8_r = 'b1110001;
                'h110 : encode_data_b8_r = 'b1110010;
                'h201 : encode_data_b8_r = 'b1110011;
                'h202 : encode_data_b8_r = 'b1110100;
                'h210 : encode_data_b8_r = 'b1110101;
                'h00F : encode_data_b8_r = 'b1111110000;
                'h111 : encode_data_b8_r = 'b1111110001;
                'h112 : encode_data_b8_r = 'b1111110010;
                'h211 : encode_data_b8_r = 'b1111110011;
                'h212 : encode_data_b8_r = 'b1111110100;
                'h10F : encode_data_b8_r = 'b111111111010;
                'h01F : encode_data_b8_r = 'b1111111111000;
                'h20F : encode_data_b8_r = 'b1111111111001;
                'h11F : encode_data_b8_r = 'b111111111111010;
                'h21F : encode_data_b8_r = 'b1111111111111110;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0001 : encode_data_b8_r = 'b1000;
                'h000F : encode_data_b8_r = 'b1111110101;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h00022 : encode_data_b8_r = 'b11101110;
                'h0000F : encode_data_b8_r = 'b1111110110;
                'h0002F : encode_data_b8_r = 'b1111111111010;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd6 : begin
            case(ap_data_i)
                'h000001 : encode_data_b8_r = 'b10010;
                'h000002 : encode_data_b8_r = 'b10011;
                'h000010 : encode_data_b8_r = 'b10100;
                'h000020 : encode_data_b8_r = 'b10101;
                'h000200 : encode_data_b8_r = 'b10110;
                'h000011 : encode_data_b8_r = 'b11101111;
                'h000012 : encode_data_b8_r = 'b11110000;
                'h000021 : encode_data_b8_r = 'b11110001;
                'h000022 : encode_data_b8_r = 'b11110010;
                'h000201 : encode_data_b8_r = 'b11110011;
                'h000202 : encode_data_b8_r = 'b11110100;
                'h000210 : encode_data_b8_r = 'b11110101;
                'h00000F : encode_data_b8_r = 'b11111110110;
                'h000211 : encode_data_b8_r = 'b11111110111;
                'h000212 : encode_data_b8_r = 'b11111111000;
                'h00001F : encode_data_b8_r = 'b1111111111011;
                'h00002F : encode_data_b8_r = 'b11111111111000;
                'h00020F : encode_data_b8_r = 'b11111111111001;
                'h00021F : encode_data_b8_r = 'b1111111111111111;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h0000001 : encode_data_b8_r = 'b10111;
                'h000000F : encode_data_b8_r = 'b11111111001;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h00000021 : encode_data_b8_r = 'b111101110;
                'h00000022 : encode_data_b8_r = 'b111101111;
                'h0000000F : encode_data_b8_r = 'b11111111010;
                'h0000002F : encode_data_b8_r = 'b11111111111010;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h000000001 : encode_data_b8_r = 'b110000;
                'h000000002 : encode_data_b8_r = 'b110001;
                'h000000020 : encode_data_b8_r = 'b110010;
                'h000000200 : encode_data_b8_r = 'b110011;
                'h000000011 : encode_data_b8_r = 'b111110000;
                'h000000012 : encode_data_b8_r = 'b111110001;
                'h000000021 : encode_data_b8_r = 'b111110010;
                'h000000022 : encode_data_b8_r = 'b111110011;
                'h000000201 : encode_data_b8_r = 'b111110100;
                'h000000202 : encode_data_b8_r = 'b111110101;
                'h00000000F : encode_data_b8_r = 'b11111111011;
                'h00000001F : encode_data_b8_r = 'b11111111111011;
                'h00000020F : encode_data_b8_r = 'b11111111111100;
                'h00000002F : encode_data_b8_r = 'b111111111111011;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h0000000000 : encode_data_b8_r = 'b000;
                'h0000000001 : encode_data_b8_r = 'b110100;
                'h0000000100 : encode_data_b8_r = 'b110101;
                'h0000000101 : encode_data_b8_r = 'b111110110;
                'h0000000102 : encode_data_b8_r = 'b111110111;
                'h000000000F : encode_data_b8_r = 'b111111111011;
                'h000000010F : encode_data_b8_r = 'b111111111111100;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd11 : begin
            case(ap_data_i)
                'h00000000021 : encode_data_b8_r = 'b1111110111;
                'h00000000022 : encode_data_b8_r = 'b1111111000;
                'h0000000002F : encode_data_b8_r = 'b111111111111101;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd12 : begin
            case(ap_data_i)
                'h000000000200 : encode_data_b8_r = 'b1110110;
                'h000000000201 : encode_data_b8_r = 'b1111111001;
                'h000000000202 : encode_data_b8_r = 'b1111111010;
                'h00000000020F : encode_data_b8_r = 'b111111111111110;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        default : encode_data_b8_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
