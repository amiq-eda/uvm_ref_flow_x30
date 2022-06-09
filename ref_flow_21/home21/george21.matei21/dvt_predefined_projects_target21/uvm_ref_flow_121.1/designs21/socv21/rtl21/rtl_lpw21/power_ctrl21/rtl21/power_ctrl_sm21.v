//File21 name   : power_ctrl_sm21.v
//Title21       : Power21 Controller21 state machine21
//Created21     : 1999
//Description21 : State21 machine21 of power21 controller21
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
module power_ctrl_sm21 (

    // Clocks21 & Reset21
    pclk21,
    nprst21,

    // Register Control21 inputs21
    L1_module_req21,
    set_status_module21,
    clr_status_module21,

    // Module21 control21 outputs21
    rstn_non_srpg_module21,
    gate_clk_module21,
    isolate_module21,
    save_edge21,
    restore_edge21,
    pwr1_on21,
    pwr2_on21

);

input    pclk21;
input    nprst21;

input    L1_module_req21;
output   set_status_module21;
output   clr_status_module21;
    
output   rstn_non_srpg_module21;
output   gate_clk_module21;
output   isolate_module21;
output   pwr1_on21;
output   pwr2_on21;
output save_edge21;
output restore_edge21;

wire    set_status_module21;
wire    clr_status_module21;

wire    rstn_non_srpg_module21;
reg     gate_clk_module21;
reg     isolate_module21;
reg     pwr1_on21;
reg     pwr2_on21;

reg save_edge21;

reg restore_edge21;
   
// FSM21 state
reg  [3:0] currentState21, nextState21;
reg     rstn_non_srpg21;
reg [4:0] trans_cnt21;

parameter Init21 = 0; 
parameter Clk_off21 = 1; 
parameter Wait121 = 2; 
parameter Isolate21 = 3; 
parameter Save_edge21 = 4; 
parameter Pre_pwr_off21 = 5; 
parameter Pwr_off21 = 6; 
parameter Pwr_on121 = 7; 
parameter Pwr_on221 = 8; 
parameter Restore_edge21 = 9; 
parameter Wait221 = 10; 
parameter De_isolate21 = 11; 
parameter Clk_on21 = 12; 
parameter Wait321 = 13; 
parameter Rst_clr21 = 14;


// Power21 Shut21 Off21 State21 Machine21

