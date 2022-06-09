//File27 name   : ttc_interface_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : The APB27 interface with the triple27 timer27 counter
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module27 definition27
//----------------------------------------------------------------------------

module ttc_interface_lite27( 

  //inputs27
  n_p_reset27,    
  pclk27,                          
  psel27,
  penable27,
  pwrite27,
  paddr27,
  clk_ctrl_reg_127,
  clk_ctrl_reg_227,
  clk_ctrl_reg_327,
  cntr_ctrl_reg_127,
  cntr_ctrl_reg_227,
  cntr_ctrl_reg_327,
  counter_val_reg_127,
  counter_val_reg_227,
  counter_val_reg_327,
  interval_reg_127,
  match_1_reg_127,
  match_2_reg_127,
  match_3_reg_127,
  interval_reg_227,
  match_1_reg_227,
  match_2_reg_227,
  match_3_reg_227,
  interval_reg_327,
  match_1_reg_327,
  match_2_reg_327,
  match_3_reg_327,
  interrupt_reg_127,
  interrupt_reg_227,
  interrupt_reg_327,      
  interrupt_en_reg_127,
  interrupt_en_reg_227,
  interrupt_en_reg_327,
                  
  //outputs27
  prdata27,
  clk_ctrl_reg_sel_127,
  clk_ctrl_reg_sel_227,
  clk_ctrl_reg_sel_327,
  cntr_ctrl_reg_sel_127,
  cntr_ctrl_reg_sel_227,
  cntr_ctrl_reg_sel_327,
  interval_reg_sel_127,                            
  interval_reg_sel_227,                          
  interval_reg_sel_327,
  match_1_reg_sel_127,                          
  match_1_reg_sel_227,                          
  match_1_reg_sel_327,                
  match_2_reg_sel_127,                          
  match_2_reg_sel_227,
  match_2_reg_sel_327,
  match_3_reg_sel_127,                          
  match_3_reg_sel_227,                         
  match_3_reg_sel_327,
  intr_en_reg_sel27,
  clear_interrupt27        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS27
//----------------------------------------------------------------------------

   //inputs27
   input        n_p_reset27;              //reset signal27
   input        pclk27;                 //System27 Clock27
   input        psel27;                 //Select27 line
   input        penable27;              //Strobe27 line
   input        pwrite27;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr27;                //Address Bus27 register
   input [6:0]  clk_ctrl_reg_127;       //Clock27 Control27 reg for Timer_Counter27 1
   input [6:0]  cntr_ctrl_reg_127;      //Counter27 Control27 reg for Timer_Counter27 1
   input [6:0]  clk_ctrl_reg_227;       //Clock27 Control27 reg for Timer_Counter27 2
   input [6:0]  cntr_ctrl_reg_227;      //Counter27 Control27 reg for Timer27 Counter27 2
   input [6:0]  clk_ctrl_reg_327;       //Clock27 Control27 reg Timer_Counter27 3
   input [6:0]  cntr_ctrl_reg_327;      //Counter27 Control27 reg for Timer27 Counter27 3
   input [15:0] counter_val_reg_127;    //Counter27 Value from Timer_Counter27 1
   input [15:0] counter_val_reg_227;    //Counter27 Value from Timer_Counter27 2
   input [15:0] counter_val_reg_327;    //Counter27 Value from Timer_Counter27 3
   input [15:0] interval_reg_127;       //Interval27 reg value from Timer_Counter27 1
   input [15:0] match_1_reg_127;        //Match27 reg value from Timer_Counter27 
   input [15:0] match_2_reg_127;        //Match27 reg value from Timer_Counter27     
   input [15:0] match_3_reg_127;        //Match27 reg value from Timer_Counter27 
   input [15:0] interval_reg_227;       //Interval27 reg value from Timer_Counter27 2
   input [15:0] match_1_reg_227;        //Match27 reg value from Timer_Counter27     
   input [15:0] match_2_reg_227;        //Match27 reg value from Timer_Counter27     
   input [15:0] match_3_reg_227;        //Match27 reg value from Timer_Counter27 
   input [15:0] interval_reg_327;       //Interval27 reg value from Timer_Counter27 3
   input [15:0] match_1_reg_327;        //Match27 reg value from Timer_Counter27   
   input [15:0] match_2_reg_327;        //Match27 reg value from Timer_Counter27   
   input [15:0] match_3_reg_327;        //Match27 reg value from Timer_Counter27   
   input [5:0]  interrupt_reg_127;      //Interrupt27 Reg27 from Interrupt27 Module27 1
   input [5:0]  interrupt_reg_227;      //Interrupt27 Reg27 from Interrupt27 Module27 2
   input [5:0]  interrupt_reg_327;      //Interrupt27 Reg27 from Interrupt27 Module27 3
   input [5:0]  interrupt_en_reg_127;   //Interrupt27 Enable27 Reg27 from Intrpt27 Module27 1
   input [5:0]  interrupt_en_reg_227;   //Interrupt27 Enable27 Reg27 from Intrpt27 Module27 2
   input [5:0]  interrupt_en_reg_327;   //Interrupt27 Enable27 Reg27 from Intrpt27 Module27 3
   
   //outputs27
   output [31:0] prdata27;              //Read Data from the APB27 Interface27
   output clk_ctrl_reg_sel_127;         //Clock27 Control27 Reg27 Select27 TC_127 
   output clk_ctrl_reg_sel_227;         //Clock27 Control27 Reg27 Select27 TC_227 
   output clk_ctrl_reg_sel_327;         //Clock27 Control27 Reg27 Select27 TC_327 
   output cntr_ctrl_reg_sel_127;        //Counter27 Control27 Reg27 Select27 TC_127
   output cntr_ctrl_reg_sel_227;        //Counter27 Control27 Reg27 Select27 TC_227
   output cntr_ctrl_reg_sel_327;        //Counter27 Control27 Reg27 Select27 TC_327
   output interval_reg_sel_127;         //Interval27 Interrupt27 Reg27 Select27 TC_127 
   output interval_reg_sel_227;         //Interval27 Interrupt27 Reg27 Select27 TC_227 
   output interval_reg_sel_327;         //Interval27 Interrupt27 Reg27 Select27 TC_327 
   output match_1_reg_sel_127;          //Match27 Reg27 Select27 TC_127
   output match_1_reg_sel_227;          //Match27 Reg27 Select27 TC_227
   output match_1_reg_sel_327;          //Match27 Reg27 Select27 TC_327
   output match_2_reg_sel_127;          //Match27 Reg27 Select27 TC_127
   output match_2_reg_sel_227;          //Match27 Reg27 Select27 TC_227
   output match_2_reg_sel_327;          //Match27 Reg27 Select27 TC_327
   output match_3_reg_sel_127;          //Match27 Reg27 Select27 TC_127
   output match_3_reg_sel_227;          //Match27 Reg27 Select27 TC_227
   output match_3_reg_sel_327;          //Match27 Reg27 Select27 TC_327
   output [3:1] intr_en_reg_sel27;      //Interrupt27 Enable27 Reg27 Select27
   output [3:1] clear_interrupt27;      //Clear Interrupt27 line


//-----------------------------------------------------------------------------
// PARAMETER27 DECLARATIONS27
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR27   = 8'h00; //Clock27 control27 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR27   = 8'h04; //Clock27 control27 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR27   = 8'h08; //Clock27 control27 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR27  = 8'h0C; //Counter27 control27 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR27  = 8'h10; //Counter27 control27 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR27  = 8'h14; //Counter27 control27 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR27   = 8'h18; //Counter27 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR27   = 8'h1C; //Counter27 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR27   = 8'h20; //Counter27 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR27   = 8'h24; //Module27 1 interval27 address
   parameter   [7:0] INTERVAL_REG_2_ADDR27   = 8'h28; //Module27 2 interval27 address
   parameter   [7:0] INTERVAL_REG_3_ADDR27   = 8'h2C; //Module27 3 interval27 address
   parameter   [7:0] MATCH_1_REG_1_ADDR27    = 8'h30; //Module27 1 Match27 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR27    = 8'h34; //Module27 2 Match27 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR27    = 8'h38; //Module27 3 Match27 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR27    = 8'h3C; //Module27 1 Match27 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR27    = 8'h40; //Module27 2 Match27 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR27    = 8'h44; //Module27 3 Match27 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR27    = 8'h48; //Module27 1 Match27 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR27    = 8'h4C; //Module27 2 Match27 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR27    = 8'h50; //Module27 3 Match27 3 address
   parameter   [7:0] IRQ_REG_1_ADDR27        = 8'h54; //Interrupt27 register 1
   parameter   [7:0] IRQ_REG_2_ADDR27        = 8'h58; //Interrupt27 register 2
   parameter   [7:0] IRQ_REG_3_ADDR27        = 8'h5C; //Interrupt27 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR27     = 8'h60; //Interrupt27 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR27     = 8'h64; //Interrupt27 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR27     = 8'h68; //Interrupt27 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals27 & Registers27
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_127;         //Clock27 Control27 Reg27 Select27 TC_127
   reg clk_ctrl_reg_sel_227;         //Clock27 Control27 Reg27 Select27 TC_227 
   reg clk_ctrl_reg_sel_327;         //Clock27 Control27 Reg27 Select27 TC_327 
   reg cntr_ctrl_reg_sel_127;        //Counter27 Control27 Reg27 Select27 TC_127
   reg cntr_ctrl_reg_sel_227;        //Counter27 Control27 Reg27 Select27 TC_227
   reg cntr_ctrl_reg_sel_327;        //Counter27 Control27 Reg27 Select27 TC_327
   reg interval_reg_sel_127;         //Interval27 Interrupt27 Reg27 Select27 TC_127 
   reg interval_reg_sel_227;         //Interval27 Interrupt27 Reg27 Select27 TC_227
   reg interval_reg_sel_327;         //Interval27 Interrupt27 Reg27 Select27 TC_327
   reg match_1_reg_sel_127;          //Match27 Reg27 Select27 TC_127
   reg match_1_reg_sel_227;          //Match27 Reg27 Select27 TC_227
   reg match_1_reg_sel_327;          //Match27 Reg27 Select27 TC_327
   reg match_2_reg_sel_127;          //Match27 Reg27 Select27 TC_127
   reg match_2_reg_sel_227;          //Match27 Reg27 Select27 TC_227
   reg match_2_reg_sel_327;          //Match27 Reg27 Select27 TC_327
   reg match_3_reg_sel_127;          //Match27 Reg27 Select27 TC_127
   reg match_3_reg_sel_227;          //Match27 Reg27 Select27 TC_227
   reg match_3_reg_sel_327;          //Match27 Reg27 Select27 TC_327
   reg [3:1] intr_en_reg_sel27;      //Interrupt27 Enable27 1 Reg27 Select27
   reg [31:0] prdata27;              //APB27 read data
   
   wire [3:1] clear_interrupt27;     // 3-bit clear interrupt27 reg on read
   wire write;                     //APB27 write command  
   wire read;                      //APB27 read command    



   assign write = psel27 & penable27 & pwrite27;  
   assign read  = psel27 & ~pwrite27;  
   assign clear_interrupt27[1] = read & penable27 & (paddr27 == IRQ_REG_1_ADDR27);
   assign clear_interrupt27[2] = read & penable27 & (paddr27 == IRQ_REG_2_ADDR27);
   assign clear_interrupt27[3] = read & penable27 & (paddr27 == IRQ_REG_3_ADDR27);   
   
   //p_write_sel27: Process27 to select27 the required27 regs for write access.

   always @ (paddr27 or write)
   begin: p_write_sel27

       clk_ctrl_reg_sel_127  = (write && (paddr27 == CLK_CTRL_REG_1_ADDR27));
       clk_ctrl_reg_sel_227  = (write && (paddr27 == CLK_CTRL_REG_2_ADDR27));
       clk_ctrl_reg_sel_327  = (write && (paddr27 == CLK_CTRL_REG_3_ADDR27));
       cntr_ctrl_reg_sel_127 = (write && (paddr27 == CNTR_CTRL_REG_1_ADDR27));
       cntr_ctrl_reg_sel_227 = (write && (paddr27 == CNTR_CTRL_REG_2_ADDR27));
       cntr_ctrl_reg_sel_327 = (write && (paddr27 == CNTR_CTRL_REG_3_ADDR27));
       interval_reg_sel_127  = (write && (paddr27 == INTERVAL_REG_1_ADDR27));
       interval_reg_sel_227  = (write && (paddr27 == INTERVAL_REG_2_ADDR27));
       interval_reg_sel_327  = (write && (paddr27 == INTERVAL_REG_3_ADDR27));
       match_1_reg_sel_127   = (write && (paddr27 == MATCH_1_REG_1_ADDR27));
       match_1_reg_sel_227   = (write && (paddr27 == MATCH_1_REG_2_ADDR27));
       match_1_reg_sel_327   = (write && (paddr27 == MATCH_1_REG_3_ADDR27));
       match_2_reg_sel_127   = (write && (paddr27 == MATCH_2_REG_1_ADDR27));
       match_2_reg_sel_227   = (write && (paddr27 == MATCH_2_REG_2_ADDR27));
       match_2_reg_sel_327   = (write && (paddr27 == MATCH_2_REG_3_ADDR27));
       match_3_reg_sel_127   = (write && (paddr27 == MATCH_3_REG_1_ADDR27));
       match_3_reg_sel_227   = (write && (paddr27 == MATCH_3_REG_2_ADDR27));
       match_3_reg_sel_327   = (write && (paddr27 == MATCH_3_REG_3_ADDR27));
       intr_en_reg_sel27[1]  = (write && (paddr27 == IRQ_EN_REG_1_ADDR27));
       intr_en_reg_sel27[2]  = (write && (paddr27 == IRQ_EN_REG_2_ADDR27));
       intr_en_reg_sel27[3]  = (write && (paddr27 == IRQ_EN_REG_3_ADDR27));      
   end  //p_write_sel27
    

//    p_read_sel27: Process27 to enable the read operation27 to occur27.

   always @ (posedge pclk27 or negedge n_p_reset27)
   begin: p_read_sel27

      if (!n_p_reset27)                                   
      begin                                     
         prdata27 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr27)

               CLK_CTRL_REG_1_ADDR27 : prdata27 <= {25'h0000000,clk_ctrl_reg_127};
               CLK_CTRL_REG_2_ADDR27 : prdata27 <= {25'h0000000,clk_ctrl_reg_227};
               CLK_CTRL_REG_3_ADDR27 : prdata27 <= {25'h0000000,clk_ctrl_reg_327};
               CNTR_CTRL_REG_1_ADDR27: prdata27 <= {25'h0000000,cntr_ctrl_reg_127};
               CNTR_CTRL_REG_2_ADDR27: prdata27 <= {25'h0000000,cntr_ctrl_reg_227};
               CNTR_CTRL_REG_3_ADDR27: prdata27 <= {25'h0000000,cntr_ctrl_reg_327};
               CNTR_VAL_REG_1_ADDR27 : prdata27 <= {16'h0000,counter_val_reg_127};
               CNTR_VAL_REG_2_ADDR27 : prdata27 <= {16'h0000,counter_val_reg_227};
               CNTR_VAL_REG_3_ADDR27 : prdata27 <= {16'h0000,counter_val_reg_327};
               INTERVAL_REG_1_ADDR27 : prdata27 <= {16'h0000,interval_reg_127};
               INTERVAL_REG_2_ADDR27 : prdata27 <= {16'h0000,interval_reg_227};
               INTERVAL_REG_3_ADDR27 : prdata27 <= {16'h0000,interval_reg_327};
               MATCH_1_REG_1_ADDR27  : prdata27 <= {16'h0000,match_1_reg_127};
               MATCH_1_REG_2_ADDR27  : prdata27 <= {16'h0000,match_1_reg_227};
               MATCH_1_REG_3_ADDR27  : prdata27 <= {16'h0000,match_1_reg_327};
               MATCH_2_REG_1_ADDR27  : prdata27 <= {16'h0000,match_2_reg_127};
               MATCH_2_REG_2_ADDR27  : prdata27 <= {16'h0000,match_2_reg_227};
               MATCH_2_REG_3_ADDR27  : prdata27 <= {16'h0000,match_2_reg_327};
               MATCH_3_REG_1_ADDR27  : prdata27 <= {16'h0000,match_3_reg_127};
               MATCH_3_REG_2_ADDR27  : prdata27 <= {16'h0000,match_3_reg_227};
               MATCH_3_REG_3_ADDR27  : prdata27 <= {16'h0000,match_3_reg_327};
               IRQ_REG_1_ADDR27      : prdata27 <= {26'h0000,interrupt_reg_127};
               IRQ_REG_2_ADDR27      : prdata27 <= {26'h0000,interrupt_reg_227};
               IRQ_REG_3_ADDR27      : prdata27 <= {26'h0000,interrupt_reg_327};
               IRQ_EN_REG_1_ADDR27   : prdata27 <= {26'h0000,interrupt_en_reg_127};
               IRQ_EN_REG_2_ADDR27   : prdata27 <= {26'h0000,interrupt_en_reg_227};
               IRQ_EN_REG_3_ADDR27   : prdata27 <= {26'h0000,interrupt_en_reg_327};
               default             : prdata27 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata27 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset27)
      
   end // block: p_read_sel27

endmodule

