`timescale 1ns/1ps

module codebook_b10#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b10_r    ;
reg     [5 : 0]                         encode_length_b10_r  ;
reg                                     encode_match_b10_r   ;

assign encode_data_o    = encode_data_b10_r      ;
assign encode_length_o  = encode_length_b10_r    ;
assign encode_match_o   = encode_match_b10_r     ;

/**************************************************************************/
//codebook_b4 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h2, 'hF : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h02, 'h11, 'h12, 'h0F, 'h1F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h002, 'h011, 'h101, 'h012, 'h102, 'h00F, 'h10F, 'h01F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h0001, 'h0002, 'h0010, 'h1000, 'h0100, 'h0011, 
                'h0012, 'h1001, 'h1002, 'h0101, 'h0102, 'h000F, 
                'h010F, 'h001F, 'h100F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00001, 'h0000F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h000001, 'h000021, 'h000022, 'h00000F, 'h00002F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case (ap_data_i)
                'h0000001, 'h0000201, 'h0000202, 'h0000021, 
                'h0000022, 'h000000F, 'h000020F, 'h000002F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd8 : begin
            case (ap_data_i)
                'h00000201, 'h00000021, 'h00002001, 'h00000202, 
                'h00000022, 'h00002002, 'h0000000F, 'h0000020F, 
                'h0000002F, 'h0000200F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd9 : begin
            case (ap_data_i)
                'h000000000, 'h000000200, 'h000002000, 'h000020000, 'h000000201, 
                'h000000011, 'h000000012, 'h000000021, 'h000002001, 'h000020001, 
                'h000000202, 'h000000022, 'h000002002, 'h000020002, 'h00000000F, 
                'h00000020F, 'h00000001F, 'h00000002F, 'h00000200F, 'h00002000F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd10 : begin
            case (ap_data_i)
                'h0000000200, 'h0000000020, 'h0000000102, 'h0000000201, 
                'h0000000011, 'h0000000012, 'h0000000021, 'h0000000101, 
                'h0000000202, 'h0000000022, 'h000000010F, 'h000000020F, 
                'h000000001F, 'h000000002F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h00000001001, 'h00000000101, 'h00000000102, 'h00000001002, 
                'h0000000010F, 'h0000000100F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h000000001000, 'h000000010000, 'h000000001001, 
                'h000000010001, 'h000000001002, 'h000000010002, 
                'h00000000100F, 'h00000001000F : encode_match_b10_r = 1'd1;
                default : encode_match_b10_r = 1'd0;
            endcase
        end
        default : encode_match_b10_r = 1'd0;
    endcase
end

//codebook_b4 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h2 : encode_length_b10_r = 5;
                'hF : encode_length_b10_r = 12;
                default : encode_length_b10_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h02 : encode_length_b10_r = 5;
                'h11 : encode_length_b10_r = 9;
                'h12 : encode_length_b10_r = 10;
                'h0F : encode_length_b10_r = 12;
                'h1F : encode_length_b10_r = 17;
                default : encode_length_b10_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h002 : encode_length_b10_r = 5;
                'h011, 'h101 : encode_length_b10_r = 9;
                'h012, 'h102 : encode_length_b10_r = 10;
                'h00F : encode_length_b10_r = 13;
                'h10F, 'h01F : encode_length_b10_r = 17;
                default : encode_length_b10_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0001, 'h0002, 'h0010, 'h1000, 'h0100 : encode_length_b10_r = 5;
                'h0011, 'h0012, 'h1001, 'h1002, 'h0101, 'h0102 : encode_length_b10_r = 10;
                'h000F : encode_length_b10_r = 13;
                'h010F, 'h001F, 'h100F : encode_length_b10_r = 17;
                default : encode_length_b10_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00001 : encode_length_b10_r = 5;
                'h0000F : encode_length_b10_r = 13;
                default : encode_length_b10_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h000001 : encode_length_b10_r = 5;
                'h000021, 'h000022 : encode_length_b10_r = 10;
                'h00000F : encode_length_b10_r = 13;
                'h00002F : encode_length_b10_r = 17;
                default : encode_length_b10_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h0000001 : encode_length_b10_r = 5;
                'h0000201, 'h0000202, 'h0000021, 'h0000022 : encode_length_b10_r = 10;
                'h000000F : encode_length_b10_r = 13;
                'h000020F, 'h000002F : encode_length_b10_r = 18;
                default : encode_length_b10_r = 0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h00000201, 'h00000021, 'h00002001 : encode_length_b10_r = 10;
                'h00000202, 'h00000022, 'h00002002 : encode_length_b10_r = 11;
                'h0000000F : encode_length_b10_r = 13;
                'h0000020F, 'h0000002F, 'h0000200F : encode_length_b10_r = 18;
                default : encode_length_b10_r = 0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h000000000 : encode_length_b10_r = 1;
                'h000000200, 'h000002000, 'h000020000 : encode_length_b10_r = 6;
                'h000000201, 'h000000011, 'h000000012, 'h000000021, 'h000002001, 'h000020001 : encode_length_b10_r = 10;
                'h000000202, 'h000000022, 'h000002002, 'h000020002 : encode_length_b10_r = 11;
                'h00000000F : encode_length_b10_r = 13;
                'h00000020F, 'h00000001F, 'h00000002F, 'h00000200F, 'h00002000F : encode_length_b10_r = 18;
                default : encode_length_b10_r = 0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h0000000200, 'h0000000020 : encode_length_b10_r = 6;
                'h0000000102, 'h0000000201, 'h0000000011, 'h0000000012, 'h0000000021, 'h0000000101 : encode_length_b10_r = 10;
                'h0000000202, 'h0000000022 : encode_length_b10_r = 11;
                'h000000010F, 'h000000020F, 'h000000001F, 'h000000002F : encode_length_b10_r = 18;
                default : encode_length_b10_r = 0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h00000001001, 'h00000000101 : encode_length_b10_r = 10;
                'h00000000102, 'h00000001002 : encode_length_b10_r = 11;
                'h0000000010F, 'h0000000100F : encode_length_b10_r = 18;
                default : encode_length_b10_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h000000001000, 'h000000010000 : encode_length_b10_r = 6;
                'h000000001001, 'h000000010001 : encode_length_b10_r = 10;
                'h000000001002, 'h000000010002 : encode_length_b10_r = 11;
                'h00000000100F, 'h00000001000F : encode_length_b10_r = 18;
                default : encode_length_b10_r = 1'd0;
            endcase
        end
        default : encode_length_b10_r = 0;
    endcase
end

//codebook_b4 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h2 : encode_data_b10_r = 'b10000;
                'hF : encode_data_b10_r = 'b111111111010;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h02 : encode_data_b10_r = 'b10001;
                'h11 : encode_data_b10_r = 'b111101000;
                'h12 : encode_data_b10_r = 'b1111010110;
                'h0F : encode_data_b10_r = 'b111111111011;
                'h1F : encode_data_b10_r = 'b11111111111110000;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h002 : encode_data_b10_r = 'b10010;
                'h011 : encode_data_b10_r = 'b111101001;
                'h101 : encode_data_b10_r = 'b111101010;
                'h012 : encode_data_b10_r = 'b1111010111;
                'h102 : encode_data_b10_r = 'b1111011000;
                'h00F : encode_data_b10_r = 'b1111111111000;
                'h10F : encode_data_b10_r = 'b11111111111110010;
                'h01F : encode_data_b10_r = 'b11111111111110001;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0001 : encode_data_b10_r = 'b10011;
                'h0002 : encode_data_b10_r = 'b10100;
                'h0010 : encode_data_b10_r = 'b10101;
                'h1000 : encode_data_b10_r = 'b10111;
                'h0100 : encode_data_b10_r = 'b10110;
                'h0011 : encode_data_b10_r = 'b1111011001;
                'h0012 : encode_data_b10_r = 'b1111011010;
                'h1001 : encode_data_b10_r = 'b1111011101;
                'h1002 : encode_data_b10_r = 'b1111011110;
                'h0101 : encode_data_b10_r = 'b1111011011;
                'h0102 : encode_data_b10_r = 'b1111011100;
                'h000F : encode_data_b10_r = 'b1111111111001;
                'h010F : encode_data_b10_r = 'b11111111111110100;
                'h001F : encode_data_b10_r = 'b11111111111110011;
                'h100F : encode_data_b10_r = 'b11111111111110101;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h00001 : encode_data_b10_r = 'b11000;
                'h0000F : encode_data_b10_r = 'b1111111111010;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd6 : begin
            case(ap_data_i)
                'h000001 : encode_data_b10_r = 'b11001;
                'h000021 : encode_data_b10_r = 'b1111011111;
                'h000022 : encode_data_b10_r = 'b1111100000;
                'h00000F : encode_data_b10_r = 'b1111111111011;
                'h00002F : encode_data_b10_r = 'b11111111111110110;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h0000001 : encode_data_b10_r = 'b11010;
                'h0000201 : encode_data_b10_r = 'b1111100011;
                'h0000202 : encode_data_b10_r = 'b1111100100;
                'h0000021 : encode_data_b10_r = 'b1111100001;
                'h0000022 : encode_data_b10_r = 'b1111100010;
                'h000000F : encode_data_b10_r = 'b1111111111100;
                'h000020F : encode_data_b10_r = 'b111111111111101111;
                'h000002F : encode_data_b10_r = 'b111111111111101110;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h00000201 : encode_data_b10_r = 'b1111100110;
                'h00000021 : encode_data_b10_r = 'b1111100101;
                'h00002001 : encode_data_b10_r = 'b1111100111;
                'h00000202 : encode_data_b10_r = 'b11111110001;
                'h00000022 : encode_data_b10_r = 'b11111110000;
                'h00002002 : encode_data_b10_r = 'b11111110010;
                'h0000000F : encode_data_b10_r = 'b1111111111101;
                'h0000020F : encode_data_b10_r = 'b111111111111110001;
                'h0000002F : encode_data_b10_r = 'b111111111111110000;
                'h0000200F : encode_data_b10_r = 'b111111111111110010;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h000000000 : encode_data_b10_r = 'b0;
                'h000000200 : encode_data_b10_r = 'b110110;
                'h000002000 : encode_data_b10_r = 'b110111;
                'h000020000 : encode_data_b10_r = 'b111000;
                'h000000201 : encode_data_b10_r = 'b1111101011;
                'h000000011 : encode_data_b10_r = 'b1111101000;
                'h000000012 : encode_data_b10_r = 'b1111101001;
                'h000000021 : encode_data_b10_r = 'b1111101010;
                'h000002001 : encode_data_b10_r = 'b1111101100;
                'h000020001 : encode_data_b10_r = 'b1111101101;
                'h000000202 : encode_data_b10_r = 'b11111110100;
                'h000000022 : encode_data_b10_r = 'b11111110011;
                'h000002002 : encode_data_b10_r = 'b11111110101;
                'h000020002 : encode_data_b10_r = 'b11111110110;
                'h00000000F : encode_data_b10_r = 'b1111111111110;
                'h00000020F : encode_data_b10_r = 'b111111111111110101;
                'h00000001F : encode_data_b10_r = 'b111111111111110011;
                'h00000002F : encode_data_b10_r = 'b111111111111110100;
                'h00000200F : encode_data_b10_r = 'b111111111111110110;
                'h00002000F : encode_data_b10_r = 'b111111111111110111;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h0000000200 : encode_data_b10_r = 'b111010;
                'h0000000020 : encode_data_b10_r = 'b111001;
                'h0000000102 : encode_data_b10_r = 'b1111110010;
                'h0000000201 : encode_data_b10_r = 'b1111110011;
                'h0000000011 : encode_data_b10_r = 'b1111101110;
                'h0000000012 : encode_data_b10_r = 'b1111101111;
                'h0000000021 : encode_data_b10_r = 'b1111110000;
                'h0000000101 : encode_data_b10_r = 'b1111110001;
                'h0000000202 : encode_data_b10_r = 'b11111111000;
                'h0000000022 : encode_data_b10_r = 'b11111110111;
                'h000000010F : encode_data_b10_r = 'b111111111111111010;
                'h000000020F : encode_data_b10_r = 'b111111111111111011;
                'h000000001F : encode_data_b10_r = 'b111111111111111000;
                'h000000002F : encode_data_b10_r = 'b111111111111111001;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd11 : begin
            case(ap_data_i)
                'h00000001001 : encode_data_b10_r = 'b1111110101;
                'h00000000101 : encode_data_b10_r = 'b1111110100;
                'h00000000102 : encode_data_b10_r = 'b11111111001;
                'h00000001002 : encode_data_b10_r = 'b11111111010;
                'h0000000010F : encode_data_b10_r = 'b111111111111111100;
                'h0000000100F : encode_data_b10_r = 'b111111111111111101;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        6'd12 : begin
            case(ap_data_i)
                'h000000001000 : encode_data_b10_r = 'b111011;
                'h000000010000 : encode_data_b10_r = 'b111100;
                'h000000001001 : encode_data_b10_r = 'b1111110110;
                'h000000010001 : encode_data_b10_r = 'b1111110111;
                'h000000001002 : encode_data_b10_r = 'b11111111011;
                'h000000010002 : encode_data_b10_r = 'b11111111100;
                'h00000000100F : encode_data_b10_r = 'b111111111111111110;
                'h00000001000F : encode_data_b10_r = 'b111111111111111111;
                default : encode_data_b10_r = 'b0;
            endcase
        end
        default : encode_data_b10_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
