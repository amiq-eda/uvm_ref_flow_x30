//File7 name   : power_ctrl_sm7.v
//Title7       : Power7 Controller7 state machine7
//Created7     : 1999
//Description7 : State7 machine7 of power7 controller7
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
module power_ctrl_sm7 (

    // Clocks7 & Reset7
    pclk7,
    nprst7,

    // Register Control7 inputs7
    L1_module_req7,
    set_status_module7,
    clr_status_module7,

    // Module7 control7 outputs7
    rstn_non_srpg_module7,
    gate_clk_module7,
    isolate_module7,
    save_edge7,
    restore_edge7,
    pwr1_on7,
    pwr2_on7

);

input    pclk7;
input    nprst7;

input    L1_module_req7;
output   set_status_module7;
output   clr_status_module7;
    
output   rstn_non_srpg_module7;
output   gate_clk_module7;
output   isolate_module7;
output   pwr1_on7;
output   pwr2_on7;
output save_edge7;
output restore_edge7;

wire    set_status_module7;
wire    clr_status_module7;

wire    rstn_non_srpg_module7;
reg     gate_clk_module7;
reg     isolate_module7;
reg     pwr1_on7;
reg     pwr2_on7;

reg save_edge7;

reg restore_edge7;
   
// FSM7 state
reg  [3:0] currentState7, nextState7;
reg     rstn_non_srpg7;
reg [4:0] trans_cnt7;

parameter Init7 = 0; 
parameter Clk_off7 = 1; 
parameter Wait17 = 2; 
parameter Isolate7 = 3; 
parameter Save_edge7 = 4; 
parameter Pre_pwr_off7 = 5; 
parameter Pwr_off7 = 6; 
parameter Pwr_on17 = 7; 
parameter Pwr_on27 = 8; 
parameter Restore_edge7 = 9; 
parameter Wait27 = 10; 
parameter De_isolate7 = 11; 
parameter Clk_on7 = 12; 
parameter Wait37 = 13; 
parameter Rst_clr7 = 14;


// Power7 Shut7 Off7 State7 Machine7

