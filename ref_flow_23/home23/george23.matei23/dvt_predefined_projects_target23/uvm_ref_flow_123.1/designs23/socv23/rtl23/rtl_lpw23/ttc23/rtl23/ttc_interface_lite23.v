//File23 name   : ttc_interface_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : The APB23 interface with the triple23 timer23 counter
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module23 definition23
//----------------------------------------------------------------------------

module ttc_interface_lite23( 

  //inputs23
  n_p_reset23,    
  pclk23,                          
  psel23,
  penable23,
  pwrite23,
  paddr23,
  clk_ctrl_reg_123,
  clk_ctrl_reg_223,
  clk_ctrl_reg_323,
  cntr_ctrl_reg_123,
  cntr_ctrl_reg_223,
  cntr_ctrl_reg_323,
  counter_val_reg_123,
  counter_val_reg_223,
  counter_val_reg_323,
  interval_reg_123,
  match_1_reg_123,
  match_2_reg_123,
  match_3_reg_123,
  interval_reg_223,
  match_1_reg_223,
  match_2_reg_223,
  match_3_reg_223,
  interval_reg_323,
  match_1_reg_323,
  match_2_reg_323,
  match_3_reg_323,
  interrupt_reg_123,
  interrupt_reg_223,
  interrupt_reg_323,      
  interrupt_en_reg_123,
  interrupt_en_reg_223,
  interrupt_en_reg_323,
                  
  //outputs23
  prdata23,
  clk_ctrl_reg_sel_123,
  clk_ctrl_reg_sel_223,
  clk_ctrl_reg_sel_323,
  cntr_ctrl_reg_sel_123,
  cntr_ctrl_reg_sel_223,
  cntr_ctrl_reg_sel_323,
  interval_reg_sel_123,                            
  interval_reg_sel_223,                          
  interval_reg_sel_323,
  match_1_reg_sel_123,                          
  match_1_reg_sel_223,                          
  match_1_reg_sel_323,                
  match_2_reg_sel_123,                          
  match_2_reg_sel_223,
  match_2_reg_sel_323,
  match_3_reg_sel_123,                          
  match_3_reg_sel_223,                         
  match_3_reg_sel_323,
  intr_en_reg_sel23,
  clear_interrupt23        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS23
//----------------------------------------------------------------------------

   //inputs23
   input        n_p_reset23;              //reset signal23
   input        pclk23;                 //System23 Clock23
   input        psel23;                 //Select23 line
   input        penable23;              //Strobe23 line
   input        pwrite23;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr23;                //Address Bus23 register
   input [6:0]  clk_ctrl_reg_123;       //Clock23 Control23 reg for Timer_Counter23 1
   input [6:0]  cntr_ctrl_reg_123;      //Counter23 Control23 reg for Timer_Counter23 1
   input [6:0]  clk_ctrl_reg_223;       //Clock23 Control23 reg for Timer_Counter23 2
   input [6:0]  cntr_ctrl_reg_223;      //Counter23 Control23 reg for Timer23 Counter23 2
   input [6:0]  clk_ctrl_reg_323;       //Clock23 Control23 reg Timer_Counter23 3
   input [6:0]  cntr_ctrl_reg_323;      //Counter23 Control23 reg for Timer23 Counter23 3
   input [15:0] counter_val_reg_123;    //Counter23 Value from Timer_Counter23 1
   input [15:0] counter_val_reg_223;    //Counter23 Value from Timer_Counter23 2
   input [15:0] counter_val_reg_323;    //Counter23 Value from Timer_Counter23 3
   input [15:0] interval_reg_123;       //Interval23 reg value from Timer_Counter23 1
   input [15:0] match_1_reg_123;        //Match23 reg value from Timer_Counter23 
   input [15:0] match_2_reg_123;        //Match23 reg value from Timer_Counter23     
   input [15:0] match_3_reg_123;        //Match23 reg value from Timer_Counter23 
   input [15:0] interval_reg_223;       //Interval23 reg value from Timer_Counter23 2
   input [15:0] match_1_reg_223;        //Match23 reg value from Timer_Counter23     
   input [15:0] match_2_reg_223;        //Match23 reg value from Timer_Counter23     
   input [15:0] match_3_reg_223;        //Match23 reg value from Timer_Counter23 
   input [15:0] interval_reg_323;       //Interval23 reg value from Timer_Counter23 3
   input [15:0] match_1_reg_323;        //Match23 reg value from Timer_Counter23   
   input [15:0] match_2_reg_323;        //Match23 reg value from Timer_Counter23   
   input [15:0] match_3_reg_323;        //Match23 reg value from Timer_Counter23   
   input [5:0]  interrupt_reg_123;      //Interrupt23 Reg23 from Interrupt23 Module23 1
   input [5:0]  interrupt_reg_223;      //Interrupt23 Reg23 from Interrupt23 Module23 2
   input [5:0]  interrupt_reg_323;      //Interrupt23 Reg23 from Interrupt23 Module23 3
   input [5:0]  interrupt_en_reg_123;   //Interrupt23 Enable23 Reg23 from Intrpt23 Module23 1
   input [5:0]  interrupt_en_reg_223;   //Interrupt23 Enable23 Reg23 from Intrpt23 Module23 2
   input [5:0]  interrupt_en_reg_323;   //Interrupt23 Enable23 Reg23 from Intrpt23 Module23 3
   
   //outputs23
   output [31:0] prdata23;              //Read Data from the APB23 Interface23
   output clk_ctrl_reg_sel_123;         //Clock23 Control23 Reg23 Select23 TC_123 
   output clk_ctrl_reg_sel_223;         //Clock23 Control23 Reg23 Select23 TC_223 
   output clk_ctrl_reg_sel_323;         //Clock23 Control23 Reg23 Select23 TC_323 
   output cntr_ctrl_reg_sel_123;        //Counter23 Control23 Reg23 Select23 TC_123
   output cntr_ctrl_reg_sel_223;        //Counter23 Control23 Reg23 Select23 TC_223
   output cntr_ctrl_reg_sel_323;        //Counter23 Control23 Reg23 Select23 TC_323
   output interval_reg_sel_123;         //Interval23 Interrupt23 Reg23 Select23 TC_123 
   output interval_reg_sel_223;         //Interval23 Interrupt23 Reg23 Select23 TC_223 
   output interval_reg_sel_323;         //Interval23 Interrupt23 Reg23 Select23 TC_323 
   output match_1_reg_sel_123;          //Match23 Reg23 Select23 TC_123
   output match_1_reg_sel_223;          //Match23 Reg23 Select23 TC_223
   output match_1_reg_sel_323;          //Match23 Reg23 Select23 TC_323
   output match_2_reg_sel_123;          //Match23 Reg23 Select23 TC_123
   output match_2_reg_sel_223;          //Match23 Reg23 Select23 TC_223
   output match_2_reg_sel_323;          //Match23 Reg23 Select23 TC_323
   output match_3_reg_sel_123;          //Match23 Reg23 Select23 TC_123
   output match_3_reg_sel_223;          //Match23 Reg23 Select23 TC_223
   output match_3_reg_sel_323;          //Match23 Reg23 Select23 TC_323
   output [3:1] intr_en_reg_sel23;      //Interrupt23 Enable23 Reg23 Select23
   output [3:1] clear_interrupt23;      //Clear Interrupt23 line


//-----------------------------------------------------------------------------
// PARAMETER23 DECLARATIONS23
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR23   = 8'h00; //Clock23 control23 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR23   = 8'h04; //Clock23 control23 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR23   = 8'h08; //Clock23 control23 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR23  = 8'h0C; //Counter23 control23 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR23  = 8'h10; //Counter23 control23 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR23  = 8'h14; //Counter23 control23 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR23   = 8'h18; //Counter23 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR23   = 8'h1C; //Counter23 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR23   = 8'h20; //Counter23 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR23   = 8'h24; //Module23 1 interval23 address
   parameter   [7:0] INTERVAL_REG_2_ADDR23   = 8'h28; //Module23 2 interval23 address
   parameter   [7:0] INTERVAL_REG_3_ADDR23   = 8'h2C; //Module23 3 interval23 address
   parameter   [7:0] MATCH_1_REG_1_ADDR23    = 8'h30; //Module23 1 Match23 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR23    = 8'h34; //Module23 2 Match23 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR23    = 8'h38; //Module23 3 Match23 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR23    = 8'h3C; //Module23 1 Match23 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR23    = 8'h40; //Module23 2 Match23 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR23    = 8'h44; //Module23 3 Match23 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR23    = 8'h48; //Module23 1 Match23 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR23    = 8'h4C; //Module23 2 Match23 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR23    = 8'h50; //Module23 3 Match23 3 address
   parameter   [7:0] IRQ_REG_1_ADDR23        = 8'h54; //Interrupt23 register 1
   parameter   [7:0] IRQ_REG_2_ADDR23        = 8'h58; //Interrupt23 register 2
   parameter   [7:0] IRQ_REG_3_ADDR23        = 8'h5C; //Interrupt23 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR23     = 8'h60; //Interrupt23 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR23     = 8'h64; //Interrupt23 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR23     = 8'h68; //Interrupt23 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals23 & Registers23
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_123;         //Clock23 Control23 Reg23 Select23 TC_123
   reg clk_ctrl_reg_sel_223;         //Clock23 Control23 Reg23 Select23 TC_223 
   reg clk_ctrl_reg_sel_323;         //Clock23 Control23 Reg23 Select23 TC_323 
   reg cntr_ctrl_reg_sel_123;        //Counter23 Control23 Reg23 Select23 TC_123
   reg cntr_ctrl_reg_sel_223;        //Counter23 Control23 Reg23 Select23 TC_223
   reg cntr_ctrl_reg_sel_323;        //Counter23 Control23 Reg23 Select23 TC_323
   reg interval_reg_sel_123;         //Interval23 Interrupt23 Reg23 Select23 TC_123 
   reg interval_reg_sel_223;         //Interval23 Interrupt23 Reg23 Select23 TC_223
   reg interval_reg_sel_323;         //Interval23 Interrupt23 Reg23 Select23 TC_323
   reg match_1_reg_sel_123;          //Match23 Reg23 Select23 TC_123
   reg match_1_reg_sel_223;          //Match23 Reg23 Select23 TC_223
   reg match_1_reg_sel_323;          //Match23 Reg23 Select23 TC_323
   reg match_2_reg_sel_123;          //Match23 Reg23 Select23 TC_123
   reg match_2_reg_sel_223;          //Match23 Reg23 Select23 TC_223
   reg match_2_reg_sel_323;          //Match23 Reg23 Select23 TC_323
   reg match_3_reg_sel_123;          //Match23 Reg23 Select23 TC_123
   reg match_3_reg_sel_223;          //Match23 Reg23 Select23 TC_223
   reg match_3_reg_sel_323;          //Match23 Reg23 Select23 TC_323
   reg [3:1] intr_en_reg_sel23;      //Interrupt23 Enable23 1 Reg23 Select23
   reg [31:0] prdata23;              //APB23 read data
   
   wire [3:1] clear_interrupt23;     // 3-bit clear interrupt23 reg on read
   wire write;                     //APB23 write command  
   wire read;                      //APB23 read command    



   assign write = psel23 & penable23 & pwrite23;  
   assign read  = psel23 & ~pwrite23;  
   assign clear_interrupt23[1] = read & penable23 & (paddr23 == IRQ_REG_1_ADDR23);
   assign clear_interrupt23[2] = read & penable23 & (paddr23 == IRQ_REG_2_ADDR23);
   assign clear_interrupt23[3] = read & penable23 & (paddr23 == IRQ_REG_3_ADDR23);   
   
   //p_write_sel23: Process23 to select23 the required23 regs for write access.

   always @ (paddr23 or write)
   begin: p_write_sel23

       clk_ctrl_reg_sel_123  = (write && (paddr23 == CLK_CTRL_REG_1_ADDR23));
       clk_ctrl_reg_sel_223  = (write && (paddr23 == CLK_CTRL_REG_2_ADDR23));
       clk_ctrl_reg_sel_323  = (write && (paddr23 == CLK_CTRL_REG_3_ADDR23));
       cntr_ctrl_reg_sel_123 = (write && (paddr23 == CNTR_CTRL_REG_1_ADDR23));
       cntr_ctrl_reg_sel_223 = (write && (paddr23 == CNTR_CTRL_REG_2_ADDR23));
       cntr_ctrl_reg_sel_323 = (write && (paddr23 == CNTR_CTRL_REG_3_ADDR23));
       interval_reg_sel_123  = (write && (paddr23 == INTERVAL_REG_1_ADDR23));
       interval_reg_sel_223  = (write && (paddr23 == INTERVAL_REG_2_ADDR23));
       interval_reg_sel_323  = (write && (paddr23 == INTERVAL_REG_3_ADDR23));
       match_1_reg_sel_123   = (write && (paddr23 == MATCH_1_REG_1_ADDR23));
       match_1_reg_sel_223   = (write && (paddr23 == MATCH_1_REG_2_ADDR23));
       match_1_reg_sel_323   = (write && (paddr23 == MATCH_1_REG_3_ADDR23));
       match_2_reg_sel_123   = (write && (paddr23 == MATCH_2_REG_1_ADDR23));
       match_2_reg_sel_223   = (write && (paddr23 == MATCH_2_REG_2_ADDR23));
       match_2_reg_sel_323   = (write && (paddr23 == MATCH_2_REG_3_ADDR23));
       match_3_reg_sel_123   = (write && (paddr23 == MATCH_3_REG_1_ADDR23));
       match_3_reg_sel_223   = (write && (paddr23 == MATCH_3_REG_2_ADDR23));
       match_3_reg_sel_323   = (write && (paddr23 == MATCH_3_REG_3_ADDR23));
       intr_en_reg_sel23[1]  = (write && (paddr23 == IRQ_EN_REG_1_ADDR23));
       intr_en_reg_sel23[2]  = (write && (paddr23 == IRQ_EN_REG_2_ADDR23));
       intr_en_reg_sel23[3]  = (write && (paddr23 == IRQ_EN_REG_3_ADDR23));      
   end  //p_write_sel23
    

//    p_read_sel23: Process23 to enable the read operation23 to occur23.

   always @ (posedge pclk23 or negedge n_p_reset23)
   begin: p_read_sel23

      if (!n_p_reset23)                                   
      begin                                     
         prdata23 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr23)

               CLK_CTRL_REG_1_ADDR23 : prdata23 <= {25'h0000000,clk_ctrl_reg_123};
               CLK_CTRL_REG_2_ADDR23 : prdata23 <= {25'h0000000,clk_ctrl_reg_223};
               CLK_CTRL_REG_3_ADDR23 : prdata23 <= {25'h0000000,clk_ctrl_reg_323};
               CNTR_CTRL_REG_1_ADDR23: prdata23 <= {25'h0000000,cntr_ctrl_reg_123};
               CNTR_CTRL_REG_2_ADDR23: prdata23 <= {25'h0000000,cntr_ctrl_reg_223};
               CNTR_CTRL_REG_3_ADDR23: prdata23 <= {25'h0000000,cntr_ctrl_reg_323};
               CNTR_VAL_REG_1_ADDR23 : prdata23 <= {16'h0000,counter_val_reg_123};
               CNTR_VAL_REG_2_ADDR23 : prdata23 <= {16'h0000,counter_val_reg_223};
               CNTR_VAL_REG_3_ADDR23 : prdata23 <= {16'h0000,counter_val_reg_323};
               INTERVAL_REG_1_ADDR23 : prdata23 <= {16'h0000,interval_reg_123};
               INTERVAL_REG_2_ADDR23 : prdata23 <= {16'h0000,interval_reg_223};
               INTERVAL_REG_3_ADDR23 : prdata23 <= {16'h0000,interval_reg_323};
               MATCH_1_REG_1_ADDR23  : prdata23 <= {16'h0000,match_1_reg_123};
               MATCH_1_REG_2_ADDR23  : prdata23 <= {16'h0000,match_1_reg_223};
               MATCH_1_REG_3_ADDR23  : prdata23 <= {16'h0000,match_1_reg_323};
               MATCH_2_REG_1_ADDR23  : prdata23 <= {16'h0000,match_2_reg_123};
               MATCH_2_REG_2_ADDR23  : prdata23 <= {16'h0000,match_2_reg_223};
               MATCH_2_REG_3_ADDR23  : prdata23 <= {16'h0000,match_2_reg_323};
               MATCH_3_REG_1_ADDR23  : prdata23 <= {16'h0000,match_3_reg_123};
               MATCH_3_REG_2_ADDR23  : prdata23 <= {16'h0000,match_3_reg_223};
               MATCH_3_REG_3_ADDR23  : prdata23 <= {16'h0000,match_3_reg_323};
               IRQ_REG_1_ADDR23      : prdata23 <= {26'h0000,interrupt_reg_123};
               IRQ_REG_2_ADDR23      : prdata23 <= {26'h0000,interrupt_reg_223};
               IRQ_REG_3_ADDR23      : prdata23 <= {26'h0000,interrupt_reg_323};
               IRQ_EN_REG_1_ADDR23   : prdata23 <= {26'h0000,interrupt_en_reg_123};
               IRQ_EN_REG_2_ADDR23   : prdata23 <= {26'h0000,interrupt_en_reg_223};
               IRQ_EN_REG_3_ADDR23   : prdata23 <= {26'h0000,interrupt_en_reg_323};
               default             : prdata23 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata23 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset23)
      
   end // block: p_read_sel23

endmodule

