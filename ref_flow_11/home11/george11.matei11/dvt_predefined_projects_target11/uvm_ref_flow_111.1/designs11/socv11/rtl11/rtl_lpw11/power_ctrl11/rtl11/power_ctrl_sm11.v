//File11 name   : power_ctrl_sm11.v
//Title11       : Power11 Controller11 state machine11
//Created11     : 1999
//Description11 : State11 machine11 of power11 controller11
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
module power_ctrl_sm11 (

    // Clocks11 & Reset11
    pclk11,
    nprst11,

    // Register Control11 inputs11
    L1_module_req11,
    set_status_module11,
    clr_status_module11,

    // Module11 control11 outputs11
    rstn_non_srpg_module11,
    gate_clk_module11,
    isolate_module11,
    save_edge11,
    restore_edge11,
    pwr1_on11,
    pwr2_on11

);

input    pclk11;
input    nprst11;

input    L1_module_req11;
output   set_status_module11;
output   clr_status_module11;
    
output   rstn_non_srpg_module11;
output   gate_clk_module11;
output   isolate_module11;
output   pwr1_on11;
output   pwr2_on11;
output save_edge11;
output restore_edge11;

wire    set_status_module11;
wire    clr_status_module11;

wire    rstn_non_srpg_module11;
reg     gate_clk_module11;
reg     isolate_module11;
reg     pwr1_on11;
reg     pwr2_on11;

reg save_edge11;

reg restore_edge11;
   
// FSM11 state
reg  [3:0] currentState11, nextState11;
reg     rstn_non_srpg11;
reg [4:0] trans_cnt11;

parameter Init11 = 0; 
parameter Clk_off11 = 1; 
parameter Wait111 = 2; 
parameter Isolate11 = 3; 
parameter Save_edge11 = 4; 
parameter Pre_pwr_off11 = 5; 
parameter Pwr_off11 = 6; 
parameter Pwr_on111 = 7; 
parameter Pwr_on211 = 8; 
parameter Restore_edge11 = 9; 
parameter Wait211 = 10; 
parameter De_isolate11 = 11; 
parameter Clk_on11 = 12; 
parameter Wait311 = 13; 
parameter Rst_clr11 = 14;


// Power11 Shut11 Off11 State11 Machine11

