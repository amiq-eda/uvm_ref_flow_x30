//File15 name   : ttc_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : The top level of the Triple15 Timer15 Counter15.
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module15 definition15
//-----------------------------------------------------------------------------

module ttc_lite15(
           
           //inputs15
           n_p_reset15,
           pclk15,
           psel15,
           penable15,
           pwrite15,
           pwdata15,
           paddr15,
           scan_in15,
           scan_en15,

           //outputs15
           prdata15,
           interrupt15,
           scan_out15           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS15
//-----------------------------------------------------------------------------

   input         n_p_reset15;              //System15 Reset15
   input         pclk15;                 //System15 clock15
   input         psel15;                 //Select15 line
   input         penable15;              //Enable15
   input         pwrite15;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata15;               //Write data
   input [7:0]   paddr15;                //Address Bus15 register
   input         scan_in15;              //Scan15 chain15 input port
   input         scan_en15;              //Scan15 chain15 enable port
   
   output [31:0] prdata15;               //Read Data from the APB15 Interface15
   output [3:1]  interrupt15;            //Interrupt15 from PCI15 
   output        scan_out15;             //Scan15 chain15 output port

//-----------------------------------------------------------------------------
// Module15 Interconnect15
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int15;
   wire        clk_ctrl_reg_sel_115;     //Module15 1 clock15 control15 select15
   wire        clk_ctrl_reg_sel_215;     //Module15 2 clock15 control15 select15
   wire        clk_ctrl_reg_sel_315;     //Module15 3 clock15 control15 select15
   wire        cntr_ctrl_reg_sel_115;    //Module15 1 counter control15 select15
   wire        cntr_ctrl_reg_sel_215;    //Module15 2 counter control15 select15
   wire        cntr_ctrl_reg_sel_315;    //Module15 3 counter control15 select15
   wire        interval_reg_sel_115;     //Interval15 1 register select15
   wire        interval_reg_sel_215;     //Interval15 2 register select15
   wire        interval_reg_sel_315;     //Interval15 3 register select15
   wire        match_1_reg_sel_115;      //Module15 1 match 1 select15
   wire        match_1_reg_sel_215;      //Module15 1 match 2 select15
   wire        match_1_reg_sel_315;      //Module15 1 match 3 select15
   wire        match_2_reg_sel_115;      //Module15 2 match 1 select15
   wire        match_2_reg_sel_215;      //Module15 2 match 2 select15
   wire        match_2_reg_sel_315;      //Module15 2 match 3 select15
   wire        match_3_reg_sel_115;      //Module15 3 match 1 select15
   wire        match_3_reg_sel_215;      //Module15 3 match 2 select15
   wire        match_3_reg_sel_315;      //Module15 3 match 3 select15
   wire [3:1]  intr_en_reg_sel15;        //Interrupt15 enable register select15
   wire [3:1]  clear_interrupt15;        //Clear interrupt15 signal15
   wire [5:0]  interrupt_reg_115;        //Interrupt15 register 1
   wire [5:0]  interrupt_reg_215;        //Interrupt15 register 2
   wire [5:0]  interrupt_reg_315;        //Interrupt15 register 3 
   wire [5:0]  interrupt_en_reg_115;     //Interrupt15 enable register 1
   wire [5:0]  interrupt_en_reg_215;     //Interrupt15 enable register 2
   wire [5:0]  interrupt_en_reg_315;     //Interrupt15 enable register 3
   wire [6:0]  clk_ctrl_reg_115;         //Clock15 control15 regs for the 
   wire [6:0]  clk_ctrl_reg_215;         //Timer_Counter15 1,2,3
   wire [6:0]  clk_ctrl_reg_315;         //Value of the clock15 frequency15
   wire [15:0] counter_val_reg_115;      //Module15 1 counter value 
   wire [15:0] counter_val_reg_215;      //Module15 2 counter value 
   wire [15:0] counter_val_reg_315;      //Module15 3 counter value 
   wire [6:0]  cntr_ctrl_reg_115;        //Module15 1 counter control15  
   wire [6:0]  cntr_ctrl_reg_215;        //Module15 2 counter control15  
   wire [6:0]  cntr_ctrl_reg_315;        //Module15 3 counter control15  
   wire [15:0] interval_reg_115;         //Module15 1 interval15 register
   wire [15:0] interval_reg_215;         //Module15 2 interval15 register
   wire [15:0] interval_reg_315;         //Module15 3 interval15 register
   wire [15:0] match_1_reg_115;          //Module15 1 match 1 register
   wire [15:0] match_1_reg_215;          //Module15 1 match 2 register
   wire [15:0] match_1_reg_315;          //Module15 1 match 3 register
   wire [15:0] match_2_reg_115;          //Module15 2 match 1 register
   wire [15:0] match_2_reg_215;          //Module15 2 match 2 register
   wire [15:0] match_2_reg_315;          //Module15 2 match 3 register
   wire [15:0] match_3_reg_115;          //Module15 3 match 1 register
   wire [15:0] match_3_reg_215;          //Module15 3 match 2 register
   wire [15:0] match_3_reg_315;          //Module15 3 match 3 register

  assign interrupt15 = TTC_int15;   // Bug15 Fix15 for floating15 ints - Santhosh15 8 Nov15 06
   

//-----------------------------------------------------------------------------
// Module15 Instantiations15
//-----------------------------------------------------------------------------


  ttc_interface_lite15 i_ttc_interface_lite15 ( 

    //inputs15
    .n_p_reset15                           (n_p_reset15),
    .pclk15                                (pclk15),
    .psel15                                (psel15),
    .penable15                             (penable15),
    .pwrite15                              (pwrite15),
    .paddr15                               (paddr15),
    .clk_ctrl_reg_115                      (clk_ctrl_reg_115),
    .clk_ctrl_reg_215                      (clk_ctrl_reg_215),
    .clk_ctrl_reg_315                      (clk_ctrl_reg_315),
    .cntr_ctrl_reg_115                     (cntr_ctrl_reg_115),
    .cntr_ctrl_reg_215                     (cntr_ctrl_reg_215),
    .cntr_ctrl_reg_315                     (cntr_ctrl_reg_315),
    .counter_val_reg_115                   (counter_val_reg_115),
    .counter_val_reg_215                   (counter_val_reg_215),
    .counter_val_reg_315                   (counter_val_reg_315),
    .interval_reg_115                      (interval_reg_115),
    .match_1_reg_115                       (match_1_reg_115),
    .match_2_reg_115                       (match_2_reg_115),
    .match_3_reg_115                       (match_3_reg_115),
    .interval_reg_215                      (interval_reg_215),
    .match_1_reg_215                       (match_1_reg_215),
    .match_2_reg_215                       (match_2_reg_215),
    .match_3_reg_215                       (match_3_reg_215),
    .interval_reg_315                      (interval_reg_315),
    .match_1_reg_315                       (match_1_reg_315),
    .match_2_reg_315                       (match_2_reg_315),
    .match_3_reg_315                       (match_3_reg_315),
    .interrupt_reg_115                     (interrupt_reg_115),
    .interrupt_reg_215                     (interrupt_reg_215),
    .interrupt_reg_315                     (interrupt_reg_315), 
    .interrupt_en_reg_115                  (interrupt_en_reg_115),
    .interrupt_en_reg_215                  (interrupt_en_reg_215),
    .interrupt_en_reg_315                  (interrupt_en_reg_315), 

    //outputs15
    .prdata15                              (prdata15),
    .clk_ctrl_reg_sel_115                  (clk_ctrl_reg_sel_115),
    .clk_ctrl_reg_sel_215                  (clk_ctrl_reg_sel_215),
    .clk_ctrl_reg_sel_315                  (clk_ctrl_reg_sel_315),
    .cntr_ctrl_reg_sel_115                 (cntr_ctrl_reg_sel_115),
    .cntr_ctrl_reg_sel_215                 (cntr_ctrl_reg_sel_215),
    .cntr_ctrl_reg_sel_315                 (cntr_ctrl_reg_sel_315),
    .interval_reg_sel_115                  (interval_reg_sel_115),  
    .interval_reg_sel_215                  (interval_reg_sel_215), 
    .interval_reg_sel_315                  (interval_reg_sel_315),
    .match_1_reg_sel_115                   (match_1_reg_sel_115),     
    .match_1_reg_sel_215                   (match_1_reg_sel_215),
    .match_1_reg_sel_315                   (match_1_reg_sel_315),                
    .match_2_reg_sel_115                   (match_2_reg_sel_115),
    .match_2_reg_sel_215                   (match_2_reg_sel_215),
    .match_2_reg_sel_315                   (match_2_reg_sel_315),
    .match_3_reg_sel_115                   (match_3_reg_sel_115),
    .match_3_reg_sel_215                   (match_3_reg_sel_215),
    .match_3_reg_sel_315                   (match_3_reg_sel_315),
    .intr_en_reg_sel15                     (intr_en_reg_sel15),
    .clear_interrupt15                     (clear_interrupt15)

  );


   

  ttc_timer_counter_lite15 i_ttc_timer_counter_lite_115 ( 

    //inputs15
    .n_p_reset15                           (n_p_reset15),
    .pclk15                                (pclk15), 
    .pwdata15                              (pwdata15[15:0]),
    .clk_ctrl_reg_sel15                    (clk_ctrl_reg_sel_115),
    .cntr_ctrl_reg_sel15                   (cntr_ctrl_reg_sel_115),
    .interval_reg_sel15                    (interval_reg_sel_115),
    .match_1_reg_sel15                     (match_1_reg_sel_115),
    .match_2_reg_sel15                     (match_2_reg_sel_115),
    .match_3_reg_sel15                     (match_3_reg_sel_115),
    .intr_en_reg_sel15                     (intr_en_reg_sel15[1]),
    .clear_interrupt15                     (clear_interrupt15[1]),
                                  
    //outputs15
    .clk_ctrl_reg15                        (clk_ctrl_reg_115),
    .counter_val_reg15                     (counter_val_reg_115),
    .cntr_ctrl_reg15                       (cntr_ctrl_reg_115),
    .interval_reg15                        (interval_reg_115),
    .match_1_reg15                         (match_1_reg_115),
    .match_2_reg15                         (match_2_reg_115),
    .match_3_reg15                         (match_3_reg_115),
    .interrupt15                           (TTC_int15[1]),
    .interrupt_reg15                       (interrupt_reg_115),
    .interrupt_en_reg15                    (interrupt_en_reg_115)
  );


  ttc_timer_counter_lite15 i_ttc_timer_counter_lite_215 ( 

    //inputs15
    .n_p_reset15                           (n_p_reset15), 
    .pclk15                                (pclk15),
    .pwdata15                              (pwdata15[15:0]),
    .clk_ctrl_reg_sel15                    (clk_ctrl_reg_sel_215),
    .cntr_ctrl_reg_sel15                   (cntr_ctrl_reg_sel_215),
    .interval_reg_sel15                    (interval_reg_sel_215),
    .match_1_reg_sel15                     (match_1_reg_sel_215),
    .match_2_reg_sel15                     (match_2_reg_sel_215),
    .match_3_reg_sel15                     (match_3_reg_sel_215),
    .intr_en_reg_sel15                     (intr_en_reg_sel15[2]),
    .clear_interrupt15                     (clear_interrupt15[2]),
                                  
    //outputs15
    .clk_ctrl_reg15                        (clk_ctrl_reg_215),
    .counter_val_reg15                     (counter_val_reg_215),
    .cntr_ctrl_reg15                       (cntr_ctrl_reg_215),
    .interval_reg15                        (interval_reg_215),
    .match_1_reg15                         (match_1_reg_215),
    .match_2_reg15                         (match_2_reg_215),
    .match_3_reg15                         (match_3_reg_215),
    .interrupt15                           (TTC_int15[2]),
    .interrupt_reg15                       (interrupt_reg_215),
    .interrupt_en_reg15                    (interrupt_en_reg_215)
  );



  ttc_timer_counter_lite15 i_ttc_timer_counter_lite_315 ( 

    //inputs15
    .n_p_reset15                           (n_p_reset15), 
    .pclk15                                (pclk15),
    .pwdata15                              (pwdata15[15:0]),
    .clk_ctrl_reg_sel15                    (clk_ctrl_reg_sel_315),
    .cntr_ctrl_reg_sel15                   (cntr_ctrl_reg_sel_315),
    .interval_reg_sel15                    (interval_reg_sel_315),
    .match_1_reg_sel15                     (match_1_reg_sel_315),
    .match_2_reg_sel15                     (match_2_reg_sel_315),
    .match_3_reg_sel15                     (match_3_reg_sel_315),
    .intr_en_reg_sel15                     (intr_en_reg_sel15[3]),
    .clear_interrupt15                     (clear_interrupt15[3]),
                                              
    //outputs15
    .clk_ctrl_reg15                        (clk_ctrl_reg_315),
    .counter_val_reg15                     (counter_val_reg_315),
    .cntr_ctrl_reg15                       (cntr_ctrl_reg_315),
    .interval_reg15                        (interval_reg_315),
    .match_1_reg15                         (match_1_reg_315),
    .match_2_reg15                         (match_2_reg_315),
    .match_3_reg15                         (match_3_reg_315),
    .interrupt15                           (TTC_int15[3]),
    .interrupt_reg15                       (interrupt_reg_315),
    .interrupt_en_reg15                    (interrupt_en_reg_315)
  );





endmodule 
