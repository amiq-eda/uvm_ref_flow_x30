//File2 name   : ttc_timer_counter_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : An2 instantiation2 of counter modules2.
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module2 definition2
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite2(

   //inputs2
   n_p_reset2,    
   pclk2,                         
   pwdata2,                              
   clk_ctrl_reg_sel2,
   cntr_ctrl_reg_sel2,
   interval_reg_sel2, 
   match_1_reg_sel2,
   match_2_reg_sel2,
   match_3_reg_sel2,
   intr_en_reg_sel2,
   clear_interrupt2,
                 
   //outputs2             
   clk_ctrl_reg2, 
   counter_val_reg2,
   cntr_ctrl_reg2,
   interval_reg2,
   match_1_reg2,
   match_2_reg2,
   match_3_reg2,
   interrupt2,
   interrupt_reg2,
   interrupt_en_reg2
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS2
//-----------------------------------------------------------------------------

   //inputs2
   input         n_p_reset2;            //reset signal2
   input         pclk2;                 //APB2 system clock2
   input [15:0]  pwdata2;               //16 Bit2 data signal2
   input         clk_ctrl_reg_sel2;     //Select2 clk_ctrl_reg2 from prescaler2
   input         cntr_ctrl_reg_sel2;    //Select2 control2 reg from counter.
   input         interval_reg_sel2;     //Select2 Interval2 reg from counter.
   input         match_1_reg_sel2;      //Select2 match_1_reg2 from counter. 
   input         match_2_reg_sel2;      //Select2 match_2_reg2 from counter.
   input         match_3_reg_sel2;      //Select2 match_3_reg2 from counter.
   input         intr_en_reg_sel2;      //Select2 interrupt2 register.
   input         clear_interrupt2;      //Clear interrupt2
   
   //Outputs2
   output [15:0]  counter_val_reg2;     //Counter2 value register from counter. 
   output [6:0]   clk_ctrl_reg2;        //Clock2 control2 reg from prescaler2.
   output [6:0]   cntr_ctrl_reg2;     //Counter2 control2 register 1.
   output [15:0]  interval_reg2;        //Interval2 register from counter.
   output [15:0]  match_1_reg2;         //Match2 1 register sent2 from counter. 
   output [15:0]  match_2_reg2;         //Match2 2 register sent2 from counter. 
   output [15:0]  match_3_reg2;         //Match2 3 register sent2 from counter. 
   output         interrupt2;
   output [5:0]   interrupt_reg2;
   output [5:0]   interrupt_en_reg2;
   
//-----------------------------------------------------------------------------
// Module2 Interconnect2
//-----------------------------------------------------------------------------

   wire count_en2;
   wire interval_intr2;          //Interval2 overflow2 interrupt2
   wire [3:1] match_intr2;       //Match2 interrupts2
   wire overflow_intr2;          //Overflow2 interupt2   
   wire [6:0] cntr_ctrl_reg2;    //Counter2 control2 register
   
//-----------------------------------------------------------------------------
// Module2 Instantiations2
//-----------------------------------------------------------------------------


    //outputs2

  ttc_count_rst_lite2 i_ttc_count_rst_lite2(

    //inputs2
    .n_p_reset2                              (n_p_reset2),   
    .pclk2                                   (pclk2),                             
    .pwdata2                                 (pwdata2[6:0]),
    .clk_ctrl_reg_sel2                       (clk_ctrl_reg_sel2),
    .restart2                                (cntr_ctrl_reg2[4]),
                         
    //outputs2        
    .count_en_out2                           (count_en2),                         
    .clk_ctrl_reg_out2                       (clk_ctrl_reg2)

  );


  ttc_counter_lite2 i_ttc_counter_lite2(

    //inputs2
    .n_p_reset2                              (n_p_reset2),  
    .pclk2                                   (pclk2),                          
    .pwdata2                                 (pwdata2),                           
    .count_en2                               (count_en2),
    .cntr_ctrl_reg_sel2                      (cntr_ctrl_reg_sel2), 
    .interval_reg_sel2                       (interval_reg_sel2),
    .match_1_reg_sel2                        (match_1_reg_sel2),
    .match_2_reg_sel2                        (match_2_reg_sel2),
    .match_3_reg_sel2                        (match_3_reg_sel2),

    //outputs2
    .count_val_out2                          (counter_val_reg2),
    .cntr_ctrl_reg_out2                      (cntr_ctrl_reg2),
    .interval_reg_out2                       (interval_reg2),
    .match_1_reg_out2                        (match_1_reg2),
    .match_2_reg_out2                        (match_2_reg2),
    .match_3_reg_out2                        (match_3_reg2),
    .interval_intr2                          (interval_intr2),
    .match_intr2                             (match_intr2),
    .overflow_intr2                          (overflow_intr2)
    
  );

  ttc_interrupt_lite2 i_ttc_interrupt_lite2(

    //inputs2
    .n_p_reset2                           (n_p_reset2), 
    .pwdata2                              (pwdata2[5:0]),
    .pclk2                                (pclk2),
    .intr_en_reg_sel2                     (intr_en_reg_sel2), 
    .clear_interrupt2                     (clear_interrupt2),
    .interval_intr2                       (interval_intr2),
    .match_intr2                          (match_intr2),
    .overflow_intr2                       (overflow_intr2),
    .restart2                             (cntr_ctrl_reg2[4]),

    //outputs2
    .interrupt2                           (interrupt2),
    .interrupt_reg_out2                   (interrupt_reg2),
    .interrupt_en_out2                    (interrupt_en_reg2)
                       
  );


   
endmodule
