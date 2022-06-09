//File16 name   : ttc_interface_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : The APB16 interface with the triple16 timer16 counter
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module16 definition16
//----------------------------------------------------------------------------

module ttc_interface_lite16( 

  //inputs16
  n_p_reset16,    
  pclk16,                          
  psel16,
  penable16,
  pwrite16,
  paddr16,
  clk_ctrl_reg_116,
  clk_ctrl_reg_216,
  clk_ctrl_reg_316,
  cntr_ctrl_reg_116,
  cntr_ctrl_reg_216,
  cntr_ctrl_reg_316,
  counter_val_reg_116,
  counter_val_reg_216,
  counter_val_reg_316,
  interval_reg_116,
  match_1_reg_116,
  match_2_reg_116,
  match_3_reg_116,
  interval_reg_216,
  match_1_reg_216,
  match_2_reg_216,
  match_3_reg_216,
  interval_reg_316,
  match_1_reg_316,
  match_2_reg_316,
  match_3_reg_316,
  interrupt_reg_116,
  interrupt_reg_216,
  interrupt_reg_316,      
  interrupt_en_reg_116,
  interrupt_en_reg_216,
  interrupt_en_reg_316,
                  
  //outputs16
  prdata16,
  clk_ctrl_reg_sel_116,
  clk_ctrl_reg_sel_216,
  clk_ctrl_reg_sel_316,
  cntr_ctrl_reg_sel_116,
  cntr_ctrl_reg_sel_216,
  cntr_ctrl_reg_sel_316,
  interval_reg_sel_116,                            
  interval_reg_sel_216,                          
  interval_reg_sel_316,
  match_1_reg_sel_116,                          
  match_1_reg_sel_216,                          
  match_1_reg_sel_316,                
  match_2_reg_sel_116,                          
  match_2_reg_sel_216,
  match_2_reg_sel_316,
  match_3_reg_sel_116,                          
  match_3_reg_sel_216,                         
  match_3_reg_sel_316,
  intr_en_reg_sel16,
  clear_interrupt16        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS16
//----------------------------------------------------------------------------

   //inputs16
   input        n_p_reset16;              //reset signal16
   input        pclk16;                 //System16 Clock16
   input        psel16;                 //Select16 line
   input        penable16;              //Strobe16 line
   input        pwrite16;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr16;                //Address Bus16 register
   input [6:0]  clk_ctrl_reg_116;       //Clock16 Control16 reg for Timer_Counter16 1
   input [6:0]  cntr_ctrl_reg_116;      //Counter16 Control16 reg for Timer_Counter16 1
   input [6:0]  clk_ctrl_reg_216;       //Clock16 Control16 reg for Timer_Counter16 2
   input [6:0]  cntr_ctrl_reg_216;      //Counter16 Control16 reg for Timer16 Counter16 2
   input [6:0]  clk_ctrl_reg_316;       //Clock16 Control16 reg Timer_Counter16 3
   input [6:0]  cntr_ctrl_reg_316;      //Counter16 Control16 reg for Timer16 Counter16 3
   input [15:0] counter_val_reg_116;    //Counter16 Value from Timer_Counter16 1
   input [15:0] counter_val_reg_216;    //Counter16 Value from Timer_Counter16 2
   input [15:0] counter_val_reg_316;    //Counter16 Value from Timer_Counter16 3
   input [15:0] interval_reg_116;       //Interval16 reg value from Timer_Counter16 1
   input [15:0] match_1_reg_116;        //Match16 reg value from Timer_Counter16 
   input [15:0] match_2_reg_116;        //Match16 reg value from Timer_Counter16     
   input [15:0] match_3_reg_116;        //Match16 reg value from Timer_Counter16 
   input [15:0] interval_reg_216;       //Interval16 reg value from Timer_Counter16 2
   input [15:0] match_1_reg_216;        //Match16 reg value from Timer_Counter16     
   input [15:0] match_2_reg_216;        //Match16 reg value from Timer_Counter16     
   input [15:0] match_3_reg_216;        //Match16 reg value from Timer_Counter16 
   input [15:0] interval_reg_316;       //Interval16 reg value from Timer_Counter16 3
   input [15:0] match_1_reg_316;        //Match16 reg value from Timer_Counter16   
   input [15:0] match_2_reg_316;        //Match16 reg value from Timer_Counter16   
   input [15:0] match_3_reg_316;        //Match16 reg value from Timer_Counter16   
   input [5:0]  interrupt_reg_116;      //Interrupt16 Reg16 from Interrupt16 Module16 1
   input [5:0]  interrupt_reg_216;      //Interrupt16 Reg16 from Interrupt16 Module16 2
   input [5:0]  interrupt_reg_316;      //Interrupt16 Reg16 from Interrupt16 Module16 3
   input [5:0]  interrupt_en_reg_116;   //Interrupt16 Enable16 Reg16 from Intrpt16 Module16 1
   input [5:0]  interrupt_en_reg_216;   //Interrupt16 Enable16 Reg16 from Intrpt16 Module16 2
   input [5:0]  interrupt_en_reg_316;   //Interrupt16 Enable16 Reg16 from Intrpt16 Module16 3
   
   //outputs16
   output [31:0] prdata16;              //Read Data from the APB16 Interface16
   output clk_ctrl_reg_sel_116;         //Clock16 Control16 Reg16 Select16 TC_116 
   output clk_ctrl_reg_sel_216;         //Clock16 Control16 Reg16 Select16 TC_216 
   output clk_ctrl_reg_sel_316;         //Clock16 Control16 Reg16 Select16 TC_316 
   output cntr_ctrl_reg_sel_116;        //Counter16 Control16 Reg16 Select16 TC_116
   output cntr_ctrl_reg_sel_216;        //Counter16 Control16 Reg16 Select16 TC_216
   output cntr_ctrl_reg_sel_316;        //Counter16 Control16 Reg16 Select16 TC_316
   output interval_reg_sel_116;         //Interval16 Interrupt16 Reg16 Select16 TC_116 
   output interval_reg_sel_216;         //Interval16 Interrupt16 Reg16 Select16 TC_216 
   output interval_reg_sel_316;         //Interval16 Interrupt16 Reg16 Select16 TC_316 
   output match_1_reg_sel_116;          //Match16 Reg16 Select16 TC_116
   output match_1_reg_sel_216;          //Match16 Reg16 Select16 TC_216
   output match_1_reg_sel_316;          //Match16 Reg16 Select16 TC_316
   output match_2_reg_sel_116;          //Match16 Reg16 Select16 TC_116
   output match_2_reg_sel_216;          //Match16 Reg16 Select16 TC_216
   output match_2_reg_sel_316;          //Match16 Reg16 Select16 TC_316
   output match_3_reg_sel_116;          //Match16 Reg16 Select16 TC_116
   output match_3_reg_sel_216;          //Match16 Reg16 Select16 TC_216
   output match_3_reg_sel_316;          //Match16 Reg16 Select16 TC_316
   output [3:1] intr_en_reg_sel16;      //Interrupt16 Enable16 Reg16 Select16
   output [3:1] clear_interrupt16;      //Clear Interrupt16 line


//-----------------------------------------------------------------------------
// PARAMETER16 DECLARATIONS16
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR16   = 8'h00; //Clock16 control16 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR16   = 8'h04; //Clock16 control16 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR16   = 8'h08; //Clock16 control16 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR16  = 8'h0C; //Counter16 control16 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR16  = 8'h10; //Counter16 control16 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR16  = 8'h14; //Counter16 control16 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR16   = 8'h18; //Counter16 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR16   = 8'h1C; //Counter16 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR16   = 8'h20; //Counter16 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR16   = 8'h24; //Module16 1 interval16 address
   parameter   [7:0] INTERVAL_REG_2_ADDR16   = 8'h28; //Module16 2 interval16 address
   parameter   [7:0] INTERVAL_REG_3_ADDR16   = 8'h2C; //Module16 3 interval16 address
   parameter   [7:0] MATCH_1_REG_1_ADDR16    = 8'h30; //Module16 1 Match16 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR16    = 8'h34; //Module16 2 Match16 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR16    = 8'h38; //Module16 3 Match16 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR16    = 8'h3C; //Module16 1 Match16 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR16    = 8'h40; //Module16 2 Match16 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR16    = 8'h44; //Module16 3 Match16 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR16    = 8'h48; //Module16 1 Match16 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR16    = 8'h4C; //Module16 2 Match16 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR16    = 8'h50; //Module16 3 Match16 3 address
   parameter   [7:0] IRQ_REG_1_ADDR16        = 8'h54; //Interrupt16 register 1
   parameter   [7:0] IRQ_REG_2_ADDR16        = 8'h58; //Interrupt16 register 2
   parameter   [7:0] IRQ_REG_3_ADDR16        = 8'h5C; //Interrupt16 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR16     = 8'h60; //Interrupt16 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR16     = 8'h64; //Interrupt16 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR16     = 8'h68; //Interrupt16 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals16 & Registers16
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_116;         //Clock16 Control16 Reg16 Select16 TC_116
   reg clk_ctrl_reg_sel_216;         //Clock16 Control16 Reg16 Select16 TC_216 
   reg clk_ctrl_reg_sel_316;         //Clock16 Control16 Reg16 Select16 TC_316 
   reg cntr_ctrl_reg_sel_116;        //Counter16 Control16 Reg16 Select16 TC_116
   reg cntr_ctrl_reg_sel_216;        //Counter16 Control16 Reg16 Select16 TC_216
   reg cntr_ctrl_reg_sel_316;        //Counter16 Control16 Reg16 Select16 TC_316
   reg interval_reg_sel_116;         //Interval16 Interrupt16 Reg16 Select16 TC_116 
   reg interval_reg_sel_216;         //Interval16 Interrupt16 Reg16 Select16 TC_216
   reg interval_reg_sel_316;         //Interval16 Interrupt16 Reg16 Select16 TC_316
   reg match_1_reg_sel_116;          //Match16 Reg16 Select16 TC_116
   reg match_1_reg_sel_216;          //Match16 Reg16 Select16 TC_216
   reg match_1_reg_sel_316;          //Match16 Reg16 Select16 TC_316
   reg match_2_reg_sel_116;          //Match16 Reg16 Select16 TC_116
   reg match_2_reg_sel_216;          //Match16 Reg16 Select16 TC_216
   reg match_2_reg_sel_316;          //Match16 Reg16 Select16 TC_316
   reg match_3_reg_sel_116;          //Match16 Reg16 Select16 TC_116
   reg match_3_reg_sel_216;          //Match16 Reg16 Select16 TC_216
   reg match_3_reg_sel_316;          //Match16 Reg16 Select16 TC_316
   reg [3:1] intr_en_reg_sel16;      //Interrupt16 Enable16 1 Reg16 Select16
   reg [31:0] prdata16;              //APB16 read data
   
   wire [3:1] clear_interrupt16;     // 3-bit clear interrupt16 reg on read
   wire write;                     //APB16 write command  
   wire read;                      //APB16 read command    



   assign write = psel16 & penable16 & pwrite16;  
   assign read  = psel16 & ~pwrite16;  
   assign clear_interrupt16[1] = read & penable16 & (paddr16 == IRQ_REG_1_ADDR16);
   assign clear_interrupt16[2] = read & penable16 & (paddr16 == IRQ_REG_2_ADDR16);
   assign clear_interrupt16[3] = read & penable16 & (paddr16 == IRQ_REG_3_ADDR16);   
   
   //p_write_sel16: Process16 to select16 the required16 regs for write access.

   always @ (paddr16 or write)
   begin: p_write_sel16

       clk_ctrl_reg_sel_116  = (write && (paddr16 == CLK_CTRL_REG_1_ADDR16));
       clk_ctrl_reg_sel_216  = (write && (paddr16 == CLK_CTRL_REG_2_ADDR16));
       clk_ctrl_reg_sel_316  = (write && (paddr16 == CLK_CTRL_REG_3_ADDR16));
       cntr_ctrl_reg_sel_116 = (write && (paddr16 == CNTR_CTRL_REG_1_ADDR16));
       cntr_ctrl_reg_sel_216 = (write && (paddr16 == CNTR_CTRL_REG_2_ADDR16));
       cntr_ctrl_reg_sel_316 = (write && (paddr16 == CNTR_CTRL_REG_3_ADDR16));
       interval_reg_sel_116  = (write && (paddr16 == INTERVAL_REG_1_ADDR16));
       interval_reg_sel_216  = (write && (paddr16 == INTERVAL_REG_2_ADDR16));
       interval_reg_sel_316  = (write && (paddr16 == INTERVAL_REG_3_ADDR16));
       match_1_reg_sel_116   = (write && (paddr16 == MATCH_1_REG_1_ADDR16));
       match_1_reg_sel_216   = (write && (paddr16 == MATCH_1_REG_2_ADDR16));
       match_1_reg_sel_316   = (write && (paddr16 == MATCH_1_REG_3_ADDR16));
       match_2_reg_sel_116   = (write && (paddr16 == MATCH_2_REG_1_ADDR16));
       match_2_reg_sel_216   = (write && (paddr16 == MATCH_2_REG_2_ADDR16));
       match_2_reg_sel_316   = (write && (paddr16 == MATCH_2_REG_3_ADDR16));
       match_3_reg_sel_116   = (write && (paddr16 == MATCH_3_REG_1_ADDR16));
       match_3_reg_sel_216   = (write && (paddr16 == MATCH_3_REG_2_ADDR16));
       match_3_reg_sel_316   = (write && (paddr16 == MATCH_3_REG_3_ADDR16));
       intr_en_reg_sel16[1]  = (write && (paddr16 == IRQ_EN_REG_1_ADDR16));
       intr_en_reg_sel16[2]  = (write && (paddr16 == IRQ_EN_REG_2_ADDR16));
       intr_en_reg_sel16[3]  = (write && (paddr16 == IRQ_EN_REG_3_ADDR16));      
   end  //p_write_sel16
    

//    p_read_sel16: Process16 to enable the read operation16 to occur16.

   always @ (posedge pclk16 or negedge n_p_reset16)
   begin: p_read_sel16

      if (!n_p_reset16)                                   
      begin                                     
         prdata16 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr16)

               CLK_CTRL_REG_1_ADDR16 : prdata16 <= {25'h0000000,clk_ctrl_reg_116};
               CLK_CTRL_REG_2_ADDR16 : prdata16 <= {25'h0000000,clk_ctrl_reg_216};
               CLK_CTRL_REG_3_ADDR16 : prdata16 <= {25'h0000000,clk_ctrl_reg_316};
               CNTR_CTRL_REG_1_ADDR16: prdata16 <= {25'h0000000,cntr_ctrl_reg_116};
               CNTR_CTRL_REG_2_ADDR16: prdata16 <= {25'h0000000,cntr_ctrl_reg_216};
               CNTR_CTRL_REG_3_ADDR16: prdata16 <= {25'h0000000,cntr_ctrl_reg_316};
               CNTR_VAL_REG_1_ADDR16 : prdata16 <= {16'h0000,counter_val_reg_116};
               CNTR_VAL_REG_2_ADDR16 : prdata16 <= {16'h0000,counter_val_reg_216};
               CNTR_VAL_REG_3_ADDR16 : prdata16 <= {16'h0000,counter_val_reg_316};
               INTERVAL_REG_1_ADDR16 : prdata16 <= {16'h0000,interval_reg_116};
               INTERVAL_REG_2_ADDR16 : prdata16 <= {16'h0000,interval_reg_216};
               INTERVAL_REG_3_ADDR16 : prdata16 <= {16'h0000,interval_reg_316};
               MATCH_1_REG_1_ADDR16  : prdata16 <= {16'h0000,match_1_reg_116};
               MATCH_1_REG_2_ADDR16  : prdata16 <= {16'h0000,match_1_reg_216};
               MATCH_1_REG_3_ADDR16  : prdata16 <= {16'h0000,match_1_reg_316};
               MATCH_2_REG_1_ADDR16  : prdata16 <= {16'h0000,match_2_reg_116};
               MATCH_2_REG_2_ADDR16  : prdata16 <= {16'h0000,match_2_reg_216};
               MATCH_2_REG_3_ADDR16  : prdata16 <= {16'h0000,match_2_reg_316};
               MATCH_3_REG_1_ADDR16  : prdata16 <= {16'h0000,match_3_reg_116};
               MATCH_3_REG_2_ADDR16  : prdata16 <= {16'h0000,match_3_reg_216};
               MATCH_3_REG_3_ADDR16  : prdata16 <= {16'h0000,match_3_reg_316};
               IRQ_REG_1_ADDR16      : prdata16 <= {26'h0000,interrupt_reg_116};
               IRQ_REG_2_ADDR16      : prdata16 <= {26'h0000,interrupt_reg_216};
               IRQ_REG_3_ADDR16      : prdata16 <= {26'h0000,interrupt_reg_316};
               IRQ_EN_REG_1_ADDR16   : prdata16 <= {26'h0000,interrupt_en_reg_116};
               IRQ_EN_REG_2_ADDR16   : prdata16 <= {26'h0000,interrupt_en_reg_216};
               IRQ_EN_REG_3_ADDR16   : prdata16 <= {26'h0000,interrupt_en_reg_316};
               default             : prdata16 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata16 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset16)
      
   end // block: p_read_sel16

endmodule

