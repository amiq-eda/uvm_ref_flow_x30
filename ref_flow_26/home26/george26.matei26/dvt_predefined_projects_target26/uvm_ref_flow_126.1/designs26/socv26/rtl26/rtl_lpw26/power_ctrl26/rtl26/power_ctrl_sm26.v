//File26 name   : power_ctrl_sm26.v
//Title26       : Power26 Controller26 state machine26
//Created26     : 1999
//Description26 : State26 machine26 of power26 controller26
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
module power_ctrl_sm26 (

    // Clocks26 & Reset26
    pclk26,
    nprst26,

    // Register Control26 inputs26
    L1_module_req26,
    set_status_module26,
    clr_status_module26,

    // Module26 control26 outputs26
    rstn_non_srpg_module26,
    gate_clk_module26,
    isolate_module26,
    save_edge26,
    restore_edge26,
    pwr1_on26,
    pwr2_on26

);

input    pclk26;
input    nprst26;

input    L1_module_req26;
output   set_status_module26;
output   clr_status_module26;
    
output   rstn_non_srpg_module26;
output   gate_clk_module26;
output   isolate_module26;
output   pwr1_on26;
output   pwr2_on26;
output save_edge26;
output restore_edge26;

wire    set_status_module26;
wire    clr_status_module26;

wire    rstn_non_srpg_module26;
reg     gate_clk_module26;
reg     isolate_module26;
reg     pwr1_on26;
reg     pwr2_on26;

reg save_edge26;

reg restore_edge26;
   
// FSM26 state
reg  [3:0] currentState26, nextState26;
reg     rstn_non_srpg26;
reg [4:0] trans_cnt26;

parameter Init26 = 0; 
parameter Clk_off26 = 1; 
parameter Wait126 = 2; 
parameter Isolate26 = 3; 
parameter Save_edge26 = 4; 
parameter Pre_pwr_off26 = 5; 
parameter Pwr_off26 = 6; 
parameter Pwr_on126 = 7; 
parameter Pwr_on226 = 8; 
parameter Restore_edge26 = 9; 
parameter Wait226 = 10; 
parameter De_isolate26 = 11; 
parameter Clk_on26 = 12; 
parameter Wait326 = 13; 
parameter Rst_clr26 = 14;


// Power26 Shut26 Off26 State26 Machine26

