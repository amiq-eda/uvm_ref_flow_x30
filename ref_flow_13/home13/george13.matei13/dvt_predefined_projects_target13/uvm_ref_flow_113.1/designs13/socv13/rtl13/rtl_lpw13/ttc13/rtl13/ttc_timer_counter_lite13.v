//File13 name   : ttc_timer_counter_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : An13 instantiation13 of counter modules13.
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module13 definition13
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite13(

   //inputs13
   n_p_reset13,    
   pclk13,                         
   pwdata13,                              
   clk_ctrl_reg_sel13,
   cntr_ctrl_reg_sel13,
   interval_reg_sel13, 
   match_1_reg_sel13,
   match_2_reg_sel13,
   match_3_reg_sel13,
   intr_en_reg_sel13,
   clear_interrupt13,
                 
   //outputs13             
   clk_ctrl_reg13, 
   counter_val_reg13,
   cntr_ctrl_reg13,
   interval_reg13,
   match_1_reg13,
   match_2_reg13,
   match_3_reg13,
   interrupt13,
   interrupt_reg13,
   interrupt_en_reg13
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS13
//-----------------------------------------------------------------------------

   //inputs13
   input         n_p_reset13;            //reset signal13
   input         pclk13;                 //APB13 system clock13
   input [15:0]  pwdata13;               //16 Bit13 data signal13
   input         clk_ctrl_reg_sel13;     //Select13 clk_ctrl_reg13 from prescaler13
   input         cntr_ctrl_reg_sel13;    //Select13 control13 reg from counter.
   input         interval_reg_sel13;     //Select13 Interval13 reg from counter.
   input         match_1_reg_sel13;      //Select13 match_1_reg13 from counter. 
   input         match_2_reg_sel13;      //Select13 match_2_reg13 from counter.
   input         match_3_reg_sel13;      //Select13 match_3_reg13 from counter.
   input         intr_en_reg_sel13;      //Select13 interrupt13 register.
   input         clear_interrupt13;      //Clear interrupt13
   
   //Outputs13
   output [15:0]  counter_val_reg13;     //Counter13 value register from counter. 
   output [6:0]   clk_ctrl_reg13;        //Clock13 control13 reg from prescaler13.
   output [6:0]   cntr_ctrl_reg13;     //Counter13 control13 register 1.
   output [15:0]  interval_reg13;        //Interval13 register from counter.
   output [15:0]  match_1_reg13;         //Match13 1 register sent13 from counter. 
   output [15:0]  match_2_reg13;         //Match13 2 register sent13 from counter. 
   output [15:0]  match_3_reg13;         //Match13 3 register sent13 from counter. 
   output         interrupt13;
   output [5:0]   interrupt_reg13;
   output [5:0]   interrupt_en_reg13;
   
//-----------------------------------------------------------------------------
// Module13 Interconnect13
//-----------------------------------------------------------------------------

   wire count_en13;
   wire interval_intr13;          //Interval13 overflow13 interrupt13
   wire [3:1] match_intr13;       //Match13 interrupts13
   wire overflow_intr13;          //Overflow13 interupt13   
   wire [6:0] cntr_ctrl_reg13;    //Counter13 control13 register
   
//-----------------------------------------------------------------------------
// Module13 Instantiations13
//-----------------------------------------------------------------------------


    //outputs13

  ttc_count_rst_lite13 i_ttc_count_rst_lite13(

    //inputs13
    .n_p_reset13                              (n_p_reset13),   
    .pclk13                                   (pclk13),                             
    .pwdata13                                 (pwdata13[6:0]),
    .clk_ctrl_reg_sel13                       (clk_ctrl_reg_sel13),
    .restart13                                (cntr_ctrl_reg13[4]),
                         
    //outputs13        
    .count_en_out13                           (count_en13),                         
    .clk_ctrl_reg_out13                       (clk_ctrl_reg13)

  );


  ttc_counter_lite13 i_ttc_counter_lite13(

    //inputs13
    .n_p_reset13                              (n_p_reset13),  
    .pclk13                                   (pclk13),                          
    .pwdata13                                 (pwdata13),                           
    .count_en13                               (count_en13),
    .cntr_ctrl_reg_sel13                      (cntr_ctrl_reg_sel13), 
    .interval_reg_sel13                       (interval_reg_sel13),
    .match_1_reg_sel13                        (match_1_reg_sel13),
    .match_2_reg_sel13                        (match_2_reg_sel13),
    .match_3_reg_sel13                        (match_3_reg_sel13),

    //outputs13
    .count_val_out13                          (counter_val_reg13),
    .cntr_ctrl_reg_out13                      (cntr_ctrl_reg13),
    .interval_reg_out13                       (interval_reg13),
    .match_1_reg_out13                        (match_1_reg13),
    .match_2_reg_out13                        (match_2_reg13),
    .match_3_reg_out13                        (match_3_reg13),
    .interval_intr13                          (interval_intr13),
    .match_intr13                             (match_intr13),
    .overflow_intr13                          (overflow_intr13)
    
  );

  ttc_interrupt_lite13 i_ttc_interrupt_lite13(

    //inputs13
    .n_p_reset13                           (n_p_reset13), 
    .pwdata13                              (pwdata13[5:0]),
    .pclk13                                (pclk13),
    .intr_en_reg_sel13                     (intr_en_reg_sel13), 
    .clear_interrupt13                     (clear_interrupt13),
    .interval_intr13                       (interval_intr13),
    .match_intr13                          (match_intr13),
    .overflow_intr13                       (overflow_intr13),
    .restart13                             (cntr_ctrl_reg13[4]),

    //outputs13
    .interrupt13                           (interrupt13),
    .interrupt_reg_out13                   (interrupt_reg13),
    .interrupt_en_out13                    (interrupt_en_reg13)
                       
  );


   
endmodule
