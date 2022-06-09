//File24 name   : ttc_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : The top level of the Triple24 Timer24 Counter24.
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module24 definition24
//-----------------------------------------------------------------------------

module ttc_lite24(
           
           //inputs24
           n_p_reset24,
           pclk24,
           psel24,
           penable24,
           pwrite24,
           pwdata24,
           paddr24,
           scan_in24,
           scan_en24,

           //outputs24
           prdata24,
           interrupt24,
           scan_out24           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS24
//-----------------------------------------------------------------------------

   input         n_p_reset24;              //System24 Reset24
   input         pclk24;                 //System24 clock24
   input         psel24;                 //Select24 line
   input         penable24;              //Enable24
   input         pwrite24;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata24;               //Write data
   input [7:0]   paddr24;                //Address Bus24 register
   input         scan_in24;              //Scan24 chain24 input port
   input         scan_en24;              //Scan24 chain24 enable port
   
   output [31:0] prdata24;               //Read Data from the APB24 Interface24
   output [3:1]  interrupt24;            //Interrupt24 from PCI24 
   output        scan_out24;             //Scan24 chain24 output port

//-----------------------------------------------------------------------------
// Module24 Interconnect24
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int24;
   wire        clk_ctrl_reg_sel_124;     //Module24 1 clock24 control24 select24
   wire        clk_ctrl_reg_sel_224;     //Module24 2 clock24 control24 select24
   wire        clk_ctrl_reg_sel_324;     //Module24 3 clock24 control24 select24
   wire        cntr_ctrl_reg_sel_124;    //Module24 1 counter control24 select24
   wire        cntr_ctrl_reg_sel_224;    //Module24 2 counter control24 select24
   wire        cntr_ctrl_reg_sel_324;    //Module24 3 counter control24 select24
   wire        interval_reg_sel_124;     //Interval24 1 register select24
   wire        interval_reg_sel_224;     //Interval24 2 register select24
   wire        interval_reg_sel_324;     //Interval24 3 register select24
   wire        match_1_reg_sel_124;      //Module24 1 match 1 select24
   wire        match_1_reg_sel_224;      //Module24 1 match 2 select24
   wire        match_1_reg_sel_324;      //Module24 1 match 3 select24
   wire        match_2_reg_sel_124;      //Module24 2 match 1 select24
   wire        match_2_reg_sel_224;      //Module24 2 match 2 select24
   wire        match_2_reg_sel_324;      //Module24 2 match 3 select24
   wire        match_3_reg_sel_124;      //Module24 3 match 1 select24
   wire        match_3_reg_sel_224;      //Module24 3 match 2 select24
   wire        match_3_reg_sel_324;      //Module24 3 match 3 select24
   wire [3:1]  intr_en_reg_sel24;        //Interrupt24 enable register select24
   wire [3:1]  clear_interrupt24;        //Clear interrupt24 signal24
   wire [5:0]  interrupt_reg_124;        //Interrupt24 register 1
   wire [5:0]  interrupt_reg_224;        //Interrupt24 register 2
   wire [5:0]  interrupt_reg_324;        //Interrupt24 register 3 
   wire [5:0]  interrupt_en_reg_124;     //Interrupt24 enable register 1
   wire [5:0]  interrupt_en_reg_224;     //Interrupt24 enable register 2
   wire [5:0]  interrupt_en_reg_324;     //Interrupt24 enable register 3
   wire [6:0]  clk_ctrl_reg_124;         //Clock24 control24 regs for the 
   wire [6:0]  clk_ctrl_reg_224;         //Timer_Counter24 1,2,3
   wire [6:0]  clk_ctrl_reg_324;         //Value of the clock24 frequency24
   wire [15:0] counter_val_reg_124;      //Module24 1 counter value 
   wire [15:0] counter_val_reg_224;      //Module24 2 counter value 
   wire [15:0] counter_val_reg_324;      //Module24 3 counter value 
   wire [6:0]  cntr_ctrl_reg_124;        //Module24 1 counter control24  
   wire [6:0]  cntr_ctrl_reg_224;        //Module24 2 counter control24  
   wire [6:0]  cntr_ctrl_reg_324;        //Module24 3 counter control24  
   wire [15:0] interval_reg_124;         //Module24 1 interval24 register
   wire [15:0] interval_reg_224;         //Module24 2 interval24 register
   wire [15:0] interval_reg_324;         //Module24 3 interval24 register
   wire [15:0] match_1_reg_124;          //Module24 1 match 1 register
   wire [15:0] match_1_reg_224;          //Module24 1 match 2 register
   wire [15:0] match_1_reg_324;          //Module24 1 match 3 register
   wire [15:0] match_2_reg_124;          //Module24 2 match 1 register
   wire [15:0] match_2_reg_224;          //Module24 2 match 2 register
   wire [15:0] match_2_reg_324;          //Module24 2 match 3 register
   wire [15:0] match_3_reg_124;          //Module24 3 match 1 register
   wire [15:0] match_3_reg_224;          //Module24 3 match 2 register
   wire [15:0] match_3_reg_324;          //Module24 3 match 3 register

  assign interrupt24 = TTC_int24;   // Bug24 Fix24 for floating24 ints - Santhosh24 8 Nov24 06
   

//-----------------------------------------------------------------------------
// Module24 Instantiations24
//-----------------------------------------------------------------------------


  ttc_interface_lite24 i_ttc_interface_lite24 ( 

    //inputs24
    .n_p_reset24                           (n_p_reset24),
    .pclk24                                (pclk24),
    .psel24                                (psel24),
    .penable24                             (penable24),
    .pwrite24                              (pwrite24),
    .paddr24                               (paddr24),
    .clk_ctrl_reg_124                      (clk_ctrl_reg_124),
    .clk_ctrl_reg_224                      (clk_ctrl_reg_224),
    .clk_ctrl_reg_324                      (clk_ctrl_reg_324),
    .cntr_ctrl_reg_124                     (cntr_ctrl_reg_124),
    .cntr_ctrl_reg_224                     (cntr_ctrl_reg_224),
    .cntr_ctrl_reg_324                     (cntr_ctrl_reg_324),
    .counter_val_reg_124                   (counter_val_reg_124),
    .counter_val_reg_224                   (counter_val_reg_224),
    .counter_val_reg_324                   (counter_val_reg_324),
    .interval_reg_124                      (interval_reg_124),
    .match_1_reg_124                       (match_1_reg_124),
    .match_2_reg_124                       (match_2_reg_124),
    .match_3_reg_124                       (match_3_reg_124),
    .interval_reg_224                      (interval_reg_224),
    .match_1_reg_224                       (match_1_reg_224),
    .match_2_reg_224                       (match_2_reg_224),
    .match_3_reg_224                       (match_3_reg_224),
    .interval_reg_324                      (interval_reg_324),
    .match_1_reg_324                       (match_1_reg_324),
    .match_2_reg_324                       (match_2_reg_324),
    .match_3_reg_324                       (match_3_reg_324),
    .interrupt_reg_124                     (interrupt_reg_124),
    .interrupt_reg_224                     (interrupt_reg_224),
    .interrupt_reg_324                     (interrupt_reg_324), 
    .interrupt_en_reg_124                  (interrupt_en_reg_124),
    .interrupt_en_reg_224                  (interrupt_en_reg_224),
    .interrupt_en_reg_324                  (interrupt_en_reg_324), 

    //outputs24
    .prdata24                              (prdata24),
    .clk_ctrl_reg_sel_124                  (clk_ctrl_reg_sel_124),
    .clk_ctrl_reg_sel_224                  (clk_ctrl_reg_sel_224),
    .clk_ctrl_reg_sel_324                  (clk_ctrl_reg_sel_324),
    .cntr_ctrl_reg_sel_124                 (cntr_ctrl_reg_sel_124),
    .cntr_ctrl_reg_sel_224                 (cntr_ctrl_reg_sel_224),
    .cntr_ctrl_reg_sel_324                 (cntr_ctrl_reg_sel_324),
    .interval_reg_sel_124                  (interval_reg_sel_124),  
    .interval_reg_sel_224                  (interval_reg_sel_224), 
    .interval_reg_sel_324                  (interval_reg_sel_324),
    .match_1_reg_sel_124                   (match_1_reg_sel_124),     
    .match_1_reg_sel_224                   (match_1_reg_sel_224),
    .match_1_reg_sel_324                   (match_1_reg_sel_324),                
    .match_2_reg_sel_124                   (match_2_reg_sel_124),
    .match_2_reg_sel_224                   (match_2_reg_sel_224),
    .match_2_reg_sel_324                   (match_2_reg_sel_324),
    .match_3_reg_sel_124                   (match_3_reg_sel_124),
    .match_3_reg_sel_224                   (match_3_reg_sel_224),
    .match_3_reg_sel_324                   (match_3_reg_sel_324),
    .intr_en_reg_sel24                     (intr_en_reg_sel24),
    .clear_interrupt24                     (clear_interrupt24)

  );


   

  ttc_timer_counter_lite24 i_ttc_timer_counter_lite_124 ( 

    //inputs24
    .n_p_reset24                           (n_p_reset24),
    .pclk24                                (pclk24), 
    .pwdata24                              (pwdata24[15:0]),
    .clk_ctrl_reg_sel24                    (clk_ctrl_reg_sel_124),
    .cntr_ctrl_reg_sel24                   (cntr_ctrl_reg_sel_124),
    .interval_reg_sel24                    (interval_reg_sel_124),
    .match_1_reg_sel24                     (match_1_reg_sel_124),
    .match_2_reg_sel24                     (match_2_reg_sel_124),
    .match_3_reg_sel24                     (match_3_reg_sel_124),
    .intr_en_reg_sel24                     (intr_en_reg_sel24[1]),
    .clear_interrupt24                     (clear_interrupt24[1]),
                                  
    //outputs24
    .clk_ctrl_reg24                        (clk_ctrl_reg_124),
    .counter_val_reg24                     (counter_val_reg_124),
    .cntr_ctrl_reg24                       (cntr_ctrl_reg_124),
    .interval_reg24                        (interval_reg_124),
    .match_1_reg24                         (match_1_reg_124),
    .match_2_reg24                         (match_2_reg_124),
    .match_3_reg24                         (match_3_reg_124),
    .interrupt24                           (TTC_int24[1]),
    .interrupt_reg24                       (interrupt_reg_124),
    .interrupt_en_reg24                    (interrupt_en_reg_124)
  );


  ttc_timer_counter_lite24 i_ttc_timer_counter_lite_224 ( 

    //inputs24
    .n_p_reset24                           (n_p_reset24), 
    .pclk24                                (pclk24),
    .pwdata24                              (pwdata24[15:0]),
    .clk_ctrl_reg_sel24                    (clk_ctrl_reg_sel_224),
    .cntr_ctrl_reg_sel24                   (cntr_ctrl_reg_sel_224),
    .interval_reg_sel24                    (interval_reg_sel_224),
    .match_1_reg_sel24                     (match_1_reg_sel_224),
    .match_2_reg_sel24                     (match_2_reg_sel_224),
    .match_3_reg_sel24                     (match_3_reg_sel_224),
    .intr_en_reg_sel24                     (intr_en_reg_sel24[2]),
    .clear_interrupt24                     (clear_interrupt24[2]),
                                  
    //outputs24
    .clk_ctrl_reg24                        (clk_ctrl_reg_224),
    .counter_val_reg24                     (counter_val_reg_224),
    .cntr_ctrl_reg24                       (cntr_ctrl_reg_224),
    .interval_reg24                        (interval_reg_224),
    .match_1_reg24                         (match_1_reg_224),
    .match_2_reg24                         (match_2_reg_224),
    .match_3_reg24                         (match_3_reg_224),
    .interrupt24                           (TTC_int24[2]),
    .interrupt_reg24                       (interrupt_reg_224),
    .interrupt_en_reg24                    (interrupt_en_reg_224)
  );



  ttc_timer_counter_lite24 i_ttc_timer_counter_lite_324 ( 

    //inputs24
    .n_p_reset24                           (n_p_reset24), 
    .pclk24                                (pclk24),
    .pwdata24                              (pwdata24[15:0]),
    .clk_ctrl_reg_sel24                    (clk_ctrl_reg_sel_324),
    .cntr_ctrl_reg_sel24                   (cntr_ctrl_reg_sel_324),
    .interval_reg_sel24                    (interval_reg_sel_324),
    .match_1_reg_sel24                     (match_1_reg_sel_324),
    .match_2_reg_sel24                     (match_2_reg_sel_324),
    .match_3_reg_sel24                     (match_3_reg_sel_324),
    .intr_en_reg_sel24                     (intr_en_reg_sel24[3]),
    .clear_interrupt24                     (clear_interrupt24[3]),
                                              
    //outputs24
    .clk_ctrl_reg24                        (clk_ctrl_reg_324),
    .counter_val_reg24                     (counter_val_reg_324),
    .cntr_ctrl_reg24                       (cntr_ctrl_reg_324),
    .interval_reg24                        (interval_reg_324),
    .match_1_reg24                         (match_1_reg_324),
    .match_2_reg24                         (match_2_reg_324),
    .match_3_reg24                         (match_3_reg_324),
    .interrupt24                           (TTC_int24[3]),
    .interrupt_reg24                       (interrupt_reg_324),
    .interrupt_en_reg24                    (interrupt_en_reg_324)
  );





endmodule 
