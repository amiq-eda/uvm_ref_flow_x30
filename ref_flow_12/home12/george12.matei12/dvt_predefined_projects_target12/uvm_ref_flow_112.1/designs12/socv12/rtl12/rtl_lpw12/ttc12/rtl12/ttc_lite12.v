//File12 name   : ttc_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : The top level of the Triple12 Timer12 Counter12.
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module12 definition12
//-----------------------------------------------------------------------------

module ttc_lite12(
           
           //inputs12
           n_p_reset12,
           pclk12,
           psel12,
           penable12,
           pwrite12,
           pwdata12,
           paddr12,
           scan_in12,
           scan_en12,

           //outputs12
           prdata12,
           interrupt12,
           scan_out12           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS12
//-----------------------------------------------------------------------------

   input         n_p_reset12;              //System12 Reset12
   input         pclk12;                 //System12 clock12
   input         psel12;                 //Select12 line
   input         penable12;              //Enable12
   input         pwrite12;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata12;               //Write data
   input [7:0]   paddr12;                //Address Bus12 register
   input         scan_in12;              //Scan12 chain12 input port
   input         scan_en12;              //Scan12 chain12 enable port
   
   output [31:0] prdata12;               //Read Data from the APB12 Interface12
   output [3:1]  interrupt12;            //Interrupt12 from PCI12 
   output        scan_out12;             //Scan12 chain12 output port

//-----------------------------------------------------------------------------
// Module12 Interconnect12
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int12;
   wire        clk_ctrl_reg_sel_112;     //Module12 1 clock12 control12 select12
   wire        clk_ctrl_reg_sel_212;     //Module12 2 clock12 control12 select12
   wire        clk_ctrl_reg_sel_312;     //Module12 3 clock12 control12 select12
   wire        cntr_ctrl_reg_sel_112;    //Module12 1 counter control12 select12
   wire        cntr_ctrl_reg_sel_212;    //Module12 2 counter control12 select12
   wire        cntr_ctrl_reg_sel_312;    //Module12 3 counter control12 select12
   wire        interval_reg_sel_112;     //Interval12 1 register select12
   wire        interval_reg_sel_212;     //Interval12 2 register select12
   wire        interval_reg_sel_312;     //Interval12 3 register select12
   wire        match_1_reg_sel_112;      //Module12 1 match 1 select12
   wire        match_1_reg_sel_212;      //Module12 1 match 2 select12
   wire        match_1_reg_sel_312;      //Module12 1 match 3 select12
   wire        match_2_reg_sel_112;      //Module12 2 match 1 select12
   wire        match_2_reg_sel_212;      //Module12 2 match 2 select12
   wire        match_2_reg_sel_312;      //Module12 2 match 3 select12
   wire        match_3_reg_sel_112;      //Module12 3 match 1 select12
   wire        match_3_reg_sel_212;      //Module12 3 match 2 select12
   wire        match_3_reg_sel_312;      //Module12 3 match 3 select12
   wire [3:1]  intr_en_reg_sel12;        //Interrupt12 enable register select12
   wire [3:1]  clear_interrupt12;        //Clear interrupt12 signal12
   wire [5:0]  interrupt_reg_112;        //Interrupt12 register 1
   wire [5:0]  interrupt_reg_212;        //Interrupt12 register 2
   wire [5:0]  interrupt_reg_312;        //Interrupt12 register 3 
   wire [5:0]  interrupt_en_reg_112;     //Interrupt12 enable register 1
   wire [5:0]  interrupt_en_reg_212;     //Interrupt12 enable register 2
   wire [5:0]  interrupt_en_reg_312;     //Interrupt12 enable register 3
   wire [6:0]  clk_ctrl_reg_112;         //Clock12 control12 regs for the 
   wire [6:0]  clk_ctrl_reg_212;         //Timer_Counter12 1,2,3
   wire [6:0]  clk_ctrl_reg_312;         //Value of the clock12 frequency12
   wire [15:0] counter_val_reg_112;      //Module12 1 counter value 
   wire [15:0] counter_val_reg_212;      //Module12 2 counter value 
   wire [15:0] counter_val_reg_312;      //Module12 3 counter value 
   wire [6:0]  cntr_ctrl_reg_112;        //Module12 1 counter control12  
   wire [6:0]  cntr_ctrl_reg_212;        //Module12 2 counter control12  
   wire [6:0]  cntr_ctrl_reg_312;        //Module12 3 counter control12  
   wire [15:0] interval_reg_112;         //Module12 1 interval12 register
   wire [15:0] interval_reg_212;         //Module12 2 interval12 register
   wire [15:0] interval_reg_312;         //Module12 3 interval12 register
   wire [15:0] match_1_reg_112;          //Module12 1 match 1 register
   wire [15:0] match_1_reg_212;          //Module12 1 match 2 register
   wire [15:0] match_1_reg_312;          //Module12 1 match 3 register
   wire [15:0] match_2_reg_112;          //Module12 2 match 1 register
   wire [15:0] match_2_reg_212;          //Module12 2 match 2 register
   wire [15:0] match_2_reg_312;          //Module12 2 match 3 register
   wire [15:0] match_3_reg_112;          //Module12 3 match 1 register
   wire [15:0] match_3_reg_212;          //Module12 3 match 2 register
   wire [15:0] match_3_reg_312;          //Module12 3 match 3 register

  assign interrupt12 = TTC_int12;   // Bug12 Fix12 for floating12 ints - Santhosh12 8 Nov12 06
   

//-----------------------------------------------------------------------------
// Module12 Instantiations12
//-----------------------------------------------------------------------------


  ttc_interface_lite12 i_ttc_interface_lite12 ( 

    //inputs12
    .n_p_reset12                           (n_p_reset12),
    .pclk12                                (pclk12),
    .psel12                                (psel12),
    .penable12                             (penable12),
    .pwrite12                              (pwrite12),
    .paddr12                               (paddr12),
    .clk_ctrl_reg_112                      (clk_ctrl_reg_112),
    .clk_ctrl_reg_212                      (clk_ctrl_reg_212),
    .clk_ctrl_reg_312                      (clk_ctrl_reg_312),
    .cntr_ctrl_reg_112                     (cntr_ctrl_reg_112),
    .cntr_ctrl_reg_212                     (cntr_ctrl_reg_212),
    .cntr_ctrl_reg_312                     (cntr_ctrl_reg_312),
    .counter_val_reg_112                   (counter_val_reg_112),
    .counter_val_reg_212                   (counter_val_reg_212),
    .counter_val_reg_312                   (counter_val_reg_312),
    .interval_reg_112                      (interval_reg_112),
    .match_1_reg_112                       (match_1_reg_112),
    .match_2_reg_112                       (match_2_reg_112),
    .match_3_reg_112                       (match_3_reg_112),
    .interval_reg_212                      (interval_reg_212),
    .match_1_reg_212                       (match_1_reg_212),
    .match_2_reg_212                       (match_2_reg_212),
    .match_3_reg_212                       (match_3_reg_212),
    .interval_reg_312                      (interval_reg_312),
    .match_1_reg_312                       (match_1_reg_312),
    .match_2_reg_312                       (match_2_reg_312),
    .match_3_reg_312                       (match_3_reg_312),
    .interrupt_reg_112                     (interrupt_reg_112),
    .interrupt_reg_212                     (interrupt_reg_212),
    .interrupt_reg_312                     (interrupt_reg_312), 
    .interrupt_en_reg_112                  (interrupt_en_reg_112),
    .interrupt_en_reg_212                  (interrupt_en_reg_212),
    .interrupt_en_reg_312                  (interrupt_en_reg_312), 

    //outputs12
    .prdata12                              (prdata12),
    .clk_ctrl_reg_sel_112                  (clk_ctrl_reg_sel_112),
    .clk_ctrl_reg_sel_212                  (clk_ctrl_reg_sel_212),
    .clk_ctrl_reg_sel_312                  (clk_ctrl_reg_sel_312),
    .cntr_ctrl_reg_sel_112                 (cntr_ctrl_reg_sel_112),
    .cntr_ctrl_reg_sel_212                 (cntr_ctrl_reg_sel_212),
    .cntr_ctrl_reg_sel_312                 (cntr_ctrl_reg_sel_312),
    .interval_reg_sel_112                  (interval_reg_sel_112),  
    .interval_reg_sel_212                  (interval_reg_sel_212), 
    .interval_reg_sel_312                  (interval_reg_sel_312),
    .match_1_reg_sel_112                   (match_1_reg_sel_112),     
    .match_1_reg_sel_212                   (match_1_reg_sel_212),
    .match_1_reg_sel_312                   (match_1_reg_sel_312),                
    .match_2_reg_sel_112                   (match_2_reg_sel_112),
    .match_2_reg_sel_212                   (match_2_reg_sel_212),
    .match_2_reg_sel_312                   (match_2_reg_sel_312),
    .match_3_reg_sel_112                   (match_3_reg_sel_112),
    .match_3_reg_sel_212                   (match_3_reg_sel_212),
    .match_3_reg_sel_312                   (match_3_reg_sel_312),
    .intr_en_reg_sel12                     (intr_en_reg_sel12),
    .clear_interrupt12                     (clear_interrupt12)

  );


   

  ttc_timer_counter_lite12 i_ttc_timer_counter_lite_112 ( 

    //inputs12
    .n_p_reset12                           (n_p_reset12),
    .pclk12                                (pclk12), 
    .pwdata12                              (pwdata12[15:0]),
    .clk_ctrl_reg_sel12                    (clk_ctrl_reg_sel_112),
    .cntr_ctrl_reg_sel12                   (cntr_ctrl_reg_sel_112),
    .interval_reg_sel12                    (interval_reg_sel_112),
    .match_1_reg_sel12                     (match_1_reg_sel_112),
    .match_2_reg_sel12                     (match_2_reg_sel_112),
    .match_3_reg_sel12                     (match_3_reg_sel_112),
    .intr_en_reg_sel12                     (intr_en_reg_sel12[1]),
    .clear_interrupt12                     (clear_interrupt12[1]),
                                  
    //outputs12
    .clk_ctrl_reg12                        (clk_ctrl_reg_112),
    .counter_val_reg12                     (counter_val_reg_112),
    .cntr_ctrl_reg12                       (cntr_ctrl_reg_112),
    .interval_reg12                        (interval_reg_112),
    .match_1_reg12                         (match_1_reg_112),
    .match_2_reg12                         (match_2_reg_112),
    .match_3_reg12                         (match_3_reg_112),
    .interrupt12                           (TTC_int12[1]),
    .interrupt_reg12                       (interrupt_reg_112),
    .interrupt_en_reg12                    (interrupt_en_reg_112)
  );


  ttc_timer_counter_lite12 i_ttc_timer_counter_lite_212 ( 

    //inputs12
    .n_p_reset12                           (n_p_reset12), 
    .pclk12                                (pclk12),
    .pwdata12                              (pwdata12[15:0]),
    .clk_ctrl_reg_sel12                    (clk_ctrl_reg_sel_212),
    .cntr_ctrl_reg_sel12                   (cntr_ctrl_reg_sel_212),
    .interval_reg_sel12                    (interval_reg_sel_212),
    .match_1_reg_sel12                     (match_1_reg_sel_212),
    .match_2_reg_sel12                     (match_2_reg_sel_212),
    .match_3_reg_sel12                     (match_3_reg_sel_212),
    .intr_en_reg_sel12                     (intr_en_reg_sel12[2]),
    .clear_interrupt12                     (clear_interrupt12[2]),
                                  
    //outputs12
    .clk_ctrl_reg12                        (clk_ctrl_reg_212),
    .counter_val_reg12                     (counter_val_reg_212),
    .cntr_ctrl_reg12                       (cntr_ctrl_reg_212),
    .interval_reg12                        (interval_reg_212),
    .match_1_reg12                         (match_1_reg_212),
    .match_2_reg12                         (match_2_reg_212),
    .match_3_reg12                         (match_3_reg_212),
    .interrupt12                           (TTC_int12[2]),
    .interrupt_reg12                       (interrupt_reg_212),
    .interrupt_en_reg12                    (interrupt_en_reg_212)
  );



  ttc_timer_counter_lite12 i_ttc_timer_counter_lite_312 ( 

    //inputs12
    .n_p_reset12                           (n_p_reset12), 
    .pclk12                                (pclk12),
    .pwdata12                              (pwdata12[15:0]),
    .clk_ctrl_reg_sel12                    (clk_ctrl_reg_sel_312),
    .cntr_ctrl_reg_sel12                   (cntr_ctrl_reg_sel_312),
    .interval_reg_sel12                    (interval_reg_sel_312),
    .match_1_reg_sel12                     (match_1_reg_sel_312),
    .match_2_reg_sel12                     (match_2_reg_sel_312),
    .match_3_reg_sel12                     (match_3_reg_sel_312),
    .intr_en_reg_sel12                     (intr_en_reg_sel12[3]),
    .clear_interrupt12                     (clear_interrupt12[3]),
                                              
    //outputs12
    .clk_ctrl_reg12                        (clk_ctrl_reg_312),
    .counter_val_reg12                     (counter_val_reg_312),
    .cntr_ctrl_reg12                       (cntr_ctrl_reg_312),
    .interval_reg12                        (interval_reg_312),
    .match_1_reg12                         (match_1_reg_312),
    .match_2_reg12                         (match_2_reg_312),
    .match_3_reg12                         (match_3_reg_312),
    .interrupt12                           (TTC_int12[3]),
    .interrupt_reg12                       (interrupt_reg_312),
    .interrupt_en_reg12                    (interrupt_en_reg_312)
  );





endmodule 
