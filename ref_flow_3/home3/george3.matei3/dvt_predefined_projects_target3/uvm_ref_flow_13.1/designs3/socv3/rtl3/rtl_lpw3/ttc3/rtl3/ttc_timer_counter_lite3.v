//File3 name   : ttc_timer_counter_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : An3 instantiation3 of counter modules3.
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module3 definition3
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite3(

   //inputs3
   n_p_reset3,    
   pclk3,                         
   pwdata3,                              
   clk_ctrl_reg_sel3,
   cntr_ctrl_reg_sel3,
   interval_reg_sel3, 
   match_1_reg_sel3,
   match_2_reg_sel3,
   match_3_reg_sel3,
   intr_en_reg_sel3,
   clear_interrupt3,
                 
   //outputs3             
   clk_ctrl_reg3, 
   counter_val_reg3,
   cntr_ctrl_reg3,
   interval_reg3,
   match_1_reg3,
   match_2_reg3,
   match_3_reg3,
   interrupt3,
   interrupt_reg3,
   interrupt_en_reg3
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS3
//-----------------------------------------------------------------------------

   //inputs3
   input         n_p_reset3;            //reset signal3
   input         pclk3;                 //APB3 system clock3
   input [15:0]  pwdata3;               //16 Bit3 data signal3
   input         clk_ctrl_reg_sel3;     //Select3 clk_ctrl_reg3 from prescaler3
   input         cntr_ctrl_reg_sel3;    //Select3 control3 reg from counter.
   input         interval_reg_sel3;     //Select3 Interval3 reg from counter.
   input         match_1_reg_sel3;      //Select3 match_1_reg3 from counter. 
   input         match_2_reg_sel3;      //Select3 match_2_reg3 from counter.
   input         match_3_reg_sel3;      //Select3 match_3_reg3 from counter.
   input         intr_en_reg_sel3;      //Select3 interrupt3 register.
   input         clear_interrupt3;      //Clear interrupt3
   
   //Outputs3
   output [15:0]  counter_val_reg3;     //Counter3 value register from counter. 
   output [6:0]   clk_ctrl_reg3;        //Clock3 control3 reg from prescaler3.
   output [6:0]   cntr_ctrl_reg3;     //Counter3 control3 register 1.
   output [15:0]  interval_reg3;        //Interval3 register from counter.
   output [15:0]  match_1_reg3;         //Match3 1 register sent3 from counter. 
   output [15:0]  match_2_reg3;         //Match3 2 register sent3 from counter. 
   output [15:0]  match_3_reg3;         //Match3 3 register sent3 from counter. 
   output         interrupt3;
   output [5:0]   interrupt_reg3;
   output [5:0]   interrupt_en_reg3;
   
//-----------------------------------------------------------------------------
// Module3 Interconnect3
//-----------------------------------------------------------------------------

   wire count_en3;
   wire interval_intr3;          //Interval3 overflow3 interrupt3
   wire [3:1] match_intr3;       //Match3 interrupts3
   wire overflow_intr3;          //Overflow3 interupt3   
   wire [6:0] cntr_ctrl_reg3;    //Counter3 control3 register
   
//-----------------------------------------------------------------------------
// Module3 Instantiations3
//-----------------------------------------------------------------------------


    //outputs3

  ttc_count_rst_lite3 i_ttc_count_rst_lite3(

    //inputs3
    .n_p_reset3                              (n_p_reset3),   
    .pclk3                                   (pclk3),                             
    .pwdata3                                 (pwdata3[6:0]),
    .clk_ctrl_reg_sel3                       (clk_ctrl_reg_sel3),
    .restart3                                (cntr_ctrl_reg3[4]),
                         
    //outputs3        
    .count_en_out3                           (count_en3),                         
    .clk_ctrl_reg_out3                       (clk_ctrl_reg3)

  );


  ttc_counter_lite3 i_ttc_counter_lite3(

    //inputs3
    .n_p_reset3                              (n_p_reset3),  
    .pclk3                                   (pclk3),                          
    .pwdata3                                 (pwdata3),                           
    .count_en3                               (count_en3),
    .cntr_ctrl_reg_sel3                      (cntr_ctrl_reg_sel3), 
    .interval_reg_sel3                       (interval_reg_sel3),
    .match_1_reg_sel3                        (match_1_reg_sel3),
    .match_2_reg_sel3                        (match_2_reg_sel3),
    .match_3_reg_sel3                        (match_3_reg_sel3),

    //outputs3
    .count_val_out3                          (counter_val_reg3),
    .cntr_ctrl_reg_out3                      (cntr_ctrl_reg3),
    .interval_reg_out3                       (interval_reg3),
    .match_1_reg_out3                        (match_1_reg3),
    .match_2_reg_out3                        (match_2_reg3),
    .match_3_reg_out3                        (match_3_reg3),
    .interval_intr3                          (interval_intr3),
    .match_intr3                             (match_intr3),
    .overflow_intr3                          (overflow_intr3)
    
  );

  ttc_interrupt_lite3 i_ttc_interrupt_lite3(

    //inputs3
    .n_p_reset3                           (n_p_reset3), 
    .pwdata3                              (pwdata3[5:0]),
    .pclk3                                (pclk3),
    .intr_en_reg_sel3                     (intr_en_reg_sel3), 
    .clear_interrupt3                     (clear_interrupt3),
    .interval_intr3                       (interval_intr3),
    .match_intr3                          (match_intr3),
    .overflow_intr3                       (overflow_intr3),
    .restart3                             (cntr_ctrl_reg3[4]),

    //outputs3
    .interrupt3                           (interrupt3),
    .interrupt_reg_out3                   (interrupt_reg3),
    .interrupt_en_out3                    (interrupt_en_reg3)
                       
  );


   
endmodule
