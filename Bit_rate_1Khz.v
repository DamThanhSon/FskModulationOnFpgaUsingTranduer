// Bit out = header(8'b11111110) + data (8bit)
module Bit_rate_1Khz(
    input [7:0] data,// dữ liệu đầu vào 8 bit
    input clk,
    input reset,
    output [11:0] select // đầu ra select 12 bit
);

chiatan
#(
    .heso(50000),
    .size(16)
)
clock_1K
(
    .clk(clk),
    .reset(reset),
    .clk_out(clk_1Khz)
);

reg [7:0] temp;
reg [3:0] stt;
reg bit_out;

always @(posedge clk_1Khz, negedge reset) 
begin
    if(~reset) 
	begin
        stt <= 0;
        bit_out <= 1;
    end
    else 
	begin
        case(stt)
			//bit 8
            0: 
			begin
				stt <= 1;
				bit_out <= 1;
			end
			//bit 7
			1: 
			begin 
				stt <= 2;
				bit_out <= 1;
			end
			2: 
			begin 
				stt <= 3;
				bit_out <= 1;
			end
			3: 
			begin
				stt <= 4;
				bit_out <= 1;
			end
			4: 
			begin 
				stt <= 5;
				bit_out <= 1;
			end
			5: 
			begin 
				stt <= 6;
				bit_out <= 1;
			end
			6: 
			begin
				stt <= 7;
				bit_out <= 1;
			end
			7: 
			begin
				stt <= 8;
				bit_out <= 0;
				temp <= data;
			end
			8: 
			begin
				stt <= 9;
				bit_out <= temp[7];
			end
			9: 
			begin
				stt <= 10;
				bit_out <= temp[6];
			end
			10: 
			begin
				stt <= 11;
				bit_out <= temp[5];
			end
			11: 
			begin
				stt <= 12;
				bit_out <= temp[4];
			end
			12: 
			begin
				stt <= 13;
				bit_out <= temp[3];
			end
			13: 
			begin
				stt <= 14;
				bit_out <= temp[2];
			end
			14: 
			begin
				stt <= 15;
				bit_out <= temp[1];
			end
			15: 
			begin
				stt <= 0;
				bit_out <= temp[0];
			end
		endcase
            
    end
end
assign select = (bit_out) ? 12'b111111111111 : 12'b000000000000;
endmodule