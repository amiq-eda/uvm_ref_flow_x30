//File27 name   : ttc_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : The top level of the Triple27 Timer27 Counter27.
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module27 definition27
//-----------------------------------------------------------------------------

module ttc_lite27(
           
           //inputs27
           n_p_reset27,
           pclk27,
           psel27,
           penable27,
           pwrite27,
           pwdata27,
           paddr27,
           scan_in27,
           scan_en27,

           //outputs27
           prdata27,
           interrupt27,
           scan_out27           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS27
//-----------------------------------------------------------------------------

   input         n_p_reset27;              //System27 Reset27
   input         pclk27;                 //System27 clock27
   input         psel27;                 //Select27 line
   input         penable27;              //Enable27
   input         pwrite27;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata27;               //Write data
   input [7:0]   paddr27;                //Address Bus27 register
   input         scan_in27;              //Scan27 chain27 input port
   input         scan_en27;              //Scan27 chain27 enable port
   
   output [31:0] prdata27;               //Read Data from the APB27 Interface27
   output [3:1]  interrupt27;            //Interrupt27 from PCI27 
   output        scan_out27;             //Scan27 chain27 output port

//-----------------------------------------------------------------------------
// Module27 Interconnect27
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int27;
   wire        clk_ctrl_reg_sel_127;     //Module27 1 clock27 control27 select27
   wire        clk_ctrl_reg_sel_227;     //Module27 2 clock27 control27 select27
   wire        clk_ctrl_reg_sel_327;     //Module27 3 clock27 control27 select27
   wire        cntr_ctrl_reg_sel_127;    //Module27 1 counter control27 select27
   wire        cntr_ctrl_reg_sel_227;    //Module27 2 counter control27 select27
   wire        cntr_ctrl_reg_sel_327;    //Module27 3 counter control27 select27
   wire        interval_reg_sel_127;     //Interval27 1 register select27
   wire        interval_reg_sel_227;     //Interval27 2 register select27
   wire        interval_reg_sel_327;     //Interval27 3 register select27
   wire        match_1_reg_sel_127;      //Module27 1 match 1 select27
   wire        match_1_reg_sel_227;      //Module27 1 match 2 select27
   wire        match_1_reg_sel_327;      //Module27 1 match 3 select27
   wire        match_2_reg_sel_127;      //Module27 2 match 1 select27
   wire        match_2_reg_sel_227;      //Module27 2 match 2 select27
   wire        match_2_reg_sel_327;      //Module27 2 match 3 select27
   wire        match_3_reg_sel_127;      //Module27 3 match 1 select27
   wire        match_3_reg_sel_227;      //Module27 3 match 2 select27
   wire        match_3_reg_sel_327;      //Module27 3 match 3 select27
   wire [3:1]  intr_en_reg_sel27;        //Interrupt27 enable register select27
   wire [3:1]  clear_interrupt27;        //Clear interrupt27 signal27
   wire [5:0]  interrupt_reg_127;        //Interrupt27 register 1
   wire [5:0]  interrupt_reg_227;        //Interrupt27 register 2
   wire [5:0]  interrupt_reg_327;        //Interrupt27 register 3 
   wire [5:0]  interrupt_en_reg_127;     //Interrupt27 enable register 1
   wire [5:0]  interrupt_en_reg_227;     //Interrupt27 enable register 2
   wire [5:0]  interrupt_en_reg_327;     //Interrupt27 enable register 3
   wire [6:0]  clk_ctrl_reg_127;         //Clock27 control27 regs for the 
   wire [6:0]  clk_ctrl_reg_227;         //Timer_Counter27 1,2,3
   wire [6:0]  clk_ctrl_reg_327;         //Value of the clock27 frequency27
   wire [15:0] counter_val_reg_127;      //Module27 1 counter value 
   wire [15:0] counter_val_reg_227;      //Module27 2 counter value 
   wire [15:0] counter_val_reg_327;      //Module27 3 counter value 
   wire [6:0]  cntr_ctrl_reg_127;        //Module27 1 counter control27  
   wire [6:0]  cntr_ctrl_reg_227;        //Module27 2 counter control27  
   wire [6:0]  cntr_ctrl_reg_327;        //Module27 3 counter control27  
   wire [15:0] interval_reg_127;         //Module27 1 interval27 register
   wire [15:0] interval_reg_227;         //Module27 2 interval27 register
   wire [15:0] interval_reg_327;         //Module27 3 interval27 register
   wire [15:0] match_1_reg_127;          //Module27 1 match 1 register
   wire [15:0] match_1_reg_227;          //Module27 1 match 2 register
   wire [15:0] match_1_reg_327;          //Module27 1 match 3 register
   wire [15:0] match_2_reg_127;          //Module27 2 match 1 register
   wire [15:0] match_2_reg_227;          //Module27 2 match 2 register
   wire [15:0] match_2_reg_327;          //Module27 2 match 3 register
   wire [15:0] match_3_reg_127;          //Module27 3 match 1 register
   wire [15:0] match_3_reg_227;          //Module27 3 match 2 register
   wire [15:0] match_3_reg_327;          //Module27 3 match 3 register

  assign interrupt27 = TTC_int27;   // Bug27 Fix27 for floating27 ints - Santhosh27 8 Nov27 06
   

//-----------------------------------------------------------------------------
// Module27 Instantiations27
//-----------------------------------------------------------------------------


  ttc_interface_lite27 i_ttc_interface_lite27 ( 

    //inputs27
    .n_p_reset27                           (n_p_reset27),
    .pclk27                                (pclk27),
    .psel27                                (psel27),
    .penable27                             (penable27),
    .pwrite27                              (pwrite27),
    .paddr27                               (paddr27),
    .clk_ctrl_reg_127                      (clk_ctrl_reg_127),
    .clk_ctrl_reg_227                      (clk_ctrl_reg_227),
    .clk_ctrl_reg_327                      (clk_ctrl_reg_327),
    .cntr_ctrl_reg_127                     (cntr_ctrl_reg_127),
    .cntr_ctrl_reg_227                     (cntr_ctrl_reg_227),
    .cntr_ctrl_reg_327                     (cntr_ctrl_reg_327),
    .counter_val_reg_127                   (counter_val_reg_127),
    .counter_val_reg_227                   (counter_val_reg_227),
    .counter_val_reg_327                   (counter_val_reg_327),
    .interval_reg_127                      (interval_reg_127),
    .match_1_reg_127                       (match_1_reg_127),
    .match_2_reg_127                       (match_2_reg_127),
    .match_3_reg_127                       (match_3_reg_127),
    .interval_reg_227                      (interval_reg_227),
    .match_1_reg_227                       (match_1_reg_227),
    .match_2_reg_227                       (match_2_reg_227),
    .match_3_reg_227                       (match_3_reg_227),
    .interval_reg_327                      (interval_reg_327),
    .match_1_reg_327                       (match_1_reg_327),
    .match_2_reg_327                       (match_2_reg_327),
    .match_3_reg_327                       (match_3_reg_327),
    .interrupt_reg_127                     (interrupt_reg_127),
    .interrupt_reg_227                     (interrupt_reg_227),
    .interrupt_reg_327                     (interrupt_reg_327), 
    .interrupt_en_reg_127                  (interrupt_en_reg_127),
    .interrupt_en_reg_227                  (interrupt_en_reg_227),
    .interrupt_en_reg_327                  (interrupt_en_reg_327), 

    //outputs27
    .prdata27                              (prdata27),
    .clk_ctrl_reg_sel_127                  (clk_ctrl_reg_sel_127),
    .clk_ctrl_reg_sel_227                  (clk_ctrl_reg_sel_227),
    .clk_ctrl_reg_sel_327                  (clk_ctrl_reg_sel_327),
    .cntr_ctrl_reg_sel_127                 (cntr_ctrl_reg_sel_127),
    .cntr_ctrl_reg_sel_227                 (cntr_ctrl_reg_sel_227),
    .cntr_ctrl_reg_sel_327                 (cntr_ctrl_reg_sel_327),
    .interval_reg_sel_127                  (interval_reg_sel_127),  
    .interval_reg_sel_227                  (interval_reg_sel_227), 
    .interval_reg_sel_327                  (interval_reg_sel_327),
    .match_1_reg_sel_127                   (match_1_reg_sel_127),     
    .match_1_reg_sel_227                   (match_1_reg_sel_227),
    .match_1_reg_sel_327                   (match_1_reg_sel_327),                
    .match_2_reg_sel_127                   (match_2_reg_sel_127),
    .match_2_reg_sel_227                   (match_2_reg_sel_227),
    .match_2_reg_sel_327                   (match_2_reg_sel_327),
    .match_3_reg_sel_127                   (match_3_reg_sel_127),
    .match_3_reg_sel_227                   (match_3_reg_sel_227),
    .match_3_reg_sel_327                   (match_3_reg_sel_327),
    .intr_en_reg_sel27                     (intr_en_reg_sel27),
    .clear_interrupt27                     (clear_interrupt27)

  );


   

  ttc_timer_counter_lite27 i_ttc_timer_counter_lite_127 ( 

    //inputs27
    .n_p_reset27                           (n_p_reset27),
    .pclk27                                (pclk27), 
    .pwdata27                              (pwdata27[15:0]),
    .clk_ctrl_reg_sel27                    (clk_ctrl_reg_sel_127),
    .cntr_ctrl_reg_sel27                   (cntr_ctrl_reg_sel_127),
    .interval_reg_sel27                    (interval_reg_sel_127),
    .match_1_reg_sel27                     (match_1_reg_sel_127),
    .match_2_reg_sel27                     (match_2_reg_sel_127),
    .match_3_reg_sel27                     (match_3_reg_sel_127),
    .intr_en_reg_sel27                     (intr_en_reg_sel27[1]),
    .clear_interrupt27                     (clear_interrupt27[1]),
                                  
    //outputs27
    .clk_ctrl_reg27                        (clk_ctrl_reg_127),
    .counter_val_reg27                     (counter_val_reg_127),
    .cntr_ctrl_reg27                       (cntr_ctrl_reg_127),
    .interval_reg27                        (interval_reg_127),
    .match_1_reg27                         (match_1_reg_127),
    .match_2_reg27                         (match_2_reg_127),
    .match_3_reg27                         (match_3_reg_127),
    .interrupt27                           (TTC_int27[1]),
    .interrupt_reg27                       (interrupt_reg_127),
    .interrupt_en_reg27                    (interrupt_en_reg_127)
  );


  ttc_timer_counter_lite27 i_ttc_timer_counter_lite_227 ( 

    //inputs27
    .n_p_reset27                           (n_p_reset27), 
    .pclk27                                (pclk27),
    .pwdata27                              (pwdata27[15:0]),
    .clk_ctrl_reg_sel27                    (clk_ctrl_reg_sel_227),
    .cntr_ctrl_reg_sel27                   (cntr_ctrl_reg_sel_227),
    .interval_reg_sel27                    (interval_reg_sel_227),
    .match_1_reg_sel27                     (match_1_reg_sel_227),
    .match_2_reg_sel27                     (match_2_reg_sel_227),
    .match_3_reg_sel27                     (match_3_reg_sel_227),
    .intr_en_reg_sel27                     (intr_en_reg_sel27[2]),
    .clear_interrupt27                     (clear_interrupt27[2]),
                                  
    //outputs27
    .clk_ctrl_reg27                        (clk_ctrl_reg_227),
    .counter_val_reg27                     (counter_val_reg_227),
    .cntr_ctrl_reg27                       (cntr_ctrl_reg_227),
    .interval_reg27                        (interval_reg_227),
    .match_1_reg27                         (match_1_reg_227),
    .match_2_reg27                         (match_2_reg_227),
    .match_3_reg27                         (match_3_reg_227),
    .interrupt27                           (TTC_int27[2]),
    .interrupt_reg27                       (interrupt_reg_227),
    .interrupt_en_reg27                    (interrupt_en_reg_227)
  );



  ttc_timer_counter_lite27 i_ttc_timer_counter_lite_327 ( 

    //inputs27
    .n_p_reset27                           (n_p_reset27), 
    .pclk27                                (pclk27),
    .pwdata27                              (pwdata27[15:0]),
    .clk_ctrl_reg_sel27                    (clk_ctrl_reg_sel_327),
    .cntr_ctrl_reg_sel27                   (cntr_ctrl_reg_sel_327),
    .interval_reg_sel27                    (interval_reg_sel_327),
    .match_1_reg_sel27                     (match_1_reg_sel_327),
    .match_2_reg_sel27                     (match_2_reg_sel_327),
    .match_3_reg_sel27                     (match_3_reg_sel_327),
    .intr_en_reg_sel27                     (intr_en_reg_sel27[3]),
    .clear_interrupt27                     (clear_interrupt27[3]),
                                              
    //outputs27
    .clk_ctrl_reg27                        (clk_ctrl_reg_327),
    .counter_val_reg27                     (counter_val_reg_327),
    .cntr_ctrl_reg27                       (cntr_ctrl_reg_327),
    .interval_reg27                        (interval_reg_327),
    .match_1_reg27                         (match_1_reg_327),
    .match_2_reg27                         (match_2_reg_327),
    .match_3_reg27                         (match_3_reg_327),
    .interrupt27                           (TTC_int27[3]),
    .interrupt_reg27                       (interrupt_reg_327),
    .interrupt_en_reg27                    (interrupt_en_reg_327)
  );





endmodule 
