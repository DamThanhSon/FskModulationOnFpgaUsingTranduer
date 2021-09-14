`timescale 1ns/1ps
module tb_top_uart_mod_fsk();
    reg clk, reset;
    reg rd_uart, wr_uart;
    reg [7:0] w_data;
    wire tx_full, rx_empty;
    wire mosi_dac;
	wire cs_dac;
    wire sclk_dac;

top_uart_mod_fsk uut(
    .clk(clk),
    .reset(reset),
    .rd_uart(rd_uart),
    .wr_uart(wr_uart),
    .w_data(w_data),
    .tx_full(tx_full),
    .rx_empty(rx_empty),
    .mosi_dac(mosi_Dac),
    .sclk_dac(sclk_dac),
    .cs_dac(cs_dac)
);
initial begin
    clk = 0;
    reset = 0;
    w_data = 8'b10101100;
    rd_uart = 0;
    wr_uart = 1;
    #100;
    reset = 1;
    
end
always #5 clk = !clk;
endmodule