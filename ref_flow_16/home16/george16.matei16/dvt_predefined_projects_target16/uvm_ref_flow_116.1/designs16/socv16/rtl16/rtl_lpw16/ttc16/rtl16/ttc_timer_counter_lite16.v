//File16 name   : ttc_timer_counter_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : An16 instantiation16 of counter modules16.
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module16 definition16
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite16(

   //inputs16
   n_p_reset16,    
   pclk16,                         
   pwdata16,                              
   clk_ctrl_reg_sel16,
   cntr_ctrl_reg_sel16,
   interval_reg_sel16, 
   match_1_reg_sel16,
   match_2_reg_sel16,
   match_3_reg_sel16,
   intr_en_reg_sel16,
   clear_interrupt16,
                 
   //outputs16             
   clk_ctrl_reg16, 
   counter_val_reg16,
   cntr_ctrl_reg16,
   interval_reg16,
   match_1_reg16,
   match_2_reg16,
   match_3_reg16,
   interrupt16,
   interrupt_reg16,
   interrupt_en_reg16
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS16
//-----------------------------------------------------------------------------

   //inputs16
   input         n_p_reset16;            //reset signal16
   input         pclk16;                 //APB16 system clock16
   input [15:0]  pwdata16;               //16 Bit16 data signal16
   input         clk_ctrl_reg_sel16;     //Select16 clk_ctrl_reg16 from prescaler16
   input         cntr_ctrl_reg_sel16;    //Select16 control16 reg from counter.
   input         interval_reg_sel16;     //Select16 Interval16 reg from counter.
   input         match_1_reg_sel16;      //Select16 match_1_reg16 from counter. 
   input         match_2_reg_sel16;      //Select16 match_2_reg16 from counter.
   input         match_3_reg_sel16;      //Select16 match_3_reg16 from counter.
   input         intr_en_reg_sel16;      //Select16 interrupt16 register.
   input         clear_interrupt16;      //Clear interrupt16
   
   //Outputs16
   output [15:0]  counter_val_reg16;     //Counter16 value register from counter. 
   output [6:0]   clk_ctrl_reg16;        //Clock16 control16 reg from prescaler16.
   output [6:0]   cntr_ctrl_reg16;     //Counter16 control16 register 1.
   output [15:0]  interval_reg16;        //Interval16 register from counter.
   output [15:0]  match_1_reg16;         //Match16 1 register sent16 from counter. 
   output [15:0]  match_2_reg16;         //Match16 2 register sent16 from counter. 
   output [15:0]  match_3_reg16;         //Match16 3 register sent16 from counter. 
   output         interrupt16;
   output [5:0]   interrupt_reg16;
   output [5:0]   interrupt_en_reg16;
   
//-----------------------------------------------------------------------------
// Module16 Interconnect16
//-----------------------------------------------------------------------------

   wire count_en16;
   wire interval_intr16;          //Interval16 overflow16 interrupt16
   wire [3:1] match_intr16;       //Match16 interrupts16
   wire overflow_intr16;          //Overflow16 interupt16   
   wire [6:0] cntr_ctrl_reg16;    //Counter16 control16 register
   
//-----------------------------------------------------------------------------
// Module16 Instantiations16
//-----------------------------------------------------------------------------


    //outputs16

  ttc_count_rst_lite16 i_ttc_count_rst_lite16(

    //inputs16
    .n_p_reset16                              (n_p_reset16),   
    .pclk16                                   (pclk16),                             
    .pwdata16                                 (pwdata16[6:0]),
    .clk_ctrl_reg_sel16                       (clk_ctrl_reg_sel16),
    .restart16                                (cntr_ctrl_reg16[4]),
                         
    //outputs16        
    .count_en_out16                           (count_en16),                         
    .clk_ctrl_reg_out16                       (clk_ctrl_reg16)

  );


  ttc_counter_lite16 i_ttc_counter_lite16(

    //inputs16
    .n_p_reset16                              (n_p_reset16),  
    .pclk16                                   (pclk16),                          
    .pwdata16                                 (pwdata16),                           
    .count_en16                               (count_en16),
    .cntr_ctrl_reg_sel16                      (cntr_ctrl_reg_sel16), 
    .interval_reg_sel16                       (interval_reg_sel16),
    .match_1_reg_sel16                        (match_1_reg_sel16),
    .match_2_reg_sel16                        (match_2_reg_sel16),
    .match_3_reg_sel16                        (match_3_reg_sel16),

    //outputs16
    .count_val_out16                          (counter_val_reg16),
    .cntr_ctrl_reg_out16                      (cntr_ctrl_reg16),
    .interval_reg_out16                       (interval_reg16),
    .match_1_reg_out16                        (match_1_reg16),
    .match_2_reg_out16                        (match_2_reg16),
    .match_3_reg_out16                        (match_3_reg16),
    .interval_intr16                          (interval_intr16),
    .match_intr16                             (match_intr16),
    .overflow_intr16                          (overflow_intr16)
    
  );

  ttc_interrupt_lite16 i_ttc_interrupt_lite16(

    //inputs16
    .n_p_reset16                           (n_p_reset16), 
    .pwdata16                              (pwdata16[5:0]),
    .pclk16                                (pclk16),
    .intr_en_reg_sel16                     (intr_en_reg_sel16), 
    .clear_interrupt16                     (clear_interrupt16),
    .interval_intr16                       (interval_intr16),
    .match_intr16                          (match_intr16),
    .overflow_intr16                       (overflow_intr16),
    .restart16                             (cntr_ctrl_reg16[4]),

    //outputs16
    .interrupt16                           (interrupt16),
    .interrupt_reg_out16                   (interrupt_reg16),
    .interrupt_en_out16                    (interrupt_en_reg16)
                       
  );


   
endmodule
