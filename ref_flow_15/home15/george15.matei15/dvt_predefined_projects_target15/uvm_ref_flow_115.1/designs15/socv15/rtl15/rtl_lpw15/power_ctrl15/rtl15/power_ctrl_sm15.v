//File15 name   : power_ctrl_sm15.v
//Title15       : Power15 Controller15 state machine15
//Created15     : 1999
//Description15 : State15 machine15 of power15 controller15
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
module power_ctrl_sm15 (

    // Clocks15 & Reset15
    pclk15,
    nprst15,

    // Register Control15 inputs15
    L1_module_req15,
    set_status_module15,
    clr_status_module15,

    // Module15 control15 outputs15
    rstn_non_srpg_module15,
    gate_clk_module15,
    isolate_module15,
    save_edge15,
    restore_edge15,
    pwr1_on15,
    pwr2_on15

);

input    pclk15;
input    nprst15;

input    L1_module_req15;
output   set_status_module15;
output   clr_status_module15;
    
output   rstn_non_srpg_module15;
output   gate_clk_module15;
output   isolate_module15;
output   pwr1_on15;
output   pwr2_on15;
output save_edge15;
output restore_edge15;

wire    set_status_module15;
wire    clr_status_module15;

wire    rstn_non_srpg_module15;
reg     gate_clk_module15;
reg     isolate_module15;
reg     pwr1_on15;
reg     pwr2_on15;

reg save_edge15;

reg restore_edge15;
   
// FSM15 state
reg  [3:0] currentState15, nextState15;
reg     rstn_non_srpg15;
reg [4:0] trans_cnt15;

parameter Init15 = 0; 
parameter Clk_off15 = 1; 
parameter Wait115 = 2; 
parameter Isolate15 = 3; 
parameter Save_edge15 = 4; 
parameter Pre_pwr_off15 = 5; 
parameter Pwr_off15 = 6; 
parameter Pwr_on115 = 7; 
parameter Pwr_on215 = 8; 
parameter Restore_edge15 = 9; 
parameter Wait215 = 10; 
parameter De_isolate15 = 11; 
parameter Clk_on15 = 12; 
parameter Wait315 = 13; 
parameter Rst_clr15 = 14;


// Power15 Shut15 Off15 State15 Machine15

