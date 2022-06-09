//File25 name   : ttc_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : The top level of the Triple25 Timer25 Counter25.
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module25 definition25
//-----------------------------------------------------------------------------

module ttc_lite25(
           
           //inputs25
           n_p_reset25,
           pclk25,
           psel25,
           penable25,
           pwrite25,
           pwdata25,
           paddr25,
           scan_in25,
           scan_en25,

           //outputs25
           prdata25,
           interrupt25,
           scan_out25           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS25
//-----------------------------------------------------------------------------

   input         n_p_reset25;              //System25 Reset25
   input         pclk25;                 //System25 clock25
   input         psel25;                 //Select25 line
   input         penable25;              //Enable25
   input         pwrite25;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata25;               //Write data
   input [7:0]   paddr25;                //Address Bus25 register
   input         scan_in25;              //Scan25 chain25 input port
   input         scan_en25;              //Scan25 chain25 enable port
   
   output [31:0] prdata25;               //Read Data from the APB25 Interface25
   output [3:1]  interrupt25;            //Interrupt25 from PCI25 
   output        scan_out25;             //Scan25 chain25 output port

//-----------------------------------------------------------------------------
// Module25 Interconnect25
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int25;
   wire        clk_ctrl_reg_sel_125;     //Module25 1 clock25 control25 select25
   wire        clk_ctrl_reg_sel_225;     //Module25 2 clock25 control25 select25
   wire        clk_ctrl_reg_sel_325;     //Module25 3 clock25 control25 select25
   wire        cntr_ctrl_reg_sel_125;    //Module25 1 counter control25 select25
   wire        cntr_ctrl_reg_sel_225;    //Module25 2 counter control25 select25
   wire        cntr_ctrl_reg_sel_325;    //Module25 3 counter control25 select25
   wire        interval_reg_sel_125;     //Interval25 1 register select25
   wire        interval_reg_sel_225;     //Interval25 2 register select25
   wire        interval_reg_sel_325;     //Interval25 3 register select25
   wire        match_1_reg_sel_125;      //Module25 1 match 1 select25
   wire        match_1_reg_sel_225;      //Module25 1 match 2 select25
   wire        match_1_reg_sel_325;      //Module25 1 match 3 select25
   wire        match_2_reg_sel_125;      //Module25 2 match 1 select25
   wire        match_2_reg_sel_225;      //Module25 2 match 2 select25
   wire        match_2_reg_sel_325;      //Module25 2 match 3 select25
   wire        match_3_reg_sel_125;      //Module25 3 match 1 select25
   wire        match_3_reg_sel_225;      //Module25 3 match 2 select25
   wire        match_3_reg_sel_325;      //Module25 3 match 3 select25
   wire [3:1]  intr_en_reg_sel25;        //Interrupt25 enable register select25
   wire [3:1]  clear_interrupt25;        //Clear interrupt25 signal25
   wire [5:0]  interrupt_reg_125;        //Interrupt25 register 1
   wire [5:0]  interrupt_reg_225;        //Interrupt25 register 2
   wire [5:0]  interrupt_reg_325;        //Interrupt25 register 3 
   wire [5:0]  interrupt_en_reg_125;     //Interrupt25 enable register 1
   wire [5:0]  interrupt_en_reg_225;     //Interrupt25 enable register 2
   wire [5:0]  interrupt_en_reg_325;     //Interrupt25 enable register 3
   wire [6:0]  clk_ctrl_reg_125;         //Clock25 control25 regs for the 
   wire [6:0]  clk_ctrl_reg_225;         //Timer_Counter25 1,2,3
   wire [6:0]  clk_ctrl_reg_325;         //Value of the clock25 frequency25
   wire [15:0] counter_val_reg_125;      //Module25 1 counter value 
   wire [15:0] counter_val_reg_225;      //Module25 2 counter value 
   wire [15:0] counter_val_reg_325;      //Module25 3 counter value 
   wire [6:0]  cntr_ctrl_reg_125;        //Module25 1 counter control25  
   wire [6:0]  cntr_ctrl_reg_225;        //Module25 2 counter control25  
   wire [6:0]  cntr_ctrl_reg_325;        //Module25 3 counter control25  
   wire [15:0] interval_reg_125;         //Module25 1 interval25 register
   wire [15:0] interval_reg_225;         //Module25 2 interval25 register
   wire [15:0] interval_reg_325;         //Module25 3 interval25 register
   wire [15:0] match_1_reg_125;          //Module25 1 match 1 register
   wire [15:0] match_1_reg_225;          //Module25 1 match 2 register
   wire [15:0] match_1_reg_325;          //Module25 1 match 3 register
   wire [15:0] match_2_reg_125;          //Module25 2 match 1 register
   wire [15:0] match_2_reg_225;          //Module25 2 match 2 register
   wire [15:0] match_2_reg_325;          //Module25 2 match 3 register
   wire [15:0] match_3_reg_125;          //Module25 3 match 1 register
   wire [15:0] match_3_reg_225;          //Module25 3 match 2 register
   wire [15:0] match_3_reg_325;          //Module25 3 match 3 register

  assign interrupt25 = TTC_int25;   // Bug25 Fix25 for floating25 ints - Santhosh25 8 Nov25 06
   

//-----------------------------------------------------------------------------
// Module25 Instantiations25
//-----------------------------------------------------------------------------


  ttc_interface_lite25 i_ttc_interface_lite25 ( 

    //inputs25
    .n_p_reset25                           (n_p_reset25),
    .pclk25                                (pclk25),
    .psel25                                (psel25),
    .penable25                             (penable25),
    .pwrite25                              (pwrite25),
    .paddr25                               (paddr25),
    .clk_ctrl_reg_125                      (clk_ctrl_reg_125),
    .clk_ctrl_reg_225                      (clk_ctrl_reg_225),
    .clk_ctrl_reg_325                      (clk_ctrl_reg_325),
    .cntr_ctrl_reg_125                     (cntr_ctrl_reg_125),
    .cntr_ctrl_reg_225                     (cntr_ctrl_reg_225),
    .cntr_ctrl_reg_325                     (cntr_ctrl_reg_325),
    .counter_val_reg_125                   (counter_val_reg_125),
    .counter_val_reg_225                   (counter_val_reg_225),
    .counter_val_reg_325                   (counter_val_reg_325),
    .interval_reg_125                      (interval_reg_125),
    .match_1_reg_125                       (match_1_reg_125),
    .match_2_reg_125                       (match_2_reg_125),
    .match_3_reg_125                       (match_3_reg_125),
    .interval_reg_225                      (interval_reg_225),
    .match_1_reg_225                       (match_1_reg_225),
    .match_2_reg_225                       (match_2_reg_225),
    .match_3_reg_225                       (match_3_reg_225),
    .interval_reg_325                      (interval_reg_325),
    .match_1_reg_325                       (match_1_reg_325),
    .match_2_reg_325                       (match_2_reg_325),
    .match_3_reg_325                       (match_3_reg_325),
    .interrupt_reg_125                     (interrupt_reg_125),
    .interrupt_reg_225                     (interrupt_reg_225),
    .interrupt_reg_325                     (interrupt_reg_325), 
    .interrupt_en_reg_125                  (interrupt_en_reg_125),
    .interrupt_en_reg_225                  (interrupt_en_reg_225),
    .interrupt_en_reg_325                  (interrupt_en_reg_325), 

    //outputs25
    .prdata25                              (prdata25),
    .clk_ctrl_reg_sel_125                  (clk_ctrl_reg_sel_125),
    .clk_ctrl_reg_sel_225                  (clk_ctrl_reg_sel_225),
    .clk_ctrl_reg_sel_325                  (clk_ctrl_reg_sel_325),
    .cntr_ctrl_reg_sel_125                 (cntr_ctrl_reg_sel_125),
    .cntr_ctrl_reg_sel_225                 (cntr_ctrl_reg_sel_225),
    .cntr_ctrl_reg_sel_325                 (cntr_ctrl_reg_sel_325),
    .interval_reg_sel_125                  (interval_reg_sel_125),  
    .interval_reg_sel_225                  (interval_reg_sel_225), 
    .interval_reg_sel_325                  (interval_reg_sel_325),
    .match_1_reg_sel_125                   (match_1_reg_sel_125),     
    .match_1_reg_sel_225                   (match_1_reg_sel_225),
    .match_1_reg_sel_325                   (match_1_reg_sel_325),                
    .match_2_reg_sel_125                   (match_2_reg_sel_125),
    .match_2_reg_sel_225                   (match_2_reg_sel_225),
    .match_2_reg_sel_325                   (match_2_reg_sel_325),
    .match_3_reg_sel_125                   (match_3_reg_sel_125),
    .match_3_reg_sel_225                   (match_3_reg_sel_225),
    .match_3_reg_sel_325                   (match_3_reg_sel_325),
    .intr_en_reg_sel25                     (intr_en_reg_sel25),
    .clear_interrupt25                     (clear_interrupt25)

  );


   

  ttc_timer_counter_lite25 i_ttc_timer_counter_lite_125 ( 

    //inputs25
    .n_p_reset25                           (n_p_reset25),
    .pclk25                                (pclk25), 
    .pwdata25                              (pwdata25[15:0]),
    .clk_ctrl_reg_sel25                    (clk_ctrl_reg_sel_125),
    .cntr_ctrl_reg_sel25                   (cntr_ctrl_reg_sel_125),
    .interval_reg_sel25                    (interval_reg_sel_125),
    .match_1_reg_sel25                     (match_1_reg_sel_125),
    .match_2_reg_sel25                     (match_2_reg_sel_125),
    .match_3_reg_sel25                     (match_3_reg_sel_125),
    .intr_en_reg_sel25                     (intr_en_reg_sel25[1]),
    .clear_interrupt25                     (clear_interrupt25[1]),
                                  
    //outputs25
    .clk_ctrl_reg25                        (clk_ctrl_reg_125),
    .counter_val_reg25                     (counter_val_reg_125),
    .cntr_ctrl_reg25                       (cntr_ctrl_reg_125),
    .interval_reg25                        (interval_reg_125),
    .match_1_reg25                         (match_1_reg_125),
    .match_2_reg25                         (match_2_reg_125),
    .match_3_reg25                         (match_3_reg_125),
    .interrupt25                           (TTC_int25[1]),
    .interrupt_reg25                       (interrupt_reg_125),
    .interrupt_en_reg25                    (interrupt_en_reg_125)
  );


  ttc_timer_counter_lite25 i_ttc_timer_counter_lite_225 ( 

    //inputs25
    .n_p_reset25                           (n_p_reset25), 
    .pclk25                                (pclk25),
    .pwdata25                              (pwdata25[15:0]),
    .clk_ctrl_reg_sel25                    (clk_ctrl_reg_sel_225),
    .cntr_ctrl_reg_sel25                   (cntr_ctrl_reg_sel_225),
    .interval_reg_sel25                    (interval_reg_sel_225),
    .match_1_reg_sel25                     (match_1_reg_sel_225),
    .match_2_reg_sel25                     (match_2_reg_sel_225),
    .match_3_reg_sel25                     (match_3_reg_sel_225),
    .intr_en_reg_sel25                     (intr_en_reg_sel25[2]),
    .clear_interrupt25                     (clear_interrupt25[2]),
                                  
    //outputs25
    .clk_ctrl_reg25                        (clk_ctrl_reg_225),
    .counter_val_reg25                     (counter_val_reg_225),
    .cntr_ctrl_reg25                       (cntr_ctrl_reg_225),
    .interval_reg25                        (interval_reg_225),
    .match_1_reg25                         (match_1_reg_225),
    .match_2_reg25                         (match_2_reg_225),
    .match_3_reg25                         (match_3_reg_225),
    .interrupt25                           (TTC_int25[2]),
    .interrupt_reg25                       (interrupt_reg_225),
    .interrupt_en_reg25                    (interrupt_en_reg_225)
  );



  ttc_timer_counter_lite25 i_ttc_timer_counter_lite_325 ( 

    //inputs25
    .n_p_reset25                           (n_p_reset25), 
    .pclk25                                (pclk25),
    .pwdata25                              (pwdata25[15:0]),
    .clk_ctrl_reg_sel25                    (clk_ctrl_reg_sel_325),
    .cntr_ctrl_reg_sel25                   (cntr_ctrl_reg_sel_325),
    .interval_reg_sel25                    (interval_reg_sel_325),
    .match_1_reg_sel25                     (match_1_reg_sel_325),
    .match_2_reg_sel25                     (match_2_reg_sel_325),
    .match_3_reg_sel25                     (match_3_reg_sel_325),
    .intr_en_reg_sel25                     (intr_en_reg_sel25[3]),
    .clear_interrupt25                     (clear_interrupt25[3]),
                                              
    //outputs25
    .clk_ctrl_reg25                        (clk_ctrl_reg_325),
    .counter_val_reg25                     (counter_val_reg_325),
    .cntr_ctrl_reg25                       (cntr_ctrl_reg_325),
    .interval_reg25                        (interval_reg_325),
    .match_1_reg25                         (match_1_reg_325),
    .match_2_reg25                         (match_2_reg_325),
    .match_3_reg25                         (match_3_reg_325),
    .interrupt25                           (TTC_int25[3]),
    .interrupt_reg25                       (interrupt_reg_325),
    .interrupt_en_reg25                    (interrupt_en_reg_325)
  );





endmodule 
