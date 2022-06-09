//File24 name   : power_ctrl_sm24.v
//Title24       : Power24 Controller24 state machine24
//Created24     : 1999
//Description24 : State24 machine24 of power24 controller24
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
module power_ctrl_sm24 (

    // Clocks24 & Reset24
    pclk24,
    nprst24,

    // Register Control24 inputs24
    L1_module_req24,
    set_status_module24,
    clr_status_module24,

    // Module24 control24 outputs24
    rstn_non_srpg_module24,
    gate_clk_module24,
    isolate_module24,
    save_edge24,
    restore_edge24,
    pwr1_on24,
    pwr2_on24

);

input    pclk24;
input    nprst24;

input    L1_module_req24;
output   set_status_module24;
output   clr_status_module24;
    
output   rstn_non_srpg_module24;
output   gate_clk_module24;
output   isolate_module24;
output   pwr1_on24;
output   pwr2_on24;
output save_edge24;
output restore_edge24;

wire    set_status_module24;
wire    clr_status_module24;

wire    rstn_non_srpg_module24;
reg     gate_clk_module24;
reg     isolate_module24;
reg     pwr1_on24;
reg     pwr2_on24;

reg save_edge24;

reg restore_edge24;
   
// FSM24 state
reg  [3:0] currentState24, nextState24;
reg     rstn_non_srpg24;
reg [4:0] trans_cnt24;

parameter Init24 = 0; 
parameter Clk_off24 = 1; 
parameter Wait124 = 2; 
parameter Isolate24 = 3; 
parameter Save_edge24 = 4; 
parameter Pre_pwr_off24 = 5; 
parameter Pwr_off24 = 6; 
parameter Pwr_on124 = 7; 
parameter Pwr_on224 = 8; 
parameter Restore_edge24 = 9; 
parameter Wait224 = 10; 
parameter De_isolate24 = 11; 
parameter Clk_on24 = 12; 
parameter Wait324 = 13; 
parameter Rst_clr24 = 14;


// Power24 Shut24 Off24 State24 Machine24

