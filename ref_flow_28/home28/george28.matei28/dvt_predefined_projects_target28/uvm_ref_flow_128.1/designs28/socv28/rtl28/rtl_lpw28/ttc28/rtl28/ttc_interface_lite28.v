//File28 name   : ttc_interface_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : The APB28 interface with the triple28 timer28 counter
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module28 definition28
//----------------------------------------------------------------------------

module ttc_interface_lite28( 

  //inputs28
  n_p_reset28,    
  pclk28,                          
  psel28,
  penable28,
  pwrite28,
  paddr28,
  clk_ctrl_reg_128,
  clk_ctrl_reg_228,
  clk_ctrl_reg_328,
  cntr_ctrl_reg_128,
  cntr_ctrl_reg_228,
  cntr_ctrl_reg_328,
  counter_val_reg_128,
  counter_val_reg_228,
  counter_val_reg_328,
  interval_reg_128,
  match_1_reg_128,
  match_2_reg_128,
  match_3_reg_128,
  interval_reg_228,
  match_1_reg_228,
  match_2_reg_228,
  match_3_reg_228,
  interval_reg_328,
  match_1_reg_328,
  match_2_reg_328,
  match_3_reg_328,
  interrupt_reg_128,
  interrupt_reg_228,
  interrupt_reg_328,      
  interrupt_en_reg_128,
  interrupt_en_reg_228,
  interrupt_en_reg_328,
                  
  //outputs28
  prdata28,
  clk_ctrl_reg_sel_128,
  clk_ctrl_reg_sel_228,
  clk_ctrl_reg_sel_328,
  cntr_ctrl_reg_sel_128,
  cntr_ctrl_reg_sel_228,
  cntr_ctrl_reg_sel_328,
  interval_reg_sel_128,                            
  interval_reg_sel_228,                          
  interval_reg_sel_328,
  match_1_reg_sel_128,                          
  match_1_reg_sel_228,                          
  match_1_reg_sel_328,                
  match_2_reg_sel_128,                          
  match_2_reg_sel_228,
  match_2_reg_sel_328,
  match_3_reg_sel_128,                          
  match_3_reg_sel_228,                         
  match_3_reg_sel_328,
  intr_en_reg_sel28,
  clear_interrupt28        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS28
//----------------------------------------------------------------------------

   //inputs28
   input        n_p_reset28;              //reset signal28
   input        pclk28;                 //System28 Clock28
   input        psel28;                 //Select28 line
   input        penable28;              //Strobe28 line
   input        pwrite28;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr28;                //Address Bus28 register
   input [6:0]  clk_ctrl_reg_128;       //Clock28 Control28 reg for Timer_Counter28 1
   input [6:0]  cntr_ctrl_reg_128;      //Counter28 Control28 reg for Timer_Counter28 1
   input [6:0]  clk_ctrl_reg_228;       //Clock28 Control28 reg for Timer_Counter28 2
   input [6:0]  cntr_ctrl_reg_228;      //Counter28 Control28 reg for Timer28 Counter28 2
   input [6:0]  clk_ctrl_reg_328;       //Clock28 Control28 reg Timer_Counter28 3
   input [6:0]  cntr_ctrl_reg_328;      //Counter28 Control28 reg for Timer28 Counter28 3
   input [15:0] counter_val_reg_128;    //Counter28 Value from Timer_Counter28 1
   input [15:0] counter_val_reg_228;    //Counter28 Value from Timer_Counter28 2
   input [15:0] counter_val_reg_328;    //Counter28 Value from Timer_Counter28 3
   input [15:0] interval_reg_128;       //Interval28 reg value from Timer_Counter28 1
   input [15:0] match_1_reg_128;        //Match28 reg value from Timer_Counter28 
   input [15:0] match_2_reg_128;        //Match28 reg value from Timer_Counter28     
   input [15:0] match_3_reg_128;        //Match28 reg value from Timer_Counter28 
   input [15:0] interval_reg_228;       //Interval28 reg value from Timer_Counter28 2
   input [15:0] match_1_reg_228;        //Match28 reg value from Timer_Counter28     
   input [15:0] match_2_reg_228;        //Match28 reg value from Timer_Counter28     
   input [15:0] match_3_reg_228;        //Match28 reg value from Timer_Counter28 
   input [15:0] interval_reg_328;       //Interval28 reg value from Timer_Counter28 3
   input [15:0] match_1_reg_328;        //Match28 reg value from Timer_Counter28   
   input [15:0] match_2_reg_328;        //Match28 reg value from Timer_Counter28   
   input [15:0] match_3_reg_328;        //Match28 reg value from Timer_Counter28   
   input [5:0]  interrupt_reg_128;      //Interrupt28 Reg28 from Interrupt28 Module28 1
   input [5:0]  interrupt_reg_228;      //Interrupt28 Reg28 from Interrupt28 Module28 2
   input [5:0]  interrupt_reg_328;      //Interrupt28 Reg28 from Interrupt28 Module28 3
   input [5:0]  interrupt_en_reg_128;   //Interrupt28 Enable28 Reg28 from Intrpt28 Module28 1
   input [5:0]  interrupt_en_reg_228;   //Interrupt28 Enable28 Reg28 from Intrpt28 Module28 2
   input [5:0]  interrupt_en_reg_328;   //Interrupt28 Enable28 Reg28 from Intrpt28 Module28 3
   
   //outputs28
   output [31:0] prdata28;              //Read Data from the APB28 Interface28
   output clk_ctrl_reg_sel_128;         //Clock28 Control28 Reg28 Select28 TC_128 
   output clk_ctrl_reg_sel_228;         //Clock28 Control28 Reg28 Select28 TC_228 
   output clk_ctrl_reg_sel_328;         //Clock28 Control28 Reg28 Select28 TC_328 
   output cntr_ctrl_reg_sel_128;        //Counter28 Control28 Reg28 Select28 TC_128
   output cntr_ctrl_reg_sel_228;        //Counter28 Control28 Reg28 Select28 TC_228
   output cntr_ctrl_reg_sel_328;        //Counter28 Control28 Reg28 Select28 TC_328
   output interval_reg_sel_128;         //Interval28 Interrupt28 Reg28 Select28 TC_128 
   output interval_reg_sel_228;         //Interval28 Interrupt28 Reg28 Select28 TC_228 
   output interval_reg_sel_328;         //Interval28 Interrupt28 Reg28 Select28 TC_328 
   output match_1_reg_sel_128;          //Match28 Reg28 Select28 TC_128
   output match_1_reg_sel_228;          //Match28 Reg28 Select28 TC_228
   output match_1_reg_sel_328;          //Match28 Reg28 Select28 TC_328
   output match_2_reg_sel_128;          //Match28 Reg28 Select28 TC_128
   output match_2_reg_sel_228;          //Match28 Reg28 Select28 TC_228
   output match_2_reg_sel_328;          //Match28 Reg28 Select28 TC_328
   output match_3_reg_sel_128;          //Match28 Reg28 Select28 TC_128
   output match_3_reg_sel_228;          //Match28 Reg28 Select28 TC_228
   output match_3_reg_sel_328;          //Match28 Reg28 Select28 TC_328
   output [3:1] intr_en_reg_sel28;      //Interrupt28 Enable28 Reg28 Select28
   output [3:1] clear_interrupt28;      //Clear Interrupt28 line


//-----------------------------------------------------------------------------
// PARAMETER28 DECLARATIONS28
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR28   = 8'h00; //Clock28 control28 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR28   = 8'h04; //Clock28 control28 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR28   = 8'h08; //Clock28 control28 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR28  = 8'h0C; //Counter28 control28 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR28  = 8'h10; //Counter28 control28 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR28  = 8'h14; //Counter28 control28 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR28   = 8'h18; //Counter28 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR28   = 8'h1C; //Counter28 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR28   = 8'h20; //Counter28 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR28   = 8'h24; //Module28 1 interval28 address
   parameter   [7:0] INTERVAL_REG_2_ADDR28   = 8'h28; //Module28 2 interval28 address
   parameter   [7:0] INTERVAL_REG_3_ADDR28   = 8'h2C; //Module28 3 interval28 address
   parameter   [7:0] MATCH_1_REG_1_ADDR28    = 8'h30; //Module28 1 Match28 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR28    = 8'h34; //Module28 2 Match28 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR28    = 8'h38; //Module28 3 Match28 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR28    = 8'h3C; //Module28 1 Match28 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR28    = 8'h40; //Module28 2 Match28 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR28    = 8'h44; //Module28 3 Match28 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR28    = 8'h48; //Module28 1 Match28 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR28    = 8'h4C; //Module28 2 Match28 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR28    = 8'h50; //Module28 3 Match28 3 address
   parameter   [7:0] IRQ_REG_1_ADDR28        = 8'h54; //Interrupt28 register 1
   parameter   [7:0] IRQ_REG_2_ADDR28        = 8'h58; //Interrupt28 register 2
   parameter   [7:0] IRQ_REG_3_ADDR28        = 8'h5C; //Interrupt28 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR28     = 8'h60; //Interrupt28 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR28     = 8'h64; //Interrupt28 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR28     = 8'h68; //Interrupt28 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals28 & Registers28
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_128;         //Clock28 Control28 Reg28 Select28 TC_128
   reg clk_ctrl_reg_sel_228;         //Clock28 Control28 Reg28 Select28 TC_228 
   reg clk_ctrl_reg_sel_328;         //Clock28 Control28 Reg28 Select28 TC_328 
   reg cntr_ctrl_reg_sel_128;        //Counter28 Control28 Reg28 Select28 TC_128
   reg cntr_ctrl_reg_sel_228;        //Counter28 Control28 Reg28 Select28 TC_228
   reg cntr_ctrl_reg_sel_328;        //Counter28 Control28 Reg28 Select28 TC_328
   reg interval_reg_sel_128;         //Interval28 Interrupt28 Reg28 Select28 TC_128 
   reg interval_reg_sel_228;         //Interval28 Interrupt28 Reg28 Select28 TC_228
   reg interval_reg_sel_328;         //Interval28 Interrupt28 Reg28 Select28 TC_328
   reg match_1_reg_sel_128;          //Match28 Reg28 Select28 TC_128
   reg match_1_reg_sel_228;          //Match28 Reg28 Select28 TC_228
   reg match_1_reg_sel_328;          //Match28 Reg28 Select28 TC_328
   reg match_2_reg_sel_128;          //Match28 Reg28 Select28 TC_128
   reg match_2_reg_sel_228;          //Match28 Reg28 Select28 TC_228
   reg match_2_reg_sel_328;          //Match28 Reg28 Select28 TC_328
   reg match_3_reg_sel_128;          //Match28 Reg28 Select28 TC_128
   reg match_3_reg_sel_228;          //Match28 Reg28 Select28 TC_228
   reg match_3_reg_sel_328;          //Match28 Reg28 Select28 TC_328
   reg [3:1] intr_en_reg_sel28;      //Interrupt28 Enable28 1 Reg28 Select28
   reg [31:0] prdata28;              //APB28 read data
   
   wire [3:1] clear_interrupt28;     // 3-bit clear interrupt28 reg on read
   wire write;                     //APB28 write command  
   wire read;                      //APB28 read command    



   assign write = psel28 & penable28 & pwrite28;  
   assign read  = psel28 & ~pwrite28;  
   assign clear_interrupt28[1] = read & penable28 & (paddr28 == IRQ_REG_1_ADDR28);
   assign clear_interrupt28[2] = read & penable28 & (paddr28 == IRQ_REG_2_ADDR28);
   assign clear_interrupt28[3] = read & penable28 & (paddr28 == IRQ_REG_3_ADDR28);   
   
   //p_write_sel28: Process28 to select28 the required28 regs for write access.

   always @ (paddr28 or write)
   begin: p_write_sel28

       clk_ctrl_reg_sel_128  = (write && (paddr28 == CLK_CTRL_REG_1_ADDR28));
       clk_ctrl_reg_sel_228  = (write && (paddr28 == CLK_CTRL_REG_2_ADDR28));
       clk_ctrl_reg_sel_328  = (write && (paddr28 == CLK_CTRL_REG_3_ADDR28));
       cntr_ctrl_reg_sel_128 = (write && (paddr28 == CNTR_CTRL_REG_1_ADDR28));
       cntr_ctrl_reg_sel_228 = (write && (paddr28 == CNTR_CTRL_REG_2_ADDR28));
       cntr_ctrl_reg_sel_328 = (write && (paddr28 == CNTR_CTRL_REG_3_ADDR28));
       interval_reg_sel_128  = (write && (paddr28 == INTERVAL_REG_1_ADDR28));
       interval_reg_sel_228  = (write && (paddr28 == INTERVAL_REG_2_ADDR28));
       interval_reg_sel_328  = (write && (paddr28 == INTERVAL_REG_3_ADDR28));
       match_1_reg_sel_128   = (write && (paddr28 == MATCH_1_REG_1_ADDR28));
       match_1_reg_sel_228   = (write && (paddr28 == MATCH_1_REG_2_ADDR28));
       match_1_reg_sel_328   = (write && (paddr28 == MATCH_1_REG_3_ADDR28));
       match_2_reg_sel_128   = (write && (paddr28 == MATCH_2_REG_1_ADDR28));
       match_2_reg_sel_228   = (write && (paddr28 == MATCH_2_REG_2_ADDR28));
       match_2_reg_sel_328   = (write && (paddr28 == MATCH_2_REG_3_ADDR28));
       match_3_reg_sel_128   = (write && (paddr28 == MATCH_3_REG_1_ADDR28));
       match_3_reg_sel_228   = (write && (paddr28 == MATCH_3_REG_2_ADDR28));
       match_3_reg_sel_328   = (write && (paddr28 == MATCH_3_REG_3_ADDR28));
       intr_en_reg_sel28[1]  = (write && (paddr28 == IRQ_EN_REG_1_ADDR28));
       intr_en_reg_sel28[2]  = (write && (paddr28 == IRQ_EN_REG_2_ADDR28));
       intr_en_reg_sel28[3]  = (write && (paddr28 == IRQ_EN_REG_3_ADDR28));      
   end  //p_write_sel28
    

//    p_read_sel28: Process28 to enable the read operation28 to occur28.

   always @ (posedge pclk28 or negedge n_p_reset28)
   begin: p_read_sel28

      if (!n_p_reset28)                                   
      begin                                     
         prdata28 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr28)

               CLK_CTRL_REG_1_ADDR28 : prdata28 <= {25'h0000000,clk_ctrl_reg_128};
               CLK_CTRL_REG_2_ADDR28 : prdata28 <= {25'h0000000,clk_ctrl_reg_228};
               CLK_CTRL_REG_3_ADDR28 : prdata28 <= {25'h0000000,clk_ctrl_reg_328};
               CNTR_CTRL_REG_1_ADDR28: prdata28 <= {25'h0000000,cntr_ctrl_reg_128};
               CNTR_CTRL_REG_2_ADDR28: prdata28 <= {25'h0000000,cntr_ctrl_reg_228};
               CNTR_CTRL_REG_3_ADDR28: prdata28 <= {25'h0000000,cntr_ctrl_reg_328};
               CNTR_VAL_REG_1_ADDR28 : prdata28 <= {16'h0000,counter_val_reg_128};
               CNTR_VAL_REG_2_ADDR28 : prdata28 <= {16'h0000,counter_val_reg_228};
               CNTR_VAL_REG_3_ADDR28 : prdata28 <= {16'h0000,counter_val_reg_328};
               INTERVAL_REG_1_ADDR28 : prdata28 <= {16'h0000,interval_reg_128};
               INTERVAL_REG_2_ADDR28 : prdata28 <= {16'h0000,interval_reg_228};
               INTERVAL_REG_3_ADDR28 : prdata28 <= {16'h0000,interval_reg_328};
               MATCH_1_REG_1_ADDR28  : prdata28 <= {16'h0000,match_1_reg_128};
               MATCH_1_REG_2_ADDR28  : prdata28 <= {16'h0000,match_1_reg_228};
               MATCH_1_REG_3_ADDR28  : prdata28 <= {16'h0000,match_1_reg_328};
               MATCH_2_REG_1_ADDR28  : prdata28 <= {16'h0000,match_2_reg_128};
               MATCH_2_REG_2_ADDR28  : prdata28 <= {16'h0000,match_2_reg_228};
               MATCH_2_REG_3_ADDR28  : prdata28 <= {16'h0000,match_2_reg_328};
               MATCH_3_REG_1_ADDR28  : prdata28 <= {16'h0000,match_3_reg_128};
               MATCH_3_REG_2_ADDR28  : prdata28 <= {16'h0000,match_3_reg_228};
               MATCH_3_REG_3_ADDR28  : prdata28 <= {16'h0000,match_3_reg_328};
               IRQ_REG_1_ADDR28      : prdata28 <= {26'h0000,interrupt_reg_128};
               IRQ_REG_2_ADDR28      : prdata28 <= {26'h0000,interrupt_reg_228};
               IRQ_REG_3_ADDR28      : prdata28 <= {26'h0000,interrupt_reg_328};
               IRQ_EN_REG_1_ADDR28   : prdata28 <= {26'h0000,interrupt_en_reg_128};
               IRQ_EN_REG_2_ADDR28   : prdata28 <= {26'h0000,interrupt_en_reg_228};
               IRQ_EN_REG_3_ADDR28   : prdata28 <= {26'h0000,interrupt_en_reg_328};
               default             : prdata28 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata28 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset28)
      
   end // block: p_read_sel28

endmodule

