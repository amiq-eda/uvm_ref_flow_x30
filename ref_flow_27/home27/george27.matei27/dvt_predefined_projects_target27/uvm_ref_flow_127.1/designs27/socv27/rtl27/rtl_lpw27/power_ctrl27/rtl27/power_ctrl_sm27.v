//File27 name   : power_ctrl_sm27.v
//Title27       : Power27 Controller27 state machine27
//Created27     : 1999
//Description27 : State27 machine27 of power27 controller27
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
module power_ctrl_sm27 (

    // Clocks27 & Reset27
    pclk27,
    nprst27,

    // Register Control27 inputs27
    L1_module_req27,
    set_status_module27,
    clr_status_module27,

    // Module27 control27 outputs27
    rstn_non_srpg_module27,
    gate_clk_module27,
    isolate_module27,
    save_edge27,
    restore_edge27,
    pwr1_on27,
    pwr2_on27

);

input    pclk27;
input    nprst27;

input    L1_module_req27;
output   set_status_module27;
output   clr_status_module27;
    
output   rstn_non_srpg_module27;
output   gate_clk_module27;
output   isolate_module27;
output   pwr1_on27;
output   pwr2_on27;
output save_edge27;
output restore_edge27;

wire    set_status_module27;
wire    clr_status_module27;

wire    rstn_non_srpg_module27;
reg     gate_clk_module27;
reg     isolate_module27;
reg     pwr1_on27;
reg     pwr2_on27;

reg save_edge27;

reg restore_edge27;
   
// FSM27 state
reg  [3:0] currentState27, nextState27;
reg     rstn_non_srpg27;
reg [4:0] trans_cnt27;

parameter Init27 = 0; 
parameter Clk_off27 = 1; 
parameter Wait127 = 2; 
parameter Isolate27 = 3; 
parameter Save_edge27 = 4; 
parameter Pre_pwr_off27 = 5; 
parameter Pwr_off27 = 6; 
parameter Pwr_on127 = 7; 
parameter Pwr_on227 = 8; 
parameter Restore_edge27 = 9; 
parameter Wait227 = 10; 
parameter De_isolate27 = 11; 
parameter Clk_on27 = 12; 
parameter Wait327 = 13; 
parameter Rst_clr27 = 14;


// Power27 Shut27 Off27 State27 Machine27

