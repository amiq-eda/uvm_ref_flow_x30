//File17 name   : power_ctrl_sm17.v
//Title17       : Power17 Controller17 state machine17
//Created17     : 1999
//Description17 : State17 machine17 of power17 controller17
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
module power_ctrl_sm17 (

    // Clocks17 & Reset17
    pclk17,
    nprst17,

    // Register Control17 inputs17
    L1_module_req17,
    set_status_module17,
    clr_status_module17,

    // Module17 control17 outputs17
    rstn_non_srpg_module17,
    gate_clk_module17,
    isolate_module17,
    save_edge17,
    restore_edge17,
    pwr1_on17,
    pwr2_on17

);

input    pclk17;
input    nprst17;

input    L1_module_req17;
output   set_status_module17;
output   clr_status_module17;
    
output   rstn_non_srpg_module17;
output   gate_clk_module17;
output   isolate_module17;
output   pwr1_on17;
output   pwr2_on17;
output save_edge17;
output restore_edge17;

wire    set_status_module17;
wire    clr_status_module17;

wire    rstn_non_srpg_module17;
reg     gate_clk_module17;
reg     isolate_module17;
reg     pwr1_on17;
reg     pwr2_on17;

reg save_edge17;

reg restore_edge17;
   
// FSM17 state
reg  [3:0] currentState17, nextState17;
reg     rstn_non_srpg17;
reg [4:0] trans_cnt17;

parameter Init17 = 0; 
parameter Clk_off17 = 1; 
parameter Wait117 = 2; 
parameter Isolate17 = 3; 
parameter Save_edge17 = 4; 
parameter Pre_pwr_off17 = 5; 
parameter Pwr_off17 = 6; 
parameter Pwr_on117 = 7; 
parameter Pwr_on217 = 8; 
parameter Restore_edge17 = 9; 
parameter Wait217 = 10; 
parameter De_isolate17 = 11; 
parameter Clk_on17 = 12; 
parameter Wait317 = 13; 
parameter Rst_clr17 = 14;


// Power17 Shut17 Off17 State17 Machine17

