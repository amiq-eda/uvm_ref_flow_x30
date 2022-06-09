//File29 name   : ttc_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : The top level of the Triple29 Timer29 Counter29.
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module29 definition29
//-----------------------------------------------------------------------------

module ttc_lite29(
           
           //inputs29
           n_p_reset29,
           pclk29,
           psel29,
           penable29,
           pwrite29,
           pwdata29,
           paddr29,
           scan_in29,
           scan_en29,

           //outputs29
           prdata29,
           interrupt29,
           scan_out29           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS29
//-----------------------------------------------------------------------------

   input         n_p_reset29;              //System29 Reset29
   input         pclk29;                 //System29 clock29
   input         psel29;                 //Select29 line
   input         penable29;              //Enable29
   input         pwrite29;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata29;               //Write data
   input [7:0]   paddr29;                //Address Bus29 register
   input         scan_in29;              //Scan29 chain29 input port
   input         scan_en29;              //Scan29 chain29 enable port
   
   output [31:0] prdata29;               //Read Data from the APB29 Interface29
   output [3:1]  interrupt29;            //Interrupt29 from PCI29 
   output        scan_out29;             //Scan29 chain29 output port

//-----------------------------------------------------------------------------
// Module29 Interconnect29
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int29;
   wire        clk_ctrl_reg_sel_129;     //Module29 1 clock29 control29 select29
   wire        clk_ctrl_reg_sel_229;     //Module29 2 clock29 control29 select29
   wire        clk_ctrl_reg_sel_329;     //Module29 3 clock29 control29 select29
   wire        cntr_ctrl_reg_sel_129;    //Module29 1 counter control29 select29
   wire        cntr_ctrl_reg_sel_229;    //Module29 2 counter control29 select29
   wire        cntr_ctrl_reg_sel_329;    //Module29 3 counter control29 select29
   wire        interval_reg_sel_129;     //Interval29 1 register select29
   wire        interval_reg_sel_229;     //Interval29 2 register select29
   wire        interval_reg_sel_329;     //Interval29 3 register select29
   wire        match_1_reg_sel_129;      //Module29 1 match 1 select29
   wire        match_1_reg_sel_229;      //Module29 1 match 2 select29
   wire        match_1_reg_sel_329;      //Module29 1 match 3 select29
   wire        match_2_reg_sel_129;      //Module29 2 match 1 select29
   wire        match_2_reg_sel_229;      //Module29 2 match 2 select29
   wire        match_2_reg_sel_329;      //Module29 2 match 3 select29
   wire        match_3_reg_sel_129;      //Module29 3 match 1 select29
   wire        match_3_reg_sel_229;      //Module29 3 match 2 select29
   wire        match_3_reg_sel_329;      //Module29 3 match 3 select29
   wire [3:1]  intr_en_reg_sel29;        //Interrupt29 enable register select29
   wire [3:1]  clear_interrupt29;        //Clear interrupt29 signal29
   wire [5:0]  interrupt_reg_129;        //Interrupt29 register 1
   wire [5:0]  interrupt_reg_229;        //Interrupt29 register 2
   wire [5:0]  interrupt_reg_329;        //Interrupt29 register 3 
   wire [5:0]  interrupt_en_reg_129;     //Interrupt29 enable register 1
   wire [5:0]  interrupt_en_reg_229;     //Interrupt29 enable register 2
   wire [5:0]  interrupt_en_reg_329;     //Interrupt29 enable register 3
   wire [6:0]  clk_ctrl_reg_129;         //Clock29 control29 regs for the 
   wire [6:0]  clk_ctrl_reg_229;         //Timer_Counter29 1,2,3
   wire [6:0]  clk_ctrl_reg_329;         //Value of the clock29 frequency29
   wire [15:0] counter_val_reg_129;      //Module29 1 counter value 
   wire [15:0] counter_val_reg_229;      //Module29 2 counter value 
   wire [15:0] counter_val_reg_329;      //Module29 3 counter value 
   wire [6:0]  cntr_ctrl_reg_129;        //Module29 1 counter control29  
   wire [6:0]  cntr_ctrl_reg_229;        //Module29 2 counter control29  
   wire [6:0]  cntr_ctrl_reg_329;        //Module29 3 counter control29  
   wire [15:0] interval_reg_129;         //Module29 1 interval29 register
   wire [15:0] interval_reg_229;         //Module29 2 interval29 register
   wire [15:0] interval_reg_329;         //Module29 3 interval29 register
   wire [15:0] match_1_reg_129;          //Module29 1 match 1 register
   wire [15:0] match_1_reg_229;          //Module29 1 match 2 register
   wire [15:0] match_1_reg_329;          //Module29 1 match 3 register
   wire [15:0] match_2_reg_129;          //Module29 2 match 1 register
   wire [15:0] match_2_reg_229;          //Module29 2 match 2 register
   wire [15:0] match_2_reg_329;          //Module29 2 match 3 register
   wire [15:0] match_3_reg_129;          //Module29 3 match 1 register
   wire [15:0] match_3_reg_229;          //Module29 3 match 2 register
   wire [15:0] match_3_reg_329;          //Module29 3 match 3 register

  assign interrupt29 = TTC_int29;   // Bug29 Fix29 for floating29 ints - Santhosh29 8 Nov29 06
   

//-----------------------------------------------------------------------------
// Module29 Instantiations29
//-----------------------------------------------------------------------------


  ttc_interface_lite29 i_ttc_interface_lite29 ( 

    //inputs29
    .n_p_reset29                           (n_p_reset29),
    .pclk29                                (pclk29),
    .psel29                                (psel29),
    .penable29                             (penable29),
    .pwrite29                              (pwrite29),
    .paddr29                               (paddr29),
    .clk_ctrl_reg_129                      (clk_ctrl_reg_129),
    .clk_ctrl_reg_229                      (clk_ctrl_reg_229),
    .clk_ctrl_reg_329                      (clk_ctrl_reg_329),
    .cntr_ctrl_reg_129                     (cntr_ctrl_reg_129),
    .cntr_ctrl_reg_229                     (cntr_ctrl_reg_229),
    .cntr_ctrl_reg_329                     (cntr_ctrl_reg_329),
    .counter_val_reg_129                   (counter_val_reg_129),
    .counter_val_reg_229                   (counter_val_reg_229),
    .counter_val_reg_329                   (counter_val_reg_329),
    .interval_reg_129                      (interval_reg_129),
    .match_1_reg_129                       (match_1_reg_129),
    .match_2_reg_129                       (match_2_reg_129),
    .match_3_reg_129                       (match_3_reg_129),
    .interval_reg_229                      (interval_reg_229),
    .match_1_reg_229                       (match_1_reg_229),
    .match_2_reg_229                       (match_2_reg_229),
    .match_3_reg_229                       (match_3_reg_229),
    .interval_reg_329                      (interval_reg_329),
    .match_1_reg_329                       (match_1_reg_329),
    .match_2_reg_329                       (match_2_reg_329),
    .match_3_reg_329                       (match_3_reg_329),
    .interrupt_reg_129                     (interrupt_reg_129),
    .interrupt_reg_229                     (interrupt_reg_229),
    .interrupt_reg_329                     (interrupt_reg_329), 
    .interrupt_en_reg_129                  (interrupt_en_reg_129),
    .interrupt_en_reg_229                  (interrupt_en_reg_229),
    .interrupt_en_reg_329                  (interrupt_en_reg_329), 

    //outputs29
    .prdata29                              (prdata29),
    .clk_ctrl_reg_sel_129                  (clk_ctrl_reg_sel_129),
    .clk_ctrl_reg_sel_229                  (clk_ctrl_reg_sel_229),
    .clk_ctrl_reg_sel_329                  (clk_ctrl_reg_sel_329),
    .cntr_ctrl_reg_sel_129                 (cntr_ctrl_reg_sel_129),
    .cntr_ctrl_reg_sel_229                 (cntr_ctrl_reg_sel_229),
    .cntr_ctrl_reg_sel_329                 (cntr_ctrl_reg_sel_329),
    .interval_reg_sel_129                  (interval_reg_sel_129),  
    .interval_reg_sel_229                  (interval_reg_sel_229), 
    .interval_reg_sel_329                  (interval_reg_sel_329),
    .match_1_reg_sel_129                   (match_1_reg_sel_129),     
    .match_1_reg_sel_229                   (match_1_reg_sel_229),
    .match_1_reg_sel_329                   (match_1_reg_sel_329),                
    .match_2_reg_sel_129                   (match_2_reg_sel_129),
    .match_2_reg_sel_229                   (match_2_reg_sel_229),
    .match_2_reg_sel_329                   (match_2_reg_sel_329),
    .match_3_reg_sel_129                   (match_3_reg_sel_129),
    .match_3_reg_sel_229                   (match_3_reg_sel_229),
    .match_3_reg_sel_329                   (match_3_reg_sel_329),
    .intr_en_reg_sel29                     (intr_en_reg_sel29),
    .clear_interrupt29                     (clear_interrupt29)

  );


   

  ttc_timer_counter_lite29 i_ttc_timer_counter_lite_129 ( 

    //inputs29
    .n_p_reset29                           (n_p_reset29),
    .pclk29                                (pclk29), 
    .pwdata29                              (pwdata29[15:0]),
    .clk_ctrl_reg_sel29                    (clk_ctrl_reg_sel_129),
    .cntr_ctrl_reg_sel29                   (cntr_ctrl_reg_sel_129),
    .interval_reg_sel29                    (interval_reg_sel_129),
    .match_1_reg_sel29                     (match_1_reg_sel_129),
    .match_2_reg_sel29                     (match_2_reg_sel_129),
    .match_3_reg_sel29                     (match_3_reg_sel_129),
    .intr_en_reg_sel29                     (intr_en_reg_sel29[1]),
    .clear_interrupt29                     (clear_interrupt29[1]),
                                  
    //outputs29
    .clk_ctrl_reg29                        (clk_ctrl_reg_129),
    .counter_val_reg29                     (counter_val_reg_129),
    .cntr_ctrl_reg29                       (cntr_ctrl_reg_129),
    .interval_reg29                        (interval_reg_129),
    .match_1_reg29                         (match_1_reg_129),
    .match_2_reg29                         (match_2_reg_129),
    .match_3_reg29                         (match_3_reg_129),
    .interrupt29                           (TTC_int29[1]),
    .interrupt_reg29                       (interrupt_reg_129),
    .interrupt_en_reg29                    (interrupt_en_reg_129)
  );


  ttc_timer_counter_lite29 i_ttc_timer_counter_lite_229 ( 

    //inputs29
    .n_p_reset29                           (n_p_reset29), 
    .pclk29                                (pclk29),
    .pwdata29                              (pwdata29[15:0]),
    .clk_ctrl_reg_sel29                    (clk_ctrl_reg_sel_229),
    .cntr_ctrl_reg_sel29                   (cntr_ctrl_reg_sel_229),
    .interval_reg_sel29                    (interval_reg_sel_229),
    .match_1_reg_sel29                     (match_1_reg_sel_229),
    .match_2_reg_sel29                     (match_2_reg_sel_229),
    .match_3_reg_sel29                     (match_3_reg_sel_229),
    .intr_en_reg_sel29                     (intr_en_reg_sel29[2]),
    .clear_interrupt29                     (clear_interrupt29[2]),
                                  
    //outputs29
    .clk_ctrl_reg29                        (clk_ctrl_reg_229),
    .counter_val_reg29                     (counter_val_reg_229),
    .cntr_ctrl_reg29                       (cntr_ctrl_reg_229),
    .interval_reg29                        (interval_reg_229),
    .match_1_reg29                         (match_1_reg_229),
    .match_2_reg29                         (match_2_reg_229),
    .match_3_reg29                         (match_3_reg_229),
    .interrupt29                           (TTC_int29[2]),
    .interrupt_reg29                       (interrupt_reg_229),
    .interrupt_en_reg29                    (interrupt_en_reg_229)
  );



  ttc_timer_counter_lite29 i_ttc_timer_counter_lite_329 ( 

    //inputs29
    .n_p_reset29                           (n_p_reset29), 
    .pclk29                                (pclk29),
    .pwdata29                              (pwdata29[15:0]),
    .clk_ctrl_reg_sel29                    (clk_ctrl_reg_sel_329),
    .cntr_ctrl_reg_sel29                   (cntr_ctrl_reg_sel_329),
    .interval_reg_sel29                    (interval_reg_sel_329),
    .match_1_reg_sel29                     (match_1_reg_sel_329),
    .match_2_reg_sel29                     (match_2_reg_sel_329),
    .match_3_reg_sel29                     (match_3_reg_sel_329),
    .intr_en_reg_sel29                     (intr_en_reg_sel29[3]),
    .clear_interrupt29                     (clear_interrupt29[3]),
                                              
    //outputs29
    .clk_ctrl_reg29                        (clk_ctrl_reg_329),
    .counter_val_reg29                     (counter_val_reg_329),
    .cntr_ctrl_reg29                       (cntr_ctrl_reg_329),
    .interval_reg29                        (interval_reg_329),
    .match_1_reg29                         (match_1_reg_329),
    .match_2_reg29                         (match_2_reg_329),
    .match_3_reg29                         (match_3_reg_329),
    .interrupt29                           (TTC_int29[3]),
    .interrupt_reg29                       (interrupt_reg_329),
    .interrupt_en_reg29                    (interrupt_en_reg_329)
  );





endmodule 
