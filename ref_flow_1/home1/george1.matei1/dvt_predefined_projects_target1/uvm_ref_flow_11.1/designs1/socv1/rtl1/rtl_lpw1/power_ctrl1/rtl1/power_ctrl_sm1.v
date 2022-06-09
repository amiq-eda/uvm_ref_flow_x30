//File1 name   : power_ctrl_sm1.v
//Title1       : Power1 Controller1 state machine1
//Created1     : 1999
//Description1 : State1 machine1 of power1 controller1
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
module power_ctrl_sm1 (

    // Clocks1 & Reset1
    pclk1,
    nprst1,

    // Register Control1 inputs1
    L1_module_req1,
    set_status_module1,
    clr_status_module1,

    // Module1 control1 outputs1
    rstn_non_srpg_module1,
    gate_clk_module1,
    isolate_module1,
    save_edge1,
    restore_edge1,
    pwr1_on1,
    pwr2_on1

);

input    pclk1;
input    nprst1;

input    L1_module_req1;
output   set_status_module1;
output   clr_status_module1;
    
output   rstn_non_srpg_module1;
output   gate_clk_module1;
output   isolate_module1;
output   pwr1_on1;
output   pwr2_on1;
output save_edge1;
output restore_edge1;

wire    set_status_module1;
wire    clr_status_module1;

wire    rstn_non_srpg_module1;
reg     gate_clk_module1;
reg     isolate_module1;
reg     pwr1_on1;
reg     pwr2_on1;

reg save_edge1;

reg restore_edge1;
   
// FSM1 state
reg  [3:0] currentState1, nextState1;
reg     rstn_non_srpg1;
reg [4:0] trans_cnt1;

parameter Init1 = 0; 
parameter Clk_off1 = 1; 
parameter Wait11 = 2; 
parameter Isolate1 = 3; 
parameter Save_edge1 = 4; 
parameter Pre_pwr_off1 = 5; 
parameter Pwr_off1 = 6; 
parameter Pwr_on11 = 7; 
parameter Pwr_on21 = 8; 
parameter Restore_edge1 = 9; 
parameter Wait21 = 10; 
parameter De_isolate1 = 11; 
parameter Clk_on1 = 12; 
parameter Wait31 = 13; 
parameter Rst_clr1 = 14;


// Power1 Shut1 Off1 State1 Machine1

