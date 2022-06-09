//File8 name   : power_ctrl_sm8.v
//Title8       : Power8 Controller8 state machine8
//Created8     : 1999
//Description8 : State8 machine8 of power8 controller8
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
module power_ctrl_sm8 (

    // Clocks8 & Reset8
    pclk8,
    nprst8,

    // Register Control8 inputs8
    L1_module_req8,
    set_status_module8,
    clr_status_module8,

    // Module8 control8 outputs8
    rstn_non_srpg_module8,
    gate_clk_module8,
    isolate_module8,
    save_edge8,
    restore_edge8,
    pwr1_on8,
    pwr2_on8

);

input    pclk8;
input    nprst8;

input    L1_module_req8;
output   set_status_module8;
output   clr_status_module8;
    
output   rstn_non_srpg_module8;
output   gate_clk_module8;
output   isolate_module8;
output   pwr1_on8;
output   pwr2_on8;
output save_edge8;
output restore_edge8;

wire    set_status_module8;
wire    clr_status_module8;

wire    rstn_non_srpg_module8;
reg     gate_clk_module8;
reg     isolate_module8;
reg     pwr1_on8;
reg     pwr2_on8;

reg save_edge8;

reg restore_edge8;
   
// FSM8 state
reg  [3:0] currentState8, nextState8;
reg     rstn_non_srpg8;
reg [4:0] trans_cnt8;

parameter Init8 = 0; 
parameter Clk_off8 = 1; 
parameter Wait18 = 2; 
parameter Isolate8 = 3; 
parameter Save_edge8 = 4; 
parameter Pre_pwr_off8 = 5; 
parameter Pwr_off8 = 6; 
parameter Pwr_on18 = 7; 
parameter Pwr_on28 = 8; 
parameter Restore_edge8 = 9; 
parameter Wait28 = 10; 
parameter De_isolate8 = 11; 
parameter Clk_on8 = 12; 
parameter Wait38 = 13; 
parameter Rst_clr8 = 14;


// Power8 Shut8 Off8 State8 Machine8

