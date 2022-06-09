//File29 name   : power_ctrl_sm29.v
//Title29       : Power29 Controller29 state machine29
//Created29     : 1999
//Description29 : State29 machine29 of power29 controller29
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
module power_ctrl_sm29 (

    // Clocks29 & Reset29
    pclk29,
    nprst29,

    // Register Control29 inputs29
    L1_module_req29,
    set_status_module29,
    clr_status_module29,

    // Module29 control29 outputs29
    rstn_non_srpg_module29,
    gate_clk_module29,
    isolate_module29,
    save_edge29,
    restore_edge29,
    pwr1_on29,
    pwr2_on29

);

input    pclk29;
input    nprst29;

input    L1_module_req29;
output   set_status_module29;
output   clr_status_module29;
    
output   rstn_non_srpg_module29;
output   gate_clk_module29;
output   isolate_module29;
output   pwr1_on29;
output   pwr2_on29;
output save_edge29;
output restore_edge29;

wire    set_status_module29;
wire    clr_status_module29;

wire    rstn_non_srpg_module29;
reg     gate_clk_module29;
reg     isolate_module29;
reg     pwr1_on29;
reg     pwr2_on29;

reg save_edge29;

reg restore_edge29;
   
// FSM29 state
reg  [3:0] currentState29, nextState29;
reg     rstn_non_srpg29;
reg [4:0] trans_cnt29;

parameter Init29 = 0; 
parameter Clk_off29 = 1; 
parameter Wait129 = 2; 
parameter Isolate29 = 3; 
parameter Save_edge29 = 4; 
parameter Pre_pwr_off29 = 5; 
parameter Pwr_off29 = 6; 
parameter Pwr_on129 = 7; 
parameter Pwr_on229 = 8; 
parameter Restore_edge29 = 9; 
parameter Wait229 = 10; 
parameter De_isolate29 = 11; 
parameter Clk_on29 = 12; 
parameter Wait329 = 13; 
parameter Rst_clr29 = 14;


// Power29 Shut29 Off29 State29 Machine29

