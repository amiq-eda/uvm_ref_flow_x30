//File29 name   : ttc_timer_counter_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : An29 instantiation29 of counter modules29.
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module29 definition29
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite29(

   //inputs29
   n_p_reset29,    
   pclk29,                         
   pwdata29,                              
   clk_ctrl_reg_sel29,
   cntr_ctrl_reg_sel29,
   interval_reg_sel29, 
   match_1_reg_sel29,
   match_2_reg_sel29,
   match_3_reg_sel29,
   intr_en_reg_sel29,
   clear_interrupt29,
                 
   //outputs29             
   clk_ctrl_reg29, 
   counter_val_reg29,
   cntr_ctrl_reg29,
   interval_reg29,
   match_1_reg29,
   match_2_reg29,
   match_3_reg29,
   interrupt29,
   interrupt_reg29,
   interrupt_en_reg29
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS29
//-----------------------------------------------------------------------------

   //inputs29
   input         n_p_reset29;            //reset signal29
   input         pclk29;                 //APB29 system clock29
   input [15:0]  pwdata29;               //16 Bit29 data signal29
   input         clk_ctrl_reg_sel29;     //Select29 clk_ctrl_reg29 from prescaler29
   input         cntr_ctrl_reg_sel29;    //Select29 control29 reg from counter.
   input         interval_reg_sel29;     //Select29 Interval29 reg from counter.
   input         match_1_reg_sel29;      //Select29 match_1_reg29 from counter. 
   input         match_2_reg_sel29;      //Select29 match_2_reg29 from counter.
   input         match_3_reg_sel29;      //Select29 match_3_reg29 from counter.
   input         intr_en_reg_sel29;      //Select29 interrupt29 register.
   input         clear_interrupt29;      //Clear interrupt29
   
   //Outputs29
   output [15:0]  counter_val_reg29;     //Counter29 value register from counter. 
   output [6:0]   clk_ctrl_reg29;        //Clock29 control29 reg from prescaler29.
   output [6:0]   cntr_ctrl_reg29;     //Counter29 control29 register 1.
   output [15:0]  interval_reg29;        //Interval29 register from counter.
   output [15:0]  match_1_reg29;         //Match29 1 register sent29 from counter. 
   output [15:0]  match_2_reg29;         //Match29 2 register sent29 from counter. 
   output [15:0]  match_3_reg29;         //Match29 3 register sent29 from counter. 
   output         interrupt29;
   output [5:0]   interrupt_reg29;
   output [5:0]   interrupt_en_reg29;
   
//-----------------------------------------------------------------------------
// Module29 Interconnect29
//-----------------------------------------------------------------------------

   wire count_en29;
   wire interval_intr29;          //Interval29 overflow29 interrupt29
   wire [3:1] match_intr29;       //Match29 interrupts29
   wire overflow_intr29;          //Overflow29 interupt29   
   wire [6:0] cntr_ctrl_reg29;    //Counter29 control29 register
   
//-----------------------------------------------------------------------------
// Module29 Instantiations29
//-----------------------------------------------------------------------------


    //outputs29

  ttc_count_rst_lite29 i_ttc_count_rst_lite29(

    //inputs29
    .n_p_reset29                              (n_p_reset29),   
    .pclk29                                   (pclk29),                             
    .pwdata29                                 (pwdata29[6:0]),
    .clk_ctrl_reg_sel29                       (clk_ctrl_reg_sel29),
    .restart29                                (cntr_ctrl_reg29[4]),
                         
    //outputs29        
    .count_en_out29                           (count_en29),                         
    .clk_ctrl_reg_out29                       (clk_ctrl_reg29)

  );


  ttc_counter_lite29 i_ttc_counter_lite29(

    //inputs29
    .n_p_reset29                              (n_p_reset29),  
    .pclk29                                   (pclk29),                          
    .pwdata29                                 (pwdata29),                           
    .count_en29                               (count_en29),
    .cntr_ctrl_reg_sel29                      (cntr_ctrl_reg_sel29), 
    .interval_reg_sel29                       (interval_reg_sel29),
    .match_1_reg_sel29                        (match_1_reg_sel29),
    .match_2_reg_sel29                        (match_2_reg_sel29),
    .match_3_reg_sel29                        (match_3_reg_sel29),

    //outputs29
    .count_val_out29                          (counter_val_reg29),
    .cntr_ctrl_reg_out29                      (cntr_ctrl_reg29),
    .interval_reg_out29                       (interval_reg29),
    .match_1_reg_out29                        (match_1_reg29),
    .match_2_reg_out29                        (match_2_reg29),
    .match_3_reg_out29                        (match_3_reg29),
    .interval_intr29                          (interval_intr29),
    .match_intr29                             (match_intr29),
    .overflow_intr29                          (overflow_intr29)
    
  );

  ttc_interrupt_lite29 i_ttc_interrupt_lite29(

    //inputs29
    .n_p_reset29                           (n_p_reset29), 
    .pwdata29                              (pwdata29[5:0]),
    .pclk29                                (pclk29),
    .intr_en_reg_sel29                     (intr_en_reg_sel29), 
    .clear_interrupt29                     (clear_interrupt29),
    .interval_intr29                       (interval_intr29),
    .match_intr29                          (match_intr29),
    .overflow_intr29                       (overflow_intr29),
    .restart29                             (cntr_ctrl_reg29[4]),

    //outputs29
    .interrupt29                           (interrupt29),
    .interrupt_reg_out29                   (interrupt_reg29),
    .interrupt_en_out29                    (interrupt_en_reg29)
                       
  );


   
endmodule
