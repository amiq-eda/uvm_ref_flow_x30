//File19 name   : ttc_timer_counter_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : An19 instantiation19 of counter modules19.
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module19 definition19
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite19(

   //inputs19
   n_p_reset19,    
   pclk19,                         
   pwdata19,                              
   clk_ctrl_reg_sel19,
   cntr_ctrl_reg_sel19,
   interval_reg_sel19, 
   match_1_reg_sel19,
   match_2_reg_sel19,
   match_3_reg_sel19,
   intr_en_reg_sel19,
   clear_interrupt19,
                 
   //outputs19             
   clk_ctrl_reg19, 
   counter_val_reg19,
   cntr_ctrl_reg19,
   interval_reg19,
   match_1_reg19,
   match_2_reg19,
   match_3_reg19,
   interrupt19,
   interrupt_reg19,
   interrupt_en_reg19
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS19
//-----------------------------------------------------------------------------

   //inputs19
   input         n_p_reset19;            //reset signal19
   input         pclk19;                 //APB19 system clock19
   input [15:0]  pwdata19;               //16 Bit19 data signal19
   input         clk_ctrl_reg_sel19;     //Select19 clk_ctrl_reg19 from prescaler19
   input         cntr_ctrl_reg_sel19;    //Select19 control19 reg from counter.
   input         interval_reg_sel19;     //Select19 Interval19 reg from counter.
   input         match_1_reg_sel19;      //Select19 match_1_reg19 from counter. 
   input         match_2_reg_sel19;      //Select19 match_2_reg19 from counter.
   input         match_3_reg_sel19;      //Select19 match_3_reg19 from counter.
   input         intr_en_reg_sel19;      //Select19 interrupt19 register.
   input         clear_interrupt19;      //Clear interrupt19
   
   //Outputs19
   output [15:0]  counter_val_reg19;     //Counter19 value register from counter. 
   output [6:0]   clk_ctrl_reg19;        //Clock19 control19 reg from prescaler19.
   output [6:0]   cntr_ctrl_reg19;     //Counter19 control19 register 1.
   output [15:0]  interval_reg19;        //Interval19 register from counter.
   output [15:0]  match_1_reg19;         //Match19 1 register sent19 from counter. 
   output [15:0]  match_2_reg19;         //Match19 2 register sent19 from counter. 
   output [15:0]  match_3_reg19;         //Match19 3 register sent19 from counter. 
   output         interrupt19;
   output [5:0]   interrupt_reg19;
   output [5:0]   interrupt_en_reg19;
   
//-----------------------------------------------------------------------------
// Module19 Interconnect19
//-----------------------------------------------------------------------------

   wire count_en19;
   wire interval_intr19;          //Interval19 overflow19 interrupt19
   wire [3:1] match_intr19;       //Match19 interrupts19
   wire overflow_intr19;          //Overflow19 interupt19   
   wire [6:0] cntr_ctrl_reg19;    //Counter19 control19 register
   
//-----------------------------------------------------------------------------
// Module19 Instantiations19
//-----------------------------------------------------------------------------


    //outputs19

  ttc_count_rst_lite19 i_ttc_count_rst_lite19(

    //inputs19
    .n_p_reset19                              (n_p_reset19),   
    .pclk19                                   (pclk19),                             
    .pwdata19                                 (pwdata19[6:0]),
    .clk_ctrl_reg_sel19                       (clk_ctrl_reg_sel19),
    .restart19                                (cntr_ctrl_reg19[4]),
                         
    //outputs19        
    .count_en_out19                           (count_en19),                         
    .clk_ctrl_reg_out19                       (clk_ctrl_reg19)

  );


  ttc_counter_lite19 i_ttc_counter_lite19(

    //inputs19
    .n_p_reset19                              (n_p_reset19),  
    .pclk19                                   (pclk19),                          
    .pwdata19                                 (pwdata19),                           
    .count_en19                               (count_en19),
    .cntr_ctrl_reg_sel19                      (cntr_ctrl_reg_sel19), 
    .interval_reg_sel19                       (interval_reg_sel19),
    .match_1_reg_sel19                        (match_1_reg_sel19),
    .match_2_reg_sel19                        (match_2_reg_sel19),
    .match_3_reg_sel19                        (match_3_reg_sel19),

    //outputs19
    .count_val_out19                          (counter_val_reg19),
    .cntr_ctrl_reg_out19                      (cntr_ctrl_reg19),
    .interval_reg_out19                       (interval_reg19),
    .match_1_reg_out19                        (match_1_reg19),
    .match_2_reg_out19                        (match_2_reg19),
    .match_3_reg_out19                        (match_3_reg19),
    .interval_intr19                          (interval_intr19),
    .match_intr19                             (match_intr19),
    .overflow_intr19                          (overflow_intr19)
    
  );

  ttc_interrupt_lite19 i_ttc_interrupt_lite19(

    //inputs19
    .n_p_reset19                           (n_p_reset19), 
    .pwdata19                              (pwdata19[5:0]),
    .pclk19                                (pclk19),
    .intr_en_reg_sel19                     (intr_en_reg_sel19), 
    .clear_interrupt19                     (clear_interrupt19),
    .interval_intr19                       (interval_intr19),
    .match_intr19                          (match_intr19),
    .overflow_intr19                       (overflow_intr19),
    .restart19                             (cntr_ctrl_reg19[4]),

    //outputs19
    .interrupt19                           (interrupt19),
    .interrupt_reg_out19                   (interrupt_reg19),
    .interrupt_en_out19                    (interrupt_en_reg19)
                       
  );


   
endmodule
