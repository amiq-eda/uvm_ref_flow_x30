//File14 name   : ttc_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : The top level of the Triple14 Timer14 Counter14.
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module14 definition14
//-----------------------------------------------------------------------------

module ttc_lite14(
           
           //inputs14
           n_p_reset14,
           pclk14,
           psel14,
           penable14,
           pwrite14,
           pwdata14,
           paddr14,
           scan_in14,
           scan_en14,

           //outputs14
           prdata14,
           interrupt14,
           scan_out14           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS14
//-----------------------------------------------------------------------------

   input         n_p_reset14;              //System14 Reset14
   input         pclk14;                 //System14 clock14
   input         psel14;                 //Select14 line
   input         penable14;              //Enable14
   input         pwrite14;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata14;               //Write data
   input [7:0]   paddr14;                //Address Bus14 register
   input         scan_in14;              //Scan14 chain14 input port
   input         scan_en14;              //Scan14 chain14 enable port
   
   output [31:0] prdata14;               //Read Data from the APB14 Interface14
   output [3:1]  interrupt14;            //Interrupt14 from PCI14 
   output        scan_out14;             //Scan14 chain14 output port

//-----------------------------------------------------------------------------
// Module14 Interconnect14
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int14;
   wire        clk_ctrl_reg_sel_114;     //Module14 1 clock14 control14 select14
   wire        clk_ctrl_reg_sel_214;     //Module14 2 clock14 control14 select14
   wire        clk_ctrl_reg_sel_314;     //Module14 3 clock14 control14 select14
   wire        cntr_ctrl_reg_sel_114;    //Module14 1 counter control14 select14
   wire        cntr_ctrl_reg_sel_214;    //Module14 2 counter control14 select14
   wire        cntr_ctrl_reg_sel_314;    //Module14 3 counter control14 select14
   wire        interval_reg_sel_114;     //Interval14 1 register select14
   wire        interval_reg_sel_214;     //Interval14 2 register select14
   wire        interval_reg_sel_314;     //Interval14 3 register select14
   wire        match_1_reg_sel_114;      //Module14 1 match 1 select14
   wire        match_1_reg_sel_214;      //Module14 1 match 2 select14
   wire        match_1_reg_sel_314;      //Module14 1 match 3 select14
   wire        match_2_reg_sel_114;      //Module14 2 match 1 select14
   wire        match_2_reg_sel_214;      //Module14 2 match 2 select14
   wire        match_2_reg_sel_314;      //Module14 2 match 3 select14
   wire        match_3_reg_sel_114;      //Module14 3 match 1 select14
   wire        match_3_reg_sel_214;      //Module14 3 match 2 select14
   wire        match_3_reg_sel_314;      //Module14 3 match 3 select14
   wire [3:1]  intr_en_reg_sel14;        //Interrupt14 enable register select14
   wire [3:1]  clear_interrupt14;        //Clear interrupt14 signal14
   wire [5:0]  interrupt_reg_114;        //Interrupt14 register 1
   wire [5:0]  interrupt_reg_214;        //Interrupt14 register 2
   wire [5:0]  interrupt_reg_314;        //Interrupt14 register 3 
   wire [5:0]  interrupt_en_reg_114;     //Interrupt14 enable register 1
   wire [5:0]  interrupt_en_reg_214;     //Interrupt14 enable register 2
   wire [5:0]  interrupt_en_reg_314;     //Interrupt14 enable register 3
   wire [6:0]  clk_ctrl_reg_114;         //Clock14 control14 regs for the 
   wire [6:0]  clk_ctrl_reg_214;         //Timer_Counter14 1,2,3
   wire [6:0]  clk_ctrl_reg_314;         //Value of the clock14 frequency14
   wire [15:0] counter_val_reg_114;      //Module14 1 counter value 
   wire [15:0] counter_val_reg_214;      //Module14 2 counter value 
   wire [15:0] counter_val_reg_314;      //Module14 3 counter value 
   wire [6:0]  cntr_ctrl_reg_114;        //Module14 1 counter control14  
   wire [6:0]  cntr_ctrl_reg_214;        //Module14 2 counter control14  
   wire [6:0]  cntr_ctrl_reg_314;        //Module14 3 counter control14  
   wire [15:0] interval_reg_114;         //Module14 1 interval14 register
   wire [15:0] interval_reg_214;         //Module14 2 interval14 register
   wire [15:0] interval_reg_314;         //Module14 3 interval14 register
   wire [15:0] match_1_reg_114;          //Module14 1 match 1 register
   wire [15:0] match_1_reg_214;          //Module14 1 match 2 register
   wire [15:0] match_1_reg_314;          //Module14 1 match 3 register
   wire [15:0] match_2_reg_114;          //Module14 2 match 1 register
   wire [15:0] match_2_reg_214;          //Module14 2 match 2 register
   wire [15:0] match_2_reg_314;          //Module14 2 match 3 register
   wire [15:0] match_3_reg_114;          //Module14 3 match 1 register
   wire [15:0] match_3_reg_214;          //Module14 3 match 2 register
   wire [15:0] match_3_reg_314;          //Module14 3 match 3 register

  assign interrupt14 = TTC_int14;   // Bug14 Fix14 for floating14 ints - Santhosh14 8 Nov14 06
   

//-----------------------------------------------------------------------------
// Module14 Instantiations14
//-----------------------------------------------------------------------------


  ttc_interface_lite14 i_ttc_interface_lite14 ( 

    //inputs14
    .n_p_reset14                           (n_p_reset14),
    .pclk14                                (pclk14),
    .psel14                                (psel14),
    .penable14                             (penable14),
    .pwrite14                              (pwrite14),
    .paddr14                               (paddr14),
    .clk_ctrl_reg_114                      (clk_ctrl_reg_114),
    .clk_ctrl_reg_214                      (clk_ctrl_reg_214),
    .clk_ctrl_reg_314                      (clk_ctrl_reg_314),
    .cntr_ctrl_reg_114                     (cntr_ctrl_reg_114),
    .cntr_ctrl_reg_214                     (cntr_ctrl_reg_214),
    .cntr_ctrl_reg_314                     (cntr_ctrl_reg_314),
    .counter_val_reg_114                   (counter_val_reg_114),
    .counter_val_reg_214                   (counter_val_reg_214),
    .counter_val_reg_314                   (counter_val_reg_314),
    .interval_reg_114                      (interval_reg_114),
    .match_1_reg_114                       (match_1_reg_114),
    .match_2_reg_114                       (match_2_reg_114),
    .match_3_reg_114                       (match_3_reg_114),
    .interval_reg_214                      (interval_reg_214),
    .match_1_reg_214                       (match_1_reg_214),
    .match_2_reg_214                       (match_2_reg_214),
    .match_3_reg_214                       (match_3_reg_214),
    .interval_reg_314                      (interval_reg_314),
    .match_1_reg_314                       (match_1_reg_314),
    .match_2_reg_314                       (match_2_reg_314),
    .match_3_reg_314                       (match_3_reg_314),
    .interrupt_reg_114                     (interrupt_reg_114),
    .interrupt_reg_214                     (interrupt_reg_214),
    .interrupt_reg_314                     (interrupt_reg_314), 
    .interrupt_en_reg_114                  (interrupt_en_reg_114),
    .interrupt_en_reg_214                  (interrupt_en_reg_214),
    .interrupt_en_reg_314                  (interrupt_en_reg_314), 

    //outputs14
    .prdata14                              (prdata14),
    .clk_ctrl_reg_sel_114                  (clk_ctrl_reg_sel_114),
    .clk_ctrl_reg_sel_214                  (clk_ctrl_reg_sel_214),
    .clk_ctrl_reg_sel_314                  (clk_ctrl_reg_sel_314),
    .cntr_ctrl_reg_sel_114                 (cntr_ctrl_reg_sel_114),
    .cntr_ctrl_reg_sel_214                 (cntr_ctrl_reg_sel_214),
    .cntr_ctrl_reg_sel_314                 (cntr_ctrl_reg_sel_314),
    .interval_reg_sel_114                  (interval_reg_sel_114),  
    .interval_reg_sel_214                  (interval_reg_sel_214), 
    .interval_reg_sel_314                  (interval_reg_sel_314),
    .match_1_reg_sel_114                   (match_1_reg_sel_114),     
    .match_1_reg_sel_214                   (match_1_reg_sel_214),
    .match_1_reg_sel_314                   (match_1_reg_sel_314),                
    .match_2_reg_sel_114                   (match_2_reg_sel_114),
    .match_2_reg_sel_214                   (match_2_reg_sel_214),
    .match_2_reg_sel_314                   (match_2_reg_sel_314),
    .match_3_reg_sel_114                   (match_3_reg_sel_114),
    .match_3_reg_sel_214                   (match_3_reg_sel_214),
    .match_3_reg_sel_314                   (match_3_reg_sel_314),
    .intr_en_reg_sel14                     (intr_en_reg_sel14),
    .clear_interrupt14                     (clear_interrupt14)

  );


   

  ttc_timer_counter_lite14 i_ttc_timer_counter_lite_114 ( 

    //inputs14
    .n_p_reset14                           (n_p_reset14),
    .pclk14                                (pclk14), 
    .pwdata14                              (pwdata14[15:0]),
    .clk_ctrl_reg_sel14                    (clk_ctrl_reg_sel_114),
    .cntr_ctrl_reg_sel14                   (cntr_ctrl_reg_sel_114),
    .interval_reg_sel14                    (interval_reg_sel_114),
    .match_1_reg_sel14                     (match_1_reg_sel_114),
    .match_2_reg_sel14                     (match_2_reg_sel_114),
    .match_3_reg_sel14                     (match_3_reg_sel_114),
    .intr_en_reg_sel14                     (intr_en_reg_sel14[1]),
    .clear_interrupt14                     (clear_interrupt14[1]),
                                  
    //outputs14
    .clk_ctrl_reg14                        (clk_ctrl_reg_114),
    .counter_val_reg14                     (counter_val_reg_114),
    .cntr_ctrl_reg14                       (cntr_ctrl_reg_114),
    .interval_reg14                        (interval_reg_114),
    .match_1_reg14                         (match_1_reg_114),
    .match_2_reg14                         (match_2_reg_114),
    .match_3_reg14                         (match_3_reg_114),
    .interrupt14                           (TTC_int14[1]),
    .interrupt_reg14                       (interrupt_reg_114),
    .interrupt_en_reg14                    (interrupt_en_reg_114)
  );


  ttc_timer_counter_lite14 i_ttc_timer_counter_lite_214 ( 

    //inputs14
    .n_p_reset14                           (n_p_reset14), 
    .pclk14                                (pclk14),
    .pwdata14                              (pwdata14[15:0]),
    .clk_ctrl_reg_sel14                    (clk_ctrl_reg_sel_214),
    .cntr_ctrl_reg_sel14                   (cntr_ctrl_reg_sel_214),
    .interval_reg_sel14                    (interval_reg_sel_214),
    .match_1_reg_sel14                     (match_1_reg_sel_214),
    .match_2_reg_sel14                     (match_2_reg_sel_214),
    .match_3_reg_sel14                     (match_3_reg_sel_214),
    .intr_en_reg_sel14                     (intr_en_reg_sel14[2]),
    .clear_interrupt14                     (clear_interrupt14[2]),
                                  
    //outputs14
    .clk_ctrl_reg14                        (clk_ctrl_reg_214),
    .counter_val_reg14                     (counter_val_reg_214),
    .cntr_ctrl_reg14                       (cntr_ctrl_reg_214),
    .interval_reg14                        (interval_reg_214),
    .match_1_reg14                         (match_1_reg_214),
    .match_2_reg14                         (match_2_reg_214),
    .match_3_reg14                         (match_3_reg_214),
    .interrupt14                           (TTC_int14[2]),
    .interrupt_reg14                       (interrupt_reg_214),
    .interrupt_en_reg14                    (interrupt_en_reg_214)
  );



  ttc_timer_counter_lite14 i_ttc_timer_counter_lite_314 ( 

    //inputs14
    .n_p_reset14                           (n_p_reset14), 
    .pclk14                                (pclk14),
    .pwdata14                              (pwdata14[15:0]),
    .clk_ctrl_reg_sel14                    (clk_ctrl_reg_sel_314),
    .cntr_ctrl_reg_sel14                   (cntr_ctrl_reg_sel_314),
    .interval_reg_sel14                    (interval_reg_sel_314),
    .match_1_reg_sel14                     (match_1_reg_sel_314),
    .match_2_reg_sel14                     (match_2_reg_sel_314),
    .match_3_reg_sel14                     (match_3_reg_sel_314),
    .intr_en_reg_sel14                     (intr_en_reg_sel14[3]),
    .clear_interrupt14                     (clear_interrupt14[3]),
                                              
    //outputs14
    .clk_ctrl_reg14                        (clk_ctrl_reg_314),
    .counter_val_reg14                     (counter_val_reg_314),
    .cntr_ctrl_reg14                       (cntr_ctrl_reg_314),
    .interval_reg14                        (interval_reg_314),
    .match_1_reg14                         (match_1_reg_314),
    .match_2_reg14                         (match_2_reg_314),
    .match_3_reg14                         (match_3_reg_314),
    .interrupt14                           (TTC_int14[3]),
    .interrupt_reg14                       (interrupt_reg_314),
    .interrupt_en_reg14                    (interrupt_en_reg_314)
  );





endmodule 
