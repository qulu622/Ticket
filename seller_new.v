module seller(station1,station2,sheet,money,change,sheet_out,clk,reset);

input clk,reset ;
input [2:0] sheet ;
input [3:0] station1,station2 ;
input [4:0] money ;
output reg [6:0] change ;
output reg [2:0] sheet_out ;

reg [3:0] state, next_state ;
reg [6:0] cost, pay, owe ;
reg tmp_cost ;

parameter ONE = 5'd0 , FIVE = 5'd5, TEN = 5'd10, FIFTY = 5'd50; // (1,5,10,50)
parameter ONEs = 3'd1, TWOs = 3'd2, THREEs = 3'd3, FOURs = 3'd4, FIVEs = 3'd5; // (1~5)
parameter S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4, S5 = 3'd5; // (S1~S5)
parameter State1 = 3'd1, State2 = 3'd2, State3 = 3'd3, State4 = 3'd4; 

initial
begin
 state = State1 ;
 next_state = state ;
 cost = 7'd0 ;
 pay = 7'd0 ;
 owe = 7'd0 ;
end


always @(posedge clk or state)    
begin
  if ( sheet != 0 )
    state = next_state;
    
  case(state)
  State1:
  begin
    cost = (station2-station1+1)*5 ;
    tmp_cost = cost ;
    if (  station1 == 0 && station2 == 0 )
    begin
      next_state = State1 ;
      cost = 0 ;
    end
    else
      next_state = State2 ;
  end
  State2:
  begin
    cost = cost*sheet ;
    if ( tmp_cost == cost )
      next_state = State2 ;
    else
      next_state = State3 ;
  end
  State3:
    if ( reset )
    begin
      change = pay ;
      next_state = State1 ;
    end
    else
    begin
      if ( pay < cost )
      begin
        pay = pay + money ;
        owe = cost - pay ;
        next_state = State3 ;
      end
      else
      begin
        next_state = State4;
        owe = 7'd0 ;  
      end
    end
  State4:
  begin
    change = pay-cost ;
    sheet_out = sheet ;
    next_state = State1;
  end
  endcase  
end

endmodule

module test;

reg clk,reset ;
reg [2:0] sheet ;
reg [3:0] station1,station2 ;
reg [4:0] money ;
wire [6:0] change ;
wire [2:0] sheet_out ;

parameter ONE = 5'd0 , FIVE = 5'd5, TEN = 5'd10, FIFTY = 5'd50; // (1,5,10,50)
parameter ONEs = 3'd1, TWOs = 3'd2, THREEs = 3'd3, FOURs = 3'd4, FIVEs = 3'd5; // (1~5)
parameter S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4, S5 = 3'd5; // (S1~S5)

always #5 clk = ~clk ;

initial
  begin
    station1 = 4'd0; station2 = 4'd0; sheet = 3'd0 ; clk = 0 ; money = 5'd0 ; reset = 0 ;
    #10 station1 = S1 ; station2 = S3 ; 
    #10 sheet = THREEs ;
    #10 money = TEN ;
  end
  
seller sell0(station1,station2,sheet,money,change,sheet_out,clk,reset);

endmodule
