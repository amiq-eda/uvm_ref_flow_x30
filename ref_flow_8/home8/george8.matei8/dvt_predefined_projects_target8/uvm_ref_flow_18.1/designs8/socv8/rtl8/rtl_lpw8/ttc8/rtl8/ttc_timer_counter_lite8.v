//File8 name   : ttc_timer_counter_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : An8 instantiation8 of counter modules8.
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module8 definition8
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite8(

   //inputs8
   n_p_reset8,    
   pclk8,                         
   pwdata8,                              
   clk_ctrl_reg_sel8,
   cntr_ctrl_reg_sel8,
   interval_reg_sel8, 
   match_1_reg_sel8,
   match_2_reg_sel8,
   match_3_reg_sel8,
   intr_en_reg_sel8,
   clear_interrupt8,
                 
   //outputs8             
   clk_ctrl_reg8, 
   counter_val_reg8,
   cntr_ctrl_reg8,
   interval_reg8,
   match_1_reg8,
   match_2_reg8,
   match_3_reg8,
   interrupt8,
   interrupt_reg8,
   interrupt_en_reg8
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS8
//-----------------------------------------------------------------------------

   //inputs8
   input         n_p_reset8;            //reset signal8
   input         pclk8;                 //APB8 system clock8
   input [15:0]  pwdata8;               //16 Bit8 data signal8
   input         clk_ctrl_reg_sel8;     //Select8 clk_ctrl_reg8 from prescaler8
   input         cntr_ctrl_reg_sel8;    //Select8 control8 reg from counter.
   input         interval_reg_sel8;     //Select8 Interval8 reg from counter.
   input         match_1_reg_sel8;      //Select8 match_1_reg8 from counter. 
   input         match_2_reg_sel8;      //Select8 match_2_reg8 from counter.
   input         match_3_reg_sel8;      //Select8 match_3_reg8 from counter.
   input         intr_en_reg_sel8;      //Select8 interrupt8 register.
   input         clear_interrupt8;      //Clear interrupt8
   
   //Outputs8
   output [15:0]  counter_val_reg8;     //Counter8 value register from counter. 
   output [6:0]   clk_ctrl_reg8;        //Clock8 control8 reg from prescaler8.
   output [6:0]   cntr_ctrl_reg8;     //Counter8 control8 register 1.
   output [15:0]  interval_reg8;        //Interval8 register from counter.
   output [15:0]  match_1_reg8;         //Match8 1 register sent8 from counter. 
   output [15:0]  match_2_reg8;         //Match8 2 register sent8 from counter. 
   output [15:0]  match_3_reg8;         //Match8 3 register sent8 from counter. 
   output         interrupt8;
   output [5:0]   interrupt_reg8;
   output [5:0]   interrupt_en_reg8;
   
//-----------------------------------------------------------------------------
// Module8 Interconnect8
//-----------------------------------------------------------------------------

   wire count_en8;
   wire interval_intr8;          //Interval8 overflow8 interrupt8
   wire [3:1] match_intr8;       //Match8 interrupts8
   wire overflow_intr8;          //Overflow8 interupt8   
   wire [6:0] cntr_ctrl_reg8;    //Counter8 control8 register
   
//-----------------------------------------------------------------------------
// Module8 Instantiations8
//-----------------------------------------------------------------------------


    //outputs8

  ttc_count_rst_lite8 i_ttc_count_rst_lite8(

    //inputs8
    .n_p_reset8                              (n_p_reset8),   
    .pclk8                                   (pclk8),                             
    .pwdata8                                 (pwdata8[6:0]),
    .clk_ctrl_reg_sel8                       (clk_ctrl_reg_sel8),
    .restart8                                (cntr_ctrl_reg8[4]),
                         
    //outputs8        
    .count_en_out8                           (count_en8),                         
    .clk_ctrl_reg_out8                       (clk_ctrl_reg8)

  );


  ttc_counter_lite8 i_ttc_counter_lite8(

    //inputs8
    .n_p_reset8                              (n_p_reset8),  
    .pclk8                                   (pclk8),                          
    .pwdata8                                 (pwdata8),                           
    .count_en8                               (count_en8),
    .cntr_ctrl_reg_sel8                      (cntr_ctrl_reg_sel8), 
    .interval_reg_sel8                       (interval_reg_sel8),
    .match_1_reg_sel8                        (match_1_reg_sel8),
    .match_2_reg_sel8                        (match_2_reg_sel8),
    .match_3_reg_sel8                        (match_3_reg_sel8),

    //outputs8
    .count_val_out8                          (counter_val_reg8),
    .cntr_ctrl_reg_out8                      (cntr_ctrl_reg8),
    .interval_reg_out8                       (interval_reg8),
    .match_1_reg_out8                        (match_1_reg8),
    .match_2_reg_out8                        (match_2_reg8),
    .match_3_reg_out8                        (match_3_reg8),
    .interval_intr8                          (interval_intr8),
    .match_intr8                             (match_intr8),
    .overflow_intr8                          (overflow_intr8)
    
  );

  ttc_interrupt_lite8 i_ttc_interrupt_lite8(

    //inputs8
    .n_p_reset8                           (n_p_reset8), 
    .pwdata8                              (pwdata8[5:0]),
    .pclk8                                (pclk8),
    .intr_en_reg_sel8                     (intr_en_reg_sel8), 
    .clear_interrupt8                     (clear_interrupt8),
    .interval_intr8                       (interval_intr8),
    .match_intr8                          (match_intr8),
    .overflow_intr8                       (overflow_intr8),
    .restart8                             (cntr_ctrl_reg8[4]),

    //outputs8
    .interrupt8                           (interrupt8),
    .interrupt_reg_out8                   (interrupt_reg8),
    .interrupt_en_out8                    (interrupt_en_reg8)
                       
  );


   
endmodule
