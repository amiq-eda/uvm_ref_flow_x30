//File6 name   : ttc_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : The top level of the Triple6 Timer6 Counter6.
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module6 definition6
//-----------------------------------------------------------------------------

module ttc_lite6(
           
           //inputs6
           n_p_reset6,
           pclk6,
           psel6,
           penable6,
           pwrite6,
           pwdata6,
           paddr6,
           scan_in6,
           scan_en6,

           //outputs6
           prdata6,
           interrupt6,
           scan_out6           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS6
//-----------------------------------------------------------------------------

   input         n_p_reset6;              //System6 Reset6
   input         pclk6;                 //System6 clock6
   input         psel6;                 //Select6 line
   input         penable6;              //Enable6
   input         pwrite6;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata6;               //Write data
   input [7:0]   paddr6;                //Address Bus6 register
   input         scan_in6;              //Scan6 chain6 input port
   input         scan_en6;              //Scan6 chain6 enable port
   
   output [31:0] prdata6;               //Read Data from the APB6 Interface6
   output [3:1]  interrupt6;            //Interrupt6 from PCI6 
   output        scan_out6;             //Scan6 chain6 output port

//-----------------------------------------------------------------------------
// Module6 Interconnect6
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int6;
   wire        clk_ctrl_reg_sel_16;     //Module6 1 clock6 control6 select6
   wire        clk_ctrl_reg_sel_26;     //Module6 2 clock6 control6 select6
   wire        clk_ctrl_reg_sel_36;     //Module6 3 clock6 control6 select6
   wire        cntr_ctrl_reg_sel_16;    //Module6 1 counter control6 select6
   wire        cntr_ctrl_reg_sel_26;    //Module6 2 counter control6 select6
   wire        cntr_ctrl_reg_sel_36;    //Module6 3 counter control6 select6
   wire        interval_reg_sel_16;     //Interval6 1 register select6
   wire        interval_reg_sel_26;     //Interval6 2 register select6
   wire        interval_reg_sel_36;     //Interval6 3 register select6
   wire        match_1_reg_sel_16;      //Module6 1 match 1 select6
   wire        match_1_reg_sel_26;      //Module6 1 match 2 select6
   wire        match_1_reg_sel_36;      //Module6 1 match 3 select6
   wire        match_2_reg_sel_16;      //Module6 2 match 1 select6
   wire        match_2_reg_sel_26;      //Module6 2 match 2 select6
   wire        match_2_reg_sel_36;      //Module6 2 match 3 select6
   wire        match_3_reg_sel_16;      //Module6 3 match 1 select6
   wire        match_3_reg_sel_26;      //Module6 3 match 2 select6
   wire        match_3_reg_sel_36;      //Module6 3 match 3 select6
   wire [3:1]  intr_en_reg_sel6;        //Interrupt6 enable register select6
   wire [3:1]  clear_interrupt6;        //Clear interrupt6 signal6
   wire [5:0]  interrupt_reg_16;        //Interrupt6 register 1
   wire [5:0]  interrupt_reg_26;        //Interrupt6 register 2
   wire [5:0]  interrupt_reg_36;        //Interrupt6 register 3 
   wire [5:0]  interrupt_en_reg_16;     //Interrupt6 enable register 1
   wire [5:0]  interrupt_en_reg_26;     //Interrupt6 enable register 2
   wire [5:0]  interrupt_en_reg_36;     //Interrupt6 enable register 3
   wire [6:0]  clk_ctrl_reg_16;         //Clock6 control6 regs for the 
   wire [6:0]  clk_ctrl_reg_26;         //Timer_Counter6 1,2,3
   wire [6:0]  clk_ctrl_reg_36;         //Value of the clock6 frequency6
   wire [15:0] counter_val_reg_16;      //Module6 1 counter value 
   wire [15:0] counter_val_reg_26;      //Module6 2 counter value 
   wire [15:0] counter_val_reg_36;      //Module6 3 counter value 
   wire [6:0]  cntr_ctrl_reg_16;        //Module6 1 counter control6  
   wire [6:0]  cntr_ctrl_reg_26;        //Module6 2 counter control6  
   wire [6:0]  cntr_ctrl_reg_36;        //Module6 3 counter control6  
   wire [15:0] interval_reg_16;         //Module6 1 interval6 register
   wire [15:0] interval_reg_26;         //Module6 2 interval6 register
   wire [15:0] interval_reg_36;         //Module6 3 interval6 register
   wire [15:0] match_1_reg_16;          //Module6 1 match 1 register
   wire [15:0] match_1_reg_26;          //Module6 1 match 2 register
   wire [15:0] match_1_reg_36;          //Module6 1 match 3 register
   wire [15:0] match_2_reg_16;          //Module6 2 match 1 register
   wire [15:0] match_2_reg_26;          //Module6 2 match 2 register
   wire [15:0] match_2_reg_36;          //Module6 2 match 3 register
   wire [15:0] match_3_reg_16;          //Module6 3 match 1 register
   wire [15:0] match_3_reg_26;          //Module6 3 match 2 register
   wire [15:0] match_3_reg_36;          //Module6 3 match 3 register

  assign interrupt6 = TTC_int6;   // Bug6 Fix6 for floating6 ints - Santhosh6 8 Nov6 06
   

//-----------------------------------------------------------------------------
// Module6 Instantiations6
//-----------------------------------------------------------------------------


  ttc_interface_lite6 i_ttc_interface_lite6 ( 

    //inputs6
    .n_p_reset6                           (n_p_reset6),
    .pclk6                                (pclk6),
    .psel6                                (psel6),
    .penable6                             (penable6),
    .pwrite6                              (pwrite6),
    .paddr6                               (paddr6),
    .clk_ctrl_reg_16                      (clk_ctrl_reg_16),
    .clk_ctrl_reg_26                      (clk_ctrl_reg_26),
    .clk_ctrl_reg_36                      (clk_ctrl_reg_36),
    .cntr_ctrl_reg_16                     (cntr_ctrl_reg_16),
    .cntr_ctrl_reg_26                     (cntr_ctrl_reg_26),
    .cntr_ctrl_reg_36                     (cntr_ctrl_reg_36),
    .counter_val_reg_16                   (counter_val_reg_16),
    .counter_val_reg_26                   (counter_val_reg_26),
    .counter_val_reg_36                   (counter_val_reg_36),
    .interval_reg_16                      (interval_reg_16),
    .match_1_reg_16                       (match_1_reg_16),
    .match_2_reg_16                       (match_2_reg_16),
    .match_3_reg_16                       (match_3_reg_16),
    .interval_reg_26                      (interval_reg_26),
    .match_1_reg_26                       (match_1_reg_26),
    .match_2_reg_26                       (match_2_reg_26),
    .match_3_reg_26                       (match_3_reg_26),
    .interval_reg_36                      (interval_reg_36),
    .match_1_reg_36                       (match_1_reg_36),
    .match_2_reg_36                       (match_2_reg_36),
    .match_3_reg_36                       (match_3_reg_36),
    .interrupt_reg_16                     (interrupt_reg_16),
    .interrupt_reg_26                     (interrupt_reg_26),
    .interrupt_reg_36                     (interrupt_reg_36), 
    .interrupt_en_reg_16                  (interrupt_en_reg_16),
    .interrupt_en_reg_26                  (interrupt_en_reg_26),
    .interrupt_en_reg_36                  (interrupt_en_reg_36), 

    //outputs6
    .prdata6                              (prdata6),
    .clk_ctrl_reg_sel_16                  (clk_ctrl_reg_sel_16),
    .clk_ctrl_reg_sel_26                  (clk_ctrl_reg_sel_26),
    .clk_ctrl_reg_sel_36                  (clk_ctrl_reg_sel_36),
    .cntr_ctrl_reg_sel_16                 (cntr_ctrl_reg_sel_16),
    .cntr_ctrl_reg_sel_26                 (cntr_ctrl_reg_sel_26),
    .cntr_ctrl_reg_sel_36                 (cntr_ctrl_reg_sel_36),
    .interval_reg_sel_16                  (interval_reg_sel_16),  
    .interval_reg_sel_26                  (interval_reg_sel_26), 
    .interval_reg_sel_36                  (interval_reg_sel_36),
    .match_1_reg_sel_16                   (match_1_reg_sel_16),     
    .match_1_reg_sel_26                   (match_1_reg_sel_26),
    .match_1_reg_sel_36                   (match_1_reg_sel_36),                
    .match_2_reg_sel_16                   (match_2_reg_sel_16),
    .match_2_reg_sel_26                   (match_2_reg_sel_26),
    .match_2_reg_sel_36                   (match_2_reg_sel_36),
    .match_3_reg_sel_16                   (match_3_reg_sel_16),
    .match_3_reg_sel_26                   (match_3_reg_sel_26),
    .match_3_reg_sel_36                   (match_3_reg_sel_36),
    .intr_en_reg_sel6                     (intr_en_reg_sel6),
    .clear_interrupt6                     (clear_interrupt6)

  );


   

  ttc_timer_counter_lite6 i_ttc_timer_counter_lite_16 ( 

    //inputs6
    .n_p_reset6                           (n_p_reset6),
    .pclk6                                (pclk6), 
    .pwdata6                              (pwdata6[15:0]),
    .clk_ctrl_reg_sel6                    (clk_ctrl_reg_sel_16),
    .cntr_ctrl_reg_sel6                   (cntr_ctrl_reg_sel_16),
    .interval_reg_sel6                    (interval_reg_sel_16),
    .match_1_reg_sel6                     (match_1_reg_sel_16),
    .match_2_reg_sel6                     (match_2_reg_sel_16),
    .match_3_reg_sel6                     (match_3_reg_sel_16),
    .intr_en_reg_sel6                     (intr_en_reg_sel6[1]),
    .clear_interrupt6                     (clear_interrupt6[1]),
                                  
    //outputs6
    .clk_ctrl_reg6                        (clk_ctrl_reg_16),
    .counter_val_reg6                     (counter_val_reg_16),
    .cntr_ctrl_reg6                       (cntr_ctrl_reg_16),
    .interval_reg6                        (interval_reg_16),
    .match_1_reg6                         (match_1_reg_16),
    .match_2_reg6                         (match_2_reg_16),
    .match_3_reg6                         (match_3_reg_16),
    .interrupt6                           (TTC_int6[1]),
    .interrupt_reg6                       (interrupt_reg_16),
    .interrupt_en_reg6                    (interrupt_en_reg_16)
  );


  ttc_timer_counter_lite6 i_ttc_timer_counter_lite_26 ( 

    //inputs6
    .n_p_reset6                           (n_p_reset6), 
    .pclk6                                (pclk6),
    .pwdata6                              (pwdata6[15:0]),
    .clk_ctrl_reg_sel6                    (clk_ctrl_reg_sel_26),
    .cntr_ctrl_reg_sel6                   (cntr_ctrl_reg_sel_26),
    .interval_reg_sel6                    (interval_reg_sel_26),
    .match_1_reg_sel6                     (match_1_reg_sel_26),
    .match_2_reg_sel6                     (match_2_reg_sel_26),
    .match_3_reg_sel6                     (match_3_reg_sel_26),
    .intr_en_reg_sel6                     (intr_en_reg_sel6[2]),
    .clear_interrupt6                     (clear_interrupt6[2]),
                                  
    //outputs6
    .clk_ctrl_reg6                        (clk_ctrl_reg_26),
    .counter_val_reg6                     (counter_val_reg_26),
    .cntr_ctrl_reg6                       (cntr_ctrl_reg_26),
    .interval_reg6                        (interval_reg_26),
    .match_1_reg6                         (match_1_reg_26),
    .match_2_reg6                         (match_2_reg_26),
    .match_3_reg6                         (match_3_reg_26),
    .interrupt6                           (TTC_int6[2]),
    .interrupt_reg6                       (interrupt_reg_26),
    .interrupt_en_reg6                    (interrupt_en_reg_26)
  );



  ttc_timer_counter_lite6 i_ttc_timer_counter_lite_36 ( 

    //inputs6
    .n_p_reset6                           (n_p_reset6), 
    .pclk6                                (pclk6),
    .pwdata6                              (pwdata6[15:0]),
    .clk_ctrl_reg_sel6                    (clk_ctrl_reg_sel_36),
    .cntr_ctrl_reg_sel6                   (cntr_ctrl_reg_sel_36),
    .interval_reg_sel6                    (interval_reg_sel_36),
    .match_1_reg_sel6                     (match_1_reg_sel_36),
    .match_2_reg_sel6                     (match_2_reg_sel_36),
    .match_3_reg_sel6                     (match_3_reg_sel_36),
    .intr_en_reg_sel6                     (intr_en_reg_sel6[3]),
    .clear_interrupt6                     (clear_interrupt6[3]),
                                              
    //outputs6
    .clk_ctrl_reg6                        (clk_ctrl_reg_36),
    .counter_val_reg6                     (counter_val_reg_36),
    .cntr_ctrl_reg6                       (cntr_ctrl_reg_36),
    .interval_reg6                        (interval_reg_36),
    .match_1_reg6                         (match_1_reg_36),
    .match_2_reg6                         (match_2_reg_36),
    .match_3_reg6                         (match_3_reg_36),
    .interrupt6                           (TTC_int6[3]),
    .interrupt_reg6                       (interrupt_reg_36),
    .interrupt_en_reg6                    (interrupt_en_reg_36)
  );





endmodule 
