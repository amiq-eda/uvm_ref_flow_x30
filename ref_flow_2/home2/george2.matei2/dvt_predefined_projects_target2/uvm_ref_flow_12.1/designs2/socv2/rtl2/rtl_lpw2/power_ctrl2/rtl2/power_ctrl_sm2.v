//File2 name   : power_ctrl_sm2.v
//Title2       : Power2 Controller2 state machine2
//Created2     : 1999
//Description2 : State2 machine2 of power2 controller2
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
module power_ctrl_sm2 (

    // Clocks2 & Reset2
    pclk2,
    nprst2,

    // Register Control2 inputs2
    L1_module_req2,
    set_status_module2,
    clr_status_module2,

    // Module2 control2 outputs2
    rstn_non_srpg_module2,
    gate_clk_module2,
    isolate_module2,
    save_edge2,
    restore_edge2,
    pwr1_on2,
    pwr2_on2

);

input    pclk2;
input    nprst2;

input    L1_module_req2;
output   set_status_module2;
output   clr_status_module2;
    
output   rstn_non_srpg_module2;
output   gate_clk_module2;
output   isolate_module2;
output   pwr1_on2;
output   pwr2_on2;
output save_edge2;
output restore_edge2;

wire    set_status_module2;
wire    clr_status_module2;

wire    rstn_non_srpg_module2;
reg     gate_clk_module2;
reg     isolate_module2;
reg     pwr1_on2;
reg     pwr2_on2;

reg save_edge2;

reg restore_edge2;
   
// FSM2 state
reg  [3:0] currentState2, nextState2;
reg     rstn_non_srpg2;
reg [4:0] trans_cnt2;

parameter Init2 = 0; 
parameter Clk_off2 = 1; 
parameter Wait12 = 2; 
parameter Isolate2 = 3; 
parameter Save_edge2 = 4; 
parameter Pre_pwr_off2 = 5; 
parameter Pwr_off2 = 6; 
parameter Pwr_on12 = 7; 
parameter Pwr_on22 = 8; 
parameter Restore_edge2 = 9; 
parameter Wait22 = 10; 
parameter De_isolate2 = 11; 
parameter Clk_on2 = 12; 
parameter Wait32 = 13; 
parameter Rst_clr2 = 14;


// Power2 Shut2 Off2 State2 Machine2

