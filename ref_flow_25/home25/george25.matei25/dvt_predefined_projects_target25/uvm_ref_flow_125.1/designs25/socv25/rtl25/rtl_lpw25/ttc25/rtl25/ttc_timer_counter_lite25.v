//File25 name   : ttc_timer_counter_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : An25 instantiation25 of counter modules25.
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module25 definition25
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite25(

   //inputs25
   n_p_reset25,    
   pclk25,                         
   pwdata25,                              
   clk_ctrl_reg_sel25,
   cntr_ctrl_reg_sel25,
   interval_reg_sel25, 
   match_1_reg_sel25,
   match_2_reg_sel25,
   match_3_reg_sel25,
   intr_en_reg_sel25,
   clear_interrupt25,
                 
   //outputs25             
   clk_ctrl_reg25, 
   counter_val_reg25,
   cntr_ctrl_reg25,
   interval_reg25,
   match_1_reg25,
   match_2_reg25,
   match_3_reg25,
   interrupt25,
   interrupt_reg25,
   interrupt_en_reg25
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS25
//-----------------------------------------------------------------------------

   //inputs25
   input         n_p_reset25;            //reset signal25
   input         pclk25;                 //APB25 system clock25
   input [15:0]  pwdata25;               //16 Bit25 data signal25
   input         clk_ctrl_reg_sel25;     //Select25 clk_ctrl_reg25 from prescaler25
   input         cntr_ctrl_reg_sel25;    //Select25 control25 reg from counter.
   input         interval_reg_sel25;     //Select25 Interval25 reg from counter.
   input         match_1_reg_sel25;      //Select25 match_1_reg25 from counter. 
   input         match_2_reg_sel25;      //Select25 match_2_reg25 from counter.
   input         match_3_reg_sel25;      //Select25 match_3_reg25 from counter.
   input         intr_en_reg_sel25;      //Select25 interrupt25 register.
   input         clear_interrupt25;      //Clear interrupt25
   
   //Outputs25
   output [15:0]  counter_val_reg25;     //Counter25 value register from counter. 
   output [6:0]   clk_ctrl_reg25;        //Clock25 control25 reg from prescaler25.
   output [6:0]   cntr_ctrl_reg25;     //Counter25 control25 register 1.
   output [15:0]  interval_reg25;        //Interval25 register from counter.
   output [15:0]  match_1_reg25;         //Match25 1 register sent25 from counter. 
   output [15:0]  match_2_reg25;         //Match25 2 register sent25 from counter. 
   output [15:0]  match_3_reg25;         //Match25 3 register sent25 from counter. 
   output         interrupt25;
   output [5:0]   interrupt_reg25;
   output [5:0]   interrupt_en_reg25;
   
//-----------------------------------------------------------------------------
// Module25 Interconnect25
//-----------------------------------------------------------------------------

   wire count_en25;
   wire interval_intr25;          //Interval25 overflow25 interrupt25
   wire [3:1] match_intr25;       //Match25 interrupts25
   wire overflow_intr25;          //Overflow25 interupt25   
   wire [6:0] cntr_ctrl_reg25;    //Counter25 control25 register
   
//-----------------------------------------------------------------------------
// Module25 Instantiations25
//-----------------------------------------------------------------------------


    //outputs25

  ttc_count_rst_lite25 i_ttc_count_rst_lite25(

    //inputs25
    .n_p_reset25                              (n_p_reset25),   
    .pclk25                                   (pclk25),                             
    .pwdata25                                 (pwdata25[6:0]),
    .clk_ctrl_reg_sel25                       (clk_ctrl_reg_sel25),
    .restart25                                (cntr_ctrl_reg25[4]),
                         
    //outputs25        
    .count_en_out25                           (count_en25),                         
    .clk_ctrl_reg_out25                       (clk_ctrl_reg25)

  );


  ttc_counter_lite25 i_ttc_counter_lite25(

    //inputs25
    .n_p_reset25                              (n_p_reset25),  
    .pclk25                                   (pclk25),                          
    .pwdata25                                 (pwdata25),                           
    .count_en25                               (count_en25),
    .cntr_ctrl_reg_sel25                      (cntr_ctrl_reg_sel25), 
    .interval_reg_sel25                       (interval_reg_sel25),
    .match_1_reg_sel25                        (match_1_reg_sel25),
    .match_2_reg_sel25                        (match_2_reg_sel25),
    .match_3_reg_sel25                        (match_3_reg_sel25),

    //outputs25
    .count_val_out25                          (counter_val_reg25),
    .cntr_ctrl_reg_out25                      (cntr_ctrl_reg25),
    .interval_reg_out25                       (interval_reg25),
    .match_1_reg_out25                        (match_1_reg25),
    .match_2_reg_out25                        (match_2_reg25),
    .match_3_reg_out25                        (match_3_reg25),
    .interval_intr25                          (interval_intr25),
    .match_intr25                             (match_intr25),
    .overflow_intr25                          (overflow_intr25)
    
  );

  ttc_interrupt_lite25 i_ttc_interrupt_lite25(

    //inputs25
    .n_p_reset25                           (n_p_reset25), 
    .pwdata25                              (pwdata25[5:0]),
    .pclk25                                (pclk25),
    .intr_en_reg_sel25                     (intr_en_reg_sel25), 
    .clear_interrupt25                     (clear_interrupt25),
    .interval_intr25                       (interval_intr25),
    .match_intr25                          (match_intr25),
    .overflow_intr25                       (overflow_intr25),
    .restart25                             (cntr_ctrl_reg25[4]),

    //outputs25
    .interrupt25                           (interrupt25),
    .interrupt_reg_out25                   (interrupt_reg25),
    .interrupt_en_out25                    (interrupt_en_reg25)
                       
  );


   
endmodule
