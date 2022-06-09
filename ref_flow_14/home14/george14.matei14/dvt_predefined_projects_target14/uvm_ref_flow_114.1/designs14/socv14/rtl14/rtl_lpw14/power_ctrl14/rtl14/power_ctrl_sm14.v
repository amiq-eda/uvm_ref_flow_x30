//File14 name   : power_ctrl_sm14.v
//Title14       : Power14 Controller14 state machine14
//Created14     : 1999
//Description14 : State14 machine14 of power14 controller14
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
module power_ctrl_sm14 (

    // Clocks14 & Reset14
    pclk14,
    nprst14,

    // Register Control14 inputs14
    L1_module_req14,
    set_status_module14,
    clr_status_module14,

    // Module14 control14 outputs14
    rstn_non_srpg_module14,
    gate_clk_module14,
    isolate_module14,
    save_edge14,
    restore_edge14,
    pwr1_on14,
    pwr2_on14

);

input    pclk14;
input    nprst14;

input    L1_module_req14;
output   set_status_module14;
output   clr_status_module14;
    
output   rstn_non_srpg_module14;
output   gate_clk_module14;
output   isolate_module14;
output   pwr1_on14;
output   pwr2_on14;
output save_edge14;
output restore_edge14;

wire    set_status_module14;
wire    clr_status_module14;

wire    rstn_non_srpg_module14;
reg     gate_clk_module14;
reg     isolate_module14;
reg     pwr1_on14;
reg     pwr2_on14;

reg save_edge14;

reg restore_edge14;
   
// FSM14 state
reg  [3:0] currentState14, nextState14;
reg     rstn_non_srpg14;
reg [4:0] trans_cnt14;

parameter Init14 = 0; 
parameter Clk_off14 = 1; 
parameter Wait114 = 2; 
parameter Isolate14 = 3; 
parameter Save_edge14 = 4; 
parameter Pre_pwr_off14 = 5; 
parameter Pwr_off14 = 6; 
parameter Pwr_on114 = 7; 
parameter Pwr_on214 = 8; 
parameter Restore_edge14 = 9; 
parameter Wait214 = 10; 
parameter De_isolate14 = 11; 
parameter Clk_on14 = 12; 
parameter Wait314 = 13; 
parameter Rst_clr14 = 14;


// Power14 Shut14 Off14 State14 Machine14