// FSM24 combinational24 process
always @  (*)
  begin
    case (currentState24)

      // Commence24 PSO24 once24 the L124 req bit is set.
      Init24:
        if (L1_module_req24 == 1'b1)
          nextState24 = Clk_off24;         // Gate24 the module's clocks24 off24
        else
          nextState24 = Init24;            // Keep24 waiting24 in Init24 state
        
      Clk_off24 :
        nextState24 = Wait124;             // Wait24 for one cycle
 
      Wait124  :                         // Wait24 for clk24 gating24 to take24 effect
        nextState24 = Isolate24;           // Start24 the isolation24 process
          
      Isolate24 :
        nextState24 = Save_edge24;
        
      Save_edge24 :
        nextState24 = Pre_pwr_off24;

      Pre_pwr_off24 :
        nextState24 = Pwr_off24;
      // Exit24 PSO24 once24 the L124 req bit is clear.

      Pwr_off24 :
        if (L1_module_req24 == 1'b0)
          nextState24 = Pwr_on124;         // Resume24 power24 if the L1_module_req24 bit is cleared24
        else
          nextState24 = Pwr_off24;         // Wait24 until the L1_module_req24 bit is cleared24
        
      Pwr_on124 :
        nextState24 = Pwr_on224;
          
      Pwr_on224 :
        if(trans_cnt24 == 5'd28)
          nextState24 = Restore_edge24;
        else 
          nextState24 = Pwr_on224;
          
      Restore_edge24 :
        nextState24 = Wait224;

      Wait224 :
        nextState24 = De_isolate24;
          
      De_isolate24 :
        nextState24 = Clk_on24;
          
      Clk_on24 :
        nextState24 = Wait324;
          
      Wait324  :                         // Wait24 for clock24 to resume
        nextState24 = Rst_clr24 ;     
 
      Rst_clr24 :
        nextState24 = Init24;
        
      default  :                       // Catch24 all
        nextState24 = Init24; 
        
    endcase
  end


  // Signals24 Sequential24 process - gate_clk_module24
always @ (posedge pclk24 or negedge nprst24)
  begin
    if (~nprst24)
      gate_clk_module24 <= 1'b0;
    else 
      if (nextState24 == Clk_on24 | nextState24 == Wait324 | nextState24 == Rst_clr24 | 
          nextState24 == Init24)
          gate_clk_module24 <= 1'b0;
      else
          gate_clk_module24 <= 1'b1;
  end

// Signals24 Sequential24 process - rstn_non_srpg24
always @ (posedge pclk24 or negedge nprst24)
  begin
    if (~nprst24)
      rstn_non_srpg24 <= 1'b0;
    else
      if ( nextState24 == Init24 | nextState24 == Clk_off24 | nextState24 == Wait124 | 
           nextState24 == Isolate24 | nextState24 == Save_edge24 | nextState24 == Pre_pwr_off24 | nextState24 == Rst_clr24)
        rstn_non_srpg24 <= 1'b1;
      else
        rstn_non_srpg24 <= 1'b0;
   end


// Signals24 Sequential24 process - pwr1_on24 & pwr2_on24
always @ (posedge pclk24 or negedge nprst24)
  begin
    if (~nprst24)
      pwr1_on24 <=  1'b1;  // power24 gates24 1 & 2 are on
    else
      if (nextState24 == Pwr_off24 )
        pwr1_on24 <= 1'b0;  // shut24 off24 both power24 gates24 1 & 2
      else
        pwr1_on24 <= 1'b1;
  end


// Signals24 Sequential24 process - pwr1_on24 & pwr2_on24
always @ (posedge pclk24 or negedge nprst24)
  begin
    if (~nprst24)
       pwr2_on24 <= 1'b1;      // power24 gates24 1 & 2 are on
    else
      if (nextState24 == Pwr_off24 | nextState24 == Pwr_on124)
        pwr2_on24 <= 1'b0;     // shut24 off24 both power24 gates24 1 & 2
      else
        pwr2_on24 <= 1'b1;
   end


// Signals24 Sequential24 process - isolate_module24 
always @ (posedge pclk24 or negedge nprst24)
  begin
    if (~nprst24)
        isolate_module24 <= 1'b0;
    else
      if (nextState24 == Isolate24 | nextState24 == Save_edge24 | nextState24 == Pre_pwr_off24 |  nextState24 == Pwr_off24 | nextState24 == Pwr_on124 |
          nextState24 == Pwr_on224 | nextState24 == Restore_edge24 | nextState24 == Wait224)
         isolate_module24 <= 1'b1;       // Activate24 the isolate24 and retain24 signals24
      else
         isolate_module24 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk24 or negedge nprst24)
  begin
    if (~nprst24)
        save_edge24 <= 1'b0;
    else
      if (nextState24 == Save_edge24 )
         save_edge24 <= 1'b1;       // Activate24 the isolate24 and retain24 signals24
      else
         save_edge24 <= 1'b0;        
   end    
// stabilising24 count
wire restore_change24;
assign restore_change24 = (nextState24 == Pwr_on224) ? 1'b1: 1'b0;

always @ (posedge pclk24 or negedge nprst24)
  begin
    if (~nprst24)
      trans_cnt24 <= 0;
    else if (trans_cnt24 > 0)
      trans_cnt24  <= trans_cnt24 + 1;
    else if (restore_change24)
      trans_cnt24  <= trans_cnt24 + 1;
  end

// enabling restore24 edge
always @ (posedge pclk24 or negedge nprst24)
  begin
    if (~nprst24)
        restore_edge24 <= 1'b0;
    else
      if (nextState24 == Restore_edge24)
         restore_edge24 <= 1'b1;       // Activate24 the isolate24 and retain24 signals24
      else
         restore_edge24 <= 1'b0;        
   end    


// FSM24 Sequential24 process
always @ (posedge pclk24 or negedge nprst24)
  begin
    if (~nprst24)
      currentState24 <= Init24;
    else
      currentState24 <= nextState24;
  end


// Reset24 for non-SRPG24 FFs24 is a combination24 of the nprst24 and the reset during PSO24
assign  rstn_non_srpg_module24 = rstn_non_srpg24 & nprst24;

assign  set_status_module24 = (nextState24 == Clk_off24);    // Set the L124 status bit  
assign  clr_status_module24 = (currentState24 == Rst_clr24); // Clear the L124 status bit  
  

`ifdef LP_ABV_ON24

// psl24 default clock24 = (posedge pclk24);

// Never24 have the set and clear status signals24 both set
// psl24 output_no_set_and_clear24 : assert never {set_status_module24 & clr_status_module24};



// Isolate24 signal24 should become24 active on the 
// Next24 clock24 after Gate24 signal24 is activated24
// psl24 output_pd_seq24:
//    assert always
//	  {rose24(gate_clk_module24)} |=> {[*1]; {rose24(isolate_module24)} }
//    abort24(~nprst24);
//
//
//
// Reset24 signal24 for Non24-SRPG24 FFs24 and POWER24 signal24 for
// SMC24 should become24 LOW24 on clock24 cycle after Isolate24 
// signal24 is activated24
// psl24 output_pd_seq_stg_224:
//    assert always
//    {rose24(isolate_module24)} |=>
//    {[*2]; {{fell24(rstn_non_srpg_module24)} && {fell24(pwr1_on24)}} }
//    abort24(~nprst24);
//
//
// Whenever24 pwr1_on24 goes24 to LOW24 pwr2_on24 should also go24 to LOW24
// psl24 output_pwr2_low24:
//    assert always
//    { fell24(pwr1_on24) } |->  { fell24(pwr2_on24) }
//    abort24(~nprst24);
//
//
// Whenever24 pwr1_on24 becomes HIGH24 , On24 Next24 clock24 cycle pwr2_on24
// should also become24 HIGH24
// psl24 output_pwr2_high24:
//    assert always
//    { rose24(pwr1_on24) } |=>  { (pwr2_on24) }
//    abort24(~nprst24);
//
`endif


endmodule
