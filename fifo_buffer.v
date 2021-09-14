module fifo_buffer

#(
    parameter B = 8,// number of bits in a word
    parameter W = 4 // number of address bits
)

(
    input clk, reset,
    input rd, wr,
    input [7:0] w_data,
    output empty, full,
    output [7:0] r_data
);

reg [B-1:0] array_reg [2**W-1:0];
reg [W-1:0] w_ptr_reg, w_ptr_next, w_ptr_succ; 
reg [W-1:0] r_ptr_reg, r_ptr_next, r_ptr_succ;
reg full_reg, empty_reg, full_next, empty_next;

wire wr_en;

// hoạt động của con trỏ viết
always @(posedge clk) 
begin
    if(wr_en)
        array_reg[w_ptr_reg] <= w_data;
end

assign r_data = array_reg[r_ptr_reg];
assign wr_en = wr & ~full_reg;

//fifo logic
always @(posedge clk, negedge reset) 
begin
    if(~reset)
        begin
            w_ptr_reg <= 0;
            r_ptr_reg <= 0;
            full_reg <= 1'b0;
            empty_reg <= 1'b1; 
        end
    else 
        begin
            w_ptr_reg <= w_ptr_next;
            r_ptr_reg <= r_ptr_next;
            full_reg <= full_next;
            empty_reg <= empty_next;
        end
end

//trạng thái của con trỏ ghi và đọc
always @(*) 
begin
    w_ptr_succ = w_ptr_reg + 1'b1;
    r_ptr_succ = r_ptr_reg + 1'b1;
    w_ptr_next = w_ptr_reg;
    r_ptr_next = r_ptr_reg;
    full_next = full_reg;
    empty_next = empty_reg;
    case({wr,rd})
        2'b01: //read
            if(~empty_reg) //not empty
                begin
                    r_ptr_next = r_ptr_succ;
                    full_next = 1'b0;
                    if(r_ptr_succ == w_ptr_reg)
                        empty_next = 1'b1;
                end
        2'b10:  //write
            if(~full_reg) //not full
                begin
                    w_ptr_next = w_ptr_succ;
                    empty_next = 1'b0;
                    if(w_ptr_succ == r_ptr_reg)
                    full_next = 1'b1;
                end
        2'b11: 
            begin
                w_ptr_next = w_ptr_succ;
                r_ptr_next = r_ptr_succ;
            end
    endcase
end

assign full = full_reg;
assign empty = empty_reg;
endmodule