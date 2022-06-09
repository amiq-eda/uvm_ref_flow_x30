//File3 name   : ttc_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : The top level of the Triple3 Timer3 Counter3.
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module3 definition3
//-----------------------------------------------------------------------------

module ttc_lite3(
           
           //inputs3
           n_p_reset3,
           pclk3,
           psel3,
           penable3,
           pwrite3,
           pwdata3,
           paddr3,
           scan_in3,
           scan_en3,

           //outputs3
           prdata3,
           interrupt3,
           scan_out3           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS3
//-----------------------------------------------------------------------------

   input         n_p_reset3;              //System3 Reset3
   input         pclk3;                 //System3 clock3
   input         psel3;                 //Select3 line
   input         penable3;              //Enable3
   input         pwrite3;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata3;               //Write data
   input [7:0]   paddr3;                //Address Bus3 register
   input         scan_in3;              //Scan3 chain3 input port
   input         scan_en3;              //Scan3 chain3 enable port
   
   output [31:0] prdata3;               //Read Data from the APB3 Interface3
   output [3:1]  interrupt3;            //Interrupt3 from PCI3 
   output        scan_out3;             //Scan3 chain3 output port

//-----------------------------------------------------------------------------
// Module3 Interconnect3
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int3;
   wire        clk_ctrl_reg_sel_13;     //Module3 1 clock3 control3 select3
   wire        clk_ctrl_reg_sel_23;     //Module3 2 clock3 control3 select3
   wire        clk_ctrl_reg_sel_33;     //Module3 3 clock3 control3 select3
   wire        cntr_ctrl_reg_sel_13;    //Module3 1 counter control3 select3
   wire        cntr_ctrl_reg_sel_23;    //Module3 2 counter control3 select3
   wire        cntr_ctrl_reg_sel_33;    //Module3 3 counter control3 select3
   wire        interval_reg_sel_13;     //Interval3 1 register select3
   wire        interval_reg_sel_23;     //Interval3 2 register select3
   wire        interval_reg_sel_33;     //Interval3 3 register select3
   wire        match_1_reg_sel_13;      //Module3 1 match 1 select3
   wire        match_1_reg_sel_23;      //Module3 1 match 2 select3
   wire        match_1_reg_sel_33;      //Module3 1 match 3 select3
   wire        match_2_reg_sel_13;      //Module3 2 match 1 select3
   wire        match_2_reg_sel_23;      //Module3 2 match 2 select3
   wire        match_2_reg_sel_33;      //Module3 2 match 3 select3
   wire        match_3_reg_sel_13;      //Module3 3 match 1 select3
   wire        match_3_reg_sel_23;      //Module3 3 match 2 select3
   wire        match_3_reg_sel_33;      //Module3 3 match 3 select3
   wire [3:1]  intr_en_reg_sel3;        //Interrupt3 enable register select3
   wire [3:1]  clear_interrupt3;        //Clear interrupt3 signal3
   wire [5:0]  interrupt_reg_13;        //Interrupt3 register 1
   wire [5:0]  interrupt_reg_23;        //Interrupt3 register 2
   wire [5:0]  interrupt_reg_33;        //Interrupt3 register 3 
   wire [5:0]  interrupt_en_reg_13;     //Interrupt3 enable register 1
   wire [5:0]  interrupt_en_reg_23;     //Interrupt3 enable register 2
   wire [5:0]  interrupt_en_reg_33;     //Interrupt3 enable register 3
   wire [6:0]  clk_ctrl_reg_13;         //Clock3 control3 regs for the 
   wire [6:0]  clk_ctrl_reg_23;         //Timer_Counter3 1,2,3
   wire [6:0]  clk_ctrl_reg_33;         //Value of the clock3 frequency3
   wire [15:0] counter_val_reg_13;      //Module3 1 counter value 
   wire [15:0] counter_val_reg_23;      //Module3 2 counter value 
   wire [15:0] counter_val_reg_33;      //Module3 3 counter value 
   wire [6:0]  cntr_ctrl_reg_13;        //Module3 1 counter control3  
   wire [6:0]  cntr_ctrl_reg_23;        //Module3 2 counter control3  
   wire [6:0]  cntr_ctrl_reg_33;        //Module3 3 counter control3  
   wire [15:0] interval_reg_13;         //Module3 1 interval3 register
   wire [15:0] interval_reg_23;         //Module3 2 interval3 register
   wire [15:0] interval_reg_33;         //Module3 3 interval3 register
   wire [15:0] match_1_reg_13;          //Module3 1 match 1 register
   wire [15:0] match_1_reg_23;          //Module3 1 match 2 register
   wire [15:0] match_1_reg_33;          //Module3 1 match 3 register
   wire [15:0] match_2_reg_13;          //Module3 2 match 1 register
   wire [15:0] match_2_reg_23;          //Module3 2 match 2 register
   wire [15:0] match_2_reg_33;          //Module3 2 match 3 register
   wire [15:0] match_3_reg_13;          //Module3 3 match 1 register
   wire [15:0] match_3_reg_23;          //Module3 3 match 2 register
   wire [15:0] match_3_reg_33;          //Module3 3 match 3 register

  assign interrupt3 = TTC_int3;   // Bug3 Fix3 for floating3 ints - Santhosh3 8 Nov3 06
   

//-----------------------------------------------------------------------------
// Module3 Instantiations3
//-----------------------------------------------------------------------------


  ttc_interface_lite3 i_ttc_interface_lite3 ( 

    //inputs3
    .n_p_reset3                           (n_p_reset3),
    .pclk3                                (pclk3),
    .psel3                                (psel3),
    .penable3                             (penable3),
    .pwrite3                              (pwrite3),
    .paddr3                               (paddr3),
    .clk_ctrl_reg_13                      (clk_ctrl_reg_13),
    .clk_ctrl_reg_23                      (clk_ctrl_reg_23),
    .clk_ctrl_reg_33                      (clk_ctrl_reg_33),
    .cntr_ctrl_reg_13                     (cntr_ctrl_reg_13),
    .cntr_ctrl_reg_23                     (cntr_ctrl_reg_23),
    .cntr_ctrl_reg_33                     (cntr_ctrl_reg_33),
    .counter_val_reg_13                   (counter_val_reg_13),
    .counter_val_reg_23                   (counter_val_reg_23),
    .counter_val_reg_33                   (counter_val_reg_33),
    .interval_reg_13                      (interval_reg_13),
    .match_1_reg_13                       (match_1_reg_13),
    .match_2_reg_13                       (match_2_reg_13),
    .match_3_reg_13                       (match_3_reg_13),
    .interval_reg_23                      (interval_reg_23),
    .match_1_reg_23                       (match_1_reg_23),
    .match_2_reg_23                       (match_2_reg_23),
    .match_3_reg_23                       (match_3_reg_23),
    .interval_reg_33                      (interval_reg_33),
    .match_1_reg_33                       (match_1_reg_33),
    .match_2_reg_33                       (match_2_reg_33),
    .match_3_reg_33                       (match_3_reg_33),
    .interrupt_reg_13                     (interrupt_reg_13),
    .interrupt_reg_23                     (interrupt_reg_23),
    .interrupt_reg_33                     (interrupt_reg_33), 
    .interrupt_en_reg_13                  (interrupt_en_reg_13),
    .interrupt_en_reg_23                  (interrupt_en_reg_23),
    .interrupt_en_reg_33                  (interrupt_en_reg_33), 

    //outputs3
    .prdata3                              (prdata3),
    .clk_ctrl_reg_sel_13                  (clk_ctrl_reg_sel_13),
    .clk_ctrl_reg_sel_23                  (clk_ctrl_reg_sel_23),
    .clk_ctrl_reg_sel_33                  (clk_ctrl_reg_sel_33),
    .cntr_ctrl_reg_sel_13                 (cntr_ctrl_reg_sel_13),
    .cntr_ctrl_reg_sel_23                 (cntr_ctrl_reg_sel_23),
    .cntr_ctrl_reg_sel_33                 (cntr_ctrl_reg_sel_33),
    .interval_reg_sel_13                  (interval_reg_sel_13),  
    .interval_reg_sel_23                  (interval_reg_sel_23), 
    .interval_reg_sel_33                  (interval_reg_sel_33),
    .match_1_reg_sel_13                   (match_1_reg_sel_13),     
    .match_1_reg_sel_23                   (match_1_reg_sel_23),
    .match_1_reg_sel_33                   (match_1_reg_sel_33),                
    .match_2_reg_sel_13                   (match_2_reg_sel_13),
    .match_2_reg_sel_23                   (match_2_reg_sel_23),
    .match_2_reg_sel_33                   (match_2_reg_sel_33),
    .match_3_reg_sel_13                   (match_3_reg_sel_13),
    .match_3_reg_sel_23                   (match_3_reg_sel_23),
    .match_3_reg_sel_33                   (match_3_reg_sel_33),
    .intr_en_reg_sel3                     (intr_en_reg_sel3),
    .clear_interrupt3                     (clear_interrupt3)

  );


   

  ttc_timer_counter_lite3 i_ttc_timer_counter_lite_13 ( 

    //inputs3
    .n_p_reset3                           (n_p_reset3),
    .pclk3                                (pclk3), 
    .pwdata3                              (pwdata3[15:0]),
    .clk_ctrl_reg_sel3                    (clk_ctrl_reg_sel_13),
    .cntr_ctrl_reg_sel3                   (cntr_ctrl_reg_sel_13),
    .interval_reg_sel3                    (interval_reg_sel_13),
    .match_1_reg_sel3                     (match_1_reg_sel_13),
    .match_2_reg_sel3                     (match_2_reg_sel_13),
    .match_3_reg_sel3                     (match_3_reg_sel_13),
    .intr_en_reg_sel3                     (intr_en_reg_sel3[1]),
    .clear_interrupt3                     (clear_interrupt3[1]),
                                  
    //outputs3
    .clk_ctrl_reg3                        (clk_ctrl_reg_13),
    .counter_val_reg3                     (counter_val_reg_13),
    .cntr_ctrl_reg3                       (cntr_ctrl_reg_13),
    .interval_reg3                        (interval_reg_13),
    .match_1_reg3                         (match_1_reg_13),
    .match_2_reg3                         (match_2_reg_13),
    .match_3_reg3                         (match_3_reg_13),
    .interrupt3                           (TTC_int3[1]),
    .interrupt_reg3                       (interrupt_reg_13),
    .interrupt_en_reg3                    (interrupt_en_reg_13)
  );


  ttc_timer_counter_lite3 i_ttc_timer_counter_lite_23 ( 

    //inputs3
    .n_p_reset3                           (n_p_reset3), 
    .pclk3                                (pclk3),
    .pwdata3                              (pwdata3[15:0]),
    .clk_ctrl_reg_sel3                    (clk_ctrl_reg_sel_23),
    .cntr_ctrl_reg_sel3                   (cntr_ctrl_reg_sel_23),
    .interval_reg_sel3                    (interval_reg_sel_23),
    .match_1_reg_sel3                     (match_1_reg_sel_23),
    .match_2_reg_sel3                     (match_2_reg_sel_23),
    .match_3_reg_sel3                     (match_3_reg_sel_23),
    .intr_en_reg_sel3                     (intr_en_reg_sel3[2]),
    .clear_interrupt3                     (clear_interrupt3[2]),
                                  
    //outputs3
    .clk_ctrl_reg3                        (clk_ctrl_reg_23),
    .counter_val_reg3                     (counter_val_reg_23),
    .cntr_ctrl_reg3                       (cntr_ctrl_reg_23),
    .interval_reg3                        (interval_reg_23),
    .match_1_reg3                         (match_1_reg_23),
    .match_2_reg3                         (match_2_reg_23),
    .match_3_reg3                         (match_3_reg_23),
    .interrupt3                           (TTC_int3[2]),
    .interrupt_reg3                       (interrupt_reg_23),
    .interrupt_en_reg3                    (interrupt_en_reg_23)
  );



  ttc_timer_counter_lite3 i_ttc_timer_counter_lite_33 ( 

    //inputs3
    .n_p_reset3                           (n_p_reset3), 
    .pclk3                                (pclk3),
    .pwdata3                              (pwdata3[15:0]),
    .clk_ctrl_reg_sel3                    (clk_ctrl_reg_sel_33),
    .cntr_ctrl_reg_sel3                   (cntr_ctrl_reg_sel_33),
    .interval_reg_sel3                    (interval_reg_sel_33),
    .match_1_reg_sel3                     (match_1_reg_sel_33),
    .match_2_reg_sel3                     (match_2_reg_sel_33),
    .match_3_reg_sel3                     (match_3_reg_sel_33),
    .intr_en_reg_sel3                     (intr_en_reg_sel3[3]),
    .clear_interrupt3                     (clear_interrupt3[3]),
                                              
    //outputs3
    .clk_ctrl_reg3                        (clk_ctrl_reg_33),
    .counter_val_reg3                     (counter_val_reg_33),
    .cntr_ctrl_reg3                       (cntr_ctrl_reg_33),
    .interval_reg3                        (interval_reg_33),
    .match_1_reg3                         (match_1_reg_33),
    .match_2_reg3                         (match_2_reg_33),
    .match_3_reg3                         (match_3_reg_33),
    .interrupt3                           (TTC_int3[3]),
    .interrupt_reg3                       (interrupt_reg_33),
    .interrupt_en_reg3                    (interrupt_en_reg_33)
  );





endmodule 
