//File5 name   : ttc_timer_counter_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : An5 instantiation5 of counter modules5.
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module5 definition5
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite5(

   //inputs5
   n_p_reset5,    
   pclk5,                         
   pwdata5,                              
   clk_ctrl_reg_sel5,
   cntr_ctrl_reg_sel5,
   interval_reg_sel5, 
   match_1_reg_sel5,
   match_2_reg_sel5,
   match_3_reg_sel5,
   intr_en_reg_sel5,
   clear_interrupt5,
                 
   //outputs5             
   clk_ctrl_reg5, 
   counter_val_reg5,
   cntr_ctrl_reg5,
   interval_reg5,
   match_1_reg5,
   match_2_reg5,
   match_3_reg5,
   interrupt5,
   interrupt_reg5,
   interrupt_en_reg5
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS5
//-----------------------------------------------------------------------------

   //inputs5
   input         n_p_reset5;            //reset signal5
   input         pclk5;                 //APB5 system clock5
   input [15:0]  pwdata5;               //16 Bit5 data signal5
   input         clk_ctrl_reg_sel5;     //Select5 clk_ctrl_reg5 from prescaler5
   input         cntr_ctrl_reg_sel5;    //Select5 control5 reg from counter.
   input         interval_reg_sel5;     //Select5 Interval5 reg from counter.
   input         match_1_reg_sel5;      //Select5 match_1_reg5 from counter. 
   input         match_2_reg_sel5;      //Select5 match_2_reg5 from counter.
   input         match_3_reg_sel5;      //Select5 match_3_reg5 from counter.
   input         intr_en_reg_sel5;      //Select5 interrupt5 register.
   input         clear_interrupt5;      //Clear interrupt5
   
   //Outputs5
   output [15:0]  counter_val_reg5;     //Counter5 value register from counter. 
   output [6:0]   clk_ctrl_reg5;        //Clock5 control5 reg from prescaler5.
   output [6:0]   cntr_ctrl_reg5;     //Counter5 control5 register 1.
   output [15:0]  interval_reg5;        //Interval5 register from counter.
   output [15:0]  match_1_reg5;         //Match5 1 register sent5 from counter. 
   output [15:0]  match_2_reg5;         //Match5 2 register sent5 from counter. 
   output [15:0]  match_3_reg5;         //Match5 3 register sent5 from counter. 
   output         interrupt5;
   output [5:0]   interrupt_reg5;
   output [5:0]   interrupt_en_reg5;
   
//-----------------------------------------------------------------------------
// Module5 Interconnect5
//-----------------------------------------------------------------------------

   wire count_en5;
   wire interval_intr5;          //Interval5 overflow5 interrupt5
   wire [3:1] match_intr5;       //Match5 interrupts5
   wire overflow_intr5;          //Overflow5 interupt5   
   wire [6:0] cntr_ctrl_reg5;    //Counter5 control5 register
   
//-----------------------------------------------------------------------------
// Module5 Instantiations5
//-----------------------------------------------------------------------------


    //outputs5

  ttc_count_rst_lite5 i_ttc_count_rst_lite5(

    //inputs5
    .n_p_reset5                              (n_p_reset5),   
    .pclk5                                   (pclk5),                             
    .pwdata5                                 (pwdata5[6:0]),
    .clk_ctrl_reg_sel5                       (clk_ctrl_reg_sel5),
    .restart5                                (cntr_ctrl_reg5[4]),
                         
    //outputs5        
    .count_en_out5                           (count_en5),                         
    .clk_ctrl_reg_out5                       (clk_ctrl_reg5)

  );


  ttc_counter_lite5 i_ttc_counter_lite5(

    //inputs5
    .n_p_reset5                              (n_p_reset5),  
    .pclk5                                   (pclk5),                          
    .pwdata5                                 (pwdata5),                           
    .count_en5                               (count_en5),
    .cntr_ctrl_reg_sel5                      (cntr_ctrl_reg_sel5), 
    .interval_reg_sel5                       (interval_reg_sel5),
    .match_1_reg_sel5                        (match_1_reg_sel5),
    .match_2_reg_sel5                        (match_2_reg_sel5),
    .match_3_reg_sel5                        (match_3_reg_sel5),

    //outputs5
    .count_val_out5                          (counter_val_reg5),
    .cntr_ctrl_reg_out5                      (cntr_ctrl_reg5),
    .interval_reg_out5                       (interval_reg5),
    .match_1_reg_out5                        (match_1_reg5),
    .match_2_reg_out5                        (match_2_reg5),
    .match_3_reg_out5                        (match_3_reg5),
    .interval_intr5                          (interval_intr5),
    .match_intr5                             (match_intr5),
    .overflow_intr5                          (overflow_intr5)
    
  );

  ttc_interrupt_lite5 i_ttc_interrupt_lite5(

    //inputs5
    .n_p_reset5                           (n_p_reset5), 
    .pwdata5                              (pwdata5[5:0]),
    .pclk5                                (pclk5),
    .intr_en_reg_sel5                     (intr_en_reg_sel5), 
    .clear_interrupt5                     (clear_interrupt5),
    .interval_intr5                       (interval_intr5),
    .match_intr5                          (match_intr5),
    .overflow_intr5                       (overflow_intr5),
    .restart5                             (cntr_ctrl_reg5[4]),

    //outputs5
    .interrupt5                           (interrupt5),
    .interrupt_reg_out5                   (interrupt_reg5),
    .interrupt_en_out5                    (interrupt_en_reg5)
                       
  );


   
endmodule
