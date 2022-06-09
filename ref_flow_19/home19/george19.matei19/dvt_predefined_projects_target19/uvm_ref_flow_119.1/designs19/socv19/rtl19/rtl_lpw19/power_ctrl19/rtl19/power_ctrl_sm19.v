//File19 name   : power_ctrl_sm19.v
//Title19       : Power19 Controller19 state machine19
//Created19     : 1999
//Description19 : State19 machine19 of power19 controller19
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
module power_ctrl_sm19 (

    // Clocks19 & Reset19
    pclk19,
    nprst19,

    // Register Control19 inputs19
    L1_module_req19,
    set_status_module19,
    clr_status_module19,

    // Module19 control19 outputs19
    rstn_non_srpg_module19,
    gate_clk_module19,
    isolate_module19,
    save_edge19,
    restore_edge19,
    pwr1_on19,
    pwr2_on19

);

input    pclk19;
input    nprst19;

input    L1_module_req19;
output   set_status_module19;
output   clr_status_module19;
    
output   rstn_non_srpg_module19;
output   gate_clk_module19;
output   isolate_module19;
output   pwr1_on19;
output   pwr2_on19;
output save_edge19;
output restore_edge19;

wire    set_status_module19;
wire    clr_status_module19;

wire    rstn_non_srpg_module19;
reg     gate_clk_module19;
reg     isolate_module19;
reg     pwr1_on19;
reg     pwr2_on19;

reg save_edge19;

reg restore_edge19;
   
// FSM19 state
reg  [3:0] currentState19, nextState19;
reg     rstn_non_srpg19;
reg [4:0] trans_cnt19;

parameter Init19 = 0; 
parameter Clk_off19 = 1; 
parameter Wait119 = 2; 
parameter Isolate19 = 3; 
parameter Save_edge19 = 4; 
parameter Pre_pwr_off19 = 5; 
parameter Pwr_off19 = 6; 
parameter Pwr_on119 = 7; 
parameter Pwr_on219 = 8; 
parameter Restore_edge19 = 9; 
parameter Wait219 = 10; 
parameter De_isolate19 = 11; 
parameter Clk_on19 = 12; 
parameter Wait319 = 13; 
parameter Rst_clr19 = 14;


// Power19 Shut19 Off19 State19 Machine19

