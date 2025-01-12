`timescale 1ns/1ps

module codebook_b4_f#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b4_r    ;
reg     [5 : 0]                         encode_length_b4_r  ;
reg                                     encode_match_b4_r   ;

assign encode_data_o    = encode_data_b4_r      ;
assign encode_length_o  = encode_length_b4_r    ;
assign encode_match_o   = encode_match_b4_r     ;

/**************************************************************************/
//codebook_b4 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_match_b4_r = 1'd1;
                default : encode_match_b4_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_match_b4_r = 1'd1;
                default : encode_match_b4_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F, 'h02F, 'h01F, 'h03F, 'h04F : encode_match_b4_r = 1'd1;
                default : encode_match_b4_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h001F, 'h010F, 'h012F, 'h021F, 'h022F, 'h011F : encode_match_b4_r = 1'd1;
                default : encode_match_b4_r = 1'd0;
            endcase
        end
        default : encode_match_b4_r = 1'd0;
    endcase
end

//codebook_b4 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_length_b4_r = 8;
                default : encode_length_b4_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_length_b4_r = 9;
                default : encode_length_b4_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_length_b4_r = 10;
                'h02F, 'h01F : encode_length_b4_r = 11;
                'h03F, 'h04F : encode_length_b4_r = 13;                
                default : encode_length_b4_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h001F, 'h010F : encode_length_b4_r = 12;
                'h012F, 'h021F, 'h022F, 'h011F : encode_length_b4_r = 13;                
                default : encode_length_b4_r = 0;
            endcase
        end
        default : encode_length_b4_r = 0;
    endcase
end

//codebook_b4 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_data_b4_r = 'b11100100        ;
                default : encode_data_b4_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F : encode_data_b4_r = 'b111101110      ;                
                default : encode_data_b4_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_data_b4_r = 'b1111101011        ;     
   
                'h02F : encode_data_b4_r = 'b11111110110       ;     
                'h01F : encode_data_b4_r = 'b11111110100       ;     
   
                'h03F : encode_data_b4_r = 'b1111111110100     ;     

                'h04F : encode_data_b4_r = 'b1111111110110     ;     
                default : encode_data_b4_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h001F : encode_data_b4_r = 'b111111110011     ;

                'h010F : encode_data_b4_r = 'b111111110110     ;

                'h012F : encode_data_b4_r = 'b1111111111010    ;

                'h021F : encode_data_b4_r = 'b1111111111100    ;

                'h022F : encode_data_b4_r = 'b1111111111111    ;
                'h011F : encode_data_b4_r = 'b1111111111000    ;
                default : encode_data_b4_r = 'b0;
            endcase
        end
        default : encode_data_b4_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
