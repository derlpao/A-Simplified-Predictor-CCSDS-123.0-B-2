`timescale 1ns/1ps

module codebook_b3_f#(
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

reg     [ENCODE_DATALENGTH - 1 : 0]     encode_data_b3_r    ;
reg     [5 : 0]                         encode_length_b3_r  ;
reg                                     encode_match_b3_r   ;

assign encode_data_o    = encode_data_b3_r      ;
assign encode_length_o  = encode_length_b3_r    ;
assign encode_match_o   = encode_match_b3_r     ;

/**************************************************************************/
//codebook_b3 match
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
               'hF : encode_match_b3_r = 1'd1;
                default : encode_match_b3_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F, 'h2F, 'h3F, 'h4F, 'h6F : encode_match_b3_r = 1'd1;
                default : encode_match_b3_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F,'h21F,'h22F,'h31F,'h32F,'h41F,'h23F : encode_match_b3_r = 1'd1;
                default : encode_match_b3_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h001F,'h002F,'h221F,'h211F : encode_match_b3_r = 1'd1;
                default : encode_match_b3_r = 1'd0;
            endcase
        end
        default : encode_match_b3_r = 1'd0;
    endcase
end

//codebook_b3 length
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
                'hF :   encode_length_b3_r = 6;
                default : encode_length_b3_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h0F, 'h2F : encode_length_b3_r = 8;
                'h3F : encode_length_b3_r = 9;
                'h4F : encode_length_b3_r = 10;
                'h6F : encode_length_b3_r = 12;
                default : encode_length_b3_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h00F : encode_length_b3_r = 9;
                'h21F, 'h22F : encode_length_b3_r = 11;
                'h31F, 'h32F, 'h41F, 'h23F : encode_length_b3_r = 12;
                default : encode_length_b3_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h001F, 'h002F : encode_length_b3_r = 12;
                'h221F, 'h211F : encode_length_b3_r = 13;
                default : encode_length_b3_r = 0;
            endcase
        end
        default : encode_length_b3_r = 0;
    endcase
end


//codebook_b3 data
always @(ap_cnt_i, ap_data_i) begin
    case(ap_cnt_i)
        6'd1 : begin
            case(ap_data_i)
               'hF : encode_data_b3_r = 'b101000;
                default : encode_data_b3_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
               'h0F : encode_data_b3_r = 'b11010110;

               'h2F : encode_data_b3_r = 'b11011001;
               
               'h3F : encode_data_b3_r = 'b111011110;
               
               'h4F : encode_data_b3_r = 'b1111101100;

               'h6F : encode_data_b3_r = 'b111111110100;               
                default : encode_data_b3_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
               'h00F : encode_data_b3_r = 'b111100101;
               
               'h21F : encode_data_b3_r = 'b11111101100;
               
               'h22F : encode_data_b3_r = 'b11111101101;
               
               'h31F : encode_data_b3_r = 'b111111110110;
               'h32F : encode_data_b3_r = 'b111111110111;
               'h41F : encode_data_b3_r = 'b111111111000;
               'h23F : encode_data_b3_r = 'b111111110101;
                default : encode_data_b3_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
               'h001F : encode_data_b3_r = 'b111111111001;

               'h002F : encode_data_b3_r = 'b111111111010;

               'h221F : encode_data_b3_r = 'b1111111111111;
               'h211F : encode_data_b3_r = 'b1111111111110;
                default : encode_data_b3_r = 'b0;
            endcase
        end
        default : encode_data_b3_r = 'b0;
    endcase
end
/**************************************************************************/

endmodule
