//File3 name   : power_ctrl_sm3.v
//Title3       : Power3 Controller3 state machine3
//Created3     : 1999
//Description3 : State3 machine3 of power3 controller3
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
module power_ctrl_sm3 (

    // Clocks3 & Reset3
    pclk3,
    nprst3,

    // Register Control3 inputs3
    L1_module_req3,
    set_status_module3,
    clr_status_module3,

    // Module3 control3 outputs3
    rstn_non_srpg_module3,
    gate_clk_module3,
    isolate_module3,
    save_edge3,
    restore_edge3,
    pwr1_on3,
    pwr2_on3

);

input    pclk3;
input    nprst3;

input    L1_module_req3;
output   set_status_module3;
output   clr_status_module3;
    
output   rstn_non_srpg_module3;
output   gate_clk_module3;
output   isolate_module3;
output   pwr1_on3;
output   pwr2_on3;
output save_edge3;
output restore_edge3;

wire    set_status_module3;
wire    clr_status_module3;

wire    rstn_non_srpg_module3;
reg     gate_clk_module3;
reg     isolate_module3;
reg     pwr1_on3;
reg     pwr2_on3;

reg save_edge3;

reg restore_edge3;
   
// FSM3 state
reg  [3:0] currentState3, nextState3;
reg     rstn_non_srpg3;
reg [4:0] trans_cnt3;

parameter Init3 = 0; 
parameter Clk_off3 = 1; 
parameter Wait13 = 2; 
parameter Isolate3 = 3; 
parameter Save_edge3 = 4; 
parameter Pre_pwr_off3 = 5; 
parameter Pwr_off3 = 6; 
parameter Pwr_on13 = 7; 
parameter Pwr_on23 = 8; 
parameter Restore_edge3 = 9; 
parameter Wait23 = 10; 
parameter De_isolate3 = 11; 
parameter Clk_on3 = 12; 
parameter Wait33 = 13; 
parameter Rst_clr3 = 14;


// Power3 Shut3 Off3 State3 Machine3