// FSM11 combinational11 process
always @  (*)
  begin
    case (currentState11)

      // Commence11 PSO11 once11 the L111 req bit is set.
      Init11:
        if (L1_module_req11 == 1'b1)
          nextState11 = Clk_off11;         // Gate11 the module's clocks11 off11
        else
          nextState11 = Init11;            // Keep11 waiting11 in Init11 state
        
      Clk_off11 :
        nextState11 = Wait111;             // Wait11 for one cycle
 
      Wait111  :                         // Wait11 for clk11 gating11 to take11 effect
        nextState11 = Isolate11;           // Start11 the isolation11 process
          
      Isolate11 :
        nextState11 = Save_edge11;
        
      Save_edge11 :
        nextState11 = Pre_pwr_off11;

      Pre_pwr_off11 :
        nextState11 = Pwr_off11;
      // Exit11 PSO11 once11 the L111 req bit is clear.

      Pwr_off11 :
        if (L1_module_req11 == 1'b0)
          nextState11 = Pwr_on111;         // Resume11 power11 if the L1_module_req11 bit is cleared11
        else
          nextState11 = Pwr_off11;         // Wait11 until the L1_module_req11 bit is cleared11
        
      Pwr_on111 :
        nextState11 = Pwr_on211;
          
      Pwr_on211 :
        if(trans_cnt11 == 5'd28)
          nextState11 = Restore_edge11;
        else 
          nextState11 = Pwr_on211;
          
      Restore_edge11 :
        nextState11 = Wait211;

      Wait211 :
        nextState11 = De_isolate11;
          
      De_isolate11 :
        nextState11 = Clk_on11;
          
      Clk_on11 :
        nextState11 = Wait311;
          
      Wait311  :                         // Wait11 for clock11 to resume
        nextState11 = Rst_clr11 ;     
 
      Rst_clr11 :
        nextState11 = Init11;
        
      default  :                       // Catch11 all
        nextState11 = Init11; 
        
    endcase
  end


  // Signals11 Sequential11 process - gate_clk_module11
always @ (posedge pclk11 or negedge nprst11)
  begin
    if (~nprst11)
      gate_clk_module11 <= 1'b0;
    else 
      if (nextState11 == Clk_on11 | nextState11 == Wait311 | nextState11 == Rst_clr11 | 
          nextState11 == Init11)
          gate_clk_module11 <= 1'b0;
      else
          gate_clk_module11 <= 1'b1;
  end

// Signals11 Sequential11 process - rstn_non_srpg11
always @ (posedge pclk11 or negedge nprst11)
  begin
    if (~nprst11)
      rstn_non_srpg11 <= 1'b0;
    else
      if ( nextState11 == Init11 | nextState11 == Clk_off11 | nextState11 == Wait111 | 
           nextState11 == Isolate11 | nextState11 == Save_edge11 | nextState11 == Pre_pwr_off11 | nextState11 == Rst_clr11)
        rstn_non_srpg11 <= 1'b1;
      else
        rstn_non_srpg11 <= 1'b0;
   end


// Signals11 Sequential11 process - pwr1_on11 & pwr2_on11
always @ (posedge pclk11 or negedge nprst11)
  begin
    if (~nprst11)
      pwr1_on11 <=  1'b1;  // power11 gates11 1 & 2 are on
    else
      if (nextState11 == Pwr_off11 )
        pwr1_on11 <= 1'b0;  // shut11 off11 both power11 gates11 1 & 2
      else
        pwr1_on11 <= 1'b1;
  end


// Signals11 Sequential11 process - pwr1_on11 & pwr2_on11
always @ (posedge pclk11 or negedge nprst11)
  begin
    if (~nprst11)
       pwr2_on11 <= 1'b1;      // power11 gates11 1 & 2 are on
    else
      if (nextState11 == Pwr_off11 | nextState11 == Pwr_on111)
        pwr2_on11 <= 1'b0;     // shut11 off11 both power11 gates11 1 & 2
      else
        pwr2_on11 <= 1'b1;
   end


// Signals11 Sequential11 process - isolate_module11 
always @ (posedge pclk11 or negedge nprst11)
  begin
    if (~nprst11)
        isolate_module11 <= 1'b0;
    else
      if (nextState11 == Isolate11 | nextState11 == Save_edge11 | nextState11 == Pre_pwr_off11 |  nextState11 == Pwr_off11 | nextState11 == Pwr_on111 |
          nextState11 == Pwr_on211 | nextState11 == Restore_edge11 | nextState11 == Wait211)
         isolate_module11 <= 1'b1;       // Activate11 the isolate11 and retain11 signals11
      else
         isolate_module11 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk11 or negedge nprst11)
  begin
    if (~nprst11)
        save_edge11 <= 1'b0;
    else
      if (nextState11 == Save_edge11 )
         save_edge11 <= 1'b1;       // Activate11 the isolate11 and retain11 signals11
      else
         save_edge11 <= 1'b0;        
   end    
// stabilising11 count
wire restore_change11;
assign restore_change11 = (nextState11 == Pwr_on211) ? 1'b1: 1'b0;

always @ (posedge pclk11 or negedge nprst11)
  begin
    if (~nprst11)
      trans_cnt11 <= 0;
    else if (trans_cnt11 > 0)
      trans_cnt11  <= trans_cnt11 + 1;
    else if (restore_change11)
      trans_cnt11  <= trans_cnt11 + 1;
  end

// enabling restore11 edge
always @ (posedge pclk11 or negedge nprst11)
  begin
    if (~nprst11)
        restore_edge11 <= 1'b0;
    else
      if (nextState11 == Restore_edge11)
         restore_edge11 <= 1'b1;       // Activate11 the isolate11 and retain11 signals11
      else
         restore_edge11 <= 1'b0;        
   end    


// FSM11 Sequential11 process
always @ (posedge pclk11 or negedge nprst11)
  begin
    if (~nprst11)
      currentState11 <= Init11;
    else
      currentState11 <= nextState11;
  end


// Reset11 for non-SRPG11 FFs11 is a combination11 of the nprst11 and the reset during PSO11
assign  rstn_non_srpg_module11 = rstn_non_srpg11 & nprst11;

assign  set_status_module11 = (nextState11 == Clk_off11);    // Set the L111 status bit  
assign  clr_status_module11 = (currentState11 == Rst_clr11); // Clear the L111 status bit  
  

`ifdef LP_ABV_ON11

// psl11 default clock11 = (posedge pclk11);

// Never11 have the set and clear status signals11 both set
// psl11 output_no_set_and_clear11 : assert never {set_status_module11 & clr_status_module11};



// Isolate11 signal11 should become11 active on the 
// Next11 clock11 after Gate11 signal11 is activated11
// psl11 output_pd_seq11:
//    assert always
//	  {rose11(gate_clk_module11)} |=> {[*1]; {rose11(isolate_module11)} }
//    abort11(~nprst11);
//
//
//
// Reset11 signal11 for Non11-SRPG11 FFs11 and POWER11 signal11 for
// SMC11 should become11 LOW11 on clock11 cycle after Isolate11 
// signal11 is activated11
// psl11 output_pd_seq_stg_211:
//    assert always
//    {rose11(isolate_module11)} |=>
//    {[*2]; {{fell11(rstn_non_srpg_module11)} && {fell11(pwr1_on11)}} }
//    abort11(~nprst11);
//
//
// Whenever11 pwr1_on11 goes11 to LOW11 pwr2_on11 should also go11 to LOW11
// psl11 output_pwr2_low11:
//    assert always
//    { fell11(pwr1_on11) } |->  { fell11(pwr2_on11) }
//    abort11(~nprst11);
//
//
// Whenever11 pwr1_on11 becomes HIGH11 , On11 Next11 clock11 cycle pwr2_on11
// should also become11 HIGH11
// psl11 output_pwr2_high11:
//    assert always
//    { rose11(pwr1_on11) } |=>  { (pwr2_on11) }
//    abort11(~nprst11);
//
`endif


endmodule
