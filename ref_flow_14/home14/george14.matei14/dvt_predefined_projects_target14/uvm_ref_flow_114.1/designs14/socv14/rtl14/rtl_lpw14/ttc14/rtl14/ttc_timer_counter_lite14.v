//File14 name   : ttc_timer_counter_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : An14 instantiation14 of counter modules14.
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module14 definition14
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite14(

   //inputs14
   n_p_reset14,    
   pclk14,                         
   pwdata14,                              
   clk_ctrl_reg_sel14,
   cntr_ctrl_reg_sel14,
   interval_reg_sel14, 
   match_1_reg_sel14,
   match_2_reg_sel14,
   match_3_reg_sel14,
   intr_en_reg_sel14,
   clear_interrupt14,
                 
   //outputs14             
   clk_ctrl_reg14, 
   counter_val_reg14,
   cntr_ctrl_reg14,
   interval_reg14,
   match_1_reg14,
   match_2_reg14,
   match_3_reg14,
   interrupt14,
   interrupt_reg14,
   interrupt_en_reg14
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS14
//-----------------------------------------------------------------------------

   //inputs14
   input         n_p_reset14;            //reset signal14
   input         pclk14;                 //APB14 system clock14
   input [15:0]  pwdata14;               //16 Bit14 data signal14
   input         clk_ctrl_reg_sel14;     //Select14 clk_ctrl_reg14 from prescaler14
   input         cntr_ctrl_reg_sel14;    //Select14 control14 reg from counter.
   input         interval_reg_sel14;     //Select14 Interval14 reg from counter.
   input         match_1_reg_sel14;      //Select14 match_1_reg14 from counter. 
   input         match_2_reg_sel14;      //Select14 match_2_reg14 from counter.
   input         match_3_reg_sel14;      //Select14 match_3_reg14 from counter.
   input         intr_en_reg_sel14;      //Select14 interrupt14 register.
   input         clear_interrupt14;      //Clear interrupt14
   
   //Outputs14
   output [15:0]  counter_val_reg14;     //Counter14 value register from counter. 
   output [6:0]   clk_ctrl_reg14;        //Clock14 control14 reg from prescaler14.
   output [6:0]   cntr_ctrl_reg14;     //Counter14 control14 register 1.
   output [15:0]  interval_reg14;        //Interval14 register from counter.
   output [15:0]  match_1_reg14;         //Match14 1 register sent14 from counter. 
   output [15:0]  match_2_reg14;         //Match14 2 register sent14 from counter. 
   output [15:0]  match_3_reg14;         //Match14 3 register sent14 from counter. 
   output         interrupt14;
   output [5:0]   interrupt_reg14;
   output [5:0]   interrupt_en_reg14;
   
//-----------------------------------------------------------------------------
// Module14 Interconnect14
//-----------------------------------------------------------------------------

   wire count_en14;
   wire interval_intr14;          //Interval14 overflow14 interrupt14
   wire [3:1] match_intr14;       //Match14 interrupts14
   wire overflow_intr14;          //Overflow14 interupt14   
   wire [6:0] cntr_ctrl_reg14;    //Counter14 control14 register
   
//-----------------------------------------------------------------------------
// Module14 Instantiations14
//-----------------------------------------------------------------------------


    //outputs14

  ttc_count_rst_lite14 i_ttc_count_rst_lite14(

    //inputs14
    .n_p_reset14                              (n_p_reset14),   
    .pclk14                                   (pclk14),                             
    .pwdata14                                 (pwdata14[6:0]),
    .clk_ctrl_reg_sel14                       (clk_ctrl_reg_sel14),
    .restart14                                (cntr_ctrl_reg14[4]),
                         
    //outputs14        
    .count_en_out14                           (count_en14),                         
    .clk_ctrl_reg_out14                       (clk_ctrl_reg14)

  );


  ttc_counter_lite14 i_ttc_counter_lite14(

    //inputs14
    .n_p_reset14                              (n_p_reset14),  
    .pclk14                                   (pclk14),                          
    .pwdata14                                 (pwdata14),                           
    .count_en14                               (count_en14),
    .cntr_ctrl_reg_sel14                      (cntr_ctrl_reg_sel14), 
    .interval_reg_sel14                       (interval_reg_sel14),
    .match_1_reg_sel14                        (match_1_reg_sel14),
    .match_2_reg_sel14                        (match_2_reg_sel14),
    .match_3_reg_sel14                        (match_3_reg_sel14),

    //outputs14
    .count_val_out14                          (counter_val_reg14),
    .cntr_ctrl_reg_out14                      (cntr_ctrl_reg14),
    .interval_reg_out14                       (interval_reg14),
    .match_1_reg_out14                        (match_1_reg14),
    .match_2_reg_out14                        (match_2_reg14),
    .match_3_reg_out14                        (match_3_reg14),
    .interval_intr14                          (interval_intr14),
    .match_intr14                             (match_intr14),
    .overflow_intr14                          (overflow_intr14)
    
  );

  ttc_interrupt_lite14 i_ttc_interrupt_lite14(

    //inputs14
    .n_p_reset14                           (n_p_reset14), 
    .pwdata14                              (pwdata14[5:0]),
    .pclk14                                (pclk14),
    .intr_en_reg_sel14                     (intr_en_reg_sel14), 
    .clear_interrupt14                     (clear_interrupt14),
    .interval_intr14                       (interval_intr14),
    .match_intr14                          (match_intr14),
    .overflow_intr14                       (overflow_intr14),
    .restart14                             (cntr_ctrl_reg14[4]),

    //outputs14
    .interrupt14                           (interrupt14),
    .interrupt_reg_out14                   (interrupt_reg14),
    .interrupt_en_out14                    (interrupt_en_reg14)
                       
  );


   
endmodule
