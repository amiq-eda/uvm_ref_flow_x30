//File20 name   : power_ctrl_sm20.v
//Title20       : Power20 Controller20 state machine20
//Created20     : 1999
//Description20 : State20 machine20 of power20 controller20
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
module power_ctrl_sm20 (

    // Clocks20 & Reset20
    pclk20,
    nprst20,

    // Register Control20 inputs20
    L1_module_req20,
    set_status_module20,
    clr_status_module20,

    // Module20 control20 outputs20
    rstn_non_srpg_module20,
    gate_clk_module20,
    isolate_module20,
    save_edge20,
    restore_edge20,
    pwr1_on20,
    pwr2_on20

);

input    pclk20;
input    nprst20;

input    L1_module_req20;
output   set_status_module20;
output   clr_status_module20;
    
output   rstn_non_srpg_module20;
output   gate_clk_module20;
output   isolate_module20;
output   pwr1_on20;
output   pwr2_on20;
output save_edge20;
output restore_edge20;

wire    set_status_module20;
wire    clr_status_module20;

wire    rstn_non_srpg_module20;
reg     gate_clk_module20;
reg     isolate_module20;
reg     pwr1_on20;
reg     pwr2_on20;

reg save_edge20;

reg restore_edge20;
   
// FSM20 state
reg  [3:0] currentState20, nextState20;
reg     rstn_non_srpg20;
reg [4:0] trans_cnt20;

parameter Init20 = 0; 
parameter Clk_off20 = 1; 
parameter Wait120 = 2; 
parameter Isolate20 = 3; 
parameter Save_edge20 = 4; 
parameter Pre_pwr_off20 = 5; 
parameter Pwr_off20 = 6; 
parameter Pwr_on120 = 7; 
parameter Pwr_on220 = 8; 
parameter Restore_edge20 = 9; 
parameter Wait220 = 10; 
parameter De_isolate20 = 11; 
parameter Clk_on20 = 12; 
parameter Wait320 = 13; 
parameter Rst_clr20 = 14;


// Power20 Shut20 Off20 State20 Machine20

