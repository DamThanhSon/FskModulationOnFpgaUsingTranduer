module chiatan
#(
    parameter heso = 3,
    parameter size = 2
)
(
    input clk,
    input reset,
    output reg clk_out
);

reg [size - 1'b1 : 0] dem;

always @(posedge clk, negedge reset) 
begin
    if(!reset) 
    begin
        clk_out <= 0;
        dem <= 0;
    end
    else if(dem == heso - 1'b1) 
    begin
        dem <= 0;
        clk_out <= !clk_out;
    end
    else 
    begin
        dem <= dem + 1'b1;
    end
end
endmodule
