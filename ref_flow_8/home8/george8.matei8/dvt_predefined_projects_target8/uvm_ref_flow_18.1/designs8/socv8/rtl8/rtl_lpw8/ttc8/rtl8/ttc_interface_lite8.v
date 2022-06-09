//File8 name   : ttc_interface_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : The APB8 interface with the triple8 timer8 counter
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module8 definition8
//----------------------------------------------------------------------------

module ttc_interface_lite8( 

  //inputs8
  n_p_reset8,    
  pclk8,                          
  psel8,
  penable8,
  pwrite8,
  paddr8,
  clk_ctrl_reg_18,
  clk_ctrl_reg_28,
  clk_ctrl_reg_38,
  cntr_ctrl_reg_18,
  cntr_ctrl_reg_28,
  cntr_ctrl_reg_38,
  counter_val_reg_18,
  counter_val_reg_28,
  counter_val_reg_38,
  interval_reg_18,
  match_1_reg_18,
  match_2_reg_18,
  match_3_reg_18,
  interval_reg_28,
  match_1_reg_28,
  match_2_reg_28,
  match_3_reg_28,
  interval_reg_38,
  match_1_reg_38,
  match_2_reg_38,
  match_3_reg_38,
  interrupt_reg_18,
  interrupt_reg_28,
  interrupt_reg_38,      
  interrupt_en_reg_18,
  interrupt_en_reg_28,
  interrupt_en_reg_38,
                  
  //outputs8
  prdata8,
  clk_ctrl_reg_sel_18,
  clk_ctrl_reg_sel_28,
  clk_ctrl_reg_sel_38,
  cntr_ctrl_reg_sel_18,
  cntr_ctrl_reg_sel_28,
  cntr_ctrl_reg_sel_38,
  interval_reg_sel_18,                            
  interval_reg_sel_28,                          
  interval_reg_sel_38,
  match_1_reg_sel_18,                          
  match_1_reg_sel_28,                          
  match_1_reg_sel_38,                
  match_2_reg_sel_18,                          
  match_2_reg_sel_28,
  match_2_reg_sel_38,
  match_3_reg_sel_18,                          
  match_3_reg_sel_28,                         
  match_3_reg_sel_38,
  intr_en_reg_sel8,
  clear_interrupt8        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS8
//----------------------------------------------------------------------------

   //inputs8
   input        n_p_reset8;              //reset signal8
   input        pclk8;                 //System8 Clock8
   input        psel8;                 //Select8 line
   input        penable8;              //Strobe8 line
   input        pwrite8;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr8;                //Address Bus8 register
   input [6:0]  clk_ctrl_reg_18;       //Clock8 Control8 reg for Timer_Counter8 1
   input [6:0]  cntr_ctrl_reg_18;      //Counter8 Control8 reg for Timer_Counter8 1
   input [6:0]  clk_ctrl_reg_28;       //Clock8 Control8 reg for Timer_Counter8 2
   input [6:0]  cntr_ctrl_reg_28;      //Counter8 Control8 reg for Timer8 Counter8 2
   input [6:0]  clk_ctrl_reg_38;       //Clock8 Control8 reg Timer_Counter8 3
   input [6:0]  cntr_ctrl_reg_38;      //Counter8 Control8 reg for Timer8 Counter8 3
   input [15:0] counter_val_reg_18;    //Counter8 Value from Timer_Counter8 1
   input [15:0] counter_val_reg_28;    //Counter8 Value from Timer_Counter8 2
   input [15:0] counter_val_reg_38;    //Counter8 Value from Timer_Counter8 3
   input [15:0] interval_reg_18;       //Interval8 reg value from Timer_Counter8 1
   input [15:0] match_1_reg_18;        //Match8 reg value from Timer_Counter8 
   input [15:0] match_2_reg_18;        //Match8 reg value from Timer_Counter8     
   input [15:0] match_3_reg_18;        //Match8 reg value from Timer_Counter8 
   input [15:0] interval_reg_28;       //Interval8 reg value from Timer_Counter8 2
   input [15:0] match_1_reg_28;        //Match8 reg value from Timer_Counter8     
   input [15:0] match_2_reg_28;        //Match8 reg value from Timer_Counter8     
   input [15:0] match_3_reg_28;        //Match8 reg value from Timer_Counter8 
   input [15:0] interval_reg_38;       //Interval8 reg value from Timer_Counter8 3
   input [15:0] match_1_reg_38;        //Match8 reg value from Timer_Counter8   
   input [15:0] match_2_reg_38;        //Match8 reg value from Timer_Counter8   
   input [15:0] match_3_reg_38;        //Match8 reg value from Timer_Counter8   
   input [5:0]  interrupt_reg_18;      //Interrupt8 Reg8 from Interrupt8 Module8 1
   input [5:0]  interrupt_reg_28;      //Interrupt8 Reg8 from Interrupt8 Module8 2
   input [5:0]  interrupt_reg_38;      //Interrupt8 Reg8 from Interrupt8 Module8 3
   input [5:0]  interrupt_en_reg_18;   //Interrupt8 Enable8 Reg8 from Intrpt8 Module8 1
   input [5:0]  interrupt_en_reg_28;   //Interrupt8 Enable8 Reg8 from Intrpt8 Module8 2
   input [5:0]  interrupt_en_reg_38;   //Interrupt8 Enable8 Reg8 from Intrpt8 Module8 3
   
   //outputs8
   output [31:0] prdata8;              //Read Data from the APB8 Interface8
   output clk_ctrl_reg_sel_18;         //Clock8 Control8 Reg8 Select8 TC_18 
   output clk_ctrl_reg_sel_28;         //Clock8 Control8 Reg8 Select8 TC_28 
   output clk_ctrl_reg_sel_38;         //Clock8 Control8 Reg8 Select8 TC_38 
   output cntr_ctrl_reg_sel_18;        //Counter8 Control8 Reg8 Select8 TC_18
   output cntr_ctrl_reg_sel_28;        //Counter8 Control8 Reg8 Select8 TC_28
   output cntr_ctrl_reg_sel_38;        //Counter8 Control8 Reg8 Select8 TC_38
   output interval_reg_sel_18;         //Interval8 Interrupt8 Reg8 Select8 TC_18 
   output interval_reg_sel_28;         //Interval8 Interrupt8 Reg8 Select8 TC_28 
   output interval_reg_sel_38;         //Interval8 Interrupt8 Reg8 Select8 TC_38 
   output match_1_reg_sel_18;          //Match8 Reg8 Select8 TC_18
   output match_1_reg_sel_28;          //Match8 Reg8 Select8 TC_28
   output match_1_reg_sel_38;          //Match8 Reg8 Select8 TC_38
   output match_2_reg_sel_18;          //Match8 Reg8 Select8 TC_18
   output match_2_reg_sel_28;          //Match8 Reg8 Select8 TC_28
   output match_2_reg_sel_38;          //Match8 Reg8 Select8 TC_38
   output match_3_reg_sel_18;          //Match8 Reg8 Select8 TC_18
   output match_3_reg_sel_28;          //Match8 Reg8 Select8 TC_28
   output match_3_reg_sel_38;          //Match8 Reg8 Select8 TC_38
   output [3:1] intr_en_reg_sel8;      //Interrupt8 Enable8 Reg8 Select8
   output [3:1] clear_interrupt8;      //Clear Interrupt8 line


//-----------------------------------------------------------------------------
// PARAMETER8 DECLARATIONS8
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR8   = 8'h00; //Clock8 control8 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR8   = 8'h04; //Clock8 control8 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR8   = 8'h08; //Clock8 control8 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR8  = 8'h0C; //Counter8 control8 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR8  = 8'h10; //Counter8 control8 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR8  = 8'h14; //Counter8 control8 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR8   = 8'h18; //Counter8 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR8   = 8'h1C; //Counter8 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR8   = 8'h20; //Counter8 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR8   = 8'h24; //Module8 1 interval8 address
   parameter   [7:0] INTERVAL_REG_2_ADDR8   = 8'h28; //Module8 2 interval8 address
   parameter   [7:0] INTERVAL_REG_3_ADDR8   = 8'h2C; //Module8 3 interval8 address
   parameter   [7:0] MATCH_1_REG_1_ADDR8    = 8'h30; //Module8 1 Match8 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR8    = 8'h34; //Module8 2 Match8 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR8    = 8'h38; //Module8 3 Match8 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR8    = 8'h3C; //Module8 1 Match8 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR8    = 8'h40; //Module8 2 Match8 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR8    = 8'h44; //Module8 3 Match8 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR8    = 8'h48; //Module8 1 Match8 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR8    = 8'h4C; //Module8 2 Match8 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR8    = 8'h50; //Module8 3 Match8 3 address
   parameter   [7:0] IRQ_REG_1_ADDR8        = 8'h54; //Interrupt8 register 1
   parameter   [7:0] IRQ_REG_2_ADDR8        = 8'h58; //Interrupt8 register 2
   parameter   [7:0] IRQ_REG_3_ADDR8        = 8'h5C; //Interrupt8 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR8     = 8'h60; //Interrupt8 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR8     = 8'h64; //Interrupt8 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR8     = 8'h68; //Interrupt8 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals8 & Registers8
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_18;         //Clock8 Control8 Reg8 Select8 TC_18
   reg clk_ctrl_reg_sel_28;         //Clock8 Control8 Reg8 Select8 TC_28 
   reg clk_ctrl_reg_sel_38;         //Clock8 Control8 Reg8 Select8 TC_38 
   reg cntr_ctrl_reg_sel_18;        //Counter8 Control8 Reg8 Select8 TC_18
   reg cntr_ctrl_reg_sel_28;        //Counter8 Control8 Reg8 Select8 TC_28
   reg cntr_ctrl_reg_sel_38;        //Counter8 Control8 Reg8 Select8 TC_38
   reg interval_reg_sel_18;         //Interval8 Interrupt8 Reg8 Select8 TC_18 
   reg interval_reg_sel_28;         //Interval8 Interrupt8 Reg8 Select8 TC_28
   reg interval_reg_sel_38;         //Interval8 Interrupt8 Reg8 Select8 TC_38
   reg match_1_reg_sel_18;          //Match8 Reg8 Select8 TC_18
   reg match_1_reg_sel_28;          //Match8 Reg8 Select8 TC_28
   reg match_1_reg_sel_38;          //Match8 Reg8 Select8 TC_38
   reg match_2_reg_sel_18;          //Match8 Reg8 Select8 TC_18
   reg match_2_reg_sel_28;          //Match8 Reg8 Select8 TC_28
   reg match_2_reg_sel_38;          //Match8 Reg8 Select8 TC_38
   reg match_3_reg_sel_18;          //Match8 Reg8 Select8 TC_18
   reg match_3_reg_sel_28;          //Match8 Reg8 Select8 TC_28
   reg match_3_reg_sel_38;          //Match8 Reg8 Select8 TC_38
   reg [3:1] intr_en_reg_sel8;      //Interrupt8 Enable8 1 Reg8 Select8
   reg [31:0] prdata8;              //APB8 read data
   
   wire [3:1] clear_interrupt8;     // 3-bit clear interrupt8 reg on read
   wire write;                     //APB8 write command  
   wire read;                      //APB8 read command    



   assign write = psel8 & penable8 & pwrite8;  
   assign read  = psel8 & ~pwrite8;  
   assign clear_interrupt8[1] = read & penable8 & (paddr8 == IRQ_REG_1_ADDR8);
   assign clear_interrupt8[2] = read & penable8 & (paddr8 == IRQ_REG_2_ADDR8);
   assign clear_interrupt8[3] = read & penable8 & (paddr8 == IRQ_REG_3_ADDR8);   
   
   //p_write_sel8: Process8 to select8 the required8 regs for write access.

   always @ (paddr8 or write)
   begin: p_write_sel8

       clk_ctrl_reg_sel_18  = (write && (paddr8 == CLK_CTRL_REG_1_ADDR8));
       clk_ctrl_reg_sel_28  = (write && (paddr8 == CLK_CTRL_REG_2_ADDR8));
       clk_ctrl_reg_sel_38  = (write && (paddr8 == CLK_CTRL_REG_3_ADDR8));
       cntr_ctrl_reg_sel_18 = (write && (paddr8 == CNTR_CTRL_REG_1_ADDR8));
       cntr_ctrl_reg_sel_28 = (write && (paddr8 == CNTR_CTRL_REG_2_ADDR8));
       cntr_ctrl_reg_sel_38 = (write && (paddr8 == CNTR_CTRL_REG_3_ADDR8));
       interval_reg_sel_18  = (write && (paddr8 == INTERVAL_REG_1_ADDR8));
       interval_reg_sel_28  = (write && (paddr8 == INTERVAL_REG_2_ADDR8));
       interval_reg_sel_38  = (write && (paddr8 == INTERVAL_REG_3_ADDR8));
       match_1_reg_sel_18   = (write && (paddr8 == MATCH_1_REG_1_ADDR8));
       match_1_reg_sel_28   = (write && (paddr8 == MATCH_1_REG_2_ADDR8));
       match_1_reg_sel_38   = (write && (paddr8 == MATCH_1_REG_3_ADDR8));
       match_2_reg_sel_18   = (write && (paddr8 == MATCH_2_REG_1_ADDR8));
       match_2_reg_sel_28   = (write && (paddr8 == MATCH_2_REG_2_ADDR8));
       match_2_reg_sel_38   = (write && (paddr8 == MATCH_2_REG_3_ADDR8));
       match_3_reg_sel_18   = (write && (paddr8 == MATCH_3_REG_1_ADDR8));
       match_3_reg_sel_28   = (write && (paddr8 == MATCH_3_REG_2_ADDR8));
       match_3_reg_sel_38   = (write && (paddr8 == MATCH_3_REG_3_ADDR8));
       intr_en_reg_sel8[1]  = (write && (paddr8 == IRQ_EN_REG_1_ADDR8));
       intr_en_reg_sel8[2]  = (write && (paddr8 == IRQ_EN_REG_2_ADDR8));
       intr_en_reg_sel8[3]  = (write && (paddr8 == IRQ_EN_REG_3_ADDR8));      
   end  //p_write_sel8
    

//    p_read_sel8: Process8 to enable the read operation8 to occur8.

   always @ (posedge pclk8 or negedge n_p_reset8)
   begin: p_read_sel8

      if (!n_p_reset8)                                   
      begin                                     
         prdata8 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr8)

               CLK_CTRL_REG_1_ADDR8 : prdata8 <= {25'h0000000,clk_ctrl_reg_18};
               CLK_CTRL_REG_2_ADDR8 : prdata8 <= {25'h0000000,clk_ctrl_reg_28};
               CLK_CTRL_REG_3_ADDR8 : prdata8 <= {25'h0000000,clk_ctrl_reg_38};
               CNTR_CTRL_REG_1_ADDR8: prdata8 <= {25'h0000000,cntr_ctrl_reg_18};
               CNTR_CTRL_REG_2_ADDR8: prdata8 <= {25'h0000000,cntr_ctrl_reg_28};
               CNTR_CTRL_REG_3_ADDR8: prdata8 <= {25'h0000000,cntr_ctrl_reg_38};
               CNTR_VAL_REG_1_ADDR8 : prdata8 <= {16'h0000,counter_val_reg_18};
               CNTR_VAL_REG_2_ADDR8 : prdata8 <= {16'h0000,counter_val_reg_28};
               CNTR_VAL_REG_3_ADDR8 : prdata8 <= {16'h0000,counter_val_reg_38};
               INTERVAL_REG_1_ADDR8 : prdata8 <= {16'h0000,interval_reg_18};
               INTERVAL_REG_2_ADDR8 : prdata8 <= {16'h0000,interval_reg_28};
               INTERVAL_REG_3_ADDR8 : prdata8 <= {16'h0000,interval_reg_38};
               MATCH_1_REG_1_ADDR8  : prdata8 <= {16'h0000,match_1_reg_18};
               MATCH_1_REG_2_ADDR8  : prdata8 <= {16'h0000,match_1_reg_28};
               MATCH_1_REG_3_ADDR8  : prdata8 <= {16'h0000,match_1_reg_38};
               MATCH_2_REG_1_ADDR8  : prdata8 <= {16'h0000,match_2_reg_18};
               MATCH_2_REG_2_ADDR8  : prdata8 <= {16'h0000,match_2_reg_28};
               MATCH_2_REG_3_ADDR8  : prdata8 <= {16'h0000,match_2_reg_38};
               MATCH_3_REG_1_ADDR8  : prdata8 <= {16'h0000,match_3_reg_18};
               MATCH_3_REG_2_ADDR8  : prdata8 <= {16'h0000,match_3_reg_28};
               MATCH_3_REG_3_ADDR8  : prdata8 <= {16'h0000,match_3_reg_38};
               IRQ_REG_1_ADDR8      : prdata8 <= {26'h0000,interrupt_reg_18};
               IRQ_REG_2_ADDR8      : prdata8 <= {26'h0000,interrupt_reg_28};
               IRQ_REG_3_ADDR8      : prdata8 <= {26'h0000,interrupt_reg_38};
               IRQ_EN_REG_1_ADDR8   : prdata8 <= {26'h0000,interrupt_en_reg_18};
               IRQ_EN_REG_2_ADDR8   : prdata8 <= {26'h0000,interrupt_en_reg_28};
               IRQ_EN_REG_3_ADDR8   : prdata8 <= {26'h0000,interrupt_en_reg_38};
               default             : prdata8 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata8 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset8)
      
   end // block: p_read_sel8

endmodule

