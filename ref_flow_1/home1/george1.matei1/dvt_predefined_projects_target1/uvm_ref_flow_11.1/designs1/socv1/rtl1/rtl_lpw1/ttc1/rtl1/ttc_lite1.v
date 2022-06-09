//File1 name   : ttc_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : The top level of the Triple1 Timer1 Counter1.
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module1 definition1
//-----------------------------------------------------------------------------

module ttc_lite1(
           
           //inputs1
           n_p_reset1,
           pclk1,
           psel1,
           penable1,
           pwrite1,
           pwdata1,
           paddr1,
           scan_in1,
           scan_en1,

           //outputs1
           prdata1,
           interrupt1,
           scan_out1           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS1
//-----------------------------------------------------------------------------

   input         n_p_reset1;              //System1 Reset1
   input         pclk1;                 //System1 clock1
   input         psel1;                 //Select1 line
   input         penable1;              //Enable1
   input         pwrite1;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata1;               //Write data
   input [7:0]   paddr1;                //Address Bus1 register
   input         scan_in1;              //Scan1 chain1 input port
   input         scan_en1;              //Scan1 chain1 enable port
   
   output [31:0] prdata1;               //Read Data from the APB1 Interface1
   output [3:1]  interrupt1;            //Interrupt1 from PCI1 
   output        scan_out1;             //Scan1 chain1 output port

//-----------------------------------------------------------------------------
// Module1 Interconnect1
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int1;
   wire        clk_ctrl_reg_sel_11;     //Module1 1 clock1 control1 select1
   wire        clk_ctrl_reg_sel_21;     //Module1 2 clock1 control1 select1
   wire        clk_ctrl_reg_sel_31;     //Module1 3 clock1 control1 select1
   wire        cntr_ctrl_reg_sel_11;    //Module1 1 counter control1 select1
   wire        cntr_ctrl_reg_sel_21;    //Module1 2 counter control1 select1
   wire        cntr_ctrl_reg_sel_31;    //Module1 3 counter control1 select1
   wire        interval_reg_sel_11;     //Interval1 1 register select1
   wire        interval_reg_sel_21;     //Interval1 2 register select1
   wire        interval_reg_sel_31;     //Interval1 3 register select1
   wire        match_1_reg_sel_11;      //Module1 1 match 1 select1
   wire        match_1_reg_sel_21;      //Module1 1 match 2 select1
   wire        match_1_reg_sel_31;      //Module1 1 match 3 select1
   wire        match_2_reg_sel_11;      //Module1 2 match 1 select1
   wire        match_2_reg_sel_21;      //Module1 2 match 2 select1
   wire        match_2_reg_sel_31;      //Module1 2 match 3 select1
   wire        match_3_reg_sel_11;      //Module1 3 match 1 select1
   wire        match_3_reg_sel_21;      //Module1 3 match 2 select1
   wire        match_3_reg_sel_31;      //Module1 3 match 3 select1
   wire [3:1]  intr_en_reg_sel1;        //Interrupt1 enable register select1
   wire [3:1]  clear_interrupt1;        //Clear interrupt1 signal1
   wire [5:0]  interrupt_reg_11;        //Interrupt1 register 1
   wire [5:0]  interrupt_reg_21;        //Interrupt1 register 2
   wire [5:0]  interrupt_reg_31;        //Interrupt1 register 3 
   wire [5:0]  interrupt_en_reg_11;     //Interrupt1 enable register 1
   wire [5:0]  interrupt_en_reg_21;     //Interrupt1 enable register 2
   wire [5:0]  interrupt_en_reg_31;     //Interrupt1 enable register 3
   wire [6:0]  clk_ctrl_reg_11;         //Clock1 control1 regs for the 
   wire [6:0]  clk_ctrl_reg_21;         //Timer_Counter1 1,2,3
   wire [6:0]  clk_ctrl_reg_31;         //Value of the clock1 frequency1
   wire [15:0] counter_val_reg_11;      //Module1 1 counter value 
   wire [15:0] counter_val_reg_21;      //Module1 2 counter value 
   wire [15:0] counter_val_reg_31;      //Module1 3 counter value 
   wire [6:0]  cntr_ctrl_reg_11;        //Module1 1 counter control1  
   wire [6:0]  cntr_ctrl_reg_21;        //Module1 2 counter control1  
   wire [6:0]  cntr_ctrl_reg_31;        //Module1 3 counter control1  
   wire [15:0] interval_reg_11;         //Module1 1 interval1 register
   wire [15:0] interval_reg_21;         //Module1 2 interval1 register
   wire [15:0] interval_reg_31;         //Module1 3 interval1 register
   wire [15:0] match_1_reg_11;          //Module1 1 match 1 register
   wire [15:0] match_1_reg_21;          //Module1 1 match 2 register
   wire [15:0] match_1_reg_31;          //Module1 1 match 3 register
   wire [15:0] match_2_reg_11;          //Module1 2 match 1 register
   wire [15:0] match_2_reg_21;          //Module1 2 match 2 register
   wire [15:0] match_2_reg_31;          //Module1 2 match 3 register
   wire [15:0] match_3_reg_11;          //Module1 3 match 1 register
   wire [15:0] match_3_reg_21;          //Module1 3 match 2 register
   wire [15:0] match_3_reg_31;          //Module1 3 match 3 register

  assign interrupt1 = TTC_int1;   // Bug1 Fix1 for floating1 ints - Santhosh1 8 Nov1 06
   

//-----------------------------------------------------------------------------
// Module1 Instantiations1
//-----------------------------------------------------------------------------


  ttc_interface_lite1 i_ttc_interface_lite1 ( 

    //inputs1
    .n_p_reset1                           (n_p_reset1),
    .pclk1                                (pclk1),
    .psel1                                (psel1),
    .penable1                             (penable1),
    .pwrite1                              (pwrite1),
    .paddr1                               (paddr1),
    .clk_ctrl_reg_11                      (clk_ctrl_reg_11),
    .clk_ctrl_reg_21                      (clk_ctrl_reg_21),
    .clk_ctrl_reg_31                      (clk_ctrl_reg_31),
    .cntr_ctrl_reg_11                     (cntr_ctrl_reg_11),
    .cntr_ctrl_reg_21                     (cntr_ctrl_reg_21),
    .cntr_ctrl_reg_31                     (cntr_ctrl_reg_31),
    .counter_val_reg_11                   (counter_val_reg_11),
    .counter_val_reg_21                   (counter_val_reg_21),
    .counter_val_reg_31                   (counter_val_reg_31),
    .interval_reg_11                      (interval_reg_11),
    .match_1_reg_11                       (match_1_reg_11),
    .match_2_reg_11                       (match_2_reg_11),
    .match_3_reg_11                       (match_3_reg_11),
    .interval_reg_21                      (interval_reg_21),
    .match_1_reg_21                       (match_1_reg_21),
    .match_2_reg_21                       (match_2_reg_21),
    .match_3_reg_21                       (match_3_reg_21),
    .interval_reg_31                      (interval_reg_31),
    .match_1_reg_31                       (match_1_reg_31),
    .match_2_reg_31                       (match_2_reg_31),
    .match_3_reg_31                       (match_3_reg_31),
    .interrupt_reg_11                     (interrupt_reg_11),
    .interrupt_reg_21                     (interrupt_reg_21),
    .interrupt_reg_31                     (interrupt_reg_31), 
    .interrupt_en_reg_11                  (interrupt_en_reg_11),
    .interrupt_en_reg_21                  (interrupt_en_reg_21),
    .interrupt_en_reg_31                  (interrupt_en_reg_31), 

    //outputs1
    .prdata1                              (prdata1),
    .clk_ctrl_reg_sel_11                  (clk_ctrl_reg_sel_11),
    .clk_ctrl_reg_sel_21                  (clk_ctrl_reg_sel_21),
    .clk_ctrl_reg_sel_31                  (clk_ctrl_reg_sel_31),
    .cntr_ctrl_reg_sel_11                 (cntr_ctrl_reg_sel_11),
    .cntr_ctrl_reg_sel_21                 (cntr_ctrl_reg_sel_21),
    .cntr_ctrl_reg_sel_31                 (cntr_ctrl_reg_sel_31),
    .interval_reg_sel_11                  (interval_reg_sel_11),  
    .interval_reg_sel_21                  (interval_reg_sel_21), 
    .interval_reg_sel_31                  (interval_reg_sel_31),
    .match_1_reg_sel_11                   (match_1_reg_sel_11),     
    .match_1_reg_sel_21                   (match_1_reg_sel_21),
    .match_1_reg_sel_31                   (match_1_reg_sel_31),                
    .match_2_reg_sel_11                   (match_2_reg_sel_11),
    .match_2_reg_sel_21                   (match_2_reg_sel_21),
    .match_2_reg_sel_31                   (match_2_reg_sel_31),
    .match_3_reg_sel_11                   (match_3_reg_sel_11),
    .match_3_reg_sel_21                   (match_3_reg_sel_21),
    .match_3_reg_sel_31                   (match_3_reg_sel_31),
    .intr_en_reg_sel1                     (intr_en_reg_sel1),
    .clear_interrupt1                     (clear_interrupt1)

  );


   

  ttc_timer_counter_lite1 i_ttc_timer_counter_lite_11 ( 

    //inputs1
    .n_p_reset1                           (n_p_reset1),
    .pclk1                                (pclk1), 
    .pwdata1                              (pwdata1[15:0]),
    .clk_ctrl_reg_sel1                    (clk_ctrl_reg_sel_11),
    .cntr_ctrl_reg_sel1                   (cntr_ctrl_reg_sel_11),
    .interval_reg_sel1                    (interval_reg_sel_11),
    .match_1_reg_sel1                     (match_1_reg_sel_11),
    .match_2_reg_sel1                     (match_2_reg_sel_11),
    .match_3_reg_sel1                     (match_3_reg_sel_11),
    .intr_en_reg_sel1                     (intr_en_reg_sel1[1]),
    .clear_interrupt1                     (clear_interrupt1[1]),
                                  
    //outputs1
    .clk_ctrl_reg1                        (clk_ctrl_reg_11),
    .counter_val_reg1                     (counter_val_reg_11),
    .cntr_ctrl_reg1                       (cntr_ctrl_reg_11),
    .interval_reg1                        (interval_reg_11),
    .match_1_reg1                         (match_1_reg_11),
    .match_2_reg1                         (match_2_reg_11),
    .match_3_reg1                         (match_3_reg_11),
    .interrupt1                           (TTC_int1[1]),
    .interrupt_reg1                       (interrupt_reg_11),
    .interrupt_en_reg1                    (interrupt_en_reg_11)
  );


  ttc_timer_counter_lite1 i_ttc_timer_counter_lite_21 ( 

    //inputs1
    .n_p_reset1                           (n_p_reset1), 
    .pclk1                                (pclk1),
    .pwdata1                              (pwdata1[15:0]),
    .clk_ctrl_reg_sel1                    (clk_ctrl_reg_sel_21),
    .cntr_ctrl_reg_sel1                   (cntr_ctrl_reg_sel_21),
    .interval_reg_sel1                    (interval_reg_sel_21),
    .match_1_reg_sel1                     (match_1_reg_sel_21),
    .match_2_reg_sel1                     (match_2_reg_sel_21),
    .match_3_reg_sel1                     (match_3_reg_sel_21),
    .intr_en_reg_sel1                     (intr_en_reg_sel1[2]),
    .clear_interrupt1                     (clear_interrupt1[2]),
                                  
    //outputs1
    .clk_ctrl_reg1                        (clk_ctrl_reg_21),
    .counter_val_reg1                     (counter_val_reg_21),
    .cntr_ctrl_reg1                       (cntr_ctrl_reg_21),
    .interval_reg1                        (interval_reg_21),
    .match_1_reg1                         (match_1_reg_21),
    .match_2_reg1                         (match_2_reg_21),
    .match_3_reg1                         (match_3_reg_21),
    .interrupt1                           (TTC_int1[2]),
    .interrupt_reg1                       (interrupt_reg_21),
    .interrupt_en_reg1                    (interrupt_en_reg_21)
  );



  ttc_timer_counter_lite1 i_ttc_timer_counter_lite_31 ( 

    //inputs1
    .n_p_reset1                           (n_p_reset1), 
    .pclk1                                (pclk1),
    .pwdata1                              (pwdata1[15:0]),
    .clk_ctrl_reg_sel1                    (clk_ctrl_reg_sel_31),
    .cntr_ctrl_reg_sel1                   (cntr_ctrl_reg_sel_31),
    .interval_reg_sel1                    (interval_reg_sel_31),
    .match_1_reg_sel1                     (match_1_reg_sel_31),
    .match_2_reg_sel1                     (match_2_reg_sel_31),
    .match_3_reg_sel1                     (match_3_reg_sel_31),
    .intr_en_reg_sel1                     (intr_en_reg_sel1[3]),
    .clear_interrupt1                     (clear_interrupt1[3]),
                                              
    //outputs1
    .clk_ctrl_reg1                        (clk_ctrl_reg_31),
    .counter_val_reg1                     (counter_val_reg_31),
    .cntr_ctrl_reg1                       (cntr_ctrl_reg_31),
    .interval_reg1                        (interval_reg_31),
    .match_1_reg1                         (match_1_reg_31),
    .match_2_reg1                         (match_2_reg_31),
    .match_3_reg1                         (match_3_reg_31),
    .interrupt1                           (TTC_int1[3]),
    .interrupt_reg1                       (interrupt_reg_31),
    .interrupt_en_reg1                    (interrupt_en_reg_31)
  );





endmodule 
