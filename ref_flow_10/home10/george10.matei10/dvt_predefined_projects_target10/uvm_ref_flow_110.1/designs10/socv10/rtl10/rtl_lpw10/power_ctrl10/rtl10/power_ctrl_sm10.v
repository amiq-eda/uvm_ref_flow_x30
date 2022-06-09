//File10 name   : power_ctrl_sm10.v
//Title10       : Power10 Controller10 state machine10
//Created10     : 1999
//Description10 : State10 machine10 of power10 controller10
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
module power_ctrl_sm10 (

    // Clocks10 & Reset10
    pclk10,
    nprst10,

    // Register Control10 inputs10
    L1_module_req10,
    set_status_module10,
    clr_status_module10,

    // Module10 control10 outputs10
    rstn_non_srpg_module10,
    gate_clk_module10,
    isolate_module10,
    save_edge10,
    restore_edge10,
    pwr1_on10,
    pwr2_on10

);

input    pclk10;
input    nprst10;

input    L1_module_req10;
output   set_status_module10;
output   clr_status_module10;
    
output   rstn_non_srpg_module10;
output   gate_clk_module10;
output   isolate_module10;
output   pwr1_on10;
output   pwr2_on10;
output save_edge10;
output restore_edge10;

wire    set_status_module10;
wire    clr_status_module10;

wire    rstn_non_srpg_module10;
reg     gate_clk_module10;
reg     isolate_module10;
reg     pwr1_on10;
reg     pwr2_on10;

reg save_edge10;

reg restore_edge10;
   
// FSM10 state
reg  [3:0] currentState10, nextState10;
reg     rstn_non_srpg10;
reg [4:0] trans_cnt10;

parameter Init10 = 0; 
parameter Clk_off10 = 1; 
parameter Wait110 = 2; 
parameter Isolate10 = 3; 
parameter Save_edge10 = 4; 
parameter Pre_pwr_off10 = 5; 
parameter Pwr_off10 = 6; 
parameter Pwr_on110 = 7; 
parameter Pwr_on210 = 8; 
parameter Restore_edge10 = 9; 
parameter Wait210 = 10; 
parameter De_isolate10 = 11; 
parameter Clk_on10 = 12; 
parameter Wait310 = 13; 
parameter Rst_clr10 = 14;


// Power10 Shut10 Off10 State10 Machine10

