//File23 name   : ttc_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : The top level of the Triple23 Timer23 Counter23.
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

module ttc_lite23(
           
           //inputs23
           n_p_reset23,
           pclk23,
           psel23,
           penable23,
           pwrite23,
           pwdata23,
           paddr23,
           scan_in23,
           scan_en23,

           //outputs23
           prdata23,
           interrupt23,
           scan_out23           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS23
//-----------------------------------------------------------------------------

   input         n_p_reset23;              //System23 Reset23
   input         pclk23;                 //System23 clock23
   input         psel23;                 //Select23 line
   input         penable23;              //Enable23
   input         pwrite23;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata23;               //Write data
   input [7:0]   paddr23;                //Address Bus23 register
   input         scan_in23;              //Scan23 chain23 input port
   input         scan_en23;              //Scan23 chain23 enable port
   
   output [31:0] prdata23;               //Read Data from the APB23 Interface23
   output [3:1]  interrupt23;            //Interrupt23 from PCI23 
   output        scan_out23;             //Scan23 chain23 output port

//-----------------------------------------------------------------------------
// Module23 Interconnect23
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int23;
   wire        clk_ctrl_reg_sel_123;     //Module23 1 clock23 control23 select23
   wire        clk_ctrl_reg_sel_223;     //Module23 2 clock23 control23 select23
   wire        clk_ctrl_reg_sel_323;     //Module23 3 clock23 control23 select23
   wire        cntr_ctrl_reg_sel_123;    //Module23 1 counter control23 select23
   wire        cntr_ctrl_reg_sel_223;    //Module23 2 counter control23 select23
   wire        cntr_ctrl_reg_sel_323;    //Module23 3 counter control23 select23
   wire        interval_reg_sel_123;     //Interval23 1 register select23
   wire        interval_reg_sel_223;     //Interval23 2 register select23
   wire        interval_reg_sel_323;     //Interval23 3 register select23
   wire        match_1_reg_sel_123;      //Module23 1 match 1 select23
   wire        match_1_reg_sel_223;      //Module23 1 match 2 select23
   wire        match_1_reg_sel_323;      //Module23 1 match 3 select23
   wire        match_2_reg_sel_123;      //Module23 2 match 1 select23
   wire        match_2_reg_sel_223;      //Module23 2 match 2 select23
   wire        match_2_reg_sel_323;      //Module23 2 match 3 select23
   wire        match_3_reg_sel_123;      //Module23 3 match 1 select23
   wire        match_3_reg_sel_223;      //Module23 3 match 2 select23
   wire        match_3_reg_sel_323;      //Module23 3 match 3 select23
   wire [3:1]  intr_en_reg_sel23;        //Interrupt23 enable register select23
   wire [3:1]  clear_interrupt23;        //Clear interrupt23 signal23
   wire [5:0]  interrupt_reg_123;        //Interrupt23 register 1
   wire [5:0]  interrupt_reg_223;        //Interrupt23 register 2
   wire [5:0]  interrupt_reg_323;        //Interrupt23 register 3 
   wire [5:0]  interrupt_en_reg_123;     //Interrupt23 enable register 1
   wire [5:0]  interrupt_en_reg_223;     //Interrupt23 enable register 2
   wire [5:0]  interrupt_en_reg_323;     //Interrupt23 enable register 3
   wire [6:0]  clk_ctrl_reg_123;         //Clock23 control23 regs for the 
   wire [6:0]  clk_ctrl_reg_223;         //Timer_Counter23 1,2,3
   wire [6:0]  clk_ctrl_reg_323;         //Value of the clock23 frequency23
   wire [15:0] counter_val_reg_123;      //Module23 1 counter value 
   wire [15:0] counter_val_reg_223;      //Module23 2 counter value 
   wire [15:0] counter_val_reg_323;      //Module23 3 counter value 
   wire [6:0]  cntr_ctrl_reg_123;        //Module23 1 counter control23  
   wire [6:0]  cntr_ctrl_reg_223;        //Module23 2 counter control23  
   wire [6:0]  cntr_ctrl_reg_323;        //Module23 3 counter control23  
   wire [15:0] interval_reg_123;         //Module23 1 interval23 register
   wire [15:0] interval_reg_223;         //Module23 2 interval23 register
   wire [15:0] interval_reg_323;         //Module23 3 interval23 register
   wire [15:0] match_1_reg_123;          //Module23 1 match 1 register
   wire [15:0] match_1_reg_223;          //Module23 1 match 2 register
   wire [15:0] match_1_reg_323;          //Module23 1 match 3 register
   wire [15:0] match_2_reg_123;          //Module23 2 match 1 register
   wire [15:0] match_2_reg_223;          //Module23 2 match 2 register
   wire [15:0] match_2_reg_323;          //Module23 2 match 3 register
   wire [15:0] match_3_reg_123;          //Module23 3 match 1 register
   wire [15:0] match_3_reg_223;          //Module23 3 match 2 register
   wire [15:0] match_3_reg_323;          //Module23 3 match 3 register

  assign interrupt23 = TTC_int23;   // Bug23 Fix23 for floating23 ints - Santhosh23 8 Nov23 06
   

//-----------------------------------------------------------------------------
// Module23 Instantiations23
//-----------------------------------------------------------------------------


  ttc_interface_lite23 i_ttc_interface_lite23 ( 

    //inputs23
    .n_p_reset23                           (n_p_reset23),
    .pclk23                                (pclk23),
    .psel23                                (psel23),
    .penable23                             (penable23),
    .pwrite23                              (pwrite23),
    .paddr23                               (paddr23),
    .clk_ctrl_reg_123                      (clk_ctrl_reg_123),
    .clk_ctrl_reg_223                      (clk_ctrl_reg_223),
    .clk_ctrl_reg_323                      (clk_ctrl_reg_323),
    .cntr_ctrl_reg_123                     (cntr_ctrl_reg_123),
    .cntr_ctrl_reg_223                     (cntr_ctrl_reg_223),
    .cntr_ctrl_reg_323                     (cntr_ctrl_reg_323),
    .counter_val_reg_123                   (counter_val_reg_123),
    .counter_val_reg_223                   (counter_val_reg_223),
    .counter_val_reg_323                   (counter_val_reg_323),
    .interval_reg_123                      (interval_reg_123),
    .match_1_reg_123                       (match_1_reg_123),
    .match_2_reg_123                       (match_2_reg_123),
    .match_3_reg_123                       (match_3_reg_123),
    .interval_reg_223                      (interval_reg_223),
    .match_1_reg_223                       (match_1_reg_223),
    .match_2_reg_223                       (match_2_reg_223),
    .match_3_reg_223                       (match_3_reg_223),
    .interval_reg_323                      (interval_reg_323),
    .match_1_reg_323                       (match_1_reg_323),
    .match_2_reg_323                       (match_2_reg_323),
    .match_3_reg_323                       (match_3_reg_323),
    .interrupt_reg_123                     (interrupt_reg_123),
    .interrupt_reg_223                     (interrupt_reg_223),
    .interrupt_reg_323                     (interrupt_reg_323), 
    .interrupt_en_reg_123                  (interrupt_en_reg_123),
    .interrupt_en_reg_223                  (interrupt_en_reg_223),
    .interrupt_en_reg_323                  (interrupt_en_reg_323), 

    //outputs23
    .prdata23                              (prdata23),
    .clk_ctrl_reg_sel_123                  (clk_ctrl_reg_sel_123),
    .clk_ctrl_reg_sel_223                  (clk_ctrl_reg_sel_223),
    .clk_ctrl_reg_sel_323                  (clk_ctrl_reg_sel_323),
    .cntr_ctrl_reg_sel_123                 (cntr_ctrl_reg_sel_123),
    .cntr_ctrl_reg_sel_223                 (cntr_ctrl_reg_sel_223),
    .cntr_ctrl_reg_sel_323                 (cntr_ctrl_reg_sel_323),
    .interval_reg_sel_123                  (interval_reg_sel_123),  
    .interval_reg_sel_223                  (interval_reg_sel_223), 
    .interval_reg_sel_323                  (interval_reg_sel_323),
    .match_1_reg_sel_123                   (match_1_reg_sel_123),     
    .match_1_reg_sel_223                   (match_1_reg_sel_223),
    .match_1_reg_sel_323                   (match_1_reg_sel_323),                
    .match_2_reg_sel_123                   (match_2_reg_sel_123),
    .match_2_reg_sel_223                   (match_2_reg_sel_223),
    .match_2_reg_sel_323                   (match_2_reg_sel_323),
    .match_3_reg_sel_123                   (match_3_reg_sel_123),
    .match_3_reg_sel_223                   (match_3_reg_sel_223),
    .match_3_reg_sel_323                   (match_3_reg_sel_323),
    .intr_en_reg_sel23                     (intr_en_reg_sel23),
    .clear_interrupt23                     (clear_interrupt23)

  );


   

  ttc_timer_counter_lite23 i_ttc_timer_counter_lite_123 ( 

    //inputs23
    .n_p_reset23                           (n_p_reset23),
    .pclk23                                (pclk23), 
    .pwdata23                              (pwdata23[15:0]),
    .clk_ctrl_reg_sel23                    (clk_ctrl_reg_sel_123),
    .cntr_ctrl_reg_sel23                   (cntr_ctrl_reg_sel_123),
    .interval_reg_sel23                    (interval_reg_sel_123),
    .match_1_reg_sel23                     (match_1_reg_sel_123),
    .match_2_reg_sel23                     (match_2_reg_sel_123),
    .match_3_reg_sel23                     (match_3_reg_sel_123),
    .intr_en_reg_sel23                     (intr_en_reg_sel23[1]),
    .clear_interrupt23                     (clear_interrupt23[1]),
                                  
    //outputs23
    .clk_ctrl_reg23                        (clk_ctrl_reg_123),
    .counter_val_reg23                     (counter_val_reg_123),
    .cntr_ctrl_reg23                       (cntr_ctrl_reg_123),
    .interval_reg23                        (interval_reg_123),
    .match_1_reg23                         (match_1_reg_123),
    .match_2_reg23                         (match_2_reg_123),
    .match_3_reg23                         (match_3_reg_123),
    .interrupt23                           (TTC_int23[1]),
    .interrupt_reg23                       (interrupt_reg_123),
    .interrupt_en_reg23                    (interrupt_en_reg_123)
  );


  ttc_timer_counter_lite23 i_ttc_timer_counter_lite_223 ( 

    //inputs23
    .n_p_reset23                           (n_p_reset23), 
    .pclk23                                (pclk23),
    .pwdata23                              (pwdata23[15:0]),
    .clk_ctrl_reg_sel23                    (clk_ctrl_reg_sel_223),
    .cntr_ctrl_reg_sel23                   (cntr_ctrl_reg_sel_223),
    .interval_reg_sel23                    (interval_reg_sel_223),
    .match_1_reg_sel23                     (match_1_reg_sel_223),
    .match_2_reg_sel23                     (match_2_reg_sel_223),
    .match_3_reg_sel23                     (match_3_reg_sel_223),
    .intr_en_reg_sel23                     (intr_en_reg_sel23[2]),
    .clear_interrupt23                     (clear_interrupt23[2]),
                                  
    //outputs23
    .clk_ctrl_reg23                        (clk_ctrl_reg_223),
    .counter_val_reg23                     (counter_val_reg_223),
    .cntr_ctrl_reg23                       (cntr_ctrl_reg_223),
    .interval_reg23                        (interval_reg_223),
    .match_1_reg23                         (match_1_reg_223),
    .match_2_reg23                         (match_2_reg_223),
    .match_3_reg23                         (match_3_reg_223),
    .interrupt23                           (TTC_int23[2]),
    .interrupt_reg23                       (interrupt_reg_223),
    .interrupt_en_reg23                    (interrupt_en_reg_223)
  );



  ttc_timer_counter_lite23 i_ttc_timer_counter_lite_323 ( 

    //inputs23
    .n_p_reset23                           (n_p_reset23), 
    .pclk23                                (pclk23),
    .pwdata23                              (pwdata23[15:0]),
    .clk_ctrl_reg_sel23                    (clk_ctrl_reg_sel_323),
    .cntr_ctrl_reg_sel23                   (cntr_ctrl_reg_sel_323),
    .interval_reg_sel23                    (interval_reg_sel_323),
    .match_1_reg_sel23                     (match_1_reg_sel_323),
    .match_2_reg_sel23                     (match_2_reg_sel_323),
    .match_3_reg_sel23                     (match_3_reg_sel_323),
    .intr_en_reg_sel23                     (intr_en_reg_sel23[3]),
    .clear_interrupt23                     (clear_interrupt23[3]),
                                              
    //outputs23
    .clk_ctrl_reg23                        (clk_ctrl_reg_323),
    .counter_val_reg23                     (counter_val_reg_323),
    .cntr_ctrl_reg23                       (cntr_ctrl_reg_323),
    .interval_reg23                        (interval_reg_323),
    .match_1_reg23                         (match_1_reg_323),
    .match_2_reg23                         (match_2_reg_323),
    .match_3_reg23                         (match_3_reg_323),
    .interrupt23                           (TTC_int23[3]),
    .interrupt_reg23                       (interrupt_reg_323),
    .interrupt_en_reg23                    (interrupt_en_reg_323)
  );





endmodule 
