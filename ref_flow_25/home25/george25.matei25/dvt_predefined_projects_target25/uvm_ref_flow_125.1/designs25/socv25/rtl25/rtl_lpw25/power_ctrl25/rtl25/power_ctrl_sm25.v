//File25 name   : power_ctrl_sm25.v
//Title25       : Power25 Controller25 state machine25
//Created25     : 1999
//Description25 : State25 machine25 of power25 controller25
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
module power_ctrl_sm25 (

    // Clocks25 & Reset25
    pclk25,
    nprst25,

    // Register Control25 inputs25
    L1_module_req25,
    set_status_module25,
    clr_status_module25,

    // Module25 control25 outputs25
    rstn_non_srpg_module25,
    gate_clk_module25,
    isolate_module25,
    save_edge25,
    restore_edge25,
    pwr1_on25,
    pwr2_on25

);

input    pclk25;
input    nprst25;

input    L1_module_req25;
output   set_status_module25;
output   clr_status_module25;
    
output   rstn_non_srpg_module25;
output   gate_clk_module25;
output   isolate_module25;
output   pwr1_on25;
output   pwr2_on25;
output save_edge25;
output restore_edge25;

wire    set_status_module25;
wire    clr_status_module25;

wire    rstn_non_srpg_module25;
reg     gate_clk_module25;
reg     isolate_module25;
reg     pwr1_on25;
reg     pwr2_on25;

reg save_edge25;

reg restore_edge25;
   
// FSM25 state
reg  [3:0] currentState25, nextState25;
reg     rstn_non_srpg25;
reg [4:0] trans_cnt25;

parameter Init25 = 0; 
parameter Clk_off25 = 1; 
parameter Wait125 = 2; 
parameter Isolate25 = 3; 
parameter Save_edge25 = 4; 
parameter Pre_pwr_off25 = 5; 
parameter Pwr_off25 = 6; 
parameter Pwr_on125 = 7; 
parameter Pwr_on225 = 8; 
parameter Restore_edge25 = 9; 
parameter Wait225 = 10; 
parameter De_isolate25 = 11; 
parameter Clk_on25 = 12; 
parameter Wait325 = 13; 
parameter Rst_clr25 = 14;


// Power25 Shut25 Off25 State25 Machine25

