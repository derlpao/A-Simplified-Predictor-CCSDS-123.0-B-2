`timescale 1ns/1ps

module codebook_b11_f#(
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
                'hF : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F, 'h2F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F, 'h01F, 'h20F, 'h02F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h000F, 'h010F, 'h001F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h0000F, 'h0010F, 'h0100F, 'h0001F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h00000F, 'h00010F, 'h00100F, 'h00001F, 'h01000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case (ap_data_i)
                'h000000F, 'h000010F, 'h000100F, 'h000001F, 
                'h001000F, 'h010000F : encode_match_b11_r = 1'd1;               
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd8 : begin
            case (ap_data_i)
                'h0000000F, 'h0000010F, 'h0000001F, 'h0100000F : encode_match_b11_r = 1'd1;                
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd9 : begin
            case (ap_data_i)
                'h00000000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd10 : begin
            case (ap_data_i)
                'h000000000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h0000000000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h00000000000F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd13 : begin
            case (ap_data_i)
                'h000000000000F, 'h000000000002F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd14 : begin
            case (ap_data_i)
                'h0000000000000F, 'h0000000000020F, 'h0000000000002F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd15 : begin
            case (ap_data_i)
                'h00000000000000F, 'h00000000000200F, 'h00000000000002F : encode_match_b11_r = 1'd1;
                default : encode_match_b11_r = 1'd0;
            endcase
        end
        6'd16 : begin
            case (ap_data_i)
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
                'hF : encode_length_b11_r = 14;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_length_b11_r = 14;
                'h2F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_length_b11_r = 14;
                'h01F : encode_length_b11_r = 19;
                'h20F, 'h02F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h000F : encode_length_b11_r = 14;
                'h010F, 'h001F : encode_length_b11_r = 19;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h0000F : encode_length_b11_r = 14;
                'h0010F, 'h0100F, 'h0001F : encode_length_b11_r = 19;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h00000F : encode_length_b11_r = 14;
                'h00010F, 'h00100F, 'h00001F, 'h01000F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd7 : begin
            case(ap_data_i)
                'h000000F : encode_length_b11_r = 14;
                'h000010F, 'h000100F, 'h000001F, 'h001000F, 'h010000F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd8 : begin
            case(ap_data_i)
                'h0000000F : encode_length_b11_r = 15;
                'h0000010F, 'h0000001F, 'h0100000F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h00000000F : encode_length_b11_r = 15;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h000000000F : encode_length_b11_r = 15;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd11 : begin
            case (ap_data_i)
                'h0000000000F : encode_length_b11_r = 15;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd12 : begin
            case (ap_data_i)
                'h00000000000F : encode_length_b11_r = 15;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd13 : begin
            case(ap_data_i)
                'h000000000000F : encode_length_b11_r = 15;
                'h000000000002F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd14 : begin
            case(ap_data_i)
                'h0000000000000F : encode_length_b11_r = 15;
                'h0000000000020F, 'h0000000000002F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 0;
            endcase
        end
        6'd15 : begin
            case (ap_data_i)
                'h00000000000000F : encode_length_b11_r = 15;
                'h00000000000200F, 'h00000000000002F : encode_length_b11_r = 20;
                default : encode_length_b11_r = 1'd0;
            endcase
        end
        6'd16 : begin
            case (ap_data_i)
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
                'hF : encode_data_b11_r = 'b11111111110100;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_data_b11_r = 'b11111111110101;
                'h2F : encode_data_b11_r = 'b11111111111111101100;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_data_b11_r = 'b11111111110110;
                'h01F : encode_data_b11_r = 'b1111111111111110000;
                'h20F : encode_data_b11_r = 'b11111111111111101110;
                'h02F : encode_data_b11_r = 'b11111111111111101101;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h000F : encode_data_b11_r = 'b11111111110111;
                'h010F : encode_data_b11_r = 'b1111111111111110010;
                'h001F : encode_data_b11_r = 'b1111111111111110001;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h0000F : encode_data_b11_r = 'b11111111111000;
                'h0010F : encode_data_b11_r = 'b1111111111111110100;
                'h0100F : encode_data_b11_r = 'b1111111111111110101;
                'h0001F : encode_data_b11_r = 'b1111111111111110011;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd6 : begin
            case(ap_data_i)
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
                'h0000000F : encode_data_b11_r = 'b111111111110110;
                'h0000010F : encode_data_b11_r = 'b11111111111111111001;
                'h0000001F : encode_data_b11_r = 'b11111111111111111000;
                'h0100000F : encode_data_b11_r = 'b11111111111111111010;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd9 : begin
            case(ap_data_i)
                'h00000000F : encode_data_b11_r = 'b111111111110111;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd10 : begin
            case(ap_data_i)
                'h000000000F : encode_data_b11_r = 'b111111111111000;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd11 : begin
            case(ap_data_i)
                'h0000000000F : encode_data_b11_r = 'b111111111111001;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd12 : begin
            case(ap_data_i)
                'h00000000000F : encode_data_b11_r = 'b111111111111010;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd13 : begin
            case(ap_data_i)
                'h000000000000F : encode_data_b11_r = 'b111111111111011;
                'h000000000002F : encode_data_b11_r = 'b11111111111111111011;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd14 : begin
            case(ap_data_i)
                'h0000000000000F : encode_data_b11_r = 'b111111111111100;
                'h0000000000020F : encode_data_b11_r = 'b11111111111111111101;
                'h0000000000002F : encode_data_b11_r = 'b11111111111111111100;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd15 : begin
            case(ap_data_i)
                'h00000000000000F : encode_data_b11_r = 'b111111111111101;
                'h00000000000200F : encode_data_b11_r = 'b11111111111111111111;
                'h00000000000002F : encode_data_b11_r = 'b11111111111111111110;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        6'd16 : begin
            case(ap_data_i)
                'h000000000000000F : encode_data_b11_r = 'b111111111111110;
                default : encode_data_b11_r = 'b0;
            endcase
        end
        default : encode_data_b11_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