// FSM10 combinational10 process
always @  (*)
  begin
    case (currentState10)

      // Commence10 PSO10 once10 the L110 req bit is set.
      Init10:
        if (L1_module_req10 == 1'b1)
          nextState10 = Clk_off10;         // Gate10 the module's clocks10 off10
        else
          nextState10 = Init10;            // Keep10 waiting10 in Init10 state
        
      Clk_off10 :
        nextState10 = Wait110;             // Wait10 for one cycle
 
      Wait110  :                         // Wait10 for clk10 gating10 to take10 effect
        nextState10 = Isolate10;           // Start10 the isolation10 process
          
      Isolate10 :
        nextState10 = Save_edge10;
        
      Save_edge10 :
        nextState10 = Pre_pwr_off10;

      Pre_pwr_off10 :
        nextState10 = Pwr_off10;
      // Exit10 PSO10 once10 the L110 req bit is clear.

      Pwr_off10 :
        if (L1_module_req10 == 1'b0)
          nextState10 = Pwr_on110;         // Resume10 power10 if the L1_module_req10 bit is cleared10
        else
          nextState10 = Pwr_off10;         // Wait10 until the L1_module_req10 bit is cleared10
        
      Pwr_on110 :
        nextState10 = Pwr_on210;
          
      Pwr_on210 :
        if(trans_cnt10 == 5'd28)
          nextState10 = Restore_edge10;
        else 
          nextState10 = Pwr_on210;
          
      Restore_edge10 :
        nextState10 = Wait210;

      Wait210 :
        nextState10 = De_isolate10;
          
      De_isolate10 :
        nextState10 = Clk_on10;
          
      Clk_on10 :
        nextState10 = Wait310;
          
      Wait310  :                         // Wait10 for clock10 to resume
        nextState10 = Rst_clr10 ;     
 
      Rst_clr10 :
        nextState10 = Init10;
        
      default  :                       // Catch10 all
        nextState10 = Init10; 
        
    endcase
  end


  // Signals10 Sequential10 process - gate_clk_module10
always @ (posedge pclk10 or negedge nprst10)
  begin
    if (~nprst10)
      gate_clk_module10 <= 1'b0;
    else 
      if (nextState10 == Clk_on10 | nextState10 == Wait310 | nextState10 == Rst_clr10 | 
          nextState10 == Init10)
          gate_clk_module10 <= 1'b0;
      else
          gate_clk_module10 <= 1'b1;
  end

// Signals10 Sequential10 process - rstn_non_srpg10
always @ (posedge pclk10 or negedge nprst10)
  begin
    if (~nprst10)
      rstn_non_srpg10 <= 1'b0;
    else
      if ( nextState10 == Init10 | nextState10 == Clk_off10 | nextState10 == Wait110 | 
           nextState10 == Isolate10 | nextState10 == Save_edge10 | nextState10 == Pre_pwr_off10 | nextState10 == Rst_clr10)
        rstn_non_srpg10 <= 1'b1;
      else
        rstn_non_srpg10 <= 1'b0;
   end


// Signals10 Sequential10 process - pwr1_on10 & pwr2_on10
always @ (posedge pclk10 or negedge nprst10)
  begin
    if (~nprst10)
      pwr1_on10 <=  1'b1;  // power10 gates10 1 & 2 are on
    else
      if (nextState10 == Pwr_off10 )
        pwr1_on10 <= 1'b0;  // shut10 off10 both power10 gates10 1 & 2
      else
        pwr1_on10 <= 1'b1;
  end


// Signals10 Sequential10 process - pwr1_on10 & pwr2_on10
always @ (posedge pclk10 or negedge nprst10)
  begin
    if (~nprst10)
       pwr2_on10 <= 1'b1;      // power10 gates10 1 & 2 are on
    else
      if (nextState10 == Pwr_off10 | nextState10 == Pwr_on110)
        pwr2_on10 <= 1'b0;     // shut10 off10 both power10 gates10 1 & 2
      else
        pwr2_on10 <= 1'b1;
   end


// Signals10 Sequential10 process - isolate_module10 
always @ (posedge pclk10 or negedge nprst10)
  begin
    if (~nprst10)
        isolate_module10 <= 1'b0;
    else
      if (nextState10 == Isolate10 | nextState10 == Save_edge10 | nextState10 == Pre_pwr_off10 |  nextState10 == Pwr_off10 | nextState10 == Pwr_on110 |
          nextState10 == Pwr_on210 | nextState10 == Restore_edge10 | nextState10 == Wait210)
         isolate_module10 <= 1'b1;       // Activate10 the isolate10 and retain10 signals10
      else
         isolate_module10 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk10 or negedge nprst10)
  begin
    if (~nprst10)
        save_edge10 <= 1'b0;
    else
      if (nextState10 == Save_edge10 )
         save_edge10 <= 1'b1;       // Activate10 the isolate10 and retain10 signals10
      else
         save_edge10 <= 1'b0;        
   end    
// stabilising10 count
wire restore_change10;
assign restore_change10 = (nextState10 == Pwr_on210) ? 1'b1: 1'b0;

always @ (posedge pclk10 or negedge nprst10)
  begin
    if (~nprst10)
      trans_cnt10 <= 0;
    else if (trans_cnt10 > 0)
      trans_cnt10  <= trans_cnt10 + 1;
    else if (restore_change10)
      trans_cnt10  <= trans_cnt10 + 1;
  end

// enabling restore10 edge
always @ (posedge pclk10 or negedge nprst10)
  begin
    if (~nprst10)
        restore_edge10 <= 1'b0;
    else
      if (nextState10 == Restore_edge10)
         restore_edge10 <= 1'b1;       // Activate10 the isolate10 and retain10 signals10
      else
         restore_edge10 <= 1'b0;        
   end    


// FSM10 Sequential10 process
always @ (posedge pclk10 or negedge nprst10)
  begin
    if (~nprst10)
      currentState10 <= Init10;
    else
      currentState10 <= nextState10;
  end


// Reset10 for non-SRPG10 FFs10 is a combination10 of the nprst10 and the reset during PSO10
assign  rstn_non_srpg_module10 = rstn_non_srpg10 & nprst10;

assign  set_status_module10 = (nextState10 == Clk_off10);    // Set the L110 status bit  
assign  clr_status_module10 = (currentState10 == Rst_clr10); // Clear the L110 status bit  
  

`ifdef LP_ABV_ON10

// psl10 default clock10 = (posedge pclk10);

// Never10 have the set and clear status signals10 both set
// psl10 output_no_set_and_clear10 : assert never {set_status_module10 & clr_status_module10};



// Isolate10 signal10 should become10 active on the 
// Next10 clock10 after Gate10 signal10 is activated10
// psl10 output_pd_seq10:
//    assert always
//	  {rose10(gate_clk_module10)} |=> {[*1]; {rose10(isolate_module10)} }
//    abort10(~nprst10);
//
//
//
// Reset10 signal10 for Non10-SRPG10 FFs10 and POWER10 signal10 for
// SMC10 should become10 LOW10 on clock10 cycle after Isolate10 
// signal10 is activated10
// psl10 output_pd_seq_stg_210:
//    assert always
//    {rose10(isolate_module10)} |=>
//    {[*2]; {{fell10(rstn_non_srpg_module10)} && {fell10(pwr1_on10)}} }
//    abort10(~nprst10);
//
//
// Whenever10 pwr1_on10 goes10 to LOW10 pwr2_on10 should also go10 to LOW10
// psl10 output_pwr2_low10:
//    assert always
//    { fell10(pwr1_on10) } |->  { fell10(pwr2_on10) }
//    abort10(~nprst10);
//
//
// Whenever10 pwr1_on10 becomes HIGH10 , On10 Next10 clock10 cycle pwr2_on10
// should also become10 HIGH10
// psl10 output_pwr2_high10:
//    assert always
//    { rose10(pwr1_on10) } |=>  { (pwr2_on10) }
//    abort10(~nprst10);
//
`endif


endmodule
