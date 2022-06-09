//File7 name   : ttc_timer_counter_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : An7 instantiation7 of counter modules7.
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module7 definition7
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite7(

   //inputs7
   n_p_reset7,    
   pclk7,                         
   pwdata7,                              
   clk_ctrl_reg_sel7,
   cntr_ctrl_reg_sel7,
   interval_reg_sel7, 
   match_1_reg_sel7,
   match_2_reg_sel7,
   match_3_reg_sel7,
   intr_en_reg_sel7,
   clear_interrupt7,
                 
   //outputs7             
   clk_ctrl_reg7, 
   counter_val_reg7,
   cntr_ctrl_reg7,
   interval_reg7,
   match_1_reg7,
   match_2_reg7,
   match_3_reg7,
   interrupt7,
   interrupt_reg7,
   interrupt_en_reg7
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS7
//-----------------------------------------------------------------------------

   //inputs7
   input         n_p_reset7;            //reset signal7
   input         pclk7;                 //APB7 system clock7
   input [15:0]  pwdata7;               //16 Bit7 data signal7
   input         clk_ctrl_reg_sel7;     //Select7 clk_ctrl_reg7 from prescaler7
   input         cntr_ctrl_reg_sel7;    //Select7 control7 reg from counter.
   input         interval_reg_sel7;     //Select7 Interval7 reg from counter.
   input         match_1_reg_sel7;      //Select7 match_1_reg7 from counter. 
   input         match_2_reg_sel7;      //Select7 match_2_reg7 from counter.
   input         match_3_reg_sel7;      //Select7 match_3_reg7 from counter.
   input         intr_en_reg_sel7;      //Select7 interrupt7 register.
   input         clear_interrupt7;      //Clear interrupt7
   
   //Outputs7
   output [15:0]  counter_val_reg7;     //Counter7 value register from counter. 
   output [6:0]   clk_ctrl_reg7;        //Clock7 control7 reg from prescaler7.
   output [6:0]   cntr_ctrl_reg7;     //Counter7 control7 register 1.
   output [15:0]  interval_reg7;        //Interval7 register from counter.
   output [15:0]  match_1_reg7;         //Match7 1 register sent7 from counter. 
   output [15:0]  match_2_reg7;         //Match7 2 register sent7 from counter. 
   output [15:0]  match_3_reg7;         //Match7 3 register sent7 from counter. 
   output         interrupt7;
   output [5:0]   interrupt_reg7;
   output [5:0]   interrupt_en_reg7;
   
//-----------------------------------------------------------------------------
// Module7 Interconnect7
//-----------------------------------------------------------------------------

   wire count_en7;
   wire interval_intr7;          //Interval7 overflow7 interrupt7
   wire [3:1] match_intr7;       //Match7 interrupts7
   wire overflow_intr7;          //Overflow7 interupt7   
   wire [6:0] cntr_ctrl_reg7;    //Counter7 control7 register
   
//-----------------------------------------------------------------------------
// Module7 Instantiations7
//-----------------------------------------------------------------------------


    //outputs7

  ttc_count_rst_lite7 i_ttc_count_rst_lite7(

    //inputs7
    .n_p_reset7                              (n_p_reset7),   
    .pclk7                                   (pclk7),                             
    .pwdata7                                 (pwdata7[6:0]),
    .clk_ctrl_reg_sel7                       (clk_ctrl_reg_sel7),
    .restart7                                (cntr_ctrl_reg7[4]),
                         
    //outputs7        
    .count_en_out7                           (count_en7),                         
    .clk_ctrl_reg_out7                       (clk_ctrl_reg7)

  );


  ttc_counter_lite7 i_ttc_counter_lite7(

    //inputs7
    .n_p_reset7                              (n_p_reset7),  
    .pclk7                                   (pclk7),                          
    .pwdata7                                 (pwdata7),                           
    .count_en7                               (count_en7),
    .cntr_ctrl_reg_sel7                      (cntr_ctrl_reg_sel7), 
    .interval_reg_sel7                       (interval_reg_sel7),
    .match_1_reg_sel7                        (match_1_reg_sel7),
    .match_2_reg_sel7                        (match_2_reg_sel7),
    .match_3_reg_sel7                        (match_3_reg_sel7),

    //outputs7
    .count_val_out7                          (counter_val_reg7),
    .cntr_ctrl_reg_out7                      (cntr_ctrl_reg7),
    .interval_reg_out7                       (interval_reg7),
    .match_1_reg_out7                        (match_1_reg7),
    .match_2_reg_out7                        (match_2_reg7),
    .match_3_reg_out7                        (match_3_reg7),
    .interval_intr7                          (interval_intr7),
    .match_intr7                             (match_intr7),
    .overflow_intr7                          (overflow_intr7)
    
  );

  ttc_interrupt_lite7 i_ttc_interrupt_lite7(

    //inputs7
    .n_p_reset7                           (n_p_reset7), 
    .pwdata7                              (pwdata7[5:0]),
    .pclk7                                (pclk7),
    .intr_en_reg_sel7                     (intr_en_reg_sel7), 
    .clear_interrupt7                     (clear_interrupt7),
    .interval_intr7                       (interval_intr7),
    .match_intr7                          (match_intr7),
    .overflow_intr7                       (overflow_intr7),
    .restart7                             (cntr_ctrl_reg7[4]),

    //outputs7
    .interrupt7                           (interrupt7),
    .interrupt_reg_out7                   (interrupt_reg7),
    .interrupt_en_out7                    (interrupt_en_reg7)
                       
  );


   
endmodule
