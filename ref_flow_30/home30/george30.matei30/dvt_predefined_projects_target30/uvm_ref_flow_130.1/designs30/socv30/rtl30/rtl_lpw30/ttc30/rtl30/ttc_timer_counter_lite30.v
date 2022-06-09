//File30 name   : ttc_timer_counter_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : An30 instantiation30 of counter modules30.
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module30 definition30
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite30(

   //inputs30
   n_p_reset30,    
   pclk30,                         
   pwdata30,                              
   clk_ctrl_reg_sel30,
   cntr_ctrl_reg_sel30,
   interval_reg_sel30, 
   match_1_reg_sel30,
   match_2_reg_sel30,
   match_3_reg_sel30,
   intr_en_reg_sel30,
   clear_interrupt30,
                 
   //outputs30             
   clk_ctrl_reg30, 
   counter_val_reg30,
   cntr_ctrl_reg30,
   interval_reg30,
   match_1_reg30,
   match_2_reg30,
   match_3_reg30,
   interrupt30,
   interrupt_reg30,
   interrupt_en_reg30
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS30
//-----------------------------------------------------------------------------

   //inputs30
   input         n_p_reset30;            //reset signal30
   input         pclk30;                 //APB30 system clock30
   input [15:0]  pwdata30;               //16 Bit30 data signal30
   input         clk_ctrl_reg_sel30;     //Select30 clk_ctrl_reg30 from prescaler30
   input         cntr_ctrl_reg_sel30;    //Select30 control30 reg from counter.
   input         interval_reg_sel30;     //Select30 Interval30 reg from counter.
   input         match_1_reg_sel30;      //Select30 match_1_reg30 from counter. 
   input         match_2_reg_sel30;      //Select30 match_2_reg30 from counter.
   input         match_3_reg_sel30;      //Select30 match_3_reg30 from counter.
   input         intr_en_reg_sel30;      //Select30 interrupt30 register.
   input         clear_interrupt30;      //Clear interrupt30
   
   //Outputs30
   output [15:0]  counter_val_reg30;     //Counter30 value register from counter. 
   output [6:0]   clk_ctrl_reg30;        //Clock30 control30 reg from prescaler30.
   output [6:0]   cntr_ctrl_reg30;     //Counter30 control30 register 1.
   output [15:0]  interval_reg30;        //Interval30 register from counter.
   output [15:0]  match_1_reg30;         //Match30 1 register sent30 from counter. 
   output [15:0]  match_2_reg30;         //Match30 2 register sent30 from counter. 
   output [15:0]  match_3_reg30;         //Match30 3 register sent30 from counter. 
   output         interrupt30;
   output [5:0]   interrupt_reg30;
   output [5:0]   interrupt_en_reg30;
   
//-----------------------------------------------------------------------------
// Module30 Interconnect30
//-----------------------------------------------------------------------------

   wire count_en30;
   wire interval_intr30;          //Interval30 overflow30 interrupt30
   wire [3:1] match_intr30;       //Match30 interrupts30
   wire overflow_intr30;          //Overflow30 interupt30   
   wire [6:0] cntr_ctrl_reg30;    //Counter30 control30 register
   
//-----------------------------------------------------------------------------
// Module30 Instantiations30
//-----------------------------------------------------------------------------


    //outputs30

  ttc_count_rst_lite30 i_ttc_count_rst_lite30(

    //inputs30
    .n_p_reset30                              (n_p_reset30),   
    .pclk30                                   (pclk30),                             
    .pwdata30                                 (pwdata30[6:0]),
    .clk_ctrl_reg_sel30                       (clk_ctrl_reg_sel30),
    .restart30                                (cntr_ctrl_reg30[4]),
                         
    //outputs30        
    .count_en_out30                           (count_en30),                         
    .clk_ctrl_reg_out30                       (clk_ctrl_reg30)

  );


  ttc_counter_lite30 i_ttc_counter_lite30(

    //inputs30
    .n_p_reset30                              (n_p_reset30),  
    .pclk30                                   (pclk30),                          
    .pwdata30                                 (pwdata30),                           
    .count_en30                               (count_en30),
    .cntr_ctrl_reg_sel30                      (cntr_ctrl_reg_sel30), 
    .interval_reg_sel30                       (interval_reg_sel30),
    .match_1_reg_sel30                        (match_1_reg_sel30),
    .match_2_reg_sel30                        (match_2_reg_sel30),
    .match_3_reg_sel30                        (match_3_reg_sel30),

    //outputs30
    .count_val_out30                          (counter_val_reg30),
    .cntr_ctrl_reg_out30                      (cntr_ctrl_reg30),
    .interval_reg_out30                       (interval_reg30),
    .match_1_reg_out30                        (match_1_reg30),
    .match_2_reg_out30                        (match_2_reg30),
    .match_3_reg_out30                        (match_3_reg30),
    .interval_intr30                          (interval_intr30),
    .match_intr30                             (match_intr30),
    .overflow_intr30                          (overflow_intr30)
    
  );

  ttc_interrupt_lite30 i_ttc_interrupt_lite30(

    //inputs30
    .n_p_reset30                           (n_p_reset30), 
    .pwdata30                              (pwdata30[5:0]),
    .pclk30                                (pclk30),
    .intr_en_reg_sel30                     (intr_en_reg_sel30), 
    .clear_interrupt30                     (clear_interrupt30),
    .interval_intr30                       (interval_intr30),
    .match_intr30                          (match_intr30),
    .overflow_intr30                       (overflow_intr30),
    .restart30                             (cntr_ctrl_reg30[4]),

    //outputs30
    .interrupt30                           (interrupt30),
    .interrupt_reg_out30                   (interrupt_reg30),
    .interrupt_en_out30                    (interrupt_en_reg30)
                       
  );


   
endmodule
