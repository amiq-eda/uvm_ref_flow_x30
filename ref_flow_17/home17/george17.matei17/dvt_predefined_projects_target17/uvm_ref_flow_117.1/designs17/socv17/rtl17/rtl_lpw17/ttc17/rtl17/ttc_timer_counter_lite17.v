//File17 name   : ttc_timer_counter_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : An17 instantiation17 of counter modules17.
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module17 definition17
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite17(

   //inputs17
   n_p_reset17,    
   pclk17,                         
   pwdata17,                              
   clk_ctrl_reg_sel17,
   cntr_ctrl_reg_sel17,
   interval_reg_sel17, 
   match_1_reg_sel17,
   match_2_reg_sel17,
   match_3_reg_sel17,
   intr_en_reg_sel17,
   clear_interrupt17,
                 
   //outputs17             
   clk_ctrl_reg17, 
   counter_val_reg17,
   cntr_ctrl_reg17,
   interval_reg17,
   match_1_reg17,
   match_2_reg17,
   match_3_reg17,
   interrupt17,
   interrupt_reg17,
   interrupt_en_reg17
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS17
//-----------------------------------------------------------------------------

   //inputs17
   input         n_p_reset17;            //reset signal17
   input         pclk17;                 //APB17 system clock17
   input [15:0]  pwdata17;               //16 Bit17 data signal17
   input         clk_ctrl_reg_sel17;     //Select17 clk_ctrl_reg17 from prescaler17
   input         cntr_ctrl_reg_sel17;    //Select17 control17 reg from counter.
   input         interval_reg_sel17;     //Select17 Interval17 reg from counter.
   input         match_1_reg_sel17;      //Select17 match_1_reg17 from counter. 
   input         match_2_reg_sel17;      //Select17 match_2_reg17 from counter.
   input         match_3_reg_sel17;      //Select17 match_3_reg17 from counter.
   input         intr_en_reg_sel17;      //Select17 interrupt17 register.
   input         clear_interrupt17;      //Clear interrupt17
   
   //Outputs17
   output [15:0]  counter_val_reg17;     //Counter17 value register from counter. 
   output [6:0]   clk_ctrl_reg17;        //Clock17 control17 reg from prescaler17.
   output [6:0]   cntr_ctrl_reg17;     //Counter17 control17 register 1.
   output [15:0]  interval_reg17;        //Interval17 register from counter.
   output [15:0]  match_1_reg17;         //Match17 1 register sent17 from counter. 
   output [15:0]  match_2_reg17;         //Match17 2 register sent17 from counter. 
   output [15:0]  match_3_reg17;         //Match17 3 register sent17 from counter. 
   output         interrupt17;
   output [5:0]   interrupt_reg17;
   output [5:0]   interrupt_en_reg17;
   
//-----------------------------------------------------------------------------
// Module17 Interconnect17
//-----------------------------------------------------------------------------

   wire count_en17;
   wire interval_intr17;          //Interval17 overflow17 interrupt17
   wire [3:1] match_intr17;       //Match17 interrupts17
   wire overflow_intr17;          //Overflow17 interupt17   
   wire [6:0] cntr_ctrl_reg17;    //Counter17 control17 register
   
//-----------------------------------------------------------------------------
// Module17 Instantiations17
//-----------------------------------------------------------------------------


    //outputs17

  ttc_count_rst_lite17 i_ttc_count_rst_lite17(

    //inputs17
    .n_p_reset17                              (n_p_reset17),   
    .pclk17                                   (pclk17),                             
    .pwdata17                                 (pwdata17[6:0]),
    .clk_ctrl_reg_sel17                       (clk_ctrl_reg_sel17),
    .restart17                                (cntr_ctrl_reg17[4]),
                         
    //outputs17        
    .count_en_out17                           (count_en17),                         
    .clk_ctrl_reg_out17                       (clk_ctrl_reg17)

  );


  ttc_counter_lite17 i_ttc_counter_lite17(

    //inputs17
    .n_p_reset17                              (n_p_reset17),  
    .pclk17                                   (pclk17),                          
    .pwdata17                                 (pwdata17),                           
    .count_en17                               (count_en17),
    .cntr_ctrl_reg_sel17                      (cntr_ctrl_reg_sel17), 
    .interval_reg_sel17                       (interval_reg_sel17),
    .match_1_reg_sel17                        (match_1_reg_sel17),
    .match_2_reg_sel17                        (match_2_reg_sel17),
    .match_3_reg_sel17                        (match_3_reg_sel17),

    //outputs17
    .count_val_out17                          (counter_val_reg17),
    .cntr_ctrl_reg_out17                      (cntr_ctrl_reg17),
    .interval_reg_out17                       (interval_reg17),
    .match_1_reg_out17                        (match_1_reg17),
    .match_2_reg_out17                        (match_2_reg17),
    .match_3_reg_out17                        (match_3_reg17),
    .interval_intr17                          (interval_intr17),
    .match_intr17                             (match_intr17),
    .overflow_intr17                          (overflow_intr17)
    
  );

  ttc_interrupt_lite17 i_ttc_interrupt_lite17(

    //inputs17
    .n_p_reset17                           (n_p_reset17), 
    .pwdata17                              (pwdata17[5:0]),
    .pclk17                                (pclk17),
    .intr_en_reg_sel17                     (intr_en_reg_sel17), 
    .clear_interrupt17                     (clear_interrupt17),
    .interval_intr17                       (interval_intr17),
    .match_intr17                          (match_intr17),
    .overflow_intr17                       (overflow_intr17),
    .restart17                             (cntr_ctrl_reg17[4]),

    //outputs17
    .interrupt17                           (interrupt17),
    .interrupt_reg_out17                   (interrupt_reg17),
    .interrupt_en_out17                    (interrupt_en_reg17)
                       
  );


   
endmodule