// FSM21 combinational21 process
always @  (*)
  begin
    case (currentState21)

      // Commence21 PSO21 once21 the L121 req bit is set.
      Init21:
        if (L1_module_req21 == 1'b1)
          nextState21 = Clk_off21;         // Gate21 the module's clocks21 off21
        else
          nextState21 = Init21;            // Keep21 waiting21 in Init21 state
        
      Clk_off21 :
        nextState21 = Wait121;             // Wait21 for one cycle
 
      Wait121  :                         // Wait21 for clk21 gating21 to take21 effect
        nextState21 = Isolate21;           // Start21 the isolation21 process
          
      Isolate21 :
        nextState21 = Save_edge21;
        
      Save_edge21 :
        nextState21 = Pre_pwr_off21;

      Pre_pwr_off21 :
        nextState21 = Pwr_off21;
      // Exit21 PSO21 once21 the L121 req bit is clear.

      Pwr_off21 :
        if (L1_module_req21 == 1'b0)
          nextState21 = Pwr_on121;         // Resume21 power21 if the L1_module_req21 bit is cleared21
        else
          nextState21 = Pwr_off21;         // Wait21 until the L1_module_req21 bit is cleared21
        
      Pwr_on121 :
        nextState21 = Pwr_on221;
          
      Pwr_on221 :
        if(trans_cnt21 == 5'd28)
          nextState21 = Restore_edge21;
        else 
          nextState21 = Pwr_on221;
          
      Restore_edge21 :
        nextState21 = Wait221;

      Wait221 :
        nextState21 = De_isolate21;
          
      De_isolate21 :
        nextState21 = Clk_on21;
          
      Clk_on21 :
        nextState21 = Wait321;
          
      Wait321  :                         // Wait21 for clock21 to resume
        nextState21 = Rst_clr21 ;     
 
      Rst_clr21 :
        nextState21 = Init21;
        
      default  :                       // Catch21 all
        nextState21 = Init21; 
        
    endcase
  end


  // Signals21 Sequential21 process - gate_clk_module21
always @ (posedge pclk21 or negedge nprst21)
  begin
    if (~nprst21)
      gate_clk_module21 <= 1'b0;
    else 
      if (nextState21 == Clk_on21 | nextState21 == Wait321 | nextState21 == Rst_clr21 | 
          nextState21 == Init21)
          gate_clk_module21 <= 1'b0;
      else
          gate_clk_module21 <= 1'b1;
  end

// Signals21 Sequential21 process - rstn_non_srpg21
always @ (posedge pclk21 or negedge nprst21)
  begin
    if (~nprst21)
      rstn_non_srpg21 <= 1'b0;
    else
      if ( nextState21 == Init21 | nextState21 == Clk_off21 | nextState21 == Wait121 | 
           nextState21 == Isolate21 | nextState21 == Save_edge21 | nextState21 == Pre_pwr_off21 | nextState21 == Rst_clr21)
        rstn_non_srpg21 <= 1'b1;
      else
        rstn_non_srpg21 <= 1'b0;
   end


// Signals21 Sequential21 process - pwr1_on21 & pwr2_on21
always @ (posedge pclk21 or negedge nprst21)
  begin
    if (~nprst21)
      pwr1_on21 <=  1'b1;  // power21 gates21 1 & 2 are on
    else
      if (nextState21 == Pwr_off21 )
        pwr1_on21 <= 1'b0;  // shut21 off21 both power21 gates21 1 & 2
      else
        pwr1_on21 <= 1'b1;
  end


// Signals21 Sequential21 process - pwr1_on21 & pwr2_on21
always @ (posedge pclk21 or negedge nprst21)
  begin
    if (~nprst21)
       pwr2_on21 <= 1'b1;      // power21 gates21 1 & 2 are on
    else
      if (nextState21 == Pwr_off21 | nextState21 == Pwr_on121)
        pwr2_on21 <= 1'b0;     // shut21 off21 both power21 gates21 1 & 2
      else
        pwr2_on21 <= 1'b1;
   end


// Signals21 Sequential21 process - isolate_module21 
always @ (posedge pclk21 or negedge nprst21)
  begin
    if (~nprst21)
        isolate_module21 <= 1'b0;
    else
      if (nextState21 == Isolate21 | nextState21 == Save_edge21 | nextState21 == Pre_pwr_off21 |  nextState21 == Pwr_off21 | nextState21 == Pwr_on121 |
          nextState21 == Pwr_on221 | nextState21 == Restore_edge21 | nextState21 == Wait221)
         isolate_module21 <= 1'b1;       // Activate21 the isolate21 and retain21 signals21
      else
         isolate_module21 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk21 or negedge nprst21)
  begin
    if (~nprst21)
        save_edge21 <= 1'b0;
    else
      if (nextState21 == Save_edge21 )
         save_edge21 <= 1'b1;       // Activate21 the isolate21 and retain21 signals21
      else
         save_edge21 <= 1'b0;        
   end    
// stabilising21 count
wire restore_change21;
assign restore_change21 = (nextState21 == Pwr_on221) ? 1'b1: 1'b0;

always @ (posedge pclk21 or negedge nprst21)
  begin
    if (~nprst21)
      trans_cnt21 <= 0;
    else if (trans_cnt21 > 0)
      trans_cnt21  <= trans_cnt21 + 1;
    else if (restore_change21)
      trans_cnt21  <= trans_cnt21 + 1;
  end

// enabling restore21 edge
always @ (posedge pclk21 or negedge nprst21)
  begin
    if (~nprst21)
        restore_edge21 <= 1'b0;
    else
      if (nextState21 == Restore_edge21)
         restore_edge21 <= 1'b1;       // Activate21 the isolate21 and retain21 signals21
      else
         restore_edge21 <= 1'b0;        
   end    


// FSM21 Sequential21 process
always @ (posedge pclk21 or negedge nprst21)
  begin
    if (~nprst21)
      currentState21 <= Init21;
    else
      currentState21 <= nextState21;
  end


// Reset21 for non-SRPG21 FFs21 is a combination21 of the nprst21 and the reset during PSO21
assign  rstn_non_srpg_module21 = rstn_non_srpg21 & nprst21;

assign  set_status_module21 = (nextState21 == Clk_off21);    // Set the L121 status bit  
assign  clr_status_module21 = (currentState21 == Rst_clr21); // Clear the L121 status bit  
  

`ifdef LP_ABV_ON21

// psl21 default clock21 = (posedge pclk21);

// Never21 have the set and clear status signals21 both set
// psl21 output_no_set_and_clear21 : assert never {set_status_module21 & clr_status_module21};



// Isolate21 signal21 should become21 active on the 
// Next21 clock21 after Gate21 signal21 is activated21
// psl21 output_pd_seq21:
//    assert always
//	  {rose21(gate_clk_module21)} |=> {[*1]; {rose21(isolate_module21)} }
//    abort21(~nprst21);
//
//
//
// Reset21 signal21 for Non21-SRPG21 FFs21 and POWER21 signal21 for
// SMC21 should become21 LOW21 on clock21 cycle after Isolate21 
// signal21 is activated21
// psl21 output_pd_seq_stg_221:
//    assert always
//    {rose21(isolate_module21)} |=>
//    {[*2]; {{fell21(rstn_non_srpg_module21)} && {fell21(pwr1_on21)}} }
//    abort21(~nprst21);
//
//
// Whenever21 pwr1_on21 goes21 to LOW21 pwr2_on21 should also go21 to LOW21
// psl21 output_pwr2_low21:
//    assert always
//    { fell21(pwr1_on21) } |->  { fell21(pwr2_on21) }
//    abort21(~nprst21);
//
//
// Whenever21 pwr1_on21 becomes HIGH21 , On21 Next21 clock21 cycle pwr2_on21
// should also become21 HIGH21
// psl21 output_pwr2_high21:
//    assert always
//    { rose21(pwr1_on21) } |=>  { (pwr2_on21) }
//    abort21(~nprst21);
//
`endif


endmodule
