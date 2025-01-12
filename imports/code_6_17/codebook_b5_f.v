`timescale 1ns/1ps

module codebook_b5_f#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b5_r    ;
reg     [5 : 0]                         encode_length_b5_r  ;
reg                                     encode_match_b5_r   ;

assign encode_data_o    = encode_data_b5_r      ;
assign encode_length_o  = encode_length_b5_r    ;
assign encode_match_o   = encode_match_b5_r     ;

/**************************************************************************/
//codebook_b4 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h2F : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h20F, 'h21F, 'h22F, 'h24F : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h200F, 'h202F, 'h220F, 'h210F, 'h201F, 'h212F, 
                'h221F, 'h211F : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h2020F, 'h2200F, 'h2001F, 
                'h2002F, 'h2100F, 'h2010F : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h20010F, 'h21000F, 'h20100F : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        default : encode_match_b5_r = 1'd0;
    endcase
end

//codebook_b4 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_length_b5_r = 7;
                default : encode_length_b5_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h2F : encode_length_b5_r = 9;
                default : encode_length_b5_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h20F : encode_length_b5_r = 10;

                'h21F : encode_length_b5_r = 11;
                'h22F : encode_length_b5_r = 12;

                'h24F : encode_length_b5_r = 14;
                default : encode_length_b5_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h200F : encode_length_b5_r = 11;

                'h202F : encode_length_b5_r = 13;
                'h220F : encode_length_b5_r = 13;
                'h210F : encode_length_b5_r = 13;
                'h201F : encode_length_b5_r = 13;
                'h212F : encode_length_b5_r = 14;
                'h221F : encode_length_b5_r = 14;
                'h211F : encode_length_b5_r = 14;
                default : encode_length_b5_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h2020F : encode_length_b5_r = 14;
                'h2200F : encode_length_b5_r = 14;
                'h2001F : encode_length_b5_r = 14;
                'h2002F : encode_length_b5_r = 14;
                'h2100F : encode_length_b5_r = 14;
                'h2010F : encode_length_b5_r = 14;
                default : encode_length_b5_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h20010F : encode_length_b5_r = 14;
                'h21000F : encode_length_b5_r = 15;
                'h20100F : encode_length_b5_r = 15;
                default : encode_length_b5_r = 1'd0;
            endcase
        end
        default : encode_length_b5_r = 0;
    endcase
end

//codebook_b4 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_data_b5_r = 'b1101100;
                default : encode_data_b5_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h2F : encode_data_b5_r = 'b111011010;
                default : encode_data_b5_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h20F : encode_data_b5_r = 'b1111100110;

                'h21F : encode_data_b5_r = 'b11111101000;
                'h22F : encode_data_b5_r = 'b111111100100;

                'h24F : encode_data_b5_r = 'b11111111110100;
                default : encode_data_b5_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h200F : encode_data_b5_r = 'b11111101001;

                'h202F : encode_data_b5_r = 'b1111111110001;
                'h220F : encode_data_b5_r = 'b1111111110011;
                'h210F : encode_data_b5_r = 'b1111111110010;
                'h201F : encode_data_b5_r = 'b1111111110000;
                'h212F : encode_data_b5_r = 'b11111111110110;
                'h221F : encode_data_b5_r = 'b11111111110111;
                'h211F : encode_data_b5_r = 'b11111111110101;
                default : encode_data_b5_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h2020F : encode_data_b5_r = 'b11111111111011;
                'h2200F : encode_data_b5_r = 'b11111111111101;
                'h2001F : encode_data_b5_r = 'b11111111111000;
                'h2002F : encode_data_b5_r = 'b11111111111001;
                'h2100F : encode_data_b5_r = 'b11111111111100;
                'h2010F : encode_data_b5_r = 'b11111111111010;
                default : encode_data_b5_r = 'b0;
            endcase
        end
        6'd6 : begin
            case(ap_data_i)
                'h20010F : encode_data_b5_r = 'b11111111111110;
                'h21000F : encode_data_b5_r = 'b111111111111111;
                'h20100F : encode_data_b5_r = 'b111111111111110;
                default : encode_data_b5_r = 'b0;
            endcase
        end
        default : encode_data_b5_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
