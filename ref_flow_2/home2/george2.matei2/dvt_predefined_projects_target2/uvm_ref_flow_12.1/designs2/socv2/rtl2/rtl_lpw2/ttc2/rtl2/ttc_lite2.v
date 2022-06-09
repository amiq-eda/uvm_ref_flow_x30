//File2 name   : ttc_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : The top level of the Triple2 Timer2 Counter2.
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module2 definition2
//-----------------------------------------------------------------------------

module ttc_lite2(
           
           //inputs2
           n_p_reset2,
           pclk2,
           psel2,
           penable2,
           pwrite2,
           pwdata2,
           paddr2,
           scan_in2,
           scan_en2,

           //outputs2
           prdata2,
           interrupt2,
           scan_out2           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS2
//-----------------------------------------------------------------------------

   input         n_p_reset2;              //System2 Reset2
   input         pclk2;                 //System2 clock2
   input         psel2;                 //Select2 line
   input         penable2;              //Enable2
   input         pwrite2;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata2;               //Write data
   input [7:0]   paddr2;                //Address Bus2 register
   input         scan_in2;              //Scan2 chain2 input port
   input         scan_en2;              //Scan2 chain2 enable port
   
   output [31:0] prdata2;               //Read Data from the APB2 Interface2
   output [3:1]  interrupt2;            //Interrupt2 from PCI2 
   output        scan_out2;             //Scan2 chain2 output port

//-----------------------------------------------------------------------------
// Module2 Interconnect2
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int2;
   wire        clk_ctrl_reg_sel_12;     //Module2 1 clock2 control2 select2
   wire        clk_ctrl_reg_sel_22;     //Module2 2 clock2 control2 select2
   wire        clk_ctrl_reg_sel_32;     //Module2 3 clock2 control2 select2
   wire        cntr_ctrl_reg_sel_12;    //Module2 1 counter control2 select2
   wire        cntr_ctrl_reg_sel_22;    //Module2 2 counter control2 select2
   wire        cntr_ctrl_reg_sel_32;    //Module2 3 counter control2 select2
   wire        interval_reg_sel_12;     //Interval2 1 register select2
   wire        interval_reg_sel_22;     //Interval2 2 register select2
   wire        interval_reg_sel_32;     //Interval2 3 register select2
   wire        match_1_reg_sel_12;      //Module2 1 match 1 select2
   wire        match_1_reg_sel_22;      //Module2 1 match 2 select2
   wire        match_1_reg_sel_32;      //Module2 1 match 3 select2
   wire        match_2_reg_sel_12;      //Module2 2 match 1 select2
   wire        match_2_reg_sel_22;      //Module2 2 match 2 select2
   wire        match_2_reg_sel_32;      //Module2 2 match 3 select2
   wire        match_3_reg_sel_12;      //Module2 3 match 1 select2
   wire        match_3_reg_sel_22;      //Module2 3 match 2 select2
   wire        match_3_reg_sel_32;      //Module2 3 match 3 select2
   wire [3:1]  intr_en_reg_sel2;        //Interrupt2 enable register select2
   wire [3:1]  clear_interrupt2;        //Clear interrupt2 signal2
   wire [5:0]  interrupt_reg_12;        //Interrupt2 register 1
   wire [5:0]  interrupt_reg_22;        //Interrupt2 register 2
   wire [5:0]  interrupt_reg_32;        //Interrupt2 register 3 
   wire [5:0]  interrupt_en_reg_12;     //Interrupt2 enable register 1
   wire [5:0]  interrupt_en_reg_22;     //Interrupt2 enable register 2
   wire [5:0]  interrupt_en_reg_32;     //Interrupt2 enable register 3
   wire [6:0]  clk_ctrl_reg_12;         //Clock2 control2 regs for the 
   wire [6:0]  clk_ctrl_reg_22;         //Timer_Counter2 1,2,3
   wire [6:0]  clk_ctrl_reg_32;         //Value of the clock2 frequency2
   wire [15:0] counter_val_reg_12;      //Module2 1 counter value 
   wire [15:0] counter_val_reg_22;      //Module2 2 counter value 
   wire [15:0] counter_val_reg_32;      //Module2 3 counter value 
   wire [6:0]  cntr_ctrl_reg_12;        //Module2 1 counter control2  
   wire [6:0]  cntr_ctrl_reg_22;        //Module2 2 counter control2  
   wire [6:0]  cntr_ctrl_reg_32;        //Module2 3 counter control2  
   wire [15:0] interval_reg_12;         //Module2 1 interval2 register
   wire [15:0] interval_reg_22;         //Module2 2 interval2 register
   wire [15:0] interval_reg_32;         //Module2 3 interval2 register
   wire [15:0] match_1_reg_12;          //Module2 1 match 1 register
   wire [15:0] match_1_reg_22;          //Module2 1 match 2 register
   wire [15:0] match_1_reg_32;          //Module2 1 match 3 register
   wire [15:0] match_2_reg_12;          //Module2 2 match 1 register
   wire [15:0] match_2_reg_22;          //Module2 2 match 2 register
   wire [15:0] match_2_reg_32;          //Module2 2 match 3 register
   wire [15:0] match_3_reg_12;          //Module2 3 match 1 register
   wire [15:0] match_3_reg_22;          //Module2 3 match 2 register
   wire [15:0] match_3_reg_32;          //Module2 3 match 3 register

  assign interrupt2 = TTC_int2;   // Bug2 Fix2 for floating2 ints - Santhosh2 8 Nov2 06
   

//-----------------------------------------------------------------------------
// Module2 Instantiations2
//-----------------------------------------------------------------------------


  ttc_interface_lite2 i_ttc_interface_lite2 ( 

    //inputs2
    .n_p_reset2                           (n_p_reset2),
    .pclk2                                (pclk2),
    .psel2                                (psel2),
    .penable2                             (penable2),
    .pwrite2                              (pwrite2),
    .paddr2                               (paddr2),
    .clk_ctrl_reg_12                      (clk_ctrl_reg_12),
    .clk_ctrl_reg_22                      (clk_ctrl_reg_22),
    .clk_ctrl_reg_32                      (clk_ctrl_reg_32),
    .cntr_ctrl_reg_12                     (cntr_ctrl_reg_12),
    .cntr_ctrl_reg_22                     (cntr_ctrl_reg_22),
    .cntr_ctrl_reg_32                     (cntr_ctrl_reg_32),
    .counter_val_reg_12                   (counter_val_reg_12),
    .counter_val_reg_22                   (counter_val_reg_22),
    .counter_val_reg_32                   (counter_val_reg_32),
    .interval_reg_12                      (interval_reg_12),
    .match_1_reg_12                       (match_1_reg_12),
    .match_2_reg_12                       (match_2_reg_12),
    .match_3_reg_12                       (match_3_reg_12),
    .interval_reg_22                      (interval_reg_22),
    .match_1_reg_22                       (match_1_reg_22),
    .match_2_reg_22                       (match_2_reg_22),
    .match_3_reg_22                       (match_3_reg_22),
    .interval_reg_32                      (interval_reg_32),
    .match_1_reg_32                       (match_1_reg_32),
    .match_2_reg_32                       (match_2_reg_32),
    .match_3_reg_32                       (match_3_reg_32),
    .interrupt_reg_12                     (interrupt_reg_12),
    .interrupt_reg_22                     (interrupt_reg_22),
    .interrupt_reg_32                     (interrupt_reg_32), 
    .interrupt_en_reg_12                  (interrupt_en_reg_12),
    .interrupt_en_reg_22                  (interrupt_en_reg_22),
    .interrupt_en_reg_32                  (interrupt_en_reg_32), 

    //outputs2
    .prdata2                              (prdata2),
    .clk_ctrl_reg_sel_12                  (clk_ctrl_reg_sel_12),
    .clk_ctrl_reg_sel_22                  (clk_ctrl_reg_sel_22),
    .clk_ctrl_reg_sel_32                  (clk_ctrl_reg_sel_32),
    .cntr_ctrl_reg_sel_12                 (cntr_ctrl_reg_sel_12),
    .cntr_ctrl_reg_sel_22                 (cntr_ctrl_reg_sel_22),
    .cntr_ctrl_reg_sel_32                 (cntr_ctrl_reg_sel_32),
    .interval_reg_sel_12                  (interval_reg_sel_12),  
    .interval_reg_sel_22                  (interval_reg_sel_22), 
    .interval_reg_sel_32                  (interval_reg_sel_32),
    .match_1_reg_sel_12                   (match_1_reg_sel_12),     
    .match_1_reg_sel_22                   (match_1_reg_sel_22),
    .match_1_reg_sel_32                   (match_1_reg_sel_32),                
    .match_2_reg_sel_12                   (match_2_reg_sel_12),
    .match_2_reg_sel_22                   (match_2_reg_sel_22),
    .match_2_reg_sel_32                   (match_2_reg_sel_32),
    .match_3_reg_sel_12                   (match_3_reg_sel_12),
    .match_3_reg_sel_22                   (match_3_reg_sel_22),
    .match_3_reg_sel_32                   (match_3_reg_sel_32),
    .intr_en_reg_sel2                     (intr_en_reg_sel2),
    .clear_interrupt2                     (clear_interrupt2)

  );


   

  ttc_timer_counter_lite2 i_ttc_timer_counter_lite_12 ( 

    //inputs2
    .n_p_reset2                           (n_p_reset2),
    .pclk2                                (pclk2), 
    .pwdata2                              (pwdata2[15:0]),
    .clk_ctrl_reg_sel2                    (clk_ctrl_reg_sel_12),
    .cntr_ctrl_reg_sel2                   (cntr_ctrl_reg_sel_12),
    .interval_reg_sel2                    (interval_reg_sel_12),
    .match_1_reg_sel2                     (match_1_reg_sel_12),
    .match_2_reg_sel2                     (match_2_reg_sel_12),
    .match_3_reg_sel2                     (match_3_reg_sel_12),
    .intr_en_reg_sel2                     (intr_en_reg_sel2[1]),
    .clear_interrupt2                     (clear_interrupt2[1]),
                                  
    //outputs2
    .clk_ctrl_reg2                        (clk_ctrl_reg_12),
    .counter_val_reg2                     (counter_val_reg_12),
    .cntr_ctrl_reg2                       (cntr_ctrl_reg_12),
    .interval_reg2                        (interval_reg_12),
    .match_1_reg2                         (match_1_reg_12),
    .match_2_reg2                         (match_2_reg_12),
    .match_3_reg2                         (match_3_reg_12),
    .interrupt2                           (TTC_int2[1]),
    .interrupt_reg2                       (interrupt_reg_12),
    .interrupt_en_reg2                    (interrupt_en_reg_12)
  );


  ttc_timer_counter_lite2 i_ttc_timer_counter_lite_22 ( 

    //inputs2
    .n_p_reset2                           (n_p_reset2), 
    .pclk2                                (pclk2),
    .pwdata2                              (pwdata2[15:0]),
    .clk_ctrl_reg_sel2                    (clk_ctrl_reg_sel_22),
    .cntr_ctrl_reg_sel2                   (cntr_ctrl_reg_sel_22),
    .interval_reg_sel2                    (interval_reg_sel_22),
    .match_1_reg_sel2                     (match_1_reg_sel_22),
    .match_2_reg_sel2                     (match_2_reg_sel_22),
    .match_3_reg_sel2                     (match_3_reg_sel_22),
    .intr_en_reg_sel2                     (intr_en_reg_sel2[2]),
    .clear_interrupt2                     (clear_interrupt2[2]),
                                  
    //outputs2
    .clk_ctrl_reg2                        (clk_ctrl_reg_22),
    .counter_val_reg2                     (counter_val_reg_22),
    .cntr_ctrl_reg2                       (cntr_ctrl_reg_22),
    .interval_reg2                        (interval_reg_22),
    .match_1_reg2                         (match_1_reg_22),
    .match_2_reg2                         (match_2_reg_22),
    .match_3_reg2                         (match_3_reg_22),
    .interrupt2                           (TTC_int2[2]),
    .interrupt_reg2                       (interrupt_reg_22),
    .interrupt_en_reg2                    (interrupt_en_reg_22)
  );



  ttc_timer_counter_lite2 i_ttc_timer_counter_lite_32 ( 

    //inputs2
    .n_p_reset2                           (n_p_reset2), 
    .pclk2                                (pclk2),
    .pwdata2                              (pwdata2[15:0]),
    .clk_ctrl_reg_sel2                    (clk_ctrl_reg_sel_32),
    .cntr_ctrl_reg_sel2                   (cntr_ctrl_reg_sel_32),
    .interval_reg_sel2                    (interval_reg_sel_32),
    .match_1_reg_sel2                     (match_1_reg_sel_32),
    .match_2_reg_sel2                     (match_2_reg_sel_32),
    .match_3_reg_sel2                     (match_3_reg_sel_32),
    .intr_en_reg_sel2                     (intr_en_reg_sel2[3]),
    .clear_interrupt2                     (clear_interrupt2[3]),
                                              
    //outputs2
    .clk_ctrl_reg2                        (clk_ctrl_reg_32),
    .counter_val_reg2                     (counter_val_reg_32),
    .cntr_ctrl_reg2                       (cntr_ctrl_reg_32),
    .interval_reg2                        (interval_reg_32),
    .match_1_reg2                         (match_1_reg_32),
    .match_2_reg2                         (match_2_reg_32),
    .match_3_reg2                         (match_3_reg_32),
    .interrupt2                           (TTC_int2[3]),
    .interrupt_reg2                       (interrupt_reg_32),
    .interrupt_en_reg2                    (interrupt_en_reg_32)
  );





endmodule 
