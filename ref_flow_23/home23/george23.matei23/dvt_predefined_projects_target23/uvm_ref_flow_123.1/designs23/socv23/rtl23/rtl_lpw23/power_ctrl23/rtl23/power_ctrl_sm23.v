//File23 name   : power_ctrl_sm23.v
//Title23       : Power23 Controller23 state machine23
//Created23     : 1999
//Description23 : State23 machine23 of power23 controller23
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
module power_ctrl_sm23 (

    // Clocks23 & Reset23
    pclk23,
    nprst23,

    // Register Control23 inputs23
    L1_module_req23,
    set_status_module23,
    clr_status_module23,

    // Module23 control23 outputs23
    rstn_non_srpg_module23,
    gate_clk_module23,
    isolate_module23,
    save_edge23,
    restore_edge23,
    pwr1_on23,
    pwr2_on23

);

input    pclk23;
input    nprst23;

input    L1_module_req23;
output   set_status_module23;
output   clr_status_module23;
    
output   rstn_non_srpg_module23;
output   gate_clk_module23;
output   isolate_module23;
output   pwr1_on23;
output   pwr2_on23;
output save_edge23;
output restore_edge23;

wire    set_status_module23;
wire    clr_status_module23;

wire    rstn_non_srpg_module23;
reg     gate_clk_module23;
reg     isolate_module23;
reg     pwr1_on23;
reg     pwr2_on23;

reg save_edge23;

reg restore_edge23;
   
// FSM23 state
reg  [3:0] currentState23, nextState23;
reg     rstn_non_srpg23;
reg [4:0] trans_cnt23;

parameter Init23 = 0; 
parameter Clk_off23 = 1; 
parameter Wait123 = 2; 
parameter Isolate23 = 3; 
parameter Save_edge23 = 4; 
parameter Pre_pwr_off23 = 5; 
parameter Pwr_off23 = 6; 
parameter Pwr_on123 = 7; 
parameter Pwr_on223 = 8; 
parameter Restore_edge23 = 9; 
parameter Wait223 = 10; 
parameter De_isolate23 = 11; 
parameter Clk_on23 = 12; 
parameter Wait323 = 13; 
parameter Rst_clr23 = 14;


// Power23 Shut23 Off23 State23 Machine23

