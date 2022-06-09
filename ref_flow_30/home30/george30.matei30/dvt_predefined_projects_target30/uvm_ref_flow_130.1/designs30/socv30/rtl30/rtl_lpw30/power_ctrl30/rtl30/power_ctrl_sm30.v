//File30 name   : power_ctrl_sm30.v
//Title30       : Power30 Controller30 state machine30
//Created30     : 1999
//Description30 : State30 machine30 of power30 controller30
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
module power_ctrl_sm30 (

    // Clocks30 & Reset30
    pclk30,
    nprst30,

    // Register Control30 inputs30
    L1_module_req30,
    set_status_module30,
    clr_status_module30,

    // Module30 control30 outputs30
    rstn_non_srpg_module30,
    gate_clk_module30,
    isolate_module30,
    save_edge30,
    restore_edge30,
    pwr1_on30,
    pwr2_on30

);

input    pclk30;
input    nprst30;

input    L1_module_req30;
output   set_status_module30;
output   clr_status_module30;
    
output   rstn_non_srpg_module30;
output   gate_clk_module30;
output   isolate_module30;
output   pwr1_on30;
output   pwr2_on30;
output save_edge30;
output restore_edge30;

wire    set_status_module30;
wire    clr_status_module30;

wire    rstn_non_srpg_module30;
reg     gate_clk_module30;
reg     isolate_module30;
reg     pwr1_on30;
reg     pwr2_on30;

reg save_edge30;

reg restore_edge30;
   
// FSM30 state
reg  [3:0] currentState30, nextState30;
reg     rstn_non_srpg30;
reg [4:0] trans_cnt30;

parameter Init30 = 0; 
parameter Clk_off30 = 1; 
parameter Wait130 = 2; 
parameter Isolate30 = 3; 
parameter Save_edge30 = 4; 
parameter Pre_pwr_off30 = 5; 
parameter Pwr_off30 = 6; 
parameter Pwr_on130 = 7; 
parameter Pwr_on230 = 8; 
parameter Restore_edge30 = 9; 
parameter Wait230 = 10; 
parameter De_isolate30 = 11; 
parameter Clk_on30 = 12; 
parameter Wait330 = 13; 
parameter Rst_clr30 = 14;


// Power30 Shut30 Off30 State30 Machine30

