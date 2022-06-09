//File16 name   : power_ctrl_sm16.v
//Title16       : Power16 Controller16 state machine16
//Created16     : 1999
//Description16 : State16 machine16 of power16 controller16
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
module power_ctrl_sm16 (

    // Clocks16 & Reset16
    pclk16,
    nprst16,

    // Register Control16 inputs16
    L1_module_req16,
    set_status_module16,
    clr_status_module16,

    // Module16 control16 outputs16
    rstn_non_srpg_module16,
    gate_clk_module16,
    isolate_module16,
    save_edge16,
    restore_edge16,
    pwr1_on16,
    pwr2_on16

);

input    pclk16;
input    nprst16;

input    L1_module_req16;
output   set_status_module16;
output   clr_status_module16;
    
output   rstn_non_srpg_module16;
output   gate_clk_module16;
output   isolate_module16;
output   pwr1_on16;
output   pwr2_on16;
output save_edge16;
output restore_edge16;

wire    set_status_module16;
wire    clr_status_module16;

wire    rstn_non_srpg_module16;
reg     gate_clk_module16;
reg     isolate_module16;
reg     pwr1_on16;
reg     pwr2_on16;

reg save_edge16;

reg restore_edge16;
   
// FSM16 state
reg  [3:0] currentState16, nextState16;
reg     rstn_non_srpg16;
reg [4:0] trans_cnt16;

parameter Init16 = 0; 
parameter Clk_off16 = 1; 
parameter Wait116 = 2; 
parameter Isolate16 = 3; 
parameter Save_edge16 = 4; 
parameter Pre_pwr_off16 = 5; 
parameter Pwr_off16 = 6; 
parameter Pwr_on116 = 7; 
parameter Pwr_on216 = 8; 
parameter Restore_edge16 = 9; 
parameter Wait216 = 10; 
parameter De_isolate16 = 11; 
parameter Clk_on16 = 12; 
parameter Wait316 = 13; 
parameter Rst_clr16 = 14;


// Power16 Shut16 Off16 State16 Machine16