// FSM23 combinational23 process
always @  (*)
  begin
    case (currentState23)

      // Commence23 PSO23 once23 the L123 req bit is set.
      Init23:
        if (L1_module_req23 == 1'b1)
          nextState23 = Clk_off23;         // Gate23 the module's clocks23 off23
        else
          nextState23 = Init23;            // Keep23 waiting23 in Init23 state
        
      Clk_off23 :
        nextState23 = Wait123;             // Wait23 for one cycle
 
      Wait123  :                         // Wait23 for clk23 gating23 to take23 effect
        nextState23 = Isolate23;           // Start23 the isolation23 process
          
      Isolate23 :
        nextState23 = Save_edge23;
        
      Save_edge23 :
        nextState23 = Pre_pwr_off23;

      Pre_pwr_off23 :
        nextState23 = Pwr_off23;
      // Exit23 PSO23 once23 the L123 req bit is clear.

      Pwr_off23 :
        if (L1_module_req23 == 1'b0)
          nextState23 = Pwr_on123;         // Resume23 power23 if the L1_module_req23 bit is cleared23
        else
          nextState23 = Pwr_off23;         // Wait23 until the L1_module_req23 bit is cleared23
        
      Pwr_on123 :
        nextState23 = Pwr_on223;
          
      Pwr_on223 :
        if(trans_cnt23 == 5'd28)
          nextState23 = Restore_edge23;
        else 
          nextState23 = Pwr_on223;
          
      Restore_edge23 :
        nextState23 = Wait223;

      Wait223 :
        nextState23 = De_isolate23;
          
      De_isolate23 :
        nextState23 = Clk_on23;
          
      Clk_on23 :
        nextState23 = Wait323;
          
      Wait323  :                         // Wait23 for clock23 to resume
        nextState23 = Rst_clr23 ;     
 
      Rst_clr23 :
        nextState23 = Init23;
        
      default  :                       // Catch23 all
        nextState23 = Init23; 
        
    endcase
  end


  // Signals23 Sequential23 process - gate_clk_module23
always @ (posedge pclk23 or negedge nprst23)
  begin
    if (~nprst23)
      gate_clk_module23 <= 1'b0;
    else 
      if (nextState23 == Clk_on23 | nextState23 == Wait323 | nextState23 == Rst_clr23 | 
          nextState23 == Init23)
          gate_clk_module23 <= 1'b0;
      else
          gate_clk_module23 <= 1'b1;
  end

// Signals23 Sequential23 process - rstn_non_srpg23
always @ (posedge pclk23 or negedge nprst23)
  begin
    if (~nprst23)
      rstn_non_srpg23 <= 1'b0;
    else
      if ( nextState23 == Init23 | nextState23 == Clk_off23 | nextState23 == Wait123 | 
           nextState23 == Isolate23 | nextState23 == Save_edge23 | nextState23 == Pre_pwr_off23 | nextState23 == Rst_clr23)
        rstn_non_srpg23 <= 1'b1;
      else
        rstn_non_srpg23 <= 1'b0;
   end


// Signals23 Sequential23 process - pwr1_on23 & pwr2_on23
always @ (posedge pclk23 or negedge nprst23)
  begin
    if (~nprst23)
      pwr1_on23 <=  1'b1;  // power23 gates23 1 & 2 are on
    else
      if (nextState23 == Pwr_off23 )
        pwr1_on23 <= 1'b0;  // shut23 off23 both power23 gates23 1 & 2
      else
        pwr1_on23 <= 1'b1;
  end


// Signals23 Sequential23 process - pwr1_on23 & pwr2_on23
always @ (posedge pclk23 or negedge nprst23)
  begin
    if (~nprst23)
       pwr2_on23 <= 1'b1;      // power23 gates23 1 & 2 are on
    else
      if (nextState23 == Pwr_off23 | nextState23 == Pwr_on123)
        pwr2_on23 <= 1'b0;     // shut23 off23 both power23 gates23 1 & 2
      else
        pwr2_on23 <= 1'b1;
   end


// Signals23 Sequential23 process - isolate_module23 
always @ (posedge pclk23 or negedge nprst23)
  begin
    if (~nprst23)
        isolate_module23 <= 1'b0;
    else
      if (nextState23 == Isolate23 | nextState23 == Save_edge23 | nextState23 == Pre_pwr_off23 |  nextState23 == Pwr_off23 | nextState23 == Pwr_on123 |
          nextState23 == Pwr_on223 | nextState23 == Restore_edge23 | nextState23 == Wait223)
         isolate_module23 <= 1'b1;       // Activate23 the isolate23 and retain23 signals23
      else
         isolate_module23 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk23 or negedge nprst23)
  begin
    if (~nprst23)
        save_edge23 <= 1'b0;
    else
      if (nextState23 == Save_edge23 )
         save_edge23 <= 1'b1;       // Activate23 the isolate23 and retain23 signals23
      else
         save_edge23 <= 1'b0;        
   end    
// stabilising23 count
wire restore_change23;
assign restore_change23 = (nextState23 == Pwr_on223) ? 1'b1: 1'b0;

always @ (posedge pclk23 or negedge nprst23)
  begin
    if (~nprst23)
      trans_cnt23 <= 0;
    else if (trans_cnt23 > 0)
      trans_cnt23  <= trans_cnt23 + 1;
    else if (restore_change23)
      trans_cnt23  <= trans_cnt23 + 1;
  end

// enabling restore23 edge
always @ (posedge pclk23 or negedge nprst23)
  begin
    if (~nprst23)
        restore_edge23 <= 1'b0;
    else
      if (nextState23 == Restore_edge23)
         restore_edge23 <= 1'b1;       // Activate23 the isolate23 and retain23 signals23
      else
         restore_edge23 <= 1'b0;        
   end    


// FSM23 Sequential23 process
always @ (posedge pclk23 or negedge nprst23)
  begin
    if (~nprst23)
      currentState23 <= Init23;
    else
      currentState23 <= nextState23;
  end


// Reset23 for non-SRPG23 FFs23 is a combination23 of the nprst23 and the reset during PSO23
assign  rstn_non_srpg_module23 = rstn_non_srpg23 & nprst23;

assign  set_status_module23 = (nextState23 == Clk_off23);    // Set the L123 status bit  
assign  clr_status_module23 = (currentState23 == Rst_clr23); // Clear the L123 status bit  
  

`ifdef LP_ABV_ON23

// psl23 default clock23 = (posedge pclk23);

// Never23 have the set and clear status signals23 both set
// psl23 output_no_set_and_clear23 : assert never {set_status_module23 & clr_status_module23};



// Isolate23 signal23 should become23 active on the 
// Next23 clock23 after Gate23 signal23 is activated23
// psl23 output_pd_seq23:
//    assert always
//	  {rose23(gate_clk_module23)} |=> {[*1]; {rose23(isolate_module23)} }
//    abort23(~nprst23);
//
//
//
// Reset23 signal23 for Non23-SRPG23 FFs23 and POWER23 signal23 for
// SMC23 should become23 LOW23 on clock23 cycle after Isolate23 
// signal23 is activated23
// psl23 output_pd_seq_stg_223:
//    assert always
//    {rose23(isolate_module23)} |=>
//    {[*2]; {{fell23(rstn_non_srpg_module23)} && {fell23(pwr1_on23)}} }
//    abort23(~nprst23);
//
//
// Whenever23 pwr1_on23 goes23 to LOW23 pwr2_on23 should also go23 to LOW23
// psl23 output_pwr2_low23:
//    assert always
//    { fell23(pwr1_on23) } |->  { fell23(pwr2_on23) }
//    abort23(~nprst23);
//
//
// Whenever23 pwr1_on23 becomes HIGH23 , On23 Next23 clock23 cycle pwr2_on23
// should also become23 HIGH23
// psl23 output_pwr2_high23:
//    assert always
//    { rose23(pwr1_on23) } |=>  { (pwr2_on23) }
//    abort23(~nprst23);
//
`endif


endmodule
