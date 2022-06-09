//File24 name   : ttc_timer_counter_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : An24 instantiation24 of counter modules24.
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module24 definition24
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite24(

   //inputs24
   n_p_reset24,    
   pclk24,                         
   pwdata24,                              
   clk_ctrl_reg_sel24,
   cntr_ctrl_reg_sel24,
   interval_reg_sel24, 
   match_1_reg_sel24,
   match_2_reg_sel24,
   match_3_reg_sel24,
   intr_en_reg_sel24,
   clear_interrupt24,
                 
   //outputs24             
   clk_ctrl_reg24, 
   counter_val_reg24,
   cntr_ctrl_reg24,
   interval_reg24,
   match_1_reg24,
   match_2_reg24,
   match_3_reg24,
   interrupt24,
   interrupt_reg24,
   interrupt_en_reg24
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS24
//-----------------------------------------------------------------------------

   //inputs24
   input         n_p_reset24;            //reset signal24
   input         pclk24;                 //APB24 system clock24
   input [15:0]  pwdata24;               //16 Bit24 data signal24
   input         clk_ctrl_reg_sel24;     //Select24 clk_ctrl_reg24 from prescaler24
   input         cntr_ctrl_reg_sel24;    //Select24 control24 reg from counter.
   input         interval_reg_sel24;     //Select24 Interval24 reg from counter.
   input         match_1_reg_sel24;      //Select24 match_1_reg24 from counter. 
   input         match_2_reg_sel24;      //Select24 match_2_reg24 from counter.
   input         match_3_reg_sel24;      //Select24 match_3_reg24 from counter.
   input         intr_en_reg_sel24;      //Select24 interrupt24 register.
   input         clear_interrupt24;      //Clear interrupt24
   
   //Outputs24
   output [15:0]  counter_val_reg24;     //Counter24 value register from counter. 
   output [6:0]   clk_ctrl_reg24;        //Clock24 control24 reg from prescaler24.
   output [6:0]   cntr_ctrl_reg24;     //Counter24 control24 register 1.
   output [15:0]  interval_reg24;        //Interval24 register from counter.
   output [15:0]  match_1_reg24;         //Match24 1 register sent24 from counter. 
   output [15:0]  match_2_reg24;         //Match24 2 register sent24 from counter. 
   output [15:0]  match_3_reg24;         //Match24 3 register sent24 from counter. 
   output         interrupt24;
   output [5:0]   interrupt_reg24;
   output [5:0]   interrupt_en_reg24;
   
//-----------------------------------------------------------------------------
// Module24 Interconnect24
//-----------------------------------------------------------------------------

   wire count_en24;
   wire interval_intr24;          //Interval24 overflow24 interrupt24
   wire [3:1] match_intr24;       //Match24 interrupts24
   wire overflow_intr24;          //Overflow24 interupt24   
   wire [6:0] cntr_ctrl_reg24;    //Counter24 control24 register
   
//-----------------------------------------------------------------------------
// Module24 Instantiations24
//-----------------------------------------------------------------------------


    //outputs24

  ttc_count_rst_lite24 i_ttc_count_rst_lite24(

    //inputs24
    .n_p_reset24                              (n_p_reset24),   
    .pclk24                                   (pclk24),                             
    .pwdata24                                 (pwdata24[6:0]),
    .clk_ctrl_reg_sel24                       (clk_ctrl_reg_sel24),
    .restart24                                (cntr_ctrl_reg24[4]),
                         
    //outputs24        
    .count_en_out24                           (count_en24),                         
    .clk_ctrl_reg_out24                       (clk_ctrl_reg24)

  );


  ttc_counter_lite24 i_ttc_counter_lite24(

    //inputs24
    .n_p_reset24                              (n_p_reset24),  
    .pclk24                                   (pclk24),                          
    .pwdata24                                 (pwdata24),                           
    .count_en24                               (count_en24),
    .cntr_ctrl_reg_sel24                      (cntr_ctrl_reg_sel24), 
    .interval_reg_sel24                       (interval_reg_sel24),
    .match_1_reg_sel24                        (match_1_reg_sel24),
    .match_2_reg_sel24                        (match_2_reg_sel24),
    .match_3_reg_sel24                        (match_3_reg_sel24),

    //outputs24
    .count_val_out24                          (counter_val_reg24),
    .cntr_ctrl_reg_out24                      (cntr_ctrl_reg24),
    .interval_reg_out24                       (interval_reg24),
    .match_1_reg_out24                        (match_1_reg24),
    .match_2_reg_out24                        (match_2_reg24),
    .match_3_reg_out24                        (match_3_reg24),
    .interval_intr24                          (interval_intr24),
    .match_intr24                             (match_intr24),
    .overflow_intr24                          (overflow_intr24)
    
  );

  ttc_interrupt_lite24 i_ttc_interrupt_lite24(

    //inputs24
    .n_p_reset24                           (n_p_reset24), 
    .pwdata24                              (pwdata24[5:0]),
    .pclk24                                (pclk24),
    .intr_en_reg_sel24                     (intr_en_reg_sel24), 
    .clear_interrupt24                     (clear_interrupt24),
    .interval_intr24                       (interval_intr24),
    .match_intr24                          (match_intr24),
    .overflow_intr24                       (overflow_intr24),
    .restart24                             (cntr_ctrl_reg24[4]),

    //outputs24
    .interrupt24                           (interrupt24),
    .interrupt_reg_out24                   (interrupt_reg24),
    .interrupt_en_out24                    (interrupt_en_reg24)
                       
  );


   
endmodule