// FSM17 combinational17 process
always @  (*)
  begin
    case (currentState17)

      // Commence17 PSO17 once17 the L117 req bit is set.
      Init17:
        if (L1_module_req17 == 1'b1)
          nextState17 = Clk_off17;         // Gate17 the module's clocks17 off17
        else
          nextState17 = Init17;            // Keep17 waiting17 in Init17 state
        
      Clk_off17 :
        nextState17 = Wait117;             // Wait17 for one cycle
 
      Wait117  :                         // Wait17 for clk17 gating17 to take17 effect
        nextState17 = Isolate17;           // Start17 the isolation17 process
          
      Isolate17 :
        nextState17 = Save_edge17;
        
      Save_edge17 :
        nextState17 = Pre_pwr_off17;

      Pre_pwr_off17 :
        nextState17 = Pwr_off17;
      // Exit17 PSO17 once17 the L117 req bit is clear.

      Pwr_off17 :
        if (L1_module_req17 == 1'b0)
          nextState17 = Pwr_on117;         // Resume17 power17 if the L1_module_req17 bit is cleared17
        else
          nextState17 = Pwr_off17;         // Wait17 until the L1_module_req17 bit is cleared17
        
      Pwr_on117 :
        nextState17 = Pwr_on217;
          
      Pwr_on217 :
        if(trans_cnt17 == 5'd28)
          nextState17 = Restore_edge17;
        else 
          nextState17 = Pwr_on217;
          
      Restore_edge17 :
        nextState17 = Wait217;

      Wait217 :
        nextState17 = De_isolate17;
          
      De_isolate17 :
        nextState17 = Clk_on17;
          
      Clk_on17 :
        nextState17 = Wait317;
          
      Wait317  :                         // Wait17 for clock17 to resume
        nextState17 = Rst_clr17 ;     
 
      Rst_clr17 :
        nextState17 = Init17;
        
      default  :                       // Catch17 all
        nextState17 = Init17; 
        
    endcase
  end


  // Signals17 Sequential17 process - gate_clk_module17
always @ (posedge pclk17 or negedge nprst17)
  begin
    if (~nprst17)
      gate_clk_module17 <= 1'b0;
    else 
      if (nextState17 == Clk_on17 | nextState17 == Wait317 | nextState17 == Rst_clr17 | 
          nextState17 == Init17)
          gate_clk_module17 <= 1'b0;
      else
          gate_clk_module17 <= 1'b1;
  end

// Signals17 Sequential17 process - rstn_non_srpg17
always @ (posedge pclk17 or negedge nprst17)
  begin
    if (~nprst17)
      rstn_non_srpg17 <= 1'b0;
    else
      if ( nextState17 == Init17 | nextState17 == Clk_off17 | nextState17 == Wait117 | 
           nextState17 == Isolate17 | nextState17 == Save_edge17 | nextState17 == Pre_pwr_off17 | nextState17 == Rst_clr17)
        rstn_non_srpg17 <= 1'b1;
      else
        rstn_non_srpg17 <= 1'b0;
   end


// Signals17 Sequential17 process - pwr1_on17 & pwr2_on17
always @ (posedge pclk17 or negedge nprst17)
  begin
    if (~nprst17)
      pwr1_on17 <=  1'b1;  // power17 gates17 1 & 2 are on
    else
      if (nextState17 == Pwr_off17 )
        pwr1_on17 <= 1'b0;  // shut17 off17 both power17 gates17 1 & 2
      else
        pwr1_on17 <= 1'b1;
  end


// Signals17 Sequential17 process - pwr1_on17 & pwr2_on17
always @ (posedge pclk17 or negedge nprst17)
  begin
    if (~nprst17)
       pwr2_on17 <= 1'b1;      // power17 gates17 1 & 2 are on
    else
      if (nextState17 == Pwr_off17 | nextState17 == Pwr_on117)
        pwr2_on17 <= 1'b0;     // shut17 off17 both power17 gates17 1 & 2
      else
        pwr2_on17 <= 1'b1;
   end


// Signals17 Sequential17 process - isolate_module17 
always @ (posedge pclk17 or negedge nprst17)
  begin
    if (~nprst17)
        isolate_module17 <= 1'b0;
    else
      if (nextState17 == Isolate17 | nextState17 == Save_edge17 | nextState17 == Pre_pwr_off17 |  nextState17 == Pwr_off17 | nextState17 == Pwr_on117 |
          nextState17 == Pwr_on217 | nextState17 == Restore_edge17 | nextState17 == Wait217)
         isolate_module17 <= 1'b1;       // Activate17 the isolate17 and retain17 signals17
      else
         isolate_module17 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk17 or negedge nprst17)
  begin
    if (~nprst17)
        save_edge17 <= 1'b0;
    else
      if (nextState17 == Save_edge17 )
         save_edge17 <= 1'b1;       // Activate17 the isolate17 and retain17 signals17
      else
         save_edge17 <= 1'b0;        
   end    
// stabilising17 count
wire restore_change17;
assign restore_change17 = (nextState17 == Pwr_on217) ? 1'b1: 1'b0;

always @ (posedge pclk17 or negedge nprst17)
  begin
    if (~nprst17)
      trans_cnt17 <= 0;
    else if (trans_cnt17 > 0)
      trans_cnt17  <= trans_cnt17 + 1;
    else if (restore_change17)
      trans_cnt17  <= trans_cnt17 + 1;
  end

// enabling restore17 edge
always @ (posedge pclk17 or negedge nprst17)
  begin
    if (~nprst17)
        restore_edge17 <= 1'b0;
    else
      if (nextState17 == Restore_edge17)
         restore_edge17 <= 1'b1;       // Activate17 the isolate17 and retain17 signals17
      else
         restore_edge17 <= 1'b0;        
   end    


// FSM17 Sequential17 process
always @ (posedge pclk17 or negedge nprst17)
  begin
    if (~nprst17)
      currentState17 <= Init17;
    else
      currentState17 <= nextState17;
  end


// Reset17 for non-SRPG17 FFs17 is a combination17 of the nprst17 and the reset during PSO17
assign  rstn_non_srpg_module17 = rstn_non_srpg17 & nprst17;

assign  set_status_module17 = (nextState17 == Clk_off17);    // Set the L117 status bit  
assign  clr_status_module17 = (currentState17 == Rst_clr17); // Clear the L117 status bit  
  

`ifdef LP_ABV_ON17

// psl17 default clock17 = (posedge pclk17);

// Never17 have the set and clear status signals17 both set
// psl17 output_no_set_and_clear17 : assert never {set_status_module17 & clr_status_module17};



// Isolate17 signal17 should become17 active on the 
// Next17 clock17 after Gate17 signal17 is activated17
// psl17 output_pd_seq17:
//    assert always
//	  {rose17(gate_clk_module17)} |=> {[*1]; {rose17(isolate_module17)} }
//    abort17(~nprst17);
//
//
//
// Reset17 signal17 for Non17-SRPG17 FFs17 and POWER17 signal17 for
// SMC17 should become17 LOW17 on clock17 cycle after Isolate17 
// signal17 is activated17
// psl17 output_pd_seq_stg_217:
//    assert always
//    {rose17(isolate_module17)} |=>
//    {[*2]; {{fell17(rstn_non_srpg_module17)} && {fell17(pwr1_on17)}} }
//    abort17(~nprst17);
//
//
// Whenever17 pwr1_on17 goes17 to LOW17 pwr2_on17 should also go17 to LOW17
// psl17 output_pwr2_low17:
//    assert always
//    { fell17(pwr1_on17) } |->  { fell17(pwr2_on17) }
//    abort17(~nprst17);
//
//
// Whenever17 pwr1_on17 becomes HIGH17 , On17 Next17 clock17 cycle pwr2_on17
// should also become17 HIGH17
// psl17 output_pwr2_high17:
//    assert always
//    { rose17(pwr1_on17) } |=>  { (pwr2_on17) }
//    abort17(~nprst17);
//
`endif


endmodule
