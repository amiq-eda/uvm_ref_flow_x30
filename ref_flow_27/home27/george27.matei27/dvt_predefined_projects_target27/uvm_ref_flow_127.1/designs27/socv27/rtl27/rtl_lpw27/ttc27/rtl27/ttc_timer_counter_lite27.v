//File27 name   : ttc_timer_counter_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : An27 instantiation27 of counter modules27.
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module27 definition27
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite27(

   //inputs27
   n_p_reset27,    
   pclk27,                         
   pwdata27,                              
   clk_ctrl_reg_sel27,
   cntr_ctrl_reg_sel27,
   interval_reg_sel27, 
   match_1_reg_sel27,
   match_2_reg_sel27,
   match_3_reg_sel27,
   intr_en_reg_sel27,
   clear_interrupt27,
                 
   //outputs27             
   clk_ctrl_reg27, 
   counter_val_reg27,
   cntr_ctrl_reg27,
   interval_reg27,
   match_1_reg27,
   match_2_reg27,
   match_3_reg27,
   interrupt27,
   interrupt_reg27,
   interrupt_en_reg27
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS27
//-----------------------------------------------------------------------------

   //inputs27
   input         n_p_reset27;            //reset signal27
   input         pclk27;                 //APB27 system clock27
   input [15:0]  pwdata27;               //16 Bit27 data signal27
   input         clk_ctrl_reg_sel27;     //Select27 clk_ctrl_reg27 from prescaler27
   input         cntr_ctrl_reg_sel27;    //Select27 control27 reg from counter.
   input         interval_reg_sel27;     //Select27 Interval27 reg from counter.
   input         match_1_reg_sel27;      //Select27 match_1_reg27 from counter. 
   input         match_2_reg_sel27;      //Select27 match_2_reg27 from counter.
   input         match_3_reg_sel27;      //Select27 match_3_reg27 from counter.
   input         intr_en_reg_sel27;      //Select27 interrupt27 register.
   input         clear_interrupt27;      //Clear interrupt27
   
   //Outputs27
   output [15:0]  counter_val_reg27;     //Counter27 value register from counter. 
   output [6:0]   clk_ctrl_reg27;        //Clock27 control27 reg from prescaler27.
   output [6:0]   cntr_ctrl_reg27;     //Counter27 control27 register 1.
   output [15:0]  interval_reg27;        //Interval27 register from counter.
   output [15:0]  match_1_reg27;         //Match27 1 register sent27 from counter. 
   output [15:0]  match_2_reg27;         //Match27 2 register sent27 from counter. 
   output [15:0]  match_3_reg27;         //Match27 3 register sent27 from counter. 
   output         interrupt27;
   output [5:0]   interrupt_reg27;
   output [5:0]   interrupt_en_reg27;
   
//-----------------------------------------------------------------------------
// Module27 Interconnect27
//-----------------------------------------------------------------------------

   wire count_en27;
   wire interval_intr27;          //Interval27 overflow27 interrupt27
   wire [3:1] match_intr27;       //Match27 interrupts27
   wire overflow_intr27;          //Overflow27 interupt27   
   wire [6:0] cntr_ctrl_reg27;    //Counter27 control27 register
   
//-----------------------------------------------------------------------------
// Module27 Instantiations27
//-----------------------------------------------------------------------------


    //outputs27

  ttc_count_rst_lite27 i_ttc_count_rst_lite27(

    //inputs27
    .n_p_reset27                              (n_p_reset27),   
    .pclk27                                   (pclk27),                             
    .pwdata27                                 (pwdata27[6:0]),
    .clk_ctrl_reg_sel27                       (clk_ctrl_reg_sel27),
    .restart27                                (cntr_ctrl_reg27[4]),
                         
    //outputs27        
    .count_en_out27                           (count_en27),                         
    .clk_ctrl_reg_out27                       (clk_ctrl_reg27)

  );


  ttc_counter_lite27 i_ttc_counter_lite27(

    //inputs27
    .n_p_reset27                              (n_p_reset27),  
    .pclk27                                   (pclk27),                          
    .pwdata27                                 (pwdata27),                           
    .count_en27                               (count_en27),
    .cntr_ctrl_reg_sel27                      (cntr_ctrl_reg_sel27), 
    .interval_reg_sel27                       (interval_reg_sel27),
    .match_1_reg_sel27                        (match_1_reg_sel27),
    .match_2_reg_sel27                        (match_2_reg_sel27),
    .match_3_reg_sel27                        (match_3_reg_sel27),

    //outputs27
    .count_val_out27                          (counter_val_reg27),
    .cntr_ctrl_reg_out27                      (cntr_ctrl_reg27),
    .interval_reg_out27                       (interval_reg27),
    .match_1_reg_out27                        (match_1_reg27),
    .match_2_reg_out27                        (match_2_reg27),
    .match_3_reg_out27                        (match_3_reg27),
    .interval_intr27                          (interval_intr27),
    .match_intr27                             (match_intr27),
    .overflow_intr27                          (overflow_intr27)
    
  );

  ttc_interrupt_lite27 i_ttc_interrupt_lite27(

    //inputs27
    .n_p_reset27                           (n_p_reset27), 
    .pwdata27                              (pwdata27[5:0]),
    .pclk27                                (pclk27),
    .intr_en_reg_sel27                     (intr_en_reg_sel27), 
    .clear_interrupt27                     (clear_interrupt27),
    .interval_intr27                       (interval_intr27),
    .match_intr27                          (match_intr27),
    .overflow_intr27                       (overflow_intr27),
    .restart27                             (cntr_ctrl_reg27[4]),

    //outputs27
    .interrupt27                           (interrupt27),
    .interrupt_reg_out27                   (interrupt_reg27),
    .interrupt_en_out27                    (interrupt_en_reg27)
                       
  );


   
endmodule
