//File11 name   : ttc_timer_counter_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : An11 instantiation11 of counter modules11.
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module11 definition11
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite11(

   //inputs11
   n_p_reset11,    
   pclk11,                         
   pwdata11,                              
   clk_ctrl_reg_sel11,
   cntr_ctrl_reg_sel11,
   interval_reg_sel11, 
   match_1_reg_sel11,
   match_2_reg_sel11,
   match_3_reg_sel11,
   intr_en_reg_sel11,
   clear_interrupt11,
                 
   //outputs11             
   clk_ctrl_reg11, 
   counter_val_reg11,
   cntr_ctrl_reg11,
   interval_reg11,
   match_1_reg11,
   match_2_reg11,
   match_3_reg11,
   interrupt11,
   interrupt_reg11,
   interrupt_en_reg11
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS11
//-----------------------------------------------------------------------------

   //inputs11
   input         n_p_reset11;            //reset signal11
   input         pclk11;                 //APB11 system clock11
   input [15:0]  pwdata11;               //16 Bit11 data signal11
   input         clk_ctrl_reg_sel11;     //Select11 clk_ctrl_reg11 from prescaler11
   input         cntr_ctrl_reg_sel11;    //Select11 control11 reg from counter.
   input         interval_reg_sel11;     //Select11 Interval11 reg from counter.
   input         match_1_reg_sel11;      //Select11 match_1_reg11 from counter. 
   input         match_2_reg_sel11;      //Select11 match_2_reg11 from counter.
   input         match_3_reg_sel11;      //Select11 match_3_reg11 from counter.
   input         intr_en_reg_sel11;      //Select11 interrupt11 register.
   input         clear_interrupt11;      //Clear interrupt11
   
   //Outputs11
   output [15:0]  counter_val_reg11;     //Counter11 value register from counter. 
   output [6:0]   clk_ctrl_reg11;        //Clock11 control11 reg from prescaler11.
   output [6:0]   cntr_ctrl_reg11;     //Counter11 control11 register 1.
   output [15:0]  interval_reg11;        //Interval11 register from counter.
   output [15:0]  match_1_reg11;         //Match11 1 register sent11 from counter. 
   output [15:0]  match_2_reg11;         //Match11 2 register sent11 from counter. 
   output [15:0]  match_3_reg11;         //Match11 3 register sent11 from counter. 
   output         interrupt11;
   output [5:0]   interrupt_reg11;
   output [5:0]   interrupt_en_reg11;
   
//-----------------------------------------------------------------------------
// Module11 Interconnect11
//-----------------------------------------------------------------------------

   wire count_en11;
   wire interval_intr11;          //Interval11 overflow11 interrupt11
   wire [3:1] match_intr11;       //Match11 interrupts11
   wire overflow_intr11;          //Overflow11 interupt11   
   wire [6:0] cntr_ctrl_reg11;    //Counter11 control11 register
   
//-----------------------------------------------------------------------------
// Module11 Instantiations11
//-----------------------------------------------------------------------------


    //outputs11

  ttc_count_rst_lite11 i_ttc_count_rst_lite11(

    //inputs11
    .n_p_reset11                              (n_p_reset11),   
    .pclk11                                   (pclk11),                             
    .pwdata11                                 (pwdata11[6:0]),
    .clk_ctrl_reg_sel11                       (clk_ctrl_reg_sel11),
    .restart11                                (cntr_ctrl_reg11[4]),
                         
    //outputs11        
    .count_en_out11                           (count_en11),                         
    .clk_ctrl_reg_out11                       (clk_ctrl_reg11)

  );


  ttc_counter_lite11 i_ttc_counter_lite11(

    //inputs11
    .n_p_reset11                              (n_p_reset11),  
    .pclk11                                   (pclk11),                          
    .pwdata11                                 (pwdata11),                           
    .count_en11                               (count_en11),
    .cntr_ctrl_reg_sel11                      (cntr_ctrl_reg_sel11), 
    .interval_reg_sel11                       (interval_reg_sel11),
    .match_1_reg_sel11                        (match_1_reg_sel11),
    .match_2_reg_sel11                        (match_2_reg_sel11),
    .match_3_reg_sel11                        (match_3_reg_sel11),

    //outputs11
    .count_val_out11                          (counter_val_reg11),
    .cntr_ctrl_reg_out11                      (cntr_ctrl_reg11),
    .interval_reg_out11                       (interval_reg11),
    .match_1_reg_out11                        (match_1_reg11),
    .match_2_reg_out11                        (match_2_reg11),
    .match_3_reg_out11                        (match_3_reg11),
    .interval_intr11                          (interval_intr11),
    .match_intr11                             (match_intr11),
    .overflow_intr11                          (overflow_intr11)
    
  );

  ttc_interrupt_lite11 i_ttc_interrupt_lite11(

    //inputs11
    .n_p_reset11                           (n_p_reset11), 
    .pwdata11                              (pwdata11[5:0]),
    .pclk11                                (pclk11),
    .intr_en_reg_sel11                     (intr_en_reg_sel11), 
    .clear_interrupt11                     (clear_interrupt11),
    .interval_intr11                       (interval_intr11),
    .match_intr11                          (match_intr11),
    .overflow_intr11                       (overflow_intr11),
    .restart11                             (cntr_ctrl_reg11[4]),

    //outputs11
    .interrupt11                           (interrupt11),
    .interrupt_reg_out11                   (interrupt_reg11),
    .interrupt_en_out11                    (interrupt_en_reg11)
                       
  );


   
endmodule
