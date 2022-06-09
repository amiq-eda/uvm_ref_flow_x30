//File6 name   : power_ctrl_sm6.v
//Title6       : Power6 Controller6 state machine6
//Created6     : 1999
//Description6 : State6 machine6 of power6 controller6
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
module power_ctrl_sm6 (

    // Clocks6 & Reset6
    pclk6,
    nprst6,

    // Register Control6 inputs6
    L1_module_req6,
    set_status_module6,
    clr_status_module6,

    // Module6 control6 outputs6
    rstn_non_srpg_module6,
    gate_clk_module6,
    isolate_module6,
    save_edge6,
    restore_edge6,
    pwr1_on6,
    pwr2_on6

);

input    pclk6;
input    nprst6;

input    L1_module_req6;
output   set_status_module6;
output   clr_status_module6;
    
output   rstn_non_srpg_module6;
output   gate_clk_module6;
output   isolate_module6;
output   pwr1_on6;
output   pwr2_on6;
output save_edge6;
output restore_edge6;

wire    set_status_module6;
wire    clr_status_module6;

wire    rstn_non_srpg_module6;
reg     gate_clk_module6;
reg     isolate_module6;
reg     pwr1_on6;
reg     pwr2_on6;

reg save_edge6;

reg restore_edge6;
   
// FSM6 state
reg  [3:0] currentState6, nextState6;
reg     rstn_non_srpg6;
reg [4:0] trans_cnt6;

parameter Init6 = 0; 
parameter Clk_off6 = 1; 
parameter Wait16 = 2; 
parameter Isolate6 = 3; 
parameter Save_edge6 = 4; 
parameter Pre_pwr_off6 = 5; 
parameter Pwr_off6 = 6; 
parameter Pwr_on16 = 7; 
parameter Pwr_on26 = 8; 
parameter Restore_edge6 = 9; 
parameter Wait26 = 10; 
parameter De_isolate6 = 11; 
parameter Clk_on6 = 12; 
parameter Wait36 = 13; 
parameter Rst_clr6 = 14;


// Power6 Shut6 Off6 State6 Machine6