// FSM29 combinational29 process
always @  (*)
  begin
    case (currentState29)

      // Commence29 PSO29 once29 the L129 req bit is set.
      Init29:
        if (L1_module_req29 == 1'b1)
          nextState29 = Clk_off29;         // Gate29 the module's clocks29 off29
        else
          nextState29 = Init29;            // Keep29 waiting29 in Init29 state
        
      Clk_off29 :
        nextState29 = Wait129;             // Wait29 for one cycle
 
      Wait129  :                         // Wait29 for clk29 gating29 to take29 effect
        nextState29 = Isolate29;           // Start29 the isolation29 process
          
      Isolate29 :
        nextState29 = Save_edge29;
        
      Save_edge29 :
        nextState29 = Pre_pwr_off29;

      Pre_pwr_off29 :
        nextState29 = Pwr_off29;
      // Exit29 PSO29 once29 the L129 req bit is clear.

      Pwr_off29 :
        if (L1_module_req29 == 1'b0)
          nextState29 = Pwr_on129;         // Resume29 power29 if the L1_module_req29 bit is cleared29
        else
          nextState29 = Pwr_off29;         // Wait29 until the L1_module_req29 bit is cleared29
        
      Pwr_on129 :
        nextState29 = Pwr_on229;
          
      Pwr_on229 :
        if(trans_cnt29 == 5'd28)
          nextState29 = Restore_edge29;
        else 
          nextState29 = Pwr_on229;
          
      Restore_edge29 :
        nextState29 = Wait229;

      Wait229 :
        nextState29 = De_isolate29;
          
      De_isolate29 :
        nextState29 = Clk_on29;
          
      Clk_on29 :
        nextState29 = Wait329;
          
      Wait329  :                         // Wait29 for clock29 to resume
        nextState29 = Rst_clr29 ;     
 
      Rst_clr29 :
        nextState29 = Init29;
        
      default  :                       // Catch29 all
        nextState29 = Init29; 
        
    endcase
  end


  // Signals29 Sequential29 process - gate_clk_module29
always @ (posedge pclk29 or negedge nprst29)
  begin
    if (~nprst29)
      gate_clk_module29 <= 1'b0;
    else 
      if (nextState29 == Clk_on29 | nextState29 == Wait329 | nextState29 == Rst_clr29 | 
          nextState29 == Init29)
          gate_clk_module29 <= 1'b0;
      else
          gate_clk_module29 <= 1'b1;
  end

// Signals29 Sequential29 process - rstn_non_srpg29
always @ (posedge pclk29 or negedge nprst29)
  begin
    if (~nprst29)
      rstn_non_srpg29 <= 1'b0;
    else
      if ( nextState29 == Init29 | nextState29 == Clk_off29 | nextState29 == Wait129 | 
           nextState29 == Isolate29 | nextState29 == Save_edge29 | nextState29 == Pre_pwr_off29 | nextState29 == Rst_clr29)
        rstn_non_srpg29 <= 1'b1;
      else
        rstn_non_srpg29 <= 1'b0;
   end


// Signals29 Sequential29 process - pwr1_on29 & pwr2_on29
always @ (posedge pclk29 or negedge nprst29)
  begin
    if (~nprst29)
      pwr1_on29 <=  1'b1;  // power29 gates29 1 & 2 are on
    else
      if (nextState29 == Pwr_off29 )
        pwr1_on29 <= 1'b0;  // shut29 off29 both power29 gates29 1 & 2
      else
        pwr1_on29 <= 1'b1;
  end


// Signals29 Sequential29 process - pwr1_on29 & pwr2_on29
always @ (posedge pclk29 or negedge nprst29)
  begin
    if (~nprst29)
       pwr2_on29 <= 1'b1;      // power29 gates29 1 & 2 are on
    else
      if (nextState29 == Pwr_off29 | nextState29 == Pwr_on129)
        pwr2_on29 <= 1'b0;     // shut29 off29 both power29 gates29 1 & 2
      else
        pwr2_on29 <= 1'b1;
   end


// Signals29 Sequential29 process - isolate_module29 
always @ (posedge pclk29 or negedge nprst29)
  begin
    if (~nprst29)
        isolate_module29 <= 1'b0;
    else
      if (nextState29 == Isolate29 | nextState29 == Save_edge29 | nextState29 == Pre_pwr_off29 |  nextState29 == Pwr_off29 | nextState29 == Pwr_on129 |
          nextState29 == Pwr_on229 | nextState29 == Restore_edge29 | nextState29 == Wait229)
         isolate_module29 <= 1'b1;       // Activate29 the isolate29 and retain29 signals29
      else
         isolate_module29 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk29 or negedge nprst29)
  begin
    if (~nprst29)
        save_edge29 <= 1'b0;
    else
      if (nextState29 == Save_edge29 )
         save_edge29 <= 1'b1;       // Activate29 the isolate29 and retain29 signals29
      else
         save_edge29 <= 1'b0;        
   end    
// stabilising29 count
wire restore_change29;
assign restore_change29 = (nextState29 == Pwr_on229) ? 1'b1: 1'b0;

always @ (posedge pclk29 or negedge nprst29)
  begin
    if (~nprst29)
      trans_cnt29 <= 0;
    else if (trans_cnt29 > 0)
      trans_cnt29  <= trans_cnt29 + 1;
    else if (restore_change29)
      trans_cnt29  <= trans_cnt29 + 1;
  end

// enabling restore29 edge
always @ (posedge pclk29 or negedge nprst29)
  begin
    if (~nprst29)
        restore_edge29 <= 1'b0;
    else
      if (nextState29 == Restore_edge29)
         restore_edge29 <= 1'b1;       // Activate29 the isolate29 and retain29 signals29
      else
         restore_edge29 <= 1'b0;        
   end    


// FSM29 Sequential29 process
always @ (posedge pclk29 or negedge nprst29)
  begin
    if (~nprst29)
      currentState29 <= Init29;
    else
      currentState29 <= nextState29;
  end


// Reset29 for non-SRPG29 FFs29 is a combination29 of the nprst29 and the reset during PSO29
assign  rstn_non_srpg_module29 = rstn_non_srpg29 & nprst29;

assign  set_status_module29 = (nextState29 == Clk_off29);    // Set the L129 status bit  
assign  clr_status_module29 = (currentState29 == Rst_clr29); // Clear the L129 status bit  
  

`ifdef LP_ABV_ON29

// psl29 default clock29 = (posedge pclk29);

// Never29 have the set and clear status signals29 both set
// psl29 output_no_set_and_clear29 : assert never {set_status_module29 & clr_status_module29};



// Isolate29 signal29 should become29 active on the 
// Next29 clock29 after Gate29 signal29 is activated29
// psl29 output_pd_seq29:
//    assert always
//	  {rose29(gate_clk_module29)} |=> {[*1]; {rose29(isolate_module29)} }
//    abort29(~nprst29);
//
//
//
// Reset29 signal29 for Non29-SRPG29 FFs29 and POWER29 signal29 for
// SMC29 should become29 LOW29 on clock29 cycle after Isolate29 
// signal29 is activated29
// psl29 output_pd_seq_stg_229:
//    assert always
//    {rose29(isolate_module29)} |=>
//    {[*2]; {{fell29(rstn_non_srpg_module29)} && {fell29(pwr1_on29)}} }
//    abort29(~nprst29);
//
//
// Whenever29 pwr1_on29 goes29 to LOW29 pwr2_on29 should also go29 to LOW29
// psl29 output_pwr2_low29:
//    assert always
//    { fell29(pwr1_on29) } |->  { fell29(pwr2_on29) }
//    abort29(~nprst29);
//
//
// Whenever29 pwr1_on29 becomes HIGH29 , On29 Next29 clock29 cycle pwr2_on29
// should also become29 HIGH29
// psl29 output_pwr2_high29:
//    assert always
//    { rose29(pwr1_on29) } |=>  { (pwr2_on29) }
//    abort29(~nprst29);
//
`endif


endmodule
