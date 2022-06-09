//File5 name   : ttc_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : The top level of the Triple5 Timer5 Counter5.
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module5 definition5
//-----------------------------------------------------------------------------

module ttc_lite5(
           
           //inputs5
           n_p_reset5,
           pclk5,
           psel5,
           penable5,
           pwrite5,
           pwdata5,
           paddr5,
           scan_in5,
           scan_en5,

           //outputs5
           prdata5,
           interrupt5,
           scan_out5           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS5
//-----------------------------------------------------------------------------

   input         n_p_reset5;              //System5 Reset5
   input         pclk5;                 //System5 clock5
   input         psel5;                 //Select5 line
   input         penable5;              //Enable5
   input         pwrite5;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata5;               //Write data
   input [7:0]   paddr5;                //Address Bus5 register
   input         scan_in5;              //Scan5 chain5 input port
   input         scan_en5;              //Scan5 chain5 enable port
   
   output [31:0] prdata5;               //Read Data from the APB5 Interface5
   output [3:1]  interrupt5;            //Interrupt5 from PCI5 
   output        scan_out5;             //Scan5 chain5 output port

//-----------------------------------------------------------------------------
// Module5 Interconnect5
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int5;
   wire        clk_ctrl_reg_sel_15;     //Module5 1 clock5 control5 select5
   wire        clk_ctrl_reg_sel_25;     //Module5 2 clock5 control5 select5
   wire        clk_ctrl_reg_sel_35;     //Module5 3 clock5 control5 select5
   wire        cntr_ctrl_reg_sel_15;    //Module5 1 counter control5 select5
   wire        cntr_ctrl_reg_sel_25;    //Module5 2 counter control5 select5
   wire        cntr_ctrl_reg_sel_35;    //Module5 3 counter control5 select5
   wire        interval_reg_sel_15;     //Interval5 1 register select5
   wire        interval_reg_sel_25;     //Interval5 2 register select5
   wire        interval_reg_sel_35;     //Interval5 3 register select5
   wire        match_1_reg_sel_15;      //Module5 1 match 1 select5
   wire        match_1_reg_sel_25;      //Module5 1 match 2 select5
   wire        match_1_reg_sel_35;      //Module5 1 match 3 select5
   wire        match_2_reg_sel_15;      //Module5 2 match 1 select5
   wire        match_2_reg_sel_25;      //Module5 2 match 2 select5
   wire        match_2_reg_sel_35;      //Module5 2 match 3 select5
   wire        match_3_reg_sel_15;      //Module5 3 match 1 select5
   wire        match_3_reg_sel_25;      //Module5 3 match 2 select5
   wire        match_3_reg_sel_35;      //Module5 3 match 3 select5
   wire [3:1]  intr_en_reg_sel5;        //Interrupt5 enable register select5
   wire [3:1]  clear_interrupt5;        //Clear interrupt5 signal5
   wire [5:0]  interrupt_reg_15;        //Interrupt5 register 1
   wire [5:0]  interrupt_reg_25;        //Interrupt5 register 2
   wire [5:0]  interrupt_reg_35;        //Interrupt5 register 3 
   wire [5:0]  interrupt_en_reg_15;     //Interrupt5 enable register 1
   wire [5:0]  interrupt_en_reg_25;     //Interrupt5 enable register 2
   wire [5:0]  interrupt_en_reg_35;     //Interrupt5 enable register 3
   wire [6:0]  clk_ctrl_reg_15;         //Clock5 control5 regs for the 
   wire [6:0]  clk_ctrl_reg_25;         //Timer_Counter5 1,2,3
   wire [6:0]  clk_ctrl_reg_35;         //Value of the clock5 frequency5
   wire [15:0] counter_val_reg_15;      //Module5 1 counter value 
   wire [15:0] counter_val_reg_25;      //Module5 2 counter value 
   wire [15:0] counter_val_reg_35;      //Module5 3 counter value 
   wire [6:0]  cntr_ctrl_reg_15;        //Module5 1 counter control5  
   wire [6:0]  cntr_ctrl_reg_25;        //Module5 2 counter control5  
   wire [6:0]  cntr_ctrl_reg_35;        //Module5 3 counter control5  
   wire [15:0] interval_reg_15;         //Module5 1 interval5 register
   wire [15:0] interval_reg_25;         //Module5 2 interval5 register
   wire [15:0] interval_reg_35;         //Module5 3 interval5 register
   wire [15:0] match_1_reg_15;          //Module5 1 match 1 register
   wire [15:0] match_1_reg_25;          //Module5 1 match 2 register
   wire [15:0] match_1_reg_35;          //Module5 1 match 3 register
   wire [15:0] match_2_reg_15;          //Module5 2 match 1 register
   wire [15:0] match_2_reg_25;          //Module5 2 match 2 register
   wire [15:0] match_2_reg_35;          //Module5 2 match 3 register
   wire [15:0] match_3_reg_15;          //Module5 3 match 1 register
   wire [15:0] match_3_reg_25;          //Module5 3 match 2 register
   wire [15:0] match_3_reg_35;          //Module5 3 match 3 register

  assign interrupt5 = TTC_int5;   // Bug5 Fix5 for floating5 ints - Santhosh5 8 Nov5 06
   

//-----------------------------------------------------------------------------
// Module5 Instantiations5
//-----------------------------------------------------------------------------


  ttc_interface_lite5 i_ttc_interface_lite5 ( 

    //inputs5
    .n_p_reset5                           (n_p_reset5),
    .pclk5                                (pclk5),
    .psel5                                (psel5),
    .penable5                             (penable5),
    .pwrite5                              (pwrite5),
    .paddr5                               (paddr5),
    .clk_ctrl_reg_15                      (clk_ctrl_reg_15),
    .clk_ctrl_reg_25                      (clk_ctrl_reg_25),
    .clk_ctrl_reg_35                      (clk_ctrl_reg_35),
    .cntr_ctrl_reg_15                     (cntr_ctrl_reg_15),
    .cntr_ctrl_reg_25                     (cntr_ctrl_reg_25),
    .cntr_ctrl_reg_35                     (cntr_ctrl_reg_35),
    .counter_val_reg_15                   (counter_val_reg_15),
    .counter_val_reg_25                   (counter_val_reg_25),
    .counter_val_reg_35                   (counter_val_reg_35),
    .interval_reg_15                      (interval_reg_15),
    .match_1_reg_15                       (match_1_reg_15),
    .match_2_reg_15                       (match_2_reg_15),
    .match_3_reg_15                       (match_3_reg_15),
    .interval_reg_25                      (interval_reg_25),
    .match_1_reg_25                       (match_1_reg_25),
    .match_2_reg_25                       (match_2_reg_25),
    .match_3_reg_25                       (match_3_reg_25),
    .interval_reg_35                      (interval_reg_35),
    .match_1_reg_35                       (match_1_reg_35),
    .match_2_reg_35                       (match_2_reg_35),
    .match_3_reg_35                       (match_3_reg_35),
    .interrupt_reg_15                     (interrupt_reg_15),
    .interrupt_reg_25                     (interrupt_reg_25),
    .interrupt_reg_35                     (interrupt_reg_35), 
    .interrupt_en_reg_15                  (interrupt_en_reg_15),
    .interrupt_en_reg_25                  (interrupt_en_reg_25),
    .interrupt_en_reg_35                  (interrupt_en_reg_35), 

    //outputs5
    .prdata5                              (prdata5),
    .clk_ctrl_reg_sel_15                  (clk_ctrl_reg_sel_15),
    .clk_ctrl_reg_sel_25                  (clk_ctrl_reg_sel_25),
    .clk_ctrl_reg_sel_35                  (clk_ctrl_reg_sel_35),
    .cntr_ctrl_reg_sel_15                 (cntr_ctrl_reg_sel_15),
    .cntr_ctrl_reg_sel_25                 (cntr_ctrl_reg_sel_25),
    .cntr_ctrl_reg_sel_35                 (cntr_ctrl_reg_sel_35),
    .interval_reg_sel_15                  (interval_reg_sel_15),  
    .interval_reg_sel_25                  (interval_reg_sel_25), 
    .interval_reg_sel_35                  (interval_reg_sel_35),
    .match_1_reg_sel_15                   (match_1_reg_sel_15),     
    .match_1_reg_sel_25                   (match_1_reg_sel_25),
    .match_1_reg_sel_35                   (match_1_reg_sel_35),                
    .match_2_reg_sel_15                   (match_2_reg_sel_15),
    .match_2_reg_sel_25                   (match_2_reg_sel_25),
    .match_2_reg_sel_35                   (match_2_reg_sel_35),
    .match_3_reg_sel_15                   (match_3_reg_sel_15),
    .match_3_reg_sel_25                   (match_3_reg_sel_25),
    .match_3_reg_sel_35                   (match_3_reg_sel_35),
    .intr_en_reg_sel5                     (intr_en_reg_sel5),
    .clear_interrupt5                     (clear_interrupt5)

  );


   

  ttc_timer_counter_lite5 i_ttc_timer_counter_lite_15 ( 

    //inputs5
    .n_p_reset5                           (n_p_reset5),
    .pclk5                                (pclk5), 
    .pwdata5                              (pwdata5[15:0]),
    .clk_ctrl_reg_sel5                    (clk_ctrl_reg_sel_15),
    .cntr_ctrl_reg_sel5                   (cntr_ctrl_reg_sel_15),
    .interval_reg_sel5                    (interval_reg_sel_15),
    .match_1_reg_sel5                     (match_1_reg_sel_15),
    .match_2_reg_sel5                     (match_2_reg_sel_15),
    .match_3_reg_sel5                     (match_3_reg_sel_15),
    .intr_en_reg_sel5                     (intr_en_reg_sel5[1]),
    .clear_interrupt5                     (clear_interrupt5[1]),
                                  
    //outputs5
    .clk_ctrl_reg5                        (clk_ctrl_reg_15),
    .counter_val_reg5                     (counter_val_reg_15),
    .cntr_ctrl_reg5                       (cntr_ctrl_reg_15),
    .interval_reg5                        (interval_reg_15),
    .match_1_reg5                         (match_1_reg_15),
    .match_2_reg5                         (match_2_reg_15),
    .match_3_reg5                         (match_3_reg_15),
    .interrupt5                           (TTC_int5[1]),
    .interrupt_reg5                       (interrupt_reg_15),
    .interrupt_en_reg5                    (interrupt_en_reg_15)
  );


  ttc_timer_counter_lite5 i_ttc_timer_counter_lite_25 ( 

    //inputs5
    .n_p_reset5                           (n_p_reset5), 
    .pclk5                                (pclk5),
    .pwdata5                              (pwdata5[15:0]),
    .clk_ctrl_reg_sel5                    (clk_ctrl_reg_sel_25),
    .cntr_ctrl_reg_sel5                   (cntr_ctrl_reg_sel_25),
    .interval_reg_sel5                    (interval_reg_sel_25),
    .match_1_reg_sel5                     (match_1_reg_sel_25),
    .match_2_reg_sel5                     (match_2_reg_sel_25),
    .match_3_reg_sel5                     (match_3_reg_sel_25),
    .intr_en_reg_sel5                     (intr_en_reg_sel5[2]),
    .clear_interrupt5                     (clear_interrupt5[2]),
                                  
    //outputs5
    .clk_ctrl_reg5                        (clk_ctrl_reg_25),
    .counter_val_reg5                     (counter_val_reg_25),
    .cntr_ctrl_reg5                       (cntr_ctrl_reg_25),
    .interval_reg5                        (interval_reg_25),
    .match_1_reg5                         (match_1_reg_25),
    .match_2_reg5                         (match_2_reg_25),
    .match_3_reg5                         (match_3_reg_25),
    .interrupt5                           (TTC_int5[2]),
    .interrupt_reg5                       (interrupt_reg_25),
    .interrupt_en_reg5                    (interrupt_en_reg_25)
  );



  ttc_timer_counter_lite5 i_ttc_timer_counter_lite_35 ( 

    //inputs5
    .n_p_reset5                           (n_p_reset5), 
    .pclk5                                (pclk5),
    .pwdata5                              (pwdata5[15:0]),
    .clk_ctrl_reg_sel5                    (clk_ctrl_reg_sel_35),
    .cntr_ctrl_reg_sel5                   (cntr_ctrl_reg_sel_35),
    .interval_reg_sel5                    (interval_reg_sel_35),
    .match_1_reg_sel5                     (match_1_reg_sel_35),
    .match_2_reg_sel5                     (match_2_reg_sel_35),
    .match_3_reg_sel5                     (match_3_reg_sel_35),
    .intr_en_reg_sel5                     (intr_en_reg_sel5[3]),
    .clear_interrupt5                     (clear_interrupt5[3]),
                                              
    //outputs5
    .clk_ctrl_reg5                        (clk_ctrl_reg_35),
    .counter_val_reg5                     (counter_val_reg_35),
    .cntr_ctrl_reg5                       (cntr_ctrl_reg_35),
    .interval_reg5                        (interval_reg_35),
    .match_1_reg5                         (match_1_reg_35),
    .match_2_reg5                         (match_2_reg_35),
    .match_3_reg5                         (match_3_reg_35),
    .interrupt5                           (TTC_int5[3]),
    .interrupt_reg5                       (interrupt_reg_35),
    .interrupt_en_reg5                    (interrupt_en_reg_35)
  );





endmodule 
