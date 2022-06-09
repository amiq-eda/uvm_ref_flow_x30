//File28 name   : power_ctrl_sm28.v
//Title28       : Power28 Controller28 state machine28
//Created28     : 1999
//Description28 : State28 machine28 of power28 controller28
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
module power_ctrl_sm28 (

    // Clocks28 & Reset28
    pclk28,
    nprst28,

    // Register Control28 inputs28
    L1_module_req28,
    set_status_module28,
    clr_status_module28,

    // Module28 control28 outputs28
    rstn_non_srpg_module28,
    gate_clk_module28,
    isolate_module28,
    save_edge28,
    restore_edge28,
    pwr1_on28,
    pwr2_on28

);

input    pclk28;
input    nprst28;

input    L1_module_req28;
output   set_status_module28;
output   clr_status_module28;
    
output   rstn_non_srpg_module28;
output   gate_clk_module28;
output   isolate_module28;
output   pwr1_on28;
output   pwr2_on28;
output save_edge28;
output restore_edge28;

wire    set_status_module28;
wire    clr_status_module28;

wire    rstn_non_srpg_module28;
reg     gate_clk_module28;
reg     isolate_module28;
reg     pwr1_on28;
reg     pwr2_on28;

reg save_edge28;

reg restore_edge28;
   
// FSM28 state
reg  [3:0] currentState28, nextState28;
reg     rstn_non_srpg28;
reg [4:0] trans_cnt28;

parameter Init28 = 0; 
parameter Clk_off28 = 1; 
parameter Wait128 = 2; 
parameter Isolate28 = 3; 
parameter Save_edge28 = 4; 
parameter Pre_pwr_off28 = 5; 
parameter Pwr_off28 = 6; 
parameter Pwr_on128 = 7; 
parameter Pwr_on228 = 8; 
parameter Restore_edge28 = 9; 
parameter Wait228 = 10; 
parameter De_isolate28 = 11; 
parameter Clk_on28 = 12; 
parameter Wait328 = 13; 
parameter Rst_clr28 = 14;


// Power28 Shut28 Off28 State28 Machine28

