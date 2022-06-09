//File13 name   : power_ctrl_sm13.v
//Title13       : Power13 Controller13 state machine13
//Created13     : 1999
//Description13 : State13 machine13 of power13 controller13
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
module power_ctrl_sm13 (

    // Clocks13 & Reset13
    pclk13,
    nprst13,

    // Register Control13 inputs13
    L1_module_req13,
    set_status_module13,
    clr_status_module13,

    // Module13 control13 outputs13
    rstn_non_srpg_module13,
    gate_clk_module13,
    isolate_module13,
    save_edge13,
    restore_edge13,
    pwr1_on13,
    pwr2_on13

);

input    pclk13;
input    nprst13;

input    L1_module_req13;
output   set_status_module13;
output   clr_status_module13;
    
output   rstn_non_srpg_module13;
output   gate_clk_module13;
output   isolate_module13;
output   pwr1_on13;
output   pwr2_on13;
output save_edge13;
output restore_edge13;

wire    set_status_module13;
wire    clr_status_module13;

wire    rstn_non_srpg_module13;
reg     gate_clk_module13;
reg     isolate_module13;
reg     pwr1_on13;
reg     pwr2_on13;

reg save_edge13;

reg restore_edge13;
   
// FSM13 state
reg  [3:0] currentState13, nextState13;
reg     rstn_non_srpg13;
reg [4:0] trans_cnt13;

parameter Init13 = 0; 
parameter Clk_off13 = 1; 
parameter Wait113 = 2; 
parameter Isolate13 = 3; 
parameter Save_edge13 = 4; 
parameter Pre_pwr_off13 = 5; 
parameter Pwr_off13 = 6; 
parameter Pwr_on113 = 7; 
parameter Pwr_on213 = 8; 
parameter Restore_edge13 = 9; 
parameter Wait213 = 10; 
parameter De_isolate13 = 11; 
parameter Clk_on13 = 12; 
parameter Wait313 = 13; 
parameter Rst_clr13 = 14;


// Power13 Shut13 Off13 State13 Machine13

