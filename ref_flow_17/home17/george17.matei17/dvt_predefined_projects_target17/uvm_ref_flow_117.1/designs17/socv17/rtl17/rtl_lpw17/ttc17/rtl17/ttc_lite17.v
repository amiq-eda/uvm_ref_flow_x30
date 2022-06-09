//File17 name   : ttc_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : The top level of the Triple17 Timer17 Counter17.
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module17 definition17
//-----------------------------------------------------------------------------

module ttc_lite17(
           
           //inputs17
           n_p_reset17,
           pclk17,
           psel17,
           penable17,
           pwrite17,
           pwdata17,
           paddr17,
           scan_in17,
           scan_en17,

           //outputs17
           prdata17,
           interrupt17,
           scan_out17           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS17
//-----------------------------------------------------------------------------

   input         n_p_reset17;              //System17 Reset17
   input         pclk17;                 //System17 clock17
   input         psel17;                 //Select17 line
   input         penable17;              //Enable17
   input         pwrite17;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata17;               //Write data
   input [7:0]   paddr17;                //Address Bus17 register
   input         scan_in17;              //Scan17 chain17 input port
   input         scan_en17;              //Scan17 chain17 enable port
   
   output [31:0] prdata17;               //Read Data from the APB17 Interface17
   output [3:1]  interrupt17;            //Interrupt17 from PCI17 
   output        scan_out17;             //Scan17 chain17 output port

//-----------------------------------------------------------------------------
// Module17 Interconnect17
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int17;
   wire        clk_ctrl_reg_sel_117;     //Module17 1 clock17 control17 select17
   wire        clk_ctrl_reg_sel_217;     //Module17 2 clock17 control17 select17
   wire        clk_ctrl_reg_sel_317;     //Module17 3 clock17 control17 select17
   wire        cntr_ctrl_reg_sel_117;    //Module17 1 counter control17 select17
   wire        cntr_ctrl_reg_sel_217;    //Module17 2 counter control17 select17
   wire        cntr_ctrl_reg_sel_317;    //Module17 3 counter control17 select17
   wire        interval_reg_sel_117;     //Interval17 1 register select17
   wire        interval_reg_sel_217;     //Interval17 2 register select17
   wire        interval_reg_sel_317;     //Interval17 3 register select17
   wire        match_1_reg_sel_117;      //Module17 1 match 1 select17
   wire        match_1_reg_sel_217;      //Module17 1 match 2 select17
   wire        match_1_reg_sel_317;      //Module17 1 match 3 select17
   wire        match_2_reg_sel_117;      //Module17 2 match 1 select17
   wire        match_2_reg_sel_217;      //Module17 2 match 2 select17
   wire        match_2_reg_sel_317;      //Module17 2 match 3 select17
   wire        match_3_reg_sel_117;      //Module17 3 match 1 select17
   wire        match_3_reg_sel_217;      //Module17 3 match 2 select17
   wire        match_3_reg_sel_317;      //Module17 3 match 3 select17
   wire [3:1]  intr_en_reg_sel17;        //Interrupt17 enable register select17
   wire [3:1]  clear_interrupt17;        //Clear interrupt17 signal17
   wire [5:0]  interrupt_reg_117;        //Interrupt17 register 1
   wire [5:0]  interrupt_reg_217;        //Interrupt17 register 2
   wire [5:0]  interrupt_reg_317;        //Interrupt17 register 3 
   wire [5:0]  interrupt_en_reg_117;     //Interrupt17 enable register 1
   wire [5:0]  interrupt_en_reg_217;     //Interrupt17 enable register 2
   wire [5:0]  interrupt_en_reg_317;     //Interrupt17 enable register 3
   wire [6:0]  clk_ctrl_reg_117;         //Clock17 control17 regs for the 
   wire [6:0]  clk_ctrl_reg_217;         //Timer_Counter17 1,2,3
   wire [6:0]  clk_ctrl_reg_317;         //Value of the clock17 frequency17
   wire [15:0] counter_val_reg_117;      //Module17 1 counter value 
   wire [15:0] counter_val_reg_217;      //Module17 2 counter value 
   wire [15:0] counter_val_reg_317;      //Module17 3 counter value 
   wire [6:0]  cntr_ctrl_reg_117;        //Module17 1 counter control17  
   wire [6:0]  cntr_ctrl_reg_217;        //Module17 2 counter control17  
   wire [6:0]  cntr_ctrl_reg_317;        //Module17 3 counter control17  
   wire [15:0] interval_reg_117;         //Module17 1 interval17 register
   wire [15:0] interval_reg_217;         //Module17 2 interval17 register
   wire [15:0] interval_reg_317;         //Module17 3 interval17 register
   wire [15:0] match_1_reg_117;          //Module17 1 match 1 register
   wire [15:0] match_1_reg_217;          //Module17 1 match 2 register
   wire [15:0] match_1_reg_317;          //Module17 1 match 3 register
   wire [15:0] match_2_reg_117;          //Module17 2 match 1 register
   wire [15:0] match_2_reg_217;          //Module17 2 match 2 register
   wire [15:0] match_2_reg_317;          //Module17 2 match 3 register
   wire [15:0] match_3_reg_117;          //Module17 3 match 1 register
   wire [15:0] match_3_reg_217;          //Module17 3 match 2 register
   wire [15:0] match_3_reg_317;          //Module17 3 match 3 register

  assign interrupt17 = TTC_int17;   // Bug17 Fix17 for floating17 ints - Santhosh17 8 Nov17 06
   

//-----------------------------------------------------------------------------
// Module17 Instantiations17
//-----------------------------------------------------------------------------


  ttc_interface_lite17 i_ttc_interface_lite17 ( 

    //inputs17
    .n_p_reset17                           (n_p_reset17),
    .pclk17                                (pclk17),
    .psel17                                (psel17),
    .penable17                             (penable17),
    .pwrite17                              (pwrite17),
    .paddr17                               (paddr17),
    .clk_ctrl_reg_117                      (clk_ctrl_reg_117),
    .clk_ctrl_reg_217                      (clk_ctrl_reg_217),
    .clk_ctrl_reg_317                      (clk_ctrl_reg_317),
    .cntr_ctrl_reg_117                     (cntr_ctrl_reg_117),
    .cntr_ctrl_reg_217                     (cntr_ctrl_reg_217),
    .cntr_ctrl_reg_317                     (cntr_ctrl_reg_317),
    .counter_val_reg_117                   (counter_val_reg_117),
    .counter_val_reg_217                   (counter_val_reg_217),
    .counter_val_reg_317                   (counter_val_reg_317),
    .interval_reg_117                      (interval_reg_117),
    .match_1_reg_117                       (match_1_reg_117),
    .match_2_reg_117                       (match_2_reg_117),
    .match_3_reg_117                       (match_3_reg_117),
    .interval_reg_217                      (interval_reg_217),
    .match_1_reg_217                       (match_1_reg_217),
    .match_2_reg_217                       (match_2_reg_217),
    .match_3_reg_217                       (match_3_reg_217),
    .interval_reg_317                      (interval_reg_317),
    .match_1_reg_317                       (match_1_reg_317),
    .match_2_reg_317                       (match_2_reg_317),
    .match_3_reg_317                       (match_3_reg_317),
    .interrupt_reg_117                     (interrupt_reg_117),
    .interrupt_reg_217                     (interrupt_reg_217),
    .interrupt_reg_317                     (interrupt_reg_317), 
    .interrupt_en_reg_117                  (interrupt_en_reg_117),
    .interrupt_en_reg_217                  (interrupt_en_reg_217),
    .interrupt_en_reg_317                  (interrupt_en_reg_317), 

    //outputs17
    .prdata17                              (prdata17),
    .clk_ctrl_reg_sel_117                  (clk_ctrl_reg_sel_117),
    .clk_ctrl_reg_sel_217                  (clk_ctrl_reg_sel_217),
    .clk_ctrl_reg_sel_317                  (clk_ctrl_reg_sel_317),
    .cntr_ctrl_reg_sel_117                 (cntr_ctrl_reg_sel_117),
    .cntr_ctrl_reg_sel_217                 (cntr_ctrl_reg_sel_217),
    .cntr_ctrl_reg_sel_317                 (cntr_ctrl_reg_sel_317),
    .interval_reg_sel_117                  (interval_reg_sel_117),  
    .interval_reg_sel_217                  (interval_reg_sel_217), 
    .interval_reg_sel_317                  (interval_reg_sel_317),
    .match_1_reg_sel_117                   (match_1_reg_sel_117),     
    .match_1_reg_sel_217                   (match_1_reg_sel_217),
    .match_1_reg_sel_317                   (match_1_reg_sel_317),                
    .match_2_reg_sel_117                   (match_2_reg_sel_117),
    .match_2_reg_sel_217                   (match_2_reg_sel_217),
    .match_2_reg_sel_317                   (match_2_reg_sel_317),
    .match_3_reg_sel_117                   (match_3_reg_sel_117),
    .match_3_reg_sel_217                   (match_3_reg_sel_217),
    .match_3_reg_sel_317                   (match_3_reg_sel_317),
    .intr_en_reg_sel17                     (intr_en_reg_sel17),
    .clear_interrupt17                     (clear_interrupt17)

  );


   

  ttc_timer_counter_lite17 i_ttc_timer_counter_lite_117 ( 

    //inputs17
    .n_p_reset17                           (n_p_reset17),
    .pclk17                                (pclk17), 
    .pwdata17                              (pwdata17[15:0]),
    .clk_ctrl_reg_sel17                    (clk_ctrl_reg_sel_117),
    .cntr_ctrl_reg_sel17                   (cntr_ctrl_reg_sel_117),
    .interval_reg_sel17                    (interval_reg_sel_117),
    .match_1_reg_sel17                     (match_1_reg_sel_117),
    .match_2_reg_sel17                     (match_2_reg_sel_117),
    .match_3_reg_sel17                     (match_3_reg_sel_117),
    .intr_en_reg_sel17                     (intr_en_reg_sel17[1]),
    .clear_interrupt17                     (clear_interrupt17[1]),
                                  
    //outputs17
    .clk_ctrl_reg17                        (clk_ctrl_reg_117),
    .counter_val_reg17                     (counter_val_reg_117),
    .cntr_ctrl_reg17                       (cntr_ctrl_reg_117),
    .interval_reg17                        (interval_reg_117),
    .match_1_reg17                         (match_1_reg_117),
    .match_2_reg17                         (match_2_reg_117),
    .match_3_reg17                         (match_3_reg_117),
    .interrupt17                           (TTC_int17[1]),
    .interrupt_reg17                       (interrupt_reg_117),
    .interrupt_en_reg17                    (interrupt_en_reg_117)
  );


  ttc_timer_counter_lite17 i_ttc_timer_counter_lite_217 ( 

    //inputs17
    .n_p_reset17                           (n_p_reset17), 
    .pclk17                                (pclk17),
    .pwdata17                              (pwdata17[15:0]),
    .clk_ctrl_reg_sel17                    (clk_ctrl_reg_sel_217),
    .cntr_ctrl_reg_sel17                   (cntr_ctrl_reg_sel_217),
    .interval_reg_sel17                    (interval_reg_sel_217),
    .match_1_reg_sel17                     (match_1_reg_sel_217),
    .match_2_reg_sel17                     (match_2_reg_sel_217),
    .match_3_reg_sel17                     (match_3_reg_sel_217),
    .intr_en_reg_sel17                     (intr_en_reg_sel17[2]),
    .clear_interrupt17                     (clear_interrupt17[2]),
                                  
    //outputs17
    .clk_ctrl_reg17                        (clk_ctrl_reg_217),
    .counter_val_reg17                     (counter_val_reg_217),
    .cntr_ctrl_reg17                       (cntr_ctrl_reg_217),
    .interval_reg17                        (interval_reg_217),
    .match_1_reg17                         (match_1_reg_217),
    .match_2_reg17                         (match_2_reg_217),
    .match_3_reg17                         (match_3_reg_217),
    .interrupt17                           (TTC_int17[2]),
    .interrupt_reg17                       (interrupt_reg_217),
    .interrupt_en_reg17                    (interrupt_en_reg_217)
  );



  ttc_timer_counter_lite17 i_ttc_timer_counter_lite_317 ( 

    //inputs17
    .n_p_reset17                           (n_p_reset17), 
    .pclk17                                (pclk17),
    .pwdata17                              (pwdata17[15:0]),
    .clk_ctrl_reg_sel17                    (clk_ctrl_reg_sel_317),
    .cntr_ctrl_reg_sel17                   (cntr_ctrl_reg_sel_317),
    .interval_reg_sel17                    (interval_reg_sel_317),
    .match_1_reg_sel17                     (match_1_reg_sel_317),
    .match_2_reg_sel17                     (match_2_reg_sel_317),
    .match_3_reg_sel17                     (match_3_reg_sel_317),
    .intr_en_reg_sel17                     (intr_en_reg_sel17[3]),
    .clear_interrupt17                     (clear_interrupt17[3]),
                                              
    //outputs17
    .clk_ctrl_reg17                        (clk_ctrl_reg_317),
    .counter_val_reg17                     (counter_val_reg_317),
    .cntr_ctrl_reg17                       (cntr_ctrl_reg_317),
    .interval_reg17                        (interval_reg_317),
    .match_1_reg17                         (match_1_reg_317),
    .match_2_reg17                         (match_2_reg_317),
    .match_3_reg17                         (match_3_reg_317),
    .interrupt17                           (TTC_int17[3]),
    .interrupt_reg17                       (interrupt_reg_317),
    .interrupt_en_reg17                    (interrupt_en_reg_317)
  );





endmodule 
