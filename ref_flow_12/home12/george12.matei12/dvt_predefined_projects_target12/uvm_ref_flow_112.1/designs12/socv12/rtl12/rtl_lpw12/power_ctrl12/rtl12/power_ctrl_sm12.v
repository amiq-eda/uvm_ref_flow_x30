//File12 name   : power_ctrl_sm12.v
//Title12       : Power12 Controller12 state machine12
//Created12     : 1999
//Description12 : State12 machine12 of power12 controller12
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
module power_ctrl_sm12 (

    // Clocks12 & Reset12
    pclk12,
    nprst12,

    // Register Control12 inputs12
    L1_module_req12,
    set_status_module12,
    clr_status_module12,

    // Module12 control12 outputs12
    rstn_non_srpg_module12,
    gate_clk_module12,
    isolate_module12,
    save_edge12,
    restore_edge12,
    pwr1_on12,
    pwr2_on12

);

input    pclk12;
input    nprst12;

input    L1_module_req12;
output   set_status_module12;
output   clr_status_module12;
    
output   rstn_non_srpg_module12;
output   gate_clk_module12;
output   isolate_module12;
output   pwr1_on12;
output   pwr2_on12;
output save_edge12;
output restore_edge12;

wire    set_status_module12;
wire    clr_status_module12;

wire    rstn_non_srpg_module12;
reg     gate_clk_module12;
reg     isolate_module12;
reg     pwr1_on12;
reg     pwr2_on12;

reg save_edge12;

reg restore_edge12;
   
// FSM12 state
reg  [3:0] currentState12, nextState12;
reg     rstn_non_srpg12;
reg [4:0] trans_cnt12;

parameter Init12 = 0; 
parameter Clk_off12 = 1; 
parameter Wait112 = 2; 
parameter Isolate12 = 3; 
parameter Save_edge12 = 4; 
parameter Pre_pwr_off12 = 5; 
parameter Pwr_off12 = 6; 
parameter Pwr_on112 = 7; 
parameter Pwr_on212 = 8; 
parameter Restore_edge12 = 9; 
parameter Wait212 = 10; 
parameter De_isolate12 = 11; 
parameter Clk_on12 = 12; 
parameter Wait312 = 13; 
parameter Rst_clr12 = 14;


// Power12 Shut12 Off12 State12 Machine12

