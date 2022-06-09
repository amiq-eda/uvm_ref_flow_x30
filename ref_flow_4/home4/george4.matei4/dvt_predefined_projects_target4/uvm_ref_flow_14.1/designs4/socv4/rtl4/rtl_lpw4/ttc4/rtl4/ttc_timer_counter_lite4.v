//File4 name   : ttc_timer_counter_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : An4 instantiation4 of counter modules4.
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module4 definition4
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite4(

   //inputs4
   n_p_reset4,    
   pclk4,                         
   pwdata4,                              
   clk_ctrl_reg_sel4,
   cntr_ctrl_reg_sel4,
   interval_reg_sel4, 
   match_1_reg_sel4,
   match_2_reg_sel4,
   match_3_reg_sel4,
   intr_en_reg_sel4,
   clear_interrupt4,
                 
   //outputs4             
   clk_ctrl_reg4, 
   counter_val_reg4,
   cntr_ctrl_reg4,
   interval_reg4,
   match_1_reg4,
   match_2_reg4,
   match_3_reg4,
   interrupt4,
   interrupt_reg4,
   interrupt_en_reg4
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS4
//-----------------------------------------------------------------------------

   //inputs4
   input         n_p_reset4;            //reset signal4
   input         pclk4;                 //APB4 system clock4
   input [15:0]  pwdata4;               //16 Bit4 data signal4
   input         clk_ctrl_reg_sel4;     //Select4 clk_ctrl_reg4 from prescaler4
   input         cntr_ctrl_reg_sel4;    //Select4 control4 reg from counter.
   input         interval_reg_sel4;     //Select4 Interval4 reg from counter.
   input         match_1_reg_sel4;      //Select4 match_1_reg4 from counter. 
   input         match_2_reg_sel4;      //Select4 match_2_reg4 from counter.
   input         match_3_reg_sel4;      //Select4 match_3_reg4 from counter.
   input         intr_en_reg_sel4;      //Select4 interrupt4 register.
   input         clear_interrupt4;      //Clear interrupt4
   
   //Outputs4
   output [15:0]  counter_val_reg4;     //Counter4 value register from counter. 
   output [6:0]   clk_ctrl_reg4;        //Clock4 control4 reg from prescaler4.
   output [6:0]   cntr_ctrl_reg4;     //Counter4 control4 register 1.
   output [15:0]  interval_reg4;        //Interval4 register from counter.
   output [15:0]  match_1_reg4;         //Match4 1 register sent4 from counter. 
   output [15:0]  match_2_reg4;         //Match4 2 register sent4 from counter. 
   output [15:0]  match_3_reg4;         //Match4 3 register sent4 from counter. 
   output         interrupt4;
   output [5:0]   interrupt_reg4;
   output [5:0]   interrupt_en_reg4;
   
//-----------------------------------------------------------------------------
// Module4 Interconnect4
//-----------------------------------------------------------------------------

   wire count_en4;
   wire interval_intr4;          //Interval4 overflow4 interrupt4
   wire [3:1] match_intr4;       //Match4 interrupts4
   wire overflow_intr4;          //Overflow4 interupt4   
   wire [6:0] cntr_ctrl_reg4;    //Counter4 control4 register
   
//-----------------------------------------------------------------------------
// Module4 Instantiations4
//-----------------------------------------------------------------------------


    //outputs4

  ttc_count_rst_lite4 i_ttc_count_rst_lite4(

    //inputs4
    .n_p_reset4                              (n_p_reset4),   
    .pclk4                                   (pclk4),                             
    .pwdata4                                 (pwdata4[6:0]),
    .clk_ctrl_reg_sel4                       (clk_ctrl_reg_sel4),
    .restart4                                (cntr_ctrl_reg4[4]),
                         
    //outputs4        
    .count_en_out4                           (count_en4),                         
    .clk_ctrl_reg_out4                       (clk_ctrl_reg4)

  );


  ttc_counter_lite4 i_ttc_counter_lite4(

    //inputs4
    .n_p_reset4                              (n_p_reset4),  
    .pclk4                                   (pclk4),                          
    .pwdata4                                 (pwdata4),                           
    .count_en4                               (count_en4),
    .cntr_ctrl_reg_sel4                      (cntr_ctrl_reg_sel4), 
    .interval_reg_sel4                       (interval_reg_sel4),
    .match_1_reg_sel4                        (match_1_reg_sel4),
    .match_2_reg_sel4                        (match_2_reg_sel4),
    .match_3_reg_sel4                        (match_3_reg_sel4),

    //outputs4
    .count_val_out4                          (counter_val_reg4),
    .cntr_ctrl_reg_out4                      (cntr_ctrl_reg4),
    .interval_reg_out4                       (interval_reg4),
    .match_1_reg_out4                        (match_1_reg4),
    .match_2_reg_out4                        (match_2_reg4),
    .match_3_reg_out4                        (match_3_reg4),
    .interval_intr4                          (interval_intr4),
    .match_intr4                             (match_intr4),
    .overflow_intr4                          (overflow_intr4)
    
  );

  ttc_interrupt_lite4 i_ttc_interrupt_lite4(

    //inputs4
    .n_p_reset4                           (n_p_reset4), 
    .pwdata4                              (pwdata4[5:0]),
    .pclk4                                (pclk4),
    .intr_en_reg_sel4                     (intr_en_reg_sel4), 
    .clear_interrupt4                     (clear_interrupt4),
    .interval_intr4                       (interval_intr4),
    .match_intr4                          (match_intr4),
    .overflow_intr4                       (overflow_intr4),
    .restart4                             (cntr_ctrl_reg4[4]),

    //outputs4
    .interrupt4                           (interrupt4),
    .interrupt_reg_out4                   (interrupt_reg4),
    .interrupt_en_out4                    (interrupt_en_reg4)
                       
  );


   
endmodule
