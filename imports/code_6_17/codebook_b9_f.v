`timescale 1ns/1ps

module codebook_b9_f#(
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
                'hF : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F, 'h02F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h000F, 'h001F, 'h002F, 'h020F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h0000F, 'h0010F, 'h0200F, 'h0001F, 'h0020F, 'h0002F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h00000F, 'h00100F, 'h00001F, 'h00010F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case (ap_data_i)
                'h000000F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd8 : begin
            case (ap_data_i)
                'h0000000F, 'h0000002F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd9 : begin
            case (ap_data_i)
                'h00000000F, 'h00000002F, 'h00000020F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd10 : begin
            case (ap_data_i)
                'h000000000F, 'h000000200F, 'h000000001F, 'h000000020F, 
                'h000000002F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h0000000000F, 'h0000000001F, 'h0000000010F : encode_match_b9_r = 1'd1;
                default : encode_match_b9_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h00000000001F, 'h00000000010F, 'h00000000100F : encode_match_b9_r = 1'd1;
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
                'hF : encode_length_b9_r = 10;
                default : encode_length_b9_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_length_b9_r = 11;
                default : encode_length_b9_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_length_b9_r = 11;
                'h02F : encode_length_b9_r = 15;
                default : encode_length_b9_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h000F : encode_length_b9_r = 11;
                'h001F : encode_length_b9_r = 15;
                'h002F : encode_length_b9_r = 15;
                'h020F : encode_length_b9_r = 15;
                default : encode_length_b9_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
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
                'h00000F : encode_length_b9_r = 12;
                'h00100F : encode_length_b9_r = 15;
                'h00001F : encode_length_b9_r = 15;
                'h00010F : encode_length_b9_r = 15;
                default : encode_length_b9_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h000000F : encode_length_b9_r = 12;
                default : encode_length_b9_r = 0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h0000000F : encode_length_b9_r = 12;
                'h0000002F : encode_length_b9_r = 16;

                default : encode_length_b9_r = 0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h00000000F : encode_length_b9_r = 12;
                'h00000002F : encode_length_b9_r = 16;
                'h00000020F : encode_length_b9_r = 16;
                default : encode_length_b9_r = 0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
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
                'h0000000000F : encode_length_b9_r = 12;
                'h0000000001F : encode_length_b9_r = 16;
                'h0000000010F : encode_length_b9_r = 16;
                default : encode_length_b9_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
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
                'hF : encode_data_b9_r = 'b1111101000;
                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_data_b9_r = 'b11111111000;
                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_data_b9_r = 'b11111111001;
                'h02F : encode_data_b9_r = 'b111111111110000;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h000F : encode_data_b9_r = 'b11111111010;
                'h001F : encode_data_b9_r = 'b111111111110001;
                'h002F : encode_data_b9_r = 'b111111111110010;
                'h020F : encode_data_b9_r = 'b111111111110011;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
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
                'h00000F : encode_data_b9_r = 'b111111111000;
                'h00100F : encode_data_b9_r = 'b111111111111001;
                'h00001F : encode_data_b9_r = 'b111111111110111;
                'h00010F : encode_data_b9_r = 'b111111111111000;
                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h000000F : encode_data_b9_r = 'b111111111001;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h0000000F : encode_data_b9_r = 'b111111111010;
                'h0000002F : encode_data_b9_r = 'b1111111111110110;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h00000000F : encode_data_b9_r = 'b111111111011;
                'h00000002F : encode_data_b9_r = 'b1111111111110111;
                'h00000020F : encode_data_b9_r = 'b1111111111111000;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
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
                'h0000000000F : encode_data_b9_r = 'b111111111101;
                'h0000000001F : encode_data_b9_r = 'b1111111111111100;
                'h0000000010F : encode_data_b9_r = 'b1111111111111101;

                default : encode_data_b9_r = 'b0;
            endcase
        end
        6'd12 : begin
            case(ap_data_i)
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