// FSM28 combinational28 process
always @  (*)
  begin
    case (currentState28)

      // Commence28 PSO28 once28 the L128 req bit is set.
      Init28:
        if (L1_module_req28 == 1'b1)
          nextState28 = Clk_off28;         // Gate28 the module's clocks28 off28
        else
          nextState28 = Init28;            // Keep28 waiting28 in Init28 state
        
      Clk_off28 :
        nextState28 = Wait128;             // Wait28 for one cycle
 
      Wait128  :                         // Wait28 for clk28 gating28 to take28 effect
        nextState28 = Isolate28;           // Start28 the isolation28 process
          
      Isolate28 :
        nextState28 = Save_edge28;
        
      Save_edge28 :
        nextState28 = Pre_pwr_off28;

      Pre_pwr_off28 :
        nextState28 = Pwr_off28;
      // Exit28 PSO28 once28 the L128 req bit is clear.

      Pwr_off28 :
        if (L1_module_req28 == 1'b0)
          nextState28 = Pwr_on128;         // Resume28 power28 if the L1_module_req28 bit is cleared28
        else
          nextState28 = Pwr_off28;         // Wait28 until the L1_module_req28 bit is cleared28
        
      Pwr_on128 :
        nextState28 = Pwr_on228;
          
      Pwr_on228 :
        if(trans_cnt28 == 5'd28)
          nextState28 = Restore_edge28;
        else 
          nextState28 = Pwr_on228;
          
      Restore_edge28 :
        nextState28 = Wait228;

      Wait228 :
        nextState28 = De_isolate28;
          
      De_isolate28 :
        nextState28 = Clk_on28;
          
      Clk_on28 :
        nextState28 = Wait328;
          
      Wait328  :                         // Wait28 for clock28 to resume
        nextState28 = Rst_clr28 ;     
 
      Rst_clr28 :
        nextState28 = Init28;
        
      default  :                       // Catch28 all
        nextState28 = Init28; 
        
    endcase
  end


  // Signals28 Sequential28 process - gate_clk_module28
always @ (posedge pclk28 or negedge nprst28)
  begin
    if (~nprst28)
      gate_clk_module28 <= 1'b0;
    else 
      if (nextState28 == Clk_on28 | nextState28 == Wait328 | nextState28 == Rst_clr28 | 
          nextState28 == Init28)
          gate_clk_module28 <= 1'b0;
      else
          gate_clk_module28 <= 1'b1;
  end

// Signals28 Sequential28 process - rstn_non_srpg28
always @ (posedge pclk28 or negedge nprst28)
  begin
    if (~nprst28)
      rstn_non_srpg28 <= 1'b0;
    else
      if ( nextState28 == Init28 | nextState28 == Clk_off28 | nextState28 == Wait128 | 
           nextState28 == Isolate28 | nextState28 == Save_edge28 | nextState28 == Pre_pwr_off28 | nextState28 == Rst_clr28)
        rstn_non_srpg28 <= 1'b1;
      else
        rstn_non_srpg28 <= 1'b0;
   end


// Signals28 Sequential28 process - pwr1_on28 & pwr2_on28
always @ (posedge pclk28 or negedge nprst28)
  begin
    if (~nprst28)
      pwr1_on28 <=  1'b1;  // power28 gates28 1 & 2 are on
    else
      if (nextState28 == Pwr_off28 )
        pwr1_on28 <= 1'b0;  // shut28 off28 both power28 gates28 1 & 2
      else
        pwr1_on28 <= 1'b1;
  end


// Signals28 Sequential28 process - pwr1_on28 & pwr2_on28
always @ (posedge pclk28 or negedge nprst28)
  begin
    if (~nprst28)
       pwr2_on28 <= 1'b1;      // power28 gates28 1 & 2 are on
    else
      if (nextState28 == Pwr_off28 | nextState28 == Pwr_on128)
        pwr2_on28 <= 1'b0;     // shut28 off28 both power28 gates28 1 & 2
      else
        pwr2_on28 <= 1'b1;
   end


// Signals28 Sequential28 process - isolate_module28 
always @ (posedge pclk28 or negedge nprst28)
  begin
    if (~nprst28)
        isolate_module28 <= 1'b0;
    else
      if (nextState28 == Isolate28 | nextState28 == Save_edge28 | nextState28 == Pre_pwr_off28 |  nextState28 == Pwr_off28 | nextState28 == Pwr_on128 |
          nextState28 == Pwr_on228 | nextState28 == Restore_edge28 | nextState28 == Wait228)
         isolate_module28 <= 1'b1;       // Activate28 the isolate28 and retain28 signals28
      else
         isolate_module28 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk28 or negedge nprst28)
  begin
    if (~nprst28)
        save_edge28 <= 1'b0;
    else
      if (nextState28 == Save_edge28 )
         save_edge28 <= 1'b1;       // Activate28 the isolate28 and retain28 signals28
      else
         save_edge28 <= 1'b0;        
   end    
// stabilising28 count
wire restore_change28;
assign restore_change28 = (nextState28 == Pwr_on228) ? 1'b1: 1'b0;

always @ (posedge pclk28 or negedge nprst28)
  begin
    if (~nprst28)
      trans_cnt28 <= 0;
    else if (trans_cnt28 > 0)
      trans_cnt28  <= trans_cnt28 + 1;
    else if (restore_change28)
      trans_cnt28  <= trans_cnt28 + 1;
  end

// enabling restore28 edge
always @ (posedge pclk28 or negedge nprst28)
  begin
    if (~nprst28)
        restore_edge28 <= 1'b0;
    else
      if (nextState28 == Restore_edge28)
         restore_edge28 <= 1'b1;       // Activate28 the isolate28 and retain28 signals28
      else
         restore_edge28 <= 1'b0;        
   end    


// FSM28 Sequential28 process
always @ (posedge pclk28 or negedge nprst28)
  begin
    if (~nprst28)
      currentState28 <= Init28;
    else
      currentState28 <= nextState28;
  end


// Reset28 for non-SRPG28 FFs28 is a combination28 of the nprst28 and the reset during PSO28
assign  rstn_non_srpg_module28 = rstn_non_srpg28 & nprst28;

assign  set_status_module28 = (nextState28 == Clk_off28);    // Set the L128 status bit  
assign  clr_status_module28 = (currentState28 == Rst_clr28); // Clear the L128 status bit  
  

`ifdef LP_ABV_ON28

// psl28 default clock28 = (posedge pclk28);

// Never28 have the set and clear status signals28 both set
// psl28 output_no_set_and_clear28 : assert never {set_status_module28 & clr_status_module28};



// Isolate28 signal28 should become28 active on the 
// Next28 clock28 after Gate28 signal28 is activated28
// psl28 output_pd_seq28:
//    assert always
//	  {rose28(gate_clk_module28)} |=> {[*1]; {rose28(isolate_module28)} }
//    abort28(~nprst28);
//
//
//
// Reset28 signal28 for Non28-SRPG28 FFs28 and POWER28 signal28 for
// SMC28 should become28 LOW28 on clock28 cycle after Isolate28 
// signal28 is activated28
// psl28 output_pd_seq_stg_228:
//    assert always
//    {rose28(isolate_module28)} |=>
//    {[*2]; {{fell28(rstn_non_srpg_module28)} && {fell28(pwr1_on28)}} }
//    abort28(~nprst28);
//
//
// Whenever28 pwr1_on28 goes28 to LOW28 pwr2_on28 should also go28 to LOW28
// psl28 output_pwr2_low28:
//    assert always
//    { fell28(pwr1_on28) } |->  { fell28(pwr2_on28) }
//    abort28(~nprst28);
//
//
// Whenever28 pwr1_on28 becomes HIGH28 , On28 Next28 clock28 cycle pwr2_on28
// should also become28 HIGH28
// psl28 output_pwr2_high28:
//    assert always
//    { rose28(pwr1_on28) } |=>  { (pwr2_on28) }
//    abort28(~nprst28);
//
`endif


endmodule