// FSM26 combinational26 process
always @  (*)
  begin
    case (currentState26)

      // Commence26 PSO26 once26 the L126 req bit is set.
      Init26:
        if (L1_module_req26 == 1'b1)
          nextState26 = Clk_off26;         // Gate26 the module's clocks26 off26
        else
          nextState26 = Init26;            // Keep26 waiting26 in Init26 state
        
      Clk_off26 :
        nextState26 = Wait126;             // Wait26 for one cycle
 
      Wait126  :                         // Wait26 for clk26 gating26 to take26 effect
        nextState26 = Isolate26;           // Start26 the isolation26 process
          
      Isolate26 :
        nextState26 = Save_edge26;
        
      Save_edge26 :
        nextState26 = Pre_pwr_off26;

      Pre_pwr_off26 :
        nextState26 = Pwr_off26;
      // Exit26 PSO26 once26 the L126 req bit is clear.

      Pwr_off26 :
        if (L1_module_req26 == 1'b0)
          nextState26 = Pwr_on126;         // Resume26 power26 if the L1_module_req26 bit is cleared26
        else
          nextState26 = Pwr_off26;         // Wait26 until the L1_module_req26 bit is cleared26
        
      Pwr_on126 :
        nextState26 = Pwr_on226;
          
      Pwr_on226 :
        if(trans_cnt26 == 5'd28)
          nextState26 = Restore_edge26;
        else 
          nextState26 = Pwr_on226;
          
      Restore_edge26 :
        nextState26 = Wait226;

      Wait226 :
        nextState26 = De_isolate26;
          
      De_isolate26 :
        nextState26 = Clk_on26;
          
      Clk_on26 :
        nextState26 = Wait326;
          
      Wait326  :                         // Wait26 for clock26 to resume
        nextState26 = Rst_clr26 ;     
 
      Rst_clr26 :
        nextState26 = Init26;
        
      default  :                       // Catch26 all
        nextState26 = Init26; 
        
    endcase
  end


  // Signals26 Sequential26 process - gate_clk_module26
always @ (posedge pclk26 or negedge nprst26)
  begin
    if (~nprst26)
      gate_clk_module26 <= 1'b0;
    else 
      if (nextState26 == Clk_on26 | nextState26 == Wait326 | nextState26 == Rst_clr26 | 
          nextState26 == Init26)
          gate_clk_module26 <= 1'b0;
      else
          gate_clk_module26 <= 1'b1;
  end

// Signals26 Sequential26 process - rstn_non_srpg26
always @ (posedge pclk26 or negedge nprst26)
  begin
    if (~nprst26)
      rstn_non_srpg26 <= 1'b0;
    else
      if ( nextState26 == Init26 | nextState26 == Clk_off26 | nextState26 == Wait126 | 
           nextState26 == Isolate26 | nextState26 == Save_edge26 | nextState26 == Pre_pwr_off26 | nextState26 == Rst_clr26)
        rstn_non_srpg26 <= 1'b1;
      else
        rstn_non_srpg26 <= 1'b0;
   end


// Signals26 Sequential26 process - pwr1_on26 & pwr2_on26
always @ (posedge pclk26 or negedge nprst26)
  begin
    if (~nprst26)
      pwr1_on26 <=  1'b1;  // power26 gates26 1 & 2 are on
    else
      if (nextState26 == Pwr_off26 )
        pwr1_on26 <= 1'b0;  // shut26 off26 both power26 gates26 1 & 2
      else
        pwr1_on26 <= 1'b1;
  end


// Signals26 Sequential26 process - pwr1_on26 & pwr2_on26
always @ (posedge pclk26 or negedge nprst26)
  begin
    if (~nprst26)
       pwr2_on26 <= 1'b1;      // power26 gates26 1 & 2 are on
    else
      if (nextState26 == Pwr_off26 | nextState26 == Pwr_on126)
        pwr2_on26 <= 1'b0;     // shut26 off26 both power26 gates26 1 & 2
      else
        pwr2_on26 <= 1'b1;
   end


// Signals26 Sequential26 process - isolate_module26 
always @ (posedge pclk26 or negedge nprst26)
  begin
    if (~nprst26)
        isolate_module26 <= 1'b0;
    else
      if (nextState26 == Isolate26 | nextState26 == Save_edge26 | nextState26 == Pre_pwr_off26 |  nextState26 == Pwr_off26 | nextState26 == Pwr_on126 |
          nextState26 == Pwr_on226 | nextState26 == Restore_edge26 | nextState26 == Wait226)
         isolate_module26 <= 1'b1;       // Activate26 the isolate26 and retain26 signals26
      else
         isolate_module26 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk26 or negedge nprst26)
  begin
    if (~nprst26)
        save_edge26 <= 1'b0;
    else
      if (nextState26 == Save_edge26 )
         save_edge26 <= 1'b1;       // Activate26 the isolate26 and retain26 signals26
      else
         save_edge26 <= 1'b0;        
   end    
// stabilising26 count
wire restore_change26;
assign restore_change26 = (nextState26 == Pwr_on226) ? 1'b1: 1'b0;

always @ (posedge pclk26 or negedge nprst26)
  begin
    if (~nprst26)
      trans_cnt26 <= 0;
    else if (trans_cnt26 > 0)
      trans_cnt26  <= trans_cnt26 + 1;
    else if (restore_change26)
      trans_cnt26  <= trans_cnt26 + 1;
  end

// enabling restore26 edge
always @ (posedge pclk26 or negedge nprst26)
  begin
    if (~nprst26)
        restore_edge26 <= 1'b0;
    else
      if (nextState26 == Restore_edge26)
         restore_edge26 <= 1'b1;       // Activate26 the isolate26 and retain26 signals26
      else
         restore_edge26 <= 1'b0;        
   end    


// FSM26 Sequential26 process
always @ (posedge pclk26 or negedge nprst26)
  begin
    if (~nprst26)
      currentState26 <= Init26;
    else
      currentState26 <= nextState26;
  end


// Reset26 for non-SRPG26 FFs26 is a combination26 of the nprst26 and the reset during PSO26
assign  rstn_non_srpg_module26 = rstn_non_srpg26 & nprst26;

assign  set_status_module26 = (nextState26 == Clk_off26);    // Set the L126 status bit  
assign  clr_status_module26 = (currentState26 == Rst_clr26); // Clear the L126 status bit  
  

`ifdef LP_ABV_ON26

// psl26 default clock26 = (posedge pclk26);

// Never26 have the set and clear status signals26 both set
// psl26 output_no_set_and_clear26 : assert never {set_status_module26 & clr_status_module26};



// Isolate26 signal26 should become26 active on the 
// Next26 clock26 after Gate26 signal26 is activated26
// psl26 output_pd_seq26:
//    assert always
//	  {rose26(gate_clk_module26)} |=> {[*1]; {rose26(isolate_module26)} }
//    abort26(~nprst26);
//
//
//
// Reset26 signal26 for Non26-SRPG26 FFs26 and POWER26 signal26 for
// SMC26 should become26 LOW26 on clock26 cycle after Isolate26 
// signal26 is activated26
// psl26 output_pd_seq_stg_226:
//    assert always
//    {rose26(isolate_module26)} |=>
//    {[*2]; {{fell26(rstn_non_srpg_module26)} && {fell26(pwr1_on26)}} }
//    abort26(~nprst26);
//
//
// Whenever26 pwr1_on26 goes26 to LOW26 pwr2_on26 should also go26 to LOW26
// psl26 output_pwr2_low26:
//    assert always
//    { fell26(pwr1_on26) } |->  { fell26(pwr2_on26) }
//    abort26(~nprst26);
//
//
// Whenever26 pwr1_on26 becomes HIGH26 , On26 Next26 clock26 cycle pwr2_on26
// should also become26 HIGH26
// psl26 output_pwr2_high26:
//    assert always
//    { rose26(pwr1_on26) } |=>  { (pwr2_on26) }
//    abort26(~nprst26);
//
`endif


endmodule
