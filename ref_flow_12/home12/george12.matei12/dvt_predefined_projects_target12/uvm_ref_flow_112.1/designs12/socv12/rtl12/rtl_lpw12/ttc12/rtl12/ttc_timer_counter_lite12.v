//File12 name   : ttc_timer_counter_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : An12 instantiation12 of counter modules12.
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module12 definition12
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite12(

   //inputs12
   n_p_reset12,    
   pclk12,                         
   pwdata12,                              
   clk_ctrl_reg_sel12,
   cntr_ctrl_reg_sel12,
   interval_reg_sel12, 
   match_1_reg_sel12,
   match_2_reg_sel12,
   match_3_reg_sel12,
   intr_en_reg_sel12,
   clear_interrupt12,
                 
   //outputs12             
   clk_ctrl_reg12, 
   counter_val_reg12,
   cntr_ctrl_reg12,
   interval_reg12,
   match_1_reg12,
   match_2_reg12,
   match_3_reg12,
   interrupt12,
   interrupt_reg12,
   interrupt_en_reg12
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS12
//-----------------------------------------------------------------------------

   //inputs12
   input         n_p_reset12;            //reset signal12
   input         pclk12;                 //APB12 system clock12
   input [15:0]  pwdata12;               //16 Bit12 data signal12
   input         clk_ctrl_reg_sel12;     //Select12 clk_ctrl_reg12 from prescaler12
   input         cntr_ctrl_reg_sel12;    //Select12 control12 reg from counter.
   input         interval_reg_sel12;     //Select12 Interval12 reg from counter.
   input         match_1_reg_sel12;      //Select12 match_1_reg12 from counter. 
   input         match_2_reg_sel12;      //Select12 match_2_reg12 from counter.
   input         match_3_reg_sel12;      //Select12 match_3_reg12 from counter.
   input         intr_en_reg_sel12;      //Select12 interrupt12 register.
   input         clear_interrupt12;      //Clear interrupt12
   
   //Outputs12
   output [15:0]  counter_val_reg12;     //Counter12 value register from counter. 
   output [6:0]   clk_ctrl_reg12;        //Clock12 control12 reg from prescaler12.
   output [6:0]   cntr_ctrl_reg12;     //Counter12 control12 register 1.
   output [15:0]  interval_reg12;        //Interval12 register from counter.
   output [15:0]  match_1_reg12;         //Match12 1 register sent12 from counter. 
   output [15:0]  match_2_reg12;         //Match12 2 register sent12 from counter. 
   output [15:0]  match_3_reg12;         //Match12 3 register sent12 from counter. 
   output         interrupt12;
   output [5:0]   interrupt_reg12;
   output [5:0]   interrupt_en_reg12;
   
//-----------------------------------------------------------------------------
// Module12 Interconnect12
//-----------------------------------------------------------------------------

   wire count_en12;
   wire interval_intr12;          //Interval12 overflow12 interrupt12
   wire [3:1] match_intr12;       //Match12 interrupts12
   wire overflow_intr12;          //Overflow12 interupt12   
   wire [6:0] cntr_ctrl_reg12;    //Counter12 control12 register
   
//-----------------------------------------------------------------------------
// Module12 Instantiations12
//-----------------------------------------------------------------------------


    //outputs12

  ttc_count_rst_lite12 i_ttc_count_rst_lite12(

    //inputs12
    .n_p_reset12                              (n_p_reset12),   
    .pclk12                                   (pclk12),                             
    .pwdata12                                 (pwdata12[6:0]),
    .clk_ctrl_reg_sel12                       (clk_ctrl_reg_sel12),
    .restart12                                (cntr_ctrl_reg12[4]),
                         
    //outputs12        
    .count_en_out12                           (count_en12),                         
    .clk_ctrl_reg_out12                       (clk_ctrl_reg12)

  );


  ttc_counter_lite12 i_ttc_counter_lite12(

    //inputs12
    .n_p_reset12                              (n_p_reset12),  
    .pclk12                                   (pclk12),                          
    .pwdata12                                 (pwdata12),                           
    .count_en12                               (count_en12),
    .cntr_ctrl_reg_sel12                      (cntr_ctrl_reg_sel12), 
    .interval_reg_sel12                       (interval_reg_sel12),
    .match_1_reg_sel12                        (match_1_reg_sel12),
    .match_2_reg_sel12                        (match_2_reg_sel12),
    .match_3_reg_sel12                        (match_3_reg_sel12),

    //outputs12
    .count_val_out12                          (counter_val_reg12),
    .cntr_ctrl_reg_out12                      (cntr_ctrl_reg12),
    .interval_reg_out12                       (interval_reg12),
    .match_1_reg_out12                        (match_1_reg12),
    .match_2_reg_out12                        (match_2_reg12),
    .match_3_reg_out12                        (match_3_reg12),
    .interval_intr12                          (interval_intr12),
    .match_intr12                             (match_intr12),
    .overflow_intr12                          (overflow_intr12)
    
  );

  ttc_interrupt_lite12 i_ttc_interrupt_lite12(

    //inputs12
    .n_p_reset12                           (n_p_reset12), 
    .pwdata12                              (pwdata12[5:0]),
    .pclk12                                (pclk12),
    .intr_en_reg_sel12                     (intr_en_reg_sel12), 
    .clear_interrupt12                     (clear_interrupt12),
    .interval_intr12                       (interval_intr12),
    .match_intr12                          (match_intr12),
    .overflow_intr12                       (overflow_intr12),
    .restart12                             (cntr_ctrl_reg12[4]),

    //outputs12
    .interrupt12                           (interrupt12),
    .interrupt_reg_out12                   (interrupt_reg12),
    .interrupt_en_out12                    (interrupt_en_reg12)
                       
  );


   
endmodule
