//File4 name   : power_ctrl_sm4.v
//Title4       : Power4 Controller4 state machine4
//Created4     : 1999
//Description4 : State4 machine4 of power4 controller4
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
module power_ctrl_sm4 (

    // Clocks4 & Reset4
    pclk4,
    nprst4,

    // Register Control4 inputs4
    L1_module_req4,
    set_status_module4,
    clr_status_module4,

    // Module4 control4 outputs4
    rstn_non_srpg_module4,
    gate_clk_module4,
    isolate_module4,
    save_edge4,
    restore_edge4,
    pwr1_on4,
    pwr2_on4

);

input    pclk4;
input    nprst4;

input    L1_module_req4;
output   set_status_module4;
output   clr_status_module4;
    
output   rstn_non_srpg_module4;
output   gate_clk_module4;
output   isolate_module4;
output   pwr1_on4;
output   pwr2_on4;
output save_edge4;
output restore_edge4;

wire    set_status_module4;
wire    clr_status_module4;

wire    rstn_non_srpg_module4;
reg     gate_clk_module4;
reg     isolate_module4;
reg     pwr1_on4;
reg     pwr2_on4;

reg save_edge4;

reg restore_edge4;
   
// FSM4 state
reg  [3:0] currentState4, nextState4;
reg     rstn_non_srpg4;
reg [4:0] trans_cnt4;

parameter Init4 = 0; 
parameter Clk_off4 = 1; 
parameter Wait14 = 2; 
parameter Isolate4 = 3; 
parameter Save_edge4 = 4; 
parameter Pre_pwr_off4 = 5; 
parameter Pwr_off4 = 6; 
parameter Pwr_on14 = 7; 
parameter Pwr_on24 = 8; 
parameter Restore_edge4 = 9; 
parameter Wait24 = 10; 
parameter De_isolate4 = 11; 
parameter Clk_on4 = 12; 
parameter Wait34 = 13; 
parameter Rst_clr4 = 14;


// Power4 Shut4 Off4 State4 Machine4

