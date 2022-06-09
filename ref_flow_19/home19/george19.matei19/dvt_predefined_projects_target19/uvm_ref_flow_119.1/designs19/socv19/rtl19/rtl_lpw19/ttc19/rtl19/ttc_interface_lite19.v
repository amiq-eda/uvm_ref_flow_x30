//File19 name   : ttc_interface_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : The APB19 interface with the triple19 timer19 counter
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module19 definition19
//----------------------------------------------------------------------------

module ttc_interface_lite19( 

  //inputs19
  n_p_reset19,    
  pclk19,                          
  psel19,
  penable19,
  pwrite19,
  paddr19,
  clk_ctrl_reg_119,
  clk_ctrl_reg_219,
  clk_ctrl_reg_319,
  cntr_ctrl_reg_119,
  cntr_ctrl_reg_219,
  cntr_ctrl_reg_319,
  counter_val_reg_119,
  counter_val_reg_219,
  counter_val_reg_319,
  interval_reg_119,
  match_1_reg_119,
  match_2_reg_119,
  match_3_reg_119,
  interval_reg_219,
  match_1_reg_219,
  match_2_reg_219,
  match_3_reg_219,
  interval_reg_319,
  match_1_reg_319,
  match_2_reg_319,
  match_3_reg_319,
  interrupt_reg_119,
  interrupt_reg_219,
  interrupt_reg_319,      
  interrupt_en_reg_119,
  interrupt_en_reg_219,
  interrupt_en_reg_319,
                  
  //outputs19
  prdata19,
  clk_ctrl_reg_sel_119,
  clk_ctrl_reg_sel_219,
  clk_ctrl_reg_sel_319,
  cntr_ctrl_reg_sel_119,
  cntr_ctrl_reg_sel_219,
  cntr_ctrl_reg_sel_319,
  interval_reg_sel_119,                            
  interval_reg_sel_219,                          
  interval_reg_sel_319,
  match_1_reg_sel_119,                          
  match_1_reg_sel_219,                          
  match_1_reg_sel_319,                
  match_2_reg_sel_119,                          
  match_2_reg_sel_219,
  match_2_reg_sel_319,
  match_3_reg_sel_119,                          
  match_3_reg_sel_219,                         
  match_3_reg_sel_319,
  intr_en_reg_sel19,
  clear_interrupt19        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS19
//----------------------------------------------------------------------------

   //inputs19
   input        n_p_reset19;              //reset signal19
   input        pclk19;                 //System19 Clock19
   input        psel19;                 //Select19 line
   input        penable19;              //Strobe19 line
   input        pwrite19;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr19;                //Address Bus19 register
   input [6:0]  clk_ctrl_reg_119;       //Clock19 Control19 reg for Timer_Counter19 1
   input [6:0]  cntr_ctrl_reg_119;      //Counter19 Control19 reg for Timer_Counter19 1
   input [6:0]  clk_ctrl_reg_219;       //Clock19 Control19 reg for Timer_Counter19 2
   input [6:0]  cntr_ctrl_reg_219;      //Counter19 Control19 reg for Timer19 Counter19 2
   input [6:0]  clk_ctrl_reg_319;       //Clock19 Control19 reg Timer_Counter19 3
   input [6:0]  cntr_ctrl_reg_319;      //Counter19 Control19 reg for Timer19 Counter19 3
   input [15:0] counter_val_reg_119;    //Counter19 Value from Timer_Counter19 1
   input [15:0] counter_val_reg_219;    //Counter19 Value from Timer_Counter19 2
   input [15:0] counter_val_reg_319;    //Counter19 Value from Timer_Counter19 3
   input [15:0] interval_reg_119;       //Interval19 reg value from Timer_Counter19 1
   input [15:0] match_1_reg_119;        //Match19 reg value from Timer_Counter19 
   input [15:0] match_2_reg_119;        //Match19 reg value from Timer_Counter19     
   input [15:0] match_3_reg_119;        //Match19 reg value from Timer_Counter19 
   input [15:0] interval_reg_219;       //Interval19 reg value from Timer_Counter19 2
   input [15:0] match_1_reg_219;        //Match19 reg value from Timer_Counter19     
   input [15:0] match_2_reg_219;        //Match19 reg value from Timer_Counter19     
   input [15:0] match_3_reg_219;        //Match19 reg value from Timer_Counter19 
   input [15:0] interval_reg_319;       //Interval19 reg value from Timer_Counter19 3
   input [15:0] match_1_reg_319;        //Match19 reg value from Timer_Counter19   
   input [15:0] match_2_reg_319;        //Match19 reg value from Timer_Counter19   
   input [15:0] match_3_reg_319;        //Match19 reg value from Timer_Counter19   
   input [5:0]  interrupt_reg_119;      //Interrupt19 Reg19 from Interrupt19 Module19 1
   input [5:0]  interrupt_reg_219;      //Interrupt19 Reg19 from Interrupt19 Module19 2
   input [5:0]  interrupt_reg_319;      //Interrupt19 Reg19 from Interrupt19 Module19 3
   input [5:0]  interrupt_en_reg_119;   //Interrupt19 Enable19 Reg19 from Intrpt19 Module19 1
   input [5:0]  interrupt_en_reg_219;   //Interrupt19 Enable19 Reg19 from Intrpt19 Module19 2
   input [5:0]  interrupt_en_reg_319;   //Interrupt19 Enable19 Reg19 from Intrpt19 Module19 3
   
   //outputs19
   output [31:0] prdata19;              //Read Data from the APB19 Interface19
   output clk_ctrl_reg_sel_119;         //Clock19 Control19 Reg19 Select19 TC_119 
   output clk_ctrl_reg_sel_219;         //Clock19 Control19 Reg19 Select19 TC_219 
   output clk_ctrl_reg_sel_319;         //Clock19 Control19 Reg19 Select19 TC_319 
   output cntr_ctrl_reg_sel_119;        //Counter19 Control19 Reg19 Select19 TC_119
   output cntr_ctrl_reg_sel_219;        //Counter19 Control19 Reg19 Select19 TC_219
   output cntr_ctrl_reg_sel_319;        //Counter19 Control19 Reg19 Select19 TC_319
   output interval_reg_sel_119;         //Interval19 Interrupt19 Reg19 Select19 TC_119 
   output interval_reg_sel_219;         //Interval19 Interrupt19 Reg19 Select19 TC_219 
   output interval_reg_sel_319;         //Interval19 Interrupt19 Reg19 Select19 TC_319 
   output match_1_reg_sel_119;          //Match19 Reg19 Select19 TC_119
   output match_1_reg_sel_219;          //Match19 Reg19 Select19 TC_219
   output match_1_reg_sel_319;          //Match19 Reg19 Select19 TC_319
   output match_2_reg_sel_119;          //Match19 Reg19 Select19 TC_119
   output match_2_reg_sel_219;          //Match19 Reg19 Select19 TC_219
   output match_2_reg_sel_319;          //Match19 Reg19 Select19 TC_319
   output match_3_reg_sel_119;          //Match19 Reg19 Select19 TC_119
   output match_3_reg_sel_219;          //Match19 Reg19 Select19 TC_219
   output match_3_reg_sel_319;          //Match19 Reg19 Select19 TC_319
   output [3:1] intr_en_reg_sel19;      //Interrupt19 Enable19 Reg19 Select19
   output [3:1] clear_interrupt19;      //Clear Interrupt19 line


//-----------------------------------------------------------------------------
// PARAMETER19 DECLARATIONS19
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR19   = 8'h00; //Clock19 control19 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR19   = 8'h04; //Clock19 control19 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR19   = 8'h08; //Clock19 control19 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR19  = 8'h0C; //Counter19 control19 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR19  = 8'h10; //Counter19 control19 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR19  = 8'h14; //Counter19 control19 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR19   = 8'h18; //Counter19 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR19   = 8'h1C; //Counter19 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR19   = 8'h20; //Counter19 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR19   = 8'h24; //Module19 1 interval19 address
   parameter   [7:0] INTERVAL_REG_2_ADDR19   = 8'h28; //Module19 2 interval19 address
   parameter   [7:0] INTERVAL_REG_3_ADDR19   = 8'h2C; //Module19 3 interval19 address
   parameter   [7:0] MATCH_1_REG_1_ADDR19    = 8'h30; //Module19 1 Match19 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR19    = 8'h34; //Module19 2 Match19 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR19    = 8'h38; //Module19 3 Match19 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR19    = 8'h3C; //Module19 1 Match19 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR19    = 8'h40; //Module19 2 Match19 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR19    = 8'h44; //Module19 3 Match19 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR19    = 8'h48; //Module19 1 Match19 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR19    = 8'h4C; //Module19 2 Match19 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR19    = 8'h50; //Module19 3 Match19 3 address
   parameter   [7:0] IRQ_REG_1_ADDR19        = 8'h54; //Interrupt19 register 1
   parameter   [7:0] IRQ_REG_2_ADDR19        = 8'h58; //Interrupt19 register 2
   parameter   [7:0] IRQ_REG_3_ADDR19        = 8'h5C; //Interrupt19 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR19     = 8'h60; //Interrupt19 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR19     = 8'h64; //Interrupt19 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR19     = 8'h68; //Interrupt19 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals19 & Registers19
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_119;         //Clock19 Control19 Reg19 Select19 TC_119
   reg clk_ctrl_reg_sel_219;         //Clock19 Control19 Reg19 Select19 TC_219 
   reg clk_ctrl_reg_sel_319;         //Clock19 Control19 Reg19 Select19 TC_319 
   reg cntr_ctrl_reg_sel_119;        //Counter19 Control19 Reg19 Select19 TC_119
   reg cntr_ctrl_reg_sel_219;        //Counter19 Control19 Reg19 Select19 TC_219
   reg cntr_ctrl_reg_sel_319;        //Counter19 Control19 Reg19 Select19 TC_319
   reg interval_reg_sel_119;         //Interval19 Interrupt19 Reg19 Select19 TC_119 
   reg interval_reg_sel_219;         //Interval19 Interrupt19 Reg19 Select19 TC_219
   reg interval_reg_sel_319;         //Interval19 Interrupt19 Reg19 Select19 TC_319
   reg match_1_reg_sel_119;          //Match19 Reg19 Select19 TC_119
   reg match_1_reg_sel_219;          //Match19 Reg19 Select19 TC_219
   reg match_1_reg_sel_319;          //Match19 Reg19 Select19 TC_319
   reg match_2_reg_sel_119;          //Match19 Reg19 Select19 TC_119
   reg match_2_reg_sel_219;          //Match19 Reg19 Select19 TC_219
   reg match_2_reg_sel_319;          //Match19 Reg19 Select19 TC_319
   reg match_3_reg_sel_119;          //Match19 Reg19 Select19 TC_119
   reg match_3_reg_sel_219;          //Match19 Reg19 Select19 TC_219
   reg match_3_reg_sel_319;          //Match19 Reg19 Select19 TC_319
   reg [3:1] intr_en_reg_sel19;      //Interrupt19 Enable19 1 Reg19 Select19
   reg [31:0] prdata19;              //APB19 read data
   
   wire [3:1] clear_interrupt19;     // 3-bit clear interrupt19 reg on read
   wire write;                     //APB19 write command  
   wire read;                      //APB19 read command    



   assign write = psel19 & penable19 & pwrite19;  
   assign read  = psel19 & ~pwrite19;  
   assign clear_interrupt19[1] = read & penable19 & (paddr19 == IRQ_REG_1_ADDR19);
   assign clear_interrupt19[2] = read & penable19 & (paddr19 == IRQ_REG_2_ADDR19);
   assign clear_interrupt19[3] = read & penable19 & (paddr19 == IRQ_REG_3_ADDR19);   
   
   //p_write_sel19: Process19 to select19 the required19 regs for write access.

   always @ (paddr19 or write)
   begin: p_write_sel19

       clk_ctrl_reg_sel_119  = (write && (paddr19 == CLK_CTRL_REG_1_ADDR19));
       clk_ctrl_reg_sel_219  = (write && (paddr19 == CLK_CTRL_REG_2_ADDR19));
       clk_ctrl_reg_sel_319  = (write && (paddr19 == CLK_CTRL_REG_3_ADDR19));
       cntr_ctrl_reg_sel_119 = (write && (paddr19 == CNTR_CTRL_REG_1_ADDR19));
       cntr_ctrl_reg_sel_219 = (write && (paddr19 == CNTR_CTRL_REG_2_ADDR19));
       cntr_ctrl_reg_sel_319 = (write && (paddr19 == CNTR_CTRL_REG_3_ADDR19));
       interval_reg_sel_119  = (write && (paddr19 == INTERVAL_REG_1_ADDR19));
       interval_reg_sel_219  = (write && (paddr19 == INTERVAL_REG_2_ADDR19));
       interval_reg_sel_319  = (write && (paddr19 == INTERVAL_REG_3_ADDR19));
       match_1_reg_sel_119   = (write && (paddr19 == MATCH_1_REG_1_ADDR19));
       match_1_reg_sel_219   = (write && (paddr19 == MATCH_1_REG_2_ADDR19));
       match_1_reg_sel_319   = (write && (paddr19 == MATCH_1_REG_3_ADDR19));
       match_2_reg_sel_119   = (write && (paddr19 == MATCH_2_REG_1_ADDR19));
       match_2_reg_sel_219   = (write && (paddr19 == MATCH_2_REG_2_ADDR19));
       match_2_reg_sel_319   = (write && (paddr19 == MATCH_2_REG_3_ADDR19));
       match_3_reg_sel_119   = (write && (paddr19 == MATCH_3_REG_1_ADDR19));
       match_3_reg_sel_219   = (write && (paddr19 == MATCH_3_REG_2_ADDR19));
       match_3_reg_sel_319   = (write && (paddr19 == MATCH_3_REG_3_ADDR19));
       intr_en_reg_sel19[1]  = (write && (paddr19 == IRQ_EN_REG_1_ADDR19));
       intr_en_reg_sel19[2]  = (write && (paddr19 == IRQ_EN_REG_2_ADDR19));
       intr_en_reg_sel19[3]  = (write && (paddr19 == IRQ_EN_REG_3_ADDR19));      
   end  //p_write_sel19
    

//    p_read_sel19: Process19 to enable the read operation19 to occur19.

   always @ (posedge pclk19 or negedge n_p_reset19)
   begin: p_read_sel19

      if (!n_p_reset19)                                   
      begin                                     
         prdata19 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr19)

               CLK_CTRL_REG_1_ADDR19 : prdata19 <= {25'h0000000,clk_ctrl_reg_119};
               CLK_CTRL_REG_2_ADDR19 : prdata19 <= {25'h0000000,clk_ctrl_reg_219};
               CLK_CTRL_REG_3_ADDR19 : prdata19 <= {25'h0000000,clk_ctrl_reg_319};
               CNTR_CTRL_REG_1_ADDR19: prdata19 <= {25'h0000000,cntr_ctrl_reg_119};
               CNTR_CTRL_REG_2_ADDR19: prdata19 <= {25'h0000000,cntr_ctrl_reg_219};
               CNTR_CTRL_REG_3_ADDR19: prdata19 <= {25'h0000000,cntr_ctrl_reg_319};
               CNTR_VAL_REG_1_ADDR19 : prdata19 <= {16'h0000,counter_val_reg_119};
               CNTR_VAL_REG_2_ADDR19 : prdata19 <= {16'h0000,counter_val_reg_219};
               CNTR_VAL_REG_3_ADDR19 : prdata19 <= {16'h0000,counter_val_reg_319};
               INTERVAL_REG_1_ADDR19 : prdata19 <= {16'h0000,interval_reg_119};
               INTERVAL_REG_2_ADDR19 : prdata19 <= {16'h0000,interval_reg_219};
               INTERVAL_REG_3_ADDR19 : prdata19 <= {16'h0000,interval_reg_319};
               MATCH_1_REG_1_ADDR19  : prdata19 <= {16'h0000,match_1_reg_119};
               MATCH_1_REG_2_ADDR19  : prdata19 <= {16'h0000,match_1_reg_219};
               MATCH_1_REG_3_ADDR19  : prdata19 <= {16'h0000,match_1_reg_319};
               MATCH_2_REG_1_ADDR19  : prdata19 <= {16'h0000,match_2_reg_119};
               MATCH_2_REG_2_ADDR19  : prdata19 <= {16'h0000,match_2_reg_219};
               MATCH_2_REG_3_ADDR19  : prdata19 <= {16'h0000,match_2_reg_319};
               MATCH_3_REG_1_ADDR19  : prdata19 <= {16'h0000,match_3_reg_119};
               MATCH_3_REG_2_ADDR19  : prdata19 <= {16'h0000,match_3_reg_219};
               MATCH_3_REG_3_ADDR19  : prdata19 <= {16'h0000,match_3_reg_319};
               IRQ_REG_1_ADDR19      : prdata19 <= {26'h0000,interrupt_reg_119};
               IRQ_REG_2_ADDR19      : prdata19 <= {26'h0000,interrupt_reg_219};
               IRQ_REG_3_ADDR19      : prdata19 <= {26'h0000,interrupt_reg_319};
               IRQ_EN_REG_1_ADDR19   : prdata19 <= {26'h0000,interrupt_en_reg_119};
               IRQ_EN_REG_2_ADDR19   : prdata19 <= {26'h0000,interrupt_en_reg_219};
               IRQ_EN_REG_3_ADDR19   : prdata19 <= {26'h0000,interrupt_en_reg_319};
               default             : prdata19 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata19 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset19)
      
   end // block: p_read_sel19

endmodule