// FSM14 combinational14 process
always @  (*)
  begin
    case (currentState14)

      // Commence14 PSO14 once14 the L114 req bit is set.
      Init14:
        if (L1_module_req14 == 1'b1)
          nextState14 = Clk_off14;         // Gate14 the module's clocks14 off14
        else
          nextState14 = Init14;            // Keep14 waiting14 in Init14 state
        
      Clk_off14 :
        nextState14 = Wait114;             // Wait14 for one cycle
 
      Wait114  :                         // Wait14 for clk14 gating14 to take14 effect
        nextState14 = Isolate14;           // Start14 the isolation14 process
          
      Isolate14 :
        nextState14 = Save_edge14;
        
      Save_edge14 :
        nextState14 = Pre_pwr_off14;

      Pre_pwr_off14 :
        nextState14 = Pwr_off14;
      // Exit14 PSO14 once14 the L114 req bit is clear.

      Pwr_off14 :
        if (L1_module_req14 == 1'b0)
          nextState14 = Pwr_on114;         // Resume14 power14 if the L1_module_req14 bit is cleared14
        else
          nextState14 = Pwr_off14;         // Wait14 until the L1_module_req14 bit is cleared14
        
      Pwr_on114 :
        nextState14 = Pwr_on214;
          
      Pwr_on214 :
        if(trans_cnt14 == 5'd28)
          nextState14 = Restore_edge14;
        else 
          nextState14 = Pwr_on214;
          
      Restore_edge14 :
        nextState14 = Wait214;

      Wait214 :
        nextState14 = De_isolate14;
          
      De_isolate14 :
        nextState14 = Clk_on14;
          
      Clk_on14 :
        nextState14 = Wait314;
          
      Wait314  :                         // Wait14 for clock14 to resume
        nextState14 = Rst_clr14 ;     
 
      Rst_clr14 :
        nextState14 = Init14;
        
      default  :                       // Catch14 all
        nextState14 = Init14; 
        
    endcase
  end


  // Signals14 Sequential14 process - gate_clk_module14
always @ (posedge pclk14 or negedge nprst14)
  begin
    if (~nprst14)
      gate_clk_module14 <= 1'b0;
    else 
      if (nextState14 == Clk_on14 | nextState14 == Wait314 | nextState14 == Rst_clr14 | 
          nextState14 == Init14)
          gate_clk_module14 <= 1'b0;
      else
          gate_clk_module14 <= 1'b1;
  end

// Signals14 Sequential14 process - rstn_non_srpg14
always @ (posedge pclk14 or negedge nprst14)
  begin
    if (~nprst14)
      rstn_non_srpg14 <= 1'b0;
    else
      if ( nextState14 == Init14 | nextState14 == Clk_off14 | nextState14 == Wait114 | 
           nextState14 == Isolate14 | nextState14 == Save_edge14 | nextState14 == Pre_pwr_off14 | nextState14 == Rst_clr14)
        rstn_non_srpg14 <= 1'b1;
      else
        rstn_non_srpg14 <= 1'b0;
   end


// Signals14 Sequential14 process - pwr1_on14 & pwr2_on14
always @ (posedge pclk14 or negedge nprst14)
  begin
    if (~nprst14)
      pwr1_on14 <=  1'b1;  // power14 gates14 1 & 2 are on
    else
      if (nextState14 == Pwr_off14 )
        pwr1_on14 <= 1'b0;  // shut14 off14 both power14 gates14 1 & 2
      else
        pwr1_on14 <= 1'b1;
  end


// Signals14 Sequential14 process - pwr1_on14 & pwr2_on14
always @ (posedge pclk14 or negedge nprst14)
  begin
    if (~nprst14)
       pwr2_on14 <= 1'b1;      // power14 gates14 1 & 2 are on
    else
      if (nextState14 == Pwr_off14 | nextState14 == Pwr_on114)
        pwr2_on14 <= 1'b0;     // shut14 off14 both power14 gates14 1 & 2
      else
        pwr2_on14 <= 1'b1;
   end


// Signals14 Sequential14 process - isolate_module14 
always @ (posedge pclk14 or negedge nprst14)
  begin
    if (~nprst14)
        isolate_module14 <= 1'b0;
    else
      if (nextState14 == Isolate14 | nextState14 == Save_edge14 | nextState14 == Pre_pwr_off14 |  nextState14 == Pwr_off14 | nextState14 == Pwr_on114 |
          nextState14 == Pwr_on214 | nextState14 == Restore_edge14 | nextState14 == Wait214)
         isolate_module14 <= 1'b1;       // Activate14 the isolate14 and retain14 signals14
      else
         isolate_module14 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk14 or negedge nprst14)
  begin
    if (~nprst14)
        save_edge14 <= 1'b0;
    else
      if (nextState14 == Save_edge14 )
         save_edge14 <= 1'b1;       // Activate14 the isolate14 and retain14 signals14
      else
         save_edge14 <= 1'b0;        
   end    
// stabilising14 count
wire restore_change14;
assign restore_change14 = (nextState14 == Pwr_on214) ? 1'b1: 1'b0;

always @ (posedge pclk14 or negedge nprst14)
  begin
    if (~nprst14)
      trans_cnt14 <= 0;
    else if (trans_cnt14 > 0)
      trans_cnt14  <= trans_cnt14 + 1;
    else if (restore_change14)
      trans_cnt14  <= trans_cnt14 + 1;
  end

// enabling restore14 edge
always @ (posedge pclk14 or negedge nprst14)
  begin
    if (~nprst14)
        restore_edge14 <= 1'b0;
    else
      if (nextState14 == Restore_edge14)
         restore_edge14 <= 1'b1;       // Activate14 the isolate14 and retain14 signals14
      else
         restore_edge14 <= 1'b0;        
   end    


// FSM14 Sequential14 process
always @ (posedge pclk14 or negedge nprst14)
  begin
    if (~nprst14)
      currentState14 <= Init14;
    else
      currentState14 <= nextState14;
  end


// Reset14 for non-SRPG14 FFs14 is a combination14 of the nprst14 and the reset during PSO14
assign  rstn_non_srpg_module14 = rstn_non_srpg14 & nprst14;

assign  set_status_module14 = (nextState14 == Clk_off14);    // Set the L114 status bit  
assign  clr_status_module14 = (currentState14 == Rst_clr14); // Clear the L114 status bit  
  

`ifdef LP_ABV_ON14

// psl14 default clock14 = (posedge pclk14);

// Never14 have the set and clear status signals14 both set
// psl14 output_no_set_and_clear14 : assert never {set_status_module14 & clr_status_module14};



// Isolate14 signal14 should become14 active on the 
// Next14 clock14 after Gate14 signal14 is activated14
// psl14 output_pd_seq14:
//    assert always
//	  {rose14(gate_clk_module14)} |=> {[*1]; {rose14(isolate_module14)} }
//    abort14(~nprst14);
//
//
//
// Reset14 signal14 for Non14-SRPG14 FFs14 and POWER14 signal14 for
// SMC14 should become14 LOW14 on clock14 cycle after Isolate14 
// signal14 is activated14
// psl14 output_pd_seq_stg_214:
//    assert always
//    {rose14(isolate_module14)} |=>
//    {[*2]; {{fell14(rstn_non_srpg_module14)} && {fell14(pwr1_on14)}} }
//    abort14(~nprst14);
//
//
// Whenever14 pwr1_on14 goes14 to LOW14 pwr2_on14 should also go14 to LOW14
// psl14 output_pwr2_low14:
//    assert always
//    { fell14(pwr1_on14) } |->  { fell14(pwr2_on14) }
//    abort14(~nprst14);
//
//
// Whenever14 pwr1_on14 becomes HIGH14 , On14 Next14 clock14 cycle pwr2_on14
// should also become14 HIGH14
// psl14 output_pwr2_high14:
//    assert always
//    { rose14(pwr1_on14) } |=>  { (pwr2_on14) }
//    abort14(~nprst14);
//
`endif


endmodule
