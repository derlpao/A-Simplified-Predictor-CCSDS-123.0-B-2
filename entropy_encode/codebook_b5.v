`timescale 1ns/1ps

module codebook_b5#(
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
                'h0, 'h1, 'h3, 'h4, 'hF : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h23, 'h2F : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h222, 'h203, 'h204, 'h240, 'h213, 'h214, 'h20F, 
                'h223, 'h224, 'h241, 'h242, 'h21F, 'h22F, 'h243, 
                'h244, 'h24F : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd4 : begin
            case (ap_data_i)
                'h2000, 'h2021, 'h2022, 'h2201, 'h2202, 'h2210, 'h2101, 'h2102, 
                'h2110, 'h2011, 'h2012, 'h2120, 'h2211, 'h2212, 'h2003, 'h2111, 
                'h2112, 'h2121, 'h2122, 'h2004, 'h2023, 'h2024, 'h2203, 'h2204, 
                'h200F, 'h2103, 'h2104, 'h2013, 'h2014, 'h2123, 'h2124, 'h2213, 
                'h2214, 'h2113, 'h2114, 'h202F, 'h220F, 'h210F, 'h201F, 'h212F, 
                'h221F, 'h211F : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd5 : begin
            case (ap_data_i)
                'h20200, 'h22000, 'h20020, 'h20201, 'h20202, 'h22001, 
                'h22002, 'h20011, 'h20012, 'h20021, 'h20022, 'h21001, 
                'h21002, 'h20101, 'h20102, 'h20203, 'h20204, 'h22003, 
                'h22004, 'h20013, 'h20014, 'h20023, 'h20024, 'h21003, 
                'h21004, 'h20103, 'h20104, 'h2020F, 'h2200F, 'h2001F, 
                'h2002F, 'h2100F, 'h2010F : encode_match_b5_r = 1'd1;
                default : encode_match_b5_r = 1'd0;
            endcase
        end
        6'd6 : begin
            case (ap_data_i)
                'h200100, 'h210000, 'h201000, 'h200101, 'h200102, 'h210001, 'h210002, 
                'h201001, 'h201002, 'h200103, 'h200104, 'h210003, 'h210004, 'h201003, 
                'h201004, 'h20010F, 'h21000F, 'h20100F : encode_match_b5_r = 1'd1;
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
                'h0 : encode_length_b5_r = 1;
                'h1 : encode_length_b5_r = 2;
                'h3 : encode_length_b5_r = 5;
                'h4 : encode_length_b5_r = 5;
                'hF : encode_length_b5_r = 7;
                default : encode_length_b5_r = 0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h23 : encode_length_b5_r = 7;
                'h2F : encode_length_b5_r = 9;
                default : encode_length_b5_r = 0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h222 : encode_length_b5_r = 7;
                'h203 : encode_length_b5_r = 8;
                'h204 : encode_length_b5_r = 9;
                'h240 : encode_length_b5_r = 9;
                'h213 : encode_length_b5_r = 10;
                'h214 : encode_length_b5_r = 10;
                'h20F : encode_length_b5_r = 10;
                'h223 : encode_length_b5_r = 10;
                'h224 : encode_length_b5_r = 10;
                'h241 : encode_length_b5_r = 10;
                'h242 : encode_length_b5_r = 10;
                'h21F : encode_length_b5_r = 11;
                'h22F : encode_length_b5_r = 12;
                'h243 : encode_length_b5_r = 13;
                'h244 : encode_length_b5_r = 13;
                'h24F : encode_length_b5_r = 14;
                default : encode_length_b5_r = 0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h2000 : encode_length_b5_r = 5;
                'h2021 : encode_length_b5_r = 8;
                'h2022 : encode_length_b5_r = 8;
                'h2201 : encode_length_b5_r = 8;
                'h2202 : encode_length_b5_r = 8;
                'h2210 : encode_length_b5_r = 8;
                'h2101 : encode_length_b5_r = 8;
                'h2102 : encode_length_b5_r = 8;
                'h2110 : encode_length_b5_r = 8;
                'h2011 : encode_length_b5_r = 8;
                'h2012 : encode_length_b5_r = 8;
                'h2120 : encode_length_b5_r = 8;
                'h2211 : encode_length_b5_r = 9;
                'h2212 : encode_length_b5_r = 9;
                'h2003 : encode_length_b5_r = 9;
                'h2111 : encode_length_b5_r = 9;
                'h2112 : encode_length_b5_r = 9;
                'h2121 : encode_length_b5_r = 9;
                'h2122 : encode_length_b5_r = 9;
                'h2004 : encode_length_b5_r = 10;
                'h2023 : encode_length_b5_r = 11;
                'h2024 : encode_length_b5_r = 11;
                'h2203 : encode_length_b5_r = 11;
                'h2204 : encode_length_b5_r = 11;
                'h200F : encode_length_b5_r = 11;
                'h2103 : encode_length_b5_r = 11;
                'h2104 : encode_length_b5_r = 11;
                'h2013 : encode_length_b5_r = 11;
                'h2014 : encode_length_b5_r = 11;
                'h2123 : encode_length_b5_r = 12;
                'h2124 : encode_length_b5_r = 12;
                'h2213 : encode_length_b5_r = 12;
                'h2214 : encode_length_b5_r = 12;
                'h2113 : encode_length_b5_r = 12;
                'h2114 : encode_length_b5_r = 12;
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
                'h20200 : encode_length_b5_r = 8;
                'h22000 : encode_length_b5_r = 8;
                'h20020 : encode_length_b5_r = 8;
                'h20201 : encode_length_b5_r = 9;
                'h20202 : encode_length_b5_r = 9;
                'h22001 : encode_length_b5_r = 9;
                'h22002 : encode_length_b5_r = 9;
                'h20011 : encode_length_b5_r = 9;
                'h20012 : encode_length_b5_r = 9;
                'h20021 : encode_length_b5_r = 9;
                'h20022 : encode_length_b5_r = 9;
                'h21001 : encode_length_b5_r = 9;
                'h21002 : encode_length_b5_r = 9;
                'h20101 : encode_length_b5_r = 9;
                'h20102 : encode_length_b5_r = 9;
                'h20203 : encode_length_b5_r = 12;
                'h20204 : encode_length_b5_r = 12;
                'h22003 : encode_length_b5_r = 12;
                'h22004 : encode_length_b5_r = 12;
                'h20013 : encode_length_b5_r = 12;
                'h20014 : encode_length_b5_r = 12;
                'h20023 : encode_length_b5_r = 12;
                'h20024 : encode_length_b5_r = 12;
                'h21003 : encode_length_b5_r = 12;
                'h21004 : encode_length_b5_r = 12;
                'h20103 : encode_length_b5_r = 12;
                'h20104 : encode_length_b5_r = 12;
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
                'h200100 : encode_length_b5_r = 9;
                'h210000 : encode_length_b5_r = 9;
                'h201000 : encode_length_b5_r = 9;
                'h200101 : encode_length_b5_r = 10;
                'h200102 : encode_length_b5_r = 10;
                'h210001 : encode_length_b5_r = 10;
                'h210002 : encode_length_b5_r = 10;
                'h201001 : encode_length_b5_r = 10;
                'h201002 : encode_length_b5_r = 10;
                'h200103 : encode_length_b5_r = 13;
                'h200104 : encode_length_b5_r = 13;
                'h210003 : encode_length_b5_r = 13;
                'h210004 : encode_length_b5_r = 13;
                'h201003 : encode_length_b5_r = 13;
                'h201004 : encode_length_b5_r = 13;
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
                'h0 : encode_data_b5_r = 'b0;
                'h1 : encode_data_b5_r = 'b10;
                'h3 : encode_data_b5_r = 'b11000;
                'h4 : encode_data_b5_r = 'b11001;
                'hF : encode_data_b5_r = 'b1101100;
                default : encode_data_b5_r = 'b0;
            endcase
        end
        6'd2 : begin
            case(ap_data_i)
                'h23 : encode_data_b5_r = 'b1101101;
                'h2F : encode_data_b5_r = 'b111011010;
                default : encode_data_b5_r = 'b0;
            endcase
        end
        6'd3 : begin
            case(ap_data_i)
                'h222 : encode_data_b5_r = 'b1101110;
                'h203 : encode_data_b5_r = 'b11011110;
                'h204 : encode_data_b5_r = 'b111011011;
                'h240 : encode_data_b5_r = 'b111011100;
                'h213 : encode_data_b5_r = 'b1111100111;
                'h214 : encode_data_b5_r = 'b1111101000;
                'h20F : encode_data_b5_r = 'b1111100110;
                'h223 : encode_data_b5_r = 'b1111101001;
                'h224 : encode_data_b5_r = 'b1111101010;
                'h241 : encode_data_b5_r = 'b1111101011;
                'h242 : encode_data_b5_r = 'b1111101100;
                'h21F : encode_data_b5_r = 'b11111101000;
                'h22F : encode_data_b5_r = 'b111111100100;
                'h243 : encode_data_b5_r = 'b1111111101110;
                'h244 : encode_data_b5_r = 'b1111111101111;
                'h24F : encode_data_b5_r = 'b11111111110100;
                default : encode_data_b5_r = 'b0;
            endcase
        end
        6'd4 : begin
            case(ap_data_i)
                'h2000 : encode_data_b5_r = 'b11010;
                'h2021 : encode_data_b5_r = 'b11100001;
                'h2022 : encode_data_b5_r = 'b11100010;
                'h2201 : encode_data_b5_r = 'b11100111;
                'h2202 : encode_data_b5_r = 'b11101000;
                'h2210 : encode_data_b5_r = 'b11101001;
                'h2101 : encode_data_b5_r = 'b11100011;
                'h2102 : encode_data_b5_r = 'b11100100;
                'h2110 : encode_data_b5_r = 'b11100101;
                'h2011 : encode_data_b5_r = 'b11011111;
                'h2012 : encode_data_b5_r = 'b11100000;
                'h2120 : encode_data_b5_r = 'b11100110;
                'h2211 : encode_data_b5_r = 'b111100010;
                'h2212 : encode_data_b5_r = 'b111100011;
                'h2003 : encode_data_b5_r = 'b111011101;
                'h2111 : encode_data_b5_r = 'b111011110;
                'h2112 : encode_data_b5_r = 'b111011111;
                'h2121 : encode_data_b5_r = 'b111100000;
                'h2122 : encode_data_b5_r = 'b111100001;
                'h2004 : encode_data_b5_r = 'b1111101101;
                'h2023 : encode_data_b5_r = 'b11111101100;
                'h2024 : encode_data_b5_r = 'b11111101101;
                'h2203 : encode_data_b5_r = 'b11111110000;
                'h2204 : encode_data_b5_r = 'b11111110001;
                'h200F : encode_data_b5_r = 'b11111101001;
                'h2103 : encode_data_b5_r = 'b11111101110;
                'h2104 : encode_data_b5_r = 'b11111101111;
                'h2013 : encode_data_b5_r = 'b11111101010;
                'h2014 : encode_data_b5_r = 'b11111101011;
                'h2123 : encode_data_b5_r = 'b111111100111;
                'h2124 : encode_data_b5_r = 'b111111101000;
                'h2213 : encode_data_b5_r = 'b111111101001;
                'h2214 : encode_data_b5_r = 'b111111101010;
                'h2113 : encode_data_b5_r = 'b111111100101;
                'h2114 : encode_data_b5_r = 'b111111100110;
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
                'h20200 : encode_data_b5_r = 'b11101011;
                'h22000 : encode_data_b5_r = 'b11101100;
                'h20020 : encode_data_b5_r = 'b11101010;
                'h20201 : encode_data_b5_r = 'b111101010;
                'h20202 : encode_data_b5_r = 'b111101011;
                'h22001 : encode_data_b5_r = 'b111101110;
                'h22002 : encode_data_b5_r = 'b111101111;
                'h20011 : encode_data_b5_r = 'b111100100;
                'h20012 : encode_data_b5_r = 'b111100101;
                'h20021 : encode_data_b5_r = 'b111100110;
                'h20022 : encode_data_b5_r = 'b111100111;
                'h21001 : encode_data_b5_r = 'b111101100;
                'h21002 : encode_data_b5_r = 'b111101101;
                'h20101 : encode_data_b5_r = 'b111101000;
                'h20102 : encode_data_b5_r = 'b111101001;
                'h20203 : encode_data_b5_r = 'b111111110001;
                'h20204 : encode_data_b5_r = 'b111111110010;
                'h22003 : encode_data_b5_r = 'b111111110101;
                'h22004 : encode_data_b5_r = 'b111111110110;
                'h20013 : encode_data_b5_r = 'b111111101011;
                'h20014 : encode_data_b5_r = 'b111111101100;
                'h20023 : encode_data_b5_r = 'b111111101101;
                'h20024 : encode_data_b5_r = 'b111111101110;
                'h21003 : encode_data_b5_r = 'b111111110011;
                'h21004 : encode_data_b5_r = 'b111111110100;
                'h20103 : encode_data_b5_r = 'b111111101111;
                'h20104 : encode_data_b5_r = 'b111111110000;
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
                'h200100 : encode_data_b5_r = 'b111110000;
                'h210000 : encode_data_b5_r = 'b111110010;
                'h201000 : encode_data_b5_r = 'b111110001;
                'h200101 : encode_data_b5_r = 'b1111101110;
                'h200102 : encode_data_b5_r = 'b1111101111;
                'h210001 : encode_data_b5_r = 'b1111110010;
                'h210002 : encode_data_b5_r = 'b1111110011;
                'h201001 : encode_data_b5_r = 'b1111110000;
                'h201002 : encode_data_b5_r = 'b1111110001;
                'h200103 : encode_data_b5_r = 'b1111111110100;
                'h200104 : encode_data_b5_r = 'b1111111110101;
                'h210003 : encode_data_b5_r = 'b1111111111000;
                'h210004 : encode_data_b5_r = 'b1111111111001;
                'h201003 : encode_data_b5_r = 'b1111111110110;
                'h201004 : encode_data_b5_r = 'b1111111110111;
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
