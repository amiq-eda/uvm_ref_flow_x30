//File11 name   : ttc_interface_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : The APB11 interface with the triple11 timer11 counter
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module11 definition11
//----------------------------------------------------------------------------

module ttc_interface_lite11( 

  //inputs11
  n_p_reset11,    
  pclk11,                          
  psel11,
  penable11,
  pwrite11,
  paddr11,
  clk_ctrl_reg_111,
  clk_ctrl_reg_211,
  clk_ctrl_reg_311,
  cntr_ctrl_reg_111,
  cntr_ctrl_reg_211,
  cntr_ctrl_reg_311,
  counter_val_reg_111,
  counter_val_reg_211,
  counter_val_reg_311,
  interval_reg_111,
  match_1_reg_111,
  match_2_reg_111,
  match_3_reg_111,
  interval_reg_211,
  match_1_reg_211,
  match_2_reg_211,
  match_3_reg_211,
  interval_reg_311,
  match_1_reg_311,
  match_2_reg_311,
  match_3_reg_311,
  interrupt_reg_111,
  interrupt_reg_211,
  interrupt_reg_311,      
  interrupt_en_reg_111,
  interrupt_en_reg_211,
  interrupt_en_reg_311,
                  
  //outputs11
  prdata11,
  clk_ctrl_reg_sel_111,
  clk_ctrl_reg_sel_211,
  clk_ctrl_reg_sel_311,
  cntr_ctrl_reg_sel_111,
  cntr_ctrl_reg_sel_211,
  cntr_ctrl_reg_sel_311,
  interval_reg_sel_111,                            
  interval_reg_sel_211,                          
  interval_reg_sel_311,
  match_1_reg_sel_111,                          
  match_1_reg_sel_211,                          
  match_1_reg_sel_311,                
  match_2_reg_sel_111,                          
  match_2_reg_sel_211,
  match_2_reg_sel_311,
  match_3_reg_sel_111,                          
  match_3_reg_sel_211,                         
  match_3_reg_sel_311,
  intr_en_reg_sel11,
  clear_interrupt11        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS11
//----------------------------------------------------------------------------

   //inputs11
   input        n_p_reset11;              //reset signal11
   input        pclk11;                 //System11 Clock11
   input        psel11;                 //Select11 line
   input        penable11;              //Strobe11 line
   input        pwrite11;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr11;                //Address Bus11 register
   input [6:0]  clk_ctrl_reg_111;       //Clock11 Control11 reg for Timer_Counter11 1
   input [6:0]  cntr_ctrl_reg_111;      //Counter11 Control11 reg for Timer_Counter11 1
   input [6:0]  clk_ctrl_reg_211;       //Clock11 Control11 reg for Timer_Counter11 2
   input [6:0]  cntr_ctrl_reg_211;      //Counter11 Control11 reg for Timer11 Counter11 2
   input [6:0]  clk_ctrl_reg_311;       //Clock11 Control11 reg Timer_Counter11 3
   input [6:0]  cntr_ctrl_reg_311;      //Counter11 Control11 reg for Timer11 Counter11 3
   input [15:0] counter_val_reg_111;    //Counter11 Value from Timer_Counter11 1
   input [15:0] counter_val_reg_211;    //Counter11 Value from Timer_Counter11 2
   input [15:0] counter_val_reg_311;    //Counter11 Value from Timer_Counter11 3
   input [15:0] interval_reg_111;       //Interval11 reg value from Timer_Counter11 1
   input [15:0] match_1_reg_111;        //Match11 reg value from Timer_Counter11 
   input [15:0] match_2_reg_111;        //Match11 reg value from Timer_Counter11     
   input [15:0] match_3_reg_111;        //Match11 reg value from Timer_Counter11 
   input [15:0] interval_reg_211;       //Interval11 reg value from Timer_Counter11 2
   input [15:0] match_1_reg_211;        //Match11 reg value from Timer_Counter11     
   input [15:0] match_2_reg_211;        //Match11 reg value from Timer_Counter11     
   input [15:0] match_3_reg_211;        //Match11 reg value from Timer_Counter11 
   input [15:0] interval_reg_311;       //Interval11 reg value from Timer_Counter11 3
   input [15:0] match_1_reg_311;        //Match11 reg value from Timer_Counter11   
   input [15:0] match_2_reg_311;        //Match11 reg value from Timer_Counter11   
   input [15:0] match_3_reg_311;        //Match11 reg value from Timer_Counter11   
   input [5:0]  interrupt_reg_111;      //Interrupt11 Reg11 from Interrupt11 Module11 1
   input [5:0]  interrupt_reg_211;      //Interrupt11 Reg11 from Interrupt11 Module11 2
   input [5:0]  interrupt_reg_311;      //Interrupt11 Reg11 from Interrupt11 Module11 3
   input [5:0]  interrupt_en_reg_111;   //Interrupt11 Enable11 Reg11 from Intrpt11 Module11 1
   input [5:0]  interrupt_en_reg_211;   //Interrupt11 Enable11 Reg11 from Intrpt11 Module11 2
   input [5:0]  interrupt_en_reg_311;   //Interrupt11 Enable11 Reg11 from Intrpt11 Module11 3
   
   //outputs11
   output [31:0] prdata11;              //Read Data from the APB11 Interface11
   output clk_ctrl_reg_sel_111;         //Clock11 Control11 Reg11 Select11 TC_111 
   output clk_ctrl_reg_sel_211;         //Clock11 Control11 Reg11 Select11 TC_211 
   output clk_ctrl_reg_sel_311;         //Clock11 Control11 Reg11 Select11 TC_311 
   output cntr_ctrl_reg_sel_111;        //Counter11 Control11 Reg11 Select11 TC_111
   output cntr_ctrl_reg_sel_211;        //Counter11 Control11 Reg11 Select11 TC_211
   output cntr_ctrl_reg_sel_311;        //Counter11 Control11 Reg11 Select11 TC_311
   output interval_reg_sel_111;         //Interval11 Interrupt11 Reg11 Select11 TC_111 
   output interval_reg_sel_211;         //Interval11 Interrupt11 Reg11 Select11 TC_211 
   output interval_reg_sel_311;         //Interval11 Interrupt11 Reg11 Select11 TC_311 
   output match_1_reg_sel_111;          //Match11 Reg11 Select11 TC_111
   output match_1_reg_sel_211;          //Match11 Reg11 Select11 TC_211
   output match_1_reg_sel_311;          //Match11 Reg11 Select11 TC_311
   output match_2_reg_sel_111;          //Match11 Reg11 Select11 TC_111
   output match_2_reg_sel_211;          //Match11 Reg11 Select11 TC_211
   output match_2_reg_sel_311;          //Match11 Reg11 Select11 TC_311
   output match_3_reg_sel_111;          //Match11 Reg11 Select11 TC_111
   output match_3_reg_sel_211;          //Match11 Reg11 Select11 TC_211
   output match_3_reg_sel_311;          //Match11 Reg11 Select11 TC_311
   output [3:1] intr_en_reg_sel11;      //Interrupt11 Enable11 Reg11 Select11
   output [3:1] clear_interrupt11;      //Clear Interrupt11 line


//-----------------------------------------------------------------------------
// PARAMETER11 DECLARATIONS11
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR11   = 8'h00; //Clock11 control11 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR11   = 8'h04; //Clock11 control11 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR11   = 8'h08; //Clock11 control11 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR11  = 8'h0C; //Counter11 control11 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR11  = 8'h10; //Counter11 control11 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR11  = 8'h14; //Counter11 control11 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR11   = 8'h18; //Counter11 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR11   = 8'h1C; //Counter11 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR11   = 8'h20; //Counter11 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR11   = 8'h24; //Module11 1 interval11 address
   parameter   [7:0] INTERVAL_REG_2_ADDR11   = 8'h28; //Module11 2 interval11 address
   parameter   [7:0] INTERVAL_REG_3_ADDR11   = 8'h2C; //Module11 3 interval11 address
   parameter   [7:0] MATCH_1_REG_1_ADDR11    = 8'h30; //Module11 1 Match11 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR11    = 8'h34; //Module11 2 Match11 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR11    = 8'h38; //Module11 3 Match11 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR11    = 8'h3C; //Module11 1 Match11 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR11    = 8'h40; //Module11 2 Match11 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR11    = 8'h44; //Module11 3 Match11 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR11    = 8'h48; //Module11 1 Match11 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR11    = 8'h4C; //Module11 2 Match11 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR11    = 8'h50; //Module11 3 Match11 3 address
   parameter   [7:0] IRQ_REG_1_ADDR11        = 8'h54; //Interrupt11 register 1
   parameter   [7:0] IRQ_REG_2_ADDR11        = 8'h58; //Interrupt11 register 2
   parameter   [7:0] IRQ_REG_3_ADDR11        = 8'h5C; //Interrupt11 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR11     = 8'h60; //Interrupt11 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR11     = 8'h64; //Interrupt11 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR11     = 8'h68; //Interrupt11 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals11 & Registers11
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_111;         //Clock11 Control11 Reg11 Select11 TC_111
   reg clk_ctrl_reg_sel_211;         //Clock11 Control11 Reg11 Select11 TC_211 
   reg clk_ctrl_reg_sel_311;         //Clock11 Control11 Reg11 Select11 TC_311 
   reg cntr_ctrl_reg_sel_111;        //Counter11 Control11 Reg11 Select11 TC_111
   reg cntr_ctrl_reg_sel_211;        //Counter11 Control11 Reg11 Select11 TC_211
   reg cntr_ctrl_reg_sel_311;        //Counter11 Control11 Reg11 Select11 TC_311
   reg interval_reg_sel_111;         //Interval11 Interrupt11 Reg11 Select11 TC_111 
   reg interval_reg_sel_211;         //Interval11 Interrupt11 Reg11 Select11 TC_211
   reg interval_reg_sel_311;         //Interval11 Interrupt11 Reg11 Select11 TC_311
   reg match_1_reg_sel_111;          //Match11 Reg11 Select11 TC_111
   reg match_1_reg_sel_211;          //Match11 Reg11 Select11 TC_211
   reg match_1_reg_sel_311;          //Match11 Reg11 Select11 TC_311
   reg match_2_reg_sel_111;          //Match11 Reg11 Select11 TC_111
   reg match_2_reg_sel_211;          //Match11 Reg11 Select11 TC_211
   reg match_2_reg_sel_311;          //Match11 Reg11 Select11 TC_311
   reg match_3_reg_sel_111;          //Match11 Reg11 Select11 TC_111
   reg match_3_reg_sel_211;          //Match11 Reg11 Select11 TC_211
   reg match_3_reg_sel_311;          //Match11 Reg11 Select11 TC_311
   reg [3:1] intr_en_reg_sel11;      //Interrupt11 Enable11 1 Reg11 Select11
   reg [31:0] prdata11;              //APB11 read data
   
   wire [3:1] clear_interrupt11;     // 3-bit clear interrupt11 reg on read
   wire write;                     //APB11 write command  
   wire read;                      //APB11 read command    



   assign write = psel11 & penable11 & pwrite11;  
   assign read  = psel11 & ~pwrite11;  
   assign clear_interrupt11[1] = read & penable11 & (paddr11 == IRQ_REG_1_ADDR11);
   assign clear_interrupt11[2] = read & penable11 & (paddr11 == IRQ_REG_2_ADDR11);
   assign clear_interrupt11[3] = read & penable11 & (paddr11 == IRQ_REG_3_ADDR11);   
   
   //p_write_sel11: Process11 to select11 the required11 regs for write access.

   always @ (paddr11 or write)
   begin: p_write_sel11

       clk_ctrl_reg_sel_111  = (write && (paddr11 == CLK_CTRL_REG_1_ADDR11));
       clk_ctrl_reg_sel_211  = (write && (paddr11 == CLK_CTRL_REG_2_ADDR11));
       clk_ctrl_reg_sel_311  = (write && (paddr11 == CLK_CTRL_REG_3_ADDR11));
       cntr_ctrl_reg_sel_111 = (write && (paddr11 == CNTR_CTRL_REG_1_ADDR11));
       cntr_ctrl_reg_sel_211 = (write && (paddr11 == CNTR_CTRL_REG_2_ADDR11));
       cntr_ctrl_reg_sel_311 = (write && (paddr11 == CNTR_CTRL_REG_3_ADDR11));
       interval_reg_sel_111  = (write && (paddr11 == INTERVAL_REG_1_ADDR11));
       interval_reg_sel_211  = (write && (paddr11 == INTERVAL_REG_2_ADDR11));
       interval_reg_sel_311  = (write && (paddr11 == INTERVAL_REG_3_ADDR11));
       match_1_reg_sel_111   = (write && (paddr11 == MATCH_1_REG_1_ADDR11));
       match_1_reg_sel_211   = (write && (paddr11 == MATCH_1_REG_2_ADDR11));
       match_1_reg_sel_311   = (write && (paddr11 == MATCH_1_REG_3_ADDR11));
       match_2_reg_sel_111   = (write && (paddr11 == MATCH_2_REG_1_ADDR11));
       match_2_reg_sel_211   = (write && (paddr11 == MATCH_2_REG_2_ADDR11));
       match_2_reg_sel_311   = (write && (paddr11 == MATCH_2_REG_3_ADDR11));
       match_3_reg_sel_111   = (write && (paddr11 == MATCH_3_REG_1_ADDR11));
       match_3_reg_sel_211   = (write && (paddr11 == MATCH_3_REG_2_ADDR11));
       match_3_reg_sel_311   = (write && (paddr11 == MATCH_3_REG_3_ADDR11));
       intr_en_reg_sel11[1]  = (write && (paddr11 == IRQ_EN_REG_1_ADDR11));
       intr_en_reg_sel11[2]  = (write && (paddr11 == IRQ_EN_REG_2_ADDR11));
       intr_en_reg_sel11[3]  = (write && (paddr11 == IRQ_EN_REG_3_ADDR11));      
   end  //p_write_sel11
    

//    p_read_sel11: Process11 to enable the read operation11 to occur11.

   always @ (posedge pclk11 or negedge n_p_reset11)
   begin: p_read_sel11

      if (!n_p_reset11)                                   
      begin                                     
         prdata11 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr11)

               CLK_CTRL_REG_1_ADDR11 : prdata11 <= {25'h0000000,clk_ctrl_reg_111};
               CLK_CTRL_REG_2_ADDR11 : prdata11 <= {25'h0000000,clk_ctrl_reg_211};
               CLK_CTRL_REG_3_ADDR11 : prdata11 <= {25'h0000000,clk_ctrl_reg_311};
               CNTR_CTRL_REG_1_ADDR11: prdata11 <= {25'h0000000,cntr_ctrl_reg_111};
               CNTR_CTRL_REG_2_ADDR11: prdata11 <= {25'h0000000,cntr_ctrl_reg_211};
               CNTR_CTRL_REG_3_ADDR11: prdata11 <= {25'h0000000,cntr_ctrl_reg_311};
               CNTR_VAL_REG_1_ADDR11 : prdata11 <= {16'h0000,counter_val_reg_111};
               CNTR_VAL_REG_2_ADDR11 : prdata11 <= {16'h0000,counter_val_reg_211};
               CNTR_VAL_REG_3_ADDR11 : prdata11 <= {16'h0000,counter_val_reg_311};
               INTERVAL_REG_1_ADDR11 : prdata11 <= {16'h0000,interval_reg_111};
               INTERVAL_REG_2_ADDR11 : prdata11 <= {16'h0000,interval_reg_211};
               INTERVAL_REG_3_ADDR11 : prdata11 <= {16'h0000,interval_reg_311};
               MATCH_1_REG_1_ADDR11  : prdata11 <= {16'h0000,match_1_reg_111};
               MATCH_1_REG_2_ADDR11  : prdata11 <= {16'h0000,match_1_reg_211};
               MATCH_1_REG_3_ADDR11  : prdata11 <= {16'h0000,match_1_reg_311};
               MATCH_2_REG_1_ADDR11  : prdata11 <= {16'h0000,match_2_reg_111};
               MATCH_2_REG_2_ADDR11  : prdata11 <= {16'h0000,match_2_reg_211};
               MATCH_2_REG_3_ADDR11  : prdata11 <= {16'h0000,match_2_reg_311};
               MATCH_3_REG_1_ADDR11  : prdata11 <= {16'h0000,match_3_reg_111};
               MATCH_3_REG_2_ADDR11  : prdata11 <= {16'h0000,match_3_reg_211};
               MATCH_3_REG_3_ADDR11  : prdata11 <= {16'h0000,match_3_reg_311};
               IRQ_REG_1_ADDR11      : prdata11 <= {26'h0000,interrupt_reg_111};
               IRQ_REG_2_ADDR11      : prdata11 <= {26'h0000,interrupt_reg_211};
               IRQ_REG_3_ADDR11      : prdata11 <= {26'h0000,interrupt_reg_311};
               IRQ_EN_REG_1_ADDR11   : prdata11 <= {26'h0000,interrupt_en_reg_111};
               IRQ_EN_REG_2_ADDR11   : prdata11 <= {26'h0000,interrupt_en_reg_211};
               IRQ_EN_REG_3_ADDR11   : prdata11 <= {26'h0000,interrupt_en_reg_311};
               default             : prdata11 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata11 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset11)
      
   end // block: p_read_sel11

endmodule

