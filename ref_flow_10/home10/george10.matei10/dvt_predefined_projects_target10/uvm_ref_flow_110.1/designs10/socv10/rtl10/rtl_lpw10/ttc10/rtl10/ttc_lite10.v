//File10 name   : ttc_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : The top level of the Triple10 Timer10 Counter10.
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module10 definition10
//-----------------------------------------------------------------------------

module ttc_lite10(
           
           //inputs10
           n_p_reset10,
           pclk10,
           psel10,
           penable10,
           pwrite10,
           pwdata10,
           paddr10,
           scan_in10,
           scan_en10,

           //outputs10
           prdata10,
           interrupt10,
           scan_out10           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS10
//-----------------------------------------------------------------------------

   input         n_p_reset10;              //System10 Reset10
   input         pclk10;                 //System10 clock10
   input         psel10;                 //Select10 line
   input         penable10;              //Enable10
   input         pwrite10;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata10;               //Write data
   input [7:0]   paddr10;                //Address Bus10 register
   input         scan_in10;              //Scan10 chain10 input port
   input         scan_en10;              //Scan10 chain10 enable port
   
   output [31:0] prdata10;               //Read Data from the APB10 Interface10
   output [3:1]  interrupt10;            //Interrupt10 from PCI10 
   output        scan_out10;             //Scan10 chain10 output port

//-----------------------------------------------------------------------------
// Module10 Interconnect10
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int10;
   wire        clk_ctrl_reg_sel_110;     //Module10 1 clock10 control10 select10
   wire        clk_ctrl_reg_sel_210;     //Module10 2 clock10 control10 select10
   wire        clk_ctrl_reg_sel_310;     //Module10 3 clock10 control10 select10
   wire        cntr_ctrl_reg_sel_110;    //Module10 1 counter control10 select10
   wire        cntr_ctrl_reg_sel_210;    //Module10 2 counter control10 select10
   wire        cntr_ctrl_reg_sel_310;    //Module10 3 counter control10 select10
   wire        interval_reg_sel_110;     //Interval10 1 register select10
   wire        interval_reg_sel_210;     //Interval10 2 register select10
   wire        interval_reg_sel_310;     //Interval10 3 register select10
   wire        match_1_reg_sel_110;      //Module10 1 match 1 select10
   wire        match_1_reg_sel_210;      //Module10 1 match 2 select10
   wire        match_1_reg_sel_310;      //Module10 1 match 3 select10
   wire        match_2_reg_sel_110;      //Module10 2 match 1 select10
   wire        match_2_reg_sel_210;      //Module10 2 match 2 select10
   wire        match_2_reg_sel_310;      //Module10 2 match 3 select10
   wire        match_3_reg_sel_110;      //Module10 3 match 1 select10
   wire        match_3_reg_sel_210;      //Module10 3 match 2 select10
   wire        match_3_reg_sel_310;      //Module10 3 match 3 select10
   wire [3:1]  intr_en_reg_sel10;        //Interrupt10 enable register select10
   wire [3:1]  clear_interrupt10;        //Clear interrupt10 signal10
   wire [5:0]  interrupt_reg_110;        //Interrupt10 register 1
   wire [5:0]  interrupt_reg_210;        //Interrupt10 register 2
   wire [5:0]  interrupt_reg_310;        //Interrupt10 register 3 
   wire [5:0]  interrupt_en_reg_110;     //Interrupt10 enable register 1
   wire [5:0]  interrupt_en_reg_210;     //Interrupt10 enable register 2
   wire [5:0]  interrupt_en_reg_310;     //Interrupt10 enable register 3
   wire [6:0]  clk_ctrl_reg_110;         //Clock10 control10 regs for the 
   wire [6:0]  clk_ctrl_reg_210;         //Timer_Counter10 1,2,3
   wire [6:0]  clk_ctrl_reg_310;         //Value of the clock10 frequency10
   wire [15:0] counter_val_reg_110;      //Module10 1 counter value 
   wire [15:0] counter_val_reg_210;      //Module10 2 counter value 
   wire [15:0] counter_val_reg_310;      //Module10 3 counter value 
   wire [6:0]  cntr_ctrl_reg_110;        //Module10 1 counter control10  
   wire [6:0]  cntr_ctrl_reg_210;        //Module10 2 counter control10  
   wire [6:0]  cntr_ctrl_reg_310;        //Module10 3 counter control10  
   wire [15:0] interval_reg_110;         //Module10 1 interval10 register
   wire [15:0] interval_reg_210;         //Module10 2 interval10 register
   wire [15:0] interval_reg_310;         //Module10 3 interval10 register
   wire [15:0] match_1_reg_110;          //Module10 1 match 1 register
   wire [15:0] match_1_reg_210;          //Module10 1 match 2 register
   wire [15:0] match_1_reg_310;          //Module10 1 match 3 register
   wire [15:0] match_2_reg_110;          //Module10 2 match 1 register
   wire [15:0] match_2_reg_210;          //Module10 2 match 2 register
   wire [15:0] match_2_reg_310;          //Module10 2 match 3 register
   wire [15:0] match_3_reg_110;          //Module10 3 match 1 register
   wire [15:0] match_3_reg_210;          //Module10 3 match 2 register
   wire [15:0] match_3_reg_310;          //Module10 3 match 3 register

  assign interrupt10 = TTC_int10;   // Bug10 Fix10 for floating10 ints - Santhosh10 8 Nov10 06
   

//-----------------------------------------------------------------------------
// Module10 Instantiations10
//-----------------------------------------------------------------------------


  ttc_interface_lite10 i_ttc_interface_lite10 ( 

    //inputs10
    .n_p_reset10                           (n_p_reset10),
    .pclk10                                (pclk10),
    .psel10                                (psel10),
    .penable10                             (penable10),
    .pwrite10                              (pwrite10),
    .paddr10                               (paddr10),
    .clk_ctrl_reg_110                      (clk_ctrl_reg_110),
    .clk_ctrl_reg_210                      (clk_ctrl_reg_210),
    .clk_ctrl_reg_310                      (clk_ctrl_reg_310),
    .cntr_ctrl_reg_110                     (cntr_ctrl_reg_110),
    .cntr_ctrl_reg_210                     (cntr_ctrl_reg_210),
    .cntr_ctrl_reg_310                     (cntr_ctrl_reg_310),
    .counter_val_reg_110                   (counter_val_reg_110),
    .counter_val_reg_210                   (counter_val_reg_210),
    .counter_val_reg_310                   (counter_val_reg_310),
    .interval_reg_110                      (interval_reg_110),
    .match_1_reg_110                       (match_1_reg_110),
    .match_2_reg_110                       (match_2_reg_110),
    .match_3_reg_110                       (match_3_reg_110),
    .interval_reg_210                      (interval_reg_210),
    .match_1_reg_210                       (match_1_reg_210),
    .match_2_reg_210                       (match_2_reg_210),
    .match_3_reg_210                       (match_3_reg_210),
    .interval_reg_310                      (interval_reg_310),
    .match_1_reg_310                       (match_1_reg_310),
    .match_2_reg_310                       (match_2_reg_310),
    .match_3_reg_310                       (match_3_reg_310),
    .interrupt_reg_110                     (interrupt_reg_110),
    .interrupt_reg_210                     (interrupt_reg_210),
    .interrupt_reg_310                     (interrupt_reg_310), 
    .interrupt_en_reg_110                  (interrupt_en_reg_110),
    .interrupt_en_reg_210                  (interrupt_en_reg_210),
    .interrupt_en_reg_310                  (interrupt_en_reg_310), 

    //outputs10
    .prdata10                              (prdata10),
    .clk_ctrl_reg_sel_110                  (clk_ctrl_reg_sel_110),
    .clk_ctrl_reg_sel_210                  (clk_ctrl_reg_sel_210),
    .clk_ctrl_reg_sel_310                  (clk_ctrl_reg_sel_310),
    .cntr_ctrl_reg_sel_110                 (cntr_ctrl_reg_sel_110),
    .cntr_ctrl_reg_sel_210                 (cntr_ctrl_reg_sel_210),
    .cntr_ctrl_reg_sel_310                 (cntr_ctrl_reg_sel_310),
    .interval_reg_sel_110                  (interval_reg_sel_110),  
    .interval_reg_sel_210                  (interval_reg_sel_210), 
    .interval_reg_sel_310                  (interval_reg_sel_310),
    .match_1_reg_sel_110                   (match_1_reg_sel_110),     
    .match_1_reg_sel_210                   (match_1_reg_sel_210),
    .match_1_reg_sel_310                   (match_1_reg_sel_310),                
    .match_2_reg_sel_110                   (match_2_reg_sel_110),
    .match_2_reg_sel_210                   (match_2_reg_sel_210),
    .match_2_reg_sel_310                   (match_2_reg_sel_310),
    .match_3_reg_sel_110                   (match_3_reg_sel_110),
    .match_3_reg_sel_210                   (match_3_reg_sel_210),
    .match_3_reg_sel_310                   (match_3_reg_sel_310),
    .intr_en_reg_sel10                     (intr_en_reg_sel10),
    .clear_interrupt10                     (clear_interrupt10)

  );


   

  ttc_timer_counter_lite10 i_ttc_timer_counter_lite_110 ( 

    //inputs10
    .n_p_reset10                           (n_p_reset10),
    .pclk10                                (pclk10), 
    .pwdata10                              (pwdata10[15:0]),
    .clk_ctrl_reg_sel10                    (clk_ctrl_reg_sel_110),
    .cntr_ctrl_reg_sel10                   (cntr_ctrl_reg_sel_110),
    .interval_reg_sel10                    (interval_reg_sel_110),
    .match_1_reg_sel10                     (match_1_reg_sel_110),
    .match_2_reg_sel10                     (match_2_reg_sel_110),
    .match_3_reg_sel10                     (match_3_reg_sel_110),
    .intr_en_reg_sel10                     (intr_en_reg_sel10[1]),
    .clear_interrupt10                     (clear_interrupt10[1]),
                                  
    //outputs10
    .clk_ctrl_reg10                        (clk_ctrl_reg_110),
    .counter_val_reg10                     (counter_val_reg_110),
    .cntr_ctrl_reg10                       (cntr_ctrl_reg_110),
    .interval_reg10                        (interval_reg_110),
    .match_1_reg10                         (match_1_reg_110),
    .match_2_reg10                         (match_2_reg_110),
    .match_3_reg10                         (match_3_reg_110),
    .interrupt10                           (TTC_int10[1]),
    .interrupt_reg10                       (interrupt_reg_110),
    .interrupt_en_reg10                    (interrupt_en_reg_110)
  );


  ttc_timer_counter_lite10 i_ttc_timer_counter_lite_210 ( 

    //inputs10
    .n_p_reset10                           (n_p_reset10), 
    .pclk10                                (pclk10),
    .pwdata10                              (pwdata10[15:0]),
    .clk_ctrl_reg_sel10                    (clk_ctrl_reg_sel_210),
    .cntr_ctrl_reg_sel10                   (cntr_ctrl_reg_sel_210),
    .interval_reg_sel10                    (interval_reg_sel_210),
    .match_1_reg_sel10                     (match_1_reg_sel_210),
    .match_2_reg_sel10                     (match_2_reg_sel_210),
    .match_3_reg_sel10                     (match_3_reg_sel_210),
    .intr_en_reg_sel10                     (intr_en_reg_sel10[2]),
    .clear_interrupt10                     (clear_interrupt10[2]),
                                  
    //outputs10
    .clk_ctrl_reg10                        (clk_ctrl_reg_210),
    .counter_val_reg10                     (counter_val_reg_210),
    .cntr_ctrl_reg10                       (cntr_ctrl_reg_210),
    .interval_reg10                        (interval_reg_210),
    .match_1_reg10                         (match_1_reg_210),
    .match_2_reg10                         (match_2_reg_210),
    .match_3_reg10                         (match_3_reg_210),
    .interrupt10                           (TTC_int10[2]),
    .interrupt_reg10                       (interrupt_reg_210),
    .interrupt_en_reg10                    (interrupt_en_reg_210)
  );



  ttc_timer_counter_lite10 i_ttc_timer_counter_lite_310 ( 

    //inputs10
    .n_p_reset10                           (n_p_reset10), 
    .pclk10                                (pclk10),
    .pwdata10                              (pwdata10[15:0]),
    .clk_ctrl_reg_sel10                    (clk_ctrl_reg_sel_310),
    .cntr_ctrl_reg_sel10                   (cntr_ctrl_reg_sel_310),
    .interval_reg_sel10                    (interval_reg_sel_310),
    .match_1_reg_sel10                     (match_1_reg_sel_310),
    .match_2_reg_sel10                     (match_2_reg_sel_310),
    .match_3_reg_sel10                     (match_3_reg_sel_310),
    .intr_en_reg_sel10                     (intr_en_reg_sel10[3]),
    .clear_interrupt10                     (clear_interrupt10[3]),
                                              
    //outputs10
    .clk_ctrl_reg10                        (clk_ctrl_reg_310),
    .counter_val_reg10                     (counter_val_reg_310),
    .cntr_ctrl_reg10                       (cntr_ctrl_reg_310),
    .interval_reg10                        (interval_reg_310),
    .match_1_reg10                         (match_1_reg_310),
    .match_2_reg10                         (match_2_reg_310),
    .match_3_reg10                         (match_3_reg_310),
    .interrupt10                           (TTC_int10[3]),
    .interrupt_reg10                       (interrupt_reg_310),
    .interrupt_en_reg10                    (interrupt_en_reg_310)
  );





endmodule 
