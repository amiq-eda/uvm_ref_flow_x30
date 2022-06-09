//File18 name   : power_ctrl_sm18.v
//Title18       : Power18 Controller18 state machine18
//Created18     : 1999
//Description18 : State18 machine18 of power18 controller18
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
module power_ctrl_sm18 (

    // Clocks18 & Reset18
    pclk18,
    nprst18,

    // Register Control18 inputs18
    L1_module_req18,
    set_status_module18,
    clr_status_module18,

    // Module18 control18 outputs18
    rstn_non_srpg_module18,
    gate_clk_module18,
    isolate_module18,
    save_edge18,
    restore_edge18,
    pwr1_on18,
    pwr2_on18

);

input    pclk18;
input    nprst18;

input    L1_module_req18;
output   set_status_module18;
output   clr_status_module18;
    
output   rstn_non_srpg_module18;
output   gate_clk_module18;
output   isolate_module18;
output   pwr1_on18;
output   pwr2_on18;
output save_edge18;
output restore_edge18;

wire    set_status_module18;
wire    clr_status_module18;

wire    rstn_non_srpg_module18;
reg     gate_clk_module18;
reg     isolate_module18;
reg     pwr1_on18;
reg     pwr2_on18;

reg save_edge18;

reg restore_edge18;
   
// FSM18 state
reg  [3:0] currentState18, nextState18;
reg     rstn_non_srpg18;
reg [4:0] trans_cnt18;

parameter Init18 = 0; 
parameter Clk_off18 = 1; 
parameter Wait118 = 2; 
parameter Isolate18 = 3; 
parameter Save_edge18 = 4; 
parameter Pre_pwr_off18 = 5; 
parameter Pwr_off18 = 6; 
parameter Pwr_on118 = 7; 
parameter Pwr_on218 = 8; 
parameter Restore_edge18 = 9; 
parameter Wait218 = 10; 
parameter De_isolate18 = 11; 
parameter Clk_on18 = 12; 
parameter Wait318 = 13; 
parameter Rst_clr18 = 14;


// Power18 Shut18 Off18 State18 Machine18

