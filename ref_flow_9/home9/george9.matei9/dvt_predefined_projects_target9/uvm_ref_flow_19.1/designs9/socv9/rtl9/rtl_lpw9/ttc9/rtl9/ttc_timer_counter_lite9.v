//File9 name   : ttc_timer_counter_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : An9 instantiation9 of counter modules9.
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module9 definition9
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite9(

   //inputs9
   n_p_reset9,    
   pclk9,                         
   pwdata9,                              
   clk_ctrl_reg_sel9,
   cntr_ctrl_reg_sel9,
   interval_reg_sel9, 
   match_1_reg_sel9,
   match_2_reg_sel9,
   match_3_reg_sel9,
   intr_en_reg_sel9,
   clear_interrupt9,
                 
   //outputs9             
   clk_ctrl_reg9, 
   counter_val_reg9,
   cntr_ctrl_reg9,
   interval_reg9,
   match_1_reg9,
   match_2_reg9,
   match_3_reg9,
   interrupt9,
   interrupt_reg9,
   interrupt_en_reg9
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS9
//-----------------------------------------------------------------------------

   //inputs9
   input         n_p_reset9;            //reset signal9
   input         pclk9;                 //APB9 system clock9
   input [15:0]  pwdata9;               //16 Bit9 data signal9
   input         clk_ctrl_reg_sel9;     //Select9 clk_ctrl_reg9 from prescaler9
   input         cntr_ctrl_reg_sel9;    //Select9 control9 reg from counter.
   input         interval_reg_sel9;     //Select9 Interval9 reg from counter.
   input         match_1_reg_sel9;      //Select9 match_1_reg9 from counter. 
   input         match_2_reg_sel9;      //Select9 match_2_reg9 from counter.
   input         match_3_reg_sel9;      //Select9 match_3_reg9 from counter.
   input         intr_en_reg_sel9;      //Select9 interrupt9 register.
   input         clear_interrupt9;      //Clear interrupt9
   
   //Outputs9
   output [15:0]  counter_val_reg9;     //Counter9 value register from counter. 
   output [6:0]   clk_ctrl_reg9;        //Clock9 control9 reg from prescaler9.
   output [6:0]   cntr_ctrl_reg9;     //Counter9 control9 register 1.
   output [15:0]  interval_reg9;        //Interval9 register from counter.
   output [15:0]  match_1_reg9;         //Match9 1 register sent9 from counter. 
   output [15:0]  match_2_reg9;         //Match9 2 register sent9 from counter. 
   output [15:0]  match_3_reg9;         //Match9 3 register sent9 from counter. 
   output         interrupt9;
   output [5:0]   interrupt_reg9;
   output [5:0]   interrupt_en_reg9;
   
//-----------------------------------------------------------------------------
// Module9 Interconnect9
//-----------------------------------------------------------------------------

   wire count_en9;
   wire interval_intr9;          //Interval9 overflow9 interrupt9
   wire [3:1] match_intr9;       //Match9 interrupts9
   wire overflow_intr9;          //Overflow9 interupt9   
   wire [6:0] cntr_ctrl_reg9;    //Counter9 control9 register
   
//-----------------------------------------------------------------------------
// Module9 Instantiations9
//-----------------------------------------------------------------------------


    //outputs9

  ttc_count_rst_lite9 i_ttc_count_rst_lite9(

    //inputs9
    .n_p_reset9                              (n_p_reset9),   
    .pclk9                                   (pclk9),                             
    .pwdata9                                 (pwdata9[6:0]),
    .clk_ctrl_reg_sel9                       (clk_ctrl_reg_sel9),
    .restart9                                (cntr_ctrl_reg9[4]),
                         
    //outputs9        
    .count_en_out9                           (count_en9),                         
    .clk_ctrl_reg_out9                       (clk_ctrl_reg9)

  );


  ttc_counter_lite9 i_ttc_counter_lite9(

    //inputs9
    .n_p_reset9                              (n_p_reset9),  
    .pclk9                                   (pclk9),                          
    .pwdata9                                 (pwdata9),                           
    .count_en9                               (count_en9),
    .cntr_ctrl_reg_sel9                      (cntr_ctrl_reg_sel9), 
    .interval_reg_sel9                       (interval_reg_sel9),
    .match_1_reg_sel9                        (match_1_reg_sel9),
    .match_2_reg_sel9                        (match_2_reg_sel9),
    .match_3_reg_sel9                        (match_3_reg_sel9),

    //outputs9
    .count_val_out9                          (counter_val_reg9),
    .cntr_ctrl_reg_out9                      (cntr_ctrl_reg9),
    .interval_reg_out9                       (interval_reg9),
    .match_1_reg_out9                        (match_1_reg9),
    .match_2_reg_out9                        (match_2_reg9),
    .match_3_reg_out9                        (match_3_reg9),
    .interval_intr9                          (interval_intr9),
    .match_intr9                             (match_intr9),
    .overflow_intr9                          (overflow_intr9)
    
  );

  ttc_interrupt_lite9 i_ttc_interrupt_lite9(

    //inputs9
    .n_p_reset9                           (n_p_reset9), 
    .pwdata9                              (pwdata9[5:0]),
    .pclk9                                (pclk9),
    .intr_en_reg_sel9                     (intr_en_reg_sel9), 
    .clear_interrupt9                     (clear_interrupt9),
    .interval_intr9                       (interval_intr9),
    .match_intr9                          (match_intr9),
    .overflow_intr9                       (overflow_intr9),
    .restart9                             (cntr_ctrl_reg9[4]),

    //outputs9
    .interrupt9                           (interrupt9),
    .interrupt_reg_out9                   (interrupt_reg9),
    .interrupt_en_out9                    (interrupt_en_reg9)
                       
  );


   
endmodule
