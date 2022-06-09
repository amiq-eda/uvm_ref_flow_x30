//File26 name   : ttc_timer_counter_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : An26 instantiation26 of counter modules26.
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module26 definition26
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite26(

   //inputs26
   n_p_reset26,    
   pclk26,                         
   pwdata26,                              
   clk_ctrl_reg_sel26,
   cntr_ctrl_reg_sel26,
   interval_reg_sel26, 
   match_1_reg_sel26,
   match_2_reg_sel26,
   match_3_reg_sel26,
   intr_en_reg_sel26,
   clear_interrupt26,
                 
   //outputs26             
   clk_ctrl_reg26, 
   counter_val_reg26,
   cntr_ctrl_reg26,
   interval_reg26,
   match_1_reg26,
   match_2_reg26,
   match_3_reg26,
   interrupt26,
   interrupt_reg26,
   interrupt_en_reg26
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS26
//-----------------------------------------------------------------------------

   //inputs26
   input         n_p_reset26;            //reset signal26
   input         pclk26;                 //APB26 system clock26
   input [15:0]  pwdata26;               //16 Bit26 data signal26
   input         clk_ctrl_reg_sel26;     //Select26 clk_ctrl_reg26 from prescaler26
   input         cntr_ctrl_reg_sel26;    //Select26 control26 reg from counter.
   input         interval_reg_sel26;     //Select26 Interval26 reg from counter.
   input         match_1_reg_sel26;      //Select26 match_1_reg26 from counter. 
   input         match_2_reg_sel26;      //Select26 match_2_reg26 from counter.
   input         match_3_reg_sel26;      //Select26 match_3_reg26 from counter.
   input         intr_en_reg_sel26;      //Select26 interrupt26 register.
   input         clear_interrupt26;      //Clear interrupt26
   
   //Outputs26
   output [15:0]  counter_val_reg26;     //Counter26 value register from counter. 
   output [6:0]   clk_ctrl_reg26;        //Clock26 control26 reg from prescaler26.
   output [6:0]   cntr_ctrl_reg26;     //Counter26 control26 register 1.
   output [15:0]  interval_reg26;        //Interval26 register from counter.
   output [15:0]  match_1_reg26;         //Match26 1 register sent26 from counter. 
   output [15:0]  match_2_reg26;         //Match26 2 register sent26 from counter. 
   output [15:0]  match_3_reg26;         //Match26 3 register sent26 from counter. 
   output         interrupt26;
   output [5:0]   interrupt_reg26;
   output [5:0]   interrupt_en_reg26;
   
//-----------------------------------------------------------------------------
// Module26 Interconnect26
//-----------------------------------------------------------------------------

   wire count_en26;
   wire interval_intr26;          //Interval26 overflow26 interrupt26
   wire [3:1] match_intr26;       //Match26 interrupts26
   wire overflow_intr26;          //Overflow26 interupt26   
   wire [6:0] cntr_ctrl_reg26;    //Counter26 control26 register
   
//-----------------------------------------------------------------------------
// Module26 Instantiations26
//-----------------------------------------------------------------------------


    //outputs26

  ttc_count_rst_lite26 i_ttc_count_rst_lite26(

    //inputs26
    .n_p_reset26                              (n_p_reset26),   
    .pclk26                                   (pclk26),                             
    .pwdata26                                 (pwdata26[6:0]),
    .clk_ctrl_reg_sel26                       (clk_ctrl_reg_sel26),
    .restart26                                (cntr_ctrl_reg26[4]),
                         
    //outputs26        
    .count_en_out26                           (count_en26),                         
    .clk_ctrl_reg_out26                       (clk_ctrl_reg26)

  );


  ttc_counter_lite26 i_ttc_counter_lite26(

    //inputs26
    .n_p_reset26                              (n_p_reset26),  
    .pclk26                                   (pclk26),                          
    .pwdata26                                 (pwdata26),                           
    .count_en26                               (count_en26),
    .cntr_ctrl_reg_sel26                      (cntr_ctrl_reg_sel26), 
    .interval_reg_sel26                       (interval_reg_sel26),
    .match_1_reg_sel26                        (match_1_reg_sel26),
    .match_2_reg_sel26                        (match_2_reg_sel26),
    .match_3_reg_sel26                        (match_3_reg_sel26),

    //outputs26
    .count_val_out26                          (counter_val_reg26),
    .cntr_ctrl_reg_out26                      (cntr_ctrl_reg26),
    .interval_reg_out26                       (interval_reg26),
    .match_1_reg_out26                        (match_1_reg26),
    .match_2_reg_out26                        (match_2_reg26),
    .match_3_reg_out26                        (match_3_reg26),
    .interval_intr26                          (interval_intr26),
    .match_intr26                             (match_intr26),
    .overflow_intr26                          (overflow_intr26)
    
  );

  ttc_interrupt_lite26 i_ttc_interrupt_lite26(

    //inputs26
    .n_p_reset26                           (n_p_reset26), 
    .pwdata26                              (pwdata26[5:0]),
    .pclk26                                (pclk26),
    .intr_en_reg_sel26                     (intr_en_reg_sel26), 
    .clear_interrupt26                     (clear_interrupt26),
    .interval_intr26                       (interval_intr26),
    .match_intr26                          (match_intr26),
    .overflow_intr26                       (overflow_intr26),
    .restart26                             (cntr_ctrl_reg26[4]),

    //outputs26
    .interrupt26                           (interrupt26),
    .interrupt_reg_out26                   (interrupt_reg26),
    .interrupt_en_out26                    (interrupt_en_reg26)
                       
  );


   
endmodule
