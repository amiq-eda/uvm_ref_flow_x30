//File9 name   : ttc_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : The top level of the Triple9 Timer9 Counter9.
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module9 definition9
//-----------------------------------------------------------------------------

module ttc_lite9(
           
           //inputs9
           n_p_reset9,
           pclk9,
           psel9,
           penable9,
           pwrite9,
           pwdata9,
           paddr9,
           scan_in9,
           scan_en9,

           //outputs9
           prdata9,
           interrupt9,
           scan_out9           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS9
//-----------------------------------------------------------------------------

   input         n_p_reset9;              //System9 Reset9
   input         pclk9;                 //System9 clock9
   input         psel9;                 //Select9 line
   input         penable9;              //Enable9
   input         pwrite9;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata9;               //Write data
   input [7:0]   paddr9;                //Address Bus9 register
   input         scan_in9;              //Scan9 chain9 input port
   input         scan_en9;              //Scan9 chain9 enable port
   
   output [31:0] prdata9;               //Read Data from the APB9 Interface9
   output [3:1]  interrupt9;            //Interrupt9 from PCI9 
   output        scan_out9;             //Scan9 chain9 output port

//-----------------------------------------------------------------------------
// Module9 Interconnect9
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int9;
   wire        clk_ctrl_reg_sel_19;     //Module9 1 clock9 control9 select9
   wire        clk_ctrl_reg_sel_29;     //Module9 2 clock9 control9 select9
   wire        clk_ctrl_reg_sel_39;     //Module9 3 clock9 control9 select9
   wire        cntr_ctrl_reg_sel_19;    //Module9 1 counter control9 select9
   wire        cntr_ctrl_reg_sel_29;    //Module9 2 counter control9 select9
   wire        cntr_ctrl_reg_sel_39;    //Module9 3 counter control9 select9
   wire        interval_reg_sel_19;     //Interval9 1 register select9
   wire        interval_reg_sel_29;     //Interval9 2 register select9
   wire        interval_reg_sel_39;     //Interval9 3 register select9
   wire        match_1_reg_sel_19;      //Module9 1 match 1 select9
   wire        match_1_reg_sel_29;      //Module9 1 match 2 select9
   wire        match_1_reg_sel_39;      //Module9 1 match 3 select9
   wire        match_2_reg_sel_19;      //Module9 2 match 1 select9
   wire        match_2_reg_sel_29;      //Module9 2 match 2 select9
   wire        match_2_reg_sel_39;      //Module9 2 match 3 select9
   wire        match_3_reg_sel_19;      //Module9 3 match 1 select9
   wire        match_3_reg_sel_29;      //Module9 3 match 2 select9
   wire        match_3_reg_sel_39;      //Module9 3 match 3 select9
   wire [3:1]  intr_en_reg_sel9;        //Interrupt9 enable register select9
   wire [3:1]  clear_interrupt9;        //Clear interrupt9 signal9
   wire [5:0]  interrupt_reg_19;        //Interrupt9 register 1
   wire [5:0]  interrupt_reg_29;        //Interrupt9 register 2
   wire [5:0]  interrupt_reg_39;        //Interrupt9 register 3 
   wire [5:0]  interrupt_en_reg_19;     //Interrupt9 enable register 1
   wire [5:0]  interrupt_en_reg_29;     //Interrupt9 enable register 2
   wire [5:0]  interrupt_en_reg_39;     //Interrupt9 enable register 3
   wire [6:0]  clk_ctrl_reg_19;         //Clock9 control9 regs for the 
   wire [6:0]  clk_ctrl_reg_29;         //Timer_Counter9 1,2,3
   wire [6:0]  clk_ctrl_reg_39;         //Value of the clock9 frequency9
   wire [15:0] counter_val_reg_19;      //Module9 1 counter value 
   wire [15:0] counter_val_reg_29;      //Module9 2 counter value 
   wire [15:0] counter_val_reg_39;      //Module9 3 counter value 
   wire [6:0]  cntr_ctrl_reg_19;        //Module9 1 counter control9  
   wire [6:0]  cntr_ctrl_reg_29;        //Module9 2 counter control9  
   wire [6:0]  cntr_ctrl_reg_39;        //Module9 3 counter control9  
   wire [15:0] interval_reg_19;         //Module9 1 interval9 register
   wire [15:0] interval_reg_29;         //Module9 2 interval9 register
   wire [15:0] interval_reg_39;         //Module9 3 interval9 register
   wire [15:0] match_1_reg_19;          //Module9 1 match 1 register
   wire [15:0] match_1_reg_29;          //Module9 1 match 2 register
   wire [15:0] match_1_reg_39;          //Module9 1 match 3 register
   wire [15:0] match_2_reg_19;          //Module9 2 match 1 register
   wire [15:0] match_2_reg_29;          //Module9 2 match 2 register
   wire [15:0] match_2_reg_39;          //Module9 2 match 3 register
   wire [15:0] match_3_reg_19;          //Module9 3 match 1 register
   wire [15:0] match_3_reg_29;          //Module9 3 match 2 register
   wire [15:0] match_3_reg_39;          //Module9 3 match 3 register

  assign interrupt9 = TTC_int9;   // Bug9 Fix9 for floating9 ints - Santhosh9 8 Nov9 06
   

//-----------------------------------------------------------------------------
// Module9 Instantiations9
//-----------------------------------------------------------------------------


  ttc_interface_lite9 i_ttc_interface_lite9 ( 

    //inputs9
    .n_p_reset9                           (n_p_reset9),
    .pclk9                                (pclk9),
    .psel9                                (psel9),
    .penable9                             (penable9),
    .pwrite9                              (pwrite9),
    .paddr9                               (paddr9),
    .clk_ctrl_reg_19                      (clk_ctrl_reg_19),
    .clk_ctrl_reg_29                      (clk_ctrl_reg_29),
    .clk_ctrl_reg_39                      (clk_ctrl_reg_39),
    .cntr_ctrl_reg_19                     (cntr_ctrl_reg_19),
    .cntr_ctrl_reg_29                     (cntr_ctrl_reg_29),
    .cntr_ctrl_reg_39                     (cntr_ctrl_reg_39),
    .counter_val_reg_19                   (counter_val_reg_19),
    .counter_val_reg_29                   (counter_val_reg_29),
    .counter_val_reg_39                   (counter_val_reg_39),
    .interval_reg_19                      (interval_reg_19),
    .match_1_reg_19                       (match_1_reg_19),
    .match_2_reg_19                       (match_2_reg_19),
    .match_3_reg_19                       (match_3_reg_19),
    .interval_reg_29                      (interval_reg_29),
    .match_1_reg_29                       (match_1_reg_29),
    .match_2_reg_29                       (match_2_reg_29),
    .match_3_reg_29                       (match_3_reg_29),
    .interval_reg_39                      (interval_reg_39),
    .match_1_reg_39                       (match_1_reg_39),
    .match_2_reg_39                       (match_2_reg_39),
    .match_3_reg_39                       (match_3_reg_39),
    .interrupt_reg_19                     (interrupt_reg_19),
    .interrupt_reg_29                     (interrupt_reg_29),
    .interrupt_reg_39                     (interrupt_reg_39), 
    .interrupt_en_reg_19                  (interrupt_en_reg_19),
    .interrupt_en_reg_29                  (interrupt_en_reg_29),
    .interrupt_en_reg_39                  (interrupt_en_reg_39), 

    //outputs9
    .prdata9                              (prdata9),
    .clk_ctrl_reg_sel_19                  (clk_ctrl_reg_sel_19),
    .clk_ctrl_reg_sel_29                  (clk_ctrl_reg_sel_29),
    .clk_ctrl_reg_sel_39                  (clk_ctrl_reg_sel_39),
    .cntr_ctrl_reg_sel_19                 (cntr_ctrl_reg_sel_19),
    .cntr_ctrl_reg_sel_29                 (cntr_ctrl_reg_sel_29),
    .cntr_ctrl_reg_sel_39                 (cntr_ctrl_reg_sel_39),
    .interval_reg_sel_19                  (interval_reg_sel_19),  
    .interval_reg_sel_29                  (interval_reg_sel_29), 
    .interval_reg_sel_39                  (interval_reg_sel_39),
    .match_1_reg_sel_19                   (match_1_reg_sel_19),     
    .match_1_reg_sel_29                   (match_1_reg_sel_29),
    .match_1_reg_sel_39                   (match_1_reg_sel_39),                
    .match_2_reg_sel_19                   (match_2_reg_sel_19),
    .match_2_reg_sel_29                   (match_2_reg_sel_29),
    .match_2_reg_sel_39                   (match_2_reg_sel_39),
    .match_3_reg_sel_19                   (match_3_reg_sel_19),
    .match_3_reg_sel_29                   (match_3_reg_sel_29),
    .match_3_reg_sel_39                   (match_3_reg_sel_39),
    .intr_en_reg_sel9                     (intr_en_reg_sel9),
    .clear_interrupt9                     (clear_interrupt9)

  );


   

  ttc_timer_counter_lite9 i_ttc_timer_counter_lite_19 ( 

    //inputs9
    .n_p_reset9                           (n_p_reset9),
    .pclk9                                (pclk9), 
    .pwdata9                              (pwdata9[15:0]),
    .clk_ctrl_reg_sel9                    (clk_ctrl_reg_sel_19),
    .cntr_ctrl_reg_sel9                   (cntr_ctrl_reg_sel_19),
    .interval_reg_sel9                    (interval_reg_sel_19),
    .match_1_reg_sel9                     (match_1_reg_sel_19),
    .match_2_reg_sel9                     (match_2_reg_sel_19),
    .match_3_reg_sel9                     (match_3_reg_sel_19),
    .intr_en_reg_sel9                     (intr_en_reg_sel9[1]),
    .clear_interrupt9                     (clear_interrupt9[1]),
                                  
    //outputs9
    .clk_ctrl_reg9                        (clk_ctrl_reg_19),
    .counter_val_reg9                     (counter_val_reg_19),
    .cntr_ctrl_reg9                       (cntr_ctrl_reg_19),
    .interval_reg9                        (interval_reg_19),
    .match_1_reg9                         (match_1_reg_19),
    .match_2_reg9                         (match_2_reg_19),
    .match_3_reg9                         (match_3_reg_19),
    .interrupt9                           (TTC_int9[1]),
    .interrupt_reg9                       (interrupt_reg_19),
    .interrupt_en_reg9                    (interrupt_en_reg_19)
  );


  ttc_timer_counter_lite9 i_ttc_timer_counter_lite_29 ( 

    //inputs9
    .n_p_reset9                           (n_p_reset9), 
    .pclk9                                (pclk9),
    .pwdata9                              (pwdata9[15:0]),
    .clk_ctrl_reg_sel9                    (clk_ctrl_reg_sel_29),
    .cntr_ctrl_reg_sel9                   (cntr_ctrl_reg_sel_29),
    .interval_reg_sel9                    (interval_reg_sel_29),
    .match_1_reg_sel9                     (match_1_reg_sel_29),
    .match_2_reg_sel9                     (match_2_reg_sel_29),
    .match_3_reg_sel9                     (match_3_reg_sel_29),
    .intr_en_reg_sel9                     (intr_en_reg_sel9[2]),
    .clear_interrupt9                     (clear_interrupt9[2]),
                                  
    //outputs9
    .clk_ctrl_reg9                        (clk_ctrl_reg_29),
    .counter_val_reg9                     (counter_val_reg_29),
    .cntr_ctrl_reg9                       (cntr_ctrl_reg_29),
    .interval_reg9                        (interval_reg_29),
    .match_1_reg9                         (match_1_reg_29),
    .match_2_reg9                         (match_2_reg_29),
    .match_3_reg9                         (match_3_reg_29),
    .interrupt9                           (TTC_int9[2]),
    .interrupt_reg9                       (interrupt_reg_29),
    .interrupt_en_reg9                    (interrupt_en_reg_29)
  );



  ttc_timer_counter_lite9 i_ttc_timer_counter_lite_39 ( 

    //inputs9
    .n_p_reset9                           (n_p_reset9), 
    .pclk9                                (pclk9),
    .pwdata9                              (pwdata9[15:0]),
    .clk_ctrl_reg_sel9                    (clk_ctrl_reg_sel_39),
    .cntr_ctrl_reg_sel9                   (cntr_ctrl_reg_sel_39),
    .interval_reg_sel9                    (interval_reg_sel_39),
    .match_1_reg_sel9                     (match_1_reg_sel_39),
    .match_2_reg_sel9                     (match_2_reg_sel_39),
    .match_3_reg_sel9                     (match_3_reg_sel_39),
    .intr_en_reg_sel9                     (intr_en_reg_sel9[3]),
    .clear_interrupt9                     (clear_interrupt9[3]),
                                              
    //outputs9
    .clk_ctrl_reg9                        (clk_ctrl_reg_39),
    .counter_val_reg9                     (counter_val_reg_39),
    .cntr_ctrl_reg9                       (cntr_ctrl_reg_39),
    .interval_reg9                        (interval_reg_39),
    .match_1_reg9                         (match_1_reg_39),
    .match_2_reg9                         (match_2_reg_39),
    .match_3_reg9                         (match_3_reg_39),
    .interrupt9                           (TTC_int9[3]),
    .interrupt_reg9                       (interrupt_reg_39),
    .interrupt_en_reg9                    (interrupt_en_reg_39)
  );





endmodule 