// FSM20 combinational20 process
always @  (*)
  begin
    case (currentState20)

      // Commence20 PSO20 once20 the L120 req bit is set.
      Init20:
        if (L1_module_req20 == 1'b1)
          nextState20 = Clk_off20;         // Gate20 the module's clocks20 off20
        else
          nextState20 = Init20;            // Keep20 waiting20 in Init20 state
        
      Clk_off20 :
        nextState20 = Wait120;             // Wait20 for one cycle
 
      Wait120  :                         // Wait20 for clk20 gating20 to take20 effect
        nextState20 = Isolate20;           // Start20 the isolation20 process
          
      Isolate20 :
        nextState20 = Save_edge20;
        
      Save_edge20 :
        nextState20 = Pre_pwr_off20;

      Pre_pwr_off20 :
        nextState20 = Pwr_off20;
      // Exit20 PSO20 once20 the L120 req bit is clear.

      Pwr_off20 :
        if (L1_module_req20 == 1'b0)
          nextState20 = Pwr_on120;         // Resume20 power20 if the L1_module_req20 bit is cleared20
        else
          nextState20 = Pwr_off20;         // Wait20 until the L1_module_req20 bit is cleared20
        
      Pwr_on120 :
        nextState20 = Pwr_on220;
          
      Pwr_on220 :
        if(trans_cnt20 == 5'd28)
          nextState20 = Restore_edge20;
        else 
          nextState20 = Pwr_on220;
          
      Restore_edge20 :
        nextState20 = Wait220;

      Wait220 :
        nextState20 = De_isolate20;
          
      De_isolate20 :
        nextState20 = Clk_on20;
          
      Clk_on20 :
        nextState20 = Wait320;
          
      Wait320  :                         // Wait20 for clock20 to resume
        nextState20 = Rst_clr20 ;     
 
      Rst_clr20 :
        nextState20 = Init20;
        
      default  :                       // Catch20 all
        nextState20 = Init20; 
        
    endcase
  end


  // Signals20 Sequential20 process - gate_clk_module20
always @ (posedge pclk20 or negedge nprst20)
  begin
    if (~nprst20)
      gate_clk_module20 <= 1'b0;
    else 
      if (nextState20 == Clk_on20 | nextState20 == Wait320 | nextState20 == Rst_clr20 | 
          nextState20 == Init20)
          gate_clk_module20 <= 1'b0;
      else
          gate_clk_module20 <= 1'b1;
  end

// Signals20 Sequential20 process - rstn_non_srpg20
always @ (posedge pclk20 or negedge nprst20)
  begin
    if (~nprst20)
      rstn_non_srpg20 <= 1'b0;
    else
      if ( nextState20 == Init20 | nextState20 == Clk_off20 | nextState20 == Wait120 | 
           nextState20 == Isolate20 | nextState20 == Save_edge20 | nextState20 == Pre_pwr_off20 | nextState20 == Rst_clr20)
        rstn_non_srpg20 <= 1'b1;
      else
        rstn_non_srpg20 <= 1'b0;
   end


// Signals20 Sequential20 process - pwr1_on20 & pwr2_on20
always @ (posedge pclk20 or negedge nprst20)
  begin
    if (~nprst20)
      pwr1_on20 <=  1'b1;  // power20 gates20 1 & 2 are on
    else
      if (nextState20 == Pwr_off20 )
        pwr1_on20 <= 1'b0;  // shut20 off20 both power20 gates20 1 & 2
      else
        pwr1_on20 <= 1'b1;
  end


// Signals20 Sequential20 process - pwr1_on20 & pwr2_on20
always @ (posedge pclk20 or negedge nprst20)
  begin
    if (~nprst20)
       pwr2_on20 <= 1'b1;      // power20 gates20 1 & 2 are on
    else
      if (nextState20 == Pwr_off20 | nextState20 == Pwr_on120)
        pwr2_on20 <= 1'b0;     // shut20 off20 both power20 gates20 1 & 2
      else
        pwr2_on20 <= 1'b1;
   end


// Signals20 Sequential20 process - isolate_module20 
always @ (posedge pclk20 or negedge nprst20)
  begin
    if (~nprst20)
        isolate_module20 <= 1'b0;
    else
      if (nextState20 == Isolate20 | nextState20 == Save_edge20 | nextState20 == Pre_pwr_off20 |  nextState20 == Pwr_off20 | nextState20 == Pwr_on120 |
          nextState20 == Pwr_on220 | nextState20 == Restore_edge20 | nextState20 == Wait220)
         isolate_module20 <= 1'b1;       // Activate20 the isolate20 and retain20 signals20
      else
         isolate_module20 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk20 or negedge nprst20)
  begin
    if (~nprst20)
        save_edge20 <= 1'b0;
    else
      if (nextState20 == Save_edge20 )
         save_edge20 <= 1'b1;       // Activate20 the isolate20 and retain20 signals20
      else
         save_edge20 <= 1'b0;        
   end    
// stabilising20 count
wire restore_change20;
assign restore_change20 = (nextState20 == Pwr_on220) ? 1'b1: 1'b0;

always @ (posedge pclk20 or negedge nprst20)
  begin
    if (~nprst20)
      trans_cnt20 <= 0;
    else if (trans_cnt20 > 0)
      trans_cnt20  <= trans_cnt20 + 1;
    else if (restore_change20)
      trans_cnt20  <= trans_cnt20 + 1;
  end

// enabling restore20 edge
always @ (posedge pclk20 or negedge nprst20)
  begin
    if (~nprst20)
        restore_edge20 <= 1'b0;
    else
      if (nextState20 == Restore_edge20)
         restore_edge20 <= 1'b1;       // Activate20 the isolate20 and retain20 signals20
      else
         restore_edge20 <= 1'b0;        
   end    


// FSM20 Sequential20 process
always @ (posedge pclk20 or negedge nprst20)
  begin
    if (~nprst20)
      currentState20 <= Init20;
    else
      currentState20 <= nextState20;
  end


// Reset20 for non-SRPG20 FFs20 is a combination20 of the nprst20 and the reset during PSO20
assign  rstn_non_srpg_module20 = rstn_non_srpg20 & nprst20;

assign  set_status_module20 = (nextState20 == Clk_off20);    // Set the L120 status bit  
assign  clr_status_module20 = (currentState20 == Rst_clr20); // Clear the L120 status bit  
  

`ifdef LP_ABV_ON20

// psl20 default clock20 = (posedge pclk20);

// Never20 have the set and clear status signals20 both set
// psl20 output_no_set_and_clear20 : assert never {set_status_module20 & clr_status_module20};



// Isolate20 signal20 should become20 active on the 
// Next20 clock20 after Gate20 signal20 is activated20
// psl20 output_pd_seq20:
//    assert always
//	  {rose20(gate_clk_module20)} |=> {[*1]; {rose20(isolate_module20)} }
//    abort20(~nprst20);
//
//
//
// Reset20 signal20 for Non20-SRPG20 FFs20 and POWER20 signal20 for
// SMC20 should become20 LOW20 on clock20 cycle after Isolate20 
// signal20 is activated20
// psl20 output_pd_seq_stg_220:
//    assert always
//    {rose20(isolate_module20)} |=>
//    {[*2]; {{fell20(rstn_non_srpg_module20)} && {fell20(pwr1_on20)}} }
//    abort20(~nprst20);
//
//
// Whenever20 pwr1_on20 goes20 to LOW20 pwr2_on20 should also go20 to LOW20
// psl20 output_pwr2_low20:
//    assert always
//    { fell20(pwr1_on20) } |->  { fell20(pwr2_on20) }
//    abort20(~nprst20);
//
//
// Whenever20 pwr1_on20 becomes HIGH20 , On20 Next20 clock20 cycle pwr2_on20
// should also become20 HIGH20
// psl20 output_pwr2_high20:
//    assert always
//    { rose20(pwr1_on20) } |=>  { (pwr2_on20) }
//    abort20(~nprst20);
//
`endif


endmodule
