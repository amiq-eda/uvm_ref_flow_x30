//File26 name   : ttc_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : The top level of the Triple26 Timer26 Counter26.
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module26 definition26
//-----------------------------------------------------------------------------

module ttc_lite26(
           
           //inputs26
           n_p_reset26,
           pclk26,
           psel26,
           penable26,
           pwrite26,
           pwdata26,
           paddr26,
           scan_in26,
           scan_en26,

           //outputs26
           prdata26,
           interrupt26,
           scan_out26           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS26
//-----------------------------------------------------------------------------

   input         n_p_reset26;              //System26 Reset26
   input         pclk26;                 //System26 clock26
   input         psel26;                 //Select26 line
   input         penable26;              //Enable26
   input         pwrite26;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata26;               //Write data
   input [7:0]   paddr26;                //Address Bus26 register
   input         scan_in26;              //Scan26 chain26 input port
   input         scan_en26;              //Scan26 chain26 enable port
   
   output [31:0] prdata26;               //Read Data from the APB26 Interface26
   output [3:1]  interrupt26;            //Interrupt26 from PCI26 
   output        scan_out26;             //Scan26 chain26 output port

//-----------------------------------------------------------------------------
// Module26 Interconnect26
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int26;
   wire        clk_ctrl_reg_sel_126;     //Module26 1 clock26 control26 select26
   wire        clk_ctrl_reg_sel_226;     //Module26 2 clock26 control26 select26
   wire        clk_ctrl_reg_sel_326;     //Module26 3 clock26 control26 select26
   wire        cntr_ctrl_reg_sel_126;    //Module26 1 counter control26 select26
   wire        cntr_ctrl_reg_sel_226;    //Module26 2 counter control26 select26
   wire        cntr_ctrl_reg_sel_326;    //Module26 3 counter control26 select26
   wire        interval_reg_sel_126;     //Interval26 1 register select26
   wire        interval_reg_sel_226;     //Interval26 2 register select26
   wire        interval_reg_sel_326;     //Interval26 3 register select26
   wire        match_1_reg_sel_126;      //Module26 1 match 1 select26
   wire        match_1_reg_sel_226;      //Module26 1 match 2 select26
   wire        match_1_reg_sel_326;      //Module26 1 match 3 select26
   wire        match_2_reg_sel_126;      //Module26 2 match 1 select26
   wire        match_2_reg_sel_226;      //Module26 2 match 2 select26
   wire        match_2_reg_sel_326;      //Module26 2 match 3 select26
   wire        match_3_reg_sel_126;      //Module26 3 match 1 select26
   wire        match_3_reg_sel_226;      //Module26 3 match 2 select26
   wire        match_3_reg_sel_326;      //Module26 3 match 3 select26
   wire [3:1]  intr_en_reg_sel26;        //Interrupt26 enable register select26
   wire [3:1]  clear_interrupt26;        //Clear interrupt26 signal26
   wire [5:0]  interrupt_reg_126;        //Interrupt26 register 1
   wire [5:0]  interrupt_reg_226;        //Interrupt26 register 2
   wire [5:0]  interrupt_reg_326;        //Interrupt26 register 3 
   wire [5:0]  interrupt_en_reg_126;     //Interrupt26 enable register 1
   wire [5:0]  interrupt_en_reg_226;     //Interrupt26 enable register 2
   wire [5:0]  interrupt_en_reg_326;     //Interrupt26 enable register 3
   wire [6:0]  clk_ctrl_reg_126;         //Clock26 control26 regs for the 
   wire [6:0]  clk_ctrl_reg_226;         //Timer_Counter26 1,2,3
   wire [6:0]  clk_ctrl_reg_326;         //Value of the clock26 frequency26
   wire [15:0] counter_val_reg_126;      //Module26 1 counter value 
   wire [15:0] counter_val_reg_226;      //Module26 2 counter value 
   wire [15:0] counter_val_reg_326;      //Module26 3 counter value 
   wire [6:0]  cntr_ctrl_reg_126;        //Module26 1 counter control26  
   wire [6:0]  cntr_ctrl_reg_226;        //Module26 2 counter control26  
   wire [6:0]  cntr_ctrl_reg_326;        //Module26 3 counter control26  
   wire [15:0] interval_reg_126;         //Module26 1 interval26 register
   wire [15:0] interval_reg_226;         //Module26 2 interval26 register
   wire [15:0] interval_reg_326;         //Module26 3 interval26 register
   wire [15:0] match_1_reg_126;          //Module26 1 match 1 register
   wire [15:0] match_1_reg_226;          //Module26 1 match 2 register
   wire [15:0] match_1_reg_326;          //Module26 1 match 3 register
   wire [15:0] match_2_reg_126;          //Module26 2 match 1 register
   wire [15:0] match_2_reg_226;          //Module26 2 match 2 register
   wire [15:0] match_2_reg_326;          //Module26 2 match 3 register
   wire [15:0] match_3_reg_126;          //Module26 3 match 1 register
   wire [15:0] match_3_reg_226;          //Module26 3 match 2 register
   wire [15:0] match_3_reg_326;          //Module26 3 match 3 register

  assign interrupt26 = TTC_int26;   // Bug26 Fix26 for floating26 ints - Santhosh26 8 Nov26 06
   

//-----------------------------------------------------------------------------
// Module26 Instantiations26
//-----------------------------------------------------------------------------


  ttc_interface_lite26 i_ttc_interface_lite26 ( 

    //inputs26
    .n_p_reset26                           (n_p_reset26),
    .pclk26                                (pclk26),
    .psel26                                (psel26),
    .penable26                             (penable26),
    .pwrite26                              (pwrite26),
    .paddr26                               (paddr26),
    .clk_ctrl_reg_126                      (clk_ctrl_reg_126),
    .clk_ctrl_reg_226                      (clk_ctrl_reg_226),
    .clk_ctrl_reg_326                      (clk_ctrl_reg_326),
    .cntr_ctrl_reg_126                     (cntr_ctrl_reg_126),
    .cntr_ctrl_reg_226                     (cntr_ctrl_reg_226),
    .cntr_ctrl_reg_326                     (cntr_ctrl_reg_326),
    .counter_val_reg_126                   (counter_val_reg_126),
    .counter_val_reg_226                   (counter_val_reg_226),
    .counter_val_reg_326                   (counter_val_reg_326),
    .interval_reg_126                      (interval_reg_126),
    .match_1_reg_126                       (match_1_reg_126),
    .match_2_reg_126                       (match_2_reg_126),
    .match_3_reg_126                       (match_3_reg_126),
    .interval_reg_226                      (interval_reg_226),
    .match_1_reg_226                       (match_1_reg_226),
    .match_2_reg_226                       (match_2_reg_226),
    .match_3_reg_226                       (match_3_reg_226),
    .interval_reg_326                      (interval_reg_326),
    .match_1_reg_326                       (match_1_reg_326),
    .match_2_reg_326                       (match_2_reg_326),
    .match_3_reg_326                       (match_3_reg_326),
    .interrupt_reg_126                     (interrupt_reg_126),
    .interrupt_reg_226                     (interrupt_reg_226),
    .interrupt_reg_326                     (interrupt_reg_326), 
    .interrupt_en_reg_126                  (interrupt_en_reg_126),
    .interrupt_en_reg_226                  (interrupt_en_reg_226),
    .interrupt_en_reg_326                  (interrupt_en_reg_326), 

    //outputs26
    .prdata26                              (prdata26),
    .clk_ctrl_reg_sel_126                  (clk_ctrl_reg_sel_126),
    .clk_ctrl_reg_sel_226                  (clk_ctrl_reg_sel_226),
    .clk_ctrl_reg_sel_326                  (clk_ctrl_reg_sel_326),
    .cntr_ctrl_reg_sel_126                 (cntr_ctrl_reg_sel_126),
    .cntr_ctrl_reg_sel_226                 (cntr_ctrl_reg_sel_226),
    .cntr_ctrl_reg_sel_326                 (cntr_ctrl_reg_sel_326),
    .interval_reg_sel_126                  (interval_reg_sel_126),  
    .interval_reg_sel_226                  (interval_reg_sel_226), 
    .interval_reg_sel_326                  (interval_reg_sel_326),
    .match_1_reg_sel_126                   (match_1_reg_sel_126),     
    .match_1_reg_sel_226                   (match_1_reg_sel_226),
    .match_1_reg_sel_326                   (match_1_reg_sel_326),                
    .match_2_reg_sel_126                   (match_2_reg_sel_126),
    .match_2_reg_sel_226                   (match_2_reg_sel_226),
    .match_2_reg_sel_326                   (match_2_reg_sel_326),
    .match_3_reg_sel_126                   (match_3_reg_sel_126),
    .match_3_reg_sel_226                   (match_3_reg_sel_226),
    .match_3_reg_sel_326                   (match_3_reg_sel_326),
    .intr_en_reg_sel26                     (intr_en_reg_sel26),
    .clear_interrupt26                     (clear_interrupt26)

  );


   

  ttc_timer_counter_lite26 i_ttc_timer_counter_lite_126 ( 

    //inputs26
    .n_p_reset26                           (n_p_reset26),
    .pclk26                                (pclk26), 
    .pwdata26                              (pwdata26[15:0]),
    .clk_ctrl_reg_sel26                    (clk_ctrl_reg_sel_126),
    .cntr_ctrl_reg_sel26                   (cntr_ctrl_reg_sel_126),
    .interval_reg_sel26                    (interval_reg_sel_126),
    .match_1_reg_sel26                     (match_1_reg_sel_126),
    .match_2_reg_sel26                     (match_2_reg_sel_126),
    .match_3_reg_sel26                     (match_3_reg_sel_126),
    .intr_en_reg_sel26                     (intr_en_reg_sel26[1]),
    .clear_interrupt26                     (clear_interrupt26[1]),
                                  
    //outputs26
    .clk_ctrl_reg26                        (clk_ctrl_reg_126),
    .counter_val_reg26                     (counter_val_reg_126),
    .cntr_ctrl_reg26                       (cntr_ctrl_reg_126),
    .interval_reg26                        (interval_reg_126),
    .match_1_reg26                         (match_1_reg_126),
    .match_2_reg26                         (match_2_reg_126),
    .match_3_reg26                         (match_3_reg_126),
    .interrupt26                           (TTC_int26[1]),
    .interrupt_reg26                       (interrupt_reg_126),
    .interrupt_en_reg26                    (interrupt_en_reg_126)
  );


  ttc_timer_counter_lite26 i_ttc_timer_counter_lite_226 ( 

    //inputs26
    .n_p_reset26                           (n_p_reset26), 
    .pclk26                                (pclk26),
    .pwdata26                              (pwdata26[15:0]),
    .clk_ctrl_reg_sel26                    (clk_ctrl_reg_sel_226),
    .cntr_ctrl_reg_sel26                   (cntr_ctrl_reg_sel_226),
    .interval_reg_sel26                    (interval_reg_sel_226),
    .match_1_reg_sel26                     (match_1_reg_sel_226),
    .match_2_reg_sel26                     (match_2_reg_sel_226),
    .match_3_reg_sel26                     (match_3_reg_sel_226),
    .intr_en_reg_sel26                     (intr_en_reg_sel26[2]),
    .clear_interrupt26                     (clear_interrupt26[2]),
                                  
    //outputs26
    .clk_ctrl_reg26                        (clk_ctrl_reg_226),
    .counter_val_reg26                     (counter_val_reg_226),
    .cntr_ctrl_reg26                       (cntr_ctrl_reg_226),
    .interval_reg26                        (interval_reg_226),
    .match_1_reg26                         (match_1_reg_226),
    .match_2_reg26                         (match_2_reg_226),
    .match_3_reg26                         (match_3_reg_226),
    .interrupt26                           (TTC_int26[2]),
    .interrupt_reg26                       (interrupt_reg_226),
    .interrupt_en_reg26                    (interrupt_en_reg_226)
  );



  ttc_timer_counter_lite26 i_ttc_timer_counter_lite_326 ( 

    //inputs26
    .n_p_reset26                           (n_p_reset26), 
    .pclk26                                (pclk26),
    .pwdata26                              (pwdata26[15:0]),
    .clk_ctrl_reg_sel26                    (clk_ctrl_reg_sel_326),
    .cntr_ctrl_reg_sel26                   (cntr_ctrl_reg_sel_326),
    .interval_reg_sel26                    (interval_reg_sel_326),
    .match_1_reg_sel26                     (match_1_reg_sel_326),
    .match_2_reg_sel26                     (match_2_reg_sel_326),
    .match_3_reg_sel26                     (match_3_reg_sel_326),
    .intr_en_reg_sel26                     (intr_en_reg_sel26[3]),
    .clear_interrupt26                     (clear_interrupt26[3]),
                                              
    //outputs26
    .clk_ctrl_reg26                        (clk_ctrl_reg_326),
    .counter_val_reg26                     (counter_val_reg_326),
    .cntr_ctrl_reg26                       (cntr_ctrl_reg_326),
    .interval_reg26                        (interval_reg_326),
    .match_1_reg26                         (match_1_reg_326),
    .match_2_reg26                         (match_2_reg_326),
    .match_3_reg26                         (match_3_reg_326),
    .interrupt26                           (TTC_int26[3]),
    .interrupt_reg26                       (interrupt_reg_326),
    .interrupt_en_reg26                    (interrupt_en_reg_326)
  );





endmodule 