// FSM8 combinational8 process
always @  (*)
  begin
    case (currentState8)

      // Commence8 PSO8 once8 the L18 req bit is set.
      Init8:
        if (L1_module_req8 == 1'b1)
          nextState8 = Clk_off8;         // Gate8 the module's clocks8 off8
        else
          nextState8 = Init8;            // Keep8 waiting8 in Init8 state
        
      Clk_off8 :
        nextState8 = Wait18;             // Wait8 for one cycle
 
      Wait18  :                         // Wait8 for clk8 gating8 to take8 effect
        nextState8 = Isolate8;           // Start8 the isolation8 process
          
      Isolate8 :
        nextState8 = Save_edge8;
        
      Save_edge8 :
        nextState8 = Pre_pwr_off8;

      Pre_pwr_off8 :
        nextState8 = Pwr_off8;
      // Exit8 PSO8 once8 the L18 req bit is clear.

      Pwr_off8 :
        if (L1_module_req8 == 1'b0)
          nextState8 = Pwr_on18;         // Resume8 power8 if the L1_module_req8 bit is cleared8
        else
          nextState8 = Pwr_off8;         // Wait8 until the L1_module_req8 bit is cleared8
        
      Pwr_on18 :
        nextState8 = Pwr_on28;
          
      Pwr_on28 :
        if(trans_cnt8 == 5'd28)
          nextState8 = Restore_edge8;
        else 
          nextState8 = Pwr_on28;
          
      Restore_edge8 :
        nextState8 = Wait28;

      Wait28 :
        nextState8 = De_isolate8;
          
      De_isolate8 :
        nextState8 = Clk_on8;
          
      Clk_on8 :
        nextState8 = Wait38;
          
      Wait38  :                         // Wait8 for clock8 to resume
        nextState8 = Rst_clr8 ;     
 
      Rst_clr8 :
        nextState8 = Init8;
        
      default  :                       // Catch8 all
        nextState8 = Init8; 
        
    endcase
  end


  // Signals8 Sequential8 process - gate_clk_module8
always @ (posedge pclk8 or negedge nprst8)
  begin
    if (~nprst8)
      gate_clk_module8 <= 1'b0;
    else 
      if (nextState8 == Clk_on8 | nextState8 == Wait38 | nextState8 == Rst_clr8 | 
          nextState8 == Init8)
          gate_clk_module8 <= 1'b0;
      else
          gate_clk_module8 <= 1'b1;
  end

// Signals8 Sequential8 process - rstn_non_srpg8
always @ (posedge pclk8 or negedge nprst8)
  begin
    if (~nprst8)
      rstn_non_srpg8 <= 1'b0;
    else
      if ( nextState8 == Init8 | nextState8 == Clk_off8 | nextState8 == Wait18 | 
           nextState8 == Isolate8 | nextState8 == Save_edge8 | nextState8 == Pre_pwr_off8 | nextState8 == Rst_clr8)
        rstn_non_srpg8 <= 1'b1;
      else
        rstn_non_srpg8 <= 1'b0;
   end


// Signals8 Sequential8 process - pwr1_on8 & pwr2_on8
always @ (posedge pclk8 or negedge nprst8)
  begin
    if (~nprst8)
      pwr1_on8 <=  1'b1;  // power8 gates8 1 & 2 are on
    else
      if (nextState8 == Pwr_off8 )
        pwr1_on8 <= 1'b0;  // shut8 off8 both power8 gates8 1 & 2
      else
        pwr1_on8 <= 1'b1;
  end


// Signals8 Sequential8 process - pwr1_on8 & pwr2_on8
always @ (posedge pclk8 or negedge nprst8)
  begin
    if (~nprst8)
       pwr2_on8 <= 1'b1;      // power8 gates8 1 & 2 are on
    else
      if (nextState8 == Pwr_off8 | nextState8 == Pwr_on18)
        pwr2_on8 <= 1'b0;     // shut8 off8 both power8 gates8 1 & 2
      else
        pwr2_on8 <= 1'b1;
   end


// Signals8 Sequential8 process - isolate_module8 
always @ (posedge pclk8 or negedge nprst8)
  begin
    if (~nprst8)
        isolate_module8 <= 1'b0;
    else
      if (nextState8 == Isolate8 | nextState8 == Save_edge8 | nextState8 == Pre_pwr_off8 |  nextState8 == Pwr_off8 | nextState8 == Pwr_on18 |
          nextState8 == Pwr_on28 | nextState8 == Restore_edge8 | nextState8 == Wait28)
         isolate_module8 <= 1'b1;       // Activate8 the isolate8 and retain8 signals8
      else
         isolate_module8 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk8 or negedge nprst8)
  begin
    if (~nprst8)
        save_edge8 <= 1'b0;
    else
      if (nextState8 == Save_edge8 )
         save_edge8 <= 1'b1;       // Activate8 the isolate8 and retain8 signals8
      else
         save_edge8 <= 1'b0;        
   end    
// stabilising8 count
wire restore_change8;
assign restore_change8 = (nextState8 == Pwr_on28) ? 1'b1: 1'b0;

always @ (posedge pclk8 or negedge nprst8)
  begin
    if (~nprst8)
      trans_cnt8 <= 0;
    else if (trans_cnt8 > 0)
      trans_cnt8  <= trans_cnt8 + 1;
    else if (restore_change8)
      trans_cnt8  <= trans_cnt8 + 1;
  end

// enabling restore8 edge
always @ (posedge pclk8 or negedge nprst8)
  begin
    if (~nprst8)
        restore_edge8 <= 1'b0;
    else
      if (nextState8 == Restore_edge8)
         restore_edge8 <= 1'b1;       // Activate8 the isolate8 and retain8 signals8
      else
         restore_edge8 <= 1'b0;        
   end    


// FSM8 Sequential8 process
always @ (posedge pclk8 or negedge nprst8)
  begin
    if (~nprst8)
      currentState8 <= Init8;
    else
      currentState8 <= nextState8;
  end


// Reset8 for non-SRPG8 FFs8 is a combination8 of the nprst8 and the reset during PSO8
assign  rstn_non_srpg_module8 = rstn_non_srpg8 & nprst8;

assign  set_status_module8 = (nextState8 == Clk_off8);    // Set the L18 status bit  
assign  clr_status_module8 = (currentState8 == Rst_clr8); // Clear the L18 status bit  
  

`ifdef LP_ABV_ON8

// psl8 default clock8 = (posedge pclk8);

// Never8 have the set and clear status signals8 both set
// psl8 output_no_set_and_clear8 : assert never {set_status_module8 & clr_status_module8};



// Isolate8 signal8 should become8 active on the 
// Next8 clock8 after Gate8 signal8 is activated8
// psl8 output_pd_seq8:
//    assert always
//	  {rose8(gate_clk_module8)} |=> {[*1]; {rose8(isolate_module8)} }
//    abort8(~nprst8);
//
//
//
// Reset8 signal8 for Non8-SRPG8 FFs8 and POWER8 signal8 for
// SMC8 should become8 LOW8 on clock8 cycle after Isolate8 
// signal8 is activated8
// psl8 output_pd_seq_stg_28:
//    assert always
//    {rose8(isolate_module8)} |=>
//    {[*2]; {{fell8(rstn_non_srpg_module8)} && {fell8(pwr1_on8)}} }
//    abort8(~nprst8);
//
//
// Whenever8 pwr1_on8 goes8 to LOW8 pwr2_on8 should also go8 to LOW8
// psl8 output_pwr2_low8:
//    assert always
//    { fell8(pwr1_on8) } |->  { fell8(pwr2_on8) }
//    abort8(~nprst8);
//
//
// Whenever8 pwr1_on8 becomes HIGH8 , On8 Next8 clock8 cycle pwr2_on8
// should also become8 HIGH8
// psl8 output_pwr2_high8:
//    assert always
//    { rose8(pwr1_on8) } |=>  { (pwr2_on8) }
//    abort8(~nprst8);
//
`endif


endmodule
