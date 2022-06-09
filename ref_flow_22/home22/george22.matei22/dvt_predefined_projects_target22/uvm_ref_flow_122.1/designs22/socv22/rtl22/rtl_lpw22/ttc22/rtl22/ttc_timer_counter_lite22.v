//File22 name   : ttc_timer_counter_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : An22 instantiation22 of counter modules22.
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module22 definition22
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite22(

   //inputs22
   n_p_reset22,    
   pclk22,                         
   pwdata22,                              
   clk_ctrl_reg_sel22,
   cntr_ctrl_reg_sel22,
   interval_reg_sel22, 
   match_1_reg_sel22,
   match_2_reg_sel22,
   match_3_reg_sel22,
   intr_en_reg_sel22,
   clear_interrupt22,
                 
   //outputs22             
   clk_ctrl_reg22, 
   counter_val_reg22,
   cntr_ctrl_reg22,
   interval_reg22,
   match_1_reg22,
   match_2_reg22,
   match_3_reg22,
   interrupt22,
   interrupt_reg22,
   interrupt_en_reg22
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS22
//-----------------------------------------------------------------------------

   //inputs22
   input         n_p_reset22;            //reset signal22
   input         pclk22;                 //APB22 system clock22
   input [15:0]  pwdata22;               //16 Bit22 data signal22
   input         clk_ctrl_reg_sel22;     //Select22 clk_ctrl_reg22 from prescaler22
   input         cntr_ctrl_reg_sel22;    //Select22 control22 reg from counter.
   input         interval_reg_sel22;     //Select22 Interval22 reg from counter.
   input         match_1_reg_sel22;      //Select22 match_1_reg22 from counter. 
   input         match_2_reg_sel22;      //Select22 match_2_reg22 from counter.
   input         match_3_reg_sel22;      //Select22 match_3_reg22 from counter.
   input         intr_en_reg_sel22;      //Select22 interrupt22 register.
   input         clear_interrupt22;      //Clear interrupt22
   
   //Outputs22
   output [15:0]  counter_val_reg22;     //Counter22 value register from counter. 
   output [6:0]   clk_ctrl_reg22;        //Clock22 control22 reg from prescaler22.
   output [6:0]   cntr_ctrl_reg22;     //Counter22 control22 register 1.
   output [15:0]  interval_reg22;        //Interval22 register from counter.
   output [15:0]  match_1_reg22;         //Match22 1 register sent22 from counter. 
   output [15:0]  match_2_reg22;         //Match22 2 register sent22 from counter. 
   output [15:0]  match_3_reg22;         //Match22 3 register sent22 from counter. 
   output         interrupt22;
   output [5:0]   interrupt_reg22;
   output [5:0]   interrupt_en_reg22;
   
//-----------------------------------------------------------------------------
// Module22 Interconnect22
//-----------------------------------------------------------------------------

   wire count_en22;
   wire interval_intr22;          //Interval22 overflow22 interrupt22
   wire [3:1] match_intr22;       //Match22 interrupts22
   wire overflow_intr22;          //Overflow22 interupt22   
   wire [6:0] cntr_ctrl_reg22;    //Counter22 control22 register
   
//-----------------------------------------------------------------------------
// Module22 Instantiations22
//-----------------------------------------------------------------------------


    //outputs22

  ttc_count_rst_lite22 i_ttc_count_rst_lite22(

    //inputs22
    .n_p_reset22                              (n_p_reset22),   
    .pclk22                                   (pclk22),                             
    .pwdata22                                 (pwdata22[6:0]),
    .clk_ctrl_reg_sel22                       (clk_ctrl_reg_sel22),
    .restart22                                (cntr_ctrl_reg22[4]),
                         
    //outputs22        
    .count_en_out22                           (count_en22),                         
    .clk_ctrl_reg_out22                       (clk_ctrl_reg22)

  );


  ttc_counter_lite22 i_ttc_counter_lite22(

    //inputs22
    .n_p_reset22                              (n_p_reset22),  
    .pclk22                                   (pclk22),                          
    .pwdata22                                 (pwdata22),                           
    .count_en22                               (count_en22),
    .cntr_ctrl_reg_sel22                      (cntr_ctrl_reg_sel22), 
    .interval_reg_sel22                       (interval_reg_sel22),
    .match_1_reg_sel22                        (match_1_reg_sel22),
    .match_2_reg_sel22                        (match_2_reg_sel22),
    .match_3_reg_sel22                        (match_3_reg_sel22),

    //outputs22
    .count_val_out22                          (counter_val_reg22),
    .cntr_ctrl_reg_out22                      (cntr_ctrl_reg22),
    .interval_reg_out22                       (interval_reg22),
    .match_1_reg_out22                        (match_1_reg22),
    .match_2_reg_out22                        (match_2_reg22),
    .match_3_reg_out22                        (match_3_reg22),
    .interval_intr22                          (interval_intr22),
    .match_intr22                             (match_intr22),
    .overflow_intr22                          (overflow_intr22)
    
  );

  ttc_interrupt_lite22 i_ttc_interrupt_lite22(

    //inputs22
    .n_p_reset22                           (n_p_reset22), 
    .pwdata22                              (pwdata22[5:0]),
    .pclk22                                (pclk22),
    .intr_en_reg_sel22                     (intr_en_reg_sel22), 
    .clear_interrupt22                     (clear_interrupt22),
    .interval_intr22                       (interval_intr22),
    .match_intr22                          (match_intr22),
    .overflow_intr22                       (overflow_intr22),
    .restart22                             (cntr_ctrl_reg22[4]),

    //outputs22
    .interrupt22                           (interrupt22),
    .interrupt_reg_out22                   (interrupt_reg22),
    .interrupt_en_out22                    (interrupt_en_reg22)
                       
  );


   
endmodule