// FSM16 combinational16 process
always @  (*)
  begin
    case (currentState16)

      // Commence16 PSO16 once16 the L116 req bit is set.
      Init16:
        if (L1_module_req16 == 1'b1)
          nextState16 = Clk_off16;         // Gate16 the module's clocks16 off16
        else
          nextState16 = Init16;            // Keep16 waiting16 in Init16 state
        
      Clk_off16 :
        nextState16 = Wait116;             // Wait16 for one cycle
 
      Wait116  :                         // Wait16 for clk16 gating16 to take16 effect
        nextState16 = Isolate16;           // Start16 the isolation16 process
          
      Isolate16 :
        nextState16 = Save_edge16;
        
      Save_edge16 :
        nextState16 = Pre_pwr_off16;

      Pre_pwr_off16 :
        nextState16 = Pwr_off16;
      // Exit16 PSO16 once16 the L116 req bit is clear.

      Pwr_off16 :
        if (L1_module_req16 == 1'b0)
          nextState16 = Pwr_on116;         // Resume16 power16 if the L1_module_req16 bit is cleared16
        else
          nextState16 = Pwr_off16;         // Wait16 until the L1_module_req16 bit is cleared16
        
      Pwr_on116 :
        nextState16 = Pwr_on216;
          
      Pwr_on216 :
        if(trans_cnt16 == 5'd28)
          nextState16 = Restore_edge16;
        else 
          nextState16 = Pwr_on216;
          
      Restore_edge16 :
        nextState16 = Wait216;

      Wait216 :
        nextState16 = De_isolate16;
          
      De_isolate16 :
        nextState16 = Clk_on16;
          
      Clk_on16 :
        nextState16 = Wait316;
          
      Wait316  :                         // Wait16 for clock16 to resume
        nextState16 = Rst_clr16 ;     
 
      Rst_clr16 :
        nextState16 = Init16;
        
      default  :                       // Catch16 all
        nextState16 = Init16; 
        
    endcase
  end


  // Signals16 Sequential16 process - gate_clk_module16
always @ (posedge pclk16 or negedge nprst16)
  begin
    if (~nprst16)
      gate_clk_module16 <= 1'b0;
    else 
      if (nextState16 == Clk_on16 | nextState16 == Wait316 | nextState16 == Rst_clr16 | 
          nextState16 == Init16)
          gate_clk_module16 <= 1'b0;
      else
          gate_clk_module16 <= 1'b1;
  end

// Signals16 Sequential16 process - rstn_non_srpg16
always @ (posedge pclk16 or negedge nprst16)
  begin
    if (~nprst16)
      rstn_non_srpg16 <= 1'b0;
    else
      if ( nextState16 == Init16 | nextState16 == Clk_off16 | nextState16 == Wait116 | 
           nextState16 == Isolate16 | nextState16 == Save_edge16 | nextState16 == Pre_pwr_off16 | nextState16 == Rst_clr16)
        rstn_non_srpg16 <= 1'b1;
      else
        rstn_non_srpg16 <= 1'b0;
   end


// Signals16 Sequential16 process - pwr1_on16 & pwr2_on16
always @ (posedge pclk16 or negedge nprst16)
  begin
    if (~nprst16)
      pwr1_on16 <=  1'b1;  // power16 gates16 1 & 2 are on
    else
      if (nextState16 == Pwr_off16 )
        pwr1_on16 <= 1'b0;  // shut16 off16 both power16 gates16 1 & 2
      else
        pwr1_on16 <= 1'b1;
  end


// Signals16 Sequential16 process - pwr1_on16 & pwr2_on16
always @ (posedge pclk16 or negedge nprst16)
  begin
    if (~nprst16)
       pwr2_on16 <= 1'b1;      // power16 gates16 1 & 2 are on
    else
      if (nextState16 == Pwr_off16 | nextState16 == Pwr_on116)
        pwr2_on16 <= 1'b0;     // shut16 off16 both power16 gates16 1 & 2
      else
        pwr2_on16 <= 1'b1;
   end


// Signals16 Sequential16 process - isolate_module16 
always @ (posedge pclk16 or negedge nprst16)
  begin
    if (~nprst16)
        isolate_module16 <= 1'b0;
    else
      if (nextState16 == Isolate16 | nextState16 == Save_edge16 | nextState16 == Pre_pwr_off16 |  nextState16 == Pwr_off16 | nextState16 == Pwr_on116 |
          nextState16 == Pwr_on216 | nextState16 == Restore_edge16 | nextState16 == Wait216)
         isolate_module16 <= 1'b1;       // Activate16 the isolate16 and retain16 signals16
      else
         isolate_module16 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk16 or negedge nprst16)
  begin
    if (~nprst16)
        save_edge16 <= 1'b0;
    else
      if (nextState16 == Save_edge16 )
         save_edge16 <= 1'b1;       // Activate16 the isolate16 and retain16 signals16
      else
         save_edge16 <= 1'b0;        
   end    
// stabilising16 count
wire restore_change16;
assign restore_change16 = (nextState16 == Pwr_on216) ? 1'b1: 1'b0;

always @ (posedge pclk16 or negedge nprst16)
  begin
    if (~nprst16)
      trans_cnt16 <= 0;
    else if (trans_cnt16 > 0)
      trans_cnt16  <= trans_cnt16 + 1;
    else if (restore_change16)
      trans_cnt16  <= trans_cnt16 + 1;
  end

// enabling restore16 edge
always @ (posedge pclk16 or negedge nprst16)
  begin
    if (~nprst16)
        restore_edge16 <= 1'b0;
    else
      if (nextState16 == Restore_edge16)
         restore_edge16 <= 1'b1;       // Activate16 the isolate16 and retain16 signals16
      else
         restore_edge16 <= 1'b0;        
   end    


// FSM16 Sequential16 process
always @ (posedge pclk16 or negedge nprst16)
  begin
    if (~nprst16)
      currentState16 <= Init16;
    else
      currentState16 <= nextState16;
  end


// Reset16 for non-SRPG16 FFs16 is a combination16 of the nprst16 and the reset during PSO16
assign  rstn_non_srpg_module16 = rstn_non_srpg16 & nprst16;

assign  set_status_module16 = (nextState16 == Clk_off16);    // Set the L116 status bit  
assign  clr_status_module16 = (currentState16 == Rst_clr16); // Clear the L116 status bit  
  

`ifdef LP_ABV_ON16

// psl16 default clock16 = (posedge pclk16);

// Never16 have the set and clear status signals16 both set
// psl16 output_no_set_and_clear16 : assert never {set_status_module16 & clr_status_module16};



// Isolate16 signal16 should become16 active on the 
// Next16 clock16 after Gate16 signal16 is activated16
// psl16 output_pd_seq16:
//    assert always
//	  {rose16(gate_clk_module16)} |=> {[*1]; {rose16(isolate_module16)} }
//    abort16(~nprst16);
//
//
//
// Reset16 signal16 for Non16-SRPG16 FFs16 and POWER16 signal16 for
// SMC16 should become16 LOW16 on clock16 cycle after Isolate16 
// signal16 is activated16
// psl16 output_pd_seq_stg_216:
//    assert always
//    {rose16(isolate_module16)} |=>
//    {[*2]; {{fell16(rstn_non_srpg_module16)} && {fell16(pwr1_on16)}} }
//    abort16(~nprst16);
//
//
// Whenever16 pwr1_on16 goes16 to LOW16 pwr2_on16 should also go16 to LOW16
// psl16 output_pwr2_low16:
//    assert always
//    { fell16(pwr1_on16) } |->  { fell16(pwr2_on16) }
//    abort16(~nprst16);
//
//
// Whenever16 pwr1_on16 becomes HIGH16 , On16 Next16 clock16 cycle pwr2_on16
// should also become16 HIGH16
// psl16 output_pwr2_high16:
//    assert always
//    { rose16(pwr1_on16) } |=>  { (pwr2_on16) }
//    abort16(~nprst16);
//
`endif


endmodule