// FSM2 combinational2 process
always @  (*)
  begin
    case (currentState2)

      // Commence2 PSO2 once2 the L12 req bit is set.
      Init2:
        if (L1_module_req2 == 1'b1)
          nextState2 = Clk_off2;         // Gate2 the module's clocks2 off2
        else
          nextState2 = Init2;            // Keep2 waiting2 in Init2 state
        
      Clk_off2 :
        nextState2 = Wait12;             // Wait2 for one cycle
 
      Wait12  :                         // Wait2 for clk2 gating2 to take2 effect
        nextState2 = Isolate2;           // Start2 the isolation2 process
          
      Isolate2 :
        nextState2 = Save_edge2;
        
      Save_edge2 :
        nextState2 = Pre_pwr_off2;

      Pre_pwr_off2 :
        nextState2 = Pwr_off2;
      // Exit2 PSO2 once2 the L12 req bit is clear.

      Pwr_off2 :
        if (L1_module_req2 == 1'b0)
          nextState2 = Pwr_on12;         // Resume2 power2 if the L1_module_req2 bit is cleared2
        else
          nextState2 = Pwr_off2;         // Wait2 until the L1_module_req2 bit is cleared2
        
      Pwr_on12 :
        nextState2 = Pwr_on22;
          
      Pwr_on22 :
        if(trans_cnt2 == 5'd28)
          nextState2 = Restore_edge2;
        else 
          nextState2 = Pwr_on22;
          
      Restore_edge2 :
        nextState2 = Wait22;

      Wait22 :
        nextState2 = De_isolate2;
          
      De_isolate2 :
        nextState2 = Clk_on2;
          
      Clk_on2 :
        nextState2 = Wait32;
          
      Wait32  :                         // Wait2 for clock2 to resume
        nextState2 = Rst_clr2 ;     
 
      Rst_clr2 :
        nextState2 = Init2;
        
      default  :                       // Catch2 all
        nextState2 = Init2; 
        
    endcase
  end


  // Signals2 Sequential2 process - gate_clk_module2
always @ (posedge pclk2 or negedge nprst2)
  begin
    if (~nprst2)
      gate_clk_module2 <= 1'b0;
    else 
      if (nextState2 == Clk_on2 | nextState2 == Wait32 | nextState2 == Rst_clr2 | 
          nextState2 == Init2)
          gate_clk_module2 <= 1'b0;
      else
          gate_clk_module2 <= 1'b1;
  end

// Signals2 Sequential2 process - rstn_non_srpg2
always @ (posedge pclk2 or negedge nprst2)
  begin
    if (~nprst2)
      rstn_non_srpg2 <= 1'b0;
    else
      if ( nextState2 == Init2 | nextState2 == Clk_off2 | nextState2 == Wait12 | 
           nextState2 == Isolate2 | nextState2 == Save_edge2 | nextState2 == Pre_pwr_off2 | nextState2 == Rst_clr2)
        rstn_non_srpg2 <= 1'b1;
      else
        rstn_non_srpg2 <= 1'b0;
   end


// Signals2 Sequential2 process - pwr1_on2 & pwr2_on2
always @ (posedge pclk2 or negedge nprst2)
  begin
    if (~nprst2)
      pwr1_on2 <=  1'b1;  // power2 gates2 1 & 2 are on
    else
      if (nextState2 == Pwr_off2 )
        pwr1_on2 <= 1'b0;  // shut2 off2 both power2 gates2 1 & 2
      else
        pwr1_on2 <= 1'b1;
  end


// Signals2 Sequential2 process - pwr1_on2 & pwr2_on2
always @ (posedge pclk2 or negedge nprst2)
  begin
    if (~nprst2)
       pwr2_on2 <= 1'b1;      // power2 gates2 1 & 2 are on
    else
      if (nextState2 == Pwr_off2 | nextState2 == Pwr_on12)
        pwr2_on2 <= 1'b0;     // shut2 off2 both power2 gates2 1 & 2
      else
        pwr2_on2 <= 1'b1;
   end


// Signals2 Sequential2 process - isolate_module2 
always @ (posedge pclk2 or negedge nprst2)
  begin
    if (~nprst2)
        isolate_module2 <= 1'b0;
    else
      if (nextState2 == Isolate2 | nextState2 == Save_edge2 | nextState2 == Pre_pwr_off2 |  nextState2 == Pwr_off2 | nextState2 == Pwr_on12 |
          nextState2 == Pwr_on22 | nextState2 == Restore_edge2 | nextState2 == Wait22)
         isolate_module2 <= 1'b1;       // Activate2 the isolate2 and retain2 signals2
      else
         isolate_module2 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk2 or negedge nprst2)
  begin
    if (~nprst2)
        save_edge2 <= 1'b0;
    else
      if (nextState2 == Save_edge2 )
         save_edge2 <= 1'b1;       // Activate2 the isolate2 and retain2 signals2
      else
         save_edge2 <= 1'b0;        
   end    
// stabilising2 count
wire restore_change2;
assign restore_change2 = (nextState2 == Pwr_on22) ? 1'b1: 1'b0;

always @ (posedge pclk2 or negedge nprst2)
  begin
    if (~nprst2)
      trans_cnt2 <= 0;
    else if (trans_cnt2 > 0)
      trans_cnt2  <= trans_cnt2 + 1;
    else if (restore_change2)
      trans_cnt2  <= trans_cnt2 + 1;
  end

// enabling restore2 edge
always @ (posedge pclk2 or negedge nprst2)
  begin
    if (~nprst2)
        restore_edge2 <= 1'b0;
    else
      if (nextState2 == Restore_edge2)
         restore_edge2 <= 1'b1;       // Activate2 the isolate2 and retain2 signals2
      else
         restore_edge2 <= 1'b0;        
   end    


// FSM2 Sequential2 process
always @ (posedge pclk2 or negedge nprst2)
  begin
    if (~nprst2)
      currentState2 <= Init2;
    else
      currentState2 <= nextState2;
  end


// Reset2 for non-SRPG2 FFs2 is a combination2 of the nprst2 and the reset during PSO2
assign  rstn_non_srpg_module2 = rstn_non_srpg2 & nprst2;

assign  set_status_module2 = (nextState2 == Clk_off2);    // Set the L12 status bit  
assign  clr_status_module2 = (currentState2 == Rst_clr2); // Clear the L12 status bit  
  

`ifdef LP_ABV_ON2

// psl2 default clock2 = (posedge pclk2);

// Never2 have the set and clear status signals2 both set
// psl2 output_no_set_and_clear2 : assert never {set_status_module2 & clr_status_module2};



// Isolate2 signal2 should become2 active on the 
// Next2 clock2 after Gate2 signal2 is activated2
// psl2 output_pd_seq2:
//    assert always
//	  {rose2(gate_clk_module2)} |=> {[*1]; {rose2(isolate_module2)} }
//    abort2(~nprst2);
//
//
//
// Reset2 signal2 for Non2-SRPG2 FFs2 and POWER2 signal2 for
// SMC2 should become2 LOW2 on clock2 cycle after Isolate2 
// signal2 is activated2
// psl2 output_pd_seq_stg_22:
//    assert always
//    {rose2(isolate_module2)} |=>
//    {[*2]; {{fell2(rstn_non_srpg_module2)} && {fell2(pwr1_on2)}} }
//    abort2(~nprst2);
//
//
// Whenever2 pwr1_on2 goes2 to LOW2 pwr2_on2 should also go2 to LOW2
// psl2 output_pwr2_low2:
//    assert always
//    { fell2(pwr1_on2) } |->  { fell2(pwr2_on2) }
//    abort2(~nprst2);
//
//
// Whenever2 pwr1_on2 becomes HIGH2 , On2 Next2 clock2 cycle pwr2_on2
// should also become2 HIGH2
// psl2 output_pwr2_high2:
//    assert always
//    { rose2(pwr1_on2) } |=>  { (pwr2_on2) }
//    abort2(~nprst2);
//
`endif


endmodule
