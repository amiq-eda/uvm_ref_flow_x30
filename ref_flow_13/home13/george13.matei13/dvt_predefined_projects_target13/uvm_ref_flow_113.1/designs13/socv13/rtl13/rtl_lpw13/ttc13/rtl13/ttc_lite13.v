//File13 name   : ttc_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : The top level of the Triple13 Timer13 Counter13.
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module13 definition13
//-----------------------------------------------------------------------------

module ttc_lite13(
           
           //inputs13
           n_p_reset13,
           pclk13,
           psel13,
           penable13,
           pwrite13,
           pwdata13,
           paddr13,
           scan_in13,
           scan_en13,

           //outputs13
           prdata13,
           interrupt13,
           scan_out13           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS13
//-----------------------------------------------------------------------------

   input         n_p_reset13;              //System13 Reset13
   input         pclk13;                 //System13 clock13
   input         psel13;                 //Select13 line
   input         penable13;              //Enable13
   input         pwrite13;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata13;               //Write data
   input [7:0]   paddr13;                //Address Bus13 register
   input         scan_in13;              //Scan13 chain13 input port
   input         scan_en13;              //Scan13 chain13 enable port
   
   output [31:0] prdata13;               //Read Data from the APB13 Interface13
   output [3:1]  interrupt13;            //Interrupt13 from PCI13 
   output        scan_out13;             //Scan13 chain13 output port

//-----------------------------------------------------------------------------
// Module13 Interconnect13
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int13;
   wire        clk_ctrl_reg_sel_113;     //Module13 1 clock13 control13 select13
   wire        clk_ctrl_reg_sel_213;     //Module13 2 clock13 control13 select13
   wire        clk_ctrl_reg_sel_313;     //Module13 3 clock13 control13 select13
   wire        cntr_ctrl_reg_sel_113;    //Module13 1 counter control13 select13
   wire        cntr_ctrl_reg_sel_213;    //Module13 2 counter control13 select13
   wire        cntr_ctrl_reg_sel_313;    //Module13 3 counter control13 select13
   wire        interval_reg_sel_113;     //Interval13 1 register select13
   wire        interval_reg_sel_213;     //Interval13 2 register select13
   wire        interval_reg_sel_313;     //Interval13 3 register select13
   wire        match_1_reg_sel_113;      //Module13 1 match 1 select13
   wire        match_1_reg_sel_213;      //Module13 1 match 2 select13
   wire        match_1_reg_sel_313;      //Module13 1 match 3 select13
   wire        match_2_reg_sel_113;      //Module13 2 match 1 select13
   wire        match_2_reg_sel_213;      //Module13 2 match 2 select13
   wire        match_2_reg_sel_313;      //Module13 2 match 3 select13
   wire        match_3_reg_sel_113;      //Module13 3 match 1 select13
   wire        match_3_reg_sel_213;      //Module13 3 match 2 select13
   wire        match_3_reg_sel_313;      //Module13 3 match 3 select13
   wire [3:1]  intr_en_reg_sel13;        //Interrupt13 enable register select13
   wire [3:1]  clear_interrupt13;        //Clear interrupt13 signal13
   wire [5:0]  interrupt_reg_113;        //Interrupt13 register 1
   wire [5:0]  interrupt_reg_213;        //Interrupt13 register 2
   wire [5:0]  interrupt_reg_313;        //Interrupt13 register 3 
   wire [5:0]  interrupt_en_reg_113;     //Interrupt13 enable register 1
   wire [5:0]  interrupt_en_reg_213;     //Interrupt13 enable register 2
   wire [5:0]  interrupt_en_reg_313;     //Interrupt13 enable register 3
   wire [6:0]  clk_ctrl_reg_113;         //Clock13 control13 regs for the 
   wire [6:0]  clk_ctrl_reg_213;         //Timer_Counter13 1,2,3
   wire [6:0]  clk_ctrl_reg_313;         //Value of the clock13 frequency13
   wire [15:0] counter_val_reg_113;      //Module13 1 counter value 
   wire [15:0] counter_val_reg_213;      //Module13 2 counter value 
   wire [15:0] counter_val_reg_313;      //Module13 3 counter value 
   wire [6:0]  cntr_ctrl_reg_113;        //Module13 1 counter control13  
   wire [6:0]  cntr_ctrl_reg_213;        //Module13 2 counter control13  
   wire [6:0]  cntr_ctrl_reg_313;        //Module13 3 counter control13  
   wire [15:0] interval_reg_113;         //Module13 1 interval13 register
   wire [15:0] interval_reg_213;         //Module13 2 interval13 register
   wire [15:0] interval_reg_313;         //Module13 3 interval13 register
   wire [15:0] match_1_reg_113;          //Module13 1 match 1 register
   wire [15:0] match_1_reg_213;          //Module13 1 match 2 register
   wire [15:0] match_1_reg_313;          //Module13 1 match 3 register
   wire [15:0] match_2_reg_113;          //Module13 2 match 1 register
   wire [15:0] match_2_reg_213;          //Module13 2 match 2 register
   wire [15:0] match_2_reg_313;          //Module13 2 match 3 register
   wire [15:0] match_3_reg_113;          //Module13 3 match 1 register
   wire [15:0] match_3_reg_213;          //Module13 3 match 2 register
   wire [15:0] match_3_reg_313;          //Module13 3 match 3 register

  assign interrupt13 = TTC_int13;   // Bug13 Fix13 for floating13 ints - Santhosh13 8 Nov13 06
   

//-----------------------------------------------------------------------------
// Module13 Instantiations13
//-----------------------------------------------------------------------------


  ttc_interface_lite13 i_ttc_interface_lite13 ( 

    //inputs13
    .n_p_reset13                           (n_p_reset13),
    .pclk13                                (pclk13),
    .psel13                                (psel13),
    .penable13                             (penable13),
    .pwrite13                              (pwrite13),
    .paddr13                               (paddr13),
    .clk_ctrl_reg_113                      (clk_ctrl_reg_113),
    .clk_ctrl_reg_213                      (clk_ctrl_reg_213),
    .clk_ctrl_reg_313                      (clk_ctrl_reg_313),
    .cntr_ctrl_reg_113                     (cntr_ctrl_reg_113),
    .cntr_ctrl_reg_213                     (cntr_ctrl_reg_213),
    .cntr_ctrl_reg_313                     (cntr_ctrl_reg_313),
    .counter_val_reg_113                   (counter_val_reg_113),
    .counter_val_reg_213                   (counter_val_reg_213),
    .counter_val_reg_313                   (counter_val_reg_313),
    .interval_reg_113                      (interval_reg_113),
    .match_1_reg_113                       (match_1_reg_113),
    .match_2_reg_113                       (match_2_reg_113),
    .match_3_reg_113                       (match_3_reg_113),
    .interval_reg_213                      (interval_reg_213),
    .match_1_reg_213                       (match_1_reg_213),
    .match_2_reg_213                       (match_2_reg_213),
    .match_3_reg_213                       (match_3_reg_213),
    .interval_reg_313                      (interval_reg_313),
    .match_1_reg_313                       (match_1_reg_313),
    .match_2_reg_313                       (match_2_reg_313),
    .match_3_reg_313                       (match_3_reg_313),
    .interrupt_reg_113                     (interrupt_reg_113),
    .interrupt_reg_213                     (interrupt_reg_213),
    .interrupt_reg_313                     (interrupt_reg_313), 
    .interrupt_en_reg_113                  (interrupt_en_reg_113),
    .interrupt_en_reg_213                  (interrupt_en_reg_213),
    .interrupt_en_reg_313                  (interrupt_en_reg_313), 

    //outputs13
    .prdata13                              (prdata13),
    .clk_ctrl_reg_sel_113                  (clk_ctrl_reg_sel_113),
    .clk_ctrl_reg_sel_213                  (clk_ctrl_reg_sel_213),
    .clk_ctrl_reg_sel_313                  (clk_ctrl_reg_sel_313),
    .cntr_ctrl_reg_sel_113                 (cntr_ctrl_reg_sel_113),
    .cntr_ctrl_reg_sel_213                 (cntr_ctrl_reg_sel_213),
    .cntr_ctrl_reg_sel_313                 (cntr_ctrl_reg_sel_313),
    .interval_reg_sel_113                  (interval_reg_sel_113),  
    .interval_reg_sel_213                  (interval_reg_sel_213), 
    .interval_reg_sel_313                  (interval_reg_sel_313),
    .match_1_reg_sel_113                   (match_1_reg_sel_113),     
    .match_1_reg_sel_213                   (match_1_reg_sel_213),
    .match_1_reg_sel_313                   (match_1_reg_sel_313),                
    .match_2_reg_sel_113                   (match_2_reg_sel_113),
    .match_2_reg_sel_213                   (match_2_reg_sel_213),
    .match_2_reg_sel_313                   (match_2_reg_sel_313),
    .match_3_reg_sel_113                   (match_3_reg_sel_113),
    .match_3_reg_sel_213                   (match_3_reg_sel_213),
    .match_3_reg_sel_313                   (match_3_reg_sel_313),
    .intr_en_reg_sel13                     (intr_en_reg_sel13),
    .clear_interrupt13                     (clear_interrupt13)

  );


   

  ttc_timer_counter_lite13 i_ttc_timer_counter_lite_113 ( 

    //inputs13
    .n_p_reset13                           (n_p_reset13),
    .pclk13                                (pclk13), 
    .pwdata13                              (pwdata13[15:0]),
    .clk_ctrl_reg_sel13                    (clk_ctrl_reg_sel_113),
    .cntr_ctrl_reg_sel13                   (cntr_ctrl_reg_sel_113),
    .interval_reg_sel13                    (interval_reg_sel_113),
    .match_1_reg_sel13                     (match_1_reg_sel_113),
    .match_2_reg_sel13                     (match_2_reg_sel_113),
    .match_3_reg_sel13                     (match_3_reg_sel_113),
    .intr_en_reg_sel13                     (intr_en_reg_sel13[1]),
    .clear_interrupt13                     (clear_interrupt13[1]),
                                  
    //outputs13
    .clk_ctrl_reg13                        (clk_ctrl_reg_113),
    .counter_val_reg13                     (counter_val_reg_113),
    .cntr_ctrl_reg13                       (cntr_ctrl_reg_113),
    .interval_reg13                        (interval_reg_113),
    .match_1_reg13                         (match_1_reg_113),
    .match_2_reg13                         (match_2_reg_113),
    .match_3_reg13                         (match_3_reg_113),
    .interrupt13                           (TTC_int13[1]),
    .interrupt_reg13                       (interrupt_reg_113),
    .interrupt_en_reg13                    (interrupt_en_reg_113)
  );


  ttc_timer_counter_lite13 i_ttc_timer_counter_lite_213 ( 

    //inputs13
    .n_p_reset13                           (n_p_reset13), 
    .pclk13                                (pclk13),
    .pwdata13                              (pwdata13[15:0]),
    .clk_ctrl_reg_sel13                    (clk_ctrl_reg_sel_213),
    .cntr_ctrl_reg_sel13                   (cntr_ctrl_reg_sel_213),
    .interval_reg_sel13                    (interval_reg_sel_213),
    .match_1_reg_sel13                     (match_1_reg_sel_213),
    .match_2_reg_sel13                     (match_2_reg_sel_213),
    .match_3_reg_sel13                     (match_3_reg_sel_213),
    .intr_en_reg_sel13                     (intr_en_reg_sel13[2]),
    .clear_interrupt13                     (clear_interrupt13[2]),
                                  
    //outputs13
    .clk_ctrl_reg13                        (clk_ctrl_reg_213),
    .counter_val_reg13                     (counter_val_reg_213),
    .cntr_ctrl_reg13                       (cntr_ctrl_reg_213),
    .interval_reg13                        (interval_reg_213),
    .match_1_reg13                         (match_1_reg_213),
    .match_2_reg13                         (match_2_reg_213),
    .match_3_reg13                         (match_3_reg_213),
    .interrupt13                           (TTC_int13[2]),
    .interrupt_reg13                       (interrupt_reg_213),
    .interrupt_en_reg13                    (interrupt_en_reg_213)
  );



  ttc_timer_counter_lite13 i_ttc_timer_counter_lite_313 ( 

    //inputs13
    .n_p_reset13                           (n_p_reset13), 
    .pclk13                                (pclk13),
    .pwdata13                              (pwdata13[15:0]),
    .clk_ctrl_reg_sel13                    (clk_ctrl_reg_sel_313),
    .cntr_ctrl_reg_sel13                   (cntr_ctrl_reg_sel_313),
    .interval_reg_sel13                    (interval_reg_sel_313),
    .match_1_reg_sel13                     (match_1_reg_sel_313),
    .match_2_reg_sel13                     (match_2_reg_sel_313),
    .match_3_reg_sel13                     (match_3_reg_sel_313),
    .intr_en_reg_sel13                     (intr_en_reg_sel13[3]),
    .clear_interrupt13                     (clear_interrupt13[3]),
                                              
    //outputs13
    .clk_ctrl_reg13                        (clk_ctrl_reg_313),
    .counter_val_reg13                     (counter_val_reg_313),
    .cntr_ctrl_reg13                       (cntr_ctrl_reg_313),
    .interval_reg13                        (interval_reg_313),
    .match_1_reg13                         (match_1_reg_313),
    .match_2_reg13                         (match_2_reg_313),
    .match_3_reg13                         (match_3_reg_313),
    .interrupt13                           (TTC_int13[3]),
    .interrupt_reg13                       (interrupt_reg_313),
    .interrupt_en_reg13                    (interrupt_en_reg_313)
  );





endmodule 
