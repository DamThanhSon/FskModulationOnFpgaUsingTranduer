module dac_out (
	input clk, 
	input reset,
	input [11:0] data_in,
	output reg mosi_out,
	output reg cs_out,
	output sclk_out
	);
reg [11:0] temp;
reg [4:0] stt;

chiatan
#(
	.heso(2),
	.size(1)
	)
clock_16m(
	.clk(clk),
	.reset(reset),
	.clk_out(clk_16m)
	);

assign sclk_out = clk_16m;

always @(negedge clk_16m or negedge reset) 
begin
	if (!reset) 
	begin
		// reset
		cs_out <= 1;
		stt <= 0;
		mosi_out <= 0;
	end
	else 
	begin
		case (stt)
			0: 
			begin
				cs_out <= 1;
				stt <= 1;
			end
			1: 
			begin
				cs_out <= 0;
				mosi_out <= 1'b0;
				stt <= 2;
			end
			2: 
			begin
				mosi_out <= 1'b0;
				stt <= 3;
				temp <= data_in;
			end
			3: 
			begin
				mosi_out <= 1'b1;
				stt <= 4;
			end
			4: 
			begin
				mosi_out <= 1'b1;
				stt <= 5;
			end	
			5: 
			begin
				mosi_out <= temp[11];
				stt <= 6;
			end
			6: begin
				mosi_out <= temp[10];
				stt <= 7;
			end
			7: 
			begin
				mosi_out <= temp[9];
				stt <= 8;
			end
			8: 
			begin
				mosi_out <= temp[8];
				stt <= 9;
			end
			9: 
			begin
				mosi_out <= temp[7];
				stt <= 10;
			end
			10: 
			begin
				mosi_out <= temp[6];
				stt <= 11;
			end
			11: 
			begin
				mosi_out <= temp[5];
				stt <= 12;
			end
			12: 
			begin
				mosi_out <= temp[4];
				stt <= 13;
			end
			13: 
			begin
				mosi_out <= temp[3];
				stt <= 14;
			end
			14: 
			begin
				mosi_out <= temp[2];
				stt <= 15;
			end
			15: 
			begin
				mosi_out <= temp[1];
				stt <= 16;
			end
			16: 
			begin
				mosi_out <= temp[0];
				stt <= 0;
			end
		endcase
	end
end
endmodule