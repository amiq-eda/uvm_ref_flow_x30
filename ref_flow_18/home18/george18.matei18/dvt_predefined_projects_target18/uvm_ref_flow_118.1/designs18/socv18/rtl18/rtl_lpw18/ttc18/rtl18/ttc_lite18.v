//File18 name   : ttc_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : The top level of the Triple18 Timer18 Counter18.
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module18 definition18
//-----------------------------------------------------------------------------

module ttc_lite18(
           
           //inputs18
           n_p_reset18,
           pclk18,
           psel18,
           penable18,
           pwrite18,
           pwdata18,
           paddr18,
           scan_in18,
           scan_en18,

           //outputs18
           prdata18,
           interrupt18,
           scan_out18           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS18
//-----------------------------------------------------------------------------

   input         n_p_reset18;              //System18 Reset18
   input         pclk18;                 //System18 clock18
   input         psel18;                 //Select18 line
   input         penable18;              //Enable18
   input         pwrite18;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata18;               //Write data
   input [7:0]   paddr18;                //Address Bus18 register
   input         scan_in18;              //Scan18 chain18 input port
   input         scan_en18;              //Scan18 chain18 enable port
   
   output [31:0] prdata18;               //Read Data from the APB18 Interface18
   output [3:1]  interrupt18;            //Interrupt18 from PCI18 
   output        scan_out18;             //Scan18 chain18 output port

//-----------------------------------------------------------------------------
// Module18 Interconnect18
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int18;
   wire        clk_ctrl_reg_sel_118;     //Module18 1 clock18 control18 select18
   wire        clk_ctrl_reg_sel_218;     //Module18 2 clock18 control18 select18
   wire        clk_ctrl_reg_sel_318;     //Module18 3 clock18 control18 select18
   wire        cntr_ctrl_reg_sel_118;    //Module18 1 counter control18 select18
   wire        cntr_ctrl_reg_sel_218;    //Module18 2 counter control18 select18
   wire        cntr_ctrl_reg_sel_318;    //Module18 3 counter control18 select18
   wire        interval_reg_sel_118;     //Interval18 1 register select18
   wire        interval_reg_sel_218;     //Interval18 2 register select18
   wire        interval_reg_sel_318;     //Interval18 3 register select18
   wire        match_1_reg_sel_118;      //Module18 1 match 1 select18
   wire        match_1_reg_sel_218;      //Module18 1 match 2 select18
   wire        match_1_reg_sel_318;      //Module18 1 match 3 select18
   wire        match_2_reg_sel_118;      //Module18 2 match 1 select18
   wire        match_2_reg_sel_218;      //Module18 2 match 2 select18
   wire        match_2_reg_sel_318;      //Module18 2 match 3 select18
   wire        match_3_reg_sel_118;      //Module18 3 match 1 select18
   wire        match_3_reg_sel_218;      //Module18 3 match 2 select18
   wire        match_3_reg_sel_318;      //Module18 3 match 3 select18
   wire [3:1]  intr_en_reg_sel18;        //Interrupt18 enable register select18
   wire [3:1]  clear_interrupt18;        //Clear interrupt18 signal18
   wire [5:0]  interrupt_reg_118;        //Interrupt18 register 1
   wire [5:0]  interrupt_reg_218;        //Interrupt18 register 2
   wire [5:0]  interrupt_reg_318;        //Interrupt18 register 3 
   wire [5:0]  interrupt_en_reg_118;     //Interrupt18 enable register 1
   wire [5:0]  interrupt_en_reg_218;     //Interrupt18 enable register 2
   wire [5:0]  interrupt_en_reg_318;     //Interrupt18 enable register 3
   wire [6:0]  clk_ctrl_reg_118;         //Clock18 control18 regs for the 
   wire [6:0]  clk_ctrl_reg_218;         //Timer_Counter18 1,2,3
   wire [6:0]  clk_ctrl_reg_318;         //Value of the clock18 frequency18
   wire [15:0] counter_val_reg_118;      //Module18 1 counter value 
   wire [15:0] counter_val_reg_218;      //Module18 2 counter value 
   wire [15:0] counter_val_reg_318;      //Module18 3 counter value 
   wire [6:0]  cntr_ctrl_reg_118;        //Module18 1 counter control18  
   wire [6:0]  cntr_ctrl_reg_218;        //Module18 2 counter control18  
   wire [6:0]  cntr_ctrl_reg_318;        //Module18 3 counter control18  
   wire [15:0] interval_reg_118;         //Module18 1 interval18 register
   wire [15:0] interval_reg_218;         //Module18 2 interval18 register
   wire [15:0] interval_reg_318;         //Module18 3 interval18 register
   wire [15:0] match_1_reg_118;          //Module18 1 match 1 register
   wire [15:0] match_1_reg_218;          //Module18 1 match 2 register
   wire [15:0] match_1_reg_318;          //Module18 1 match 3 register
   wire [15:0] match_2_reg_118;          //Module18 2 match 1 register
   wire [15:0] match_2_reg_218;          //Module18 2 match 2 register
   wire [15:0] match_2_reg_318;          //Module18 2 match 3 register
   wire [15:0] match_3_reg_118;          //Module18 3 match 1 register
   wire [15:0] match_3_reg_218;          //Module18 3 match 2 register
   wire [15:0] match_3_reg_318;          //Module18 3 match 3 register

  assign interrupt18 = TTC_int18;   // Bug18 Fix18 for floating18 ints - Santhosh18 8 Nov18 06
   

//-----------------------------------------------------------------------------
// Module18 Instantiations18
//-----------------------------------------------------------------------------


  ttc_interface_lite18 i_ttc_interface_lite18 ( 

    //inputs18
    .n_p_reset18                           (n_p_reset18),
    .pclk18                                (pclk18),
    .psel18                                (psel18),
    .penable18                             (penable18),
    .pwrite18                              (pwrite18),
    .paddr18                               (paddr18),
    .clk_ctrl_reg_118                      (clk_ctrl_reg_118),
    .clk_ctrl_reg_218                      (clk_ctrl_reg_218),
    .clk_ctrl_reg_318                      (clk_ctrl_reg_318),
    .cntr_ctrl_reg_118                     (cntr_ctrl_reg_118),
    .cntr_ctrl_reg_218                     (cntr_ctrl_reg_218),
    .cntr_ctrl_reg_318                     (cntr_ctrl_reg_318),
    .counter_val_reg_118                   (counter_val_reg_118),
    .counter_val_reg_218                   (counter_val_reg_218),
    .counter_val_reg_318                   (counter_val_reg_318),
    .interval_reg_118                      (interval_reg_118),
    .match_1_reg_118                       (match_1_reg_118),
    .match_2_reg_118                       (match_2_reg_118),
    .match_3_reg_118                       (match_3_reg_118),
    .interval_reg_218                      (interval_reg_218),
    .match_1_reg_218                       (match_1_reg_218),
    .match_2_reg_218                       (match_2_reg_218),
    .match_3_reg_218                       (match_3_reg_218),
    .interval_reg_318                      (interval_reg_318),
    .match_1_reg_318                       (match_1_reg_318),
    .match_2_reg_318                       (match_2_reg_318),
    .match_3_reg_318                       (match_3_reg_318),
    .interrupt_reg_118                     (interrupt_reg_118),
    .interrupt_reg_218                     (interrupt_reg_218),
    .interrupt_reg_318                     (interrupt_reg_318), 
    .interrupt_en_reg_118                  (interrupt_en_reg_118),
    .interrupt_en_reg_218                  (interrupt_en_reg_218),
    .interrupt_en_reg_318                  (interrupt_en_reg_318), 

    //outputs18
    .prdata18                              (prdata18),
    .clk_ctrl_reg_sel_118                  (clk_ctrl_reg_sel_118),
    .clk_ctrl_reg_sel_218                  (clk_ctrl_reg_sel_218),
    .clk_ctrl_reg_sel_318                  (clk_ctrl_reg_sel_318),
    .cntr_ctrl_reg_sel_118                 (cntr_ctrl_reg_sel_118),
    .cntr_ctrl_reg_sel_218                 (cntr_ctrl_reg_sel_218),
    .cntr_ctrl_reg_sel_318                 (cntr_ctrl_reg_sel_318),
    .interval_reg_sel_118                  (interval_reg_sel_118),  
    .interval_reg_sel_218                  (interval_reg_sel_218), 
    .interval_reg_sel_318                  (interval_reg_sel_318),
    .match_1_reg_sel_118                   (match_1_reg_sel_118),     
    .match_1_reg_sel_218                   (match_1_reg_sel_218),
    .match_1_reg_sel_318                   (match_1_reg_sel_318),                
    .match_2_reg_sel_118                   (match_2_reg_sel_118),
    .match_2_reg_sel_218                   (match_2_reg_sel_218),
    .match_2_reg_sel_318                   (match_2_reg_sel_318),
    .match_3_reg_sel_118                   (match_3_reg_sel_118),
    .match_3_reg_sel_218                   (match_3_reg_sel_218),
    .match_3_reg_sel_318                   (match_3_reg_sel_318),
    .intr_en_reg_sel18                     (intr_en_reg_sel18),
    .clear_interrupt18                     (clear_interrupt18)

  );


   

  ttc_timer_counter_lite18 i_ttc_timer_counter_lite_118 ( 

    //inputs18
    .n_p_reset18                           (n_p_reset18),
    .pclk18                                (pclk18), 
    .pwdata18                              (pwdata18[15:0]),
    .clk_ctrl_reg_sel18                    (clk_ctrl_reg_sel_118),
    .cntr_ctrl_reg_sel18                   (cntr_ctrl_reg_sel_118),
    .interval_reg_sel18                    (interval_reg_sel_118),
    .match_1_reg_sel18                     (match_1_reg_sel_118),
    .match_2_reg_sel18                     (match_2_reg_sel_118),
    .match_3_reg_sel18                     (match_3_reg_sel_118),
    .intr_en_reg_sel18                     (intr_en_reg_sel18[1]),
    .clear_interrupt18                     (clear_interrupt18[1]),
                                  
    //outputs18
    .clk_ctrl_reg18                        (clk_ctrl_reg_118),
    .counter_val_reg18                     (counter_val_reg_118),
    .cntr_ctrl_reg18                       (cntr_ctrl_reg_118),
    .interval_reg18                        (interval_reg_118),
    .match_1_reg18                         (match_1_reg_118),
    .match_2_reg18                         (match_2_reg_118),
    .match_3_reg18                         (match_3_reg_118),
    .interrupt18                           (TTC_int18[1]),
    .interrupt_reg18                       (interrupt_reg_118),
    .interrupt_en_reg18                    (interrupt_en_reg_118)
  );


  ttc_timer_counter_lite18 i_ttc_timer_counter_lite_218 ( 

    //inputs18
    .n_p_reset18                           (n_p_reset18), 
    .pclk18                                (pclk18),
    .pwdata18                              (pwdata18[15:0]),
    .clk_ctrl_reg_sel18                    (clk_ctrl_reg_sel_218),
    .cntr_ctrl_reg_sel18                   (cntr_ctrl_reg_sel_218),
    .interval_reg_sel18                    (interval_reg_sel_218),
    .match_1_reg_sel18                     (match_1_reg_sel_218),
    .match_2_reg_sel18                     (match_2_reg_sel_218),
    .match_3_reg_sel18                     (match_3_reg_sel_218),
    .intr_en_reg_sel18                     (intr_en_reg_sel18[2]),
    .clear_interrupt18                     (clear_interrupt18[2]),
                                  
    //outputs18
    .clk_ctrl_reg18                        (clk_ctrl_reg_218),
    .counter_val_reg18                     (counter_val_reg_218),
    .cntr_ctrl_reg18                       (cntr_ctrl_reg_218),
    .interval_reg18                        (interval_reg_218),
    .match_1_reg18                         (match_1_reg_218),
    .match_2_reg18                         (match_2_reg_218),
    .match_3_reg18                         (match_3_reg_218),
    .interrupt18                           (TTC_int18[2]),
    .interrupt_reg18                       (interrupt_reg_218),
    .interrupt_en_reg18                    (interrupt_en_reg_218)
  );



  ttc_timer_counter_lite18 i_ttc_timer_counter_lite_318 ( 

    //inputs18
    .n_p_reset18                           (n_p_reset18), 
    .pclk18                                (pclk18),
    .pwdata18                              (pwdata18[15:0]),
    .clk_ctrl_reg_sel18                    (clk_ctrl_reg_sel_318),
    .cntr_ctrl_reg_sel18                   (cntr_ctrl_reg_sel_318),
    .interval_reg_sel18                    (interval_reg_sel_318),
    .match_1_reg_sel18                     (match_1_reg_sel_318),
    .match_2_reg_sel18                     (match_2_reg_sel_318),
    .match_3_reg_sel18                     (match_3_reg_sel_318),
    .intr_en_reg_sel18                     (intr_en_reg_sel18[3]),
    .clear_interrupt18                     (clear_interrupt18[3]),
                                              
    //outputs18
    .clk_ctrl_reg18                        (clk_ctrl_reg_318),
    .counter_val_reg18                     (counter_val_reg_318),
    .cntr_ctrl_reg18                       (cntr_ctrl_reg_318),
    .interval_reg18                        (interval_reg_318),
    .match_1_reg18                         (match_1_reg_318),
    .match_2_reg18                         (match_2_reg_318),
    .match_3_reg18                         (match_3_reg_318),
    .interrupt18                           (TTC_int18[3]),
    .interrupt_reg18                       (interrupt_reg_318),
    .interrupt_en_reg18                    (interrupt_en_reg_318)
  );





endmodule 
