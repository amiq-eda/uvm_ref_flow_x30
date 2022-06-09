//File28 name   : ttc_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : The top level of the Triple28 Timer28 Counter28.
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

module ttc_lite28(
           
           //inputs28
           n_p_reset28,
           pclk28,
           psel28,
           penable28,
           pwrite28,
           pwdata28,
           paddr28,
           scan_in28,
           scan_en28,

           //outputs28
           prdata28,
           interrupt28,
           scan_out28           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS28
//-----------------------------------------------------------------------------

   input         n_p_reset28;              //System28 Reset28
   input         pclk28;                 //System28 clock28
   input         psel28;                 //Select28 line
   input         penable28;              //Enable28
   input         pwrite28;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata28;               //Write data
   input [7:0]   paddr28;                //Address Bus28 register
   input         scan_in28;              //Scan28 chain28 input port
   input         scan_en28;              //Scan28 chain28 enable port
   
   output [31:0] prdata28;               //Read Data from the APB28 Interface28
   output [3:1]  interrupt28;            //Interrupt28 from PCI28 
   output        scan_out28;             //Scan28 chain28 output port

//-----------------------------------------------------------------------------
// Module28 Interconnect28
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int28;
   wire        clk_ctrl_reg_sel_128;     //Module28 1 clock28 control28 select28
   wire        clk_ctrl_reg_sel_228;     //Module28 2 clock28 control28 select28
   wire        clk_ctrl_reg_sel_328;     //Module28 3 clock28 control28 select28
   wire        cntr_ctrl_reg_sel_128;    //Module28 1 counter control28 select28
   wire        cntr_ctrl_reg_sel_228;    //Module28 2 counter control28 select28
   wire        cntr_ctrl_reg_sel_328;    //Module28 3 counter control28 select28
   wire        interval_reg_sel_128;     //Interval28 1 register select28
   wire        interval_reg_sel_228;     //Interval28 2 register select28
   wire        interval_reg_sel_328;     //Interval28 3 register select28
   wire        match_1_reg_sel_128;      //Module28 1 match 1 select28
   wire        match_1_reg_sel_228;      //Module28 1 match 2 select28
   wire        match_1_reg_sel_328;      //Module28 1 match 3 select28
   wire        match_2_reg_sel_128;      //Module28 2 match 1 select28
   wire        match_2_reg_sel_228;      //Module28 2 match 2 select28
   wire        match_2_reg_sel_328;      //Module28 2 match 3 select28
   wire        match_3_reg_sel_128;      //Module28 3 match 1 select28
   wire        match_3_reg_sel_228;      //Module28 3 match 2 select28
   wire        match_3_reg_sel_328;      //Module28 3 match 3 select28
   wire [3:1]  intr_en_reg_sel28;        //Interrupt28 enable register select28
   wire [3:1]  clear_interrupt28;        //Clear interrupt28 signal28
   wire [5:0]  interrupt_reg_128;        //Interrupt28 register 1
   wire [5:0]  interrupt_reg_228;        //Interrupt28 register 2
   wire [5:0]  interrupt_reg_328;        //Interrupt28 register 3 
   wire [5:0]  interrupt_en_reg_128;     //Interrupt28 enable register 1
   wire [5:0]  interrupt_en_reg_228;     //Interrupt28 enable register 2
   wire [5:0]  interrupt_en_reg_328;     //Interrupt28 enable register 3
   wire [6:0]  clk_ctrl_reg_128;         //Clock28 control28 regs for the 
   wire [6:0]  clk_ctrl_reg_228;         //Timer_Counter28 1,2,3
   wire [6:0]  clk_ctrl_reg_328;         //Value of the clock28 frequency28
   wire [15:0] counter_val_reg_128;      //Module28 1 counter value 
   wire [15:0] counter_val_reg_228;      //Module28 2 counter value 
   wire [15:0] counter_val_reg_328;      //Module28 3 counter value 
   wire [6:0]  cntr_ctrl_reg_128;        //Module28 1 counter control28  
   wire [6:0]  cntr_ctrl_reg_228;        //Module28 2 counter control28  
   wire [6:0]  cntr_ctrl_reg_328;        //Module28 3 counter control28  
   wire [15:0] interval_reg_128;         //Module28 1 interval28 register
   wire [15:0] interval_reg_228;         //Module28 2 interval28 register
   wire [15:0] interval_reg_328;         //Module28 3 interval28 register
   wire [15:0] match_1_reg_128;          //Module28 1 match 1 register
   wire [15:0] match_1_reg_228;          //Module28 1 match 2 register
   wire [15:0] match_1_reg_328;          //Module28 1 match 3 register
   wire [15:0] match_2_reg_128;          //Module28 2 match 1 register
   wire [15:0] match_2_reg_228;          //Module28 2 match 2 register
   wire [15:0] match_2_reg_328;          //Module28 2 match 3 register
   wire [15:0] match_3_reg_128;          //Module28 3 match 1 register
   wire [15:0] match_3_reg_228;          //Module28 3 match 2 register
   wire [15:0] match_3_reg_328;          //Module28 3 match 3 register

  assign interrupt28 = TTC_int28;   // Bug28 Fix28 for floating28 ints - Santhosh28 8 Nov28 06
   

//-----------------------------------------------------------------------------
// Module28 Instantiations28
//-----------------------------------------------------------------------------


  ttc_interface_lite28 i_ttc_interface_lite28 ( 

    //inputs28
    .n_p_reset28                           (n_p_reset28),
    .pclk28                                (pclk28),
    .psel28                                (psel28),
    .penable28                             (penable28),
    .pwrite28                              (pwrite28),
    .paddr28                               (paddr28),
    .clk_ctrl_reg_128                      (clk_ctrl_reg_128),
    .clk_ctrl_reg_228                      (clk_ctrl_reg_228),
    .clk_ctrl_reg_328                      (clk_ctrl_reg_328),
    .cntr_ctrl_reg_128                     (cntr_ctrl_reg_128),
    .cntr_ctrl_reg_228                     (cntr_ctrl_reg_228),
    .cntr_ctrl_reg_328                     (cntr_ctrl_reg_328),
    .counter_val_reg_128                   (counter_val_reg_128),
    .counter_val_reg_228                   (counter_val_reg_228),
    .counter_val_reg_328                   (counter_val_reg_328),
    .interval_reg_128                      (interval_reg_128),
    .match_1_reg_128                       (match_1_reg_128),
    .match_2_reg_128                       (match_2_reg_128),
    .match_3_reg_128                       (match_3_reg_128),
    .interval_reg_228                      (interval_reg_228),
    .match_1_reg_228                       (match_1_reg_228),
    .match_2_reg_228                       (match_2_reg_228),
    .match_3_reg_228                       (match_3_reg_228),
    .interval_reg_328                      (interval_reg_328),
    .match_1_reg_328                       (match_1_reg_328),
    .match_2_reg_328                       (match_2_reg_328),
    .match_3_reg_328                       (match_3_reg_328),
    .interrupt_reg_128                     (interrupt_reg_128),
    .interrupt_reg_228                     (interrupt_reg_228),
    .interrupt_reg_328                     (interrupt_reg_328), 
    .interrupt_en_reg_128                  (interrupt_en_reg_128),
    .interrupt_en_reg_228                  (interrupt_en_reg_228),
    .interrupt_en_reg_328                  (interrupt_en_reg_328), 

    //outputs28
    .prdata28                              (prdata28),
    .clk_ctrl_reg_sel_128                  (clk_ctrl_reg_sel_128),
    .clk_ctrl_reg_sel_228                  (clk_ctrl_reg_sel_228),
    .clk_ctrl_reg_sel_328                  (clk_ctrl_reg_sel_328),
    .cntr_ctrl_reg_sel_128                 (cntr_ctrl_reg_sel_128),
    .cntr_ctrl_reg_sel_228                 (cntr_ctrl_reg_sel_228),
    .cntr_ctrl_reg_sel_328                 (cntr_ctrl_reg_sel_328),
    .interval_reg_sel_128                  (interval_reg_sel_128),  
    .interval_reg_sel_228                  (interval_reg_sel_228), 
    .interval_reg_sel_328                  (interval_reg_sel_328),
    .match_1_reg_sel_128                   (match_1_reg_sel_128),     
    .match_1_reg_sel_228                   (match_1_reg_sel_228),
    .match_1_reg_sel_328                   (match_1_reg_sel_328),                
    .match_2_reg_sel_128                   (match_2_reg_sel_128),
    .match_2_reg_sel_228                   (match_2_reg_sel_228),
    .match_2_reg_sel_328                   (match_2_reg_sel_328),
    .match_3_reg_sel_128                   (match_3_reg_sel_128),
    .match_3_reg_sel_228                   (match_3_reg_sel_228),
    .match_3_reg_sel_328                   (match_3_reg_sel_328),
    .intr_en_reg_sel28                     (intr_en_reg_sel28),
    .clear_interrupt28                     (clear_interrupt28)

  );


   

  ttc_timer_counter_lite28 i_ttc_timer_counter_lite_128 ( 

    //inputs28
    .n_p_reset28                           (n_p_reset28),
    .pclk28                                (pclk28), 
    .pwdata28                              (pwdata28[15:0]),
    .clk_ctrl_reg_sel28                    (clk_ctrl_reg_sel_128),
    .cntr_ctrl_reg_sel28                   (cntr_ctrl_reg_sel_128),
    .interval_reg_sel28                    (interval_reg_sel_128),
    .match_1_reg_sel28                     (match_1_reg_sel_128),
    .match_2_reg_sel28                     (match_2_reg_sel_128),
    .match_3_reg_sel28                     (match_3_reg_sel_128),
    .intr_en_reg_sel28                     (intr_en_reg_sel28[1]),
    .clear_interrupt28                     (clear_interrupt28[1]),
                                  
    //outputs28
    .clk_ctrl_reg28                        (clk_ctrl_reg_128),
    .counter_val_reg28                     (counter_val_reg_128),
    .cntr_ctrl_reg28                       (cntr_ctrl_reg_128),
    .interval_reg28                        (interval_reg_128),
    .match_1_reg28                         (match_1_reg_128),
    .match_2_reg28                         (match_2_reg_128),
    .match_3_reg28                         (match_3_reg_128),
    .interrupt28                           (TTC_int28[1]),
    .interrupt_reg28                       (interrupt_reg_128),
    .interrupt_en_reg28                    (interrupt_en_reg_128)
  );


  ttc_timer_counter_lite28 i_ttc_timer_counter_lite_228 ( 

    //inputs28
    .n_p_reset28                           (n_p_reset28), 
    .pclk28                                (pclk28),
    .pwdata28                              (pwdata28[15:0]),
    .clk_ctrl_reg_sel28                    (clk_ctrl_reg_sel_228),
    .cntr_ctrl_reg_sel28                   (cntr_ctrl_reg_sel_228),
    .interval_reg_sel28                    (interval_reg_sel_228),
    .match_1_reg_sel28                     (match_1_reg_sel_228),
    .match_2_reg_sel28                     (match_2_reg_sel_228),
    .match_3_reg_sel28                     (match_3_reg_sel_228),
    .intr_en_reg_sel28                     (intr_en_reg_sel28[2]),
    .clear_interrupt28                     (clear_interrupt28[2]),
                                  
    //outputs28
    .clk_ctrl_reg28                        (clk_ctrl_reg_228),
    .counter_val_reg28                     (counter_val_reg_228),
    .cntr_ctrl_reg28                       (cntr_ctrl_reg_228),
    .interval_reg28                        (interval_reg_228),
    .match_1_reg28                         (match_1_reg_228),
    .match_2_reg28                         (match_2_reg_228),
    .match_3_reg28                         (match_3_reg_228),
    .interrupt28                           (TTC_int28[2]),
    .interrupt_reg28                       (interrupt_reg_228),
    .interrupt_en_reg28                    (interrupt_en_reg_228)
  );



  ttc_timer_counter_lite28 i_ttc_timer_counter_lite_328 ( 

    //inputs28
    .n_p_reset28                           (n_p_reset28), 
    .pclk28                                (pclk28),
    .pwdata28                              (pwdata28[15:0]),
    .clk_ctrl_reg_sel28                    (clk_ctrl_reg_sel_328),
    .cntr_ctrl_reg_sel28                   (cntr_ctrl_reg_sel_328),
    .interval_reg_sel28                    (interval_reg_sel_328),
    .match_1_reg_sel28                     (match_1_reg_sel_328),
    .match_2_reg_sel28                     (match_2_reg_sel_328),
    .match_3_reg_sel28                     (match_3_reg_sel_328),
    .intr_en_reg_sel28                     (intr_en_reg_sel28[3]),
    .clear_interrupt28                     (clear_interrupt28[3]),
                                              
    //outputs28
    .clk_ctrl_reg28                        (clk_ctrl_reg_328),
    .counter_val_reg28                     (counter_val_reg_328),
    .cntr_ctrl_reg28                       (cntr_ctrl_reg_328),
    .interval_reg28                        (interval_reg_328),
    .match_1_reg28                         (match_1_reg_328),
    .match_2_reg28                         (match_2_reg_328),
    .match_3_reg28                         (match_3_reg_328),
    .interrupt28                           (TTC_int28[3]),
    .interrupt_reg28                       (interrupt_reg_328),
    .interrupt_en_reg28                    (interrupt_en_reg_328)
  );





endmodule 
