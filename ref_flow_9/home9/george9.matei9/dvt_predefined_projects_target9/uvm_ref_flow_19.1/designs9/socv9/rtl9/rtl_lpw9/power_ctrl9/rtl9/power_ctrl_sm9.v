//File9 name   : power_ctrl_sm9.v
//Title9       : Power9 Controller9 state machine9
//Created9     : 1999
//Description9 : State9 machine9 of power9 controller9
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
module power_ctrl_sm9 (

    // Clocks9 & Reset9
    pclk9,
    nprst9,

    // Register Control9 inputs9
    L1_module_req9,
    set_status_module9,
    clr_status_module9,

    // Module9 control9 outputs9
    rstn_non_srpg_module9,
    gate_clk_module9,
    isolate_module9,
    save_edge9,
    restore_edge9,
    pwr1_on9,
    pwr2_on9

);

input    pclk9;
input    nprst9;

input    L1_module_req9;
output   set_status_module9;
output   clr_status_module9;
    
output   rstn_non_srpg_module9;
output   gate_clk_module9;
output   isolate_module9;
output   pwr1_on9;
output   pwr2_on9;
output save_edge9;
output restore_edge9;

wire    set_status_module9;
wire    clr_status_module9;

wire    rstn_non_srpg_module9;
reg     gate_clk_module9;
reg     isolate_module9;
reg     pwr1_on9;
reg     pwr2_on9;

reg save_edge9;

reg restore_edge9;
   
// FSM9 state
reg  [3:0] currentState9, nextState9;
reg     rstn_non_srpg9;
reg [4:0] trans_cnt9;

parameter Init9 = 0; 
parameter Clk_off9 = 1; 
parameter Wait19 = 2; 
parameter Isolate9 = 3; 
parameter Save_edge9 = 4; 
parameter Pre_pwr_off9 = 5; 
parameter Pwr_off9 = 6; 
parameter Pwr_on19 = 7; 
parameter Pwr_on29 = 8; 
parameter Restore_edge9 = 9; 
parameter Wait29 = 10; 
parameter De_isolate9 = 11; 
parameter Clk_on9 = 12; 
parameter Wait39 = 13; 
parameter Rst_clr9 = 14;


// Power9 Shut9 Off9 State9 Machine9