// FSM12 combinational12 process
always @  (*)
  begin
    case (currentState12)

      // Commence12 PSO12 once12 the L112 req bit is set.
      Init12:
        if (L1_module_req12 == 1'b1)
          nextState12 = Clk_off12;         // Gate12 the module's clocks12 off12
        else
          nextState12 = Init12;            // Keep12 waiting12 in Init12 state
        
      Clk_off12 :
        nextState12 = Wait112;             // Wait12 for one cycle
 
      Wait112  :                         // Wait12 for clk12 gating12 to take12 effect
        nextState12 = Isolate12;           // Start12 the isolation12 process
          
      Isolate12 :
        nextState12 = Save_edge12;
        
      Save_edge12 :
        nextState12 = Pre_pwr_off12;

      Pre_pwr_off12 :
        nextState12 = Pwr_off12;
      // Exit12 PSO12 once12 the L112 req bit is clear.

      Pwr_off12 :
        if (L1_module_req12 == 1'b0)
          nextState12 = Pwr_on112;         // Resume12 power12 if the L1_module_req12 bit is cleared12
        else
          nextState12 = Pwr_off12;         // Wait12 until the L1_module_req12 bit is cleared12
        
      Pwr_on112 :
        nextState12 = Pwr_on212;
          
      Pwr_on212 :
        if(trans_cnt12 == 5'd28)
          nextState12 = Restore_edge12;
        else 
          nextState12 = Pwr_on212;
          
      Restore_edge12 :
        nextState12 = Wait212;

      Wait212 :
        nextState12 = De_isolate12;
          
      De_isolate12 :
        nextState12 = Clk_on12;
          
      Clk_on12 :
        nextState12 = Wait312;
          
      Wait312  :                         // Wait12 for clock12 to resume
        nextState12 = Rst_clr12 ;     
 
      Rst_clr12 :
        nextState12 = Init12;
        
      default  :                       // Catch12 all
        nextState12 = Init12; 
        
    endcase
  end


  // Signals12 Sequential12 process - gate_clk_module12
always @ (posedge pclk12 or negedge nprst12)
  begin
    if (~nprst12)
      gate_clk_module12 <= 1'b0;
    else 
      if (nextState12 == Clk_on12 | nextState12 == Wait312 | nextState12 == Rst_clr12 | 
          nextState12 == Init12)
          gate_clk_module12 <= 1'b0;
      else
          gate_clk_module12 <= 1'b1;
  end

// Signals12 Sequential12 process - rstn_non_srpg12
always @ (posedge pclk12 or negedge nprst12)
  begin
    if (~nprst12)
      rstn_non_srpg12 <= 1'b0;
    else
      if ( nextState12 == Init12 | nextState12 == Clk_off12 | nextState12 == Wait112 | 
           nextState12 == Isolate12 | nextState12 == Save_edge12 | nextState12 == Pre_pwr_off12 | nextState12 == Rst_clr12)
        rstn_non_srpg12 <= 1'b1;
      else
        rstn_non_srpg12 <= 1'b0;
   end


// Signals12 Sequential12 process - pwr1_on12 & pwr2_on12
always @ (posedge pclk12 or negedge nprst12)
  begin
    if (~nprst12)
      pwr1_on12 <=  1'b1;  // power12 gates12 1 & 2 are on
    else
      if (nextState12 == Pwr_off12 )
        pwr1_on12 <= 1'b0;  // shut12 off12 both power12 gates12 1 & 2
      else
        pwr1_on12 <= 1'b1;
  end


// Signals12 Sequential12 process - pwr1_on12 & pwr2_on12
always @ (posedge pclk12 or negedge nprst12)
  begin
    if (~nprst12)
       pwr2_on12 <= 1'b1;      // power12 gates12 1 & 2 are on
    else
      if (nextState12 == Pwr_off12 | nextState12 == Pwr_on112)
        pwr2_on12 <= 1'b0;     // shut12 off12 both power12 gates12 1 & 2
      else
        pwr2_on12 <= 1'b1;
   end


// Signals12 Sequential12 process - isolate_module12 
always @ (posedge pclk12 or negedge nprst12)
  begin
    if (~nprst12)
        isolate_module12 <= 1'b0;
    else
      if (nextState12 == Isolate12 | nextState12 == Save_edge12 | nextState12 == Pre_pwr_off12 |  nextState12 == Pwr_off12 | nextState12 == Pwr_on112 |
          nextState12 == Pwr_on212 | nextState12 == Restore_edge12 | nextState12 == Wait212)
         isolate_module12 <= 1'b1;       // Activate12 the isolate12 and retain12 signals12
      else
         isolate_module12 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk12 or negedge nprst12)
  begin
    if (~nprst12)
        save_edge12 <= 1'b0;
    else
      if (nextState12 == Save_edge12 )
         save_edge12 <= 1'b1;       // Activate12 the isolate12 and retain12 signals12
      else
         save_edge12 <= 1'b0;        
   end    
// stabilising12 count
wire restore_change12;
assign restore_change12 = (nextState12 == Pwr_on212) ? 1'b1: 1'b0;

always @ (posedge pclk12 or negedge nprst12)
  begin
    if (~nprst12)
      trans_cnt12 <= 0;
    else if (trans_cnt12 > 0)
      trans_cnt12  <= trans_cnt12 + 1;
    else if (restore_change12)
      trans_cnt12  <= trans_cnt12 + 1;
  end

// enabling restore12 edge
always @ (posedge pclk12 or negedge nprst12)
  begin
    if (~nprst12)
        restore_edge12 <= 1'b0;
    else
      if (nextState12 == Restore_edge12)
         restore_edge12 <= 1'b1;       // Activate12 the isolate12 and retain12 signals12
      else
         restore_edge12 <= 1'b0;        
   end    


// FSM12 Sequential12 process
always @ (posedge pclk12 or negedge nprst12)
  begin
    if (~nprst12)
      currentState12 <= Init12;
    else
      currentState12 <= nextState12;
  end


// Reset12 for non-SRPG12 FFs12 is a combination12 of the nprst12 and the reset during PSO12
assign  rstn_non_srpg_module12 = rstn_non_srpg12 & nprst12;

assign  set_status_module12 = (nextState12 == Clk_off12);    // Set the L112 status bit  
assign  clr_status_module12 = (currentState12 == Rst_clr12); // Clear the L112 status bit  
  

`ifdef LP_ABV_ON12

// psl12 default clock12 = (posedge pclk12);

// Never12 have the set and clear status signals12 both set
// psl12 output_no_set_and_clear12 : assert never {set_status_module12 & clr_status_module12};



// Isolate12 signal12 should become12 active on the 
// Next12 clock12 after Gate12 signal12 is activated12
// psl12 output_pd_seq12:
//    assert always
//	  {rose12(gate_clk_module12)} |=> {[*1]; {rose12(isolate_module12)} }
//    abort12(~nprst12);
//
//
//
// Reset12 signal12 for Non12-SRPG12 FFs12 and POWER12 signal12 for
// SMC12 should become12 LOW12 on clock12 cycle after Isolate12 
// signal12 is activated12
// psl12 output_pd_seq_stg_212:
//    assert always
//    {rose12(isolate_module12)} |=>
//    {[*2]; {{fell12(rstn_non_srpg_module12)} && {fell12(pwr1_on12)}} }
//    abort12(~nprst12);
//
//
// Whenever12 pwr1_on12 goes12 to LOW12 pwr2_on12 should also go12 to LOW12
// psl12 output_pwr2_low12:
//    assert always
//    { fell12(pwr1_on12) } |->  { fell12(pwr2_on12) }
//    abort12(~nprst12);
//
//
// Whenever12 pwr1_on12 becomes HIGH12 , On12 Next12 clock12 cycle pwr2_on12
// should also become12 HIGH12
// psl12 output_pwr2_high12:
//    assert always
//    { rose12(pwr1_on12) } |=>  { (pwr2_on12) }
//    abort12(~nprst12);
//
`endif


endmodule