// FSM30 combinational30 process
always @  (*)
  begin
    case (currentState30)

      // Commence30 PSO30 once30 the L130 req bit is set.
      Init30:
        if (L1_module_req30 == 1'b1)
          nextState30 = Clk_off30;         // Gate30 the module's clocks30 off30
        else
          nextState30 = Init30;            // Keep30 waiting30 in Init30 state
        
      Clk_off30 :
        nextState30 = Wait130;             // Wait30 for one cycle
 
      Wait130  :                         // Wait30 for clk30 gating30 to take30 effect
        nextState30 = Isolate30;           // Start30 the isolation30 process
          
      Isolate30 :
        nextState30 = Save_edge30;
        
      Save_edge30 :
        nextState30 = Pre_pwr_off30;

      Pre_pwr_off30 :
        nextState30 = Pwr_off30;
      // Exit30 PSO30 once30 the L130 req bit is clear.

      Pwr_off30 :
        if (L1_module_req30 == 1'b0)
          nextState30 = Pwr_on130;         // Resume30 power30 if the L1_module_req30 bit is cleared30
        else
          nextState30 = Pwr_off30;         // Wait30 until the L1_module_req30 bit is cleared30
        
      Pwr_on130 :
        nextState30 = Pwr_on230;
          
      Pwr_on230 :
        if(trans_cnt30 == 5'd28)
          nextState30 = Restore_edge30;
        else 
          nextState30 = Pwr_on230;
          
      Restore_edge30 :
        nextState30 = Wait230;

      Wait230 :
        nextState30 = De_isolate30;
          
      De_isolate30 :
        nextState30 = Clk_on30;
          
      Clk_on30 :
        nextState30 = Wait330;
          
      Wait330  :                         // Wait30 for clock30 to resume
        nextState30 = Rst_clr30 ;     
 
      Rst_clr30 :
        nextState30 = Init30;
        
      default  :                       // Catch30 all
        nextState30 = Init30; 
        
    endcase
  end


  // Signals30 Sequential30 process - gate_clk_module30
always @ (posedge pclk30 or negedge nprst30)
  begin
    if (~nprst30)
      gate_clk_module30 <= 1'b0;
    else 
      if (nextState30 == Clk_on30 | nextState30 == Wait330 | nextState30 == Rst_clr30 | 
          nextState30 == Init30)
          gate_clk_module30 <= 1'b0;
      else
          gate_clk_module30 <= 1'b1;
  end

// Signals30 Sequential30 process - rstn_non_srpg30
always @ (posedge pclk30 or negedge nprst30)
  begin
    if (~nprst30)
      rstn_non_srpg30 <= 1'b0;
    else
      if ( nextState30 == Init30 | nextState30 == Clk_off30 | nextState30 == Wait130 | 
           nextState30 == Isolate30 | nextState30 == Save_edge30 | nextState30 == Pre_pwr_off30 | nextState30 == Rst_clr30)
        rstn_non_srpg30 <= 1'b1;
      else
        rstn_non_srpg30 <= 1'b0;
   end


// Signals30 Sequential30 process - pwr1_on30 & pwr2_on30
always @ (posedge pclk30 or negedge nprst30)
  begin
    if (~nprst30)
      pwr1_on30 <=  1'b1;  // power30 gates30 1 & 2 are on
    else
      if (nextState30 == Pwr_off30 )
        pwr1_on30 <= 1'b0;  // shut30 off30 both power30 gates30 1 & 2
      else
        pwr1_on30 <= 1'b1;
  end


// Signals30 Sequential30 process - pwr1_on30 & pwr2_on30
always @ (posedge pclk30 or negedge nprst30)
  begin
    if (~nprst30)
       pwr2_on30 <= 1'b1;      // power30 gates30 1 & 2 are on
    else
      if (nextState30 == Pwr_off30 | nextState30 == Pwr_on130)
        pwr2_on30 <= 1'b0;     // shut30 off30 both power30 gates30 1 & 2
      else
        pwr2_on30 <= 1'b1;
   end


// Signals30 Sequential30 process - isolate_module30 
always @ (posedge pclk30 or negedge nprst30)
  begin
    if (~nprst30)
        isolate_module30 <= 1'b0;
    else
      if (nextState30 == Isolate30 | nextState30 == Save_edge30 | nextState30 == Pre_pwr_off30 |  nextState30 == Pwr_off30 | nextState30 == Pwr_on130 |
          nextState30 == Pwr_on230 | nextState30 == Restore_edge30 | nextState30 == Wait230)
         isolate_module30 <= 1'b1;       // Activate30 the isolate30 and retain30 signals30
      else
         isolate_module30 <= 1'b0;        
   end    

// enabling save edge
always @ (posedge pclk30 or negedge nprst30)
  begin
    if (~nprst30)
        save_edge30 <= 1'b0;
    else
      if (nextState30 == Save_edge30 )
         save_edge30 <= 1'b1;       // Activate30 the isolate30 and retain30 signals30
      else
         save_edge30 <= 1'b0;        
   end    
// stabilising30 count
wire restore_change30;
assign restore_change30 = (nextState30 == Pwr_on230) ? 1'b1: 1'b0;

always @ (posedge pclk30 or negedge nprst30)
  begin
    if (~nprst30)
      trans_cnt30 <= 0;
    else if (trans_cnt30 > 0)
      trans_cnt30  <= trans_cnt30 + 1;
    else if (restore_change30)
      trans_cnt30  <= trans_cnt30 + 1;
  end

// enabling restore30 edge
always @ (posedge pclk30 or negedge nprst30)
  begin
    if (~nprst30)
        restore_edge30 <= 1'b0;
    else
      if (nextState30 == Restore_edge30)
         restore_edge30 <= 1'b1;       // Activate30 the isolate30 and retain30 signals30
      else
         restore_edge30 <= 1'b0;        
   end    


// FSM30 Sequential30 process
always @ (posedge pclk30 or negedge nprst30)
  begin
    if (~nprst30)
      currentState30 <= Init30;
    else
      currentState30 <= nextState30;
  end


// Reset30 for non-SRPG30 FFs30 is a combination30 of the nprst30 and the reset during PSO30
assign  rstn_non_srpg_module30 = rstn_non_srpg30 & nprst30;

assign  set_status_module30 = (nextState30 == Clk_off30);    // Set the L130 status bit  
assign  clr_status_module30 = (currentState30 == Rst_clr30); // Clear the L130 status bit  
  

`ifdef LP_ABV_ON30

// psl30 default clock30 = (posedge pclk30);

// Never30 have the set and clear status signals30 both set
// psl30 output_no_set_and_clear30 : assert never {set_status_module30 & clr_status_module30};



// Isolate30 signal30 should become30 active on the 
// Next30 clock30 after Gate30 signal30 is activated30
// psl30 output_pd_seq30:
//    assert always
//	  {rose30(gate_clk_module30)} |=> {[*1]; {rose30(isolate_module30)} }
//    abort30(~nprst30);
//
//
//
// Reset30 signal30 for Non30-SRPG30 FFs30 and POWER30 signal30 for
// SMC30 should become30 LOW30 on clock30 cycle after Isolate30 
// signal30 is activated30
// psl30 output_pd_seq_stg_230:
//    assert always
//    {rose30(isolate_module30)} |=>
//    {[*2]; {{fell30(rstn_non_srpg_module30)} && {fell30(pwr1_on30)}} }
//    abort30(~nprst30);
//
//
// Whenever30 pwr1_on30 goes30 to LOW30 pwr2_on30 should also go30 to LOW30
// psl30 output_pwr2_low30:
//    assert always
//    { fell30(pwr1_on30) } |->  { fell30(pwr2_on30) }
//    abort30(~nprst30);
//
//
// Whenever30 pwr1_on30 becomes HIGH30 , On30 Next30 clock30 cycle pwr2_on30
// should also become30 HIGH30
// psl30 output_pwr2_high30:
//    assert always
//    { rose30(pwr1_on30) } |=>  { (pwr2_on30) }
//    abort30(~nprst30);
//
`endif


endmodule
