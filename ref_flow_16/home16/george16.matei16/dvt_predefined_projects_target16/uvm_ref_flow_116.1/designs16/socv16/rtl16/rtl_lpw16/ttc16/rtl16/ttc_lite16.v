//File16 name   : ttc_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : The top level of the Triple16 Timer16 Counter16.
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module16 definition16
//-----------------------------------------------------------------------------

module ttc_lite16(
           
           //inputs16
           n_p_reset16,
           pclk16,
           psel16,
           penable16,
           pwrite16,
           pwdata16,
           paddr16,
           scan_in16,
           scan_en16,

           //outputs16
           prdata16,
           interrupt16,
           scan_out16           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS16
//-----------------------------------------------------------------------------

   input         n_p_reset16;              //System16 Reset16
   input         pclk16;                 //System16 clock16
   input         psel16;                 //Select16 line
   input         penable16;              //Enable16
   input         pwrite16;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata16;               //Write data
   input [7:0]   paddr16;                //Address Bus16 register
   input         scan_in16;              //Scan16 chain16 input port
   input         scan_en16;              //Scan16 chain16 enable port
   
   output [31:0] prdata16;               //Read Data from the APB16 Interface16
   output [3:1]  interrupt16;            //Interrupt16 from PCI16 
   output        scan_out16;             //Scan16 chain16 output port

//-----------------------------------------------------------------------------
// Module16 Interconnect16
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int16;
   wire        clk_ctrl_reg_sel_116;     //Module16 1 clock16 control16 select16
   wire        clk_ctrl_reg_sel_216;     //Module16 2 clock16 control16 select16
   wire        clk_ctrl_reg_sel_316;     //Module16 3 clock16 control16 select16
   wire        cntr_ctrl_reg_sel_116;    //Module16 1 counter control16 select16
   wire        cntr_ctrl_reg_sel_216;    //Module16 2 counter control16 select16
   wire        cntr_ctrl_reg_sel_316;    //Module16 3 counter control16 select16
   wire        interval_reg_sel_116;     //Interval16 1 register select16
   wire        interval_reg_sel_216;     //Interval16 2 register select16
   wire        interval_reg_sel_316;     //Interval16 3 register select16
   wire        match_1_reg_sel_116;      //Module16 1 match 1 select16
   wire        match_1_reg_sel_216;      //Module16 1 match 2 select16
   wire        match_1_reg_sel_316;      //Module16 1 match 3 select16
   wire        match_2_reg_sel_116;      //Module16 2 match 1 select16
   wire        match_2_reg_sel_216;      //Module16 2 match 2 select16
   wire        match_2_reg_sel_316;      //Module16 2 match 3 select16
   wire        match_3_reg_sel_116;      //Module16 3 match 1 select16
   wire        match_3_reg_sel_216;      //Module16 3 match 2 select16
   wire        match_3_reg_sel_316;      //Module16 3 match 3 select16
   wire [3:1]  intr_en_reg_sel16;        //Interrupt16 enable register select16
   wire [3:1]  clear_interrupt16;        //Clear interrupt16 signal16
   wire [5:0]  interrupt_reg_116;        //Interrupt16 register 1
   wire [5:0]  interrupt_reg_216;        //Interrupt16 register 2
   wire [5:0]  interrupt_reg_316;        //Interrupt16 register 3 
   wire [5:0]  interrupt_en_reg_116;     //Interrupt16 enable register 1
   wire [5:0]  interrupt_en_reg_216;     //Interrupt16 enable register 2
   wire [5:0]  interrupt_en_reg_316;     //Interrupt16 enable register 3
   wire [6:0]  clk_ctrl_reg_116;         //Clock16 control16 regs for the 
   wire [6:0]  clk_ctrl_reg_216;         //Timer_Counter16 1,2,3
   wire [6:0]  clk_ctrl_reg_316;         //Value of the clock16 frequency16
   wire [15:0] counter_val_reg_116;      //Module16 1 counter value 
   wire [15:0] counter_val_reg_216;      //Module16 2 counter value 
   wire [15:0] counter_val_reg_316;      //Module16 3 counter value 
   wire [6:0]  cntr_ctrl_reg_116;        //Module16 1 counter control16  
   wire [6:0]  cntr_ctrl_reg_216;        //Module16 2 counter control16  
   wire [6:0]  cntr_ctrl_reg_316;        //Module16 3 counter control16  
   wire [15:0] interval_reg_116;         //Module16 1 interval16 register
   wire [15:0] interval_reg_216;         //Module16 2 interval16 register
   wire [15:0] interval_reg_316;         //Module16 3 interval16 register
   wire [15:0] match_1_reg_116;          //Module16 1 match 1 register
   wire [15:0] match_1_reg_216;          //Module16 1 match 2 register
   wire [15:0] match_1_reg_316;          //Module16 1 match 3 register
   wire [15:0] match_2_reg_116;          //Module16 2 match 1 register
   wire [15:0] match_2_reg_216;          //Module16 2 match 2 register
   wire [15:0] match_2_reg_316;          //Module16 2 match 3 register
   wire [15:0] match_3_reg_116;          //Module16 3 match 1 register
   wire [15:0] match_3_reg_216;          //Module16 3 match 2 register
   wire [15:0] match_3_reg_316;          //Module16 3 match 3 register

  assign interrupt16 = TTC_int16;   // Bug16 Fix16 for floating16 ints - Santhosh16 8 Nov16 06
   

//-----------------------------------------------------------------------------
// Module16 Instantiations16
//-----------------------------------------------------------------------------


  ttc_interface_lite16 i_ttc_interface_lite16 ( 

    //inputs16
    .n_p_reset16                           (n_p_reset16),
    .pclk16                                (pclk16),
    .psel16                                (psel16),
    .penable16                             (penable16),
    .pwrite16                              (pwrite16),
    .paddr16                               (paddr16),
    .clk_ctrl_reg_116                      (clk_ctrl_reg_116),
    .clk_ctrl_reg_216                      (clk_ctrl_reg_216),
    .clk_ctrl_reg_316                      (clk_ctrl_reg_316),
    .cntr_ctrl_reg_116                     (cntr_ctrl_reg_116),
    .cntr_ctrl_reg_216                     (cntr_ctrl_reg_216),
    .cntr_ctrl_reg_316                     (cntr_ctrl_reg_316),
    .counter_val_reg_116                   (counter_val_reg_116),
    .counter_val_reg_216                   (counter_val_reg_216),
    .counter_val_reg_316                   (counter_val_reg_316),
    .interval_reg_116                      (interval_reg_116),
    .match_1_reg_116                       (match_1_reg_116),
    .match_2_reg_116                       (match_2_reg_116),
    .match_3_reg_116                       (match_3_reg_116),
    .interval_reg_216                      (interval_reg_216),
    .match_1_reg_216                       (match_1_reg_216),
    .match_2_reg_216                       (match_2_reg_216),
    .match_3_reg_216                       (match_3_reg_216),
    .interval_reg_316                      (interval_reg_316),
    .match_1_reg_316                       (match_1_reg_316),
    .match_2_reg_316                       (match_2_reg_316),
    .match_3_reg_316                       (match_3_reg_316),
    .interrupt_reg_116                     (interrupt_reg_116),
    .interrupt_reg_216                     (interrupt_reg_216),
    .interrupt_reg_316                     (interrupt_reg_316), 
    .interrupt_en_reg_116                  (interrupt_en_reg_116),
    .interrupt_en_reg_216                  (interrupt_en_reg_216),
    .interrupt_en_reg_316                  (interrupt_en_reg_316), 

    //outputs16
    .prdata16                              (prdata16),
    .clk_ctrl_reg_sel_116                  (clk_ctrl_reg_sel_116),
    .clk_ctrl_reg_sel_216                  (clk_ctrl_reg_sel_216),
    .clk_ctrl_reg_sel_316                  (clk_ctrl_reg_sel_316),
    .cntr_ctrl_reg_sel_116                 (cntr_ctrl_reg_sel_116),
    .cntr_ctrl_reg_sel_216                 (cntr_ctrl_reg_sel_216),
    .cntr_ctrl_reg_sel_316                 (cntr_ctrl_reg_sel_316),
    .interval_reg_sel_116                  (interval_reg_sel_116),  
    .interval_reg_sel_216                  (interval_reg_sel_216), 
    .interval_reg_sel_316                  (interval_reg_sel_316),
    .match_1_reg_sel_116                   (match_1_reg_sel_116),     
    .match_1_reg_sel_216                   (match_1_reg_sel_216),
    .match_1_reg_sel_316                   (match_1_reg_sel_316),                
    .match_2_reg_sel_116                   (match_2_reg_sel_116),
    .match_2_reg_sel_216                   (match_2_reg_sel_216),
    .match_2_reg_sel_316                   (match_2_reg_sel_316),
    .match_3_reg_sel_116                   (match_3_reg_sel_116),
    .match_3_reg_sel_216                   (match_3_reg_sel_216),
    .match_3_reg_sel_316                   (match_3_reg_sel_316),
    .intr_en_reg_sel16                     (intr_en_reg_sel16),
    .clear_interrupt16                     (clear_interrupt16)

  );


   

  ttc_timer_counter_lite16 i_ttc_timer_counter_lite_116 ( 

    //inputs16
    .n_p_reset16                           (n_p_reset16),
    .pclk16                                (pclk16), 
    .pwdata16                              (pwdata16[15:0]),
    .clk_ctrl_reg_sel16                    (clk_ctrl_reg_sel_116),
    .cntr_ctrl_reg_sel16                   (cntr_ctrl_reg_sel_116),
    .interval_reg_sel16                    (interval_reg_sel_116),
    .match_1_reg_sel16                     (match_1_reg_sel_116),
    .match_2_reg_sel16                     (match_2_reg_sel_116),
    .match_3_reg_sel16                     (match_3_reg_sel_116),
    .intr_en_reg_sel16                     (intr_en_reg_sel16[1]),
    .clear_interrupt16                     (clear_interrupt16[1]),
                                  
    //outputs16
    .clk_ctrl_reg16                        (clk_ctrl_reg_116),
    .counter_val_reg16                     (counter_val_reg_116),
    .cntr_ctrl_reg16                       (cntr_ctrl_reg_116),
    .interval_reg16                        (interval_reg_116),
    .match_1_reg16                         (match_1_reg_116),
    .match_2_reg16                         (match_2_reg_116),
    .match_3_reg16                         (match_3_reg_116),
    .interrupt16                           (TTC_int16[1]),
    .interrupt_reg16                       (interrupt_reg_116),
    .interrupt_en_reg16                    (interrupt_en_reg_116)
  );


  ttc_timer_counter_lite16 i_ttc_timer_counter_lite_216 ( 

    //inputs16
    .n_p_reset16                           (n_p_reset16), 
    .pclk16                                (pclk16),
    .pwdata16                              (pwdata16[15:0]),
    .clk_ctrl_reg_sel16                    (clk_ctrl_reg_sel_216),
    .cntr_ctrl_reg_sel16                   (cntr_ctrl_reg_sel_216),
    .interval_reg_sel16                    (interval_reg_sel_216),
    .match_1_reg_sel16                     (match_1_reg_sel_216),
    .match_2_reg_sel16                     (match_2_reg_sel_216),
    .match_3_reg_sel16                     (match_3_reg_sel_216),
    .intr_en_reg_sel16                     (intr_en_reg_sel16[2]),
    .clear_interrupt16                     (clear_interrupt16[2]),
                                  
    //outputs16
    .clk_ctrl_reg16                        (clk_ctrl_reg_216),
    .counter_val_reg16                     (counter_val_reg_216),
    .cntr_ctrl_reg16                       (cntr_ctrl_reg_216),
    .interval_reg16                        (interval_reg_216),
    .match_1_reg16                         (match_1_reg_216),
    .match_2_reg16                         (match_2_reg_216),
    .match_3_reg16                         (match_3_reg_216),
    .interrupt16                           (TTC_int16[2]),
    .interrupt_reg16                       (interrupt_reg_216),
    .interrupt_en_reg16                    (interrupt_en_reg_216)
  );



  ttc_timer_counter_lite16 i_ttc_timer_counter_lite_316 ( 

    //inputs16
    .n_p_reset16                           (n_p_reset16), 
    .pclk16                                (pclk16),
    .pwdata16                              (pwdata16[15:0]),
    .clk_ctrl_reg_sel16                    (clk_ctrl_reg_sel_316),
    .cntr_ctrl_reg_sel16                   (cntr_ctrl_reg_sel_316),
    .interval_reg_sel16                    (interval_reg_sel_316),
    .match_1_reg_sel16                     (match_1_reg_sel_316),
    .match_2_reg_sel16                     (match_2_reg_sel_316),
    .match_3_reg_sel16                     (match_3_reg_sel_316),
    .intr_en_reg_sel16                     (intr_en_reg_sel16[3]),
    .clear_interrupt16                     (clear_interrupt16[3]),
                                              
    //outputs16
    .clk_ctrl_reg16                        (clk_ctrl_reg_316),
    .counter_val_reg16                     (counter_val_reg_316),
    .cntr_ctrl_reg16                       (cntr_ctrl_reg_316),
    .interval_reg16                        (interval_reg_316),
    .match_1_reg16                         (match_1_reg_316),
    .match_2_reg16                         (match_2_reg_316),
    .match_3_reg16                         (match_3_reg_316),
    .interrupt16                           (TTC_int16[3]),
    .interrupt_reg16                       (interrupt_reg_316),
    .interrupt_en_reg16                    (interrupt_en_reg_316)
  );





endmodule 
