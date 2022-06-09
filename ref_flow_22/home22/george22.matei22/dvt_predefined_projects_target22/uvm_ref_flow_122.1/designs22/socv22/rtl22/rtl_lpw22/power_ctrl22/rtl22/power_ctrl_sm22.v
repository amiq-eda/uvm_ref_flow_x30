//File22 name   : power_ctrl_sm22.v
//Title22       : Power22 Controller22 state machine22
//Created22     : 1999
//Description22 : State22 machine22 of power22 controller22
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
module power_ctrl_sm22 (

    // Clocks22 & Reset22
    pclk22,
    nprst22,

    // Register Control22 inputs22
    L1_module_req22,
    set_status_module22,
    clr_status_module22,

    // Module22 control22 outputs22
    rstn_non_srpg_module22,
    gate_clk_module22,
    isolate_module22,
    save_edge22,
    restore_edge22,
    pwr1_on22,
    pwr2_on22

);

input    pclk22;
input    nprst22;

input    L1_module_req22;
output   set_status_module22;
output   clr_status_module22;
    
output   rstn_non_srpg_module22;
output   gate_clk_module22;
output   isolate_module22;
output   pwr1_on22;
output   pwr2_on22;
output save_edge22;
output restore_edge22;

wire    set_status_module22;
wire    clr_status_module22;

wire    rstn_non_srpg_module22;
reg     gate_clk_module22;
reg     isolate_module22;
reg     pwr1_on22;
reg     pwr2_on22;

reg save_edge22;

reg restore_edge22;
   
// FSM22 state
reg  [3:0] currentState22, nextState22;
reg     rstn_non_srpg22;
reg [4:0] trans_cnt22;

parameter Init22 = 0; 
parameter Clk_off22 = 1; 
parameter Wait122 = 2; 
parameter Isolate22 = 3; 
parameter Save_edge22 = 4; 
parameter Pre_pwr_off22 = 5; 
parameter Pwr_off22 = 6; 
parameter Pwr_on122 = 7; 
parameter Pwr_on222 = 8; 
parameter Restore_edge22 = 9; 
parameter Wait222 = 10; 
parameter De_isolate22 = 11; 
parameter Clk_on22 = 12; 
parameter Wait322 = 13; 
parameter Rst_clr22 = 14;


// Power22 Shut22 Off22 State22 Machine22

