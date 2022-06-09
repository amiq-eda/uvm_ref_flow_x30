//File8 name   : ttc_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : The top level of the Triple8 Timer8 Counter8.
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module8 definition8
//-----------------------------------------------------------------------------

module ttc_lite8(
           
           //inputs8
           n_p_reset8,
           pclk8,
           psel8,
           penable8,
           pwrite8,
           pwdata8,
           paddr8,
           scan_in8,
           scan_en8,

           //outputs8
           prdata8,
           interrupt8,
           scan_out8           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS8
//-----------------------------------------------------------------------------

   input         n_p_reset8;              //System8 Reset8
   input         pclk8;                 //System8 clock8
   input         psel8;                 //Select8 line
   input         penable8;              //Enable8
   input         pwrite8;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata8;               //Write data
   input [7:0]   paddr8;                //Address Bus8 register
   input         scan_in8;              //Scan8 chain8 input port
   input         scan_en8;              //Scan8 chain8 enable port
   
   output [31:0] prdata8;               //Read Data from the APB8 Interface8
   output [3:1]  interrupt8;            //Interrupt8 from PCI8 
   output        scan_out8;             //Scan8 chain8 output port

//-----------------------------------------------------------------------------
// Module8 Interconnect8
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int8;
   wire        clk_ctrl_reg_sel_18;     //Module8 1 clock8 control8 select8
   wire        clk_ctrl_reg_sel_28;     //Module8 2 clock8 control8 select8
   wire        clk_ctrl_reg_sel_38;     //Module8 3 clock8 control8 select8
   wire        cntr_ctrl_reg_sel_18;    //Module8 1 counter control8 select8
   wire        cntr_ctrl_reg_sel_28;    //Module8 2 counter control8 select8
   wire        cntr_ctrl_reg_sel_38;    //Module8 3 counter control8 select8
   wire        interval_reg_sel_18;     //Interval8 1 register select8
   wire        interval_reg_sel_28;     //Interval8 2 register select8
   wire        interval_reg_sel_38;     //Interval8 3 register select8
   wire        match_1_reg_sel_18;      //Module8 1 match 1 select8
   wire        match_1_reg_sel_28;      //Module8 1 match 2 select8
   wire        match_1_reg_sel_38;      //Module8 1 match 3 select8
   wire        match_2_reg_sel_18;      //Module8 2 match 1 select8
   wire        match_2_reg_sel_28;      //Module8 2 match 2 select8
   wire        match_2_reg_sel_38;      //Module8 2 match 3 select8
   wire        match_3_reg_sel_18;      //Module8 3 match 1 select8
   wire        match_3_reg_sel_28;      //Module8 3 match 2 select8
   wire        match_3_reg_sel_38;      //Module8 3 match 3 select8
   wire [3:1]  intr_en_reg_sel8;        //Interrupt8 enable register select8
   wire [3:1]  clear_interrupt8;        //Clear interrupt8 signal8
   wire [5:0]  interrupt_reg_18;        //Interrupt8 register 1
   wire [5:0]  interrupt_reg_28;        //Interrupt8 register 2
   wire [5:0]  interrupt_reg_38;        //Interrupt8 register 3 
   wire [5:0]  interrupt_en_reg_18;     //Interrupt8 enable register 1
   wire [5:0]  interrupt_en_reg_28;     //Interrupt8 enable register 2
   wire [5:0]  interrupt_en_reg_38;     //Interrupt8 enable register 3
   wire [6:0]  clk_ctrl_reg_18;         //Clock8 control8 regs for the 
   wire [6:0]  clk_ctrl_reg_28;         //Timer_Counter8 1,2,3
   wire [6:0]  clk_ctrl_reg_38;         //Value of the clock8 frequency8
   wire [15:0] counter_val_reg_18;      //Module8 1 counter value 
   wire [15:0] counter_val_reg_28;      //Module8 2 counter value 
   wire [15:0] counter_val_reg_38;      //Module8 3 counter value 
   wire [6:0]  cntr_ctrl_reg_18;        //Module8 1 counter control8  
   wire [6:0]  cntr_ctrl_reg_28;        //Module8 2 counter control8  
   wire [6:0]  cntr_ctrl_reg_38;        //Module8 3 counter control8  
   wire [15:0] interval_reg_18;         //Module8 1 interval8 register
   wire [15:0] interval_reg_28;         //Module8 2 interval8 register
   wire [15:0] interval_reg_38;         //Module8 3 interval8 register
   wire [15:0] match_1_reg_18;          //Module8 1 match 1 register
   wire [15:0] match_1_reg_28;          //Module8 1 match 2 register
   wire [15:0] match_1_reg_38;          //Module8 1 match 3 register
   wire [15:0] match_2_reg_18;          //Module8 2 match 1 register
   wire [15:0] match_2_reg_28;          //Module8 2 match 2 register
   wire [15:0] match_2_reg_38;          //Module8 2 match 3 register
   wire [15:0] match_3_reg_18;          //Module8 3 match 1 register
   wire [15:0] match_3_reg_28;          //Module8 3 match 2 register
   wire [15:0] match_3_reg_38;          //Module8 3 match 3 register

  assign interrupt8 = TTC_int8;   // Bug8 Fix8 for floating8 ints - Santhosh8 8 Nov8 06
   

//-----------------------------------------------------------------------------
// Module8 Instantiations8
//-----------------------------------------------------------------------------


  ttc_interface_lite8 i_ttc_interface_lite8 ( 

    //inputs8
    .n_p_reset8                           (n_p_reset8),
    .pclk8                                (pclk8),
    .psel8                                (psel8),
    .penable8                             (penable8),
    .pwrite8                              (pwrite8),
    .paddr8                               (paddr8),
    .clk_ctrl_reg_18                      (clk_ctrl_reg_18),
    .clk_ctrl_reg_28                      (clk_ctrl_reg_28),
    .clk_ctrl_reg_38                      (clk_ctrl_reg_38),
    .cntr_ctrl_reg_18                     (cntr_ctrl_reg_18),
    .cntr_ctrl_reg_28                     (cntr_ctrl_reg_28),
    .cntr_ctrl_reg_38                     (cntr_ctrl_reg_38),
    .counter_val_reg_18                   (counter_val_reg_18),
    .counter_val_reg_28                   (counter_val_reg_28),
    .counter_val_reg_38                   (counter_val_reg_38),
    .interval_reg_18                      (interval_reg_18),
    .match_1_reg_18                       (match_1_reg_18),
    .match_2_reg_18                       (match_2_reg_18),
    .match_3_reg_18                       (match_3_reg_18),
    .interval_reg_28                      (interval_reg_28),
    .match_1_reg_28                       (match_1_reg_28),
    .match_2_reg_28                       (match_2_reg_28),
    .match_3_reg_28                       (match_3_reg_28),
    .interval_reg_38                      (interval_reg_38),
    .match_1_reg_38                       (match_1_reg_38),
    .match_2_reg_38                       (match_2_reg_38),
    .match_3_reg_38                       (match_3_reg_38),
    .interrupt_reg_18                     (interrupt_reg_18),
    .interrupt_reg_28                     (interrupt_reg_28),
    .interrupt_reg_38                     (interrupt_reg_38), 
    .interrupt_en_reg_18                  (interrupt_en_reg_18),
    .interrupt_en_reg_28                  (interrupt_en_reg_28),
    .interrupt_en_reg_38                  (interrupt_en_reg_38), 

    //outputs8
    .prdata8                              (prdata8),
    .clk_ctrl_reg_sel_18                  (clk_ctrl_reg_sel_18),
    .clk_ctrl_reg_sel_28                  (clk_ctrl_reg_sel_28),
    .clk_ctrl_reg_sel_38                  (clk_ctrl_reg_sel_38),
    .cntr_ctrl_reg_sel_18                 (cntr_ctrl_reg_sel_18),
    .cntr_ctrl_reg_sel_28                 (cntr_ctrl_reg_sel_28),
    .cntr_ctrl_reg_sel_38                 (cntr_ctrl_reg_sel_38),
    .interval_reg_sel_18                  (interval_reg_sel_18),  
    .interval_reg_sel_28                  (interval_reg_sel_28), 
    .interval_reg_sel_38                  (interval_reg_sel_38),
    .match_1_reg_sel_18                   (match_1_reg_sel_18),     
    .match_1_reg_sel_28                   (match_1_reg_sel_28),
    .match_1_reg_sel_38                   (match_1_reg_sel_38),                
    .match_2_reg_sel_18                   (match_2_reg_sel_18),
    .match_2_reg_sel_28                   (match_2_reg_sel_28),
    .match_2_reg_sel_38                   (match_2_reg_sel_38),
    .match_3_reg_sel_18                   (match_3_reg_sel_18),
    .match_3_reg_sel_28                   (match_3_reg_sel_28),
    .match_3_reg_sel_38                   (match_3_reg_sel_38),
    .intr_en_reg_sel8                     (intr_en_reg_sel8),
    .clear_interrupt8                     (clear_interrupt8)

  );


   

  ttc_timer_counter_lite8 i_ttc_timer_counter_lite_18 ( 

    //inputs8
    .n_p_reset8                           (n_p_reset8),
    .pclk8                                (pclk8), 
    .pwdata8                              (pwdata8[15:0]),
    .clk_ctrl_reg_sel8                    (clk_ctrl_reg_sel_18),
    .cntr_ctrl_reg_sel8                   (cntr_ctrl_reg_sel_18),
    .interval_reg_sel8                    (interval_reg_sel_18),
    .match_1_reg_sel8                     (match_1_reg_sel_18),
    .match_2_reg_sel8                     (match_2_reg_sel_18),
    .match_3_reg_sel8                     (match_3_reg_sel_18),
    .intr_en_reg_sel8                     (intr_en_reg_sel8[1]),
    .clear_interrupt8                     (clear_interrupt8[1]),
                                  
    //outputs8
    .clk_ctrl_reg8                        (clk_ctrl_reg_18),
    .counter_val_reg8                     (counter_val_reg_18),
    .cntr_ctrl_reg8                       (cntr_ctrl_reg_18),
    .interval_reg8                        (interval_reg_18),
    .match_1_reg8                         (match_1_reg_18),
    .match_2_reg8                         (match_2_reg_18),
    .match_3_reg8                         (match_3_reg_18),
    .interrupt8                           (TTC_int8[1]),
    .interrupt_reg8                       (interrupt_reg_18),
    .interrupt_en_reg8                    (interrupt_en_reg_18)
  );


  ttc_timer_counter_lite8 i_ttc_timer_counter_lite_28 ( 

    //inputs8
    .n_p_reset8                           (n_p_reset8), 
    .pclk8                                (pclk8),
    .pwdata8                              (pwdata8[15:0]),
    .clk_ctrl_reg_sel8                    (clk_ctrl_reg_sel_28),
    .cntr_ctrl_reg_sel8                   (cntr_ctrl_reg_sel_28),
    .interval_reg_sel8                    (interval_reg_sel_28),
    .match_1_reg_sel8                     (match_1_reg_sel_28),
    .match_2_reg_sel8                     (match_2_reg_sel_28),
    .match_3_reg_sel8                     (match_3_reg_sel_28),
    .intr_en_reg_sel8                     (intr_en_reg_sel8[2]),
    .clear_interrupt8                     (clear_interrupt8[2]),
                                  
    //outputs8
    .clk_ctrl_reg8                        (clk_ctrl_reg_28),
    .counter_val_reg8                     (counter_val_reg_28),
    .cntr_ctrl_reg8                       (cntr_ctrl_reg_28),
    .interval_reg8                        (interval_reg_28),
    .match_1_reg8                         (match_1_reg_28),
    .match_2_reg8                         (match_2_reg_28),
    .match_3_reg8                         (match_3_reg_28),
    .interrupt8                           (TTC_int8[2]),
    .interrupt_reg8                       (interrupt_reg_28),
    .interrupt_en_reg8                    (interrupt_en_reg_28)
  );



  ttc_timer_counter_lite8 i_ttc_timer_counter_lite_38 ( 

    //inputs8
    .n_p_reset8                           (n_p_reset8), 
    .pclk8                                (pclk8),
    .pwdata8                              (pwdata8[15:0]),
    .clk_ctrl_reg_sel8                    (clk_ctrl_reg_sel_38),
    .cntr_ctrl_reg_sel8                   (cntr_ctrl_reg_sel_38),
    .interval_reg_sel8                    (interval_reg_sel_38),
    .match_1_reg_sel8                     (match_1_reg_sel_38),
    .match_2_reg_sel8                     (match_2_reg_sel_38),
    .match_3_reg_sel8                     (match_3_reg_sel_38),
    .intr_en_reg_sel8                     (intr_en_reg_sel8[3]),
    .clear_interrupt8                     (clear_interrupt8[3]),
                                              
    //outputs8
    .clk_ctrl_reg8                        (clk_ctrl_reg_38),
    .counter_val_reg8                     (counter_val_reg_38),
    .cntr_ctrl_reg8                       (cntr_ctrl_reg_38),
    .interval_reg8                        (interval_reg_38),
    .match_1_reg8                         (match_1_reg_38),
    .match_2_reg8                         (match_2_reg_38),
    .match_3_reg8                         (match_3_reg_38),
    .interrupt8                           (TTC_int8[3]),
    .interrupt_reg8                       (interrupt_reg_38),
    .interrupt_en_reg8                    (interrupt_en_reg_38)
  );





endmodule 
