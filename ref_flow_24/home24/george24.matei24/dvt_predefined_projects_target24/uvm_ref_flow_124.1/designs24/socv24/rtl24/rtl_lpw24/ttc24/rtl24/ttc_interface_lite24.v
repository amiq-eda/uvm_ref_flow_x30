//File24 name   : ttc_interface_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : The APB24 interface with the triple24 timer24 counter
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module24 definition24
//----------------------------------------------------------------------------

module ttc_interface_lite24( 

  //inputs24
  n_p_reset24,    
  pclk24,                          
  psel24,
  penable24,
  pwrite24,
  paddr24,
  clk_ctrl_reg_124,
  clk_ctrl_reg_224,
  clk_ctrl_reg_324,
  cntr_ctrl_reg_124,
  cntr_ctrl_reg_224,
  cntr_ctrl_reg_324,
  counter_val_reg_124,
  counter_val_reg_224,
  counter_val_reg_324,
  interval_reg_124,
  match_1_reg_124,
  match_2_reg_124,
  match_3_reg_124,
  interval_reg_224,
  match_1_reg_224,
  match_2_reg_224,
  match_3_reg_224,
  interval_reg_324,
  match_1_reg_324,
  match_2_reg_324,
  match_3_reg_324,
  interrupt_reg_124,
  interrupt_reg_224,
  interrupt_reg_324,      
  interrupt_en_reg_124,
  interrupt_en_reg_224,
  interrupt_en_reg_324,
                  
  //outputs24
  prdata24,
  clk_ctrl_reg_sel_124,
  clk_ctrl_reg_sel_224,
  clk_ctrl_reg_sel_324,
  cntr_ctrl_reg_sel_124,
  cntr_ctrl_reg_sel_224,
  cntr_ctrl_reg_sel_324,
  interval_reg_sel_124,                            
  interval_reg_sel_224,                          
  interval_reg_sel_324,
  match_1_reg_sel_124,                          
  match_1_reg_sel_224,                          
  match_1_reg_sel_324,                
  match_2_reg_sel_124,                          
  match_2_reg_sel_224,
  match_2_reg_sel_324,
  match_3_reg_sel_124,                          
  match_3_reg_sel_224,                         
  match_3_reg_sel_324,
  intr_en_reg_sel24,
  clear_interrupt24        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS24
//----------------------------------------------------------------------------

   //inputs24
   input        n_p_reset24;              //reset signal24
   input        pclk24;                 //System24 Clock24
   input        psel24;                 //Select24 line
   input        penable24;              //Strobe24 line
   input        pwrite24;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr24;                //Address Bus24 register
   input [6:0]  clk_ctrl_reg_124;       //Clock24 Control24 reg for Timer_Counter24 1
   input [6:0]  cntr_ctrl_reg_124;      //Counter24 Control24 reg for Timer_Counter24 1
   input [6:0]  clk_ctrl_reg_224;       //Clock24 Control24 reg for Timer_Counter24 2
   input [6:0]  cntr_ctrl_reg_224;      //Counter24 Control24 reg for Timer24 Counter24 2
   input [6:0]  clk_ctrl_reg_324;       //Clock24 Control24 reg Timer_Counter24 3
   input [6:0]  cntr_ctrl_reg_324;      //Counter24 Control24 reg for Timer24 Counter24 3
   input [15:0] counter_val_reg_124;    //Counter24 Value from Timer_Counter24 1
   input [15:0] counter_val_reg_224;    //Counter24 Value from Timer_Counter24 2
   input [15:0] counter_val_reg_324;    //Counter24 Value from Timer_Counter24 3
   input [15:0] interval_reg_124;       //Interval24 reg value from Timer_Counter24 1
   input [15:0] match_1_reg_124;        //Match24 reg value from Timer_Counter24 
   input [15:0] match_2_reg_124;        //Match24 reg value from Timer_Counter24     
   input [15:0] match_3_reg_124;        //Match24 reg value from Timer_Counter24 
   input [15:0] interval_reg_224;       //Interval24 reg value from Timer_Counter24 2
   input [15:0] match_1_reg_224;        //Match24 reg value from Timer_Counter24     
   input [15:0] match_2_reg_224;        //Match24 reg value from Timer_Counter24     
   input [15:0] match_3_reg_224;        //Match24 reg value from Timer_Counter24 
   input [15:0] interval_reg_324;       //Interval24 reg value from Timer_Counter24 3
   input [15:0] match_1_reg_324;        //Match24 reg value from Timer_Counter24   
   input [15:0] match_2_reg_324;        //Match24 reg value from Timer_Counter24   
   input [15:0] match_3_reg_324;        //Match24 reg value from Timer_Counter24   
   input [5:0]  interrupt_reg_124;      //Interrupt24 Reg24 from Interrupt24 Module24 1
   input [5:0]  interrupt_reg_224;      //Interrupt24 Reg24 from Interrupt24 Module24 2
   input [5:0]  interrupt_reg_324;      //Interrupt24 Reg24 from Interrupt24 Module24 3
   input [5:0]  interrupt_en_reg_124;   //Interrupt24 Enable24 Reg24 from Intrpt24 Module24 1
   input [5:0]  interrupt_en_reg_224;   //Interrupt24 Enable24 Reg24 from Intrpt24 Module24 2
   input [5:0]  interrupt_en_reg_324;   //Interrupt24 Enable24 Reg24 from Intrpt24 Module24 3
   
   //outputs24
   output [31:0] prdata24;              //Read Data from the APB24 Interface24
   output clk_ctrl_reg_sel_124;         //Clock24 Control24 Reg24 Select24 TC_124 
   output clk_ctrl_reg_sel_224;         //Clock24 Control24 Reg24 Select24 TC_224 
   output clk_ctrl_reg_sel_324;         //Clock24 Control24 Reg24 Select24 TC_324 
   output cntr_ctrl_reg_sel_124;        //Counter24 Control24 Reg24 Select24 TC_124
   output cntr_ctrl_reg_sel_224;        //Counter24 Control24 Reg24 Select24 TC_224
   output cntr_ctrl_reg_sel_324;        //Counter24 Control24 Reg24 Select24 TC_324
   output interval_reg_sel_124;         //Interval24 Interrupt24 Reg24 Select24 TC_124 
   output interval_reg_sel_224;         //Interval24 Interrupt24 Reg24 Select24 TC_224 
   output interval_reg_sel_324;         //Interval24 Interrupt24 Reg24 Select24 TC_324 
   output match_1_reg_sel_124;          //Match24 Reg24 Select24 TC_124
   output match_1_reg_sel_224;          //Match24 Reg24 Select24 TC_224
   output match_1_reg_sel_324;          //Match24 Reg24 Select24 TC_324
   output match_2_reg_sel_124;          //Match24 Reg24 Select24 TC_124
   output match_2_reg_sel_224;          //Match24 Reg24 Select24 TC_224
   output match_2_reg_sel_324;          //Match24 Reg24 Select24 TC_324
   output match_3_reg_sel_124;          //Match24 Reg24 Select24 TC_124
   output match_3_reg_sel_224;          //Match24 Reg24 Select24 TC_224
   output match_3_reg_sel_324;          //Match24 Reg24 Select24 TC_324
   output [3:1] intr_en_reg_sel24;      //Interrupt24 Enable24 Reg24 Select24
   output [3:1] clear_interrupt24;      //Clear Interrupt24 line


//-----------------------------------------------------------------------------
// PARAMETER24 DECLARATIONS24
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR24   = 8'h00; //Clock24 control24 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR24   = 8'h04; //Clock24 control24 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR24   = 8'h08; //Clock24 control24 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR24  = 8'h0C; //Counter24 control24 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR24  = 8'h10; //Counter24 control24 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR24  = 8'h14; //Counter24 control24 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR24   = 8'h18; //Counter24 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR24   = 8'h1C; //Counter24 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR24   = 8'h20; //Counter24 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR24   = 8'h24; //Module24 1 interval24 address
   parameter   [7:0] INTERVAL_REG_2_ADDR24   = 8'h28; //Module24 2 interval24 address
   parameter   [7:0] INTERVAL_REG_3_ADDR24   = 8'h2C; //Module24 3 interval24 address
   parameter   [7:0] MATCH_1_REG_1_ADDR24    = 8'h30; //Module24 1 Match24 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR24    = 8'h34; //Module24 2 Match24 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR24    = 8'h38; //Module24 3 Match24 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR24    = 8'h3C; //Module24 1 Match24 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR24    = 8'h40; //Module24 2 Match24 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR24    = 8'h44; //Module24 3 Match24 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR24    = 8'h48; //Module24 1 Match24 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR24    = 8'h4C; //Module24 2 Match24 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR24    = 8'h50; //Module24 3 Match24 3 address
   parameter   [7:0] IRQ_REG_1_ADDR24        = 8'h54; //Interrupt24 register 1
   parameter   [7:0] IRQ_REG_2_ADDR24        = 8'h58; //Interrupt24 register 2
   parameter   [7:0] IRQ_REG_3_ADDR24        = 8'h5C; //Interrupt24 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR24     = 8'h60; //Interrupt24 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR24     = 8'h64; //Interrupt24 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR24     = 8'h68; //Interrupt24 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals24 & Registers24
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_124;         //Clock24 Control24 Reg24 Select24 TC_124
   reg clk_ctrl_reg_sel_224;         //Clock24 Control24 Reg24 Select24 TC_224 
   reg clk_ctrl_reg_sel_324;         //Clock24 Control24 Reg24 Select24 TC_324 
   reg cntr_ctrl_reg_sel_124;        //Counter24 Control24 Reg24 Select24 TC_124
   reg cntr_ctrl_reg_sel_224;        //Counter24 Control24 Reg24 Select24 TC_224
   reg cntr_ctrl_reg_sel_324;        //Counter24 Control24 Reg24 Select24 TC_324
   reg interval_reg_sel_124;         //Interval24 Interrupt24 Reg24 Select24 TC_124 
   reg interval_reg_sel_224;         //Interval24 Interrupt24 Reg24 Select24 TC_224
   reg interval_reg_sel_324;         //Interval24 Interrupt24 Reg24 Select24 TC_324
   reg match_1_reg_sel_124;          //Match24 Reg24 Select24 TC_124
   reg match_1_reg_sel_224;          //Match24 Reg24 Select24 TC_224
   reg match_1_reg_sel_324;          //Match24 Reg24 Select24 TC_324
   reg match_2_reg_sel_124;          //Match24 Reg24 Select24 TC_124
   reg match_2_reg_sel_224;          //Match24 Reg24 Select24 TC_224
   reg match_2_reg_sel_324;          //Match24 Reg24 Select24 TC_324
   reg match_3_reg_sel_124;          //Match24 Reg24 Select24 TC_124
   reg match_3_reg_sel_224;          //Match24 Reg24 Select24 TC_224
   reg match_3_reg_sel_324;          //Match24 Reg24 Select24 TC_324
   reg [3:1] intr_en_reg_sel24;      //Interrupt24 Enable24 1 Reg24 Select24
   reg [31:0] prdata24;              //APB24 read data
   
   wire [3:1] clear_interrupt24;     // 3-bit clear interrupt24 reg on read
   wire write;                     //APB24 write command  
   wire read;                      //APB24 read command    



   assign write = psel24 & penable24 & pwrite24;  
   assign read  = psel24 & ~pwrite24;  
   assign clear_interrupt24[1] = read & penable24 & (paddr24 == IRQ_REG_1_ADDR24);
   assign clear_interrupt24[2] = read & penable24 & (paddr24 == IRQ_REG_2_ADDR24);
   assign clear_interrupt24[3] = read & penable24 & (paddr24 == IRQ_REG_3_ADDR24);   
   
   //p_write_sel24: Process24 to select24 the required24 regs for write access.

   always @ (paddr24 or write)
   begin: p_write_sel24

       clk_ctrl_reg_sel_124  = (write && (paddr24 == CLK_CTRL_REG_1_ADDR24));
       clk_ctrl_reg_sel_224  = (write && (paddr24 == CLK_CTRL_REG_2_ADDR24));
       clk_ctrl_reg_sel_324  = (write && (paddr24 == CLK_CTRL_REG_3_ADDR24));
       cntr_ctrl_reg_sel_124 = (write && (paddr24 == CNTR_CTRL_REG_1_ADDR24));
       cntr_ctrl_reg_sel_224 = (write && (paddr24 == CNTR_CTRL_REG_2_ADDR24));
       cntr_ctrl_reg_sel_324 = (write && (paddr24 == CNTR_CTRL_REG_3_ADDR24));
       interval_reg_sel_124  = (write && (paddr24 == INTERVAL_REG_1_ADDR24));
       interval_reg_sel_224  = (write && (paddr24 == INTERVAL_REG_2_ADDR24));
       interval_reg_sel_324  = (write && (paddr24 == INTERVAL_REG_3_ADDR24));
       match_1_reg_sel_124   = (write && (paddr24 == MATCH_1_REG_1_ADDR24));
       match_1_reg_sel_224   = (write && (paddr24 == MATCH_1_REG_2_ADDR24));
       match_1_reg_sel_324   = (write && (paddr24 == MATCH_1_REG_3_ADDR24));
       match_2_reg_sel_124   = (write && (paddr24 == MATCH_2_REG_1_ADDR24));
       match_2_reg_sel_224   = (write && (paddr24 == MATCH_2_REG_2_ADDR24));
       match_2_reg_sel_324   = (write && (paddr24 == MATCH_2_REG_3_ADDR24));
       match_3_reg_sel_124   = (write && (paddr24 == MATCH_3_REG_1_ADDR24));
       match_3_reg_sel_224   = (write && (paddr24 == MATCH_3_REG_2_ADDR24));
       match_3_reg_sel_324   = (write && (paddr24 == MATCH_3_REG_3_ADDR24));
       intr_en_reg_sel24[1]  = (write && (paddr24 == IRQ_EN_REG_1_ADDR24));
       intr_en_reg_sel24[2]  = (write && (paddr24 == IRQ_EN_REG_2_ADDR24));
       intr_en_reg_sel24[3]  = (write && (paddr24 == IRQ_EN_REG_3_ADDR24));      
   end  //p_write_sel24
    

//    p_read_sel24: Process24 to enable the read operation24 to occur24.

   always @ (posedge pclk24 or negedge n_p_reset24)
   begin: p_read_sel24

      if (!n_p_reset24)                                   
      begin                                     
         prdata24 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr24)

               CLK_CTRL_REG_1_ADDR24 : prdata24 <= {25'h0000000,clk_ctrl_reg_124};
               CLK_CTRL_REG_2_ADDR24 : prdata24 <= {25'h0000000,clk_ctrl_reg_224};
               CLK_CTRL_REG_3_ADDR24 : prdata24 <= {25'h0000000,clk_ctrl_reg_324};
               CNTR_CTRL_REG_1_ADDR24: prdata24 <= {25'h0000000,cntr_ctrl_reg_124};
               CNTR_CTRL_REG_2_ADDR24: prdata24 <= {25'h0000000,cntr_ctrl_reg_224};
               CNTR_CTRL_REG_3_ADDR24: prdata24 <= {25'h0000000,cntr_ctrl_reg_324};
               CNTR_VAL_REG_1_ADDR24 : prdata24 <= {16'h0000,counter_val_reg_124};
               CNTR_VAL_REG_2_ADDR24 : prdata24 <= {16'h0000,counter_val_reg_224};
               CNTR_VAL_REG_3_ADDR24 : prdata24 <= {16'h0000,counter_val_reg_324};
               INTERVAL_REG_1_ADDR24 : prdata24 <= {16'h0000,interval_reg_124};
               INTERVAL_REG_2_ADDR24 : prdata24 <= {16'h0000,interval_reg_224};
               INTERVAL_REG_3_ADDR24 : prdata24 <= {16'h0000,interval_reg_324};
               MATCH_1_REG_1_ADDR24  : prdata24 <= {16'h0000,match_1_reg_124};
               MATCH_1_REG_2_ADDR24  : prdata24 <= {16'h0000,match_1_reg_224};
               MATCH_1_REG_3_ADDR24  : prdata24 <= {16'h0000,match_1_reg_324};
               MATCH_2_REG_1_ADDR24  : prdata24 <= {16'h0000,match_2_reg_124};
               MATCH_2_REG_2_ADDR24  : prdata24 <= {16'h0000,match_2_reg_224};
               MATCH_2_REG_3_ADDR24  : prdata24 <= {16'h0000,match_2_reg_324};
               MATCH_3_REG_1_ADDR24  : prdata24 <= {16'h0000,match_3_reg_124};
               MATCH_3_REG_2_ADDR24  : prdata24 <= {16'h0000,match_3_reg_224};
               MATCH_3_REG_3_ADDR24  : prdata24 <= {16'h0000,match_3_reg_324};
               IRQ_REG_1_ADDR24      : prdata24 <= {26'h0000,interrupt_reg_124};
               IRQ_REG_2_ADDR24      : prdata24 <= {26'h0000,interrupt_reg_224};
               IRQ_REG_3_ADDR24      : prdata24 <= {26'h0000,interrupt_reg_324};
               IRQ_EN_REG_1_ADDR24   : prdata24 <= {26'h0000,interrupt_en_reg_124};
               IRQ_EN_REG_2_ADDR24   : prdata24 <= {26'h0000,interrupt_en_reg_224};
               IRQ_EN_REG_3_ADDR24   : prdata24 <= {26'h0000,interrupt_en_reg_324};
               default             : prdata24 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata24 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset24)
      
   end // block: p_read_sel24

endmodule