// FSM25 combinational25 process
always @  (*)
  begin
    case (currentState25)

      // Commence25 PSO25 once25 the L125 req bit is set.
      Init25:
        if (L1_module_req25 == 1'b1)
          nextState25 = Clk_off25;         // Gate25 the module's clocks25 off25
        else
          nextState25 = Init25;            // Keep25 waiting25 in Init25 state
        
      Clk_off25 :
        nextState25 = Wait125;             // Wait25 for one cycle
 
      Wait125  :                         // Wait25 for clk25 gating25 to take25 effect
        nextState25 = Isolate25;           // Start25 the isolation25 process
          
      Isolate25 :
        nextState25 = Save_edge25;
        
      Save_edge25 :
        nextState25 = Pre_pwr_off25;

      Pre_pwr_off25 :
        nextState25 = Pwr_off25;
      // Exit25 PSO25 once25 the L125 req bit is clear.

      Pwr_off25 :
        if (L1_module_req25 == 1'b0)
          nextState25 = Pwr_on125;         // Resume25 power25 if the L1_module_req25 bit is cleared25
        else
          nextState25 = Pwr_off25;         // Wait25 until the L1_module_req25 bit is cleared25
        
      Pwr_on125 :
        nextState25 = Pwr_on225;
          
      Pwr_on225 :
        if(trans_cnt25 == 5'd28)
          nextState25 = Restore_edge25;
        else 
          nextState25 = Pwr_on225;
          
      Restore_edge25 :
        nextState25 = Wait225;

      Wait225 :
        nextState25 = De_isolate25;
          
      De_isolate25 :
        nextState25 = Clk_on25;
          
      Clk_on25 :
        nextState25 = Wait325;
          
      Wait325  :                         // Wait25 for clock25 to resume
        nextState25 = Rst_clr25 ;     
 
      Rst_clr25 :
        nextState25 = Init25;
        
      default  :                       // Catch25 all
        nextState25 = Init25; 
        
    endcase
  end


  // Signals25 Sequential25 process - gate_clk_module25
always @ (posedge pclk25 or negedge nprst25)
  begin
    if (~nprst25)
      gate_clk_module25 <= 1'b0;
    else 
      if (nextState25 == Clk_on25 | nextState25 == Wait325 | nextState25 == Rst_clr25 | 
          nextState25 == Init25)
          gate_clk_module25 <= 1'b0;
      else
          gate_clk_module25 <= 1'b1;
  end

// Signals25 Sequential25 process - rstn_non_srpg25
always @ (posedge pclk25 or negedge nprst25)
  begin
    if (~nprst25)
      rstn_non_srpg25 <= 1'b0;
    else
      if ( nextState25 == Init25 | nextState25 == Clk_off25 | nextState25 == Wait125 | 
           nextState25 == Isolate25 | nextState25 == Save_edge25 | nextState25 == Pre_pwr_off25 | nextState25 == Rst_clr25)
        rstn_non_srpg25 <= 1'b1;
      else
        rstn_non_srpg25 <= 1'b0;
   end


// Signals25 Sequential25 process - pwr1_on25 & pwr2_on25
always @ (posedge pclk25 or negedge nprst25)
  begin
    if (~nprst25)
      pwr1_on25 <=  1'b1;  // power25 gates25 1 & 2 are on
    else
      if (nextState25 == Pwr_off25 )
        pwr1_on25 <= 1'b0;  // shut25 off25 both power25 gates25 1 & 2
      else
        pwr1_on25 <= 1'b1;
  end


// Signals25 Sequential25 process - pwr1_on25 & pwr2_on25
always @ (posedge pclk25 or negedge nprst25)
  begin
    if (~nprst25)
       pwr2_on25 <= 1'b1;      // power25 gates25 1 & 2 are on
    else
      if (nextState25 == Pwr_off25 | nextState25 == Pwr_on125)
        pwr2_on25 <= 1'b0;     // shut25 off25 both power25 gates25 1 & 2
      else
        pwr2_on25 <= 1'b1;
   end


// Signals25 Sequential25 process - isolate_module25 
always @ (posedge pclk25 or negedge nprst25)
  begin
    if (~nprst25)
        isolate_module25 <= 1'b0;
    else
      if (nextState25 == Isolate25 | nextState25 == Save_edge25 | nextState25 == Pre_pwr_off25 |  nextState25 == Pwr_off25 | nextState25 == Pwr_on125 |
          nextState25 == Pwr_on225 | nextState25 == Restore_edge25 | nextState25 == Wait225)
         isolate_module25 <= 1'b1;       // Activate25 the isolate25 and retain25 signals25
      else
         isolate_module25 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk25 or negedge nprst25)
  begin
    if (~nprst25)
        save_edge25 <= 1'b0;
    else
      if (nextState25 == Save_edge25 )
         save_edge25 <= 1'b1;       // Activate25 the isolate25 and retain25 signals25
      else
         save_edge25 <= 1'b0;        
   end    
// stabilising25 count
wire restore_change25;
assign restore_change25 = (nextState25 == Pwr_on225) ? 1'b1: 1'b0;

always @ (posedge pclk25 or negedge nprst25)
  begin
    if (~nprst25)
      trans_cnt25 <= 0;
    else if (trans_cnt25 > 0)
      trans_cnt25  <= trans_cnt25 + 1;
    else if (restore_change25)
      trans_cnt25  <= trans_cnt25 + 1;
  end

// enabling restore25 edge
always @ (posedge pclk25 or negedge nprst25)
  begin
    if (~nprst25)
        restore_edge25 <= 1'b0;
    else
      if (nextState25 == Restore_edge25)
         restore_edge25 <= 1'b1;       // Activate25 the isolate25 and retain25 signals25
      else
         restore_edge25 <= 1'b0;        
   end    


// FSM25 Sequential25 process
always @ (posedge pclk25 or negedge nprst25)
  begin
    if (~nprst25)
      currentState25 <= Init25;
    else
      currentState25 <= nextState25;
  end


// Reset25 for non-SRPG25 FFs25 is a combination25 of the nprst25 and the reset during PSO25
assign  rstn_non_srpg_module25 = rstn_non_srpg25 & nprst25;

assign  set_status_module25 = (nextState25 == Clk_off25);    // Set the L125 status bit  
assign  clr_status_module25 = (currentState25 == Rst_clr25); // Clear the L125 status bit  
  

`ifdef LP_ABV_ON25

// psl25 default clock25 = (posedge pclk25);

// Never25 have the set and clear status signals25 both set
// psl25 output_no_set_and_clear25 : assert never {set_status_module25 & clr_status_module25};



// Isolate25 signal25 should become25 active on the 
// Next25 clock25 after Gate25 signal25 is activated25
// psl25 output_pd_seq25:
//    assert always
//	  {rose25(gate_clk_module25)} |=> {[*1]; {rose25(isolate_module25)} }
//    abort25(~nprst25);
//
//
//
// Reset25 signal25 for Non25-SRPG25 FFs25 and POWER25 signal25 for
// SMC25 should become25 LOW25 on clock25 cycle after Isolate25 
// signal25 is activated25
// psl25 output_pd_seq_stg_225:
//    assert always
//    {rose25(isolate_module25)} |=>
//    {[*2]; {{fell25(rstn_non_srpg_module25)} && {fell25(pwr1_on25)}} }
//    abort25(~nprst25);
//
//
// Whenever25 pwr1_on25 goes25 to LOW25 pwr2_on25 should also go25 to LOW25
// psl25 output_pwr2_low25:
//    assert always
//    { fell25(pwr1_on25) } |->  { fell25(pwr2_on25) }
//    abort25(~nprst25);
//
//
// Whenever25 pwr1_on25 becomes HIGH25 , On25 Next25 clock25 cycle pwr2_on25
// should also become25 HIGH25
// psl25 output_pwr2_high25:
//    assert always
//    { rose25(pwr1_on25) } |=>  { (pwr2_on25) }
//    abort25(~nprst25);
//
`endif


endmodule
