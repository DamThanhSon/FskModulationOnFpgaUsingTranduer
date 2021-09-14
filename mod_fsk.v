module mod_fsk(
    input [7:0] data,
	input clk,
	input reset,
	output cs_dac,
	output sclk_dac,
	output mosi_dac 
	);

wire [11:0] data_sin;
wire [11:0] select;

Bit_rate_1Khz Bit_rate_1Khz (
	.data(data),
	.clk(clk),
	.reset(reset),
	.select(select)
	);

sin_data sin_data (
	.clk(clk),
	.reset(reset),
	.select(select),
	.data_sin(data_sin)
	);

dac_out dac_out (
	.clk(clk),
	.reset(reset),
	.data_in(data_sin),
	.mosi_out(mosi_dac),
	.cs_out(cs_dac),
	.sclk_out(sclk_dac)
	);
endmodule