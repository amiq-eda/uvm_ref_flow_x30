//File22 name   : ttc_interface_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : The APB22 interface with the triple22 timer22 counter
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module22 definition22
//----------------------------------------------------------------------------

module ttc_interface_lite22( 

  //inputs22
  n_p_reset22,    
  pclk22,                          
  psel22,
  penable22,
  pwrite22,
  paddr22,
  clk_ctrl_reg_122,
  clk_ctrl_reg_222,
  clk_ctrl_reg_322,
  cntr_ctrl_reg_122,
  cntr_ctrl_reg_222,
  cntr_ctrl_reg_322,
  counter_val_reg_122,
  counter_val_reg_222,
  counter_val_reg_322,
  interval_reg_122,
  match_1_reg_122,
  match_2_reg_122,
  match_3_reg_122,
  interval_reg_222,
  match_1_reg_222,
  match_2_reg_222,
  match_3_reg_222,
  interval_reg_322,
  match_1_reg_322,
  match_2_reg_322,
  match_3_reg_322,
  interrupt_reg_122,
  interrupt_reg_222,
  interrupt_reg_322,      
  interrupt_en_reg_122,
  interrupt_en_reg_222,
  interrupt_en_reg_322,
                  
  //outputs22
  prdata22,
  clk_ctrl_reg_sel_122,
  clk_ctrl_reg_sel_222,
  clk_ctrl_reg_sel_322,
  cntr_ctrl_reg_sel_122,
  cntr_ctrl_reg_sel_222,
  cntr_ctrl_reg_sel_322,
  interval_reg_sel_122,                            
  interval_reg_sel_222,                          
  interval_reg_sel_322,
  match_1_reg_sel_122,                          
  match_1_reg_sel_222,                          
  match_1_reg_sel_322,                
  match_2_reg_sel_122,                          
  match_2_reg_sel_222,
  match_2_reg_sel_322,
  match_3_reg_sel_122,                          
  match_3_reg_sel_222,                         
  match_3_reg_sel_322,
  intr_en_reg_sel22,
  clear_interrupt22        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS22
//----------------------------------------------------------------------------

   //inputs22
   input        n_p_reset22;              //reset signal22
   input        pclk22;                 //System22 Clock22
   input        psel22;                 //Select22 line
   input        penable22;              //Strobe22 line
   input        pwrite22;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr22;                //Address Bus22 register
   input [6:0]  clk_ctrl_reg_122;       //Clock22 Control22 reg for Timer_Counter22 1
   input [6:0]  cntr_ctrl_reg_122;      //Counter22 Control22 reg for Timer_Counter22 1
   input [6:0]  clk_ctrl_reg_222;       //Clock22 Control22 reg for Timer_Counter22 2
   input [6:0]  cntr_ctrl_reg_222;      //Counter22 Control22 reg for Timer22 Counter22 2
   input [6:0]  clk_ctrl_reg_322;       //Clock22 Control22 reg Timer_Counter22 3
   input [6:0]  cntr_ctrl_reg_322;      //Counter22 Control22 reg for Timer22 Counter22 3
   input [15:0] counter_val_reg_122;    //Counter22 Value from Timer_Counter22 1
   input [15:0] counter_val_reg_222;    //Counter22 Value from Timer_Counter22 2
   input [15:0] counter_val_reg_322;    //Counter22 Value from Timer_Counter22 3
   input [15:0] interval_reg_122;       //Interval22 reg value from Timer_Counter22 1
   input [15:0] match_1_reg_122;        //Match22 reg value from Timer_Counter22 
   input [15:0] match_2_reg_122;        //Match22 reg value from Timer_Counter22     
   input [15:0] match_3_reg_122;        //Match22 reg value from Timer_Counter22 
   input [15:0] interval_reg_222;       //Interval22 reg value from Timer_Counter22 2
   input [15:0] match_1_reg_222;        //Match22 reg value from Timer_Counter22     
   input [15:0] match_2_reg_222;        //Match22 reg value from Timer_Counter22     
   input [15:0] match_3_reg_222;        //Match22 reg value from Timer_Counter22 
   input [15:0] interval_reg_322;       //Interval22 reg value from Timer_Counter22 3
   input [15:0] match_1_reg_322;        //Match22 reg value from Timer_Counter22   
   input [15:0] match_2_reg_322;        //Match22 reg value from Timer_Counter22   
   input [15:0] match_3_reg_322;        //Match22 reg value from Timer_Counter22   
   input [5:0]  interrupt_reg_122;      //Interrupt22 Reg22 from Interrupt22 Module22 1
   input [5:0]  interrupt_reg_222;      //Interrupt22 Reg22 from Interrupt22 Module22 2
   input [5:0]  interrupt_reg_322;      //Interrupt22 Reg22 from Interrupt22 Module22 3
   input [5:0]  interrupt_en_reg_122;   //Interrupt22 Enable22 Reg22 from Intrpt22 Module22 1
   input [5:0]  interrupt_en_reg_222;   //Interrupt22 Enable22 Reg22 from Intrpt22 Module22 2
   input [5:0]  interrupt_en_reg_322;   //Interrupt22 Enable22 Reg22 from Intrpt22 Module22 3
   
   //outputs22
   output [31:0] prdata22;              //Read Data from the APB22 Interface22
   output clk_ctrl_reg_sel_122;         //Clock22 Control22 Reg22 Select22 TC_122 
   output clk_ctrl_reg_sel_222;         //Clock22 Control22 Reg22 Select22 TC_222 
   output clk_ctrl_reg_sel_322;         //Clock22 Control22 Reg22 Select22 TC_322 
   output cntr_ctrl_reg_sel_122;        //Counter22 Control22 Reg22 Select22 TC_122
   output cntr_ctrl_reg_sel_222;        //Counter22 Control22 Reg22 Select22 TC_222
   output cntr_ctrl_reg_sel_322;        //Counter22 Control22 Reg22 Select22 TC_322
   output interval_reg_sel_122;         //Interval22 Interrupt22 Reg22 Select22 TC_122 
   output interval_reg_sel_222;         //Interval22 Interrupt22 Reg22 Select22 TC_222 
   output interval_reg_sel_322;         //Interval22 Interrupt22 Reg22 Select22 TC_322 
   output match_1_reg_sel_122;          //Match22 Reg22 Select22 TC_122
   output match_1_reg_sel_222;          //Match22 Reg22 Select22 TC_222
   output match_1_reg_sel_322;          //Match22 Reg22 Select22 TC_322
   output match_2_reg_sel_122;          //Match22 Reg22 Select22 TC_122
   output match_2_reg_sel_222;          //Match22 Reg22 Select22 TC_222
   output match_2_reg_sel_322;          //Match22 Reg22 Select22 TC_322
   output match_3_reg_sel_122;          //Match22 Reg22 Select22 TC_122
   output match_3_reg_sel_222;          //Match22 Reg22 Select22 TC_222
   output match_3_reg_sel_322;          //Match22 Reg22 Select22 TC_322
   output [3:1] intr_en_reg_sel22;      //Interrupt22 Enable22 Reg22 Select22
   output [3:1] clear_interrupt22;      //Clear Interrupt22 line


//-----------------------------------------------------------------------------
// PARAMETER22 DECLARATIONS22
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR22   = 8'h00; //Clock22 control22 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR22   = 8'h04; //Clock22 control22 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR22   = 8'h08; //Clock22 control22 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR22  = 8'h0C; //Counter22 control22 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR22  = 8'h10; //Counter22 control22 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR22  = 8'h14; //Counter22 control22 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR22   = 8'h18; //Counter22 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR22   = 8'h1C; //Counter22 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR22   = 8'h20; //Counter22 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR22   = 8'h24; //Module22 1 interval22 address
   parameter   [7:0] INTERVAL_REG_2_ADDR22   = 8'h28; //Module22 2 interval22 address
   parameter   [7:0] INTERVAL_REG_3_ADDR22   = 8'h2C; //Module22 3 interval22 address
   parameter   [7:0] MATCH_1_REG_1_ADDR22    = 8'h30; //Module22 1 Match22 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR22    = 8'h34; //Module22 2 Match22 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR22    = 8'h38; //Module22 3 Match22 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR22    = 8'h3C; //Module22 1 Match22 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR22    = 8'h40; //Module22 2 Match22 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR22    = 8'h44; //Module22 3 Match22 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR22    = 8'h48; //Module22 1 Match22 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR22    = 8'h4C; //Module22 2 Match22 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR22    = 8'h50; //Module22 3 Match22 3 address
   parameter   [7:0] IRQ_REG_1_ADDR22        = 8'h54; //Interrupt22 register 1
   parameter   [7:0] IRQ_REG_2_ADDR22        = 8'h58; //Interrupt22 register 2
   parameter   [7:0] IRQ_REG_3_ADDR22        = 8'h5C; //Interrupt22 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR22     = 8'h60; //Interrupt22 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR22     = 8'h64; //Interrupt22 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR22     = 8'h68; //Interrupt22 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals22 & Registers22
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_122;         //Clock22 Control22 Reg22 Select22 TC_122
   reg clk_ctrl_reg_sel_222;         //Clock22 Control22 Reg22 Select22 TC_222 
   reg clk_ctrl_reg_sel_322;         //Clock22 Control22 Reg22 Select22 TC_322 
   reg cntr_ctrl_reg_sel_122;        //Counter22 Control22 Reg22 Select22 TC_122
   reg cntr_ctrl_reg_sel_222;        //Counter22 Control22 Reg22 Select22 TC_222
   reg cntr_ctrl_reg_sel_322;        //Counter22 Control22 Reg22 Select22 TC_322
   reg interval_reg_sel_122;         //Interval22 Interrupt22 Reg22 Select22 TC_122 
   reg interval_reg_sel_222;         //Interval22 Interrupt22 Reg22 Select22 TC_222
   reg interval_reg_sel_322;         //Interval22 Interrupt22 Reg22 Select22 TC_322
   reg match_1_reg_sel_122;          //Match22 Reg22 Select22 TC_122
   reg match_1_reg_sel_222;          //Match22 Reg22 Select22 TC_222
   reg match_1_reg_sel_322;          //Match22 Reg22 Select22 TC_322
   reg match_2_reg_sel_122;          //Match22 Reg22 Select22 TC_122
   reg match_2_reg_sel_222;          //Match22 Reg22 Select22 TC_222
   reg match_2_reg_sel_322;          //Match22 Reg22 Select22 TC_322
   reg match_3_reg_sel_122;          //Match22 Reg22 Select22 TC_122
   reg match_3_reg_sel_222;          //Match22 Reg22 Select22 TC_222
   reg match_3_reg_sel_322;          //Match22 Reg22 Select22 TC_322
   reg [3:1] intr_en_reg_sel22;      //Interrupt22 Enable22 1 Reg22 Select22
   reg [31:0] prdata22;              //APB22 read data
   
   wire [3:1] clear_interrupt22;     // 3-bit clear interrupt22 reg on read
   wire write;                     //APB22 write command  
   wire read;                      //APB22 read command    



   assign write = psel22 & penable22 & pwrite22;  
   assign read  = psel22 & ~pwrite22;  
   assign clear_interrupt22[1] = read & penable22 & (paddr22 == IRQ_REG_1_ADDR22);
   assign clear_interrupt22[2] = read & penable22 & (paddr22 == IRQ_REG_2_ADDR22);
   assign clear_interrupt22[3] = read & penable22 & (paddr22 == IRQ_REG_3_ADDR22);   
   
   //p_write_sel22: Process22 to select22 the required22 regs for write access.

   always @ (paddr22 or write)
   begin: p_write_sel22

       clk_ctrl_reg_sel_122  = (write && (paddr22 == CLK_CTRL_REG_1_ADDR22));
       clk_ctrl_reg_sel_222  = (write && (paddr22 == CLK_CTRL_REG_2_ADDR22));
       clk_ctrl_reg_sel_322  = (write && (paddr22 == CLK_CTRL_REG_3_ADDR22));
       cntr_ctrl_reg_sel_122 = (write && (paddr22 == CNTR_CTRL_REG_1_ADDR22));
       cntr_ctrl_reg_sel_222 = (write && (paddr22 == CNTR_CTRL_REG_2_ADDR22));
       cntr_ctrl_reg_sel_322 = (write && (paddr22 == CNTR_CTRL_REG_3_ADDR22));
       interval_reg_sel_122  = (write && (paddr22 == INTERVAL_REG_1_ADDR22));
       interval_reg_sel_222  = (write && (paddr22 == INTERVAL_REG_2_ADDR22));
       interval_reg_sel_322  = (write && (paddr22 == INTERVAL_REG_3_ADDR22));
       match_1_reg_sel_122   = (write && (paddr22 == MATCH_1_REG_1_ADDR22));
       match_1_reg_sel_222   = (write && (paddr22 == MATCH_1_REG_2_ADDR22));
       match_1_reg_sel_322   = (write && (paddr22 == MATCH_1_REG_3_ADDR22));
       match_2_reg_sel_122   = (write && (paddr22 == MATCH_2_REG_1_ADDR22));
       match_2_reg_sel_222   = (write && (paddr22 == MATCH_2_REG_2_ADDR22));
       match_2_reg_sel_322   = (write && (paddr22 == MATCH_2_REG_3_ADDR22));
       match_3_reg_sel_122   = (write && (paddr22 == MATCH_3_REG_1_ADDR22));
       match_3_reg_sel_222   = (write && (paddr22 == MATCH_3_REG_2_ADDR22));
       match_3_reg_sel_322   = (write && (paddr22 == MATCH_3_REG_3_ADDR22));
       intr_en_reg_sel22[1]  = (write && (paddr22 == IRQ_EN_REG_1_ADDR22));
       intr_en_reg_sel22[2]  = (write && (paddr22 == IRQ_EN_REG_2_ADDR22));
       intr_en_reg_sel22[3]  = (write && (paddr22 == IRQ_EN_REG_3_ADDR22));      
   end  //p_write_sel22
    

//    p_read_sel22: Process22 to enable the read operation22 to occur22.

   always @ (posedge pclk22 or negedge n_p_reset22)
   begin: p_read_sel22

      if (!n_p_reset22)                                   
      begin                                     
         prdata22 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr22)

               CLK_CTRL_REG_1_ADDR22 : prdata22 <= {25'h0000000,clk_ctrl_reg_122};
               CLK_CTRL_REG_2_ADDR22 : prdata22 <= {25'h0000000,clk_ctrl_reg_222};
               CLK_CTRL_REG_3_ADDR22 : prdata22 <= {25'h0000000,clk_ctrl_reg_322};
               CNTR_CTRL_REG_1_ADDR22: prdata22 <= {25'h0000000,cntr_ctrl_reg_122};
               CNTR_CTRL_REG_2_ADDR22: prdata22 <= {25'h0000000,cntr_ctrl_reg_222};
               CNTR_CTRL_REG_3_ADDR22: prdata22 <= {25'h0000000,cntr_ctrl_reg_322};
               CNTR_VAL_REG_1_ADDR22 : prdata22 <= {16'h0000,counter_val_reg_122};
               CNTR_VAL_REG_2_ADDR22 : prdata22 <= {16'h0000,counter_val_reg_222};
               CNTR_VAL_REG_3_ADDR22 : prdata22 <= {16'h0000,counter_val_reg_322};
               INTERVAL_REG_1_ADDR22 : prdata22 <= {16'h0000,interval_reg_122};
               INTERVAL_REG_2_ADDR22 : prdata22 <= {16'h0000,interval_reg_222};
               INTERVAL_REG_3_ADDR22 : prdata22 <= {16'h0000,interval_reg_322};
               MATCH_1_REG_1_ADDR22  : prdata22 <= {16'h0000,match_1_reg_122};
               MATCH_1_REG_2_ADDR22  : prdata22 <= {16'h0000,match_1_reg_222};
               MATCH_1_REG_3_ADDR22  : prdata22 <= {16'h0000,match_1_reg_322};
               MATCH_2_REG_1_ADDR22  : prdata22 <= {16'h0000,match_2_reg_122};
               MATCH_2_REG_2_ADDR22  : prdata22 <= {16'h0000,match_2_reg_222};
               MATCH_2_REG_3_ADDR22  : prdata22 <= {16'h0000,match_2_reg_322};
               MATCH_3_REG_1_ADDR22  : prdata22 <= {16'h0000,match_3_reg_122};
               MATCH_3_REG_2_ADDR22  : prdata22 <= {16'h0000,match_3_reg_222};
               MATCH_3_REG_3_ADDR22  : prdata22 <= {16'h0000,match_3_reg_322};
               IRQ_REG_1_ADDR22      : prdata22 <= {26'h0000,interrupt_reg_122};
               IRQ_REG_2_ADDR22      : prdata22 <= {26'h0000,interrupt_reg_222};
               IRQ_REG_3_ADDR22      : prdata22 <= {26'h0000,interrupt_reg_322};
               IRQ_EN_REG_1_ADDR22   : prdata22 <= {26'h0000,interrupt_en_reg_122};
               IRQ_EN_REG_2_ADDR22   : prdata22 <= {26'h0000,interrupt_en_reg_222};
               IRQ_EN_REG_3_ADDR22   : prdata22 <= {26'h0000,interrupt_en_reg_322};
               default             : prdata22 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata22 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset22)
      
   end // block: p_read_sel22

endmodule