// FSM27 combinational27 process
always @  (*)
  begin
    case (currentState27)

      // Commence27 PSO27 once27 the L127 req bit is set.
      Init27:
        if (L1_module_req27 == 1'b1)
          nextState27 = Clk_off27;         // Gate27 the module's clocks27 off27
        else
          nextState27 = Init27;            // Keep27 waiting27 in Init27 state
        
      Clk_off27 :
        nextState27 = Wait127;             // Wait27 for one cycle
 
      Wait127  :                         // Wait27 for clk27 gating27 to take27 effect
        nextState27 = Isolate27;           // Start27 the isolation27 process
          
      Isolate27 :
        nextState27 = Save_edge27;
        
      Save_edge27 :
        nextState27 = Pre_pwr_off27;

      Pre_pwr_off27 :
        nextState27 = Pwr_off27;
      // Exit27 PSO27 once27 the L127 req bit is clear.

      Pwr_off27 :
        if (L1_module_req27 == 1'b0)
          nextState27 = Pwr_on127;         // Resume27 power27 if the L1_module_req27 bit is cleared27
        else
          nextState27 = Pwr_off27;         // Wait27 until the L1_module_req27 bit is cleared27
        
      Pwr_on127 :
        nextState27 = Pwr_on227;
          
      Pwr_on227 :
        if(trans_cnt27 == 5'd28)
          nextState27 = Restore_edge27;
        else 
          nextState27 = Pwr_on227;
          
      Restore_edge27 :
        nextState27 = Wait227;

      Wait227 :
        nextState27 = De_isolate27;
          
      De_isolate27 :
        nextState27 = Clk_on27;
          
      Clk_on27 :
        nextState27 = Wait327;
          
      Wait327  :                         // Wait27 for clock27 to resume
        nextState27 = Rst_clr27 ;     
 
      Rst_clr27 :
        nextState27 = Init27;
        
      default  :                       // Catch27 all
        nextState27 = Init27; 
        
    endcase
  end


  // Signals27 Sequential27 process - gate_clk_module27
always @ (posedge pclk27 or negedge nprst27)
  begin
    if (~nprst27)
      gate_clk_module27 <= 1'b0;
    else 
      if (nextState27 == Clk_on27 | nextState27 == Wait327 | nextState27 == Rst_clr27 | 
          nextState27 == Init27)
          gate_clk_module27 <= 1'b0;
      else
          gate_clk_module27 <= 1'b1;
  end

// Signals27 Sequential27 process - rstn_non_srpg27
always @ (posedge pclk27 or negedge nprst27)
  begin
    if (~nprst27)
      rstn_non_srpg27 <= 1'b0;
    else
      if ( nextState27 == Init27 | nextState27 == Clk_off27 | nextState27 == Wait127 | 
           nextState27 == Isolate27 | nextState27 == Save_edge27 | nextState27 == Pre_pwr_off27 | nextState27 == Rst_clr27)
        rstn_non_srpg27 <= 1'b1;
      else
        rstn_non_srpg27 <= 1'b0;
   end


// Signals27 Sequential27 process - pwr1_on27 & pwr2_on27
always @ (posedge pclk27 or negedge nprst27)
  begin
    if (~nprst27)
      pwr1_on27 <=  1'b1;  // power27 gates27 1 & 2 are on
    else
      if (nextState27 == Pwr_off27 )
        pwr1_on27 <= 1'b0;  // shut27 off27 both power27 gates27 1 & 2
      else
        pwr1_on27 <= 1'b1;
  end


// Signals27 Sequential27 process - pwr1_on27 & pwr2_on27
always @ (posedge pclk27 or negedge nprst27)
  begin
    if (~nprst27)
       pwr2_on27 <= 1'b1;      // power27 gates27 1 & 2 are on
    else
      if (nextState27 == Pwr_off27 | nextState27 == Pwr_on127)
        pwr2_on27 <= 1'b0;     // shut27 off27 both power27 gates27 1 & 2
      else
        pwr2_on27 <= 1'b1;
   end


// Signals27 Sequential27 process - isolate_module27 
always @ (posedge pclk27 or negedge nprst27)
  begin
    if (~nprst27)
        isolate_module27 <= 1'b0;
    else
      if (nextState27 == Isolate27 | nextState27 == Save_edge27 | nextState27 == Pre_pwr_off27 |  nextState27 == Pwr_off27 | nextState27 == Pwr_on127 |
          nextState27 == Pwr_on227 | nextState27 == Restore_edge27 | nextState27 == Wait227)
         isolate_module27 <= 1'b1;       // Activate27 the isolate27 and retain27 signals27
      else
         isolate_module27 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk27 or negedge nprst27)
  begin
    if (~nprst27)
        save_edge27 <= 1'b0;
    else
      if (nextState27 == Save_edge27 )
         save_edge27 <= 1'b1;       // Activate27 the isolate27 and retain27 signals27
      else
         save_edge27 <= 1'b0;        
   end    
// stabilising27 count
wire restore_change27;
assign restore_change27 = (nextState27 == Pwr_on227) ? 1'b1: 1'b0;

always @ (posedge pclk27 or negedge nprst27)
  begin
    if (~nprst27)
      trans_cnt27 <= 0;
    else if (trans_cnt27 > 0)
      trans_cnt27  <= trans_cnt27 + 1;
    else if (restore_change27)
      trans_cnt27  <= trans_cnt27 + 1;
  end

// enabling restore27 edge
always @ (posedge pclk27 or negedge nprst27)
  begin
    if (~nprst27)
        restore_edge27 <= 1'b0;
    else
      if (nextState27 == Restore_edge27)
         restore_edge27 <= 1'b1;       // Activate27 the isolate27 and retain27 signals27
      else
         restore_edge27 <= 1'b0;        
   end    


// FSM27 Sequential27 process
always @ (posedge pclk27 or negedge nprst27)
  begin
    if (~nprst27)
      currentState27 <= Init27;
    else
      currentState27 <= nextState27;
  end


// Reset27 for non-SRPG27 FFs27 is a combination27 of the nprst27 and the reset during PSO27
assign  rstn_non_srpg_module27 = rstn_non_srpg27 & nprst27;

assign  set_status_module27 = (nextState27 == Clk_off27);    // Set the L127 status bit  
assign  clr_status_module27 = (currentState27 == Rst_clr27); // Clear the L127 status bit  
  

`ifdef LP_ABV_ON27

// psl27 default clock27 = (posedge pclk27);

// Never27 have the set and clear status signals27 both set
// psl27 output_no_set_and_clear27 : assert never {set_status_module27 & clr_status_module27};



// Isolate27 signal27 should become27 active on the 
// Next27 clock27 after Gate27 signal27 is activated27
// psl27 output_pd_seq27:
//    assert always
//	  {rose27(gate_clk_module27)} |=> {[*1]; {rose27(isolate_module27)} }
//    abort27(~nprst27);
//
//
//
// Reset27 signal27 for Non27-SRPG27 FFs27 and POWER27 signal27 for
// SMC27 should become27 LOW27 on clock27 cycle after Isolate27 
// signal27 is activated27
// psl27 output_pd_seq_stg_227:
//    assert always
//    {rose27(isolate_module27)} |=>
//    {[*2]; {{fell27(rstn_non_srpg_module27)} && {fell27(pwr1_on27)}} }
//    abort27(~nprst27);
//
//
// Whenever27 pwr1_on27 goes27 to LOW27 pwr2_on27 should also go27 to LOW27
// psl27 output_pwr2_low27:
//    assert always
//    { fell27(pwr1_on27) } |->  { fell27(pwr2_on27) }
//    abort27(~nprst27);
//
//
// Whenever27 pwr1_on27 becomes HIGH27 , On27 Next27 clock27 cycle pwr2_on27
// should also become27 HIGH27
// psl27 output_pwr2_high27:
//    assert always
//    { rose27(pwr1_on27) } |=>  { (pwr2_on27) }
//    abort27(~nprst27);
//
`endif


endmodule