// FSM1 combinational1 process
always @  (*)
  begin
    case (currentState1)

      // Commence1 PSO1 once1 the L11 req bit is set.
      Init1:
        if (L1_module_req1 == 1'b1)
          nextState1 = Clk_off1;         // Gate1 the module's clocks1 off1
        else
          nextState1 = Init1;            // Keep1 waiting1 in Init1 state
        
      Clk_off1 :
        nextState1 = Wait11;             // Wait1 for one cycle
 
      Wait11  :                         // Wait1 for clk1 gating1 to take1 effect
        nextState1 = Isolate1;           // Start1 the isolation1 process
          
      Isolate1 :
        nextState1 = Save_edge1;
        
      Save_edge1 :
        nextState1 = Pre_pwr_off1;

      Pre_pwr_off1 :
        nextState1 = Pwr_off1;
      // Exit1 PSO1 once1 the L11 req bit is clear.

      Pwr_off1 :
        if (L1_module_req1 == 1'b0)
          nextState1 = Pwr_on11;         // Resume1 power1 if the L1_module_req1 bit is cleared1
        else
          nextState1 = Pwr_off1;         // Wait1 until the L1_module_req1 bit is cleared1
        
      Pwr_on11 :
        nextState1 = Pwr_on21;
          
      Pwr_on21 :
        if(trans_cnt1 == 5'd28)
          nextState1 = Restore_edge1;
        else 
          nextState1 = Pwr_on21;
          
      Restore_edge1 :
        nextState1 = Wait21;

      Wait21 :
        nextState1 = De_isolate1;
          
      De_isolate1 :
        nextState1 = Clk_on1;
          
      Clk_on1 :
        nextState1 = Wait31;
          
      Wait31  :                         // Wait1 for clock1 to resume
        nextState1 = Rst_clr1 ;     
 
      Rst_clr1 :
        nextState1 = Init1;
        
      default  :                       // Catch1 all
        nextState1 = Init1; 
        
    endcase
  end


  // Signals1 Sequential1 process - gate_clk_module1
always @ (posedge pclk1 or negedge nprst1)
  begin
    if (~nprst1)
      gate_clk_module1 <= 1'b0;
    else 
      if (nextState1 == Clk_on1 | nextState1 == Wait31 | nextState1 == Rst_clr1 | 
          nextState1 == Init1)
          gate_clk_module1 <= 1'b0;
      else
          gate_clk_module1 <= 1'b1;
  end

// Signals1 Sequential1 process - rstn_non_srpg1
always @ (posedge pclk1 or negedge nprst1)
  begin
    if (~nprst1)
      rstn_non_srpg1 <= 1'b0;
    else
      if ( nextState1 == Init1 | nextState1 == Clk_off1 | nextState1 == Wait11 | 
           nextState1 == Isolate1 | nextState1 == Save_edge1 | nextState1 == Pre_pwr_off1 | nextState1 == Rst_clr1)
        rstn_non_srpg1 <= 1'b1;
      else
        rstn_non_srpg1 <= 1'b0;
   end


// Signals1 Sequential1 process - pwr1_on1 & pwr2_on1
always @ (posedge pclk1 or negedge nprst1)
  begin
    if (~nprst1)
      pwr1_on1 <=  1'b1;  // power1 gates1 1 & 2 are on
    else
      if (nextState1 == Pwr_off1 )
        pwr1_on1 <= 1'b0;  // shut1 off1 both power1 gates1 1 & 2
      else
        pwr1_on1 <= 1'b1;
  end


// Signals1 Sequential1 process - pwr1_on1 & pwr2_on1
always @ (posedge pclk1 or negedge nprst1)
  begin
    if (~nprst1)
       pwr2_on1 <= 1'b1;      // power1 gates1 1 & 2 are on
    else
      if (nextState1 == Pwr_off1 | nextState1 == Pwr_on11)
        pwr2_on1 <= 1'b0;     // shut1 off1 both power1 gates1 1 & 2
      else
        pwr2_on1 <= 1'b1;
   end


// Signals1 Sequential1 process - isolate_module1 
always @ (posedge pclk1 or negedge nprst1)
  begin
    if (~nprst1)
        isolate_module1 <= 1'b0;
    else
      if (nextState1 == Isolate1 | nextState1 == Save_edge1 | nextState1 == Pre_pwr_off1 |  nextState1 == Pwr_off1 | nextState1 == Pwr_on11 |
          nextState1 == Pwr_on21 | nextState1 == Restore_edge1 | nextState1 == Wait21)
         isolate_module1 <= 1'b1;       // Activate1 the isolate1 and retain1 signals1
      else
         isolate_module1 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk1 or negedge nprst1)
  begin
    if (~nprst1)
        save_edge1 <= 1'b0;
    else
      if (nextState1 == Save_edge1 )
         save_edge1 <= 1'b1;       // Activate1 the isolate1 and retain1 signals1
      else
         save_edge1 <= 1'b0;        
   end    
// stabilising1 count
wire restore_change1;
assign restore_change1 = (nextState1 == Pwr_on21) ? 1'b1: 1'b0;

always @ (posedge pclk1 or negedge nprst1)
  begin
    if (~nprst1)
      trans_cnt1 <= 0;
    else if (trans_cnt1 > 0)
      trans_cnt1  <= trans_cnt1 + 1;
    else if (restore_change1)
      trans_cnt1  <= trans_cnt1 + 1;
  end

// enabling restore1 edge
always @ (posedge pclk1 or negedge nprst1)
  begin
    if (~nprst1)
        restore_edge1 <= 1'b0;
    else
      if (nextState1 == Restore_edge1)
         restore_edge1 <= 1'b1;       // Activate1 the isolate1 and retain1 signals1
      else
         restore_edge1 <= 1'b0;        
   end    


// FSM1 Sequential1 process
always @ (posedge pclk1 or negedge nprst1)
  begin
    if (~nprst1)
      currentState1 <= Init1;
    else
      currentState1 <= nextState1;
  end


// Reset1 for non-SRPG1 FFs1 is a combination1 of the nprst1 and the reset during PSO1
assign  rstn_non_srpg_module1 = rstn_non_srpg1 & nprst1;

assign  set_status_module1 = (nextState1 == Clk_off1);    // Set the L11 status bit  
assign  clr_status_module1 = (currentState1 == Rst_clr1); // Clear the L11 status bit  
  

`ifdef LP_ABV_ON1

// psl1 default clock1 = (posedge pclk1);

// Never1 have the set and clear status signals1 both set
// psl1 output_no_set_and_clear1 : assert never {set_status_module1 & clr_status_module1};



// Isolate1 signal1 should become1 active on the 
// Next1 clock1 after Gate1 signal1 is activated1
// psl1 output_pd_seq1:
//    assert always
//	  {rose1(gate_clk_module1)} |=> {[*1]; {rose1(isolate_module1)} }
//    abort1(~nprst1);
//
//
//
// Reset1 signal1 for Non1-SRPG1 FFs1 and POWER1 signal1 for
// SMC1 should become1 LOW1 on clock1 cycle after Isolate1 
// signal1 is activated1
// psl1 output_pd_seq_stg_21:
//    assert always
//    {rose1(isolate_module1)} |=>
//    {[*2]; {{fell1(rstn_non_srpg_module1)} && {fell1(pwr1_on1)}} }
//    abort1(~nprst1);
//
//
// Whenever1 pwr1_on1 goes1 to LOW1 pwr2_on1 should also go1 to LOW1
// psl1 output_pwr2_low1:
//    assert always
//    { fell1(pwr1_on1) } |->  { fell1(pwr2_on1) }
//    abort1(~nprst1);
//
//
// Whenever1 pwr1_on1 becomes HIGH1 , On1 Next1 clock1 cycle pwr2_on1
// should also become1 HIGH1
// psl1 output_pwr2_high1:
//    assert always
//    { rose1(pwr1_on1) } |=>  { (pwr2_on1) }
//    abort1(~nprst1);
//
`endif


endmodule
