//File21 name   : ttc_timer_counter_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : An21 instantiation21 of counter modules21.
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

module ttc_timer_counter_lite21(

   //inputs21
   n_p_reset21,    
   pclk21,                         
   pwdata21,                              
   clk_ctrl_reg_sel21,
   cntr_ctrl_reg_sel21,
   interval_reg_sel21, 
   match_1_reg_sel21,
   match_2_reg_sel21,
   match_3_reg_sel21,
   intr_en_reg_sel21,
   clear_interrupt21,
                 
   //outputs21             
   clk_ctrl_reg21, 
   counter_val_reg21,
   cntr_ctrl_reg21,
   interval_reg21,
   match_1_reg21,
   match_2_reg21,
   match_3_reg21,
   interrupt21,
   interrupt_reg21,
   interrupt_en_reg21
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS21
//-----------------------------------------------------------------------------

   //inputs21
   input         n_p_reset21;            //reset signal21
   input         pclk21;                 //APB21 system clock21
   input [15:0]  pwdata21;               //16 Bit21 data signal21
   input         clk_ctrl_reg_sel21;     //Select21 clk_ctrl_reg21 from prescaler21
   input         cntr_ctrl_reg_sel21;    //Select21 control21 reg from counter.
   input         interval_reg_sel21;     //Select21 Interval21 reg from counter.
   input         match_1_reg_sel21;      //Select21 match_1_reg21 from counter. 
   input         match_2_reg_sel21;      //Select21 match_2_reg21 from counter.
   input         match_3_reg_sel21;      //Select21 match_3_reg21 from counter.
   input         intr_en_reg_sel21;      //Select21 interrupt21 register.
   input         clear_interrupt21;      //Clear interrupt21
   
   //Outputs21
   output [15:0]  counter_val_reg21;     //Counter21 value register from counter. 
   output [6:0]   clk_ctrl_reg21;        //Clock21 control21 reg from prescaler21.
   output [6:0]   cntr_ctrl_reg21;     //Counter21 control21 register 1.
   output [15:0]  interval_reg21;        //Interval21 register from counter.
   output [15:0]  match_1_reg21;         //Match21 1 register sent21 from counter. 
   output [15:0]  match_2_reg21;         //Match21 2 register sent21 from counter. 
   output [15:0]  match_3_reg21;         //Match21 3 register sent21 from counter. 
   output         interrupt21;
   output [5:0]   interrupt_reg21;
   output [5:0]   interrupt_en_reg21;
   
//-----------------------------------------------------------------------------
// Module21 Interconnect21
//-----------------------------------------------------------------------------

   wire count_en21;
   wire interval_intr21;          //Interval21 overflow21 interrupt21
   wire [3:1] match_intr21;       //Match21 interrupts21
   wire overflow_intr21;          //Overflow21 interupt21   
   wire [6:0] cntr_ctrl_reg21;    //Counter21 control21 register
   
//-----------------------------------------------------------------------------
// Module21 Instantiations21
//-----------------------------------------------------------------------------


    //outputs21

  ttc_count_rst_lite21 i_ttc_count_rst_lite21(

    //inputs21
    .n_p_reset21                              (n_p_reset21),   
    .pclk21                                   (pclk21),                             
    .pwdata21                                 (pwdata21[6:0]),
    .clk_ctrl_reg_sel21                       (clk_ctrl_reg_sel21),
    .restart21                                (cntr_ctrl_reg21[4]),
                         
    //outputs21        
    .count_en_out21                           (count_en21),                         
    .clk_ctrl_reg_out21                       (clk_ctrl_reg21)

  );


  ttc_counter_lite21 i_ttc_counter_lite21(

    //inputs21
    .n_p_reset21                              (n_p_reset21),  
    .pclk21                                   (pclk21),                          
    .pwdata21                                 (pwdata21),                           
    .count_en21                               (count_en21),
    .cntr_ctrl_reg_sel21                      (cntr_ctrl_reg_sel21), 
    .interval_reg_sel21                       (interval_reg_sel21),
    .match_1_reg_sel21                        (match_1_reg_sel21),
    .match_2_reg_sel21                        (match_2_reg_sel21),
    .match_3_reg_sel21                        (match_3_reg_sel21),

    //outputs21
    .count_val_out21                          (counter_val_reg21),
    .cntr_ctrl_reg_out21                      (cntr_ctrl_reg21),
    .interval_reg_out21                       (interval_reg21),
    .match_1_reg_out21                        (match_1_reg21),
    .match_2_reg_out21                        (match_2_reg21),
    .match_3_reg_out21                        (match_3_reg21),
    .interval_intr21                          (interval_intr21),
    .match_intr21                             (match_intr21),
    .overflow_intr21                          (overflow_intr21)
    
  );

  ttc_interrupt_lite21 i_ttc_interrupt_lite21(

    //inputs21
    .n_p_reset21                           (n_p_reset21), 
    .pwdata21                              (pwdata21[5:0]),
    .pclk21                                (pclk21),
    .intr_en_reg_sel21                     (intr_en_reg_sel21), 
    .clear_interrupt21                     (clear_interrupt21),
    .interval_intr21                       (interval_intr21),
    .match_intr21                          (match_intr21),
    .overflow_intr21                       (overflow_intr21),
    .restart21                             (cntr_ctrl_reg21[4]),

    //outputs21
    .interrupt21                           (interrupt21),
    .interrupt_reg_out21                   (interrupt_reg21),
    .interrupt_en_out21                    (interrupt_en_reg21)
                       
  );


   
endmodule
