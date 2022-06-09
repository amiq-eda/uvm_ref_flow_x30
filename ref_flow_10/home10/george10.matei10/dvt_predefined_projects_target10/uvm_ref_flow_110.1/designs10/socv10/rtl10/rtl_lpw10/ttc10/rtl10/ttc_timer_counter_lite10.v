//File10 name   : ttc_timer_counter_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : An10 instantiation10 of counter modules10.
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module10 definition10
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite10(

   //inputs10
   n_p_reset10,    
   pclk10,                         
   pwdata10,                              
   clk_ctrl_reg_sel10,
   cntr_ctrl_reg_sel10,
   interval_reg_sel10, 
   match_1_reg_sel10,
   match_2_reg_sel10,
   match_3_reg_sel10,
   intr_en_reg_sel10,
   clear_interrupt10,
                 
   //outputs10             
   clk_ctrl_reg10, 
   counter_val_reg10,
   cntr_ctrl_reg10,
   interval_reg10,
   match_1_reg10,
   match_2_reg10,
   match_3_reg10,
   interrupt10,
   interrupt_reg10,
   interrupt_en_reg10
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS10
//-----------------------------------------------------------------------------

   //inputs10
   input         n_p_reset10;            //reset signal10
   input         pclk10;                 //APB10 system clock10
   input [15:0]  pwdata10;               //16 Bit10 data signal10
   input         clk_ctrl_reg_sel10;     //Select10 clk_ctrl_reg10 from prescaler10
   input         cntr_ctrl_reg_sel10;    //Select10 control10 reg from counter.
   input         interval_reg_sel10;     //Select10 Interval10 reg from counter.
   input         match_1_reg_sel10;      //Select10 match_1_reg10 from counter. 
   input         match_2_reg_sel10;      //Select10 match_2_reg10 from counter.
   input         match_3_reg_sel10;      //Select10 match_3_reg10 from counter.
   input         intr_en_reg_sel10;      //Select10 interrupt10 register.
   input         clear_interrupt10;      //Clear interrupt10
   
   //Outputs10
   output [15:0]  counter_val_reg10;     //Counter10 value register from counter. 
   output [6:0]   clk_ctrl_reg10;        //Clock10 control10 reg from prescaler10.
   output [6:0]   cntr_ctrl_reg10;     //Counter10 control10 register 1.
   output [15:0]  interval_reg10;        //Interval10 register from counter.
   output [15:0]  match_1_reg10;         //Match10 1 register sent10 from counter. 
   output [15:0]  match_2_reg10;         //Match10 2 register sent10 from counter. 
   output [15:0]  match_3_reg10;         //Match10 3 register sent10 from counter. 
   output         interrupt10;
   output [5:0]   interrupt_reg10;
   output [5:0]   interrupt_en_reg10;
   
//-----------------------------------------------------------------------------
// Module10 Interconnect10
//-----------------------------------------------------------------------------

   wire count_en10;
   wire interval_intr10;          //Interval10 overflow10 interrupt10
   wire [3:1] match_intr10;       //Match10 interrupts10
   wire overflow_intr10;          //Overflow10 interupt10   
   wire [6:0] cntr_ctrl_reg10;    //Counter10 control10 register
   
//-----------------------------------------------------------------------------
// Module10 Instantiations10
//-----------------------------------------------------------------------------


    //outputs10

  ttc_count_rst_lite10 i_ttc_count_rst_lite10(

    //inputs10
    .n_p_reset10                              (n_p_reset10),   
    .pclk10                                   (pclk10),                             
    .pwdata10                                 (pwdata10[6:0]),
    .clk_ctrl_reg_sel10                       (clk_ctrl_reg_sel10),
    .restart10                                (cntr_ctrl_reg10[4]),
                         
    //outputs10        
    .count_en_out10                           (count_en10),                         
    .clk_ctrl_reg_out10                       (clk_ctrl_reg10)

  );


  ttc_counter_lite10 i_ttc_counter_lite10(

    //inputs10
    .n_p_reset10                              (n_p_reset10),  
    .pclk10                                   (pclk10),                          
    .pwdata10                                 (pwdata10),                           
    .count_en10                               (count_en10),
    .cntr_ctrl_reg_sel10                      (cntr_ctrl_reg_sel10), 
    .interval_reg_sel10                       (interval_reg_sel10),
    .match_1_reg_sel10                        (match_1_reg_sel10),
    .match_2_reg_sel10                        (match_2_reg_sel10),
    .match_3_reg_sel10                        (match_3_reg_sel10),

    //outputs10
    .count_val_out10                          (counter_val_reg10),
    .cntr_ctrl_reg_out10                      (cntr_ctrl_reg10),
    .interval_reg_out10                       (interval_reg10),
    .match_1_reg_out10                        (match_1_reg10),
    .match_2_reg_out10                        (match_2_reg10),
    .match_3_reg_out10                        (match_3_reg10),
    .interval_intr10                          (interval_intr10),
    .match_intr10                             (match_intr10),
    .overflow_intr10                          (overflow_intr10)
    
  );

  ttc_interrupt_lite10 i_ttc_interrupt_lite10(

    //inputs10
    .n_p_reset10                           (n_p_reset10), 
    .pwdata10                              (pwdata10[5:0]),
    .pclk10                                (pclk10),
    .intr_en_reg_sel10                     (intr_en_reg_sel10), 
    .clear_interrupt10                     (clear_interrupt10),
    .interval_intr10                       (interval_intr10),
    .match_intr10                          (match_intr10),
    .overflow_intr10                       (overflow_intr10),
    .restart10                             (cntr_ctrl_reg10[4]),

    //outputs10
    .interrupt10                           (interrupt10),
    .interrupt_reg_out10                   (interrupt_reg10),
    .interrupt_en_out10                    (interrupt_en_reg10)
                       
  );


   
endmodule
