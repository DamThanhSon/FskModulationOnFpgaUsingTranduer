module top_uart
#(
    parameter   DBIT = 8,
    parameter   SB_TICK = 16,
    parameter   DVSR = 163,
    parameter   DVSR_BIT = 8,
    parameter   FIFO_W = 2
)

(
    input clk, reset,
    input rd_uart, wr_uart,
    input [7:0] w_data,
    output tx_full, rx_empty,
    output [7:0] r_data
);

wire tick, rx_done_tick ,  tx_done_tick; 
wire tx_empty, tx_fifo_not_empty; 
wire [7:0]  tx_fifo_out ,  rx_data_out;
wire rx_tx;

mod_m_counter #(
    .M(DVSR),
    .N(DVSR_BIT))
    baud_gen_unit(
    .clk(clk),
    .reset(reset),
    .max_tick(tick),
    .q()
);

uart_rx #(
    .DBIT(DBIT),
    .SB_TICK(SB_TICK))
    uart_rx_unit(
    .clk(clk),
    .reset(reset),
    .rx(rx_tx),
    .s_tick(tick),
    .rx_done_tick(rx_done_tick),
    .dout(rx_data_out)
);

fifo_buffer #(
    .B(DBIT), 
    .W(FIFO_W))
    fifo_buffer_rx_unit(
    .clk(clk),
    .reset(reset),
    .rd(rd_uart),
    .wr(rx_done_tick),
    .w_data(rx_data_out),
    .empty(rx_empty),
    .full(),
    .r_data(r_data)
);

fifo_buffer #(
    .B(DBIT),
    .W(FIFO_W))
    fifo_buffer_tx_unit(
    .clk(clk),
    .reset(reset),
    .rd(tx_done_tick),
    .wr(wr_uart),
	.w_data(w_data),
    .empty(tx_empty),
    .full(tx_full),
    .r_data(tx_fifo_out)
);

uart_tx #(
    .DBIT(DBIT),
    .SB_TICK(SB_TICK))
    uart_tx_unit(
    .clk(clk),
    .reset(reset),
    .tx_start(tx_fifo_not_empty),
    .tx_done_tick(tx_done_tick),
    .tx(rx_tx),
	.din(tx_fifo_out),
	.s_tick(tick)
);
assign tx_fifo_not_empty = tx_empty;
endmodule