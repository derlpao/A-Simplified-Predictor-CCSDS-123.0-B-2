`timescale 1ns/1ps

module codebook_b9#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b9_r    ;
reg     [5 : 0]                         encode_length_b9_r  ;
reg                                     encode_match_b9_r   ;

assign encode_data_o    = encode_data_b9_r      ;
assign encode_length_o  = encode_length_b9_r    ;
assign encode_match_o   = encode_match_b9_r     ;

/**************************************************************************/
//codebook_b4 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1, 'h2, 'hF : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h01, 'h0F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h021, 'h022, 'h00F, 'h02F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h0011, 'h0012, 'h0021, 'h0201, 'h0022, 'h0202, 'h000F, 
                'h001F, 'h002F, 'h020F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00200, 'h02000, 'h00002, 'h00020, 'h00101, 'h00011, 'h00102, 
                'h00201, 'h00202, 'h02001, 'h02002, 'h00012, 'h00021, 'h00022, 
                'h0000F, 'h0010F, 'h0200F, 'h0001F, 'h0020F, 'h0002F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h001000, 'h000001, 'h000002, 'h000010, 'h000100, 
                'h001001, 'h001002, 'h000011, 'h000012, 'h000101, 
                'h000102, 'h00000F, 'h00100F, 'h00001F, 'h00010F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case (ap_data_i)
                'h0000001, 'h000000F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd8 : begin
            case (ap_data_i)
                'h00000001, 'h00000021, 'h00000022, 'h0000000F, 'h0000002F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd9 : begin
            case (ap_data_i)
                'h000000021, 'h000000201, 'h000000022, 'h000000202, 
                'h00000000F, 'h00000002F, 'h00000020F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd10 : begin
            case (ap_data_i)
                'h0000002000, 'h0000000002, 'h0000000020, 'h0000000200, 
                'h0000000011, 'h0000002001, 'h0000002002, 'h0000000012, 
                'h0000000021, 'h0000000022, 'h0000000201, 'h0000000202, 
                'h000000000F, 'h000000200F, 'h000000001F, 'h000000020F, 
                'h000000002F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h00000000000, 'h00000000002, 'h00000000101, 'h00000000011, 
                'h00000000012, 'h00000000102, 'h0000000000F, 'h0000000001F, 
                'h0000000010F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h000000000010, 'h000000000100, 'h000000001000, 'h000000000011, 
                'h000000000012, 'h000000000101, 'h000000000102, 'h000000001001, 
                'h000000001002, 'h00000000001F, 'h00000000010F, 'h00000000100F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        default : encode_match_b9_r = 1'd0;
    endcase
end

//codebook_b4 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1 : encode_length_b9_r = 4;
                'h2 : encode_length_b9_r = 4;
                'hF : encode_length_b9_r = 10;

                default : encode_length_b9_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h01 : encode_length_b9_r = 4;
                'h0F : encode_length_b9_r = 11;

                default : encode_length_b9_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h021 : encode_length_b9_r = 8;
                'h022 : encode_length_b9_r = 9;
                'h00F : encode_length_b9_r = 11;
                'h02F : encode_length_b9_r = 15;

                default : encode_length_b9_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0011 : encode_length_b9_r = 8;
                'h0012 : encode_length_b9_r = 8;
                'h0021 : encode_length_b9_r = 8;
                'h0201 : encode_length_b9_r = 8;
                'h0022 : encode_length_b9_r = 9;
                'h0202 : encode_length_b9_r = 9;
                'h000F : encode_length_b9_r = 11;
                'h001F : encode_length_b9_r = 15;
                'h002F : encode_length_b9_r = 15;
                'h020F : encode_length_b9_r = 15;

                default : encode_length_b9_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00200 : encode_length_b9_r = 5;
                'h02000 : encode_length_b9_r = 5;
                'h00002 : encode_length_b9_r = 5;
                'h00020 : encode_length_b9_r = 5;
                'h00101 : encode_length_b9_r = 8;
                'h00011 : encode_length_b9_r = 8;
                'h00102 : encode_length_b9_r = 9;
                'h00201 : encode_length_b9_r = 9;
                'h00202 : encode_length_b9_r = 9;
                'h02001 : encode_length_b9_r = 9;
                'h02002 : encode_length_b9_r = 9;
                'h00012 : encode_length_b9_r = 9;
                'h00021 : encode_length_b9_r = 9;
                'h00022 : encode_length_b9_r = 9;
                'h0000F : encode_length_b9_r = 11;
                'h0010F : encode_length_b9_r = 15;
                'h0200F : encode_length_b9_r = 15;
                'h0001F : encode_length_b9_r = 15;
                'h0020F : encode_length_b9_r = 16;
                'h0002F : encode_length_b9_r = 16;

                default : encode_length_b9_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h001000 : encode_length_b9_r = 5;
                'h000001 : encode_length_b9_r = 5;
                'h000002 : encode_length_b9_r = 5;
                'h000010 : encode_length_b9_r = 5;
                'h000100 : encode_length_b9_r = 5;
                'h001001 : encode_length_b9_r = 9;
                'h001002 : encode_length_b9_r = 9;
                'h000011 : encode_length_b9_r = 9;
                'h000012 : encode_length_b9_r = 9;
                'h000101 : encode_length_b9_r = 9;
                'h000102 : encode_length_b9_r = 9;
                'h00000F : encode_length_b9_r = 12;
                'h00100F : encode_length_b9_r = 15;
                'h00001F : encode_length_b9_r = 15;
                'h00010F : encode_length_b9_r = 15;

                default : encode_length_b9_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h0000001 : encode_length_b9_r = 5;
                'h000000F : encode_length_b9_r = 12;

                default : encode_length_b9_r = 0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h00000001 : encode_length_b9_r = 5;
                'h00000021 : encode_length_b9_r = 9;
                'h00000022 : encode_length_b9_r = 10;
                'h0000000F : encode_length_b9_r = 12;
                'h0000002F : encode_length_b9_r = 16;

                default : encode_length_b9_r = 0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h000000021 : encode_length_b9_r = 9;
                'h000000201 : encode_length_b9_r = 9;
                'h000000022 : encode_length_b9_r = 10;
                'h000000202 : encode_length_b9_r = 10;
                'h00000000F : encode_length_b9_r = 12;
                'h00000002F : encode_length_b9_r = 16;
                'h00000020F : encode_length_b9_r = 16;

                default : encode_length_b9_r = 0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h0000002000 : encode_length_b9_r = 6;
                'h0000000002 : encode_length_b9_r = 6;
                'h0000000020 : encode_length_b9_r = 6;
                'h0000000200 : encode_length_b9_r = 6;
                'h0000000011 : encode_length_b9_r = 9;
                'h0000002001 : encode_length_b9_r = 10;
                'h0000002002 : encode_length_b9_r = 10;
                'h0000000012 : encode_length_b9_r = 10;
                'h0000000021 : encode_length_b9_r = 10;
                'h0000000022 : encode_length_b9_r = 10;
                'h0000000201 : encode_length_b9_r = 10;
                'h0000000202 : encode_length_b9_r = 10;
                'h000000000F : encode_length_b9_r = 12;
                'h000000200F : encode_length_b9_r = 16;
                'h000000001F : encode_length_b9_r = 16;
                'h000000020F : encode_length_b9_r = 16;
                'h000000002F : encode_length_b9_r = 17;

                default : encode_length_b9_r = 0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h00000000000 : encode_length_b9_r = 2;
                'h00000000002 : encode_length_b9_r = 6;
                'h00000000101 : encode_length_b9_r = 9;
                'h00000000011 : encode_length_b9_r = 10;
                'h00000000012 : encode_length_b9_r = 10;
                'h00000000102 : encode_length_b9_r = 10;
                'h0000000000F : encode_length_b9_r = 12;
                'h0000000001F : encode_length_b9_r = 16;
                'h0000000010F : encode_length_b9_r = 16;

                default : encode_length_b9_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h000000000010 : encode_length_b9_r = 6;
                'h000000000100 : encode_length_b9_r = 6;
                'h000000001000 : encode_length_b9_r = 6;
                'h000000000011 : encode_length_b9_r = 10;
                'h000000000012 : encode_length_b9_r = 10;
                'h000000000101 : encode_length_b9_r = 10;
                'h000000000102 : encode_length_b9_r = 10;
                'h000000001001 : encode_length_b9_r = 10;
                'h000000001002 : encode_length_b9_r = 10;
                'h00000000001F : encode_length_b9_r = 17;
                'h00000000010F : encode_length_b9_r = 17;
                'h00000000100F : encode_length_b9_r = 17;
                default : encode_length_b9_r = 1'd0;
            endcase
        end

        default : encode_length_b9_r = 0;
    endcase
end

//codebook_b4 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1 : encode_data_b9_r = 'b0100;
                'h2 : encode_data_b9_r = 'b0101;
                'hF : encode_data_b9_r = 'b1111101000;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h01 : encode_data_b9_r = 'b0110;
                'h0F : encode_data_b9_r = 'b11111111000;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h021 : encode_data_b9_r = 'b11101000;
                'h022 : encode_data_b9_r = 'b111011110;
                'h00F : encode_data_b9_r = 'b11111111001;
                'h02F : encode_data_b9_r = 'b111111111110000;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0011 : encode_data_b9_r = 'b11101001;
                'h0012 : encode_data_b9_r = 'b11101010;
                'h0021 : encode_data_b9_r = 'b11101011;
                'h0201 : encode_data_b9_r = 'b11101100;
                'h0022 : encode_data_b9_r = 'b111011111;
                'h0202 : encode_data_b9_r = 'b111100000;
                'h000F : encode_data_b9_r = 'b11111111010;
                'h001F : encode_data_b9_r = 'b111111111110001;
                'h002F : encode_data_b9_r = 'b111111111110010;
                'h020F : encode_data_b9_r = 'b111111111110011;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h00200 : encode_data_b9_r = 'b10000;
                'h02000 : encode_data_b9_r = 'b10001;
                'h00002 : encode_data_b9_r = 'b01110;
                'h00020 : encode_data_b9_r = 'b01111;
                'h00101 : encode_data_b9_r = 'b11101110;
                'h00011 : encode_data_b9_r = 'b11101101;
                'h00102 : encode_data_b9_r = 'b111100100;
                'h00201 : encode_data_b9_r = 'b111100101;
                'h00202 : encode_data_b9_r = 'b111100110;
                'h02001 : encode_data_b9_r = 'b111100111;
                'h02002 : encode_data_b9_r = 'b111101000;
                'h00012 : encode_data_b9_r = 'b111100001;
                'h00021 : encode_data_b9_r = 'b111100010;
                'h00022 : encode_data_b9_r = 'b111100011;
                'h0000F : encode_data_b9_r = 'b11111111011;
                'h0010F : encode_data_b9_r = 'b111111111110101;
                'h0200F : encode_data_b9_r = 'b111111111110110;
                'h0001F : encode_data_b9_r = 'b111111111110100;
                'h0020F : encode_data_b9_r = 'b1111111111110101;
                'h0002F : encode_data_b9_r = 'b1111111111110100;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd6 : begin
            case(ap_data_i)
                'h001000 : encode_data_b9_r = 'b10110;
                'h000001 : encode_data_b9_r = 'b10010;
                'h000002 : encode_data_b9_r = 'b10011;
                'h000010 : encode_data_b9_r = 'b10100;
                'h000100 : encode_data_b9_r = 'b10101;
                'h001001 : encode_data_b9_r = 'b111101101;
                'h001002 : encode_data_b9_r = 'b111101110;
                'h000011 : encode_data_b9_r = 'b111101001;
                'h000012 : encode_data_b9_r = 'b111101010;
                'h000101 : encode_data_b9_r = 'b111101011;
                'h000102 : encode_data_b9_r = 'b111101100;
                'h00000F : encode_data_b9_r = 'b111111111000;
                'h00100F : encode_data_b9_r = 'b111111111111001;
                'h00001F : encode_data_b9_r = 'b111111111110111;
                'h00010F : encode_data_b9_r = 'b111111111111000;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h0000001 : encode_data_b9_r = 'b10111;
                'h000000F : encode_data_b9_r = 'b111111111001;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h00000001 : encode_data_b9_r = 'b11000;
                'h00000021 : encode_data_b9_r = 'b111101111;
                'h00000022 : encode_data_b9_r = 'b1111101001;
                'h0000000F : encode_data_b9_r = 'b111111111010;
                'h0000002F : encode_data_b9_r = 'b1111111111110110;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h000000021 : encode_data_b9_r = 'b111110000;
                'h000000201 : encode_data_b9_r = 'b111110001;
                'h000000022 : encode_data_b9_r = 'b1111101010;
                'h000000202 : encode_data_b9_r = 'b1111101011;
                'h00000000F : encode_data_b9_r = 'b111111111011;
                'h00000002F : encode_data_b9_r = 'b1111111111110111;
                'h00000020F : encode_data_b9_r = 'b1111111111111000;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h0000002000 : encode_data_b9_r = 'b110101;
                'h0000000002 : encode_data_b9_r = 'b110010;
                'h0000000020 : encode_data_b9_r = 'b110011;
                'h0000000200 : encode_data_b9_r = 'b110100;
                'h0000000011 : encode_data_b9_r = 'b111110010;
                'h0000002001 : encode_data_b9_r = 'b1111110001;
                'h0000002002 : encode_data_b9_r = 'b1111110010;
                'h0000000012 : encode_data_b9_r = 'b1111101100;
                'h0000000021 : encode_data_b9_r = 'b1111101101;
                'h0000000022 : encode_data_b9_r = 'b1111101110;
                'h0000000201 : encode_data_b9_r = 'b1111101111;
                'h0000000202 : encode_data_b9_r = 'b1111110000;
                'h000000000F : encode_data_b9_r = 'b111111111100;
                'h000000200F : encode_data_b9_r = 'b1111111111111011;
                'h000000001F : encode_data_b9_r = 'b1111111111111001;
                'h000000020F : encode_data_b9_r = 'b1111111111111010;
                'h000000002F : encode_data_b9_r = 'b11111111111111100;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd11 : begin
            case(ap_data_i)
                'h00000000000 : encode_data_b9_r = 'b00;
                'h00000000002 : encode_data_b9_r = 'b110110;
                'h00000000101 : encode_data_b9_r = 'b111110011;
                'h00000000011 : encode_data_b9_r = 'b1111110011;
                'h00000000012 : encode_data_b9_r = 'b1111110100;
                'h00000000102 : encode_data_b9_r = 'b1111110101;
                'h0000000000F : encode_data_b9_r = 'b111111111101;
                'h0000000001F : encode_data_b9_r = 'b1111111111111100;
                'h0000000010F : encode_data_b9_r = 'b1111111111111101;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd12 : begin
            case(ap_data_i)
                'h000000000010 : encode_data_b9_r = 'b110111;
                'h000000000100 : encode_data_b9_r = 'b111000;
                'h000000001000 : encode_data_b9_r = 'b111001;
                'h000000000011 : encode_data_b9_r = 'b1111110110;
                'h000000000012 : encode_data_b9_r = 'b1111110111;
                'h000000000101 : encode_data_b9_r = 'b1111111000;
                'h000000000102 : encode_data_b9_r = 'b1111111001;
                'h000000001001 : encode_data_b9_r = 'b1111111010;
                'h000000001002 : encode_data_b9_r = 'b1111111011;
                'h00000000001F : encode_data_b9_r = 'b11111111111111101;
                'h00000000010F : encode_data_b9_r = 'b11111111111111110;
                'h00000000100F : encode_data_b9_r = 'b11111111111111111;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        default : encode_data_b9_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
