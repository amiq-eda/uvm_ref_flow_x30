//File6 name   : ttc_timer_counter_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : An6 instantiation6 of counter modules6.
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module6 definition6
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite6(

   //inputs6
   n_p_reset6,    
   pclk6,                         
   pwdata6,                              
   clk_ctrl_reg_sel6,
   cntr_ctrl_reg_sel6,
   interval_reg_sel6, 
   match_1_reg_sel6,
   match_2_reg_sel6,
   match_3_reg_sel6,
   intr_en_reg_sel6,
   clear_interrupt6,
                 
   //outputs6             
   clk_ctrl_reg6, 
   counter_val_reg6,
   cntr_ctrl_reg6,
   interval_reg6,
   match_1_reg6,
   match_2_reg6,
   match_3_reg6,
   interrupt6,
   interrupt_reg6,
   interrupt_en_reg6
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS6
//-----------------------------------------------------------------------------

   //inputs6
   input         n_p_reset6;            //reset signal6
   input         pclk6;                 //APB6 system clock6
   input [15:0]  pwdata6;               //16 Bit6 data signal6
   input         clk_ctrl_reg_sel6;     //Select6 clk_ctrl_reg6 from prescaler6
   input         cntr_ctrl_reg_sel6;    //Select6 control6 reg from counter.
   input         interval_reg_sel6;     //Select6 Interval6 reg from counter.
   input         match_1_reg_sel6;      //Select6 match_1_reg6 from counter. 
   input         match_2_reg_sel6;      //Select6 match_2_reg6 from counter.
   input         match_3_reg_sel6;      //Select6 match_3_reg6 from counter.
   input         intr_en_reg_sel6;      //Select6 interrupt6 register.
   input         clear_interrupt6;      //Clear interrupt6
   
   //Outputs6
   output [15:0]  counter_val_reg6;     //Counter6 value register from counter. 
   output [6:0]   clk_ctrl_reg6;        //Clock6 control6 reg from prescaler6.
   output [6:0]   cntr_ctrl_reg6;     //Counter6 control6 register 1.
   output [15:0]  interval_reg6;        //Interval6 register from counter.
   output [15:0]  match_1_reg6;         //Match6 1 register sent6 from counter. 
   output [15:0]  match_2_reg6;         //Match6 2 register sent6 from counter. 
   output [15:0]  match_3_reg6;         //Match6 3 register sent6 from counter. 
   output         interrupt6;
   output [5:0]   interrupt_reg6;
   output [5:0]   interrupt_en_reg6;
   
//-----------------------------------------------------------------------------
// Module6 Interconnect6
//-----------------------------------------------------------------------------

   wire count_en6;
   wire interval_intr6;          //Interval6 overflow6 interrupt6
   wire [3:1] match_intr6;       //Match6 interrupts6
   wire overflow_intr6;          //Overflow6 interupt6   
   wire [6:0] cntr_ctrl_reg6;    //Counter6 control6 register
   
//-----------------------------------------------------------------------------
// Module6 Instantiations6
//-----------------------------------------------------------------------------


    //outputs6

  ttc_count_rst_lite6 i_ttc_count_rst_lite6(

    //inputs6
    .n_p_reset6                              (n_p_reset6),   
    .pclk6                                   (pclk6),                             
    .pwdata6                                 (pwdata6[6:0]),
    .clk_ctrl_reg_sel6                       (clk_ctrl_reg_sel6),
    .restart6                                (cntr_ctrl_reg6[4]),
                         
    //outputs6        
    .count_en_out6                           (count_en6),                         
    .clk_ctrl_reg_out6                       (clk_ctrl_reg6)

  );


  ttc_counter_lite6 i_ttc_counter_lite6(

    //inputs6
    .n_p_reset6                              (n_p_reset6),  
    .pclk6                                   (pclk6),                          
    .pwdata6                                 (pwdata6),                           
    .count_en6                               (count_en6),
    .cntr_ctrl_reg_sel6                      (cntr_ctrl_reg_sel6), 
    .interval_reg_sel6                       (interval_reg_sel6),
    .match_1_reg_sel6                        (match_1_reg_sel6),
    .match_2_reg_sel6                        (match_2_reg_sel6),
    .match_3_reg_sel6                        (match_3_reg_sel6),

    //outputs6
    .count_val_out6                          (counter_val_reg6),
    .cntr_ctrl_reg_out6                      (cntr_ctrl_reg6),
    .interval_reg_out6                       (interval_reg6),
    .match_1_reg_out6                        (match_1_reg6),
    .match_2_reg_out6                        (match_2_reg6),
    .match_3_reg_out6                        (match_3_reg6),
    .interval_intr6                          (interval_intr6),
    .match_intr6                             (match_intr6),
    .overflow_intr6                          (overflow_intr6)
    
  );

  ttc_interrupt_lite6 i_ttc_interrupt_lite6(

    //inputs6
    .n_p_reset6                           (n_p_reset6), 
    .pwdata6                              (pwdata6[5:0]),
    .pclk6                                (pclk6),
    .intr_en_reg_sel6                     (intr_en_reg_sel6), 
    .clear_interrupt6                     (clear_interrupt6),
    .interval_intr6                       (interval_intr6),
    .match_intr6                          (match_intr6),
    .overflow_intr6                       (overflow_intr6),
    .restart6                             (cntr_ctrl_reg6[4]),

    //outputs6
    .interrupt6                           (interrupt6),
    .interrupt_reg_out6                   (interrupt_reg6),
    .interrupt_en_out6                    (interrupt_en_reg6)
                       
  );


   
endmodule