// FSM18 combinational18 process
always @  (*)
  begin
    case (currentState18)

      // Commence18 PSO18 once18 the L118 req bit is set.
      Init18:
        if (L1_module_req18 == 1'b1)
          nextState18 = Clk_off18;         // Gate18 the module's clocks18 off18
        else
          nextState18 = Init18;            // Keep18 waiting18 in Init18 state
        
      Clk_off18 :
        nextState18 = Wait118;             // Wait18 for one cycle
 
      Wait118  :                         // Wait18 for clk18 gating18 to take18 effect
        nextState18 = Isolate18;           // Start18 the isolation18 process
          
      Isolate18 :
        nextState18 = Save_edge18;
        
      Save_edge18 :
        nextState18 = Pre_pwr_off18;

      Pre_pwr_off18 :
        nextState18 = Pwr_off18;
      // Exit18 PSO18 once18 the L118 req bit is clear.

      Pwr_off18 :
        if (L1_module_req18 == 1'b0)
          nextState18 = Pwr_on118;         // Resume18 power18 if the L1_module_req18 bit is cleared18
        else
          nextState18 = Pwr_off18;         // Wait18 until the L1_module_req18 bit is cleared18
        
      Pwr_on118 :
        nextState18 = Pwr_on218;
          
      Pwr_on218 :
        if(trans_cnt18 == 5'd28)
          nextState18 = Restore_edge18;
        else 
          nextState18 = Pwr_on218;
          
      Restore_edge18 :
        nextState18 = Wait218;

      Wait218 :
        nextState18 = De_isolate18;
          
      De_isolate18 :
        nextState18 = Clk_on18;
          
      Clk_on18 :
        nextState18 = Wait318;
          
      Wait318  :                         // Wait18 for clock18 to resume
        nextState18 = Rst_clr18 ;     
 
      Rst_clr18 :
        nextState18 = Init18;
        
      default  :                       // Catch18 all
        nextState18 = Init18; 
        
    endcase
  end


  // Signals18 Sequential18 process - gate_clk_module18
always @ (posedge pclk18 or negedge nprst18)
  begin
    if (~nprst18)
      gate_clk_module18 <= 1'b0;
    else 
      if (nextState18 == Clk_on18 | nextState18 == Wait318 | nextState18 == Rst_clr18 | 
          nextState18 == Init18)
          gate_clk_module18 <= 1'b0;
      else
          gate_clk_module18 <= 1'b1;
  end

// Signals18 Sequential18 process - rstn_non_srpg18
always @ (posedge pclk18 or negedge nprst18)
  begin
    if (~nprst18)
      rstn_non_srpg18 <= 1'b0;
    else
      if ( nextState18 == Init18 | nextState18 == Clk_off18 | nextState18 == Wait118 | 
           nextState18 == Isolate18 | nextState18 == Save_edge18 | nextState18 == Pre_pwr_off18 | nextState18 == Rst_clr18)
        rstn_non_srpg18 <= 1'b1;
      else
        rstn_non_srpg18 <= 1'b0;
   end


// Signals18 Sequential18 process - pwr1_on18 & pwr2_on18
always @ (posedge pclk18 or negedge nprst18)
  begin
    if (~nprst18)
      pwr1_on18 <=  1'b1;  // power18 gates18 1 & 2 are on
    else
      if (nextState18 == Pwr_off18 )
        pwr1_on18 <= 1'b0;  // shut18 off18 both power18 gates18 1 & 2
      else
        pwr1_on18 <= 1'b1;
  end


// Signals18 Sequential18 process - pwr1_on18 & pwr2_on18
always @ (posedge pclk18 or negedge nprst18)
  begin
    if (~nprst18)
       pwr2_on18 <= 1'b1;      // power18 gates18 1 & 2 are on
    else
      if (nextState18 == Pwr_off18 | nextState18 == Pwr_on118)
        pwr2_on18 <= 1'b0;     // shut18 off18 both power18 gates18 1 & 2
      else
        pwr2_on18 <= 1'b1;
   end


// Signals18 Sequential18 process - isolate_module18 
always @ (posedge pclk18 or negedge nprst18)
  begin
    if (~nprst18)
        isolate_module18 <= 1'b0;
    else
      if (nextState18 == Isolate18 | nextState18 == Save_edge18 | nextState18 == Pre_pwr_off18 |  nextState18 == Pwr_off18 | nextState18 == Pwr_on118 |
          nextState18 == Pwr_on218 | nextState18 == Restore_edge18 | nextState18 == Wait218)
         isolate_module18 <= 1'b1;       // Activate18 the isolate18 and retain18 signals18
      else
         isolate_module18 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk18 or negedge nprst18)
  begin
    if (~nprst18)
        save_edge18 <= 1'b0;
    else
      if (nextState18 == Save_edge18 )
         save_edge18 <= 1'b1;       // Activate18 the isolate18 and retain18 signals18
      else
         save_edge18 <= 1'b0;        
   end    
// stabilising18 count
wire restore_change18;
assign restore_change18 = (nextState18 == Pwr_on218) ? 1'b1: 1'b0;

always @ (posedge pclk18 or negedge nprst18)
  begin
    if (~nprst18)
      trans_cnt18 <= 0;
    else if (trans_cnt18 > 0)
      trans_cnt18  <= trans_cnt18 + 1;
    else if (restore_change18)
      trans_cnt18  <= trans_cnt18 + 1;
  end

// enabling restore18 edge
always @ (posedge pclk18 or negedge nprst18)
  begin
    if (~nprst18)
        restore_edge18 <= 1'b0;
    else
      if (nextState18 == Restore_edge18)
         restore_edge18 <= 1'b1;       // Activate18 the isolate18 and retain18 signals18
      else
         restore_edge18 <= 1'b0;        
   end    


// FSM18 Sequential18 process
always @ (posedge pclk18 or negedge nprst18)
  begin
    if (~nprst18)
      currentState18 <= Init18;
    else
      currentState18 <= nextState18;
  end


// Reset18 for non-SRPG18 FFs18 is a combination18 of the nprst18 and the reset during PSO18
assign  rstn_non_srpg_module18 = rstn_non_srpg18 & nprst18;

assign  set_status_module18 = (nextState18 == Clk_off18);    // Set the L118 status bit  
assign  clr_status_module18 = (currentState18 == Rst_clr18); // Clear the L118 status bit  
  

`ifdef LP_ABV_ON18

// psl18 default clock18 = (posedge pclk18);

// Never18 have the set and clear status signals18 both set
// psl18 output_no_set_and_clear18 : assert never {set_status_module18 & clr_status_module18};



// Isolate18 signal18 should become18 active on the 
// Next18 clock18 after Gate18 signal18 is activated18
// psl18 output_pd_seq18:
//    assert always
//	  {rose18(gate_clk_module18)} |=> {[*1]; {rose18(isolate_module18)} }
//    abort18(~nprst18);
//
//
//
// Reset18 signal18 for Non18-SRPG18 FFs18 and POWER18 signal18 for
// SMC18 should become18 LOW18 on clock18 cycle after Isolate18 
// signal18 is activated18
// psl18 output_pd_seq_stg_218:
//    assert always
//    {rose18(isolate_module18)} |=>
//    {[*2]; {{fell18(rstn_non_srpg_module18)} && {fell18(pwr1_on18)}} }
//    abort18(~nprst18);
//
//
// Whenever18 pwr1_on18 goes18 to LOW18 pwr2_on18 should also go18 to LOW18
// psl18 output_pwr2_low18:
//    assert always
//    { fell18(pwr1_on18) } |->  { fell18(pwr2_on18) }
//    abort18(~nprst18);
//
//
// Whenever18 pwr1_on18 becomes HIGH18 , On18 Next18 clock18 cycle pwr2_on18
// should also become18 HIGH18
// psl18 output_pwr2_high18:
//    assert always
//    { rose18(pwr1_on18) } |=>  { (pwr2_on18) }
//    abort18(~nprst18);
//
`endif


endmodule
