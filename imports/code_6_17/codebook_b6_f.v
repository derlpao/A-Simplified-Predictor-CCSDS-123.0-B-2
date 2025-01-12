`timescale 1ns/1ps

module codebook_b6_f#(
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
                'hF : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F, 'h1F, 'h2F, 'h3F : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F, 'h02F, 'h20F, 'h11F : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h000F, 'h001F, 'h021F, 'h201F, 'h110F : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h0001F, 'h0002F, 'h0010F, 'h2010F : encode_match_b6_r = 1'd1;
                default : encode_match_b6_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h00010F, 'h00020F : encode_match_b6_r = 1'd1;
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
                'hF : encode_length_b6_r = 9;
                default : encode_length_b6_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_length_b6_r = 9;
                
                'h1F : encode_length_b6_r = 11;
                'h2F : encode_length_b6_r = 11;
                
                'h3F : encode_length_b6_r = 15;
                default : encode_length_b6_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_length_b6_r = 10;
                
                'h02F : encode_length_b6_r = 12;
                'h20F : encode_length_b6_r = 12;
                
                'h11F : encode_length_b6_r = 13;
                default : encode_length_b6_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h000F : encode_length_b6_r = 11;
                
                'h001F : encode_length_b6_r = 13;
                'h021F : encode_length_b6_r = 14;
                'h201F : encode_length_b6_r = 14;
                'h110F : encode_length_b6_r = 14;
                default : encode_length_b6_r = 0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h0001F : encode_length_b6_r = 13;
                'h0002F : encode_length_b6_r = 13;
                'h0010F : encode_length_b6_r = 13;
                'h2010F : encode_length_b6_r = 15;
                default : encode_length_b6_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
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
                'hF : encode_data_b6_r = 'b111101100;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_data_b6_r = 'b111101101;
                
                'h1F : encode_data_b6_r = 'b11111101100;
                'h2F : encode_data_b6_r = 'b11111101101;
                
                'h3F : encode_data_b6_r = 'b111111111111110;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_data_b6_r = 'b1111110000;
                
                'h02F : encode_data_b6_r = 'b111111101100;
                'h20F : encode_data_b6_r = 'b111111101110;
                
                'h11F : encode_data_b6_r = 'b1111111110110;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h000F : encode_data_b6_r = 'b11111101111;
                
                'h001F : encode_data_b6_r = 'b1111111110111;
                'h021F : encode_data_b6_r = 'b11111111111010;
                'h201F : encode_data_b6_r = 'b11111111111100;
                'h110F : encode_data_b6_r = 'b11111111111011;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd5 : begin
            case(ap_data_i)
                'h0001F : encode_data_b6_r = 'b1111111111000;
                'h0002F : encode_data_b6_r = 'b1111111111001;
                'h0010F : encode_data_b6_r = 'b1111111111010;
                'h2010F : encode_data_b6_r = 'b111111111111111;
                default : encode_data_b6_r = 'b0;
            endcase
        end
        6'd6 : begin
            case(ap_data_i)
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
