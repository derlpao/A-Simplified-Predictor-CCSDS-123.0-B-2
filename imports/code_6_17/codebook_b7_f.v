`timescale 1ns/1ps

module codebook_b7_f#(
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
                'hF : encode_match_b7_r = 1'd1;
                default : encode_match_b7_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F, 'h1F, 'h3F : encode_match_b7_r = 1'd1;
                default : encode_match_b7_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h10F, 'h02F, 'h01F, 'h11F : encode_match_b7_r = 1'd1;
                default : encode_match_b7_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h010F, 'h100F, 'h022F, 'h112F : encode_match_b7_r = 1'd1;
                default : encode_match_b7_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h1001F, 'h0101F, 'h0102F, 'h1002F : encode_match_b7_r = 1'd1;
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
                'hF : encode_length_b7_r = 10;
                default : encode_length_b7_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_length_b7_r = 11;

                'h1F : encode_length_b7_r = 13;

                'h3F : encode_length_b7_r = 18;
                default : encode_length_b7_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h10F : encode_length_b7_r = 14;
                'h02F : encode_length_b7_r = 14;

                'h01F : encode_length_b7_r = 14;
                'h11F : encode_length_b7_r = 16;
                default : encode_length_b7_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h010F : encode_length_b7_r = 14;
                'h100F : encode_length_b7_r = 14;

                'h022F : encode_length_b7_r = 16;

                'h112F : encode_length_b7_r = 18;
                default : encode_length_b7_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
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
                'hF : encode_data_b7_r = 'b1111110110;
                default : encode_data_b7_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_data_b7_r = 'b11111110010;

                'h1F : encode_data_b7_r = 'b1111111111000;

                'h3F : encode_data_b7_r = 'b111111111111111110;
                default : encode_data_b7_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h10F : encode_data_b7_r = 'b11111111110100;
                'h02F : encode_data_b7_r = 'b11111111110011;

                'h01F : encode_data_b7_r = 'b11111111110010;
                'h11F : encode_data_b7_r = 'b1111111111111001;

                default : encode_data_b7_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h010F : encode_data_b7_r = 'b11111111110111;
                'h100F : encode_data_b7_r = 'b11111111111000;

                'h022F : encode_data_b7_r = 'b1111111111111010;

                'h112F : encode_data_b7_r = 'b111111111111111111;
                default : encode_data_b7_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
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