// FSM15 combinational15 process
always @  (*)
  begin
    case (currentState15)

      // Commence15 PSO15 once15 the L115 req bit is set.
      Init15:
        if (L1_module_req15 == 1'b1)
          nextState15 = Clk_off15;         // Gate15 the module's clocks15 off15
        else
          nextState15 = Init15;            // Keep15 waiting15 in Init15 state
        
      Clk_off15 :
        nextState15 = Wait115;             // Wait15 for one cycle
 
      Wait115  :                         // Wait15 for clk15 gating15 to take15 effect
        nextState15 = Isolate15;           // Start15 the isolation15 process
          
      Isolate15 :
        nextState15 = Save_edge15;
        
      Save_edge15 :
        nextState15 = Pre_pwr_off15;

      Pre_pwr_off15 :
        nextState15 = Pwr_off15;
      // Exit15 PSO15 once15 the L115 req bit is clear.

      Pwr_off15 :
        if (L1_module_req15 == 1'b0)
          nextState15 = Pwr_on115;         // Resume15 power15 if the L1_module_req15 bit is cleared15
        else
          nextState15 = Pwr_off15;         // Wait15 until the L1_module_req15 bit is cleared15
        
      Pwr_on115 :
        nextState15 = Pwr_on215;
          
      Pwr_on215 :
        if(trans_cnt15 == 5'd28)
          nextState15 = Restore_edge15;
        else 
          nextState15 = Pwr_on215;
          
      Restore_edge15 :
        nextState15 = Wait215;

      Wait215 :
        nextState15 = De_isolate15;
          
      De_isolate15 :
        nextState15 = Clk_on15;
          
      Clk_on15 :
        nextState15 = Wait315;
          
      Wait315  :                         // Wait15 for clock15 to resume
        nextState15 = Rst_clr15 ;     
 
      Rst_clr15 :
        nextState15 = Init15;
        
      default  :                       // Catch15 all
        nextState15 = Init15; 
        
    endcase
  end


  // Signals15 Sequential15 process - gate_clk_module15
always @ (posedge pclk15 or negedge nprst15)
  begin
    if (~nprst15)
      gate_clk_module15 <= 1'b0;
    else 
      if (nextState15 == Clk_on15 | nextState15 == Wait315 | nextState15 == Rst_clr15 | 
          nextState15 == Init15)
          gate_clk_module15 <= 1'b0;
      else
          gate_clk_module15 <= 1'b1;
  end

// Signals15 Sequential15 process - rstn_non_srpg15
always @ (posedge pclk15 or negedge nprst15)
  begin
    if (~nprst15)
      rstn_non_srpg15 <= 1'b0;
    else
      if ( nextState15 == Init15 | nextState15 == Clk_off15 | nextState15 == Wait115 | 
           nextState15 == Isolate15 | nextState15 == Save_edge15 | nextState15 == Pre_pwr_off15 | nextState15 == Rst_clr15)
        rstn_non_srpg15 <= 1'b1;
      else
        rstn_non_srpg15 <= 1'b0;
   end


// Signals15 Sequential15 process - pwr1_on15 & pwr2_on15
always @ (posedge pclk15 or negedge nprst15)
  begin
    if (~nprst15)
      pwr1_on15 <=  1'b1;  // power15 gates15 1 & 2 are on
    else
      if (nextState15 == Pwr_off15 )
        pwr1_on15 <= 1'b0;  // shut15 off15 both power15 gates15 1 & 2
      else
        pwr1_on15 <= 1'b1;
  end


// Signals15 Sequential15 process - pwr1_on15 & pwr2_on15
always @ (posedge pclk15 or negedge nprst15)
  begin
    if (~nprst15)
       pwr2_on15 <= 1'b1;      // power15 gates15 1 & 2 are on
    else
      if (nextState15 == Pwr_off15 | nextState15 == Pwr_on115)
        pwr2_on15 <= 1'b0;     // shut15 off15 both power15 gates15 1 & 2
      else
        pwr2_on15 <= 1'b1;
   end


// Signals15 Sequential15 process - isolate_module15 
always @ (posedge pclk15 or negedge nprst15)
  begin
    if (~nprst15)
        isolate_module15 <= 1'b0;
    else
      if (nextState15 == Isolate15 | nextState15 == Save_edge15 | nextState15 == Pre_pwr_off15 |  nextState15 == Pwr_off15 | nextState15 == Pwr_on115 |
          nextState15 == Pwr_on215 | nextState15 == Restore_edge15 | nextState15 == Wait215)
         isolate_module15 <= 1'b1;       // Activate15 the isolate15 and retain15 signals15
      else
         isolate_module15 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk15 or negedge nprst15)
  begin
    if (~nprst15)
        save_edge15 <= 1'b0;
    else
      if (nextState15 == Save_edge15 )
         save_edge15 <= 1'b1;       // Activate15 the isolate15 and retain15 signals15
      else
         save_edge15 <= 1'b0;        
   end    
// stabilising15 count
wire restore_change15;
assign restore_change15 = (nextState15 == Pwr_on215) ? 1'b1: 1'b0;

always @ (posedge pclk15 or negedge nprst15)
  begin
    if (~nprst15)
      trans_cnt15 <= 0;
    else if (trans_cnt15 > 0)
      trans_cnt15  <= trans_cnt15 + 1;
    else if (restore_change15)
      trans_cnt15  <= trans_cnt15 + 1;
  end

// enabling restore15 edge
always @ (posedge pclk15 or negedge nprst15)
  begin
    if (~nprst15)
        restore_edge15 <= 1'b0;
    else
      if (nextState15 == Restore_edge15)
         restore_edge15 <= 1'b1;       // Activate15 the isolate15 and retain15 signals15
      else
         restore_edge15 <= 1'b0;        
   end    


// FSM15 Sequential15 process
always @ (posedge pclk15 or negedge nprst15)
  begin
    if (~nprst15)
      currentState15 <= Init15;
    else
      currentState15 <= nextState15;
  end


// Reset15 for non-SRPG15 FFs15 is a combination15 of the nprst15 and the reset during PSO15
assign  rstn_non_srpg_module15 = rstn_non_srpg15 & nprst15;

assign  set_status_module15 = (nextState15 == Clk_off15);    // Set the L115 status bit  
assign  clr_status_module15 = (currentState15 == Rst_clr15); // Clear the L115 status bit  
  

`ifdef LP_ABV_ON15

// psl15 default clock15 = (posedge pclk15);

// Never15 have the set and clear status signals15 both set
// psl15 output_no_set_and_clear15 : assert never {set_status_module15 & clr_status_module15};



// Isolate15 signal15 should become15 active on the 
// Next15 clock15 after Gate15 signal15 is activated15
// psl15 output_pd_seq15:
//    assert always
//	  {rose15(gate_clk_module15)} |=> {[*1]; {rose15(isolate_module15)} }
//    abort15(~nprst15);
//
//
//
// Reset15 signal15 for Non15-SRPG15 FFs15 and POWER15 signal15 for
// SMC15 should become15 LOW15 on clock15 cycle after Isolate15 
// signal15 is activated15
// psl15 output_pd_seq_stg_215:
//    assert always
//    {rose15(isolate_module15)} |=>
//    {[*2]; {{fell15(rstn_non_srpg_module15)} && {fell15(pwr1_on15)}} }
//    abort15(~nprst15);
//
//
// Whenever15 pwr1_on15 goes15 to LOW15 pwr2_on15 should also go15 to LOW15
// psl15 output_pwr2_low15:
//    assert always
//    { fell15(pwr1_on15) } |->  { fell15(pwr2_on15) }
//    abort15(~nprst15);
//
//
// Whenever15 pwr1_on15 becomes HIGH15 , On15 Next15 clock15 cycle pwr2_on15
// should also become15 HIGH15
// psl15 output_pwr2_high15:
//    assert always
//    { rose15(pwr1_on15) } |=>  { (pwr2_on15) }
//    abort15(~nprst15);
//
`endif


endmodule
