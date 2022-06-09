//File20 name   : ttc_timer_counter_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : An20 instantiation20 of counter modules20.
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
 

//-----------------------------------------------------------------------------
// Module20 definition20
//-----------------------------------------------------------------------------

module ttc_timer_counter_lite20(

   //inputs20
   n_p_reset20,    
   pclk20,                         
   pwdata20,                              
   clk_ctrl_reg_sel20,
   cntr_ctrl_reg_sel20,
   interval_reg_sel20, 
   match_1_reg_sel20,
   match_2_reg_sel20,
   match_3_reg_sel20,
   intr_en_reg_sel20,
   clear_interrupt20,
                 
   //outputs20             
   clk_ctrl_reg20, 
   counter_val_reg20,
   cntr_ctrl_reg20,
   interval_reg20,
   match_1_reg20,
   match_2_reg20,
   match_3_reg20,
   interrupt20,
   interrupt_reg20,
   interrupt_en_reg20
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS20
//-----------------------------------------------------------------------------

   //inputs20
   input         n_p_reset20;            //reset signal20
   input         pclk20;                 //APB20 system clock20
   input [15:0]  pwdata20;               //16 Bit20 data signal20
   input         clk_ctrl_reg_sel20;     //Select20 clk_ctrl_reg20 from prescaler20
   input         cntr_ctrl_reg_sel20;    //Select20 control20 reg from counter.
   input         interval_reg_sel20;     //Select20 Interval20 reg from counter.
   input         match_1_reg_sel20;      //Select20 match_1_reg20 from counter. 
   input         match_2_reg_sel20;      //Select20 match_2_reg20 from counter.
   input         match_3_reg_sel20;      //Select20 match_3_reg20 from counter.
   input         intr_en_reg_sel20;      //Select20 interrupt20 register.
   input         clear_interrupt20;      //Clear interrupt20
   
   //Outputs20
   output [15:0]  counter_val_reg20;     //Counter20 value register from counter. 
   output [6:0]   clk_ctrl_reg20;        //Clock20 control20 reg from prescaler20.
   output [6:0]   cntr_ctrl_reg20;     //Counter20 control20 register 1.
   output [15:0]  interval_reg20;        //Interval20 register from counter.
   output [15:0]  match_1_reg20;         //Match20 1 register sent20 from counter. 
   output [15:0]  match_2_reg20;         //Match20 2 register sent20 from counter. 
   output [15:0]  match_3_reg20;         //Match20 3 register sent20 from counter. 
   output         interrupt20;
   output [5:0]   interrupt_reg20;
   output [5:0]   interrupt_en_reg20;
   
//-----------------------------------------------------------------------------
// Module20 Interconnect20
//-----------------------------------------------------------------------------

   wire count_en20;
   wire interval_intr20;          //Interval20 overflow20 interrupt20
   wire [3:1] match_intr20;       //Match20 interrupts20
   wire overflow_intr20;          //Overflow20 interupt20   
   wire [6:0] cntr_ctrl_reg20;    //Counter20 control20 register
   
//-----------------------------------------------------------------------------
// Module20 Instantiations20
//-----------------------------------------------------------------------------


    //outputs20

  ttc_count_rst_lite20 i_ttc_count_rst_lite20(

    //inputs20
    .n_p_reset20                              (n_p_reset20),   
    .pclk20                                   (pclk20),                             
    .pwdata20                                 (pwdata20[6:0]),
    .clk_ctrl_reg_sel20                       (clk_ctrl_reg_sel20),
    .restart20                                (cntr_ctrl_reg20[4]),
                         
    //outputs20        
    .count_en_out20                           (count_en20),                         
    .clk_ctrl_reg_out20                       (clk_ctrl_reg20)

  );


  ttc_counter_lite20 i_ttc_counter_lite20(

    //inputs20
    .n_p_reset20                              (n_p_reset20),  
    .pclk20                                   (pclk20),                          
    .pwdata20                                 (pwdata20),                           
    .count_en20                               (count_en20),
    .cntr_ctrl_reg_sel20                      (cntr_ctrl_reg_sel20), 
    .interval_reg_sel20                       (interval_reg_sel20),
    .match_1_reg_sel20                        (match_1_reg_sel20),
    .match_2_reg_sel20                        (match_2_reg_sel20),
    .match_3_reg_sel20                        (match_3_reg_sel20),

    //outputs20
    .count_val_out20                          (counter_val_reg20),
    .cntr_ctrl_reg_out20                      (cntr_ctrl_reg20),
    .interval_reg_out20                       (interval_reg20),
    .match_1_reg_out20                        (match_1_reg20),
    .match_2_reg_out20                        (match_2_reg20),
    .match_3_reg_out20                        (match_3_reg20),
    .interval_intr20                          (interval_intr20),
    .match_intr20                             (match_intr20),
    .overflow_intr20                          (overflow_intr20)
    
  );

  ttc_interrupt_lite20 i_ttc_interrupt_lite20(

    //inputs20
    .n_p_reset20                           (n_p_reset20), 
    .pwdata20                              (pwdata20[5:0]),
    .pclk20                                (pclk20),
    .intr_en_reg_sel20                     (intr_en_reg_sel20), 
    .clear_interrupt20                     (clear_interrupt20),
    .interval_intr20                       (interval_intr20),
    .match_intr20                          (match_intr20),
    .overflow_intr20                       (overflow_intr20),
    .restart20                             (cntr_ctrl_reg20[4]),

    //outputs20
    .interrupt20                           (interrupt20),
    .interrupt_reg_out20                   (interrupt_reg20),
    .interrupt_en_out20                    (interrupt_en_reg20)
                       
  );


   
endmodule