// FSM19 combinational19 process
always @  (*)
  begin
    case (currentState19)

      // Commence19 PSO19 once19 the L119 req bit is set.
      Init19:
        if (L1_module_req19 == 1'b1)
          nextState19 = Clk_off19;         // Gate19 the module's clocks19 off19
        else
          nextState19 = Init19;            // Keep19 waiting19 in Init19 state
        
      Clk_off19 :
        nextState19 = Wait119;             // Wait19 for one cycle
 
      Wait119  :                         // Wait19 for clk19 gating19 to take19 effect
        nextState19 = Isolate19;           // Start19 the isolation19 process
          
      Isolate19 :
        nextState19 = Save_edge19;
        
      Save_edge19 :
        nextState19 = Pre_pwr_off19;

      Pre_pwr_off19 :
        nextState19 = Pwr_off19;
      // Exit19 PSO19 once19 the L119 req bit is clear.

      Pwr_off19 :
        if (L1_module_req19 == 1'b0)
          nextState19 = Pwr_on119;         // Resume19 power19 if the L1_module_req19 bit is cleared19
        else
          nextState19 = Pwr_off19;         // Wait19 until the L1_module_req19 bit is cleared19
        
      Pwr_on119 :
        nextState19 = Pwr_on219;
          
      Pwr_on219 :
        if(trans_cnt19 == 5'd28)
          nextState19 = Restore_edge19;
        else 
          nextState19 = Pwr_on219;
          
      Restore_edge19 :
        nextState19 = Wait219;

      Wait219 :
        nextState19 = De_isolate19;
          
      De_isolate19 :
        nextState19 = Clk_on19;
          
      Clk_on19 :
        nextState19 = Wait319;
          
      Wait319  :                         // Wait19 for clock19 to resume
        nextState19 = Rst_clr19 ;     
 
      Rst_clr19 :
        nextState19 = Init19;
        
      default  :                       // Catch19 all
        nextState19 = Init19; 
        
    endcase
  end


  // Signals19 Sequential19 process - gate_clk_module19
always @ (posedge pclk19 or negedge nprst19)
  begin
    if (~nprst19)
      gate_clk_module19 <= 1'b0;
    else 
      if (nextState19 == Clk_on19 | nextState19 == Wait319 | nextState19 == Rst_clr19 | 
          nextState19 == Init19)
          gate_clk_module19 <= 1'b0;
      else
          gate_clk_module19 <= 1'b1;
  end

// Signals19 Sequential19 process - rstn_non_srpg19
always @ (posedge pclk19 or negedge nprst19)
  begin
    if (~nprst19)
      rstn_non_srpg19 <= 1'b0;
    else
      if ( nextState19 == Init19 | nextState19 == Clk_off19 | nextState19 == Wait119 | 
           nextState19 == Isolate19 | nextState19 == Save_edge19 | nextState19 == Pre_pwr_off19 | nextState19 == Rst_clr19)
        rstn_non_srpg19 <= 1'b1;
      else
        rstn_non_srpg19 <= 1'b0;
   end


// Signals19 Sequential19 process - pwr1_on19 & pwr2_on19
always @ (posedge pclk19 or negedge nprst19)
  begin
    if (~nprst19)
      pwr1_on19 <=  1'b1;  // power19 gates19 1 & 2 are on
    else
      if (nextState19 == Pwr_off19 )
        pwr1_on19 <= 1'b0;  // shut19 off19 both power19 gates19 1 & 2
      else
        pwr1_on19 <= 1'b1;
  end


// Signals19 Sequential19 process - pwr1_on19 & pwr2_on19
always @ (posedge pclk19 or negedge nprst19)
  begin
    if (~nprst19)
       pwr2_on19 <= 1'b1;      // power19 gates19 1 & 2 are on
    else
      if (nextState19 == Pwr_off19 | nextState19 == Pwr_on119)
        pwr2_on19 <= 1'b0;     // shut19 off19 both power19 gates19 1 & 2
      else
        pwr2_on19 <= 1'b1;
   end


// Signals19 Sequential19 process - isolate_module19 
always @ (posedge pclk19 or negedge nprst19)
  begin
    if (~nprst19)
        isolate_module19 <= 1'b0;
    else
      if (nextState19 == Isolate19 | nextState19 == Save_edge19 | nextState19 == Pre_pwr_off19 |  nextState19 == Pwr_off19 | nextState19 == Pwr_on119 |
          nextState19 == Pwr_on219 | nextState19 == Restore_edge19 | nextState19 == Wait219)
         isolate_module19 <= 1'b1;       // Activate19 the isolate19 and retain19 signals19
      else
         isolate_module19 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk19 or negedge nprst19)
  begin
    if (~nprst19)
        save_edge19 <= 1'b0;
    else
      if (nextState19 == Save_edge19 )
         save_edge19 <= 1'b1;       // Activate19 the isolate19 and retain19 signals19
      else
         save_edge19 <= 1'b0;        
   end    
// stabilising19 count
wire restore_change19;
assign restore_change19 = (nextState19 == Pwr_on219) ? 1'b1: 1'b0;

always @ (posedge pclk19 or negedge nprst19)
  begin
    if (~nprst19)
      trans_cnt19 <= 0;
    else if (trans_cnt19 > 0)
      trans_cnt19  <= trans_cnt19 + 1;
    else if (restore_change19)
      trans_cnt19  <= trans_cnt19 + 1;
  end

// enabling restore19 edge
always @ (posedge pclk19 or negedge nprst19)
  begin
    if (~nprst19)
        restore_edge19 <= 1'b0;
    else
      if (nextState19 == Restore_edge19)
         restore_edge19 <= 1'b1;       // Activate19 the isolate19 and retain19 signals19
      else
         restore_edge19 <= 1'b0;        
   end    


// FSM19 Sequential19 process
always @ (posedge pclk19 or negedge nprst19)
  begin
    if (~nprst19)
      currentState19 <= Init19;
    else
      currentState19 <= nextState19;
  end


// Reset19 for non-SRPG19 FFs19 is a combination19 of the nprst19 and the reset during PSO19
assign  rstn_non_srpg_module19 = rstn_non_srpg19 & nprst19;

assign  set_status_module19 = (nextState19 == Clk_off19);    // Set the L119 status bit  
assign  clr_status_module19 = (currentState19 == Rst_clr19); // Clear the L119 status bit  
  

`ifdef LP_ABV_ON19

// psl19 default clock19 = (posedge pclk19);

// Never19 have the set and clear status signals19 both set
// psl19 output_no_set_and_clear19 : assert never {set_status_module19 & clr_status_module19};



// Isolate19 signal19 should become19 active on the 
// Next19 clock19 after Gate19 signal19 is activated19
// psl19 output_pd_seq19:
//    assert always
//	  {rose19(gate_clk_module19)} |=> {[*1]; {rose19(isolate_module19)} }
//    abort19(~nprst19);
//
//
//
// Reset19 signal19 for Non19-SRPG19 FFs19 and POWER19 signal19 for
// SMC19 should become19 LOW19 on clock19 cycle after Isolate19 
// signal19 is activated19
// psl19 output_pd_seq_stg_219:
//    assert always
//    {rose19(isolate_module19)} |=>
//    {[*2]; {{fell19(rstn_non_srpg_module19)} && {fell19(pwr1_on19)}} }
//    abort19(~nprst19);
//
//
// Whenever19 pwr1_on19 goes19 to LOW19 pwr2_on19 should also go19 to LOW19
// psl19 output_pwr2_low19:
//    assert always
//    { fell19(pwr1_on19) } |->  { fell19(pwr2_on19) }
//    abort19(~nprst19);
//
//
// Whenever19 pwr1_on19 becomes HIGH19 , On19 Next19 clock19 cycle pwr2_on19
// should also become19 HIGH19
// psl19 output_pwr2_high19:
//    assert always
//    { rose19(pwr1_on19) } |=>  { (pwr2_on19) }
//    abort19(~nprst19);
//
`endif


endmodule