// FSM3 combinational3 process
always @  (*)
  begin
    case (currentState3)

      // Commence3 PSO3 once3 the L13 req bit is set.
      Init3:
        if (L1_module_req3 == 1'b1)
          nextState3 = Clk_off3;         // Gate3 the module's clocks3 off3
        else
          nextState3 = Init3;            // Keep3 waiting3 in Init3 state
        
      Clk_off3 :
        nextState3 = Wait13;             // Wait3 for one cycle
 
      Wait13  :                         // Wait3 for clk3 gating3 to take3 effect
        nextState3 = Isolate3;           // Start3 the isolation3 process
          
      Isolate3 :
        nextState3 = Save_edge3;
        
      Save_edge3 :
        nextState3 = Pre_pwr_off3;

      Pre_pwr_off3 :
        nextState3 = Pwr_off3;
      // Exit3 PSO3 once3 the L13 req bit is clear.

      Pwr_off3 :
        if (L1_module_req3 == 1'b0)
          nextState3 = Pwr_on13;         // Resume3 power3 if the L1_module_req3 bit is cleared3
        else
          nextState3 = Pwr_off3;         // Wait3 until the L1_module_req3 bit is cleared3
        
      Pwr_on13 :
        nextState3 = Pwr_on23;
          
      Pwr_on23 :
        if(trans_cnt3 == 5'd28)
          nextState3 = Restore_edge3;
        else 
          nextState3 = Pwr_on23;
          
      Restore_edge3 :
        nextState3 = Wait23;

      Wait23 :
        nextState3 = De_isolate3;
          
      De_isolate3 :
        nextState3 = Clk_on3;
          
      Clk_on3 :
        nextState3 = Wait33;
          
      Wait33  :                         // Wait3 for clock3 to resume
        nextState3 = Rst_clr3 ;     
 
      Rst_clr3 :
        nextState3 = Init3;
        
      default  :                       // Catch3 all
        nextState3 = Init3; 
        
    endcase
  end


  // Signals3 Sequential3 process - gate_clk_module3
always @ (posedge pclk3 or negedge nprst3)
  begin
    if (~nprst3)
      gate_clk_module3 <= 1'b0;
    else 
      if (nextState3 == Clk_on3 | nextState3 == Wait33 | nextState3 == Rst_clr3 | 
          nextState3 == Init3)
          gate_clk_module3 <= 1'b0;
      else
          gate_clk_module3 <= 1'b1;
  end

// Signals3 Sequential3 process - rstn_non_srpg3
always @ (posedge pclk3 or negedge nprst3)
  begin
    if (~nprst3)
      rstn_non_srpg3 <= 1'b0;
    else
      if ( nextState3 == Init3 | nextState3 == Clk_off3 | nextState3 == Wait13 | 
           nextState3 == Isolate3 | nextState3 == Save_edge3 | nextState3 == Pre_pwr_off3 | nextState3 == Rst_clr3)
        rstn_non_srpg3 <= 1'b1;
      else
        rstn_non_srpg3 <= 1'b0;
   end


// Signals3 Sequential3 process - pwr1_on3 & pwr2_on3
always @ (posedge pclk3 or negedge nprst3)
  begin
    if (~nprst3)
      pwr1_on3 <=  1'b1;  // power3 gates3 1 & 2 are on
    else
      if (nextState3 == Pwr_off3 )
        pwr1_on3 <= 1'b0;  // shut3 off3 both power3 gates3 1 & 2
      else
        pwr1_on3 <= 1'b1;
  end


// Signals3 Sequential3 process - pwr1_on3 & pwr2_on3
always @ (posedge pclk3 or negedge nprst3)
  begin
    if (~nprst3)
       pwr2_on3 <= 1'b1;      // power3 gates3 1 & 2 are on
    else
      if (nextState3 == Pwr_off3 | nextState3 == Pwr_on13)
        pwr2_on3 <= 1'b0;     // shut3 off3 both power3 gates3 1 & 2
      else
        pwr2_on3 <= 1'b1;
   end


// Signals3 Sequential3 process - isolate_module3 
always @ (posedge pclk3 or negedge nprst3)
  begin
    if (~nprst3)
        isolate_module3 <= 1'b0;
    else
      if (nextState3 == Isolate3 | nextState3 == Save_edge3 | nextState3 == Pre_pwr_off3 |  nextState3 == Pwr_off3 | nextState3 == Pwr_on13 |
          nextState3 == Pwr_on23 | nextState3 == Restore_edge3 | nextState3 == Wait23)
         isolate_module3 <= 1'b1;       // Activate3 the isolate3 and retain3 signals3
      else
         isolate_module3 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk3 or negedge nprst3)
  begin
    if (~nprst3)
        save_edge3 <= 1'b0;
    else
      if (nextState3 == Save_edge3 )
         save_edge3 <= 1'b1;       // Activate3 the isolate3 and retain3 signals3
      else
         save_edge3 <= 1'b0;        
   end    
// stabilising3 count
wire restore_change3;
assign restore_change3 = (nextState3 == Pwr_on23) ? 1'b1: 1'b0;

always @ (posedge pclk3 or negedge nprst3)
  begin
    if (~nprst3)
      trans_cnt3 <= 0;
    else if (trans_cnt3 > 0)
      trans_cnt3  <= trans_cnt3 + 1;
    else if (restore_change3)
      trans_cnt3  <= trans_cnt3 + 1;
  end

// enabling restore3 edge
always @ (posedge pclk3 or negedge nprst3)
  begin
    if (~nprst3)
        restore_edge3 <= 1'b0;
    else
      if (nextState3 == Restore_edge3)
         restore_edge3 <= 1'b1;       // Activate3 the isolate3 and retain3 signals3
      else
         restore_edge3 <= 1'b0;        
   end    


// FSM3 Sequential3 process
always @ (posedge pclk3 or negedge nprst3)
  begin
    if (~nprst3)
      currentState3 <= Init3;
    else
      currentState3 <= nextState3;
  end


// Reset3 for non-SRPG3 FFs3 is a combination3 of the nprst3 and the reset during PSO3
assign  rstn_non_srpg_module3 = rstn_non_srpg3 & nprst3;

assign  set_status_module3 = (nextState3 == Clk_off3);    // Set the L13 status bit  
assign  clr_status_module3 = (currentState3 == Rst_clr3); // Clear the L13 status bit  
  

`ifdef LP_ABV_ON3

// psl3 default clock3 = (posedge pclk3);

// Never3 have the set and clear status signals3 both set
// psl3 output_no_set_and_clear3 : assert never {set_status_module3 & clr_status_module3};



// Isolate3 signal3 should become3 active on the 
// Next3 clock3 after Gate3 signal3 is activated3
// psl3 output_pd_seq3:
//    assert always
//	  {rose3(gate_clk_module3)} |=> {[*1]; {rose3(isolate_module3)} }
//    abort3(~nprst3);
//
//
//
// Reset3 signal3 for Non3-SRPG3 FFs3 and POWER3 signal3 for
// SMC3 should become3 LOW3 on clock3 cycle after Isolate3 
// signal3 is activated3
// psl3 output_pd_seq_stg_23:
//    assert always
//    {rose3(isolate_module3)} |=>
//    {[*2]; {{fell3(rstn_non_srpg_module3)} && {fell3(pwr1_on3)}} }
//    abort3(~nprst3);
//
//
// Whenever3 pwr1_on3 goes3 to LOW3 pwr2_on3 should also go3 to LOW3
// psl3 output_pwr2_low3:
//    assert always
//    { fell3(pwr1_on3) } |->  { fell3(pwr2_on3) }
//    abort3(~nprst3);
//
//
// Whenever3 pwr1_on3 becomes HIGH3 , On3 Next3 clock3 cycle pwr2_on3
// should also become3 HIGH3
// psl3 output_pwr2_high3:
//    assert always
//    { rose3(pwr1_on3) } |=>  { (pwr2_on3) }
//    abort3(~nprst3);
//
`endif


endmodule
