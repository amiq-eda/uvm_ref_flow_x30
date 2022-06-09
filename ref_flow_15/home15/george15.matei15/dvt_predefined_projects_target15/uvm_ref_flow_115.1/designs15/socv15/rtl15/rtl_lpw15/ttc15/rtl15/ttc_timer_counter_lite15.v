//File15 name   : ttc_timer_counter_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : An15 instantiation15 of counter modules15.
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module15 definition15
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite15(

   //inputs15
   n_p_reset15,    
   pclk15,                         
   pwdata15,                              
   clk_ctrl_reg_sel15,
   cntr_ctrl_reg_sel15,
   interval_reg_sel15, 
   match_1_reg_sel15,
   match_2_reg_sel15,
   match_3_reg_sel15,
   intr_en_reg_sel15,
   clear_interrupt15,
                 
   //outputs15             
   clk_ctrl_reg15, 
   counter_val_reg15,
   cntr_ctrl_reg15,
   interval_reg15,
   match_1_reg15,
   match_2_reg15,
   match_3_reg15,
   interrupt15,
   interrupt_reg15,
   interrupt_en_reg15
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS15
//-----------------------------------------------------------------------------

   //inputs15
   input         n_p_reset15;            //reset signal15
   input         pclk15;                 //APB15 system clock15
   input [15:0]  pwdata15;               //16 Bit15 data signal15
   input         clk_ctrl_reg_sel15;     //Select15 clk_ctrl_reg15 from prescaler15
   input         cntr_ctrl_reg_sel15;    //Select15 control15 reg from counter.
   input         interval_reg_sel15;     //Select15 Interval15 reg from counter.
   input         match_1_reg_sel15;      //Select15 match_1_reg15 from counter. 
   input         match_2_reg_sel15;      //Select15 match_2_reg15 from counter.
   input         match_3_reg_sel15;      //Select15 match_3_reg15 from counter.
   input         intr_en_reg_sel15;      //Select15 interrupt15 register.
   input         clear_interrupt15;      //Clear interrupt15
   
   //Outputs15
   output [15:0]  counter_val_reg15;     //Counter15 value register from counter. 
   output [6:0]   clk_ctrl_reg15;        //Clock15 control15 reg from prescaler15.
   output [6:0]   cntr_ctrl_reg15;     //Counter15 control15 register 1.
   output [15:0]  interval_reg15;        //Interval15 register from counter.
   output [15:0]  match_1_reg15;         //Match15 1 register sent15 from counter. 
   output [15:0]  match_2_reg15;         //Match15 2 register sent15 from counter. 
   output [15:0]  match_3_reg15;         //Match15 3 register sent15 from counter. 
   output         interrupt15;
   output [5:0]   interrupt_reg15;
   output [5:0]   interrupt_en_reg15;
   
//-----------------------------------------------------------------------------
// Module15 Interconnect15
//-----------------------------------------------------------------------------

   wire count_en15;
   wire interval_intr15;          //Interval15 overflow15 interrupt15
   wire [3:1] match_intr15;       //Match15 interrupts15
   wire overflow_intr15;          //Overflow15 interupt15   
   wire [6:0] cntr_ctrl_reg15;    //Counter15 control15 register
   
//-----------------------------------------------------------------------------
// Module15 Instantiations15
//-----------------------------------------------------------------------------


    //outputs15

  ttc_count_rst_lite15 i_ttc_count_rst_lite15(

    //inputs15
    .n_p_reset15                              (n_p_reset15),   
    .pclk15                                   (pclk15),                             
    .pwdata15                                 (pwdata15[6:0]),
    .clk_ctrl_reg_sel15                       (clk_ctrl_reg_sel15),
    .restart15                                (cntr_ctrl_reg15[4]),
                         
    //outputs15        
    .count_en_out15                           (count_en15),                         
    .clk_ctrl_reg_out15                       (clk_ctrl_reg15)

  );


  ttc_counter_lite15 i_ttc_counter_lite15(

    //inputs15
    .n_p_reset15                              (n_p_reset15),  
    .pclk15                                   (pclk15),                          
    .pwdata15                                 (pwdata15),                           
    .count_en15                               (count_en15),
    .cntr_ctrl_reg_sel15                      (cntr_ctrl_reg_sel15), 
    .interval_reg_sel15                       (interval_reg_sel15),
    .match_1_reg_sel15                        (match_1_reg_sel15),
    .match_2_reg_sel15                        (match_2_reg_sel15),
    .match_3_reg_sel15                        (match_3_reg_sel15),

    //outputs15
    .count_val_out15                          (counter_val_reg15),
    .cntr_ctrl_reg_out15                      (cntr_ctrl_reg15),
    .interval_reg_out15                       (interval_reg15),
    .match_1_reg_out15                        (match_1_reg15),
    .match_2_reg_out15                        (match_2_reg15),
    .match_3_reg_out15                        (match_3_reg15),
    .interval_intr15                          (interval_intr15),
    .match_intr15                             (match_intr15),
    .overflow_intr15                          (overflow_intr15)
    
  );

  ttc_interrupt_lite15 i_ttc_interrupt_lite15(

    //inputs15
    .n_p_reset15                           (n_p_reset15), 
    .pwdata15                              (pwdata15[5:0]),
    .pclk15                                (pclk15),
    .intr_en_reg_sel15                     (intr_en_reg_sel15), 
    .clear_interrupt15                     (clear_interrupt15),
    .interval_intr15                       (interval_intr15),
    .match_intr15                          (match_intr15),
    .overflow_intr15                       (overflow_intr15),
    .restart15                             (cntr_ctrl_reg15[4]),

    //outputs15
    .interrupt15                           (interrupt15),
    .interrupt_reg_out15                   (interrupt_reg15),
    .interrupt_en_out15                    (interrupt_en_reg15)
                       
  );


   
endmodule
