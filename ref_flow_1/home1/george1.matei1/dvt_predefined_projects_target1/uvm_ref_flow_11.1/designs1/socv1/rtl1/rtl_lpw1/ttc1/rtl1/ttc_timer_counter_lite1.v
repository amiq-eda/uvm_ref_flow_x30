//File1 name   : ttc_timer_counter_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : An1 instantiation1 of counter modules1.
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module1 definition1
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite1(

   //inputs1
   n_p_reset1,    
   pclk1,                         
   pwdata1,                              
   clk_ctrl_reg_sel1,
   cntr_ctrl_reg_sel1,
   interval_reg_sel1, 
   match_1_reg_sel1,
   match_2_reg_sel1,
   match_3_reg_sel1,
   intr_en_reg_sel1,
   clear_interrupt1,
                 
   //outputs1             
   clk_ctrl_reg1, 
   counter_val_reg1,
   cntr_ctrl_reg1,
   interval_reg1,
   match_1_reg1,
   match_2_reg1,
   match_3_reg1,
   interrupt1,
   interrupt_reg1,
   interrupt_en_reg1
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS1
//-----------------------------------------------------------------------------

   //inputs1
   input         n_p_reset1;            //reset signal1
   input         pclk1;                 //APB1 system clock1
   input [15:0]  pwdata1;               //16 Bit1 data signal1
   input         clk_ctrl_reg_sel1;     //Select1 clk_ctrl_reg1 from prescaler1
   input         cntr_ctrl_reg_sel1;    //Select1 control1 reg from counter.
   input         interval_reg_sel1;     //Select1 Interval1 reg from counter.
   input         match_1_reg_sel1;      //Select1 match_1_reg1 from counter. 
   input         match_2_reg_sel1;      //Select1 match_2_reg1 from counter.
   input         match_3_reg_sel1;      //Select1 match_3_reg1 from counter.
   input         intr_en_reg_sel1;      //Select1 interrupt1 register.
   input         clear_interrupt1;      //Clear interrupt1
   
   //Outputs1
   output [15:0]  counter_val_reg1;     //Counter1 value register from counter. 
   output [6:0]   clk_ctrl_reg1;        //Clock1 control1 reg from prescaler1.
   output [6:0]   cntr_ctrl_reg1;     //Counter1 control1 register 1.
   output [15:0]  interval_reg1;        //Interval1 register from counter.
   output [15:0]  match_1_reg1;         //Match1 1 register sent1 from counter. 
   output [15:0]  match_2_reg1;         //Match1 2 register sent1 from counter. 
   output [15:0]  match_3_reg1;         //Match1 3 register sent1 from counter. 
   output         interrupt1;
   output [5:0]   interrupt_reg1;
   output [5:0]   interrupt_en_reg1;
   
//-----------------------------------------------------------------------------
// Module1 Interconnect1
//-----------------------------------------------------------------------------

   wire count_en1;
   wire interval_intr1;          //Interval1 overflow1 interrupt1
   wire [3:1] match_intr1;       //Match1 interrupts1
   wire overflow_intr1;          //Overflow1 interupt1   
   wire [6:0] cntr_ctrl_reg1;    //Counter1 control1 register
   
//-----------------------------------------------------------------------------
// Module1 Instantiations1
//-----------------------------------------------------------------------------


    //outputs1

  ttc_count_rst_lite1 i_ttc_count_rst_lite1(

    //inputs1
    .n_p_reset1                              (n_p_reset1),   
    .pclk1                                   (pclk1),                             
    .pwdata1                                 (pwdata1[6:0]),
    .clk_ctrl_reg_sel1                       (clk_ctrl_reg_sel1),
    .restart1                                (cntr_ctrl_reg1[4]),
                         
    //outputs1        
    .count_en_out1                           (count_en1),                         
    .clk_ctrl_reg_out1                       (clk_ctrl_reg1)

  );


  ttc_counter_lite1 i_ttc_counter_lite1(

    //inputs1
    .n_p_reset1                              (n_p_reset1),  
    .pclk1                                   (pclk1),                          
    .pwdata1                                 (pwdata1),                           
    .count_en1                               (count_en1),
    .cntr_ctrl_reg_sel1                      (cntr_ctrl_reg_sel1), 
    .interval_reg_sel1                       (interval_reg_sel1),
    .match_1_reg_sel1                        (match_1_reg_sel1),
    .match_2_reg_sel1                        (match_2_reg_sel1),
    .match_3_reg_sel1                        (match_3_reg_sel1),

    //outputs1
    .count_val_out1                          (counter_val_reg1),
    .cntr_ctrl_reg_out1                      (cntr_ctrl_reg1),
    .interval_reg_out1                       (interval_reg1),
    .match_1_reg_out1                        (match_1_reg1),
    .match_2_reg_out1                        (match_2_reg1),
    .match_3_reg_out1                        (match_3_reg1),
    .interval_intr1                          (interval_intr1),
    .match_intr1                             (match_intr1),
    .overflow_intr1                          (overflow_intr1)
    
  );

  ttc_interrupt_lite1 i_ttc_interrupt_lite1(

    //inputs1
    .n_p_reset1                           (n_p_reset1), 
    .pwdata1                              (pwdata1[5:0]),
    .pclk1                                (pclk1),
    .intr_en_reg_sel1                     (intr_en_reg_sel1), 
    .clear_interrupt1                     (clear_interrupt1),
    .interval_intr1                       (interval_intr1),
    .match_intr1                          (match_intr1),
    .overflow_intr1                       (overflow_intr1),
    .restart1                             (cntr_ctrl_reg1[4]),

    //outputs1
    .interrupt1                           (interrupt1),
    .interrupt_reg_out1                   (interrupt_reg1),
    .interrupt_en_out1                    (interrupt_en_reg1)
                       
  );


   
endmodule
