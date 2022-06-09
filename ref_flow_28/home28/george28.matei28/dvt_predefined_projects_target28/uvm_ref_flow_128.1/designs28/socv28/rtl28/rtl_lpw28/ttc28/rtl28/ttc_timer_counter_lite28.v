//File28 name   : ttc_timer_counter_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : An28 instantiation28 of counter modules28.
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module28 definition28
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite28(

   //inputs28
   n_p_reset28,    
   pclk28,                         
   pwdata28,                              
   clk_ctrl_reg_sel28,
   cntr_ctrl_reg_sel28,
   interval_reg_sel28, 
   match_1_reg_sel28,
   match_2_reg_sel28,
   match_3_reg_sel28,
   intr_en_reg_sel28,
   clear_interrupt28,
                 
   //outputs28             
   clk_ctrl_reg28, 
   counter_val_reg28,
   cntr_ctrl_reg28,
   interval_reg28,
   match_1_reg28,
   match_2_reg28,
   match_3_reg28,
   interrupt28,
   interrupt_reg28,
   interrupt_en_reg28
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS28
//-----------------------------------------------------------------------------

   //inputs28
   input         n_p_reset28;            //reset signal28
   input         pclk28;                 //APB28 system clock28
   input [15:0]  pwdata28;               //16 Bit28 data signal28
   input         clk_ctrl_reg_sel28;     //Select28 clk_ctrl_reg28 from prescaler28
   input         cntr_ctrl_reg_sel28;    //Select28 control28 reg from counter.
   input         interval_reg_sel28;     //Select28 Interval28 reg from counter.
   input         match_1_reg_sel28;      //Select28 match_1_reg28 from counter. 
   input         match_2_reg_sel28;      //Select28 match_2_reg28 from counter.
   input         match_3_reg_sel28;      //Select28 match_3_reg28 from counter.
   input         intr_en_reg_sel28;      //Select28 interrupt28 register.
   input         clear_interrupt28;      //Clear interrupt28
   
   //Outputs28
   output [15:0]  counter_val_reg28;     //Counter28 value register from counter. 
   output [6:0]   clk_ctrl_reg28;        //Clock28 control28 reg from prescaler28.
   output [6:0]   cntr_ctrl_reg28;     //Counter28 control28 register 1.
   output [15:0]  interval_reg28;        //Interval28 register from counter.
   output [15:0]  match_1_reg28;         //Match28 1 register sent28 from counter. 
   output [15:0]  match_2_reg28;         //Match28 2 register sent28 from counter. 
   output [15:0]  match_3_reg28;         //Match28 3 register sent28 from counter. 
   output         interrupt28;
   output [5:0]   interrupt_reg28;
   output [5:0]   interrupt_en_reg28;
   
//-----------------------------------------------------------------------------
// Module28 Interconnect28
//-----------------------------------------------------------------------------

   wire count_en28;
   wire interval_intr28;          //Interval28 overflow28 interrupt28
   wire [3:1] match_intr28;       //Match28 interrupts28
   wire overflow_intr28;          //Overflow28 interupt28   
   wire [6:0] cntr_ctrl_reg28;    //Counter28 control28 register
   
//-----------------------------------------------------------------------------
// Module28 Instantiations28
//-----------------------------------------------------------------------------


    //outputs28

  ttc_count_rst_lite28 i_ttc_count_rst_lite28(

    //inputs28
    .n_p_reset28                              (n_p_reset28),   
    .pclk28                                   (pclk28),                             
    .pwdata28                                 (pwdata28[6:0]),
    .clk_ctrl_reg_sel28                       (clk_ctrl_reg_sel28),
    .restart28                                (cntr_ctrl_reg28[4]),
                         
    //outputs28        
    .count_en_out28                           (count_en28),                         
    .clk_ctrl_reg_out28                       (clk_ctrl_reg28)

  );


  ttc_counter_lite28 i_ttc_counter_lite28(

    //inputs28
    .n_p_reset28                              (n_p_reset28),  
    .pclk28                                   (pclk28),                          
    .pwdata28                                 (pwdata28),                           
    .count_en28                               (count_en28),
    .cntr_ctrl_reg_sel28                      (cntr_ctrl_reg_sel28), 
    .interval_reg_sel28                       (interval_reg_sel28),
    .match_1_reg_sel28                        (match_1_reg_sel28),
    .match_2_reg_sel28                        (match_2_reg_sel28),
    .match_3_reg_sel28                        (match_3_reg_sel28),

    //outputs28
    .count_val_out28                          (counter_val_reg28),
    .cntr_ctrl_reg_out28                      (cntr_ctrl_reg28),
    .interval_reg_out28                       (interval_reg28),
    .match_1_reg_out28                        (match_1_reg28),
    .match_2_reg_out28                        (match_2_reg28),
    .match_3_reg_out28                        (match_3_reg28),
    .interval_intr28                          (interval_intr28),
    .match_intr28                             (match_intr28),
    .overflow_intr28                          (overflow_intr28)
    
  );

  ttc_interrupt_lite28 i_ttc_interrupt_lite28(

    //inputs28
    .n_p_reset28                           (n_p_reset28), 
    .pwdata28                              (pwdata28[5:0]),
    .pclk28                                (pclk28),
    .intr_en_reg_sel28                     (intr_en_reg_sel28), 
    .clear_interrupt28                     (clear_interrupt28),
    .interval_intr28                       (interval_intr28),
    .match_intr28                          (match_intr28),
    .overflow_intr28                       (overflow_intr28),
    .restart28                             (cntr_ctrl_reg28[4]),

    //outputs28
    .interrupt28                           (interrupt28),
    .interrupt_reg_out28                   (interrupt_reg28),
    .interrupt_en_out28                    (interrupt_en_reg28)
                       
  );


   
endmodule
