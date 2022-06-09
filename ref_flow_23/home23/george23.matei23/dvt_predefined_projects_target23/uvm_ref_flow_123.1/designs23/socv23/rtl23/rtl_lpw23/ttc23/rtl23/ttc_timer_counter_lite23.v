//File23 name   : ttc_timer_counter_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : An23 instantiation23 of counter modules23.
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module23 definition23
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite23(

   //inputs23
   n_p_reset23,    
   pclk23,                         
   pwdata23,                              
   clk_ctrl_reg_sel23,
   cntr_ctrl_reg_sel23,
   interval_reg_sel23, 
   match_1_reg_sel23,
   match_2_reg_sel23,
   match_3_reg_sel23,
   intr_en_reg_sel23,
   clear_interrupt23,
                 
   //outputs23             
   clk_ctrl_reg23, 
   counter_val_reg23,
   cntr_ctrl_reg23,
   interval_reg23,
   match_1_reg23,
   match_2_reg23,
   match_3_reg23,
   interrupt23,
   interrupt_reg23,
   interrupt_en_reg23
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS23
//-----------------------------------------------------------------------------

   //inputs23
   input         n_p_reset23;            //reset signal23
   input         pclk23;                 //APB23 system clock23
   input [15:0]  pwdata23;               //16 Bit23 data signal23
   input         clk_ctrl_reg_sel23;     //Select23 clk_ctrl_reg23 from prescaler23
   input         cntr_ctrl_reg_sel23;    //Select23 control23 reg from counter.
   input         interval_reg_sel23;     //Select23 Interval23 reg from counter.
   input         match_1_reg_sel23;      //Select23 match_1_reg23 from counter. 
   input         match_2_reg_sel23;      //Select23 match_2_reg23 from counter.
   input         match_3_reg_sel23;      //Select23 match_3_reg23 from counter.
   input         intr_en_reg_sel23;      //Select23 interrupt23 register.
   input         clear_interrupt23;      //Clear interrupt23
   
   //Outputs23
   output [15:0]  counter_val_reg23;     //Counter23 value register from counter. 
   output [6:0]   clk_ctrl_reg23;        //Clock23 control23 reg from prescaler23.
   output [6:0]   cntr_ctrl_reg23;     //Counter23 control23 register 1.
   output [15:0]  interval_reg23;        //Interval23 register from counter.
   output [15:0]  match_1_reg23;         //Match23 1 register sent23 from counter. 
   output [15:0]  match_2_reg23;         //Match23 2 register sent23 from counter. 
   output [15:0]  match_3_reg23;         //Match23 3 register sent23 from counter. 
   output         interrupt23;
   output [5:0]   interrupt_reg23;
   output [5:0]   interrupt_en_reg23;
   
//-----------------------------------------------------------------------------
// Module23 Interconnect23
//-----------------------------------------------------------------------------

   wire count_en23;
   wire interval_intr23;          //Interval23 overflow23 interrupt23
   wire [3:1] match_intr23;       //Match23 interrupts23
   wire overflow_intr23;          //Overflow23 interupt23   
   wire [6:0] cntr_ctrl_reg23;    //Counter23 control23 register
   
//-----------------------------------------------------------------------------
// Module23 Instantiations23
//-----------------------------------------------------------------------------


    //outputs23

  ttc_count_rst_lite23 i_ttc_count_rst_lite23(

    //inputs23
    .n_p_reset23                              (n_p_reset23),   
    .pclk23                                   (pclk23),                             
    .pwdata23                                 (pwdata23[6:0]),
    .clk_ctrl_reg_sel23                       (clk_ctrl_reg_sel23),
    .restart23                                (cntr_ctrl_reg23[4]),
                         
    //outputs23        
    .count_en_out23                           (count_en23),                         
    .clk_ctrl_reg_out23                       (clk_ctrl_reg23)

  );


  ttc_counter_lite23 i_ttc_counter_lite23(

    //inputs23
    .n_p_reset23                              (n_p_reset23),  
    .pclk23                                   (pclk23),                          
    .pwdata23                                 (pwdata23),                           
    .count_en23                               (count_en23),
    .cntr_ctrl_reg_sel23                      (cntr_ctrl_reg_sel23), 
    .interval_reg_sel23                       (interval_reg_sel23),
    .match_1_reg_sel23                        (match_1_reg_sel23),
    .match_2_reg_sel23                        (match_2_reg_sel23),
    .match_3_reg_sel23                        (match_3_reg_sel23),

    //outputs23
    .count_val_out23                          (counter_val_reg23),
    .cntr_ctrl_reg_out23                      (cntr_ctrl_reg23),
    .interval_reg_out23                       (interval_reg23),
    .match_1_reg_out23                        (match_1_reg23),
    .match_2_reg_out23                        (match_2_reg23),
    .match_3_reg_out23                        (match_3_reg23),
    .interval_intr23                          (interval_intr23),
    .match_intr23                             (match_intr23),
    .overflow_intr23                          (overflow_intr23)
    
  );

  ttc_interrupt_lite23 i_ttc_interrupt_lite23(

    //inputs23
    .n_p_reset23                           (n_p_reset23), 
    .pwdata23                              (pwdata23[5:0]),
    .pclk23                                (pclk23),
    .intr_en_reg_sel23                     (intr_en_reg_sel23), 
    .clear_interrupt23                     (clear_interrupt23),
    .interval_intr23                       (interval_intr23),
    .match_intr23                          (match_intr23),
    .overflow_intr23                       (overflow_intr23),
    .restart23                             (cntr_ctrl_reg23[4]),

    //outputs23
    .interrupt23                           (interrupt23),
    .interrupt_reg_out23                   (interrupt_reg23),
    .interrupt_en_out23                    (interrupt_en_reg23)
                       
  );


   
endmodule