// FSM4 combinational4 process
always @  (*)
  begin
    case (currentState4)

      // Commence4 PSO4 once4 the L14 req bit is set.
      Init4:
        if (L1_module_req4 == 1'b1)
          nextState4 = Clk_off4;         // Gate4 the module's clocks4 off4
        else
          nextState4 = Init4;            // Keep4 waiting4 in Init4 state
        
      Clk_off4 :
        nextState4 = Wait14;             // Wait4 for one cycle
 
      Wait14  :                         // Wait4 for clk4 gating4 to take4 effect
        nextState4 = Isolate4;           // Start4 the isolation4 process
          
      Isolate4 :
        nextState4 = Save_edge4;
        
      Save_edge4 :
        nextState4 = Pre_pwr_off4;

      Pre_pwr_off4 :
        nextState4 = Pwr_off4;
      // Exit4 PSO4 once4 the L14 req bit is clear.

      Pwr_off4 :
        if (L1_module_req4 == 1'b0)
          nextState4 = Pwr_on14;         // Resume4 power4 if the L1_module_req4 bit is cleared4
        else
          nextState4 = Pwr_off4;         // Wait4 until the L1_module_req4 bit is cleared4
        
      Pwr_on14 :
        nextState4 = Pwr_on24;
          
      Pwr_on24 :
        if(trans_cnt4 == 5'd28)
          nextState4 = Restore_edge4;
        else 
          nextState4 = Pwr_on24;
          
      Restore_edge4 :
        nextState4 = Wait24;

      Wait24 :
        nextState4 = De_isolate4;
          
      De_isolate4 :
        nextState4 = Clk_on4;
          
      Clk_on4 :
        nextState4 = Wait34;
          
      Wait34  :                         // Wait4 for clock4 to resume
        nextState4 = Rst_clr4 ;     
 
      Rst_clr4 :
        nextState4 = Init4;
        
      default  :                       // Catch4 all
        nextState4 = Init4; 
        
    endcase
  end


  // Signals4 Sequential4 process - gate_clk_module4
always @ (posedge pclk4 or negedge nprst4)
  begin
    if (~nprst4)
      gate_clk_module4 <= 1'b0;
    else 
      if (nextState4 == Clk_on4 | nextState4 == Wait34 | nextState4 == Rst_clr4 | 
          nextState4 == Init4)
          gate_clk_module4 <= 1'b0;
      else
          gate_clk_module4 <= 1'b1;
  end

// Signals4 Sequential4 process - rstn_non_srpg4
always @ (posedge pclk4 or negedge nprst4)
  begin
    if (~nprst4)
      rstn_non_srpg4 <= 1'b0;
    else
      if ( nextState4 == Init4 | nextState4 == Clk_off4 | nextState4 == Wait14 | 
           nextState4 == Isolate4 | nextState4 == Save_edge4 | nextState4 == Pre_pwr_off4 | nextState4 == Rst_clr4)
        rstn_non_srpg4 <= 1'b1;
      else
        rstn_non_srpg4 <= 1'b0;
   end


// Signals4 Sequential4 process - pwr1_on4 & pwr2_on4
always @ (posedge pclk4 or negedge nprst4)
  begin
    if (~nprst4)
      pwr1_on4 <=  1'b1;  // power4 gates4 1 & 2 are on
    else
      if (nextState4 == Pwr_off4 )
        pwr1_on4 <= 1'b0;  // shut4 off4 both power4 gates4 1 & 2
      else
        pwr1_on4 <= 1'b1;
  end


// Signals4 Sequential4 process - pwr1_on4 & pwr2_on4
always @ (posedge pclk4 or negedge nprst4)
  begin
    if (~nprst4)
       pwr2_on4 <= 1'b1;      // power4 gates4 1 & 2 are on
    else
      if (nextState4 == Pwr_off4 | nextState4 == Pwr_on14)
        pwr2_on4 <= 1'b0;     // shut4 off4 both power4 gates4 1 & 2
      else
        pwr2_on4 <= 1'b1;
   end


// Signals4 Sequential4 process - isolate_module4 
always @ (posedge pclk4 or negedge nprst4)
  begin
    if (~nprst4)
        isolate_module4 <= 1'b0;
    else
      if (nextState4 == Isolate4 | nextState4 == Save_edge4 | nextState4 == Pre_pwr_off4 |  nextState4 == Pwr_off4 | nextState4 == Pwr_on14 |
          nextState4 == Pwr_on24 | nextState4 == Restore_edge4 | nextState4 == Wait24)
         isolate_module4 <= 1'b1;       // Activate4 the isolate4 and retain4 signals4
      else
         isolate_module4 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk4 or negedge nprst4)
  begin
    if (~nprst4)
        save_edge4 <= 1'b0;
    else
      if (nextState4 == Save_edge4 )
         save_edge4 <= 1'b1;       // Activate4 the isolate4 and retain4 signals4
      else
         save_edge4 <= 1'b0;        
   end    
// stabilising4 count
wire restore_change4;
assign restore_change4 = (nextState4 == Pwr_on24) ? 1'b1: 1'b0;

always @ (posedge pclk4 or negedge nprst4)
  begin
    if (~nprst4)
      trans_cnt4 <= 0;
    else if (trans_cnt4 > 0)
      trans_cnt4  <= trans_cnt4 + 1;
    else if (restore_change4)
      trans_cnt4  <= trans_cnt4 + 1;
  end

// enabling restore4 edge
always @ (posedge pclk4 or negedge nprst4)
  begin
    if (~nprst4)
        restore_edge4 <= 1'b0;
    else
      if (nextState4 == Restore_edge4)
         restore_edge4 <= 1'b1;       // Activate4 the isolate4 and retain4 signals4
      else
         restore_edge4 <= 1'b0;        
   end    


// FSM4 Sequential4 process
always @ (posedge pclk4 or negedge nprst4)
  begin
    if (~nprst4)
      currentState4 <= Init4;
    else
      currentState4 <= nextState4;
  end


// Reset4 for non-SRPG4 FFs4 is a combination4 of the nprst4 and the reset during PSO4
assign  rstn_non_srpg_module4 = rstn_non_srpg4 & nprst4;

assign  set_status_module4 = (nextState4 == Clk_off4);    // Set the L14 status bit  
assign  clr_status_module4 = (currentState4 == Rst_clr4); // Clear the L14 status bit  
  

`ifdef LP_ABV_ON4

// psl4 default clock4 = (posedge pclk4);

// Never4 have the set and clear status signals4 both set
// psl4 output_no_set_and_clear4 : assert never {set_status_module4 & clr_status_module4};



// Isolate4 signal4 should become4 active on the 
// Next4 clock4 after Gate4 signal4 is activated4
// psl4 output_pd_seq4:
//    assert always
//	  {rose4(gate_clk_module4)} |=> {[*1]; {rose4(isolate_module4)} }
//    abort4(~nprst4);
//
//
//
// Reset4 signal4 for Non4-SRPG4 FFs4 and POWER4 signal4 for
// SMC4 should become4 LOW4 on clock4 cycle after Isolate4 
// signal4 is activated4
// psl4 output_pd_seq_stg_24:
//    assert always
//    {rose4(isolate_module4)} |=>
//    {[*2]; {{fell4(rstn_non_srpg_module4)} && {fell4(pwr1_on4)}} }
//    abort4(~nprst4);
//
//
// Whenever4 pwr1_on4 goes4 to LOW4 pwr2_on4 should also go4 to LOW4
// psl4 output_pwr2_low4:
//    assert always
//    { fell4(pwr1_on4) } |->  { fell4(pwr2_on4) }
//    abort4(~nprst4);
//
//
// Whenever4 pwr1_on4 becomes HIGH4 , On4 Next4 clock4 cycle pwr2_on4
// should also become4 HIGH4
// psl4 output_pwr2_high4:
//    assert always
//    { rose4(pwr1_on4) } |=>  { (pwr2_on4) }
//    abort4(~nprst4);
//
`endif


endmodule
