//File21 name   : ttc_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : The top level of the Triple21 Timer21 Counter21.
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module21 definition21
//-----------------------------------------------------------------------------

module ttc_lite21(
           
           //inputs21
           n_p_reset21,
           pclk21,
           psel21,
           penable21,
           pwrite21,
           pwdata21,
           paddr21,
           scan_in21,
           scan_en21,

           //outputs21
           prdata21,
           interrupt21,
           scan_out21           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS21
//-----------------------------------------------------------------------------

   input         n_p_reset21;              //System21 Reset21
   input         pclk21;                 //System21 clock21
   input         psel21;                 //Select21 line
   input         penable21;              //Enable21
   input         pwrite21;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata21;               //Write data
   input [7:0]   paddr21;                //Address Bus21 register
   input         scan_in21;              //Scan21 chain21 input port
   input         scan_en21;              //Scan21 chain21 enable port
   
   output [31:0] prdata21;               //Read Data from the APB21 Interface21
   output [3:1]  interrupt21;            //Interrupt21 from PCI21 
   output        scan_out21;             //Scan21 chain21 output port

//-----------------------------------------------------------------------------
// Module21 Interconnect21
//-----------------------------------------------------------------------------
   wire [3:1] TTC_int21;
   wire        clk_ctrl_reg_sel_121;     //Module21 1 clock21 control21 select21
   wire        clk_ctrl_reg_sel_221;     //Module21 2 clock21 control21 select21
   wire        clk_ctrl_reg_sel_321;     //Module21 3 clock21 control21 select21
   wire        cntr_ctrl_reg_sel_121;    //Module21 1 counter control21 select21
   wire        cntr_ctrl_reg_sel_221;    //Module21 2 counter control21 select21
   wire        cntr_ctrl_reg_sel_321;    //Module21 3 counter control21 select21
   wire        interval_reg_sel_121;     //Interval21 1 register select21
   wire        interval_reg_sel_221;     //Interval21 2 register select21
   wire        interval_reg_sel_321;     //Interval21 3 register select21
   wire        match_1_reg_sel_121;      //Module21 1 match 1 select21
   wire        match_1_reg_sel_221;      //Module21 1 match 2 select21
   wire        match_1_reg_sel_321;      //Module21 1 match 3 select21
   wire        match_2_reg_sel_121;      //Module21 2 match 1 select21
   wire        match_2_reg_sel_221;      //Module21 2 match 2 select21
   wire        match_2_reg_sel_321;      //Module21 2 match 3 select21
   wire        match_3_reg_sel_121;      //Module21 3 match 1 select21
   wire        match_3_reg_sel_221;      //Module21 3 match 2 select21
   wire        match_3_reg_sel_321;      //Module21 3 match 3 select21
   wire [3:1]  intr_en_reg_sel21;        //Interrupt21 enable register select21
   wire [3:1]  clear_interrupt21;        //Clear interrupt21 signal21
   wire [5:0]  interrupt_reg_121;        //Interrupt21 register 1
   wire [5:0]  interrupt_reg_221;        //Interrupt21 register 2
   wire [5:0]  interrupt_reg_321;        //Interrupt21 register 3 
   wire [5:0]  interrupt_en_reg_121;     //Interrupt21 enable register 1
   wire [5:0]  interrupt_en_reg_221;     //Interrupt21 enable register 2
   wire [5:0]  interrupt_en_reg_321;     //Interrupt21 enable register 3
   wire [6:0]  clk_ctrl_reg_121;         //Clock21 control21 regs for the 
   wire [6:0]  clk_ctrl_reg_221;         //Timer_Counter21 1,2,3
   wire [6:0]  clk_ctrl_reg_321;         //Value of the clock21 frequency21
   wire [15:0] counter_val_reg_121;      //Module21 1 counter value 
   wire [15:0] counter_val_reg_221;      //Module21 2 counter value 
   wire [15:0] counter_val_reg_321;      //Module21 3 counter value 
   wire [6:0]  cntr_ctrl_reg_121;        //Module21 1 counter control21  
   wire [6:0]  cntr_ctrl_reg_221;        //Module21 2 counter control21  
   wire [6:0]  cntr_ctrl_reg_321;        //Module21 3 counter control21  
   wire [15:0] interval_reg_121;         //Module21 1 interval21 register
   wire [15:0] interval_reg_221;         //Module21 2 interval21 register
   wire [15:0] interval_reg_321;         //Module21 3 interval21 register
   wire [15:0] match_1_reg_121;          //Module21 1 match 1 register
   wire [15:0] match_1_reg_221;          //Module21 1 match 2 register
   wire [15:0] match_1_reg_321;          //Module21 1 match 3 register
   wire [15:0] match_2_reg_121;          //Module21 2 match 1 register
   wire [15:0] match_2_reg_221;          //Module21 2 match 2 register
   wire [15:0] match_2_reg_321;          //Module21 2 match 3 register
   wire [15:0] match_3_reg_121;          //Module21 3 match 1 register
   wire [15:0] match_3_reg_221;          //Module21 3 match 2 register
   wire [15:0] match_3_reg_321;          //Module21 3 match 3 register

  assign interrupt21 = TTC_int21;   // Bug21 Fix21 for floating21 ints - Santhosh21 8 Nov21 06
   

//-----------------------------------------------------------------------------
// Module21 Instantiations21
//-----------------------------------------------------------------------------


  ttc_interface_lite21 i_ttc_interface_lite21 ( 

    //inputs21
    .n_p_reset21                           (n_p_reset21),
    .pclk21                                (pclk21),
    .psel21                                (psel21),
    .penable21                             (penable21),
    .pwrite21                              (pwrite21),
    .paddr21                               (paddr21),
    .clk_ctrl_reg_121                      (clk_ctrl_reg_121),
    .clk_ctrl_reg_221                      (clk_ctrl_reg_221),
    .clk_ctrl_reg_321                      (clk_ctrl_reg_321),
    .cntr_ctrl_reg_121                     (cntr_ctrl_reg_121),
    .cntr_ctrl_reg_221                     (cntr_ctrl_reg_221),
    .cntr_ctrl_reg_321                     (cntr_ctrl_reg_321),
    .counter_val_reg_121                   (counter_val_reg_121),
    .counter_val_reg_221                   (counter_val_reg_221),
    .counter_val_reg_321                   (counter_val_reg_321),
    .interval_reg_121                      (interval_reg_121),
    .match_1_reg_121                       (match_1_reg_121),
    .match_2_reg_121                       (match_2_reg_121),
    .match_3_reg_121                       (match_3_reg_121),
    .interval_reg_221                      (interval_reg_221),
    .match_1_reg_221                       (match_1_reg_221),
    .match_2_reg_221                       (match_2_reg_221),
    .match_3_reg_221                       (match_3_reg_221),
    .interval_reg_321                      (interval_reg_321),
    .match_1_reg_321                       (match_1_reg_321),
    .match_2_reg_321                       (match_2_reg_321),
    .match_3_reg_321                       (match_3_reg_321),
    .interrupt_reg_121                     (interrupt_reg_121),
    .interrupt_reg_221                     (interrupt_reg_221),
    .interrupt_reg_321                     (interrupt_reg_321), 
    .interrupt_en_reg_121                  (interrupt_en_reg_121),
    .interrupt_en_reg_221                  (interrupt_en_reg_221),
    .interrupt_en_reg_321                  (interrupt_en_reg_321), 

    //outputs21
    .prdata21                              (prdata21),
    .clk_ctrl_reg_sel_121                  (clk_ctrl_reg_sel_121),
    .clk_ctrl_reg_sel_221                  (clk_ctrl_reg_sel_221),
    .clk_ctrl_reg_sel_321                  (clk_ctrl_reg_sel_321),
    .cntr_ctrl_reg_sel_121                 (cntr_ctrl_reg_sel_121),
    .cntr_ctrl_reg_sel_221                 (cntr_ctrl_reg_sel_221),
    .cntr_ctrl_reg_sel_321                 (cntr_ctrl_reg_sel_321),
    .interval_reg_sel_121                  (interval_reg_sel_121),  
    .interval_reg_sel_221                  (interval_reg_sel_221), 
    .interval_reg_sel_321                  (interval_reg_sel_321),
    .match_1_reg_sel_121                   (match_1_reg_sel_121),     
    .match_1_reg_sel_221                   (match_1_reg_sel_221),
    .match_1_reg_sel_321                   (match_1_reg_sel_321),                
    .match_2_reg_sel_121                   (match_2_reg_sel_121),
    .match_2_reg_sel_221                   (match_2_reg_sel_221),
    .match_2_reg_sel_321                   (match_2_reg_sel_321),
    .match_3_reg_sel_121                   (match_3_reg_sel_121),
    .match_3_reg_sel_221                   (match_3_reg_sel_221),
    .match_3_reg_sel_321                   (match_3_reg_sel_321),
    .intr_en_reg_sel21                     (intr_en_reg_sel21),
    .clear_interrupt21                     (clear_interrupt21)

  );


   

  ttc_timer_counter_lite21 i_ttc_timer_counter_lite_121 ( 

    //inputs21
    .n_p_reset21                           (n_p_reset21),
    .pclk21                                (pclk21), 
    .pwdata21                              (pwdata21[15:0]),
    .clk_ctrl_reg_sel21                    (clk_ctrl_reg_sel_121),
    .cntr_ctrl_reg_sel21                   (cntr_ctrl_reg_sel_121),
    .interval_reg_sel21                    (interval_reg_sel_121),
    .match_1_reg_sel21                     (match_1_reg_sel_121),
    .match_2_reg_sel21                     (match_2_reg_sel_121),
    .match_3_reg_sel21                     (match_3_reg_sel_121),
    .intr_en_reg_sel21                     (intr_en_reg_sel21[1]),
    .clear_interrupt21                     (clear_interrupt21[1]),
                                  
    //outputs21
    .clk_ctrl_reg21                        (clk_ctrl_reg_121),
    .counter_val_reg21                     (counter_val_reg_121),
    .cntr_ctrl_reg21                       (cntr_ctrl_reg_121),
    .interval_reg21                        (interval_reg_121),
    .match_1_reg21                         (match_1_reg_121),
    .match_2_reg21                         (match_2_reg_121),
    .match_3_reg21                         (match_3_reg_121),
    .interrupt21                           (TTC_int21[1]),
    .interrupt_reg21                       (interrupt_reg_121),
    .interrupt_en_reg21                    (interrupt_en_reg_121)
  );


  ttc_timer_counter_lite21 i_ttc_timer_counter_lite_221 ( 

    //inputs21
    .n_p_reset21                           (n_p_reset21), 
    .pclk21                                (pclk21),
    .pwdata21                              (pwdata21[15:0]),
    .clk_ctrl_reg_sel21                    (clk_ctrl_reg_sel_221),
    .cntr_ctrl_reg_sel21                   (cntr_ctrl_reg_sel_221),
    .interval_reg_sel21                    (interval_reg_sel_221),
    .match_1_reg_sel21                     (match_1_reg_sel_221),
    .match_2_reg_sel21                     (match_2_reg_sel_221),
    .match_3_reg_sel21                     (match_3_reg_sel_221),
    .intr_en_reg_sel21                     (intr_en_reg_sel21[2]),
    .clear_interrupt21                     (clear_interrupt21[2]),
                                  
    //outputs21
    .clk_ctrl_reg21                        (clk_ctrl_reg_221),
    .counter_val_reg21                     (counter_val_reg_221),
    .cntr_ctrl_reg21                       (cntr_ctrl_reg_221),
    .interval_reg21                        (interval_reg_221),
    .match_1_reg21                         (match_1_reg_221),
    .match_2_reg21                         (match_2_reg_221),
    .match_3_reg21                         (match_3_reg_221),
    .interrupt21                           (TTC_int21[2]),
    .interrupt_reg21                       (interrupt_reg_221),
    .interrupt_en_reg21                    (interrupt_en_reg_221)
  );



  ttc_timer_counter_lite21 i_ttc_timer_counter_lite_321 ( 

    //inputs21
    .n_p_reset21                           (n_p_reset21), 
    .pclk21                                (pclk21),
    .pwdata21                              (pwdata21[15:0]),
    .clk_ctrl_reg_sel21                    (clk_ctrl_reg_sel_321),
    .cntr_ctrl_reg_sel21                   (cntr_ctrl_reg_sel_321),
    .interval_reg_sel21                    (interval_reg_sel_321),
    .match_1_reg_sel21                     (match_1_reg_sel_321),
    .match_2_reg_sel21                     (match_2_reg_sel_321),
    .match_3_reg_sel21                     (match_3_reg_sel_321),
    .intr_en_reg_sel21                     (intr_en_reg_sel21[3]),
    .clear_interrupt21                     (clear_interrupt21[3]),
                                              
    //outputs21
    .clk_ctrl_reg21                        (clk_ctrl_reg_321),
    .counter_val_reg21                     (counter_val_reg_321),
    .cntr_ctrl_reg21                       (cntr_ctrl_reg_321),
    .interval_reg21                        (interval_reg_321),
    .match_1_reg21                         (match_1_reg_321),
    .match_2_reg21                         (match_2_reg_321),
    .match_3_reg21                         (match_3_reg_321),
    .interrupt21                           (TTC_int21[3]),
    .interrupt_reg21                       (interrupt_reg_321),
    .interrupt_en_reg21                    (interrupt_en_reg_321)
  );





endmodule 