// FSM9 combinational9 process
always @  (*)
  begin
    case (currentState9)

      // Commence9 PSO9 once9 the L19 req bit is set.
      Init9:
        if (L1_module_req9 == 1'b1)
          nextState9 = Clk_off9;         // Gate9 the module's clocks9 off9
        else
          nextState9 = Init9;            // Keep9 waiting9 in Init9 state
        
      Clk_off9 :
        nextState9 = Wait19;             // Wait9 for one cycle
 
      Wait19  :                         // Wait9 for clk9 gating9 to take9 effect
        nextState9 = Isolate9;           // Start9 the isolation9 process
          
      Isolate9 :
        nextState9 = Save_edge9;
        
      Save_edge9 :
        nextState9 = Pre_pwr_off9;

      Pre_pwr_off9 :
        nextState9 = Pwr_off9;
      // Exit9 PSO9 once9 the L19 req bit is clear.

      Pwr_off9 :
        if (L1_module_req9 == 1'b0)
          nextState9 = Pwr_on19;         // Resume9 power9 if the L1_module_req9 bit is cleared9
        else
          nextState9 = Pwr_off9;         // Wait9 until the L1_module_req9 bit is cleared9
        
      Pwr_on19 :
        nextState9 = Pwr_on29;
          
      Pwr_on29 :
        if(trans_cnt9 == 5'd28)
          nextState9 = Restore_edge9;
        else 
          nextState9 = Pwr_on29;
          
      Restore_edge9 :
        nextState9 = Wait29;

      Wait29 :
        nextState9 = De_isolate9;
          
      De_isolate9 :
        nextState9 = Clk_on9;
          
      Clk_on9 :
        nextState9 = Wait39;
          
      Wait39  :                         // Wait9 for clock9 to resume
        nextState9 = Rst_clr9 ;     
 
      Rst_clr9 :
        nextState9 = Init9;
        
      default  :                       // Catch9 all
        nextState9 = Init9; 
        
    endcase
  end


  // Signals9 Sequential9 process - gate_clk_module9
always @ (posedge pclk9 or negedge nprst9)
  begin
    if (~nprst9)
      gate_clk_module9 <= 1'b0;
    else 
      if (nextState9 == Clk_on9 | nextState9 == Wait39 | nextState9 == Rst_clr9 | 
          nextState9 == Init9)
          gate_clk_module9 <= 1'b0;
      else
          gate_clk_module9 <= 1'b1;
  end

// Signals9 Sequential9 process - rstn_non_srpg9
always @ (posedge pclk9 or negedge nprst9)
  begin
    if (~nprst9)
      rstn_non_srpg9 <= 1'b0;
    else
      if ( nextState9 == Init9 | nextState9 == Clk_off9 | nextState9 == Wait19 | 
           nextState9 == Isolate9 | nextState9 == Save_edge9 | nextState9 == Pre_pwr_off9 | nextState9 == Rst_clr9)
        rstn_non_srpg9 <= 1'b1;
      else
        rstn_non_srpg9 <= 1'b0;
   end


// Signals9 Sequential9 process - pwr1_on9 & pwr2_on9
always @ (posedge pclk9 or negedge nprst9)
  begin
    if (~nprst9)
      pwr1_on9 <=  1'b1;  // power9 gates9 1 & 2 are on
    else
      if (nextState9 == Pwr_off9 )
        pwr1_on9 <= 1'b0;  // shut9 off9 both power9 gates9 1 & 2
      else
        pwr1_on9 <= 1'b1;
  end


// Signals9 Sequential9 process - pwr1_on9 & pwr2_on9
always @ (posedge pclk9 or negedge nprst9)
  begin
    if (~nprst9)
       pwr2_on9 <= 1'b1;      // power9 gates9 1 & 2 are on
    else
      if (nextState9 == Pwr_off9 | nextState9 == Pwr_on19)
        pwr2_on9 <= 1'b0;     // shut9 off9 both power9 gates9 1 & 2
      else
        pwr2_on9 <= 1'b1;
   end


// Signals9 Sequential9 process - isolate_module9 
always @ (posedge pclk9 or negedge nprst9)
  begin
    if (~nprst9)
        isolate_module9 <= 1'b0;
    else
      if (nextState9 == Isolate9 | nextState9 == Save_edge9 | nextState9 == Pre_pwr_off9 |  nextState9 == Pwr_off9 | nextState9 == Pwr_on19 |
          nextState9 == Pwr_on29 | nextState9 == Restore_edge9 | nextState9 == Wait29)
         isolate_module9 <= 1'b1;       // Activate9 the isolate9 and retain9 signals9
      else
         isolate_module9 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk9 or negedge nprst9)
  begin
    if (~nprst9)
        save_edge9 <= 1'b0;
    else
      if (nextState9 == Save_edge9 )
         save_edge9 <= 1'b1;       // Activate9 the isolate9 and retain9 signals9
      else
         save_edge9 <= 1'b0;        
   end    
// stabilising9 count
wire restore_change9;
assign restore_change9 = (nextState9 == Pwr_on29) ? 1'b1: 1'b0;

always @ (posedge pclk9 or negedge nprst9)
  begin
    if (~nprst9)
      trans_cnt9 <= 0;
    else if (trans_cnt9 > 0)
      trans_cnt9  <= trans_cnt9 + 1;
    else if (restore_change9)
      trans_cnt9  <= trans_cnt9 + 1;
  end

// enabling restore9 edge
always @ (posedge pclk9 or negedge nprst9)
  begin
    if (~nprst9)
        restore_edge9 <= 1'b0;
    else
      if (nextState9 == Restore_edge9)
         restore_edge9 <= 1'b1;       // Activate9 the isolate9 and retain9 signals9
      else
         restore_edge9 <= 1'b0;        
   end    


// FSM9 Sequential9 process
always @ (posedge pclk9 or negedge nprst9)
  begin
    if (~nprst9)
      currentState9 <= Init9;
    else
      currentState9 <= nextState9;
  end


// Reset9 for non-SRPG9 FFs9 is a combination9 of the nprst9 and the reset during PSO9
assign  rstn_non_srpg_module9 = rstn_non_srpg9 & nprst9;

assign  set_status_module9 = (nextState9 == Clk_off9);    // Set the L19 status bit  
assign  clr_status_module9 = (currentState9 == Rst_clr9); // Clear the L19 status bit  
  

`ifdef LP_ABV_ON9

// psl9 default clock9 = (posedge pclk9);

// Never9 have the set and clear status signals9 both set
// psl9 output_no_set_and_clear9 : assert never {set_status_module9 & clr_status_module9};



// Isolate9 signal9 should become9 active on the 
// Next9 clock9 after Gate9 signal9 is activated9
// psl9 output_pd_seq9:
//    assert always
//	  {rose9(gate_clk_module9)} |=> {[*1]; {rose9(isolate_module9)} }
//    abort9(~nprst9);
//
//
//
// Reset9 signal9 for Non9-SRPG9 FFs9 and POWER9 signal9 for
// SMC9 should become9 LOW9 on clock9 cycle after Isolate9 
// signal9 is activated9
// psl9 output_pd_seq_stg_29:
//    assert always
//    {rose9(isolate_module9)} |=>
//    {[*2]; {{fell9(rstn_non_srpg_module9)} && {fell9(pwr1_on9)}} }
//    abort9(~nprst9);
//
//
// Whenever9 pwr1_on9 goes9 to LOW9 pwr2_on9 should also go9 to LOW9
// psl9 output_pwr2_low9:
//    assert always
//    { fell9(pwr1_on9) } |->  { fell9(pwr2_on9) }
//    abort9(~nprst9);
//
//
// Whenever9 pwr1_on9 becomes HIGH9 , On9 Next9 clock9 cycle pwr2_on9
// should also become9 HIGH9
// psl9 output_pwr2_high9:
//    assert always
//    { rose9(pwr1_on9) } |=>  { (pwr2_on9) }
//    abort9(~nprst9);
//
`endif


endmodule
