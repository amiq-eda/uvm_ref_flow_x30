//File20 name   : ttc_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : The top level of the Triple20 Timer20 Counter20.
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module20 definition20
//-----------------------------------------------------------------------------

module ttc_lite20(
           
           //inputs20
           n_p_reset20,
           pclk20,
           psel20,
           penable20,
           pwrite20,
           pwdata20,
           paddr20,
           scan_in20,
           scan_en20,

           //outputs20
           prdata20,
           interrupt20,
           scan_out20           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS20
//-----------------------------------------------------------------------------

   input         n_p_reset20;              //System20 Reset20
   input         pclk20;                 //System20 clock20
   input         psel20;                 //Select20 line
   input         penable20;              //Enable20
   input         pwrite20;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata20;               //Write data
   input [7:0]   paddr20;                //Address Bus20 register
   input         scan_in20;              //Scan20 chain20 input port
   input         scan_en20;              //Scan20 chain20 enable port
   
   output [31:0] prdata20;               //Read Data from the APB20 Interface20
   output [3:1]  interrupt20;            //Interrupt20 from PCI20 
   output        scan_out20;             //Scan20 chain20 output port

//-----------------------------------------------------------------------------
// Module20 Interconnect20
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int20;
   wire        clk_ctrl_reg_sel_120;     //Module20 1 clock20 control20 select20
   wire        clk_ctrl_reg_sel_220;     //Module20 2 clock20 control20 select20
   wire        clk_ctrl_reg_sel_320;     //Module20 3 clock20 control20 select20
   wire        cntr_ctrl_reg_sel_120;    //Module20 1 counter control20 select20
   wire        cntr_ctrl_reg_sel_220;    //Module20 2 counter control20 select20
   wire        cntr_ctrl_reg_sel_320;    //Module20 3 counter control20 select20
   wire        interval_reg_sel_120;     //Interval20 1 register select20
   wire        interval_reg_sel_220;     //Interval20 2 register select20
   wire        interval_reg_sel_320;     //Interval20 3 register select20
   wire        match_1_reg_sel_120;      //Module20 1 match 1 select20
   wire        match_1_reg_sel_220;      //Module20 1 match 2 select20
   wire        match_1_reg_sel_320;      //Module20 1 match 3 select20
   wire        match_2_reg_sel_120;      //Module20 2 match 1 select20
   wire        match_2_reg_sel_220;      //Module20 2 match 2 select20
   wire        match_2_reg_sel_320;      //Module20 2 match 3 select20
   wire        match_3_reg_sel_120;      //Module20 3 match 1 select20
   wire        match_3_reg_sel_220;      //Module20 3 match 2 select20
   wire        match_3_reg_sel_320;      //Module20 3 match 3 select20
   wire [3:1]  intr_en_reg_sel20;        //Interrupt20 enable register select20
   wire [3:1]  clear_interrupt20;        //Clear interrupt20 signal20
   wire [5:0]  interrupt_reg_120;        //Interrupt20 register 1
   wire [5:0]  interrupt_reg_220;        //Interrupt20 register 2
   wire [5:0]  interrupt_reg_320;        //Interrupt20 register 3 
   wire [5:0]  interrupt_en_reg_120;     //Interrupt20 enable register 1
   wire [5:0]  interrupt_en_reg_220;     //Interrupt20 enable register 2
   wire [5:0]  interrupt_en_reg_320;     //Interrupt20 enable register 3
   wire [6:0]  clk_ctrl_reg_120;         //Clock20 control20 regs for the 
   wire [6:0]  clk_ctrl_reg_220;         //Timer_Counter20 1,2,3
   wire [6:0]  clk_ctrl_reg_320;         //Value of the clock20 frequency20
   wire [15:0] counter_val_reg_120;      //Module20 1 counter value 
   wire [15:0] counter_val_reg_220;      //Module20 2 counter value 
   wire [15:0] counter_val_reg_320;      //Module20 3 counter value 
   wire [6:0]  cntr_ctrl_reg_120;        //Module20 1 counter control20  
   wire [6:0]  cntr_ctrl_reg_220;        //Module20 2 counter control20  
   wire [6:0]  cntr_ctrl_reg_320;        //Module20 3 counter control20  
   wire [15:0] interval_reg_120;         //Module20 1 interval20 register
   wire [15:0] interval_reg_220;         //Module20 2 interval20 register
   wire [15:0] interval_reg_320;         //Module20 3 interval20 register
   wire [15:0] match_1_reg_120;          //Module20 1 match 1 register
   wire [15:0] match_1_reg_220;          //Module20 1 match 2 register
   wire [15:0] match_1_reg_320;          //Module20 1 match 3 register
   wire [15:0] match_2_reg_120;          //Module20 2 match 1 register
   wire [15:0] match_2_reg_220;          //Module20 2 match 2 register
   wire [15:0] match_2_reg_320;          //Module20 2 match 3 register
   wire [15:0] match_3_reg_120;          //Module20 3 match 1 register
   wire [15:0] match_3_reg_220;          //Module20 3 match 2 register
   wire [15:0] match_3_reg_320;          //Module20 3 match 3 register

  assign interrupt20 = TTC_int20;   // Bug20 Fix20 for floating20 ints - Santhosh20 8 Nov20 06
   

//-----------------------------------------------------------------------------
// Module20 Instantiations20
//-----------------------------------------------------------------------------


  ttc_interface_lite20 i_ttc_interface_lite20 ( 

    //inputs20
    .n_p_reset20                           (n_p_reset20),
    .pclk20                                (pclk20),
    .psel20                                (psel20),
    .penable20                             (penable20),
    .pwrite20                              (pwrite20),
    .paddr20                               (paddr20),
    .clk_ctrl_reg_120                      (clk_ctrl_reg_120),
    .clk_ctrl_reg_220                      (clk_ctrl_reg_220),
    .clk_ctrl_reg_320                      (clk_ctrl_reg_320),
    .cntr_ctrl_reg_120                     (cntr_ctrl_reg_120),
    .cntr_ctrl_reg_220                     (cntr_ctrl_reg_220),
    .cntr_ctrl_reg_320                     (cntr_ctrl_reg_320),
    .counter_val_reg_120                   (counter_val_reg_120),
    .counter_val_reg_220                   (counter_val_reg_220),
    .counter_val_reg_320                   (counter_val_reg_320),
    .interval_reg_120                      (interval_reg_120),
    .match_1_reg_120                       (match_1_reg_120),
    .match_2_reg_120                       (match_2_reg_120),
    .match_3_reg_120                       (match_3_reg_120),
    .interval_reg_220                      (interval_reg_220),
    .match_1_reg_220                       (match_1_reg_220),
    .match_2_reg_220                       (match_2_reg_220),
    .match_3_reg_220                       (match_3_reg_220),
    .interval_reg_320                      (interval_reg_320),
    .match_1_reg_320                       (match_1_reg_320),
    .match_2_reg_320                       (match_2_reg_320),
    .match_3_reg_320                       (match_3_reg_320),
    .interrupt_reg_120                     (interrupt_reg_120),
    .interrupt_reg_220                     (interrupt_reg_220),
    .interrupt_reg_320                     (interrupt_reg_320), 
    .interrupt_en_reg_120                  (interrupt_en_reg_120),
    .interrupt_en_reg_220                  (interrupt_en_reg_220),
    .interrupt_en_reg_320                  (interrupt_en_reg_320), 

    //outputs20
    .prdata20                              (prdata20),
    .clk_ctrl_reg_sel_120                  (clk_ctrl_reg_sel_120),
    .clk_ctrl_reg_sel_220                  (clk_ctrl_reg_sel_220),
    .clk_ctrl_reg_sel_320                  (clk_ctrl_reg_sel_320),
    .cntr_ctrl_reg_sel_120                 (cntr_ctrl_reg_sel_120),
    .cntr_ctrl_reg_sel_220                 (cntr_ctrl_reg_sel_220),
    .cntr_ctrl_reg_sel_320                 (cntr_ctrl_reg_sel_320),
    .interval_reg_sel_120                  (interval_reg_sel_120),  
    .interval_reg_sel_220                  (interval_reg_sel_220), 
    .interval_reg_sel_320                  (interval_reg_sel_320),
    .match_1_reg_sel_120                   (match_1_reg_sel_120),     
    .match_1_reg_sel_220                   (match_1_reg_sel_220),
    .match_1_reg_sel_320                   (match_1_reg_sel_320),                
    .match_2_reg_sel_120                   (match_2_reg_sel_120),
    .match_2_reg_sel_220                   (match_2_reg_sel_220),
    .match_2_reg_sel_320                   (match_2_reg_sel_320),
    .match_3_reg_sel_120                   (match_3_reg_sel_120),
    .match_3_reg_sel_220                   (match_3_reg_sel_220),
    .match_3_reg_sel_320                   (match_3_reg_sel_320),
    .intr_en_reg_sel20                     (intr_en_reg_sel20),
    .clear_interrupt20                     (clear_interrupt20)

  );


   

  ttc_timer_counter_lite20 i_ttc_timer_counter_lite_120 ( 

    //inputs20
    .n_p_reset20                           (n_p_reset20),
    .pclk20                                (pclk20), 
    .pwdata20                              (pwdata20[15:0]),
    .clk_ctrl_reg_sel20                    (clk_ctrl_reg_sel_120),
    .cntr_ctrl_reg_sel20                   (cntr_ctrl_reg_sel_120),
    .interval_reg_sel20                    (interval_reg_sel_120),
    .match_1_reg_sel20                     (match_1_reg_sel_120),
    .match_2_reg_sel20                     (match_2_reg_sel_120),
    .match_3_reg_sel20                     (match_3_reg_sel_120),
    .intr_en_reg_sel20                     (intr_en_reg_sel20[1]),
    .clear_interrupt20                     (clear_interrupt20[1]),
                                  
    //outputs20
    .clk_ctrl_reg20                        (clk_ctrl_reg_120),
    .counter_val_reg20                     (counter_val_reg_120),
    .cntr_ctrl_reg20                       (cntr_ctrl_reg_120),
    .interval_reg20                        (interval_reg_120),
    .match_1_reg20                         (match_1_reg_120),
    .match_2_reg20                         (match_2_reg_120),
    .match_3_reg20                         (match_3_reg_120),
    .interrupt20                           (TTC_int20[1]),
    .interrupt_reg20                       (interrupt_reg_120),
    .interrupt_en_reg20                    (interrupt_en_reg_120)
  );


  ttc_timer_counter_lite20 i_ttc_timer_counter_lite_220 ( 

    //inputs20
    .n_p_reset20                           (n_p_reset20), 
    .pclk20                                (pclk20),
    .pwdata20                              (pwdata20[15:0]),
    .clk_ctrl_reg_sel20                    (clk_ctrl_reg_sel_220),
    .cntr_ctrl_reg_sel20                   (cntr_ctrl_reg_sel_220),
    .interval_reg_sel20                    (interval_reg_sel_220),
    .match_1_reg_sel20                     (match_1_reg_sel_220),
    .match_2_reg_sel20                     (match_2_reg_sel_220),
    .match_3_reg_sel20                     (match_3_reg_sel_220),
    .intr_en_reg_sel20                     (intr_en_reg_sel20[2]),
    .clear_interrupt20                     (clear_interrupt20[2]),
                                  
    //outputs20
    .clk_ctrl_reg20                        (clk_ctrl_reg_220),
    .counter_val_reg20                     (counter_val_reg_220),
    .cntr_ctrl_reg20                       (cntr_ctrl_reg_220),
    .interval_reg20                        (interval_reg_220),
    .match_1_reg20                         (match_1_reg_220),
    .match_2_reg20                         (match_2_reg_220),
    .match_3_reg20                         (match_3_reg_220),
    .interrupt20                           (TTC_int20[2]),
    .interrupt_reg20                       (interrupt_reg_220),
    .interrupt_en_reg20                    (interrupt_en_reg_220)
  );



  ttc_timer_counter_lite20 i_ttc_timer_counter_lite_320 ( 

    //inputs20
    .n_p_reset20                           (n_p_reset20), 
    .pclk20                                (pclk20),
    .pwdata20                              (pwdata20[15:0]),
    .clk_ctrl_reg_sel20                    (clk_ctrl_reg_sel_320),
    .cntr_ctrl_reg_sel20                   (cntr_ctrl_reg_sel_320),
    .interval_reg_sel20                    (interval_reg_sel_320),
    .match_1_reg_sel20                     (match_1_reg_sel_320),
    .match_2_reg_sel20                     (match_2_reg_sel_320),
    .match_3_reg_sel20                     (match_3_reg_sel_320),
    .intr_en_reg_sel20                     (intr_en_reg_sel20[3]),
    .clear_interrupt20                     (clear_interrupt20[3]),
                                              
    //outputs20
    .clk_ctrl_reg20                        (clk_ctrl_reg_320),
    .counter_val_reg20                     (counter_val_reg_320),
    .cntr_ctrl_reg20                       (cntr_ctrl_reg_320),
    .interval_reg20                        (interval_reg_320),
    .match_1_reg20                         (match_1_reg_320),
    .match_2_reg20                         (match_2_reg_320),
    .match_3_reg20                         (match_3_reg_320),
    .interrupt20                           (TTC_int20[3]),
    .interrupt_reg20                       (interrupt_reg_320),
    .interrupt_en_reg20                    (interrupt_en_reg_320)
  );





endmodule 
