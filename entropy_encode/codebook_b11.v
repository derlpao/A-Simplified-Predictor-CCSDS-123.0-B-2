`timescale 1ns/1ps

module codebook_b11#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b11_r    ;
reg     [5 : 0]                         encode_length_b11_r  ;
reg                                     encode_match_b11_r   ;

assign encode_data_o    = encode_data_b11_r      ;
assign encode_length_o  = encode_length_b11_r    ;
assign encode_match_o   = encode_match_b11_r     ;

/**************************************************************************/
//codebook_b4 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1, 'hF : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h21, 'h22, 'h0F, 'h2F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h002, 'h200, 'h020, 'h201, 'h011, 'h202, 'h012, 'h021, 
                'h022, 'h00F, 'h01F, 'h20F, 'h02F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h0002, 'h0102, 'h0011, 'h0012, 'h0101, 
                'h000F, 'h010F, 'h001F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00002, 'h00102, 'h00011, 'h01001, 'h00012, 'h01002, 
                'h00101, 'h0000F, 'h0010F, 'h0100F, 'h0001F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h000002, 'h000101, 'h000102, 'h000011, 'h001001, 
                'h000012, 'h001002, 'h010001, 'h010002, 'h00000F, 
                'h00010F, 'h00100F, 'h00001F, 'h01000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case (ap_data_i)
                'h0000002, 'h0001000, 'h0010000, 'h0000100, 'h0000101, 'h0000102, 
                'h0000011, 'h0001001, 'h0000012, 'h0001002, 'h0010001, 'h0010002, 
                'h0100001, 'h0100002, 'h000000F, 'h000010F, 'h000100F, 'h000001F, 
                'h001000F, 'h010000F : encode_match_b11_r = 1'd1;               
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd8 : begin
            case (ap_data_i)
                'h00000001, 'h00000002, 'h00000010, 'h01000000, 'h00000100, 'h00000101, 
                'h00000102, 'h00000011, 'h00000012, 'h01000001, 'h01000002, 'h0000000F, 
                'h0000010F, 'h0000001F, 'h0100000F : encode_match_b11_r = 1'd1;                
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd9 : begin
            case (ap_data_i)
                'h000000001, 'h000000002, 'h00000000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd10 : begin
            case (ap_data_i)
                'h0000000001, 'h0000000002, 'h000000000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h00000000001, 'h00000000002, 'h0000000000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h000000000001, 'h00000000000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd13 : begin
            case (ap_data_i)
                'h0000000000001, 'h0000000000021, 'h0000000000022, 'h000000000000F, 
                'h000000000002F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd14 : begin
            case (ap_data_i)
                'h00000000000001, 'h00000000000020, 'h00000000000201, 'h00000000000202, 
                'h00000000000021, 'h00000000000022, 'h0000000000000F, 'h0000000000020F, 
                'h0000000000002F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd15 : begin
            case (ap_data_i)
                'h000000000000001, 'h000000000000002, 'h000000000002000, 'h000000000000020, 
                'h000000000002001, 'h000000000002002, 'h000000000000021, 'h000000000000022, 
                'h00000000000000F, 'h00000000000200F, 'h00000000000002F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd16 : begin
            case (ap_data_i)
                'h0000000000000000, 'h0000000000000001, 'h0000000000000002, 
                'h000000000000000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        default : encode_match_b11_r = 1'd0;
    endcase
end

//codebook_b4 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1 : encode_length_b11_r = 5;
                'hF : encode_length_b11_r = 14;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h21, 'h22 : encode_length_b11_r = 11;
                'h0F : encode_length_b11_r = 14;
                'h2F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h002, 'h200, 'h020 : encode_length_b11_r = 6;
                'h201, 'h011, 'h202, 'h012, 'h021, 'h022 : encode_length_b11_r = 11;
                'h00F : encode_length_b11_r = 14;
                'h01F : encode_length_b11_r = 19;
                'h20F, 'h02F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0002 : encode_length_b11_r = 6;
                'h0102, 'h0011, 'h0012, 'h0101 : encode_length_b11_r = 11;
                'h000F : encode_length_b11_r = 14;
                'h010F, 'h001F : encode_length_b11_r = 19;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h00002 : encode_length_b11_r = 6;
                'h00102, 'h00011, 'h01001, 'h00012, 'h01002, 'h00101 : encode_length_b11_r = 11;
                'h0000F : encode_length_b11_r = 14;
                'h0010F, 'h0100F, 'h0001F : encode_length_b11_r = 19;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h000002 : encode_length_b11_r = 6;
                'h000101, 'h000102, 'h000011, 'h001001, 'h000012, 'h001002, 'h010001, 'h010002 : encode_length_b11_r = 11;
                'h00000F : encode_length_b11_r = 14;
                'h00010F, 'h00100F, 'h00001F, 'h01000F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h0000002, 'h0001000, 'h0010000, 'h0000100 : encode_length_b11_r = 6;
                'h0000101, 'h0000102, 'h0000011, 'h0001001, 'h0000012, 'h0001002, 'h0010001, 'h0010002, 'h0100001, 'h0100002 : encode_length_b11_r = 11;
                'h000000F : encode_length_b11_r = 14;
                'h000010F, 'h000100F, 'h000001F, 'h001000F, 'h010000F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h00000001, 'h00000002, 'h00000010, 'h01000000, 'h00000100 : encode_length_b11_r = 6;
                'h00000101, 'h00000102, 'h00000011, 'h00000012, 'h01000001 : encode_length_b11_r = 11;
                'h01000002 : encode_length_b11_r = 12;
                'h0000000F : encode_length_b11_r = 15;
                'h0000010F, 'h0000001F, 'h0100000F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h000000001, 'h000000002 : encode_length_b11_r = 6;
                'h00000000F : encode_length_b11_r = 15;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h0000000001, 'h0000000002 : encode_length_b11_r = 6;
                'h000000000F : encode_length_b11_r = 15;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h00000000001, 'h00000000002 : encode_length_b11_r = 6;
                'h0000000000F : encode_length_b11_r = 15;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h000000000001 : encode_length_b11_r = 6;
                'h00000000000F : encode_length_b11_r = 15;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd13 : begin
            case(ap_data_i)
                'h0000000000001 : encode_length_b11_r = 6;
                'h0000000000021, 'h0000000000022 : encode_length_b11_r = 12;
                'h000000000000F : encode_length_b11_r = 15;
                'h000000000002F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd14 : begin
            case(ap_data_i)
                'h00000000000001 : encode_length_b11_r = 6;
                'h00000000000020 : encode_length_b11_r = 7;
                'h00000000000201, 'h00000000000202, 'h00000000000021, 'h00000000000022 : encode_length_b11_r = 12;
                'h0000000000000F : encode_length_b11_r = 15;
                'h0000000000020F, 'h0000000000002F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd15 : begin
            case (ap_data_i)
                'h000000000000001 : encode_length_b11_r = 6;
                'h000000000000002, 'h000000000002000, 'h000000000000020 : encode_length_b11_r = 7;
                'h000000000002001, 'h000000000002002, 'h000000000000021, 'h000000000000022 : encode_length_b11_r = 12;
                'h00000000000000F : encode_length_b11_r = 15;
                'h00000000000200F, 'h00000000000002F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd16 : begin
            case (ap_data_i)
                'h0000000000000000 : encode_length_b11_r = 1;
                'h0000000000000001 : encode_length_b11_r = 6;
                'h0000000000000002 : encode_length_b11_r = 7;
                'h000000000000000F : encode_length_b11_r = 15;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        default : encode_length_b11_r = 0;
    endcase
end

//codebook_b4 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'h1 : encode_data_b11_r = 'b10000;
                'hF : encode_data_b11_r = 'b11111111110100;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h21 : encode_data_b11_r = 'b11111010000;
                'h22 : encode_data_b11_r = 'b11111010001;
                'h0F : encode_data_b11_r = 'b11111111110101;
                'h2F : encode_data_b11_r = 'b11111111111111101100;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h002 : encode_data_b11_r = 'b100010;
                'h200 : encode_data_b11_r = 'b100100;
                'h020 : encode_data_b11_r = 'b100011;
                'h201 : encode_data_b11_r = 'b11111010110;
                'h011 : encode_data_b11_r = 'b11111010010;
                'h202 : encode_data_b11_r = 'b11111010111;
                'h012 : encode_data_b11_r = 'b11111010011;
                'h021 : encode_data_b11_r = 'b11111010100;
                'h022 : encode_data_b11_r = 'b11111010101;
                'h00F : encode_data_b11_r = 'b11111111110110;
                'h01F : encode_data_b11_r = 'b1111111111111110000;
                'h20F : encode_data_b11_r = 'b11111111111111101110;
                'h02F : encode_data_b11_r = 'b11111111111111101101;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h0002 : encode_data_b11_r = 'b100101;
                'h0102 : encode_data_b11_r = 'b11111011011;
                'h0011 : encode_data_b11_r = 'b11111011000;
                'h0012 : encode_data_b11_r = 'b11111011001;
                'h0101 : encode_data_b11_r = 'b11111011010;
                'h000F : encode_data_b11_r = 'b11111111110111;
                'h010F : encode_data_b11_r = 'b1111111111111110010;
                'h001F : encode_data_b11_r = 'b1111111111111110001;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h00002 : encode_data_b11_r = 'b100110;
                'h00102 : encode_data_b11_r = 'b11111011111;
                'h00011 : encode_data_b11_r = 'b11111011100;
                'h01001 : encode_data_b11_r = 'b11111100000;
                'h00012 : encode_data_b11_r = 'b11111011101;
                'h01002 : encode_data_b11_r = 'b11111100001;
                'h00101 : encode_data_b11_r = 'b11111011110;
                'h0000F : encode_data_b11_r = 'b11111111111000;
                'h0010F : encode_data_b11_r = 'b1111111111111110100;
                'h0100F : encode_data_b11_r = 'b1111111111111110101;
                'h0001F : encode_data_b11_r = 'b1111111111111110011;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd6 : begin
            case(ap_data_i)
                'h000002 : encode_data_b11_r = 'b100111;
                'h000101 : encode_data_b11_r = 'b11111100100;
                'h000102 : encode_data_b11_r = 'b11111100101;
                'h000011 : encode_data_b11_r = 'b11111100010;
                'h001001 : encode_data_b11_r = 'b11111100110;
                'h000012 : encode_data_b11_r = 'b11111100011;
                'h001002 : encode_data_b11_r = 'b11111100111;
                'h010001 : encode_data_b11_r = 'b11111101000;
                'h010002 : encode_data_b11_r = 'b11111101001;
                'h00000F : encode_data_b11_r = 'b11111111111001;
                'h00010F : encode_data_b11_r = 'b11111111111111110000;
                'h00100F : encode_data_b11_r = 'b11111111111111110001;
                'h00001F : encode_data_b11_r = 'b11111111111111101111;
                'h01000F : encode_data_b11_r = 'b11111111111111110010;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h0000002 : encode_data_b11_r = 'b101000;
                'h0001000 : encode_data_b11_r = 'b101010;
                'h0010000 : encode_data_b11_r = 'b101011;
                'h0000100 : encode_data_b11_r = 'b101001;
                'h0000101 : encode_data_b11_r = 'b11111101100;
                'h0000102 : encode_data_b11_r = 'b11111101101;
                'h0000011 : encode_data_b11_r = 'b11111101010;
                'h0001001 : encode_data_b11_r = 'b11111101110;
                'h0000012 : encode_data_b11_r = 'b11111101011;
                'h0001002 : encode_data_b11_r = 'b11111101111;
                'h0010001 : encode_data_b11_r = 'b11111110000;
                'h0010002 : encode_data_b11_r = 'b11111110001;
                'h0100001 : encode_data_b11_r = 'b11111110010;
                'h0100002 : encode_data_b11_r = 'b11111110011;
                'h000000F : encode_data_b11_r = 'b11111111111010;
                'h000010F : encode_data_b11_r = 'b11111111111111110100;
                'h000100F : encode_data_b11_r = 'b11111111111111110101;
                'h000001F : encode_data_b11_r = 'b11111111111111110011;
                'h001000F : encode_data_b11_r = 'b11111111111111110110;
                'h010000F : encode_data_b11_r = 'b11111111111111110111;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h00000001 : encode_data_b11_r = 'b101100;
                'h00000002 : encode_data_b11_r = 'b101101;
                'h00000010 : encode_data_b11_r = 'b101110;
                'h01000000 : encode_data_b11_r = 'b110000;
                'h00000100 : encode_data_b11_r = 'b101111;
                'h00000101 : encode_data_b11_r = 'b11111110110;
                'h00000102 : encode_data_b11_r = 'b11111110111;
                'h00000011 : encode_data_b11_r = 'b11111110100;
                'h00000012 : encode_data_b11_r = 'b11111110101;
                'h01000001 : encode_data_b11_r = 'b11111111000;
                'h01000002 : encode_data_b11_r = 'b111111110010;
                'h0000000F : encode_data_b11_r = 'b111111111110110;
                'h0000010F : encode_data_b11_r = 'b11111111111111111001;
                'h0000001F : encode_data_b11_r = 'b11111111111111111000;
                'h0100000F : encode_data_b11_r = 'b11111111111111111010;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h000000001 : encode_data_b11_r = 'b110001;
                'h000000002 : encode_data_b11_r = 'b110010;
                'h00000000F : encode_data_b11_r = 'b111111111110111;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h0000000001 : encode_data_b11_r = 'b110011;
                'h0000000002 : encode_data_b11_r = 'b110100;
                'h000000000F : encode_data_b11_r = 'b111111111111000;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd11 : begin
            case(ap_data_i)
                'h00000000001 : encode_data_b11_r = 'b110101;
                'h00000000002 : encode_data_b11_r = 'b110110;
                'h0000000000F : encode_data_b11_r = 'b111111111111001;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd12 : begin
            case(ap_data_i)
                'h000000000001 : encode_data_b11_r = 'b110111;
                'h00000000000F : encode_data_b11_r = 'b111111111111010;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd13 : begin
            case(ap_data_i)
                'h0000000000001 : encode_data_b11_r = 'b111000;
                'h0000000000021 : encode_data_b11_r = 'b111111110011;
                'h0000000000022 : encode_data_b11_r = 'b111111110100;
                'h000000000000F : encode_data_b11_r = 'b111111111111011;
                'h000000000002F : encode_data_b11_r = 'b11111111111111111011;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd14 : begin
            case(ap_data_i)
                'h00000000000001 : encode_data_b11_r = 'b111001;
                'h00000000000020 : encode_data_b11_r = 'b1111000;
                'h00000000000201 : encode_data_b11_r = 'b111111110111;
                'h00000000000202 : encode_data_b11_r = 'b111111111000;
                'h00000000000021 : encode_data_b11_r = 'b111111110101;
                'h00000000000022 : encode_data_b11_r = 'b111111110110;
                'h0000000000000F : encode_data_b11_r = 'b111111111111100;
                'h0000000000020F : encode_data_b11_r = 'b11111111111111111101;
                'h0000000000002F : encode_data_b11_r = 'b11111111111111111100;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd15 : begin
            case(ap_data_i)
                'h000000000000001 : encode_data_b11_r = 'b111010;
                'h000000000000002 : encode_data_b11_r = 'b1111001;
                'h000000000002000 : encode_data_b11_r = 'b1111011;
                'h000000000000020 : encode_data_b11_r = 'b1111010;
                'h000000000002001 : encode_data_b11_r = 'b111111111011;
                'h000000000002002 : encode_data_b11_r = 'b111111111100;
                'h000000000000021 : encode_data_b11_r = 'b111111111001;
                'h000000000000022 : encode_data_b11_r = 'b111111111010;
                'h00000000000000F : encode_data_b11_r = 'b111111111111101;
                'h00000000000200F : encode_data_b11_r = 'b11111111111111111111;
                'h00000000000002F : encode_data_b11_r = 'b11111111111111111110;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd16 : begin
            case(ap_data_i)
                'h0000000000000000 : encode_data_b11_r = 'b0;
                'h0000000000000001 : encode_data_b11_r = 'b111011;
                'h0000000000000002 : encode_data_b11_r = 'b1111100;
                'h000000000000000F : encode_data_b11_r = 'b111111111111110;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        default : encode_data_b11_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