// FSM22 combinational22 process
always @  (*)
  begin
    case (currentState22)

      // Commence22 PSO22 once22 the L122 req bit is set.
      Init22:
        if (L1_module_req22 == 1'b1)
          nextState22 = Clk_off22;         // Gate22 the module's clocks22 off22
        else
          nextState22 = Init22;            // Keep22 waiting22 in Init22 state
        
      Clk_off22 :
        nextState22 = Wait122;             // Wait22 for one cycle
 
      Wait122  :                         // Wait22 for clk22 gating22 to take22 effect
        nextState22 = Isolate22;           // Start22 the isolation22 process
          
      Isolate22 :
        nextState22 = Save_edge22;
        
      Save_edge22 :
        nextState22 = Pre_pwr_off22;

      Pre_pwr_off22 :
        nextState22 = Pwr_off22;
      // Exit22 PSO22 once22 the L122 req bit is clear.

      Pwr_off22 :
        if (L1_module_req22 == 1'b0)
          nextState22 = Pwr_on122;         // Resume22 power22 if the L1_module_req22 bit is cleared22
        else
          nextState22 = Pwr_off22;         // Wait22 until the L1_module_req22 bit is cleared22
        
      Pwr_on122 :
        nextState22 = Pwr_on222;
          
      Pwr_on222 :
        if(trans_cnt22 == 5'd28)
          nextState22 = Restore_edge22;
        else 
          nextState22 = Pwr_on222;
          
      Restore_edge22 :
        nextState22 = Wait222;

      Wait222 :
        nextState22 = De_isolate22;
          
      De_isolate22 :
        nextState22 = Clk_on22;
          
      Clk_on22 :
        nextState22 = Wait322;
          
      Wait322  :                         // Wait22 for clock22 to resume
        nextState22 = Rst_clr22 ;     
 
      Rst_clr22 :
        nextState22 = Init22;
        
      default  :                       // Catch22 all
        nextState22 = Init22; 
        
    endcase
  end


  // Signals22 Sequential22 process - gate_clk_module22
always @ (posedge pclk22 or negedge nprst22)
  begin
    if (~nprst22)
      gate_clk_module22 <= 1'b0;
    else 
      if (nextState22 == Clk_on22 | nextState22 == Wait322 | nextState22 == Rst_clr22 | 
          nextState22 == Init22)
          gate_clk_module22 <= 1'b0;
      else
          gate_clk_module22 <= 1'b1;
  end

// Signals22 Sequential22 process - rstn_non_srpg22
always @ (posedge pclk22 or negedge nprst22)
  begin
    if (~nprst22)
      rstn_non_srpg22 <= 1'b0;
    else
      if ( nextState22 == Init22 | nextState22 == Clk_off22 | nextState22 == Wait122 | 
           nextState22 == Isolate22 | nextState22 == Save_edge22 | nextState22 == Pre_pwr_off22 | nextState22 == Rst_clr22)
        rstn_non_srpg22 <= 1'b1;
      else
        rstn_non_srpg22 <= 1'b0;
   end


// Signals22 Sequential22 process - pwr1_on22 & pwr2_on22
always @ (posedge pclk22 or negedge nprst22)
  begin
    if (~nprst22)
      pwr1_on22 <=  1'b1;  // power22 gates22 1 & 2 are on
    else
      if (nextState22 == Pwr_off22 )
        pwr1_on22 <= 1'b0;  // shut22 off22 both power22 gates22 1 & 2
      else
        pwr1_on22 <= 1'b1;
  end


// Signals22 Sequential22 process - pwr1_on22 & pwr2_on22
always @ (posedge pclk22 or negedge nprst22)
  begin
    if (~nprst22)
       pwr2_on22 <= 1'b1;      // power22 gates22 1 & 2 are on
    else
      if (nextState22 == Pwr_off22 | nextState22 == Pwr_on122)
        pwr2_on22 <= 1'b0;     // shut22 off22 both power22 gates22 1 & 2
      else
        pwr2_on22 <= 1'b1;
   end


// Signals22 Sequential22 process - isolate_module22 
always @ (posedge pclk22 or negedge nprst22)
  begin
    if (~nprst22)
        isolate_module22 <= 1'b0;
    else
      if (nextState22 == Isolate22 | nextState22 == Save_edge22 | nextState22 == Pre_pwr_off22 |  nextState22 == Pwr_off22 | nextState22 == Pwr_on122 |
          nextState22 == Pwr_on222 | nextState22 == Restore_edge22 | nextState22 == Wait222)
         isolate_module22 <= 1'b1;       // Activate22 the isolate22 and retain22 signals22
      else
         isolate_module22 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk22 or negedge nprst22)
  begin
    if (~nprst22)
        save_edge22 <= 1'b0;
    else
      if (nextState22 == Save_edge22 )
         save_edge22 <= 1'b1;       // Activate22 the isolate22 and retain22 signals22
      else
         save_edge22 <= 1'b0;        
   end    
// stabilising22 count
wire restore_change22;
assign restore_change22 = (nextState22 == Pwr_on222) ? 1'b1: 1'b0;

always @ (posedge pclk22 or negedge nprst22)
  begin
    if (~nprst22)
      trans_cnt22 <= 0;
    else if (trans_cnt22 > 0)
      trans_cnt22  <= trans_cnt22 + 1;
    else if (restore_change22)
      trans_cnt22  <= trans_cnt22 + 1;
  end

// enabling restore22 edge
always @ (posedge pclk22 or negedge nprst22)
  begin
    if (~nprst22)
        restore_edge22 <= 1'b0;
    else
      if (nextState22 == Restore_edge22)
         restore_edge22 <= 1'b1;       // Activate22 the isolate22 and retain22 signals22
      else
         restore_edge22 <= 1'b0;        
   end    


// FSM22 Sequential22 process
always @ (posedge pclk22 or negedge nprst22)
  begin
    if (~nprst22)
      currentState22 <= Init22;
    else
      currentState22 <= nextState22;
  end


// Reset22 for non-SRPG22 FFs22 is a combination22 of the nprst22 and the reset during PSO22
assign  rstn_non_srpg_module22 = rstn_non_srpg22 & nprst22;

assign  set_status_module22 = (nextState22 == Clk_off22);    // Set the L122 status bit  
assign  clr_status_module22 = (currentState22 == Rst_clr22); // Clear the L122 status bit  
  

`ifdef LP_ABV_ON22

// psl22 default clock22 = (posedge pclk22);

// Never22 have the set and clear status signals22 both set
// psl22 output_no_set_and_clear22 : assert never {set_status_module22 & clr_status_module22};



// Isolate22 signal22 should become22 active on the 
// Next22 clock22 after Gate22 signal22 is activated22
// psl22 output_pd_seq22:
//    assert always
//	  {rose22(gate_clk_module22)} |=> {[*1]; {rose22(isolate_module22)} }
//    abort22(~nprst22);
//
//
//
// Reset22 signal22 for Non22-SRPG22 FFs22 and POWER22 signal22 for
// SMC22 should become22 LOW22 on clock22 cycle after Isolate22 
// signal22 is activated22
// psl22 output_pd_seq_stg_222:
//    assert always
//    {rose22(isolate_module22)} |=>
//    {[*2]; {{fell22(rstn_non_srpg_module22)} && {fell22(pwr1_on22)}} }
//    abort22(~nprst22);
//
//
// Whenever22 pwr1_on22 goes22 to LOW22 pwr2_on22 should also go22 to LOW22
// psl22 output_pwr2_low22:
//    assert always
//    { fell22(pwr1_on22) } |->  { fell22(pwr2_on22) }
//    abort22(~nprst22);
//
//
// Whenever22 pwr1_on22 becomes HIGH22 , On22 Next22 clock22 cycle pwr2_on22
// should also become22 HIGH22
// psl22 output_pwr2_high22:
//    assert always
//    { rose22(pwr1_on22) } |=>  { (pwr2_on22) }
//    abort22(~nprst22);
//
`endif


endmodule
