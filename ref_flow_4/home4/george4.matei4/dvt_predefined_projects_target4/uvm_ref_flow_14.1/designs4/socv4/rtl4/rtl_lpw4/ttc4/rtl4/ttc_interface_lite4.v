//File4 name   : ttc_interface_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : The APB4 interface with the triple4 timer4 counter
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module4 definition4
//----------------------------------------------------------------------------

module ttc_interface_lite4( 

  //inputs4
  n_p_reset4,    
  pclk4,                          
  psel4,
  penable4,
  pwrite4,
  paddr4,
  clk_ctrl_reg_14,
  clk_ctrl_reg_24,
  clk_ctrl_reg_34,
  cntr_ctrl_reg_14,
  cntr_ctrl_reg_24,
  cntr_ctrl_reg_34,
  counter_val_reg_14,
  counter_val_reg_24,
  counter_val_reg_34,
  interval_reg_14,
  match_1_reg_14,
  match_2_reg_14,
  match_3_reg_14,
  interval_reg_24,
  match_1_reg_24,
  match_2_reg_24,
  match_3_reg_24,
  interval_reg_34,
  match_1_reg_34,
  match_2_reg_34,
  match_3_reg_34,
  interrupt_reg_14,
  interrupt_reg_24,
  interrupt_reg_34,      
  interrupt_en_reg_14,
  interrupt_en_reg_24,
  interrupt_en_reg_34,
                  
  //outputs4
  prdata4,
  clk_ctrl_reg_sel_14,
  clk_ctrl_reg_sel_24,
  clk_ctrl_reg_sel_34,
  cntr_ctrl_reg_sel_14,
  cntr_ctrl_reg_sel_24,
  cntr_ctrl_reg_sel_34,
  interval_reg_sel_14,                            
  interval_reg_sel_24,                          
  interval_reg_sel_34,
  match_1_reg_sel_14,                          
  match_1_reg_sel_24,                          
  match_1_reg_sel_34,                
  match_2_reg_sel_14,                          
  match_2_reg_sel_24,
  match_2_reg_sel_34,
  match_3_reg_sel_14,                          
  match_3_reg_sel_24,                         
  match_3_reg_sel_34,
  intr_en_reg_sel4,
  clear_interrupt4        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS4
//----------------------------------------------------------------------------

   //inputs4
   input        n_p_reset4;              //reset signal4
   input        pclk4;                 //System4 Clock4
   input        psel4;                 //Select4 line
   input        penable4;              //Strobe4 line
   input        pwrite4;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr4;                //Address Bus4 register
   input [6:0]  clk_ctrl_reg_14;       //Clock4 Control4 reg for Timer_Counter4 1
   input [6:0]  cntr_ctrl_reg_14;      //Counter4 Control4 reg for Timer_Counter4 1
   input [6:0]  clk_ctrl_reg_24;       //Clock4 Control4 reg for Timer_Counter4 2
   input [6:0]  cntr_ctrl_reg_24;      //Counter4 Control4 reg for Timer4 Counter4 2
   input [6:0]  clk_ctrl_reg_34;       //Clock4 Control4 reg Timer_Counter4 3
   input [6:0]  cntr_ctrl_reg_34;      //Counter4 Control4 reg for Timer4 Counter4 3
   input [15:0] counter_val_reg_14;    //Counter4 Value from Timer_Counter4 1
   input [15:0] counter_val_reg_24;    //Counter4 Value from Timer_Counter4 2
   input [15:0] counter_val_reg_34;    //Counter4 Value from Timer_Counter4 3
   input [15:0] interval_reg_14;       //Interval4 reg value from Timer_Counter4 1
   input [15:0] match_1_reg_14;        //Match4 reg value from Timer_Counter4 
   input [15:0] match_2_reg_14;        //Match4 reg value from Timer_Counter4     
   input [15:0] match_3_reg_14;        //Match4 reg value from Timer_Counter4 
   input [15:0] interval_reg_24;       //Interval4 reg value from Timer_Counter4 2
   input [15:0] match_1_reg_24;        //Match4 reg value from Timer_Counter4     
   input [15:0] match_2_reg_24;        //Match4 reg value from Timer_Counter4     
   input [15:0] match_3_reg_24;        //Match4 reg value from Timer_Counter4 
   input [15:0] interval_reg_34;       //Interval4 reg value from Timer_Counter4 3
   input [15:0] match_1_reg_34;        //Match4 reg value from Timer_Counter4   
   input [15:0] match_2_reg_34;        //Match4 reg value from Timer_Counter4   
   input [15:0] match_3_reg_34;        //Match4 reg value from Timer_Counter4   
   input [5:0]  interrupt_reg_14;      //Interrupt4 Reg4 from Interrupt4 Module4 1
   input [5:0]  interrupt_reg_24;      //Interrupt4 Reg4 from Interrupt4 Module4 2
   input [5:0]  interrupt_reg_34;      //Interrupt4 Reg4 from Interrupt4 Module4 3
   input [5:0]  interrupt_en_reg_14;   //Interrupt4 Enable4 Reg4 from Intrpt4 Module4 1
   input [5:0]  interrupt_en_reg_24;   //Interrupt4 Enable4 Reg4 from Intrpt4 Module4 2
   input [5:0]  interrupt_en_reg_34;   //Interrupt4 Enable4 Reg4 from Intrpt4 Module4 3
   
   //outputs4
   output [31:0] prdata4;              //Read Data from the APB4 Interface4
   output clk_ctrl_reg_sel_14;         //Clock4 Control4 Reg4 Select4 TC_14 
   output clk_ctrl_reg_sel_24;         //Clock4 Control4 Reg4 Select4 TC_24 
   output clk_ctrl_reg_sel_34;         //Clock4 Control4 Reg4 Select4 TC_34 
   output cntr_ctrl_reg_sel_14;        //Counter4 Control4 Reg4 Select4 TC_14
   output cntr_ctrl_reg_sel_24;        //Counter4 Control4 Reg4 Select4 TC_24
   output cntr_ctrl_reg_sel_34;        //Counter4 Control4 Reg4 Select4 TC_34
   output interval_reg_sel_14;         //Interval4 Interrupt4 Reg4 Select4 TC_14 
   output interval_reg_sel_24;         //Interval4 Interrupt4 Reg4 Select4 TC_24 
   output interval_reg_sel_34;         //Interval4 Interrupt4 Reg4 Select4 TC_34 
   output match_1_reg_sel_14;          //Match4 Reg4 Select4 TC_14
   output match_1_reg_sel_24;          //Match4 Reg4 Select4 TC_24
   output match_1_reg_sel_34;          //Match4 Reg4 Select4 TC_34
   output match_2_reg_sel_14;          //Match4 Reg4 Select4 TC_14
   output match_2_reg_sel_24;          //Match4 Reg4 Select4 TC_24
   output match_2_reg_sel_34;          //Match4 Reg4 Select4 TC_34
   output match_3_reg_sel_14;          //Match4 Reg4 Select4 TC_14
   output match_3_reg_sel_24;          //Match4 Reg4 Select4 TC_24
   output match_3_reg_sel_34;          //Match4 Reg4 Select4 TC_34
   output [3:1] intr_en_reg_sel4;      //Interrupt4 Enable4 Reg4 Select4
   output [3:1] clear_interrupt4;      //Clear Interrupt4 line


//-----------------------------------------------------------------------------
// PARAMETER4 DECLARATIONS4
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR4   = 8'h00; //Clock4 control4 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR4   = 8'h04; //Clock4 control4 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR4   = 8'h08; //Clock4 control4 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR4  = 8'h0C; //Counter4 control4 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR4  = 8'h10; //Counter4 control4 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR4  = 8'h14; //Counter4 control4 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR4   = 8'h18; //Counter4 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR4   = 8'h1C; //Counter4 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR4   = 8'h20; //Counter4 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR4   = 8'h24; //Module4 1 interval4 address
   parameter   [7:0] INTERVAL_REG_2_ADDR4   = 8'h28; //Module4 2 interval4 address
   parameter   [7:0] INTERVAL_REG_3_ADDR4   = 8'h2C; //Module4 3 interval4 address
   parameter   [7:0] MATCH_1_REG_1_ADDR4    = 8'h30; //Module4 1 Match4 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR4    = 8'h34; //Module4 2 Match4 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR4    = 8'h38; //Module4 3 Match4 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR4    = 8'h3C; //Module4 1 Match4 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR4    = 8'h40; //Module4 2 Match4 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR4    = 8'h44; //Module4 3 Match4 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR4    = 8'h48; //Module4 1 Match4 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR4    = 8'h4C; //Module4 2 Match4 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR4    = 8'h50; //Module4 3 Match4 3 address
   parameter   [7:0] IRQ_REG_1_ADDR4        = 8'h54; //Interrupt4 register 1
   parameter   [7:0] IRQ_REG_2_ADDR4        = 8'h58; //Interrupt4 register 2
   parameter   [7:0] IRQ_REG_3_ADDR4        = 8'h5C; //Interrupt4 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR4     = 8'h60; //Interrupt4 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR4     = 8'h64; //Interrupt4 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR4     = 8'h68; //Interrupt4 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals4 & Registers4
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_14;         //Clock4 Control4 Reg4 Select4 TC_14
   reg clk_ctrl_reg_sel_24;         //Clock4 Control4 Reg4 Select4 TC_24 
   reg clk_ctrl_reg_sel_34;         //Clock4 Control4 Reg4 Select4 TC_34 
   reg cntr_ctrl_reg_sel_14;        //Counter4 Control4 Reg4 Select4 TC_14
   reg cntr_ctrl_reg_sel_24;        //Counter4 Control4 Reg4 Select4 TC_24
   reg cntr_ctrl_reg_sel_34;        //Counter4 Control4 Reg4 Select4 TC_34
   reg interval_reg_sel_14;         //Interval4 Interrupt4 Reg4 Select4 TC_14 
   reg interval_reg_sel_24;         //Interval4 Interrupt4 Reg4 Select4 TC_24
   reg interval_reg_sel_34;         //Interval4 Interrupt4 Reg4 Select4 TC_34
   reg match_1_reg_sel_14;          //Match4 Reg4 Select4 TC_14
   reg match_1_reg_sel_24;          //Match4 Reg4 Select4 TC_24
   reg match_1_reg_sel_34;          //Match4 Reg4 Select4 TC_34
   reg match_2_reg_sel_14;          //Match4 Reg4 Select4 TC_14
   reg match_2_reg_sel_24;          //Match4 Reg4 Select4 TC_24
   reg match_2_reg_sel_34;          //Match4 Reg4 Select4 TC_34
   reg match_3_reg_sel_14;          //Match4 Reg4 Select4 TC_14
   reg match_3_reg_sel_24;          //Match4 Reg4 Select4 TC_24
   reg match_3_reg_sel_34;          //Match4 Reg4 Select4 TC_34
   reg [3:1] intr_en_reg_sel4;      //Interrupt4 Enable4 1 Reg4 Select4
   reg [31:0] prdata4;              //APB4 read data
   
   wire [3:1] clear_interrupt4;     // 3-bit clear interrupt4 reg on read
   wire write;                     //APB4 write command  
   wire read;                      //APB4 read command    



   assign write = psel4 & penable4 & pwrite4;  
   assign read  = psel4 & ~pwrite4;  
   assign clear_interrupt4[1] = read & penable4 & (paddr4 == IRQ_REG_1_ADDR4);
   assign clear_interrupt4[2] = read & penable4 & (paddr4 == IRQ_REG_2_ADDR4);
   assign clear_interrupt4[3] = read & penable4 & (paddr4 == IRQ_REG_3_ADDR4);   
   
   //p_write_sel4: Process4 to select4 the required4 regs for write access.

   always @ (paddr4 or write)
   begin: p_write_sel4

       clk_ctrl_reg_sel_14  = (write && (paddr4 == CLK_CTRL_REG_1_ADDR4));
       clk_ctrl_reg_sel_24  = (write && (paddr4 == CLK_CTRL_REG_2_ADDR4));
       clk_ctrl_reg_sel_34  = (write && (paddr4 == CLK_CTRL_REG_3_ADDR4));
       cntr_ctrl_reg_sel_14 = (write && (paddr4 == CNTR_CTRL_REG_1_ADDR4));
       cntr_ctrl_reg_sel_24 = (write && (paddr4 == CNTR_CTRL_REG_2_ADDR4));
       cntr_ctrl_reg_sel_34 = (write && (paddr4 == CNTR_CTRL_REG_3_ADDR4));
       interval_reg_sel_14  = (write && (paddr4 == INTERVAL_REG_1_ADDR4));
       interval_reg_sel_24  = (write && (paddr4 == INTERVAL_REG_2_ADDR4));
       interval_reg_sel_34  = (write && (paddr4 == INTERVAL_REG_3_ADDR4));
       match_1_reg_sel_14   = (write && (paddr4 == MATCH_1_REG_1_ADDR4));
       match_1_reg_sel_24   = (write && (paddr4 == MATCH_1_REG_2_ADDR4));
       match_1_reg_sel_34   = (write && (paddr4 == MATCH_1_REG_3_ADDR4));
       match_2_reg_sel_14   = (write && (paddr4 == MATCH_2_REG_1_ADDR4));
       match_2_reg_sel_24   = (write && (paddr4 == MATCH_2_REG_2_ADDR4));
       match_2_reg_sel_34   = (write && (paddr4 == MATCH_2_REG_3_ADDR4));
       match_3_reg_sel_14   = (write && (paddr4 == MATCH_3_REG_1_ADDR4));
       match_3_reg_sel_24   = (write && (paddr4 == MATCH_3_REG_2_ADDR4));
       match_3_reg_sel_34   = (write && (paddr4 == MATCH_3_REG_3_ADDR4));
       intr_en_reg_sel4[1]  = (write && (paddr4 == IRQ_EN_REG_1_ADDR4));
       intr_en_reg_sel4[2]  = (write && (paddr4 == IRQ_EN_REG_2_ADDR4));
       intr_en_reg_sel4[3]  = (write && (paddr4 == IRQ_EN_REG_3_ADDR4));      
   end  //p_write_sel4
    

//    p_read_sel4: Process4 to enable the read operation4 to occur4.

   always @ (posedge pclk4 or negedge n_p_reset4)
   begin: p_read_sel4

      if (!n_p_reset4)                                   
      begin                                     
         prdata4 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr4)

               CLK_CTRL_REG_1_ADDR4 : prdata4 <= {25'h0000000,clk_ctrl_reg_14};
               CLK_CTRL_REG_2_ADDR4 : prdata4 <= {25'h0000000,clk_ctrl_reg_24};
               CLK_CTRL_REG_3_ADDR4 : prdata4 <= {25'h0000000,clk_ctrl_reg_34};
               CNTR_CTRL_REG_1_ADDR4: prdata4 <= {25'h0000000,cntr_ctrl_reg_14};
               CNTR_CTRL_REG_2_ADDR4: prdata4 <= {25'h0000000,cntr_ctrl_reg_24};
               CNTR_CTRL_REG_3_ADDR4: prdata4 <= {25'h0000000,cntr_ctrl_reg_34};
               CNTR_VAL_REG_1_ADDR4 : prdata4 <= {16'h0000,counter_val_reg_14};
               CNTR_VAL_REG_2_ADDR4 : prdata4 <= {16'h0000,counter_val_reg_24};
               CNTR_VAL_REG_3_ADDR4 : prdata4 <= {16'h0000,counter_val_reg_34};
               INTERVAL_REG_1_ADDR4 : prdata4 <= {16'h0000,interval_reg_14};
               INTERVAL_REG_2_ADDR4 : prdata4 <= {16'h0000,interval_reg_24};
               INTERVAL_REG_3_ADDR4 : prdata4 <= {16'h0000,interval_reg_34};
               MATCH_1_REG_1_ADDR4  : prdata4 <= {16'h0000,match_1_reg_14};
               MATCH_1_REG_2_ADDR4  : prdata4 <= {16'h0000,match_1_reg_24};
               MATCH_1_REG_3_ADDR4  : prdata4 <= {16'h0000,match_1_reg_34};
               MATCH_2_REG_1_ADDR4  : prdata4 <= {16'h0000,match_2_reg_14};
               MATCH_2_REG_2_ADDR4  : prdata4 <= {16'h0000,match_2_reg_24};
               MATCH_2_REG_3_ADDR4  : prdata4 <= {16'h0000,match_2_reg_34};
               MATCH_3_REG_1_ADDR4  : prdata4 <= {16'h0000,match_3_reg_14};
               MATCH_3_REG_2_ADDR4  : prdata4 <= {16'h0000,match_3_reg_24};
               MATCH_3_REG_3_ADDR4  : prdata4 <= {16'h0000,match_3_reg_34};
               IRQ_REG_1_ADDR4      : prdata4 <= {26'h0000,interrupt_reg_14};
               IRQ_REG_2_ADDR4      : prdata4 <= {26'h0000,interrupt_reg_24};
               IRQ_REG_3_ADDR4      : prdata4 <= {26'h0000,interrupt_reg_34};
               IRQ_EN_REG_1_ADDR4   : prdata4 <= {26'h0000,interrupt_en_reg_14};
               IRQ_EN_REG_2_ADDR4   : prdata4 <= {26'h0000,interrupt_en_reg_24};
               IRQ_EN_REG_3_ADDR4   : prdata4 <= {26'h0000,interrupt_en_reg_34};
               default             : prdata4 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata4 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset4)
      
   end // block: p_read_sel4

endmodule

