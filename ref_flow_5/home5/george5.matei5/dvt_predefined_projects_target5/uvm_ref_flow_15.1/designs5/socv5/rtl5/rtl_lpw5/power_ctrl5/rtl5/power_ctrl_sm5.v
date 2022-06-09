//File5 name   : power_ctrl_sm5.v
//Title5       : Power5 Controller5 state machine5
//Created5     : 1999
//Description5 : State5 machine5 of power5 controller5
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
module power_ctrl_sm5 (

    // Clocks5 & Reset5
    pclk5,
    nprst5,

    // Register Control5 inputs5
    L1_module_req5,
    set_status_module5,
    clr_status_module5,

    // Module5 control5 outputs5
    rstn_non_srpg_module5,
    gate_clk_module5,
    isolate_module5,
    save_edge5,
    restore_edge5,
    pwr1_on5,
    pwr2_on5

);

input    pclk5;
input    nprst5;

input    L1_module_req5;
output   set_status_module5;
output   clr_status_module5;
    
output   rstn_non_srpg_module5;
output   gate_clk_module5;
output   isolate_module5;
output   pwr1_on5;
output   pwr2_on5;
output save_edge5;
output restore_edge5;

wire    set_status_module5;
wire    clr_status_module5;

wire    rstn_non_srpg_module5;
reg     gate_clk_module5;
reg     isolate_module5;
reg     pwr1_on5;
reg     pwr2_on5;

reg save_edge5;

reg restore_edge5;
   
// FSM5 state
reg  [3:0] currentState5, nextState5;
reg     rstn_non_srpg5;
reg [4:0] trans_cnt5;

parameter Init5 = 0; 
parameter Clk_off5 = 1; 
parameter Wait15 = 2; 
parameter Isolate5 = 3; 
parameter Save_edge5 = 4; 
parameter Pre_pwr_off5 = 5; 
parameter Pwr_off5 = 6; 
parameter Pwr_on15 = 7; 
parameter Pwr_on25 = 8; 
parameter Restore_edge5 = 9; 
parameter Wait25 = 10; 
parameter De_isolate5 = 11; 
parameter Clk_on5 = 12; 
parameter Wait35 = 13; 
parameter Rst_clr5 = 14;


// Power5 Shut5 Off5 State5 Machine5

