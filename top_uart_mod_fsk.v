module top_uart_mod_fsk
(
    input clk, reset,
    input rd_uart, wr_uart,
    input [7:0] w_data,
    output tx_full, rx_empty,
    output mosi_dac,
    output cs_dac,
    output sclk_dac
);

wire [7:0] r_data;
wire [11:0] data_sin;
wire [11:0] select;

top_uart top_uart(
    .clk(clk),
    .reset(reset),
    .rd_uart(rd_uart),
    .wr_uart(wr_uart),
    .w_data(w_data),
    .tx_full(tx_full),
    .rx_empty(rx_empty),
    .r_data(r_data)
);

Bit_rate_1Khz Bit_rate_1Khz (
	.data(r_data),
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