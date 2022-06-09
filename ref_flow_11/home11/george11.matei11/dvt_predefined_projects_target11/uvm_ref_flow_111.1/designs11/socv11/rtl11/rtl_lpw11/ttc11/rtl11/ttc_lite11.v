//File11 name   : ttc_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : The top level of the Triple11 Timer11 Counter11.
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module11 definition11
//-----------------------------------------------------------------------------

module ttc_lite11(
           
           //inputs11
           n_p_reset11,
           pclk11,
           psel11,
           penable11,
           pwrite11,
           pwdata11,
           paddr11,
           scan_in11,
           scan_en11,

           //outputs11
           prdata11,
           interrupt11,
           scan_out11           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS11
//-----------------------------------------------------------------------------

   input         n_p_reset11;              //System11 Reset11
   input         pclk11;                 //System11 clock11
   input         psel11;                 //Select11 line
   input         penable11;              //Enable11
   input         pwrite11;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata11;               //Write data
   input [7:0]   paddr11;                //Address Bus11 register
   input         scan_in11;              //Scan11 chain11 input port
   input         scan_en11;              //Scan11 chain11 enable port
   
   output [31:0] prdata11;               //Read Data from the APB11 Interface11
   output [3:1]  interrupt11;            //Interrupt11 from PCI11 
   output        scan_out11;             //Scan11 chain11 output port

//-----------------------------------------------------------------------------
// Module11 Interconnect11
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int11;
   wire        clk_ctrl_reg_sel_111;     //Module11 1 clock11 control11 select11
   wire        clk_ctrl_reg_sel_211;     //Module11 2 clock11 control11 select11
   wire        clk_ctrl_reg_sel_311;     //Module11 3 clock11 control11 select11
   wire        cntr_ctrl_reg_sel_111;    //Module11 1 counter control11 select11
   wire        cntr_ctrl_reg_sel_211;    //Module11 2 counter control11 select11
   wire        cntr_ctrl_reg_sel_311;    //Module11 3 counter control11 select11
   wire        interval_reg_sel_111;     //Interval11 1 register select11
   wire        interval_reg_sel_211;     //Interval11 2 register select11
   wire        interval_reg_sel_311;     //Interval11 3 register select11
   wire        match_1_reg_sel_111;      //Module11 1 match 1 select11
   wire        match_1_reg_sel_211;      //Module11 1 match 2 select11
   wire        match_1_reg_sel_311;      //Module11 1 match 3 select11
   wire        match_2_reg_sel_111;      //Module11 2 match 1 select11
   wire        match_2_reg_sel_211;      //Module11 2 match 2 select11
   wire        match_2_reg_sel_311;      //Module11 2 match 3 select11
   wire        match_3_reg_sel_111;      //Module11 3 match 1 select11
   wire        match_3_reg_sel_211;      //Module11 3 match 2 select11
   wire        match_3_reg_sel_311;      //Module11 3 match 3 select11
   wire [3:1]  intr_en_reg_sel11;        //Interrupt11 enable register select11
   wire [3:1]  clear_interrupt11;        //Clear interrupt11 signal11
   wire [5:0]  interrupt_reg_111;        //Interrupt11 register 1
   wire [5:0]  interrupt_reg_211;        //Interrupt11 register 2
   wire [5:0]  interrupt_reg_311;        //Interrupt11 register 3 
   wire [5:0]  interrupt_en_reg_111;     //Interrupt11 enable register 1
   wire [5:0]  interrupt_en_reg_211;     //Interrupt11 enable register 2
   wire [5:0]  interrupt_en_reg_311;     //Interrupt11 enable register 3
   wire [6:0]  clk_ctrl_reg_111;         //Clock11 control11 regs for the 
   wire [6:0]  clk_ctrl_reg_211;         //Timer_Counter11 1,2,3
   wire [6:0]  clk_ctrl_reg_311;         //Value of the clock11 frequency11
   wire [15:0] counter_val_reg_111;      //Module11 1 counter value 
   wire [15:0] counter_val_reg_211;      //Module11 2 counter value 
   wire [15:0] counter_val_reg_311;      //Module11 3 counter value 
   wire [6:0]  cntr_ctrl_reg_111;        //Module11 1 counter control11  
   wire [6:0]  cntr_ctrl_reg_211;        //Module11 2 counter control11  
   wire [6:0]  cntr_ctrl_reg_311;        //Module11 3 counter control11  
   wire [15:0] interval_reg_111;         //Module11 1 interval11 register
   wire [15:0] interval_reg_211;         //Module11 2 interval11 register
   wire [15:0] interval_reg_311;         //Module11 3 interval11 register
   wire [15:0] match_1_reg_111;          //Module11 1 match 1 register
   wire [15:0] match_1_reg_211;          //Module11 1 match 2 register
   wire [15:0] match_1_reg_311;          //Module11 1 match 3 register
   wire [15:0] match_2_reg_111;          //Module11 2 match 1 register
   wire [15:0] match_2_reg_211;          //Module11 2 match 2 register
   wire [15:0] match_2_reg_311;          //Module11 2 match 3 register
   wire [15:0] match_3_reg_111;          //Module11 3 match 1 register
   wire [15:0] match_3_reg_211;          //Module11 3 match 2 register
   wire [15:0] match_3_reg_311;          //Module11 3 match 3 register

  assign interrupt11 = TTC_int11;   // Bug11 Fix11 for floating11 ints - Santhosh11 8 Nov11 06
   

//-----------------------------------------------------------------------------
// Module11 Instantiations11
//-----------------------------------------------------------------------------


  ttc_interface_lite11 i_ttc_interface_lite11 ( 

    //inputs11
    .n_p_reset11                           (n_p_reset11),
    .pclk11                                (pclk11),
    .psel11                                (psel11),
    .penable11                             (penable11),
    .pwrite11                              (pwrite11),
    .paddr11                               (paddr11),
    .clk_ctrl_reg_111                      (clk_ctrl_reg_111),
    .clk_ctrl_reg_211                      (clk_ctrl_reg_211),
    .clk_ctrl_reg_311                      (clk_ctrl_reg_311),
    .cntr_ctrl_reg_111                     (cntr_ctrl_reg_111),
    .cntr_ctrl_reg_211                     (cntr_ctrl_reg_211),
    .cntr_ctrl_reg_311                     (cntr_ctrl_reg_311),
    .counter_val_reg_111                   (counter_val_reg_111),
    .counter_val_reg_211                   (counter_val_reg_211),
    .counter_val_reg_311                   (counter_val_reg_311),
    .interval_reg_111                      (interval_reg_111),
    .match_1_reg_111                       (match_1_reg_111),
    .match_2_reg_111                       (match_2_reg_111),
    .match_3_reg_111                       (match_3_reg_111),
    .interval_reg_211                      (interval_reg_211),
    .match_1_reg_211                       (match_1_reg_211),
    .match_2_reg_211                       (match_2_reg_211),
    .match_3_reg_211                       (match_3_reg_211),
    .interval_reg_311                      (interval_reg_311),
    .match_1_reg_311                       (match_1_reg_311),
    .match_2_reg_311                       (match_2_reg_311),
    .match_3_reg_311                       (match_3_reg_311),
    .interrupt_reg_111                     (interrupt_reg_111),
    .interrupt_reg_211                     (interrupt_reg_211),
    .interrupt_reg_311                     (interrupt_reg_311), 
    .interrupt_en_reg_111                  (interrupt_en_reg_111),
    .interrupt_en_reg_211                  (interrupt_en_reg_211),
    .interrupt_en_reg_311                  (interrupt_en_reg_311), 

    //outputs11
    .prdata11                              (prdata11),
    .clk_ctrl_reg_sel_111                  (clk_ctrl_reg_sel_111),
    .clk_ctrl_reg_sel_211                  (clk_ctrl_reg_sel_211),
    .clk_ctrl_reg_sel_311                  (clk_ctrl_reg_sel_311),
    .cntr_ctrl_reg_sel_111                 (cntr_ctrl_reg_sel_111),
    .cntr_ctrl_reg_sel_211                 (cntr_ctrl_reg_sel_211),
    .cntr_ctrl_reg_sel_311                 (cntr_ctrl_reg_sel_311),
    .interval_reg_sel_111                  (interval_reg_sel_111),  
    .interval_reg_sel_211                  (interval_reg_sel_211), 
    .interval_reg_sel_311                  (interval_reg_sel_311),
    .match_1_reg_sel_111                   (match_1_reg_sel_111),     
    .match_1_reg_sel_211                   (match_1_reg_sel_211),
    .match_1_reg_sel_311                   (match_1_reg_sel_311),                
    .match_2_reg_sel_111                   (match_2_reg_sel_111),
    .match_2_reg_sel_211                   (match_2_reg_sel_211),
    .match_2_reg_sel_311                   (match_2_reg_sel_311),
    .match_3_reg_sel_111                   (match_3_reg_sel_111),
    .match_3_reg_sel_211                   (match_3_reg_sel_211),
    .match_3_reg_sel_311                   (match_3_reg_sel_311),
    .intr_en_reg_sel11                     (intr_en_reg_sel11),
    .clear_interrupt11                     (clear_interrupt11)

  );


   

  ttc_timer_counter_lite11 i_ttc_timer_counter_lite_111 ( 

    //inputs11
    .n_p_reset11                           (n_p_reset11),
    .pclk11                                (pclk11), 
    .pwdata11                              (pwdata11[15:0]),
    .clk_ctrl_reg_sel11                    (clk_ctrl_reg_sel_111),
    .cntr_ctrl_reg_sel11                   (cntr_ctrl_reg_sel_111),
    .interval_reg_sel11                    (interval_reg_sel_111),
    .match_1_reg_sel11                     (match_1_reg_sel_111),
    .match_2_reg_sel11                     (match_2_reg_sel_111),
    .match_3_reg_sel11                     (match_3_reg_sel_111),
    .intr_en_reg_sel11                     (intr_en_reg_sel11[1]),
    .clear_interrupt11                     (clear_interrupt11[1]),
                                  
    //outputs11
    .clk_ctrl_reg11                        (clk_ctrl_reg_111),
    .counter_val_reg11                     (counter_val_reg_111),
    .cntr_ctrl_reg11                       (cntr_ctrl_reg_111),
    .interval_reg11                        (interval_reg_111),
    .match_1_reg11                         (match_1_reg_111),
    .match_2_reg11                         (match_2_reg_111),
    .match_3_reg11                         (match_3_reg_111),
    .interrupt11                           (TTC_int11[1]),
    .interrupt_reg11                       (interrupt_reg_111),
    .interrupt_en_reg11                    (interrupt_en_reg_111)
  );


  ttc_timer_counter_lite11 i_ttc_timer_counter_lite_211 ( 

    //inputs11
    .n_p_reset11                           (n_p_reset11), 
    .pclk11                                (pclk11),
    .pwdata11                              (pwdata11[15:0]),
    .clk_ctrl_reg_sel11                    (clk_ctrl_reg_sel_211),
    .cntr_ctrl_reg_sel11                   (cntr_ctrl_reg_sel_211),
    .interval_reg_sel11                    (interval_reg_sel_211),
    .match_1_reg_sel11                     (match_1_reg_sel_211),
    .match_2_reg_sel11                     (match_2_reg_sel_211),
    .match_3_reg_sel11                     (match_3_reg_sel_211),
    .intr_en_reg_sel11                     (intr_en_reg_sel11[2]),
    .clear_interrupt11                     (clear_interrupt11[2]),
                                  
    //outputs11
    .clk_ctrl_reg11                        (clk_ctrl_reg_211),
    .counter_val_reg11                     (counter_val_reg_211),
    .cntr_ctrl_reg11                       (cntr_ctrl_reg_211),
    .interval_reg11                        (interval_reg_211),
    .match_1_reg11                         (match_1_reg_211),
    .match_2_reg11                         (match_2_reg_211),
    .match_3_reg11                         (match_3_reg_211),
    .interrupt11                           (TTC_int11[2]),
    .interrupt_reg11                       (interrupt_reg_211),
    .interrupt_en_reg11                    (interrupt_en_reg_211)
  );



  ttc_timer_counter_lite11 i_ttc_timer_counter_lite_311 ( 

    //inputs11
    .n_p_reset11                           (n_p_reset11), 
    .pclk11                                (pclk11),
    .pwdata11                              (pwdata11[15:0]),
    .clk_ctrl_reg_sel11                    (clk_ctrl_reg_sel_311),
    .cntr_ctrl_reg_sel11                   (cntr_ctrl_reg_sel_311),
    .interval_reg_sel11                    (interval_reg_sel_311),
    .match_1_reg_sel11                     (match_1_reg_sel_311),
    .match_2_reg_sel11                     (match_2_reg_sel_311),
    .match_3_reg_sel11                     (match_3_reg_sel_311),
    .intr_en_reg_sel11                     (intr_en_reg_sel11[3]),
    .clear_interrupt11                     (clear_interrupt11[3]),
                                              
    //outputs11
    .clk_ctrl_reg11                        (clk_ctrl_reg_311),
    .counter_val_reg11                     (counter_val_reg_311),
    .cntr_ctrl_reg11                       (cntr_ctrl_reg_311),
    .interval_reg11                        (interval_reg_311),
    .match_1_reg11                         (match_1_reg_311),
    .match_2_reg11                         (match_2_reg_311),
    .match_3_reg11                         (match_3_reg_311),
    .interrupt11                           (TTC_int11[3]),
    .interrupt_reg11                       (interrupt_reg_311),
    .interrupt_en_reg11                    (interrupt_en_reg_311)
  );





endmodule 
