//File19 name   : ttc_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : The top level of the Triple19 Timer19 Counter19.
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module19 definition19
//-----------------------------------------------------------------------------

module ttc_lite19(
           
           //inputs19
           n_p_reset19,
           pclk19,
           psel19,
           penable19,
           pwrite19,
           pwdata19,
           paddr19,
           scan_in19,
           scan_en19,

           //outputs19
           prdata19,
           interrupt19,
           scan_out19           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS19
//-----------------------------------------------------------------------------

   input         n_p_reset19;              //System19 Reset19
   input         pclk19;                 //System19 clock19
   input         psel19;                 //Select19 line
   input         penable19;              //Enable19
   input         pwrite19;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata19;               //Write data
   input [7:0]   paddr19;                //Address Bus19 register
   input         scan_in19;              //Scan19 chain19 input port
   input         scan_en19;              //Scan19 chain19 enable port
   
   output [31:0] prdata19;               //Read Data from the APB19 Interface19
   output [3:1]  interrupt19;            //Interrupt19 from PCI19 
   output        scan_out19;             //Scan19 chain19 output port

//-----------------------------------------------------------------------------
// Module19 Interconnect19
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int19;
   wire        clk_ctrl_reg_sel_119;     //Module19 1 clock19 control19 select19
   wire        clk_ctrl_reg_sel_219;     //Module19 2 clock19 control19 select19
   wire        clk_ctrl_reg_sel_319;     //Module19 3 clock19 control19 select19
   wire        cntr_ctrl_reg_sel_119;    //Module19 1 counter control19 select19
   wire        cntr_ctrl_reg_sel_219;    //Module19 2 counter control19 select19
   wire        cntr_ctrl_reg_sel_319;    //Module19 3 counter control19 select19
   wire        interval_reg_sel_119;     //Interval19 1 register select19
   wire        interval_reg_sel_219;     //Interval19 2 register select19
   wire        interval_reg_sel_319;     //Interval19 3 register select19
   wire        match_1_reg_sel_119;      //Module19 1 match 1 select19
   wire        match_1_reg_sel_219;      //Module19 1 match 2 select19
   wire        match_1_reg_sel_319;      //Module19 1 match 3 select19
   wire        match_2_reg_sel_119;      //Module19 2 match 1 select19
   wire        match_2_reg_sel_219;      //Module19 2 match 2 select19
   wire        match_2_reg_sel_319;      //Module19 2 match 3 select19
   wire        match_3_reg_sel_119;      //Module19 3 match 1 select19
   wire        match_3_reg_sel_219;      //Module19 3 match 2 select19
   wire        match_3_reg_sel_319;      //Module19 3 match 3 select19
   wire [3:1]  intr_en_reg_sel19;        //Interrupt19 enable register select19
   wire [3:1]  clear_interrupt19;        //Clear interrupt19 signal19
   wire [5:0]  interrupt_reg_119;        //Interrupt19 register 1
   wire [5:0]  interrupt_reg_219;        //Interrupt19 register 2
   wire [5:0]  interrupt_reg_319;        //Interrupt19 register 3 
   wire [5:0]  interrupt_en_reg_119;     //Interrupt19 enable register 1
   wire [5:0]  interrupt_en_reg_219;     //Interrupt19 enable register 2
   wire [5:0]  interrupt_en_reg_319;     //Interrupt19 enable register 3
   wire [6:0]  clk_ctrl_reg_119;         //Clock19 control19 regs for the 
   wire [6:0]  clk_ctrl_reg_219;         //Timer_Counter19 1,2,3
   wire [6:0]  clk_ctrl_reg_319;         //Value of the clock19 frequency19
   wire [15:0] counter_val_reg_119;      //Module19 1 counter value 
   wire [15:0] counter_val_reg_219;      //Module19 2 counter value 
   wire [15:0] counter_val_reg_319;      //Module19 3 counter value 
   wire [6:0]  cntr_ctrl_reg_119;        //Module19 1 counter control19  
   wire [6:0]  cntr_ctrl_reg_219;        //Module19 2 counter control19  
   wire [6:0]  cntr_ctrl_reg_319;        //Module19 3 counter control19  
   wire [15:0] interval_reg_119;         //Module19 1 interval19 register
   wire [15:0] interval_reg_219;         //Module19 2 interval19 register
   wire [15:0] interval_reg_319;         //Module19 3 interval19 register
   wire [15:0] match_1_reg_119;          //Module19 1 match 1 register
   wire [15:0] match_1_reg_219;          //Module19 1 match 2 register
   wire [15:0] match_1_reg_319;          //Module19 1 match 3 register
   wire [15:0] match_2_reg_119;          //Module19 2 match 1 register
   wire [15:0] match_2_reg_219;          //Module19 2 match 2 register
   wire [15:0] match_2_reg_319;          //Module19 2 match 3 register
   wire [15:0] match_3_reg_119;          //Module19 3 match 1 register
   wire [15:0] match_3_reg_219;          //Module19 3 match 2 register
   wire [15:0] match_3_reg_319;          //Module19 3 match 3 register

  assign interrupt19 = TTC_int19;   // Bug19 Fix19 for floating19 ints - Santhosh19 8 Nov19 06
   

//-----------------------------------------------------------------------------
// Module19 Instantiations19
//-----------------------------------------------------------------------------


  ttc_interface_lite19 i_ttc_interface_lite19 ( 

    //inputs19
    .n_p_reset19                           (n_p_reset19),
    .pclk19                                (pclk19),
    .psel19                                (psel19),
    .penable19                             (penable19),
    .pwrite19                              (pwrite19),
    .paddr19                               (paddr19),
    .clk_ctrl_reg_119                      (clk_ctrl_reg_119),
    .clk_ctrl_reg_219                      (clk_ctrl_reg_219),
    .clk_ctrl_reg_319                      (clk_ctrl_reg_319),
    .cntr_ctrl_reg_119                     (cntr_ctrl_reg_119),
    .cntr_ctrl_reg_219                     (cntr_ctrl_reg_219),
    .cntr_ctrl_reg_319                     (cntr_ctrl_reg_319),
    .counter_val_reg_119                   (counter_val_reg_119),
    .counter_val_reg_219                   (counter_val_reg_219),
    .counter_val_reg_319                   (counter_val_reg_319),
    .interval_reg_119                      (interval_reg_119),
    .match_1_reg_119                       (match_1_reg_119),
    .match_2_reg_119                       (match_2_reg_119),
    .match_3_reg_119                       (match_3_reg_119),
    .interval_reg_219                      (interval_reg_219),
    .match_1_reg_219                       (match_1_reg_219),
    .match_2_reg_219                       (match_2_reg_219),
    .match_3_reg_219                       (match_3_reg_219),
    .interval_reg_319                      (interval_reg_319),
    .match_1_reg_319                       (match_1_reg_319),
    .match_2_reg_319                       (match_2_reg_319),
    .match_3_reg_319                       (match_3_reg_319),
    .interrupt_reg_119                     (interrupt_reg_119),
    .interrupt_reg_219                     (interrupt_reg_219),
    .interrupt_reg_319                     (interrupt_reg_319), 
    .interrupt_en_reg_119                  (interrupt_en_reg_119),
    .interrupt_en_reg_219                  (interrupt_en_reg_219),
    .interrupt_en_reg_319                  (interrupt_en_reg_319), 

    //outputs19
    .prdata19                              (prdata19),
    .clk_ctrl_reg_sel_119                  (clk_ctrl_reg_sel_119),
    .clk_ctrl_reg_sel_219                  (clk_ctrl_reg_sel_219),
    .clk_ctrl_reg_sel_319                  (clk_ctrl_reg_sel_319),
    .cntr_ctrl_reg_sel_119                 (cntr_ctrl_reg_sel_119),
    .cntr_ctrl_reg_sel_219                 (cntr_ctrl_reg_sel_219),
    .cntr_ctrl_reg_sel_319                 (cntr_ctrl_reg_sel_319),
    .interval_reg_sel_119                  (interval_reg_sel_119),  
    .interval_reg_sel_219                  (interval_reg_sel_219), 
    .interval_reg_sel_319                  (interval_reg_sel_319),
    .match_1_reg_sel_119                   (match_1_reg_sel_119),     
    .match_1_reg_sel_219                   (match_1_reg_sel_219),
    .match_1_reg_sel_319                   (match_1_reg_sel_319),                
    .match_2_reg_sel_119                   (match_2_reg_sel_119),
    .match_2_reg_sel_219                   (match_2_reg_sel_219),
    .match_2_reg_sel_319                   (match_2_reg_sel_319),
    .match_3_reg_sel_119                   (match_3_reg_sel_119),
    .match_3_reg_sel_219                   (match_3_reg_sel_219),
    .match_3_reg_sel_319                   (match_3_reg_sel_319),
    .intr_en_reg_sel19                     (intr_en_reg_sel19),
    .clear_interrupt19                     (clear_interrupt19)

  );


   

  ttc_timer_counter_lite19 i_ttc_timer_counter_lite_119 ( 

    //inputs19
    .n_p_reset19                           (n_p_reset19),
    .pclk19                                (pclk19), 
    .pwdata19                              (pwdata19[15:0]),
    .clk_ctrl_reg_sel19                    (clk_ctrl_reg_sel_119),
    .cntr_ctrl_reg_sel19                   (cntr_ctrl_reg_sel_119),
    .interval_reg_sel19                    (interval_reg_sel_119),
    .match_1_reg_sel19                     (match_1_reg_sel_119),
    .match_2_reg_sel19                     (match_2_reg_sel_119),
    .match_3_reg_sel19                     (match_3_reg_sel_119),
    .intr_en_reg_sel19                     (intr_en_reg_sel19[1]),
    .clear_interrupt19                     (clear_interrupt19[1]),
                                  
    //outputs19
    .clk_ctrl_reg19                        (clk_ctrl_reg_119),
    .counter_val_reg19                     (counter_val_reg_119),
    .cntr_ctrl_reg19                       (cntr_ctrl_reg_119),
    .interval_reg19                        (interval_reg_119),
    .match_1_reg19                         (match_1_reg_119),
    .match_2_reg19                         (match_2_reg_119),
    .match_3_reg19                         (match_3_reg_119),
    .interrupt19                           (TTC_int19[1]),
    .interrupt_reg19                       (interrupt_reg_119),
    .interrupt_en_reg19                    (interrupt_en_reg_119)
  );


  ttc_timer_counter_lite19 i_ttc_timer_counter_lite_219 ( 

    //inputs19
    .n_p_reset19                           (n_p_reset19), 
    .pclk19                                (pclk19),
    .pwdata19                              (pwdata19[15:0]),
    .clk_ctrl_reg_sel19                    (clk_ctrl_reg_sel_219),
    .cntr_ctrl_reg_sel19                   (cntr_ctrl_reg_sel_219),
    .interval_reg_sel19                    (interval_reg_sel_219),
    .match_1_reg_sel19                     (match_1_reg_sel_219),
    .match_2_reg_sel19                     (match_2_reg_sel_219),
    .match_3_reg_sel19                     (match_3_reg_sel_219),
    .intr_en_reg_sel19                     (intr_en_reg_sel19[2]),
    .clear_interrupt19                     (clear_interrupt19[2]),
                                  
    //outputs19
    .clk_ctrl_reg19                        (clk_ctrl_reg_219),
    .counter_val_reg19                     (counter_val_reg_219),
    .cntr_ctrl_reg19                       (cntr_ctrl_reg_219),
    .interval_reg19                        (interval_reg_219),
    .match_1_reg19                         (match_1_reg_219),
    .match_2_reg19                         (match_2_reg_219),
    .match_3_reg19                         (match_3_reg_219),
    .interrupt19                           (TTC_int19[2]),
    .interrupt_reg19                       (interrupt_reg_219),
    .interrupt_en_reg19                    (interrupt_en_reg_219)
  );



  ttc_timer_counter_lite19 i_ttc_timer_counter_lite_319 ( 

    //inputs19
    .n_p_reset19                           (n_p_reset19), 
    .pclk19                                (pclk19),
    .pwdata19                              (pwdata19[15:0]),
    .clk_ctrl_reg_sel19                    (clk_ctrl_reg_sel_319),
    .cntr_ctrl_reg_sel19                   (cntr_ctrl_reg_sel_319),
    .interval_reg_sel19                    (interval_reg_sel_319),
    .match_1_reg_sel19                     (match_1_reg_sel_319),
    .match_2_reg_sel19                     (match_2_reg_sel_319),
    .match_3_reg_sel19                     (match_3_reg_sel_319),
    .intr_en_reg_sel19                     (intr_en_reg_sel19[3]),
    .clear_interrupt19                     (clear_interrupt19[3]),
                                              
    //outputs19
    .clk_ctrl_reg19                        (clk_ctrl_reg_319),
    .counter_val_reg19                     (counter_val_reg_319),
    .cntr_ctrl_reg19                       (cntr_ctrl_reg_319),
    .interval_reg19                        (interval_reg_319),
    .match_1_reg19                         (match_1_reg_319),
    .match_2_reg19                         (match_2_reg_319),
    .match_3_reg19                         (match_3_reg_319),
    .interrupt19                           (TTC_int19[3]),
    .interrupt_reg19                       (interrupt_reg_319),
    .interrupt_en_reg19                    (interrupt_en_reg_319)
  );





endmodule 
