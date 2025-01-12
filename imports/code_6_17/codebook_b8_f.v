`timescale 1ns/1ps

module codebook_b8_f#(
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
                'h0F, 'h1F, 'h2F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F, 'h10F, 'h01F, 'h20F, 'h11F, 'h21F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h000F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h0000F, 'h0002F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h00000F, 'h00001F, 'h00002F, 'h00020F, 'h00021F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case (ap_data_i)
                'h000000F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd8 : begin
            case (ap_data_i)
                'h0000000F, 'h0000002F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd9 : begin
            case (ap_data_i)
                'h00000000F, 'h00000001F, 'h00000020F, 'h00000002F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd10 : begin
            case (ap_data_i)
                'h000000000F, 'h000000010F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h0000000002F : encode_match_b8_r = 1'd1;
                default : encode_match_b8_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h00000000020F : encode_match_b8_r = 1'd1;
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
                'h0F : encode_length_b8_r = 9;
                'h1F : encode_length_b8_r = 12;
                'h2F : encode_length_b8_r = 12;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_length_b8_r = 10;

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
                'h000F : encode_length_b8_r = 10;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h0000F : encode_length_b8_r = 10;
                'h0002F : encode_length_b8_r = 13;
                default : encode_length_b8_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h00000F : encode_length_b8_r = 11;

                'h00001F : encode_length_b8_r = 13;
                'h00002F : encode_length_b8_r = 14;
                'h00020F : encode_length_b8_r = 14;
                'h00021F : encode_length_b8_r = 16;
                default : encode_length_b8_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h000000F : encode_length_b8_r = 11;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h0000000F : encode_length_b8_r = 11;
                'h0000002F : encode_length_b8_r = 14;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h00000000F : encode_length_b8_r = 11;
                'h00000001F : encode_length_b8_r = 14;
                'h00000020F : encode_length_b8_r = 14;
                'h00000002F : encode_length_b8_r = 15;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h000000000F : encode_length_b8_r = 12;
                'h000000010F : encode_length_b8_r = 15;
                default : encode_length_b8_r = 0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h0000000002F : encode_length_b8_r = 15;
                default : encode_length_b8_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
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
                'h0F : encode_data_b8_r = 'b111101101;
                'h1F : encode_data_b8_r = 'b111111111000;
                'h2F : encode_data_b8_r = 'b111111111001;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_data_b8_r = 'b1111110000;
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
                'h000F : encode_data_b8_r = 'b1111110101;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h0000F : encode_data_b8_r = 'b1111110110;
                'h0002F : encode_data_b8_r = 'b1111111111010;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd6 : begin
            case(ap_data_i)
                'h00000F : encode_data_b8_r = 'b11111110110;
                'h00001F : encode_data_b8_r = 'b1111111111011;
                'h00002F : encode_data_b8_r = 'b11111111111000;
                'h00020F : encode_data_b8_r = 'b11111111111001;
                'h00021F : encode_data_b8_r = 'b1111111111111111;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h000000F : encode_data_b8_r = 'b11111111001;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h0000000F : encode_data_b8_r = 'b11111111010;
                'h0000002F : encode_data_b8_r = 'b11111111111010;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h00000000F : encode_data_b8_r = 'b11111111011;
                'h00000001F : encode_data_b8_r = 'b11111111111011;
                'h00000020F : encode_data_b8_r = 'b11111111111100;
                'h00000002F : encode_data_b8_r = 'b111111111111011;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h000000000F : encode_data_b8_r = 'b111111111011;
                'h000000010F : encode_data_b8_r = 'b111111111111100;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd11 : begin
            case(ap_data_i)
                'h0000000002F : encode_data_b8_r = 'b111111111111101;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        6'd12 : begin
            case(ap_data_i)
                'h00000000020F : encode_data_b8_r = 'b111111111111110;
                default : encode_data_b8_r = 'b0;
            endcase
        end
        default : encode_data_b8_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