// FSM7 combinational7 process
always @  (*)
  begin
    case (currentState7)

      // Commence7 PSO7 once7 the L17 req bit is set.
      Init7:
        if (L1_module_req7 == 1'b1)
          nextState7 = Clk_off7;         // Gate7 the module's clocks7 off7
        else
          nextState7 = Init7;            // Keep7 waiting7 in Init7 state
        
      Clk_off7 :
        nextState7 = Wait17;             // Wait7 for one cycle
 
      Wait17  :                         // Wait7 for clk7 gating7 to take7 effect
        nextState7 = Isolate7;           // Start7 the isolation7 process
          
      Isolate7 :
        nextState7 = Save_edge7;
        
      Save_edge7 :
        nextState7 = Pre_pwr_off7;

      Pre_pwr_off7 :
        nextState7 = Pwr_off7;
      // Exit7 PSO7 once7 the L17 req bit is clear.

      Pwr_off7 :
        if (L1_module_req7 == 1'b0)
          nextState7 = Pwr_on17;         // Resume7 power7 if the L1_module_req7 bit is cleared7
        else
          nextState7 = Pwr_off7;         // Wait7 until the L1_module_req7 bit is cleared7
        
      Pwr_on17 :
        nextState7 = Pwr_on27;
          
      Pwr_on27 :
        if(trans_cnt7 == 5'd28)
          nextState7 = Restore_edge7;
        else 
          nextState7 = Pwr_on27;
          
      Restore_edge7 :
        nextState7 = Wait27;

      Wait27 :
        nextState7 = De_isolate7;
          
      De_isolate7 :
        nextState7 = Clk_on7;
          
      Clk_on7 :
        nextState7 = Wait37;
          
      Wait37  :                         // Wait7 for clock7 to resume
        nextState7 = Rst_clr7 ;     
 
      Rst_clr7 :
        nextState7 = Init7;
        
      default  :                       // Catch7 all
        nextState7 = Init7; 
        
    endcase
  end


  // Signals7 Sequential7 process - gate_clk_module7
always @ (posedge pclk7 or negedge nprst7)
  begin
    if (~nprst7)
      gate_clk_module7 <= 1'b0;
    else 
      if (nextState7 == Clk_on7 | nextState7 == Wait37 | nextState7 == Rst_clr7 | 
          nextState7 == Init7)
          gate_clk_module7 <= 1'b0;
      else
          gate_clk_module7 <= 1'b1;
  end

// Signals7 Sequential7 process - rstn_non_srpg7
always @ (posedge pclk7 or negedge nprst7)
  begin
    if (~nprst7)
      rstn_non_srpg7 <= 1'b0;
    else
      if ( nextState7 == Init7 | nextState7 == Clk_off7 | nextState7 == Wait17 | 
           nextState7 == Isolate7 | nextState7 == Save_edge7 | nextState7 == Pre_pwr_off7 | nextState7 == Rst_clr7)
        rstn_non_srpg7 <= 1'b1;
      else
        rstn_non_srpg7 <= 1'b0;
   end


// Signals7 Sequential7 process - pwr1_on7 & pwr2_on7
always @ (posedge pclk7 or negedge nprst7)
  begin
    if (~nprst7)
      pwr1_on7 <=  1'b1;  // power7 gates7 1 & 2 are on
    else
      if (nextState7 == Pwr_off7 )
        pwr1_on7 <= 1'b0;  // shut7 off7 both power7 gates7 1 & 2
      else
        pwr1_on7 <= 1'b1;
  end


// Signals7 Sequential7 process - pwr1_on7 & pwr2_on7
always @ (posedge pclk7 or negedge nprst7)
  begin
    if (~nprst7)
       pwr2_on7 <= 1'b1;      // power7 gates7 1 & 2 are on
    else
      if (nextState7 == Pwr_off7 | nextState7 == Pwr_on17)
        pwr2_on7 <= 1'b0;     // shut7 off7 both power7 gates7 1 & 2
      else
        pwr2_on7 <= 1'b1;
   end


// Signals7 Sequential7 process - isolate_module7 
always @ (posedge pclk7 or negedge nprst7)
  begin
    if (~nprst7)
        isolate_module7 <= 1'b0;
    else
      if (nextState7 == Isolate7 | nextState7 == Save_edge7 | nextState7 == Pre_pwr_off7 |  nextState7 == Pwr_off7 | nextState7 == Pwr_on17 |
          nextState7 == Pwr_on27 | nextState7 == Restore_edge7 | nextState7 == Wait27)
         isolate_module7 <= 1'b1;       // Activate7 the isolate7 and retain7 signals7
      else
         isolate_module7 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk7 or negedge nprst7)
  begin
    if (~nprst7)
        save_edge7 <= 1'b0;
    else
      if (nextState7 == Save_edge7 )
         save_edge7 <= 1'b1;       // Activate7 the isolate7 and retain7 signals7
      else
         save_edge7 <= 1'b0;        
   end    
// stabilising7 count
wire restore_change7;
assign restore_change7 = (nextState7 == Pwr_on27) ? 1'b1: 1'b0;

always @ (posedge pclk7 or negedge nprst7)
  begin
    if (~nprst7)
      trans_cnt7 <= 0;
    else if (trans_cnt7 > 0)
      trans_cnt7  <= trans_cnt7 + 1;
    else if (restore_change7)
      trans_cnt7  <= trans_cnt7 + 1;
  end

// enabling restore7 edge
always @ (posedge pclk7 or negedge nprst7)
  begin
    if (~nprst7)
        restore_edge7 <= 1'b0;
    else
      if (nextState7 == Restore_edge7)
         restore_edge7 <= 1'b1;       // Activate7 the isolate7 and retain7 signals7
      else
         restore_edge7 <= 1'b0;        
   end    


// FSM7 Sequential7 process
always @ (posedge pclk7 or negedge nprst7)
  begin
    if (~nprst7)
      currentState7 <= Init7;
    else
      currentState7 <= nextState7;
  end


// Reset7 for non-SRPG7 FFs7 is a combination7 of the nprst7 and the reset during PSO7
assign  rstn_non_srpg_module7 = rstn_non_srpg7 & nprst7;

assign  set_status_module7 = (nextState7 == Clk_off7);    // Set the L17 status bit  
assign  clr_status_module7 = (currentState7 == Rst_clr7); // Clear the L17 status bit  
  

`ifdef LP_ABV_ON7

// psl7 default clock7 = (posedge pclk7);

// Never7 have the set and clear status signals7 both set
// psl7 output_no_set_and_clear7 : assert never {set_status_module7 & clr_status_module7};



// Isolate7 signal7 should become7 active on the 
// Next7 clock7 after Gate7 signal7 is activated7
// psl7 output_pd_seq7:
//    assert always
//	  {rose7(gate_clk_module7)} |=> {[*1]; {rose7(isolate_module7)} }
//    abort7(~nprst7);
//
//
//
// Reset7 signal7 for Non7-SRPG7 FFs7 and POWER7 signal7 for
// SMC7 should become7 LOW7 on clock7 cycle after Isolate7 
// signal7 is activated7
// psl7 output_pd_seq_stg_27:
//    assert always
//    {rose7(isolate_module7)} |=>
//    {[*2]; {{fell7(rstn_non_srpg_module7)} && {fell7(pwr1_on7)}} }
//    abort7(~nprst7);
//
//
// Whenever7 pwr1_on7 goes7 to LOW7 pwr2_on7 should also go7 to LOW7
// psl7 output_pwr2_low7:
//    assert always
//    { fell7(pwr1_on7) } |->  { fell7(pwr2_on7) }
//    abort7(~nprst7);
//
//
// Whenever7 pwr1_on7 becomes HIGH7 , On7 Next7 clock7 cycle pwr2_on7
// should also become7 HIGH7
// psl7 output_pwr2_high7:
//    assert always
//    { rose7(pwr1_on7) } |=>  { (pwr2_on7) }
//    abort7(~nprst7);
//
`endif


endmodule
