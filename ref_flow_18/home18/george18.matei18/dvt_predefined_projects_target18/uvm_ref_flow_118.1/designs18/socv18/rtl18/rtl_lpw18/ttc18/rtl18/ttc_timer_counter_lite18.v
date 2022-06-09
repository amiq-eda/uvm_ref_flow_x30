//File18 name   : ttc_timer_counter_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : An18 instantiation18 of counter modules18.
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module18 definition18
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite18(

   //inputs18
   n_p_reset18,    
   pclk18,                         
   pwdata18,                              
   clk_ctrl_reg_sel18,
   cntr_ctrl_reg_sel18,
   interval_reg_sel18, 
   match_1_reg_sel18,
   match_2_reg_sel18,
   match_3_reg_sel18,
   intr_en_reg_sel18,
   clear_interrupt18,
                 
   //outputs18             
   clk_ctrl_reg18, 
   counter_val_reg18,
   cntr_ctrl_reg18,
   interval_reg18,
   match_1_reg18,
   match_2_reg18,
   match_3_reg18,
   interrupt18,
   interrupt_reg18,
   interrupt_en_reg18
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS18
//-----------------------------------------------------------------------------

   //inputs18
   input         n_p_reset18;            //reset signal18
   input         pclk18;                 //APB18 system clock18
   input [15:0]  pwdata18;               //16 Bit18 data signal18
   input         clk_ctrl_reg_sel18;     //Select18 clk_ctrl_reg18 from prescaler18
   input         cntr_ctrl_reg_sel18;    //Select18 control18 reg from counter.
   input         interval_reg_sel18;     //Select18 Interval18 reg from counter.
   input         match_1_reg_sel18;      //Select18 match_1_reg18 from counter. 
   input         match_2_reg_sel18;      //Select18 match_2_reg18 from counter.
   input         match_3_reg_sel18;      //Select18 match_3_reg18 from counter.
   input         intr_en_reg_sel18;      //Select18 interrupt18 register.
   input         clear_interrupt18;      //Clear interrupt18
   
   //Outputs18
   output [15:0]  counter_val_reg18;     //Counter18 value register from counter. 
   output [6:0]   clk_ctrl_reg18;        //Clock18 control18 reg from prescaler18.
   output [6:0]   cntr_ctrl_reg18;     //Counter18 control18 register 1.
   output [15:0]  interval_reg18;        //Interval18 register from counter.
   output [15:0]  match_1_reg18;         //Match18 1 register sent18 from counter. 
   output [15:0]  match_2_reg18;         //Match18 2 register sent18 from counter. 
   output [15:0]  match_3_reg18;         //Match18 3 register sent18 from counter. 
   output         interrupt18;
   output [5:0]   interrupt_reg18;
   output [5:0]   interrupt_en_reg18;
   
//-----------------------------------------------------------------------------
// Module18 Interconnect18
//-----------------------------------------------------------------------------

   wire count_en18;
   wire interval_intr18;          //Interval18 overflow18 interrupt18
   wire [3:1] match_intr18;       //Match18 interrupts18
   wire overflow_intr18;          //Overflow18 interupt18   
   wire [6:0] cntr_ctrl_reg18;    //Counter18 control18 register
   
//-----------------------------------------------------------------------------
// Module18 Instantiations18
//-----------------------------------------------------------------------------


    //outputs18

  ttc_count_rst_lite18 i_ttc_count_rst_lite18(

    //inputs18
    .n_p_reset18                              (n_p_reset18),   
    .pclk18                                   (pclk18),                             
    .pwdata18                                 (pwdata18[6:0]),
    .clk_ctrl_reg_sel18                       (clk_ctrl_reg_sel18),
    .restart18                                (cntr_ctrl_reg18[4]),
                         
    //outputs18        
    .count_en_out18                           (count_en18),                         
    .clk_ctrl_reg_out18                       (clk_ctrl_reg18)

  );


  ttc_counter_lite18 i_ttc_counter_lite18(

    //inputs18
    .n_p_reset18                              (n_p_reset18),  
    .pclk18                                   (pclk18),                          
    .pwdata18                                 (pwdata18),                           
    .count_en18                               (count_en18),
    .cntr_ctrl_reg_sel18                      (cntr_ctrl_reg_sel18), 
    .interval_reg_sel18                       (interval_reg_sel18),
    .match_1_reg_sel18                        (match_1_reg_sel18),
    .match_2_reg_sel18                        (match_2_reg_sel18),
    .match_3_reg_sel18                        (match_3_reg_sel18),

    //outputs18
    .count_val_out18                          (counter_val_reg18),
    .cntr_ctrl_reg_out18                      (cntr_ctrl_reg18),
    .interval_reg_out18                       (interval_reg18),
    .match_1_reg_out18                        (match_1_reg18),
    .match_2_reg_out18                        (match_2_reg18),
    .match_3_reg_out18                        (match_3_reg18),
    .interval_intr18                          (interval_intr18),
    .match_intr18                             (match_intr18),
    .overflow_intr18                          (overflow_intr18)
    
  );

  ttc_interrupt_lite18 i_ttc_interrupt_lite18(

    //inputs18
    .n_p_reset18                           (n_p_reset18), 
    .pwdata18                              (pwdata18[5:0]),
    .pclk18                                (pclk18),
    .intr_en_reg_sel18                     (intr_en_reg_sel18), 
    .clear_interrupt18                     (clear_interrupt18),
    .interval_intr18                       (interval_intr18),
    .match_intr18                          (match_intr18),
    .overflow_intr18                       (overflow_intr18),
    .restart18                             (cntr_ctrl_reg18[4]),

    //outputs18
    .interrupt18                           (interrupt18),
    .interrupt_reg_out18                   (interrupt_reg18),
    .interrupt_en_out18                    (interrupt_en_reg18)
                       
  );


   
endmodule
