//File10 name   : ttc_interface_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : The APB10 interface with the triple10 timer10 counter
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module10 definition10
//----------------------------------------------------------------------------

module ttc_interface_lite10( 

  //inputs10
  n_p_reset10,    
  pclk10,                          
  psel10,
  penable10,
  pwrite10,
  paddr10,
  clk_ctrl_reg_110,
  clk_ctrl_reg_210,
  clk_ctrl_reg_310,
  cntr_ctrl_reg_110,
  cntr_ctrl_reg_210,
  cntr_ctrl_reg_310,
  counter_val_reg_110,
  counter_val_reg_210,
  counter_val_reg_310,
  interval_reg_110,
  match_1_reg_110,
  match_2_reg_110,
  match_3_reg_110,
  interval_reg_210,
  match_1_reg_210,
  match_2_reg_210,
  match_3_reg_210,
  interval_reg_310,
  match_1_reg_310,
  match_2_reg_310,
  match_3_reg_310,
  interrupt_reg_110,
  interrupt_reg_210,
  interrupt_reg_310,      
  interrupt_en_reg_110,
  interrupt_en_reg_210,
  interrupt_en_reg_310,
                  
  //outputs10
  prdata10,
  clk_ctrl_reg_sel_110,
  clk_ctrl_reg_sel_210,
  clk_ctrl_reg_sel_310,
  cntr_ctrl_reg_sel_110,
  cntr_ctrl_reg_sel_210,
  cntr_ctrl_reg_sel_310,
  interval_reg_sel_110,                            
  interval_reg_sel_210,                          
  interval_reg_sel_310,
  match_1_reg_sel_110,                          
  match_1_reg_sel_210,                          
  match_1_reg_sel_310,                
  match_2_reg_sel_110,                          
  match_2_reg_sel_210,
  match_2_reg_sel_310,
  match_3_reg_sel_110,                          
  match_3_reg_sel_210,                         
  match_3_reg_sel_310,
  intr_en_reg_sel10,
  clear_interrupt10        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS10
//----------------------------------------------------------------------------

   //inputs10
   input        n_p_reset10;              //reset signal10
   input        pclk10;                 //System10 Clock10
   input        psel10;                 //Select10 line
   input        penable10;              //Strobe10 line
   input        pwrite10;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr10;                //Address Bus10 register
   input [6:0]  clk_ctrl_reg_110;       //Clock10 Control10 reg for Timer_Counter10 1
   input [6:0]  cntr_ctrl_reg_110;      //Counter10 Control10 reg for Timer_Counter10 1
   input [6:0]  clk_ctrl_reg_210;       //Clock10 Control10 reg for Timer_Counter10 2
   input [6:0]  cntr_ctrl_reg_210;      //Counter10 Control10 reg for Timer10 Counter10 2
   input [6:0]  clk_ctrl_reg_310;       //Clock10 Control10 reg Timer_Counter10 3
   input [6:0]  cntr_ctrl_reg_310;      //Counter10 Control10 reg for Timer10 Counter10 3
   input [15:0] counter_val_reg_110;    //Counter10 Value from Timer_Counter10 1
   input [15:0] counter_val_reg_210;    //Counter10 Value from Timer_Counter10 2
   input [15:0] counter_val_reg_310;    //Counter10 Value from Timer_Counter10 3
   input [15:0] interval_reg_110;       //Interval10 reg value from Timer_Counter10 1
   input [15:0] match_1_reg_110;        //Match10 reg value from Timer_Counter10 
   input [15:0] match_2_reg_110;        //Match10 reg value from Timer_Counter10     
   input [15:0] match_3_reg_110;        //Match10 reg value from Timer_Counter10 
   input [15:0] interval_reg_210;       //Interval10 reg value from Timer_Counter10 2
   input [15:0] match_1_reg_210;        //Match10 reg value from Timer_Counter10     
   input [15:0] match_2_reg_210;        //Match10 reg value from Timer_Counter10     
   input [15:0] match_3_reg_210;        //Match10 reg value from Timer_Counter10 
   input [15:0] interval_reg_310;       //Interval10 reg value from Timer_Counter10 3
   input [15:0] match_1_reg_310;        //Match10 reg value from Timer_Counter10   
   input [15:0] match_2_reg_310;        //Match10 reg value from Timer_Counter10   
   input [15:0] match_3_reg_310;        //Match10 reg value from Timer_Counter10   
   input [5:0]  interrupt_reg_110;      //Interrupt10 Reg10 from Interrupt10 Module10 1
   input [5:0]  interrupt_reg_210;      //Interrupt10 Reg10 from Interrupt10 Module10 2
   input [5:0]  interrupt_reg_310;      //Interrupt10 Reg10 from Interrupt10 Module10 3
   input [5:0]  interrupt_en_reg_110;   //Interrupt10 Enable10 Reg10 from Intrpt10 Module10 1
   input [5:0]  interrupt_en_reg_210;   //Interrupt10 Enable10 Reg10 from Intrpt10 Module10 2
   input [5:0]  interrupt_en_reg_310;   //Interrupt10 Enable10 Reg10 from Intrpt10 Module10 3
   
   //outputs10
   output [31:0] prdata10;              //Read Data from the APB10 Interface10
   output clk_ctrl_reg_sel_110;         //Clock10 Control10 Reg10 Select10 TC_110 
   output clk_ctrl_reg_sel_210;         //Clock10 Control10 Reg10 Select10 TC_210 
   output clk_ctrl_reg_sel_310;         //Clock10 Control10 Reg10 Select10 TC_310 
   output cntr_ctrl_reg_sel_110;        //Counter10 Control10 Reg10 Select10 TC_110
   output cntr_ctrl_reg_sel_210;        //Counter10 Control10 Reg10 Select10 TC_210
   output cntr_ctrl_reg_sel_310;        //Counter10 Control10 Reg10 Select10 TC_310
   output interval_reg_sel_110;         //Interval10 Interrupt10 Reg10 Select10 TC_110 
   output interval_reg_sel_210;         //Interval10 Interrupt10 Reg10 Select10 TC_210 
   output interval_reg_sel_310;         //Interval10 Interrupt10 Reg10 Select10 TC_310 
   output match_1_reg_sel_110;          //Match10 Reg10 Select10 TC_110
   output match_1_reg_sel_210;          //Match10 Reg10 Select10 TC_210
   output match_1_reg_sel_310;          //Match10 Reg10 Select10 TC_310
   output match_2_reg_sel_110;          //Match10 Reg10 Select10 TC_110
   output match_2_reg_sel_210;          //Match10 Reg10 Select10 TC_210
   output match_2_reg_sel_310;          //Match10 Reg10 Select10 TC_310
   output match_3_reg_sel_110;          //Match10 Reg10 Select10 TC_110
   output match_3_reg_sel_210;          //Match10 Reg10 Select10 TC_210
   output match_3_reg_sel_310;          //Match10 Reg10 Select10 TC_310
   output [3:1] intr_en_reg_sel10;      //Interrupt10 Enable10 Reg10 Select10
   output [3:1] clear_interrupt10;      //Clear Interrupt10 line


//-----------------------------------------------------------------------------
// PARAMETER10 DECLARATIONS10
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR10   = 8'h00; //Clock10 control10 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR10   = 8'h04; //Clock10 control10 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR10   = 8'h08; //Clock10 control10 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR10  = 8'h0C; //Counter10 control10 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR10  = 8'h10; //Counter10 control10 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR10  = 8'h14; //Counter10 control10 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR10   = 8'h18; //Counter10 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR10   = 8'h1C; //Counter10 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR10   = 8'h20; //Counter10 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR10   = 8'h24; //Module10 1 interval10 address
   parameter   [7:0] INTERVAL_REG_2_ADDR10   = 8'h28; //Module10 2 interval10 address
   parameter   [7:0] INTERVAL_REG_3_ADDR10   = 8'h2C; //Module10 3 interval10 address
   parameter   [7:0] MATCH_1_REG_1_ADDR10    = 8'h30; //Module10 1 Match10 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR10    = 8'h34; //Module10 2 Match10 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR10    = 8'h38; //Module10 3 Match10 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR10    = 8'h3C; //Module10 1 Match10 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR10    = 8'h40; //Module10 2 Match10 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR10    = 8'h44; //Module10 3 Match10 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR10    = 8'h48; //Module10 1 Match10 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR10    = 8'h4C; //Module10 2 Match10 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR10    = 8'h50; //Module10 3 Match10 3 address
   parameter   [7:0] IRQ_REG_1_ADDR10        = 8'h54; //Interrupt10 register 1
   parameter   [7:0] IRQ_REG_2_ADDR10        = 8'h58; //Interrupt10 register 2
   parameter   [7:0] IRQ_REG_3_ADDR10        = 8'h5C; //Interrupt10 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR10     = 8'h60; //Interrupt10 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR10     = 8'h64; //Interrupt10 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR10     = 8'h68; //Interrupt10 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals10 & Registers10
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_110;         //Clock10 Control10 Reg10 Select10 TC_110
   reg clk_ctrl_reg_sel_210;         //Clock10 Control10 Reg10 Select10 TC_210 
   reg clk_ctrl_reg_sel_310;         //Clock10 Control10 Reg10 Select10 TC_310 
   reg cntr_ctrl_reg_sel_110;        //Counter10 Control10 Reg10 Select10 TC_110
   reg cntr_ctrl_reg_sel_210;        //Counter10 Control10 Reg10 Select10 TC_210
   reg cntr_ctrl_reg_sel_310;        //Counter10 Control10 Reg10 Select10 TC_310
   reg interval_reg_sel_110;         //Interval10 Interrupt10 Reg10 Select10 TC_110 
   reg interval_reg_sel_210;         //Interval10 Interrupt10 Reg10 Select10 TC_210
   reg interval_reg_sel_310;         //Interval10 Interrupt10 Reg10 Select10 TC_310
   reg match_1_reg_sel_110;          //Match10 Reg10 Select10 TC_110
   reg match_1_reg_sel_210;          //Match10 Reg10 Select10 TC_210
   reg match_1_reg_sel_310;          //Match10 Reg10 Select10 TC_310
   reg match_2_reg_sel_110;          //Match10 Reg10 Select10 TC_110
   reg match_2_reg_sel_210;          //Match10 Reg10 Select10 TC_210
   reg match_2_reg_sel_310;          //Match10 Reg10 Select10 TC_310
   reg match_3_reg_sel_110;          //Match10 Reg10 Select10 TC_110
   reg match_3_reg_sel_210;          //Match10 Reg10 Select10 TC_210
   reg match_3_reg_sel_310;          //Match10 Reg10 Select10 TC_310
   reg [3:1] intr_en_reg_sel10;      //Interrupt10 Enable10 1 Reg10 Select10
   reg [31:0] prdata10;              //APB10 read data
   
   wire [3:1] clear_interrupt10;     // 3-bit clear interrupt10 reg on read
   wire write;                     //APB10 write command  
   wire read;                      //APB10 read command    



   assign write = psel10 & penable10 & pwrite10;  
   assign read  = psel10 & ~pwrite10;  
   assign clear_interrupt10[1] = read & penable10 & (paddr10 == IRQ_REG_1_ADDR10);
   assign clear_interrupt10[2] = read & penable10 & (paddr10 == IRQ_REG_2_ADDR10);
   assign clear_interrupt10[3] = read & penable10 & (paddr10 == IRQ_REG_3_ADDR10);   
   
   //p_write_sel10: Process10 to select10 the required10 regs for write access.

   always @ (paddr10 or write)
   begin: p_write_sel10

       clk_ctrl_reg_sel_110  = (write && (paddr10 == CLK_CTRL_REG_1_ADDR10));
       clk_ctrl_reg_sel_210  = (write && (paddr10 == CLK_CTRL_REG_2_ADDR10));
       clk_ctrl_reg_sel_310  = (write && (paddr10 == CLK_CTRL_REG_3_ADDR10));
       cntr_ctrl_reg_sel_110 = (write && (paddr10 == CNTR_CTRL_REG_1_ADDR10));
       cntr_ctrl_reg_sel_210 = (write && (paddr10 == CNTR_CTRL_REG_2_ADDR10));
       cntr_ctrl_reg_sel_310 = (write && (paddr10 == CNTR_CTRL_REG_3_ADDR10));
       interval_reg_sel_110  = (write && (paddr10 == INTERVAL_REG_1_ADDR10));
       interval_reg_sel_210  = (write && (paddr10 == INTERVAL_REG_2_ADDR10));
       interval_reg_sel_310  = (write && (paddr10 == INTERVAL_REG_3_ADDR10));
       match_1_reg_sel_110   = (write && (paddr10 == MATCH_1_REG_1_ADDR10));
       match_1_reg_sel_210   = (write && (paddr10 == MATCH_1_REG_2_ADDR10));
       match_1_reg_sel_310   = (write && (paddr10 == MATCH_1_REG_3_ADDR10));
       match_2_reg_sel_110   = (write && (paddr10 == MATCH_2_REG_1_ADDR10));
       match_2_reg_sel_210   = (write && (paddr10 == MATCH_2_REG_2_ADDR10));
       match_2_reg_sel_310   = (write && (paddr10 == MATCH_2_REG_3_ADDR10));
       match_3_reg_sel_110   = (write && (paddr10 == MATCH_3_REG_1_ADDR10));
       match_3_reg_sel_210   = (write && (paddr10 == MATCH_3_REG_2_ADDR10));
       match_3_reg_sel_310   = (write && (paddr10 == MATCH_3_REG_3_ADDR10));
       intr_en_reg_sel10[1]  = (write && (paddr10 == IRQ_EN_REG_1_ADDR10));
       intr_en_reg_sel10[2]  = (write && (paddr10 == IRQ_EN_REG_2_ADDR10));
       intr_en_reg_sel10[3]  = (write && (paddr10 == IRQ_EN_REG_3_ADDR10));      
   end  //p_write_sel10
    

//    p_read_sel10: Process10 to enable the read operation10 to occur10.

   always @ (posedge pclk10 or negedge n_p_reset10)
   begin: p_read_sel10

      if (!n_p_reset10)                                   
      begin                                     
         prdata10 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr10)

               CLK_CTRL_REG_1_ADDR10 : prdata10 <= {25'h0000000,clk_ctrl_reg_110};
               CLK_CTRL_REG_2_ADDR10 : prdata10 <= {25'h0000000,clk_ctrl_reg_210};
               CLK_CTRL_REG_3_ADDR10 : prdata10 <= {25'h0000000,clk_ctrl_reg_310};
               CNTR_CTRL_REG_1_ADDR10: prdata10 <= {25'h0000000,cntr_ctrl_reg_110};
               CNTR_CTRL_REG_2_ADDR10: prdata10 <= {25'h0000000,cntr_ctrl_reg_210};
               CNTR_CTRL_REG_3_ADDR10: prdata10 <= {25'h0000000,cntr_ctrl_reg_310};
               CNTR_VAL_REG_1_ADDR10 : prdata10 <= {16'h0000,counter_val_reg_110};
               CNTR_VAL_REG_2_ADDR10 : prdata10 <= {16'h0000,counter_val_reg_210};
               CNTR_VAL_REG_3_ADDR10 : prdata10 <= {16'h0000,counter_val_reg_310};
               INTERVAL_REG_1_ADDR10 : prdata10 <= {16'h0000,interval_reg_110};
               INTERVAL_REG_2_ADDR10 : prdata10 <= {16'h0000,interval_reg_210};
               INTERVAL_REG_3_ADDR10 : prdata10 <= {16'h0000,interval_reg_310};
               MATCH_1_REG_1_ADDR10  : prdata10 <= {16'h0000,match_1_reg_110};
               MATCH_1_REG_2_ADDR10  : prdata10 <= {16'h0000,match_1_reg_210};
               MATCH_1_REG_3_ADDR10  : prdata10 <= {16'h0000,match_1_reg_310};
               MATCH_2_REG_1_ADDR10  : prdata10 <= {16'h0000,match_2_reg_110};
               MATCH_2_REG_2_ADDR10  : prdata10 <= {16'h0000,match_2_reg_210};
               MATCH_2_REG_3_ADDR10  : prdata10 <= {16'h0000,match_2_reg_310};
               MATCH_3_REG_1_ADDR10  : prdata10 <= {16'h0000,match_3_reg_110};
               MATCH_3_REG_2_ADDR10  : prdata10 <= {16'h0000,match_3_reg_210};
               MATCH_3_REG_3_ADDR10  : prdata10 <= {16'h0000,match_3_reg_310};
               IRQ_REG_1_ADDR10      : prdata10 <= {26'h0000,interrupt_reg_110};
               IRQ_REG_2_ADDR10      : prdata10 <= {26'h0000,interrupt_reg_210};
               IRQ_REG_3_ADDR10      : prdata10 <= {26'h0000,interrupt_reg_310};
               IRQ_EN_REG_1_ADDR10   : prdata10 <= {26'h0000,interrupt_en_reg_110};
               IRQ_EN_REG_2_ADDR10   : prdata10 <= {26'h0000,interrupt_en_reg_210};
               IRQ_EN_REG_3_ADDR10   : prdata10 <= {26'h0000,interrupt_en_reg_310};
               default             : prdata10 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata10 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset10)
      
   end // block: p_read_sel10

endmodule