// FSM6 combinational6 process
always @  (*)
  begin
    case (currentState6)

      // Commence6 PSO6 once6 the L16 req bit is set.
      Init6:
        if (L1_module_req6 == 1'b1)
          nextState6 = Clk_off6;         // Gate6 the module's clocks6 off6
        else
          nextState6 = Init6;            // Keep6 waiting6 in Init6 state
        
      Clk_off6 :
        nextState6 = Wait16;             // Wait6 for one cycle
 
      Wait16  :                         // Wait6 for clk6 gating6 to take6 effect
        nextState6 = Isolate6;           // Start6 the isolation6 process
          
      Isolate6 :
        nextState6 = Save_edge6;
        
      Save_edge6 :
        nextState6 = Pre_pwr_off6;

      Pre_pwr_off6 :
        nextState6 = Pwr_off6;
      // Exit6 PSO6 once6 the L16 req bit is clear.

      Pwr_off6 :
        if (L1_module_req6 == 1'b0)
          nextState6 = Pwr_on16;         // Resume6 power6 if the L1_module_req6 bit is cleared6
        else
          nextState6 = Pwr_off6;         // Wait6 until the L1_module_req6 bit is cleared6
        
      Pwr_on16 :
        nextState6 = Pwr_on26;
          
      Pwr_on26 :
        if(trans_cnt6 == 5'd28)
          nextState6 = Restore_edge6;
        else 
          nextState6 = Pwr_on26;
          
      Restore_edge6 :
        nextState6 = Wait26;

      Wait26 :
        nextState6 = De_isolate6;
          
      De_isolate6 :
        nextState6 = Clk_on6;
          
      Clk_on6 :
        nextState6 = Wait36;
          
      Wait36  :                         // Wait6 for clock6 to resume
        nextState6 = Rst_clr6 ;     
 
      Rst_clr6 :
        nextState6 = Init6;
        
      default  :                       // Catch6 all
        nextState6 = Init6; 
        
    endcase
  end


  // Signals6 Sequential6 process - gate_clk_module6
always @ (posedge pclk6 or negedge nprst6)
  begin
    if (~nprst6)
      gate_clk_module6 <= 1'b0;
    else 
      if (nextState6 == Clk_on6 | nextState6 == Wait36 | nextState6 == Rst_clr6 | 
          nextState6 == Init6)
          gate_clk_module6 <= 1'b0;
      else
          gate_clk_module6 <= 1'b1;
  end

// Signals6 Sequential6 process - rstn_non_srpg6
always @ (posedge pclk6 or negedge nprst6)
  begin
    if (~nprst6)
      rstn_non_srpg6 <= 1'b0;
    else
      if ( nextState6 == Init6 | nextState6 == Clk_off6 | nextState6 == Wait16 | 
           nextState6 == Isolate6 | nextState6 == Save_edge6 | nextState6 == Pre_pwr_off6 | nextState6 == Rst_clr6)
        rstn_non_srpg6 <= 1'b1;
      else
        rstn_non_srpg6 <= 1'b0;
   end


// Signals6 Sequential6 process - pwr1_on6 & pwr2_on6
always @ (posedge pclk6 or negedge nprst6)
  begin
    if (~nprst6)
      pwr1_on6 <=  1'b1;  // power6 gates6 1 & 2 are on
    else
      if (nextState6 == Pwr_off6 )
        pwr1_on6 <= 1'b0;  // shut6 off6 both power6 gates6 1 & 2
      else
        pwr1_on6 <= 1'b1;
  end


// Signals6 Sequential6 process - pwr1_on6 & pwr2_on6
always @ (posedge pclk6 or negedge nprst6)
  begin
    if (~nprst6)
       pwr2_on6 <= 1'b1;      // power6 gates6 1 & 2 are on
    else
      if (nextState6 == Pwr_off6 | nextState6 == Pwr_on16)
        pwr2_on6 <= 1'b0;     // shut6 off6 both power6 gates6 1 & 2
      else
        pwr2_on6 <= 1'b1;
   end


// Signals6 Sequential6 process - isolate_module6 
always @ (posedge pclk6 or negedge nprst6)
  begin
    if (~nprst6)
        isolate_module6 <= 1'b0;
    else
      if (nextState6 == Isolate6 | nextState6 == Save_edge6 | nextState6 == Pre_pwr_off6 |  nextState6 == Pwr_off6 | nextState6 == Pwr_on16 |
          nextState6 == Pwr_on26 | nextState6 == Restore_edge6 | nextState6 == Wait26)
         isolate_module6 <= 1'b1;       // Activate6 the isolate6 and retain6 signals6
      else
         isolate_module6 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk6 or negedge nprst6)
  begin
    if (~nprst6)
        save_edge6 <= 1'b0;
    else
      if (nextState6 == Save_edge6 )
         save_edge6 <= 1'b1;       // Activate6 the isolate6 and retain6 signals6
      else
         save_edge6 <= 1'b0;        
   end    
// stabilising6 count
wire restore_change6;
assign restore_change6 = (nextState6 == Pwr_on26) ? 1'b1: 1'b0;

always @ (posedge pclk6 or negedge nprst6)
  begin
    if (~nprst6)
      trans_cnt6 <= 0;
    else if (trans_cnt6 > 0)
      trans_cnt6  <= trans_cnt6 + 1;
    else if (restore_change6)
      trans_cnt6  <= trans_cnt6 + 1;
  end

// enabling restore6 edge
always @ (posedge pclk6 or negedge nprst6)
  begin
    if (~nprst6)
        restore_edge6 <= 1'b0;
    else
      if (nextState6 == Restore_edge6)
         restore_edge6 <= 1'b1;       // Activate6 the isolate6 and retain6 signals6
      else
         restore_edge6 <= 1'b0;        
   end    


// FSM6 Sequential6 process
always @ (posedge pclk6 or negedge nprst6)
  begin
    if (~nprst6)
      currentState6 <= Init6;
    else
      currentState6 <= nextState6;
  end


// Reset6 for non-SRPG6 FFs6 is a combination6 of the nprst6 and the reset during PSO6
assign  rstn_non_srpg_module6 = rstn_non_srpg6 & nprst6;

assign  set_status_module6 = (nextState6 == Clk_off6);    // Set the L16 status bit  
assign  clr_status_module6 = (currentState6 == Rst_clr6); // Clear the L16 status bit  
  

`ifdef LP_ABV_ON6

// psl6 default clock6 = (posedge pclk6);

// Never6 have the set and clear status signals6 both set
// psl6 output_no_set_and_clear6 : assert never {set_status_module6 & clr_status_module6};



// Isolate6 signal6 should become6 active on the 
// Next6 clock6 after Gate6 signal6 is activated6
// psl6 output_pd_seq6:
//    assert always
//	  {rose6(gate_clk_module6)} |=> {[*1]; {rose6(isolate_module6)} }
//    abort6(~nprst6);
//
//
//
// Reset6 signal6 for Non6-SRPG6 FFs6 and POWER6 signal6 for
// SMC6 should become6 LOW6 on clock6 cycle after Isolate6 
// signal6 is activated6
// psl6 output_pd_seq_stg_26:
//    assert always
//    {rose6(isolate_module6)} |=>
//    {[*2]; {{fell6(rstn_non_srpg_module6)} && {fell6(pwr1_on6)}} }
//    abort6(~nprst6);
//
//
// Whenever6 pwr1_on6 goes6 to LOW6 pwr2_on6 should also go6 to LOW6
// psl6 output_pwr2_low6:
//    assert always
//    { fell6(pwr1_on6) } |->  { fell6(pwr2_on6) }
//    abort6(~nprst6);
//
//
// Whenever6 pwr1_on6 becomes HIGH6 , On6 Next6 clock6 cycle pwr2_on6
// should also become6 HIGH6
// psl6 output_pwr2_high6:
//    assert always
//    { rose6(pwr1_on6) } |=>  { (pwr2_on6) }
//    abort6(~nprst6);
//
`endif


endmodule