// FSM5 combinational5 process
always @  (*)
  begin
    case (currentState5)

      // Commence5 PSO5 once5 the L15 req bit is set.
      Init5:
        if (L1_module_req5 == 1'b1)
          nextState5 = Clk_off5;         // Gate5 the module's clocks5 off5
        else
          nextState5 = Init5;            // Keep5 waiting5 in Init5 state
        
      Clk_off5 :
        nextState5 = Wait15;             // Wait5 for one cycle
 
      Wait15  :                         // Wait5 for clk5 gating5 to take5 effect
        nextState5 = Isolate5;           // Start5 the isolation5 process
          
      Isolate5 :
        nextState5 = Save_edge5;
        
      Save_edge5 :
        nextState5 = Pre_pwr_off5;

      Pre_pwr_off5 :
        nextState5 = Pwr_off5;
      // Exit5 PSO5 once5 the L15 req bit is clear.

      Pwr_off5 :
        if (L1_module_req5 == 1'b0)
          nextState5 = Pwr_on15;         // Resume5 power5 if the L1_module_req5 bit is cleared5
        else
          nextState5 = Pwr_off5;         // Wait5 until the L1_module_req5 bit is cleared5
        
      Pwr_on15 :
        nextState5 = Pwr_on25;
          
      Pwr_on25 :
        if(trans_cnt5 == 5'd28)
          nextState5 = Restore_edge5;
        else 
          nextState5 = Pwr_on25;
          
      Restore_edge5 :
        nextState5 = Wait25;

      Wait25 :
        nextState5 = De_isolate5;
          
      De_isolate5 :
        nextState5 = Clk_on5;
          
      Clk_on5 :
        nextState5 = Wait35;
          
      Wait35  :                         // Wait5 for clock5 to resume
        nextState5 = Rst_clr5 ;     
 
      Rst_clr5 :
        nextState5 = Init5;
        
      default  :                       // Catch5 all
        nextState5 = Init5; 
        
    endcase
  end


  // Signals5 Sequential5 process - gate_clk_module5
always @ (posedge pclk5 or negedge nprst5)
  begin
    if (~nprst5)
      gate_clk_module5 <= 1'b0;
    else 
      if (nextState5 == Clk_on5 | nextState5 == Wait35 | nextState5 == Rst_clr5 | 
          nextState5 == Init5)
          gate_clk_module5 <= 1'b0;
      else
          gate_clk_module5 <= 1'b1;
  end

// Signals5 Sequential5 process - rstn_non_srpg5
always @ (posedge pclk5 or negedge nprst5)
  begin
    if (~nprst5)
      rstn_non_srpg5 <= 1'b0;
    else
      if ( nextState5 == Init5 | nextState5 == Clk_off5 | nextState5 == Wait15 | 
           nextState5 == Isolate5 | nextState5 == Save_edge5 | nextState5 == Pre_pwr_off5 | nextState5 == Rst_clr5)
        rstn_non_srpg5 <= 1'b1;
      else
        rstn_non_srpg5 <= 1'b0;
   end


// Signals5 Sequential5 process - pwr1_on5 & pwr2_on5
always @ (posedge pclk5 or negedge nprst5)
  begin
    if (~nprst5)
      pwr1_on5 <=  1'b1;  // power5 gates5 1 & 2 are on
    else
      if (nextState5 == Pwr_off5 )
        pwr1_on5 <= 1'b0;  // shut5 off5 both power5 gates5 1 & 2
      else
        pwr1_on5 <= 1'b1;
  end


// Signals5 Sequential5 process - pwr1_on5 & pwr2_on5
always @ (posedge pclk5 or negedge nprst5)
  begin
    if (~nprst5)
       pwr2_on5 <= 1'b1;      // power5 gates5 1 & 2 are on
    else
      if (nextState5 == Pwr_off5 | nextState5 == Pwr_on15)
        pwr2_on5 <= 1'b0;     // shut5 off5 both power5 gates5 1 & 2
      else
        pwr2_on5 <= 1'b1;
   end


// Signals5 Sequential5 process - isolate_module5 
always @ (posedge pclk5 or negedge nprst5)
  begin
    if (~nprst5)
        isolate_module5 <= 1'b0;
    else
      if (nextState5 == Isolate5 | nextState5 == Save_edge5 | nextState5 == Pre_pwr_off5 |  nextState5 == Pwr_off5 | nextState5 == Pwr_on15 |
          nextState5 == Pwr_on25 | nextState5 == Restore_edge5 | nextState5 == Wait25)
         isolate_module5 <= 1'b1;       // Activate5 the isolate5 and retain5 signals5
      else
         isolate_module5 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk5 or negedge nprst5)
  begin
    if (~nprst5)
        save_edge5 <= 1'b0;
    else
      if (nextState5 == Save_edge5 )
         save_edge5 <= 1'b1;       // Activate5 the isolate5 and retain5 signals5
      else
         save_edge5 <= 1'b0;        
   end    
// stabilising5 count
wire restore_change5;
assign restore_change5 = (nextState5 == Pwr_on25) ? 1'b1: 1'b0;

always @ (posedge pclk5 or negedge nprst5)
  begin
    if (~nprst5)
      trans_cnt5 <= 0;
    else if (trans_cnt5 > 0)
      trans_cnt5  <= trans_cnt5 + 1;
    else if (restore_change5)
      trans_cnt5  <= trans_cnt5 + 1;
  end

// enabling restore5 edge
always @ (posedge pclk5 or negedge nprst5)
  begin
    if (~nprst5)
        restore_edge5 <= 1'b0;
    else
      if (nextState5 == Restore_edge5)
         restore_edge5 <= 1'b1;       // Activate5 the isolate5 and retain5 signals5
      else
         restore_edge5 <= 1'b0;        
   end    


// FSM5 Sequential5 process
always @ (posedge pclk5 or negedge nprst5)
  begin
    if (~nprst5)
      currentState5 <= Init5;
    else
      currentState5 <= nextState5;
  end


// Reset5 for non-SRPG5 FFs5 is a combination5 of the nprst5 and the reset during PSO5
assign  rstn_non_srpg_module5 = rstn_non_srpg5 & nprst5;

assign  set_status_module5 = (nextState5 == Clk_off5);    // Set the L15 status bit  
assign  clr_status_module5 = (currentState5 == Rst_clr5); // Clear the L15 status bit  
  

`ifdef LP_ABV_ON5

// psl5 default clock5 = (posedge pclk5);

// Never5 have the set and clear status signals5 both set
// psl5 output_no_set_and_clear5 : assert never {set_status_module5 & clr_status_module5};



// Isolate5 signal5 should become5 active on the 
// Next5 clock5 after Gate5 signal5 is activated5
// psl5 output_pd_seq5:
//    assert always
//	  {rose5(gate_clk_module5)} |=> {[*1]; {rose5(isolate_module5)} }
//    abort5(~nprst5);
//
//
//
// Reset5 signal5 for Non5-SRPG5 FFs5 and POWER5 signal5 for
// SMC5 should become5 LOW5 on clock5 cycle after Isolate5 
// signal5 is activated5
// psl5 output_pd_seq_stg_25:
//    assert always
//    {rose5(isolate_module5)} |=>
//    {[*2]; {{fell5(rstn_non_srpg_module5)} && {fell5(pwr1_on5)}} }
//    abort5(~nprst5);
//
//
// Whenever5 pwr1_on5 goes5 to LOW5 pwr2_on5 should also go5 to LOW5
// psl5 output_pwr2_low5:
//    assert always
//    { fell5(pwr1_on5) } |->  { fell5(pwr2_on5) }
//    abort5(~nprst5);
//
//
// Whenever5 pwr1_on5 becomes HIGH5 , On5 Next5 clock5 cycle pwr2_on5
// should also become5 HIGH5
// psl5 output_pwr2_high5:
//    assert always
//    { rose5(pwr1_on5) } |=>  { (pwr2_on5) }
//    abort5(~nprst5);
//
`endif


endmodule
