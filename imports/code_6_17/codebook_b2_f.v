`timescale 1ns/1ps

module codebook_b2_f#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b2_r    ;
reg     [5 : 0]                         encode_length_b2_r  ;
reg                                     encode_match_b2_r   ;

assign encode_data_o    = encode_data_b2_r      ;
assign encode_length_o  = encode_length_b2_r    ;
assign encode_match_o   = encode_match_b2_r     ;

/**************************************************************************/
//codebook_b2 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_match_b2_r = 1'd1;
                default : encode_match_b2_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h1F,'h2F,'h5F,'h6F : encode_match_b2_r = 1'd1;
                default : encode_match_b2_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h11F,'h20F,'h12F,'h21F,
                'h14F,'h24F,'h13F,'h23F : encode_match_b2_r = 1'd1;
                default : encode_match_b2_r = 1'd0;
            endcase
        end
        default : encode_match_b2_r = 1'd0;
    endcase
end

//codebook_b2 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF :   encode_length_b2_r = 6;
                default : encode_length_b2_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h1F,'h2F : encode_length_b2_r = 9;
                'h5F,'h6F : encode_length_b2_r = 11;
                default : encode_length_b2_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h11F,'h20F,'h12F,'h21F : encode_length_b2_r = 11;
                'h14F,'h24F,'h13F,'h23F : encode_length_b2_r = 12;
                default : encode_length_b2_r = 0;
            endcase
        end
        default : encode_length_b2_r = 0;
    endcase
end

//codebook_b2 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF : encode_data_b2_r = 'b101000;                
                default : encode_data_b2_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h1F : encode_data_b2_r = 'b111011111   ;
                
                'h2F : encode_data_b2_r = 'b111100001   ;
                
                'h5F : encode_data_b2_r = 'b11111101010 ;

                'h6F : encode_data_b2_r = 'b11111101101 ;
                default : encode_data_b2_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h11F : encode_data_b2_r = 'b11111110000   ;
                
                'h20F : encode_data_b2_r = 'b11111110110   ;
                
                'h12F : encode_data_b2_r = 'b11111110011   ;
                
                'h21F : encode_data_b2_r = 'b11111111001   ;
                
                'h14F : encode_data_b2_r = 'b111111111001  ;
                
                'h24F : encode_data_b2_r = 'b111111111111  ;
                
                'h13F : encode_data_b2_r = 'b111111110110  ;
                
                'h23F : encode_data_b2_r = 'b111111111100  ;
                default : encode_data_b2_r = 'b0;
            endcase
        end
        default : encode_data_b2_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
