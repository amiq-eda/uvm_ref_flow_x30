//File22 name   : ttc_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : The top level of the Triple22 Timer22 Counter22.
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module22 definition22
//-----------------------------------------------------------------------------

module ttc_lite22(
           
           //inputs22
           n_p_reset22,
           pclk22,
           psel22,
           penable22,
           pwrite22,
           pwdata22,
           paddr22,
           scan_in22,
           scan_en22,

           //outputs22
           prdata22,
           interrupt22,
           scan_out22           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS22
//-----------------------------------------------------------------------------

   input         n_p_reset22;              //System22 Reset22
   input         pclk22;                 //System22 clock22
   input         psel22;                 //Select22 line
   input         penable22;              //Enable22
   input         pwrite22;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata22;               //Write data
   input [7:0]   paddr22;                //Address Bus22 register
   input         scan_in22;              //Scan22 chain22 input port
   input         scan_en22;              //Scan22 chain22 enable port
   
   output [31:0] prdata22;               //Read Data from the APB22 Interface22
   output [3:1]  interrupt22;            //Interrupt22 from PCI22 
   output        scan_out22;             //Scan22 chain22 output port

//-----------------------------------------------------------------------------
// Module22 Interconnect22
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int22;
   wire        clk_ctrl_reg_sel_122;     //Module22 1 clock22 control22 select22
   wire        clk_ctrl_reg_sel_222;     //Module22 2 clock22 control22 select22
   wire        clk_ctrl_reg_sel_322;     //Module22 3 clock22 control22 select22
   wire        cntr_ctrl_reg_sel_122;    //Module22 1 counter control22 select22
   wire        cntr_ctrl_reg_sel_222;    //Module22 2 counter control22 select22
   wire        cntr_ctrl_reg_sel_322;    //Module22 3 counter control22 select22
   wire        interval_reg_sel_122;     //Interval22 1 register select22
   wire        interval_reg_sel_222;     //Interval22 2 register select22
   wire        interval_reg_sel_322;     //Interval22 3 register select22
   wire        match_1_reg_sel_122;      //Module22 1 match 1 select22
   wire        match_1_reg_sel_222;      //Module22 1 match 2 select22
   wire        match_1_reg_sel_322;      //Module22 1 match 3 select22
   wire        match_2_reg_sel_122;      //Module22 2 match 1 select22
   wire        match_2_reg_sel_222;      //Module22 2 match 2 select22
   wire        match_2_reg_sel_322;      //Module22 2 match 3 select22
   wire        match_3_reg_sel_122;      //Module22 3 match 1 select22
   wire        match_3_reg_sel_222;      //Module22 3 match 2 select22
   wire        match_3_reg_sel_322;      //Module22 3 match 3 select22
   wire [3:1]  intr_en_reg_sel22;        //Interrupt22 enable register select22
   wire [3:1]  clear_interrupt22;        //Clear interrupt22 signal22
   wire [5:0]  interrupt_reg_122;        //Interrupt22 register 1
   wire [5:0]  interrupt_reg_222;        //Interrupt22 register 2
   wire [5:0]  interrupt_reg_322;        //Interrupt22 register 3 
   wire [5:0]  interrupt_en_reg_122;     //Interrupt22 enable register 1
   wire [5:0]  interrupt_en_reg_222;     //Interrupt22 enable register 2
   wire [5:0]  interrupt_en_reg_322;     //Interrupt22 enable register 3
   wire [6:0]  clk_ctrl_reg_122;         //Clock22 control22 regs for the 
   wire [6:0]  clk_ctrl_reg_222;         //Timer_Counter22 1,2,3
   wire [6:0]  clk_ctrl_reg_322;         //Value of the clock22 frequency22
   wire [15:0] counter_val_reg_122;      //Module22 1 counter value 
   wire [15:0] counter_val_reg_222;      //Module22 2 counter value 
   wire [15:0] counter_val_reg_322;      //Module22 3 counter value 
   wire [6:0]  cntr_ctrl_reg_122;        //Module22 1 counter control22  
   wire [6:0]  cntr_ctrl_reg_222;        //Module22 2 counter control22  
   wire [6:0]  cntr_ctrl_reg_322;        //Module22 3 counter control22  
   wire [15:0] interval_reg_122;         //Module22 1 interval22 register
   wire [15:0] interval_reg_222;         //Module22 2 interval22 register
   wire [15:0] interval_reg_322;         //Module22 3 interval22 register
   wire [15:0] match_1_reg_122;          //Module22 1 match 1 register
   wire [15:0] match_1_reg_222;          //Module22 1 match 2 register
   wire [15:0] match_1_reg_322;          //Module22 1 match 3 register
   wire [15:0] match_2_reg_122;          //Module22 2 match 1 register
   wire [15:0] match_2_reg_222;          //Module22 2 match 2 register
   wire [15:0] match_2_reg_322;          //Module22 2 match 3 register
   wire [15:0] match_3_reg_122;          //Module22 3 match 1 register
   wire [15:0] match_3_reg_222;          //Module22 3 match 2 register
   wire [15:0] match_3_reg_322;          //Module22 3 match 3 register

  assign interrupt22 = TTC_int22;   // Bug22 Fix22 for floating22 ints - Santhosh22 8 Nov22 06
   

//-----------------------------------------------------------------------------
// Module22 Instantiations22
//-----------------------------------------------------------------------------


  ttc_interface_lite22 i_ttc_interface_lite22 ( 

    //inputs22
    .n_p_reset22                           (n_p_reset22),
    .pclk22                                (pclk22),
    .psel22                                (psel22),
    .penable22                             (penable22),
    .pwrite22                              (pwrite22),
    .paddr22                               (paddr22),
    .clk_ctrl_reg_122                      (clk_ctrl_reg_122),
    .clk_ctrl_reg_222                      (clk_ctrl_reg_222),
    .clk_ctrl_reg_322                      (clk_ctrl_reg_322),
    .cntr_ctrl_reg_122                     (cntr_ctrl_reg_122),
    .cntr_ctrl_reg_222                     (cntr_ctrl_reg_222),
    .cntr_ctrl_reg_322                     (cntr_ctrl_reg_322),
    .counter_val_reg_122                   (counter_val_reg_122),
    .counter_val_reg_222                   (counter_val_reg_222),
    .counter_val_reg_322                   (counter_val_reg_322),
    .interval_reg_122                      (interval_reg_122),
    .match_1_reg_122                       (match_1_reg_122),
    .match_2_reg_122                       (match_2_reg_122),
    .match_3_reg_122                       (match_3_reg_122),
    .interval_reg_222                      (interval_reg_222),
    .match_1_reg_222                       (match_1_reg_222),
    .match_2_reg_222                       (match_2_reg_222),
    .match_3_reg_222                       (match_3_reg_222),
    .interval_reg_322                      (interval_reg_322),
    .match_1_reg_322                       (match_1_reg_322),
    .match_2_reg_322                       (match_2_reg_322),
    .match_3_reg_322                       (match_3_reg_322),
    .interrupt_reg_122                     (interrupt_reg_122),
    .interrupt_reg_222                     (interrupt_reg_222),
    .interrupt_reg_322                     (interrupt_reg_322), 
    .interrupt_en_reg_122                  (interrupt_en_reg_122),
    .interrupt_en_reg_222                  (interrupt_en_reg_222),
    .interrupt_en_reg_322                  (interrupt_en_reg_322), 

    //outputs22
    .prdata22                              (prdata22),
    .clk_ctrl_reg_sel_122                  (clk_ctrl_reg_sel_122),
    .clk_ctrl_reg_sel_222                  (clk_ctrl_reg_sel_222),
    .clk_ctrl_reg_sel_322                  (clk_ctrl_reg_sel_322),
    .cntr_ctrl_reg_sel_122                 (cntr_ctrl_reg_sel_122),
    .cntr_ctrl_reg_sel_222                 (cntr_ctrl_reg_sel_222),
    .cntr_ctrl_reg_sel_322                 (cntr_ctrl_reg_sel_322),
    .interval_reg_sel_122                  (interval_reg_sel_122),  
    .interval_reg_sel_222                  (interval_reg_sel_222), 
    .interval_reg_sel_322                  (interval_reg_sel_322),
    .match_1_reg_sel_122                   (match_1_reg_sel_122),     
    .match_1_reg_sel_222                   (match_1_reg_sel_222),
    .match_1_reg_sel_322                   (match_1_reg_sel_322),                
    .match_2_reg_sel_122                   (match_2_reg_sel_122),
    .match_2_reg_sel_222                   (match_2_reg_sel_222),
    .match_2_reg_sel_322                   (match_2_reg_sel_322),
    .match_3_reg_sel_122                   (match_3_reg_sel_122),
    .match_3_reg_sel_222                   (match_3_reg_sel_222),
    .match_3_reg_sel_322                   (match_3_reg_sel_322),
    .intr_en_reg_sel22                     (intr_en_reg_sel22),
    .clear_interrupt22                     (clear_interrupt22)

  );


   

  ttc_timer_counter_lite22 i_ttc_timer_counter_lite_122 ( 

    //inputs22
    .n_p_reset22                           (n_p_reset22),
    .pclk22                                (pclk22), 
    .pwdata22                              (pwdata22[15:0]),
    .clk_ctrl_reg_sel22                    (clk_ctrl_reg_sel_122),
    .cntr_ctrl_reg_sel22                   (cntr_ctrl_reg_sel_122),
    .interval_reg_sel22                    (interval_reg_sel_122),
    .match_1_reg_sel22                     (match_1_reg_sel_122),
    .match_2_reg_sel22                     (match_2_reg_sel_122),
    .match_3_reg_sel22                     (match_3_reg_sel_122),
    .intr_en_reg_sel22                     (intr_en_reg_sel22[1]),
    .clear_interrupt22                     (clear_interrupt22[1]),
                                  
    //outputs22
    .clk_ctrl_reg22                        (clk_ctrl_reg_122),
    .counter_val_reg22                     (counter_val_reg_122),
    .cntr_ctrl_reg22                       (cntr_ctrl_reg_122),
    .interval_reg22                        (interval_reg_122),
    .match_1_reg22                         (match_1_reg_122),
    .match_2_reg22                         (match_2_reg_122),
    .match_3_reg22                         (match_3_reg_122),
    .interrupt22                           (TTC_int22[1]),
    .interrupt_reg22                       (interrupt_reg_122),
    .interrupt_en_reg22                    (interrupt_en_reg_122)
  );


  ttc_timer_counter_lite22 i_ttc_timer_counter_lite_222 ( 

    //inputs22
    .n_p_reset22                           (n_p_reset22), 
    .pclk22                                (pclk22),
    .pwdata22                              (pwdata22[15:0]),
    .clk_ctrl_reg_sel22                    (clk_ctrl_reg_sel_222),
    .cntr_ctrl_reg_sel22                   (cntr_ctrl_reg_sel_222),
    .interval_reg_sel22                    (interval_reg_sel_222),
    .match_1_reg_sel22                     (match_1_reg_sel_222),
    .match_2_reg_sel22                     (match_2_reg_sel_222),
    .match_3_reg_sel22                     (match_3_reg_sel_222),
    .intr_en_reg_sel22                     (intr_en_reg_sel22[2]),
    .clear_interrupt22                     (clear_interrupt22[2]),
                                  
    //outputs22
    .clk_ctrl_reg22                        (clk_ctrl_reg_222),
    .counter_val_reg22                     (counter_val_reg_222),
    .cntr_ctrl_reg22                       (cntr_ctrl_reg_222),
    .interval_reg22                        (interval_reg_222),
    .match_1_reg22                         (match_1_reg_222),
    .match_2_reg22                         (match_2_reg_222),
    .match_3_reg22                         (match_3_reg_222),
    .interrupt22                           (TTC_int22[2]),
    .interrupt_reg22                       (interrupt_reg_222),
    .interrupt_en_reg22                    (interrupt_en_reg_222)
  );



  ttc_timer_counter_lite22 i_ttc_timer_counter_lite_322 ( 

    //inputs22
    .n_p_reset22                           (n_p_reset22), 
    .pclk22                                (pclk22),
    .pwdata22                              (pwdata22[15:0]),
    .clk_ctrl_reg_sel22                    (clk_ctrl_reg_sel_322),
    .cntr_ctrl_reg_sel22                   (cntr_ctrl_reg_sel_322),
    .interval_reg_sel22                    (interval_reg_sel_322),
    .match_1_reg_sel22                     (match_1_reg_sel_322),
    .match_2_reg_sel22                     (match_2_reg_sel_322),
    .match_3_reg_sel22                     (match_3_reg_sel_322),
    .intr_en_reg_sel22                     (intr_en_reg_sel22[3]),
    .clear_interrupt22                     (clear_interrupt22[3]),
                                              
    //outputs22
    .clk_ctrl_reg22                        (clk_ctrl_reg_322),
    .counter_val_reg22                     (counter_val_reg_322),
    .cntr_ctrl_reg22                       (cntr_ctrl_reg_322),
    .interval_reg22                        (interval_reg_322),
    .match_1_reg22                         (match_1_reg_322),
    .match_2_reg22                         (match_2_reg_322),
    .match_3_reg22                         (match_3_reg_322),
    .interrupt22                           (TTC_int22[3]),
    .interrupt_reg22                       (interrupt_reg_322),
    .interrupt_en_reg22                    (interrupt_en_reg_322)
  );





endmodule 
