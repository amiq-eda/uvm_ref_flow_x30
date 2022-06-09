//File4 name   : ttc_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : The top level of the Triple4 Timer4 Counter4.
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module4 definition4
//-----------------------------------------------------------------------------

module ttc_lite4(
           
           //inputs4
           n_p_reset4,
           pclk4,
           psel4,
           penable4,
           pwrite4,
           pwdata4,
           paddr4,
           scan_in4,
           scan_en4,

           //outputs4
           prdata4,
           interrupt4,
           scan_out4           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS4
//-----------------------------------------------------------------------------

   input         n_p_reset4;              //System4 Reset4
   input         pclk4;                 //System4 clock4
   input         psel4;                 //Select4 line
   input         penable4;              //Enable4
   input         pwrite4;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata4;               //Write data
   input [7:0]   paddr4;                //Address Bus4 register
   input         scan_in4;              //Scan4 chain4 input port
   input         scan_en4;              //Scan4 chain4 enable port
   
   output [31:0] prdata4;               //Read Data from the APB4 Interface4
   output [3:1]  interrupt4;            //Interrupt4 from PCI4 
   output        scan_out4;             //Scan4 chain4 output port

//-----------------------------------------------------------------------------
// Module4 Interconnect4
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int4;
   wire        clk_ctrl_reg_sel_14;     //Module4 1 clock4 control4 select4
   wire        clk_ctrl_reg_sel_24;     //Module4 2 clock4 control4 select4
   wire        clk_ctrl_reg_sel_34;     //Module4 3 clock4 control4 select4
   wire        cntr_ctrl_reg_sel_14;    //Module4 1 counter control4 select4
   wire        cntr_ctrl_reg_sel_24;    //Module4 2 counter control4 select4
   wire        cntr_ctrl_reg_sel_34;    //Module4 3 counter control4 select4
   wire        interval_reg_sel_14;     //Interval4 1 register select4
   wire        interval_reg_sel_24;     //Interval4 2 register select4
   wire        interval_reg_sel_34;     //Interval4 3 register select4
   wire        match_1_reg_sel_14;      //Module4 1 match 1 select4
   wire        match_1_reg_sel_24;      //Module4 1 match 2 select4
   wire        match_1_reg_sel_34;      //Module4 1 match 3 select4
   wire        match_2_reg_sel_14;      //Module4 2 match 1 select4
   wire        match_2_reg_sel_24;      //Module4 2 match 2 select4
   wire        match_2_reg_sel_34;      //Module4 2 match 3 select4
   wire        match_3_reg_sel_14;      //Module4 3 match 1 select4
   wire        match_3_reg_sel_24;      //Module4 3 match 2 select4
   wire        match_3_reg_sel_34;      //Module4 3 match 3 select4
   wire [3:1]  intr_en_reg_sel4;        //Interrupt4 enable register select4
   wire [3:1]  clear_interrupt4;        //Clear interrupt4 signal4
   wire [5:0]  interrupt_reg_14;        //Interrupt4 register 1
   wire [5:0]  interrupt_reg_24;        //Interrupt4 register 2
   wire [5:0]  interrupt_reg_34;        //Interrupt4 register 3 
   wire [5:0]  interrupt_en_reg_14;     //Interrupt4 enable register 1
   wire [5:0]  interrupt_en_reg_24;     //Interrupt4 enable register 2
   wire [5:0]  interrupt_en_reg_34;     //Interrupt4 enable register 3
   wire [6:0]  clk_ctrl_reg_14;         //Clock4 control4 regs for the 
   wire [6:0]  clk_ctrl_reg_24;         //Timer_Counter4 1,2,3
   wire [6:0]  clk_ctrl_reg_34;         //Value of the clock4 frequency4
   wire [15:0] counter_val_reg_14;      //Module4 1 counter value 
   wire [15:0] counter_val_reg_24;      //Module4 2 counter value 
   wire [15:0] counter_val_reg_34;      //Module4 3 counter value 
   wire [6:0]  cntr_ctrl_reg_14;        //Module4 1 counter control4  
   wire [6:0]  cntr_ctrl_reg_24;        //Module4 2 counter control4  
   wire [6:0]  cntr_ctrl_reg_34;        //Module4 3 counter control4  
   wire [15:0] interval_reg_14;         //Module4 1 interval4 register
   wire [15:0] interval_reg_24;         //Module4 2 interval4 register
   wire [15:0] interval_reg_34;         //Module4 3 interval4 register
   wire [15:0] match_1_reg_14;          //Module4 1 match 1 register
   wire [15:0] match_1_reg_24;          //Module4 1 match 2 register
   wire [15:0] match_1_reg_34;          //Module4 1 match 3 register
   wire [15:0] match_2_reg_14;          //Module4 2 match 1 register
   wire [15:0] match_2_reg_24;          //Module4 2 match 2 register
   wire [15:0] match_2_reg_34;          //Module4 2 match 3 register
   wire [15:0] match_3_reg_14;          //Module4 3 match 1 register
   wire [15:0] match_3_reg_24;          //Module4 3 match 2 register
   wire [15:0] match_3_reg_34;          //Module4 3 match 3 register

  assign interrupt4 = TTC_int4;   // Bug4 Fix4 for floating4 ints - Santhosh4 8 Nov4 06
   

//-----------------------------------------------------------------------------
// Module4 Instantiations4
//-----------------------------------------------------------------------------


  ttc_interface_lite4 i_ttc_interface_lite4 ( 

    //inputs4
    .n_p_reset4                           (n_p_reset4),
    .pclk4                                (pclk4),
    .psel4                                (psel4),
    .penable4                             (penable4),
    .pwrite4                              (pwrite4),
    .paddr4                               (paddr4),
    .clk_ctrl_reg_14                      (clk_ctrl_reg_14),
    .clk_ctrl_reg_24                      (clk_ctrl_reg_24),
    .clk_ctrl_reg_34                      (clk_ctrl_reg_34),
    .cntr_ctrl_reg_14                     (cntr_ctrl_reg_14),
    .cntr_ctrl_reg_24                     (cntr_ctrl_reg_24),
    .cntr_ctrl_reg_34                     (cntr_ctrl_reg_34),
    .counter_val_reg_14                   (counter_val_reg_14),
    .counter_val_reg_24                   (counter_val_reg_24),
    .counter_val_reg_34                   (counter_val_reg_34),
    .interval_reg_14                      (interval_reg_14),
    .match_1_reg_14                       (match_1_reg_14),
    .match_2_reg_14                       (match_2_reg_14),
    .match_3_reg_14                       (match_3_reg_14),
    .interval_reg_24                      (interval_reg_24),
    .match_1_reg_24                       (match_1_reg_24),
    .match_2_reg_24                       (match_2_reg_24),
    .match_3_reg_24                       (match_3_reg_24),
    .interval_reg_34                      (interval_reg_34),
    .match_1_reg_34                       (match_1_reg_34),
    .match_2_reg_34                       (match_2_reg_34),
    .match_3_reg_34                       (match_3_reg_34),
    .interrupt_reg_14                     (interrupt_reg_14),
    .interrupt_reg_24                     (interrupt_reg_24),
    .interrupt_reg_34                     (interrupt_reg_34), 
    .interrupt_en_reg_14                  (interrupt_en_reg_14),
    .interrupt_en_reg_24                  (interrupt_en_reg_24),
    .interrupt_en_reg_34                  (interrupt_en_reg_34), 

    //outputs4
    .prdata4                              (prdata4),
    .clk_ctrl_reg_sel_14                  (clk_ctrl_reg_sel_14),
    .clk_ctrl_reg_sel_24                  (clk_ctrl_reg_sel_24),
    .clk_ctrl_reg_sel_34                  (clk_ctrl_reg_sel_34),
    .cntr_ctrl_reg_sel_14                 (cntr_ctrl_reg_sel_14),
    .cntr_ctrl_reg_sel_24                 (cntr_ctrl_reg_sel_24),
    .cntr_ctrl_reg_sel_34                 (cntr_ctrl_reg_sel_34),
    .interval_reg_sel_14                  (interval_reg_sel_14),  
    .interval_reg_sel_24                  (interval_reg_sel_24), 
    .interval_reg_sel_34                  (interval_reg_sel_34),
    .match_1_reg_sel_14                   (match_1_reg_sel_14),     
    .match_1_reg_sel_24                   (match_1_reg_sel_24),
    .match_1_reg_sel_34                   (match_1_reg_sel_34),                
    .match_2_reg_sel_14                   (match_2_reg_sel_14),
    .match_2_reg_sel_24                   (match_2_reg_sel_24),
    .match_2_reg_sel_34                   (match_2_reg_sel_34),
    .match_3_reg_sel_14                   (match_3_reg_sel_14),
    .match_3_reg_sel_24                   (match_3_reg_sel_24),
    .match_3_reg_sel_34                   (match_3_reg_sel_34),
    .intr_en_reg_sel4                     (intr_en_reg_sel4),
    .clear_interrupt4                     (clear_interrupt4)

  );


   

  ttc_timer_counter_lite4 i_ttc_timer_counter_lite_14 ( 

    //inputs4
    .n_p_reset4                           (n_p_reset4),
    .pclk4                                (pclk4), 
    .pwdata4                              (pwdata4[15:0]),
    .clk_ctrl_reg_sel4                    (clk_ctrl_reg_sel_14),
    .cntr_ctrl_reg_sel4                   (cntr_ctrl_reg_sel_14),
    .interval_reg_sel4                    (interval_reg_sel_14),
    .match_1_reg_sel4                     (match_1_reg_sel_14),
    .match_2_reg_sel4                     (match_2_reg_sel_14),
    .match_3_reg_sel4                     (match_3_reg_sel_14),
    .intr_en_reg_sel4                     (intr_en_reg_sel4[1]),
    .clear_interrupt4                     (clear_interrupt4[1]),
                                  
    //outputs4
    .clk_ctrl_reg4                        (clk_ctrl_reg_14),
    .counter_val_reg4                     (counter_val_reg_14),
    .cntr_ctrl_reg4                       (cntr_ctrl_reg_14),
    .interval_reg4                        (interval_reg_14),
    .match_1_reg4                         (match_1_reg_14),
    .match_2_reg4                         (match_2_reg_14),
    .match_3_reg4                         (match_3_reg_14),
    .interrupt4                           (TTC_int4[1]),
    .interrupt_reg4                       (interrupt_reg_14),
    .interrupt_en_reg4                    (interrupt_en_reg_14)
  );


  ttc_timer_counter_lite4 i_ttc_timer_counter_lite_24 ( 

    //inputs4
    .n_p_reset4                           (n_p_reset4), 
    .pclk4                                (pclk4),
    .pwdata4                              (pwdata4[15:0]),
    .clk_ctrl_reg_sel4                    (clk_ctrl_reg_sel_24),
    .cntr_ctrl_reg_sel4                   (cntr_ctrl_reg_sel_24),
    .interval_reg_sel4                    (interval_reg_sel_24),
    .match_1_reg_sel4                     (match_1_reg_sel_24),
    .match_2_reg_sel4                     (match_2_reg_sel_24),
    .match_3_reg_sel4                     (match_3_reg_sel_24),
    .intr_en_reg_sel4                     (intr_en_reg_sel4[2]),
    .clear_interrupt4                     (clear_interrupt4[2]),
                                  
    //outputs4
    .clk_ctrl_reg4                        (clk_ctrl_reg_24),
    .counter_val_reg4                     (counter_val_reg_24),
    .cntr_ctrl_reg4                       (cntr_ctrl_reg_24),
    .interval_reg4                        (interval_reg_24),
    .match_1_reg4                         (match_1_reg_24),
    .match_2_reg4                         (match_2_reg_24),
    .match_3_reg4                         (match_3_reg_24),
    .interrupt4                           (TTC_int4[2]),
    .interrupt_reg4                       (interrupt_reg_24),
    .interrupt_en_reg4                    (interrupt_en_reg_24)
  );



  ttc_timer_counter_lite4 i_ttc_timer_counter_lite_34 ( 

    //inputs4
    .n_p_reset4                           (n_p_reset4), 
    .pclk4                                (pclk4),
    .pwdata4                              (pwdata4[15:0]),
    .clk_ctrl_reg_sel4                    (clk_ctrl_reg_sel_34),
    .cntr_ctrl_reg_sel4                   (cntr_ctrl_reg_sel_34),
    .interval_reg_sel4                    (interval_reg_sel_34),
    .match_1_reg_sel4                     (match_1_reg_sel_34),
    .match_2_reg_sel4                     (match_2_reg_sel_34),
    .match_3_reg_sel4                     (match_3_reg_sel_34),
    .intr_en_reg_sel4                     (intr_en_reg_sel4[3]),
    .clear_interrupt4                     (clear_interrupt4[3]),
                                              
    //outputs4
    .clk_ctrl_reg4                        (clk_ctrl_reg_34),
    .counter_val_reg4                     (counter_val_reg_34),
    .cntr_ctrl_reg4                       (cntr_ctrl_reg_34),
    .interval_reg4                        (interval_reg_34),
    .match_1_reg4                         (match_1_reg_34),
    .match_2_reg4                         (match_2_reg_34),
    .match_3_reg4                         (match_3_reg_34),
    .interrupt4                           (TTC_int4[3]),
    .interrupt_reg4                       (interrupt_reg_34),
    .interrupt_en_reg4                    (interrupt_en_reg_34)
  );





endmodule 
