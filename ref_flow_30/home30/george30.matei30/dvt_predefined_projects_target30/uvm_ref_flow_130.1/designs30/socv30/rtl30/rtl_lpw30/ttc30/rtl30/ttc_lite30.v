//File30 name   : ttc_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : The top level of the Triple30 Timer30 Counter30.
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

module ttc_lite30(
           
           //inputs30
           n_p_reset30,
           pclk30,
           psel30,
           penable30,
           pwrite30,
           pwdata30,
           paddr30,
           scan_in30,
           scan_en30,

           //outputs30
           prdata30,
           interrupt30,
           scan_out30           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS30
//-----------------------------------------------------------------------------

   input         n_p_reset30;              //System30 Reset30
   input         pclk30;                 //System30 clock30
   input         psel30;                 //Select30 line
   input         penable30;              //Enable30
   input         pwrite30;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata30;               //Write data
   input [7:0]   paddr30;                //Address Bus30 register
   input         scan_in30;              //Scan30 chain30 input port
   input         scan_en30;              //Scan30 chain30 enable port
   
   output [31:0] prdata30;               //Read Data from the APB30 Interface30
   output [3:1]  interrupt30;            //Interrupt30 from PCI30 
   output        scan_out30;             //Scan30 chain30 output port

//-----------------------------------------------------------------------------
// Module30 Interconnect30
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int30;
   wire        clk_ctrl_reg_sel_130;     //Module30 1 clock30 control30 select30
   wire        clk_ctrl_reg_sel_230;     //Module30 2 clock30 control30 select30
   wire        clk_ctrl_reg_sel_330;     //Module30 3 clock30 control30 select30
   wire        cntr_ctrl_reg_sel_130;    //Module30 1 counter control30 select30
   wire        cntr_ctrl_reg_sel_230;    //Module30 2 counter control30 select30
   wire        cntr_ctrl_reg_sel_330;    //Module30 3 counter control30 select30
   wire        interval_reg_sel_130;     //Interval30 1 register select30
   wire        interval_reg_sel_230;     //Interval30 2 register select30
   wire        interval_reg_sel_330;     //Interval30 3 register select30
   wire        match_1_reg_sel_130;      //Module30 1 match 1 select30
   wire        match_1_reg_sel_230;      //Module30 1 match 2 select30
   wire        match_1_reg_sel_330;      //Module30 1 match 3 select30
   wire        match_2_reg_sel_130;      //Module30 2 match 1 select30
   wire        match_2_reg_sel_230;      //Module30 2 match 2 select30
   wire        match_2_reg_sel_330;      //Module30 2 match 3 select30
   wire        match_3_reg_sel_130;      //Module30 3 match 1 select30
   wire        match_3_reg_sel_230;      //Module30 3 match 2 select30
   wire        match_3_reg_sel_330;      //Module30 3 match 3 select30
   wire [3:1]  intr_en_reg_sel30;        //Interrupt30 enable register select30
   wire [3:1]  clear_interrupt30;        //Clear interrupt30 signal30
   wire [5:0]  interrupt_reg_130;        //Interrupt30 register 1
   wire [5:0]  interrupt_reg_230;        //Interrupt30 register 2
   wire [5:0]  interrupt_reg_330;        //Interrupt30 register 3 
   wire [5:0]  interrupt_en_reg_130;     //Interrupt30 enable register 1
   wire [5:0]  interrupt_en_reg_230;     //Interrupt30 enable register 2
   wire [5:0]  interrupt_en_reg_330;     //Interrupt30 enable register 3
   wire [6:0]  clk_ctrl_reg_130;         //Clock30 control30 regs for the 
   wire [6:0]  clk_ctrl_reg_230;         //Timer_Counter30 1,2,3
   wire [6:0]  clk_ctrl_reg_330;         //Value of the clock30 frequency30
   wire [15:0] counter_val_reg_130;      //Module30 1 counter value 
   wire [15:0] counter_val_reg_230;      //Module30 2 counter value 
   wire [15:0] counter_val_reg_330;      //Module30 3 counter value 
   wire [6:0]  cntr_ctrl_reg_130;        //Module30 1 counter control30  
   wire [6:0]  cntr_ctrl_reg_230;        //Module30 2 counter control30  
   wire [6:0]  cntr_ctrl_reg_330;        //Module30 3 counter control30  
   wire [15:0] interval_reg_130;         //Module30 1 interval30 register
   wire [15:0] interval_reg_230;         //Module30 2 interval30 register
   wire [15:0] interval_reg_330;         //Module30 3 interval30 register
   wire [15:0] match_1_reg_130;          //Module30 1 match 1 register
   wire [15:0] match_1_reg_230;          //Module30 1 match 2 register
   wire [15:0] match_1_reg_330;          //Module30 1 match 3 register
   wire [15:0] match_2_reg_130;          //Module30 2 match 1 register
   wire [15:0] match_2_reg_230;          //Module30 2 match 2 register
   wire [15:0] match_2_reg_330;          //Module30 2 match 3 register
   wire [15:0] match_3_reg_130;          //Module30 3 match 1 register
   wire [15:0] match_3_reg_230;          //Module30 3 match 2 register
   wire [15:0] match_3_reg_330;          //Module30 3 match 3 register

  assign interrupt30 = TTC_int30;   // Bug30 Fix30 for floating30 ints - Santhosh30 8 Nov30 06
   

//-----------------------------------------------------------------------------
// Module30 Instantiations30
//-----------------------------------------------------------------------------


  ttc_interface_lite30 i_ttc_interface_lite30 ( 

    //inputs30
    .n_p_reset30                           (n_p_reset30),
    .pclk30                                (pclk30),
    .psel30                                (psel30),
    .penable30                             (penable30),
    .pwrite30                              (pwrite30),
    .paddr30                               (paddr30),
    .clk_ctrl_reg_130                      (clk_ctrl_reg_130),
    .clk_ctrl_reg_230                      (clk_ctrl_reg_230),
    .clk_ctrl_reg_330                      (clk_ctrl_reg_330),
    .cntr_ctrl_reg_130                     (cntr_ctrl_reg_130),
    .cntr_ctrl_reg_230                     (cntr_ctrl_reg_230),
    .cntr_ctrl_reg_330                     (cntr_ctrl_reg_330),
    .counter_val_reg_130                   (counter_val_reg_130),
    .counter_val_reg_230                   (counter_val_reg_230),
    .counter_val_reg_330                   (counter_val_reg_330),
    .interval_reg_130                      (interval_reg_130),
    .match_1_reg_130                       (match_1_reg_130),
    .match_2_reg_130                       (match_2_reg_130),
    .match_3_reg_130                       (match_3_reg_130),
    .interval_reg_230                      (interval_reg_230),
    .match_1_reg_230                       (match_1_reg_230),
    .match_2_reg_230                       (match_2_reg_230),
    .match_3_reg_230                       (match_3_reg_230),
    .interval_reg_330                      (interval_reg_330),
    .match_1_reg_330                       (match_1_reg_330),
    .match_2_reg_330                       (match_2_reg_330),
    .match_3_reg_330                       (match_3_reg_330),
    .interrupt_reg_130                     (interrupt_reg_130),
    .interrupt_reg_230                     (interrupt_reg_230),
    .interrupt_reg_330                     (interrupt_reg_330), 
    .interrupt_en_reg_130                  (interrupt_en_reg_130),
    .interrupt_en_reg_230                  (interrupt_en_reg_230),
    .interrupt_en_reg_330                  (interrupt_en_reg_330), 

    //outputs30
    .prdata30                              (prdata30),
    .clk_ctrl_reg_sel_130                  (clk_ctrl_reg_sel_130),
    .clk_ctrl_reg_sel_230                  (clk_ctrl_reg_sel_230),
    .clk_ctrl_reg_sel_330                  (clk_ctrl_reg_sel_330),
    .cntr_ctrl_reg_sel_130                 (cntr_ctrl_reg_sel_130),
    .cntr_ctrl_reg_sel_230                 (cntr_ctrl_reg_sel_230),
    .cntr_ctrl_reg_sel_330                 (cntr_ctrl_reg_sel_330),
    .interval_reg_sel_130                  (interval_reg_sel_130),  
    .interval_reg_sel_230                  (interval_reg_sel_230), 
    .interval_reg_sel_330                  (interval_reg_sel_330),
    .match_1_reg_sel_130                   (match_1_reg_sel_130),     
    .match_1_reg_sel_230                   (match_1_reg_sel_230),
    .match_1_reg_sel_330                   (match_1_reg_sel_330),                
    .match_2_reg_sel_130                   (match_2_reg_sel_130),
    .match_2_reg_sel_230                   (match_2_reg_sel_230),
    .match_2_reg_sel_330                   (match_2_reg_sel_330),
    .match_3_reg_sel_130                   (match_3_reg_sel_130),
    .match_3_reg_sel_230                   (match_3_reg_sel_230),
    .match_3_reg_sel_330                   (match_3_reg_sel_330),
    .intr_en_reg_sel30                     (intr_en_reg_sel30),
    .clear_interrupt30                     (clear_interrupt30)

  );


   

  ttc_timer_counter_lite30 i_ttc_timer_counter_lite_130 ( 

    //inputs30
    .n_p_reset30                           (n_p_reset30),
    .pclk30                                (pclk30), 
    .pwdata30                              (pwdata30[15:0]),
    .clk_ctrl_reg_sel30                    (clk_ctrl_reg_sel_130),
    .cntr_ctrl_reg_sel30                   (cntr_ctrl_reg_sel_130),
    .interval_reg_sel30                    (interval_reg_sel_130),
    .match_1_reg_sel30                     (match_1_reg_sel_130),
    .match_2_reg_sel30                     (match_2_reg_sel_130),
    .match_3_reg_sel30                     (match_3_reg_sel_130),
    .intr_en_reg_sel30                     (intr_en_reg_sel30[1]),
    .clear_interrupt30                     (clear_interrupt30[1]),
                                  
    //outputs30
    .clk_ctrl_reg30                        (clk_ctrl_reg_130),
    .counter_val_reg30                     (counter_val_reg_130),
    .cntr_ctrl_reg30                       (cntr_ctrl_reg_130),
    .interval_reg30                        (interval_reg_130),
    .match_1_reg30                         (match_1_reg_130),
    .match_2_reg30                         (match_2_reg_130),
    .match_3_reg30                         (match_3_reg_130),
    .interrupt30                           (TTC_int30[1]),
    .interrupt_reg30                       (interrupt_reg_130),
    .interrupt_en_reg30                    (interrupt_en_reg_130)
  );


  ttc_timer_counter_lite30 i_ttc_timer_counter_lite_230 ( 

    //inputs30
    .n_p_reset30                           (n_p_reset30), 
    .pclk30                                (pclk30),
    .pwdata30                              (pwdata30[15:0]),
    .clk_ctrl_reg_sel30                    (clk_ctrl_reg_sel_230),
    .cntr_ctrl_reg_sel30                   (cntr_ctrl_reg_sel_230),
    .interval_reg_sel30                    (interval_reg_sel_230),
    .match_1_reg_sel30                     (match_1_reg_sel_230),
    .match_2_reg_sel30                     (match_2_reg_sel_230),
    .match_3_reg_sel30                     (match_3_reg_sel_230),
    .intr_en_reg_sel30                     (intr_en_reg_sel30[2]),
    .clear_interrupt30                     (clear_interrupt30[2]),
                                  
    //outputs30
    .clk_ctrl_reg30                        (clk_ctrl_reg_230),
    .counter_val_reg30                     (counter_val_reg_230),
    .cntr_ctrl_reg30                       (cntr_ctrl_reg_230),
    .interval_reg30                        (interval_reg_230),
    .match_1_reg30                         (match_1_reg_230),
    .match_2_reg30                         (match_2_reg_230),
    .match_3_reg30                         (match_3_reg_230),
    .interrupt30                           (TTC_int30[2]),
    .interrupt_reg30                       (interrupt_reg_230),
    .interrupt_en_reg30                    (interrupt_en_reg_230)
  );



  ttc_timer_counter_lite30 i_ttc_timer_counter_lite_330 ( 

    //inputs30
    .n_p_reset30                           (n_p_reset30), 
    .pclk30                                (pclk30),
    .pwdata30                              (pwdata30[15:0]),
    .clk_ctrl_reg_sel30                    (clk_ctrl_reg_sel_330),
    .cntr_ctrl_reg_sel30                   (cntr_ctrl_reg_sel_330),
    .interval_reg_sel30                    (interval_reg_sel_330),
    .match_1_reg_sel30                     (match_1_reg_sel_330),
    .match_2_reg_sel30                     (match_2_reg_sel_330),
    .match_3_reg_sel30                     (match_3_reg_sel_330),
    .intr_en_reg_sel30                     (intr_en_reg_sel30[3]),
    .clear_interrupt30                     (clear_interrupt30[3]),
                                              
    //outputs30
    .clk_ctrl_reg30                        (clk_ctrl_reg_330),
    .counter_val_reg30                     (counter_val_reg_330),
    .cntr_ctrl_reg30                       (cntr_ctrl_reg_330),
    .interval_reg30                        (interval_reg_330),
    .match_1_reg30                         (match_1_reg_330),
    .match_2_reg30                         (match_2_reg_330),
    .match_3_reg30                         (match_3_reg_330),
    .interrupt30                           (TTC_int30[3]),
    .interrupt_reg30                       (interrupt_reg_330),
    .interrupt_en_reg30                    (interrupt_en_reg_330)
  );





endmodule 
