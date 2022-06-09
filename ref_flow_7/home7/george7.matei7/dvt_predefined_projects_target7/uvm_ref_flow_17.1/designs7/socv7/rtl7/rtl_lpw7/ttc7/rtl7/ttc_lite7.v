//File7 name   : ttc_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : The top level of the Triple7 Timer7 Counter7.
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module7 definition7
//-----------------------------------------------------------------------------

module ttc_lite7(
           
           //inputs7
           n_p_reset7,
           pclk7,
           psel7,
           penable7,
           pwrite7,
           pwdata7,
           paddr7,
           scan_in7,
           scan_en7,

           //outputs7
           prdata7,
           interrupt7,
           scan_out7           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS7
//-----------------------------------------------------------------------------

   input         n_p_reset7;              //System7 Reset7
   input         pclk7;                 //System7 clock7
   input         psel7;                 //Select7 line
   input         penable7;              //Enable7
   input         pwrite7;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata7;               //Write data
   input [7:0]   paddr7;                //Address Bus7 register
   input         scan_in7;              //Scan7 chain7 input port
   input         scan_en7;              //Scan7 chain7 enable port
   
   output [31:0] prdata7;               //Read Data from the APB7 Interface7
   output [3:1]  interrupt7;            //Interrupt7 from PCI7 
   output        scan_out7;             //Scan7 chain7 output port

//-----------------------------------------------------------------------------
// Module7 Interconnect7
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int7;
   wire        clk_ctrl_reg_sel_17;     //Module7 1 clock7 control7 select7
   wire        clk_ctrl_reg_sel_27;     //Module7 2 clock7 control7 select7
   wire        clk_ctrl_reg_sel_37;     //Module7 3 clock7 control7 select7
   wire        cntr_ctrl_reg_sel_17;    //Module7 1 counter control7 select7
   wire        cntr_ctrl_reg_sel_27;    //Module7 2 counter control7 select7
   wire        cntr_ctrl_reg_sel_37;    //Module7 3 counter control7 select7
   wire        interval_reg_sel_17;     //Interval7 1 register select7
   wire        interval_reg_sel_27;     //Interval7 2 register select7
   wire        interval_reg_sel_37;     //Interval7 3 register select7
   wire        match_1_reg_sel_17;      //Module7 1 match 1 select7
   wire        match_1_reg_sel_27;      //Module7 1 match 2 select7
   wire        match_1_reg_sel_37;      //Module7 1 match 3 select7
   wire        match_2_reg_sel_17;      //Module7 2 match 1 select7
   wire        match_2_reg_sel_27;      //Module7 2 match 2 select7
   wire        match_2_reg_sel_37;      //Module7 2 match 3 select7
   wire        match_3_reg_sel_17;      //Module7 3 match 1 select7
   wire        match_3_reg_sel_27;      //Module7 3 match 2 select7
   wire        match_3_reg_sel_37;      //Module7 3 match 3 select7
   wire [3:1]  intr_en_reg_sel7;        //Interrupt7 enable register select7
   wire [3:1]  clear_interrupt7;        //Clear interrupt7 signal7
   wire [5:0]  interrupt_reg_17;        //Interrupt7 register 1
   wire [5:0]  interrupt_reg_27;        //Interrupt7 register 2
   wire [5:0]  interrupt_reg_37;        //Interrupt7 register 3 
   wire [5:0]  interrupt_en_reg_17;     //Interrupt7 enable register 1
   wire [5:0]  interrupt_en_reg_27;     //Interrupt7 enable register 2
   wire [5:0]  interrupt_en_reg_37;     //Interrupt7 enable register 3
   wire [6:0]  clk_ctrl_reg_17;         //Clock7 control7 regs for the 
   wire [6:0]  clk_ctrl_reg_27;         //Timer_Counter7 1,2,3
   wire [6:0]  clk_ctrl_reg_37;         //Value of the clock7 frequency7
   wire [15:0] counter_val_reg_17;      //Module7 1 counter value 
   wire [15:0] counter_val_reg_27;      //Module7 2 counter value 
   wire [15:0] counter_val_reg_37;      //Module7 3 counter value 
   wire [6:0]  cntr_ctrl_reg_17;        //Module7 1 counter control7  
   wire [6:0]  cntr_ctrl_reg_27;        //Module7 2 counter control7  
   wire [6:0]  cntr_ctrl_reg_37;        //Module7 3 counter control7  
   wire [15:0] interval_reg_17;         //Module7 1 interval7 register
   wire [15:0] interval_reg_27;         //Module7 2 interval7 register
   wire [15:0] interval_reg_37;         //Module7 3 interval7 register
   wire [15:0] match_1_reg_17;          //Module7 1 match 1 register
   wire [15:0] match_1_reg_27;          //Module7 1 match 2 register
   wire [15:0] match_1_reg_37;          //Module7 1 match 3 register
   wire [15:0] match_2_reg_17;          //Module7 2 match 1 register
   wire [15:0] match_2_reg_27;          //Module7 2 match 2 register
   wire [15:0] match_2_reg_37;          //Module7 2 match 3 register
   wire [15:0] match_3_reg_17;          //Module7 3 match 1 register
   wire [15:0] match_3_reg_27;          //Module7 3 match 2 register
   wire [15:0] match_3_reg_37;          //Module7 3 match 3 register

  assign interrupt7 = TTC_int7;   // Bug7 Fix7 for floating7 ints - Santhosh7 8 Nov7 06
   

//-----------------------------------------------------------------------------
// Module7 Instantiations7
//-----------------------------------------------------------------------------


  ttc_interface_lite7 i_ttc_interface_lite7 ( 

    //inputs7
    .n_p_reset7                           (n_p_reset7),
    .pclk7                                (pclk7),
    .psel7                                (psel7),
    .penable7                             (penable7),
    .pwrite7                              (pwrite7),
    .paddr7                               (paddr7),
    .clk_ctrl_reg_17                      (clk_ctrl_reg_17),
    .clk_ctrl_reg_27                      (clk_ctrl_reg_27),
    .clk_ctrl_reg_37                      (clk_ctrl_reg_37),
    .cntr_ctrl_reg_17                     (cntr_ctrl_reg_17),
    .cntr_ctrl_reg_27                     (cntr_ctrl_reg_27),
    .cntr_ctrl_reg_37                     (cntr_ctrl_reg_37),
    .counter_val_reg_17                   (counter_val_reg_17),
    .counter_val_reg_27                   (counter_val_reg_27),
    .counter_val_reg_37                   (counter_val_reg_37),
    .interval_reg_17                      (interval_reg_17),
    .match_1_reg_17                       (match_1_reg_17),
    .match_2_reg_17                       (match_2_reg_17),
    .match_3_reg_17                       (match_3_reg_17),
    .interval_reg_27                      (interval_reg_27),
    .match_1_reg_27                       (match_1_reg_27),
    .match_2_reg_27                       (match_2_reg_27),
    .match_3_reg_27                       (match_3_reg_27),
    .interval_reg_37                      (interval_reg_37),
    .match_1_reg_37                       (match_1_reg_37),
    .match_2_reg_37                       (match_2_reg_37),
    .match_3_reg_37                       (match_3_reg_37),
    .interrupt_reg_17                     (interrupt_reg_17),
    .interrupt_reg_27                     (interrupt_reg_27),
    .interrupt_reg_37                     (interrupt_reg_37), 
    .interrupt_en_reg_17                  (interrupt_en_reg_17),
    .interrupt_en_reg_27                  (interrupt_en_reg_27),
    .interrupt_en_reg_37                  (interrupt_en_reg_37), 

    //outputs7
    .prdata7                              (prdata7),
    .clk_ctrl_reg_sel_17                  (clk_ctrl_reg_sel_17),
    .clk_ctrl_reg_sel_27                  (clk_ctrl_reg_sel_27),
    .clk_ctrl_reg_sel_37                  (clk_ctrl_reg_sel_37),
    .cntr_ctrl_reg_sel_17                 (cntr_ctrl_reg_sel_17),
    .cntr_ctrl_reg_sel_27                 (cntr_ctrl_reg_sel_27),
    .cntr_ctrl_reg_sel_37                 (cntr_ctrl_reg_sel_37),
    .interval_reg_sel_17                  (interval_reg_sel_17),  
    .interval_reg_sel_27                  (interval_reg_sel_27), 
    .interval_reg_sel_37                  (interval_reg_sel_37),
    .match_1_reg_sel_17                   (match_1_reg_sel_17),     
    .match_1_reg_sel_27                   (match_1_reg_sel_27),
    .match_1_reg_sel_37                   (match_1_reg_sel_37),                
    .match_2_reg_sel_17                   (match_2_reg_sel_17),
    .match_2_reg_sel_27                   (match_2_reg_sel_27),
    .match_2_reg_sel_37                   (match_2_reg_sel_37),
    .match_3_reg_sel_17                   (match_3_reg_sel_17),
    .match_3_reg_sel_27                   (match_3_reg_sel_27),
    .match_3_reg_sel_37                   (match_3_reg_sel_37),
    .intr_en_reg_sel7                     (intr_en_reg_sel7),
    .clear_interrupt7                     (clear_interrupt7)

  );


   

  ttc_timer_counter_lite7 i_ttc_timer_counter_lite_17 ( 

    //inputs7
    .n_p_reset7                           (n_p_reset7),
    .pclk7                                (pclk7), 
    .pwdata7                              (pwdata7[15:0]),
    .clk_ctrl_reg_sel7                    (clk_ctrl_reg_sel_17),
    .cntr_ctrl_reg_sel7                   (cntr_ctrl_reg_sel_17),
    .interval_reg_sel7                    (interval_reg_sel_17),
    .match_1_reg_sel7                     (match_1_reg_sel_17),
    .match_2_reg_sel7                     (match_2_reg_sel_17),
    .match_3_reg_sel7                     (match_3_reg_sel_17),
    .intr_en_reg_sel7                     (intr_en_reg_sel7[1]),
    .clear_interrupt7                     (clear_interrupt7[1]),
                                  
    //outputs7
    .clk_ctrl_reg7                        (clk_ctrl_reg_17),
    .counter_val_reg7                     (counter_val_reg_17),
    .cntr_ctrl_reg7                       (cntr_ctrl_reg_17),
    .interval_reg7                        (interval_reg_17),
    .match_1_reg7                         (match_1_reg_17),
    .match_2_reg7                         (match_2_reg_17),
    .match_3_reg7                         (match_3_reg_17),
    .interrupt7                           (TTC_int7[1]),
    .interrupt_reg7                       (interrupt_reg_17),
    .interrupt_en_reg7                    (interrupt_en_reg_17)
  );


  ttc_timer_counter_lite7 i_ttc_timer_counter_lite_27 ( 

    //inputs7
    .n_p_reset7                           (n_p_reset7), 
    .pclk7                                (pclk7),
    .pwdata7                              (pwdata7[15:0]),
    .clk_ctrl_reg_sel7                    (clk_ctrl_reg_sel_27),
    .cntr_ctrl_reg_sel7                   (cntr_ctrl_reg_sel_27),
    .interval_reg_sel7                    (interval_reg_sel_27),
    .match_1_reg_sel7                     (match_1_reg_sel_27),
    .match_2_reg_sel7                     (match_2_reg_sel_27),
    .match_3_reg_sel7                     (match_3_reg_sel_27),
    .intr_en_reg_sel7                     (intr_en_reg_sel7[2]),
    .clear_interrupt7                     (clear_interrupt7[2]),
                                  
    //outputs7
    .clk_ctrl_reg7                        (clk_ctrl_reg_27),
    .counter_val_reg7                     (counter_val_reg_27),
    .cntr_ctrl_reg7                       (cntr_ctrl_reg_27),
    .interval_reg7                        (interval_reg_27),
    .match_1_reg7                         (match_1_reg_27),
    .match_2_reg7                         (match_2_reg_27),
    .match_3_reg7                         (match_3_reg_27),
    .interrupt7                           (TTC_int7[2]),
    .interrupt_reg7                       (interrupt_reg_27),
    .interrupt_en_reg7                    (interrupt_en_reg_27)
  );



  ttc_timer_counter_lite7 i_ttc_timer_counter_lite_37 ( 

    //inputs7
    .n_p_reset7                           (n_p_reset7), 
    .pclk7                                (pclk7),
    .pwdata7                              (pwdata7[15:0]),
    .clk_ctrl_reg_sel7                    (clk_ctrl_reg_sel_37),
    .cntr_ctrl_reg_sel7                   (cntr_ctrl_reg_sel_37),
    .interval_reg_sel7                    (interval_reg_sel_37),
    .match_1_reg_sel7                     (match_1_reg_sel_37),
    .match_2_reg_sel7                     (match_2_reg_sel_37),
    .match_3_reg_sel7                     (match_3_reg_sel_37),
    .intr_en_reg_sel7                     (intr_en_reg_sel7[3]),
    .clear_interrupt7                     (clear_interrupt7[3]),
                                              
    //outputs7
    .clk_ctrl_reg7                        (clk_ctrl_reg_37),
    .counter_val_reg7                     (counter_val_reg_37),
    .cntr_ctrl_reg7                       (cntr_ctrl_reg_37),
    .interval_reg7                        (interval_reg_37),
    .match_1_reg7                         (match_1_reg_37),
    .match_2_reg7                         (match_2_reg_37),
    .match_3_reg7                         (match_3_reg_37),
    .interrupt7                           (TTC_int7[3]),
    .interrupt_reg7                       (interrupt_reg_37),
    .interrupt_en_reg7                    (interrupt_en_reg_37)
  );





endmodule 