// FSM13 combinational13 process
always @  (*)
  begin
    case (currentState13)

      // Commence13 PSO13 once13 the L113 req bit is set.
      Init13:
        if (L1_module_req13 == 1'b1)
          nextState13 = Clk_off13;         // Gate13 the module's clocks13 off13
        else
          nextState13 = Init13;            // Keep13 waiting13 in Init13 state
        
      Clk_off13 :
        nextState13 = Wait113;             // Wait13 for one cycle
 
      Wait113  :                         // Wait13 for clk13 gating13 to take13 effect
        nextState13 = Isolate13;           // Start13 the isolation13 process
          
      Isolate13 :
        nextState13 = Save_edge13;
        
      Save_edge13 :
        nextState13 = Pre_pwr_off13;

      Pre_pwr_off13 :
        nextState13 = Pwr_off13;
      // Exit13 PSO13 once13 the L113 req bit is clear.

      Pwr_off13 :
        if (L1_module_req13 == 1'b0)
          nextState13 = Pwr_on113;         // Resume13 power13 if the L1_module_req13 bit is cleared13
        else
          nextState13 = Pwr_off13;         // Wait13 until the L1_module_req13 bit is cleared13
        
      Pwr_on113 :
        nextState13 = Pwr_on213;
          
      Pwr_on213 :
        if(trans_cnt13 == 5'd28)
          nextState13 = Restore_edge13;
        else 
          nextState13 = Pwr_on213;
          
      Restore_edge13 :
        nextState13 = Wait213;

      Wait213 :
        nextState13 = De_isolate13;
          
      De_isolate13 :
        nextState13 = Clk_on13;
          
      Clk_on13 :
        nextState13 = Wait313;
          
      Wait313  :                         // Wait13 for clock13 to resume
        nextState13 = Rst_clr13 ;     
 
      Rst_clr13 :
        nextState13 = Init13;
        
      default  :                       // Catch13 all
        nextState13 = Init13; 
        
    endcase
  end


  // Signals13 Sequential13 process - gate_clk_module13
always @ (posedge pclk13 or negedge nprst13)
  begin
    if (~nprst13)
      gate_clk_module13 <= 1'b0;
    else 
      if (nextState13 == Clk_on13 | nextState13 == Wait313 | nextState13 == Rst_clr13 | 
          nextState13 == Init13)
          gate_clk_module13 <= 1'b0;
      else
          gate_clk_module13 <= 1'b1;
  end

// Signals13 Sequential13 process - rstn_non_srpg13
always @ (posedge pclk13 or negedge nprst13)
  begin
    if (~nprst13)
      rstn_non_srpg13 <= 1'b0;
    else
      if ( nextState13 == Init13 | nextState13 == Clk_off13 | nextState13 == Wait113 | 
           nextState13 == Isolate13 | nextState13 == Save_edge13 | nextState13 == Pre_pwr_off13 | nextState13 == Rst_clr13)
        rstn_non_srpg13 <= 1'b1;
      else
        rstn_non_srpg13 <= 1'b0;
   end


// Signals13 Sequential13 process - pwr1_on13 & pwr2_on13
always @ (posedge pclk13 or negedge nprst13)
  begin
    if (~nprst13)
      pwr1_on13 <=  1'b1;  // power13 gates13 1 & 2 are on
    else
      if (nextState13 == Pwr_off13 )
        pwr1_on13 <= 1'b0;  // shut13 off13 both power13 gates13 1 & 2
      else
        pwr1_on13 <= 1'b1;
  end


// Signals13 Sequential13 process - pwr1_on13 & pwr2_on13
always @ (posedge pclk13 or negedge nprst13)
  begin
    if (~nprst13)
       pwr2_on13 <= 1'b1;      // power13 gates13 1 & 2 are on
    else
      if (nextState13 == Pwr_off13 | nextState13 == Pwr_on113)
        pwr2_on13 <= 1'b0;     // shut13 off13 both power13 gates13 1 & 2
      else
        pwr2_on13 <= 1'b1;
   end


// Signals13 Sequential13 process - isolate_module13 
always @ (posedge pclk13 or negedge nprst13)
  begin
    if (~nprst13)
        isolate_module13 <= 1'b0;
    else
      if (nextState13 == Isolate13 | nextState13 == Save_edge13 | nextState13 == Pre_pwr_off13 |  nextState13 == Pwr_off13 | nextState13 == Pwr_on113 |
          nextState13 == Pwr_on213 | nextState13 == Restore_edge13 | nextState13 == Wait213)
         isolate_module13 <= 1'b1;       // Activate13 the isolate13 and retain13 signals13
      else
         isolate_module13 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk13 or negedge nprst13)
  begin
    if (~nprst13)
        save_edge13 <= 1'b0;
    else
      if (nextState13 == Save_edge13 )
         save_edge13 <= 1'b1;       // Activate13 the isolate13 and retain13 signals13
      else
         save_edge13 <= 1'b0;        
   end    
// stabilising13 count
wire restore_change13;
assign restore_change13 = (nextState13 == Pwr_on213) ? 1'b1: 1'b0;

always @ (posedge pclk13 or negedge nprst13)
  begin
    if (~nprst13)
      trans_cnt13 <= 0;
    else if (trans_cnt13 > 0)
      trans_cnt13  <= trans_cnt13 + 1;
    else if (restore_change13)
      trans_cnt13  <= trans_cnt13 + 1;
  end

// enabling restore13 edge
always @ (posedge pclk13 or negedge nprst13)
  begin
    if (~nprst13)
        restore_edge13 <= 1'b0;
    else
      if (nextState13 == Restore_edge13)
         restore_edge13 <= 1'b1;       // Activate13 the isolate13 and retain13 signals13
      else
         restore_edge13 <= 1'b0;        
   end    


// FSM13 Sequential13 process
always @ (posedge pclk13 or negedge nprst13)
  begin
    if (~nprst13)
      currentState13 <= Init13;
    else
      currentState13 <= nextState13;
  end


// Reset13 for non-SRPG13 FFs13 is a combination13 of the nprst13 and the reset during PSO13
assign  rstn_non_srpg_module13 = rstn_non_srpg13 & nprst13;

assign  set_status_module13 = (nextState13 == Clk_off13);    // Set the L113 status bit  
assign  clr_status_module13 = (currentState13 == Rst_clr13); // Clear the L113 status bit  
  

`ifdef LP_ABV_ON13

// psl13 default clock13 = (posedge pclk13);

// Never13 have the set and clear status signals13 both set
// psl13 output_no_set_and_clear13 : assert never {set_status_module13 & clr_status_module13};



// Isolate13 signal13 should become13 active on the 
// Next13 clock13 after Gate13 signal13 is activated13
// psl13 output_pd_seq13:
//    assert always
//	  {rose13(gate_clk_module13)} |=> {[*1]; {rose13(isolate_module13)} }
//    abort13(~nprst13);
//
//
//
// Reset13 signal13 for Non13-SRPG13 FFs13 and POWER13 signal13 for
// SMC13 should become13 LOW13 on clock13 cycle after Isolate13 
// signal13 is activated13
// psl13 output_pd_seq_stg_213:
//    assert always
//    {rose13(isolate_module13)} |=>
//    {[*2]; {{fell13(rstn_non_srpg_module13)} && {fell13(pwr1_on13)}} }
//    abort13(~nprst13);
//
//
// Whenever13 pwr1_on13 goes13 to LOW13 pwr2_on13 should also go13 to LOW13
// psl13 output_pwr2_low13:
//    assert always
//    { fell13(pwr1_on13) } |->  { fell13(pwr2_on13) }
//    abort13(~nprst13);
//
//
// Whenever13 pwr1_on13 becomes HIGH13 , On13 Next13 clock13 cycle pwr2_on13
// should also become13 HIGH13
// psl13 output_pwr2_high13:
//    assert always
//    { rose13(pwr1_on13) } |=>  { (pwr2_on13) }
//    abort13(~nprst13);
//
`endif


endmodule
