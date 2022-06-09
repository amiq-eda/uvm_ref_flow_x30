//File3 name   : ttc_interface_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : The APB3 interface with the triple3 timer3 counter
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module3 definition3
//----------------------------------------------------------------------------

module ttc_interface_lite3( 

  //inputs3
  n_p_reset3,    
  pclk3,                          
  psel3,
  penable3,
  pwrite3,
  paddr3,
  clk_ctrl_reg_13,
  clk_ctrl_reg_23,
  clk_ctrl_reg_33,
  cntr_ctrl_reg_13,
  cntr_ctrl_reg_23,
  cntr_ctrl_reg_33,
  counter_val_reg_13,
  counter_val_reg_23,
  counter_val_reg_33,
  interval_reg_13,
  match_1_reg_13,
  match_2_reg_13,
  match_3_reg_13,
  interval_reg_23,
  match_1_reg_23,
  match_2_reg_23,
  match_3_reg_23,
  interval_reg_33,
  match_1_reg_33,
  match_2_reg_33,
  match_3_reg_33,
  interrupt_reg_13,
  interrupt_reg_23,
  interrupt_reg_33,      
  interrupt_en_reg_13,
  interrupt_en_reg_23,
  interrupt_en_reg_33,
                  
  //outputs3
  prdata3,
  clk_ctrl_reg_sel_13,
  clk_ctrl_reg_sel_23,
  clk_ctrl_reg_sel_33,
  cntr_ctrl_reg_sel_13,
  cntr_ctrl_reg_sel_23,
  cntr_ctrl_reg_sel_33,
  interval_reg_sel_13,                            
  interval_reg_sel_23,                          
  interval_reg_sel_33,
  match_1_reg_sel_13,                          
  match_1_reg_sel_23,                          
  match_1_reg_sel_33,                
  match_2_reg_sel_13,                          
  match_2_reg_sel_23,
  match_2_reg_sel_33,
  match_3_reg_sel_13,                          
  match_3_reg_sel_23,                         
  match_3_reg_sel_33,
  intr_en_reg_sel3,
  clear_interrupt3        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS3
//----------------------------------------------------------------------------

   //inputs3
   input        n_p_reset3;              //reset signal3
   input        pclk3;                 //System3 Clock3
   input        psel3;                 //Select3 line
   input        penable3;              //Strobe3 line
   input        pwrite3;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr3;                //Address Bus3 register
   input [6:0]  clk_ctrl_reg_13;       //Clock3 Control3 reg for Timer_Counter3 1
   input [6:0]  cntr_ctrl_reg_13;      //Counter3 Control3 reg for Timer_Counter3 1
   input [6:0]  clk_ctrl_reg_23;       //Clock3 Control3 reg for Timer_Counter3 2
   input [6:0]  cntr_ctrl_reg_23;      //Counter3 Control3 reg for Timer3 Counter3 2
   input [6:0]  clk_ctrl_reg_33;       //Clock3 Control3 reg Timer_Counter3 3
   input [6:0]  cntr_ctrl_reg_33;      //Counter3 Control3 reg for Timer3 Counter3 3
   input [15:0] counter_val_reg_13;    //Counter3 Value from Timer_Counter3 1
   input [15:0] counter_val_reg_23;    //Counter3 Value from Timer_Counter3 2
   input [15:0] counter_val_reg_33;    //Counter3 Value from Timer_Counter3 3
   input [15:0] interval_reg_13;       //Interval3 reg value from Timer_Counter3 1
   input [15:0] match_1_reg_13;        //Match3 reg value from Timer_Counter3 
   input [15:0] match_2_reg_13;        //Match3 reg value from Timer_Counter3     
   input [15:0] match_3_reg_13;        //Match3 reg value from Timer_Counter3 
   input [15:0] interval_reg_23;       //Interval3 reg value from Timer_Counter3 2
   input [15:0] match_1_reg_23;        //Match3 reg value from Timer_Counter3     
   input [15:0] match_2_reg_23;        //Match3 reg value from Timer_Counter3     
   input [15:0] match_3_reg_23;        //Match3 reg value from Timer_Counter3 
   input [15:0] interval_reg_33;       //Interval3 reg value from Timer_Counter3 3
   input [15:0] match_1_reg_33;        //Match3 reg value from Timer_Counter3   
   input [15:0] match_2_reg_33;        //Match3 reg value from Timer_Counter3   
   input [15:0] match_3_reg_33;        //Match3 reg value from Timer_Counter3   
   input [5:0]  interrupt_reg_13;      //Interrupt3 Reg3 from Interrupt3 Module3 1
   input [5:0]  interrupt_reg_23;      //Interrupt3 Reg3 from Interrupt3 Module3 2
   input [5:0]  interrupt_reg_33;      //Interrupt3 Reg3 from Interrupt3 Module3 3
   input [5:0]  interrupt_en_reg_13;   //Interrupt3 Enable3 Reg3 from Intrpt3 Module3 1
   input [5:0]  interrupt_en_reg_23;   //Interrupt3 Enable3 Reg3 from Intrpt3 Module3 2
   input [5:0]  interrupt_en_reg_33;   //Interrupt3 Enable3 Reg3 from Intrpt3 Module3 3
   
   //outputs3
   output [31:0] prdata3;              //Read Data from the APB3 Interface3
   output clk_ctrl_reg_sel_13;         //Clock3 Control3 Reg3 Select3 TC_13 
   output clk_ctrl_reg_sel_23;         //Clock3 Control3 Reg3 Select3 TC_23 
   output clk_ctrl_reg_sel_33;         //Clock3 Control3 Reg3 Select3 TC_33 
   output cntr_ctrl_reg_sel_13;        //Counter3 Control3 Reg3 Select3 TC_13
   output cntr_ctrl_reg_sel_23;        //Counter3 Control3 Reg3 Select3 TC_23
   output cntr_ctrl_reg_sel_33;        //Counter3 Control3 Reg3 Select3 TC_33
   output interval_reg_sel_13;         //Interval3 Interrupt3 Reg3 Select3 TC_13 
   output interval_reg_sel_23;         //Interval3 Interrupt3 Reg3 Select3 TC_23 
   output interval_reg_sel_33;         //Interval3 Interrupt3 Reg3 Select3 TC_33 
   output match_1_reg_sel_13;          //Match3 Reg3 Select3 TC_13
   output match_1_reg_sel_23;          //Match3 Reg3 Select3 TC_23
   output match_1_reg_sel_33;          //Match3 Reg3 Select3 TC_33
   output match_2_reg_sel_13;          //Match3 Reg3 Select3 TC_13
   output match_2_reg_sel_23;          //Match3 Reg3 Select3 TC_23
   output match_2_reg_sel_33;          //Match3 Reg3 Select3 TC_33
   output match_3_reg_sel_13;          //Match3 Reg3 Select3 TC_13
   output match_3_reg_sel_23;          //Match3 Reg3 Select3 TC_23
   output match_3_reg_sel_33;          //Match3 Reg3 Select3 TC_33
   output [3:1] intr_en_reg_sel3;      //Interrupt3 Enable3 Reg3 Select3
   output [3:1] clear_interrupt3;      //Clear Interrupt3 line


//-----------------------------------------------------------------------------
// PARAMETER3 DECLARATIONS3
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR3   = 8'h00; //Clock3 control3 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR3   = 8'h04; //Clock3 control3 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR3   = 8'h08; //Clock3 control3 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR3  = 8'h0C; //Counter3 control3 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR3  = 8'h10; //Counter3 control3 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR3  = 8'h14; //Counter3 control3 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR3   = 8'h18; //Counter3 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR3   = 8'h1C; //Counter3 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR3   = 8'h20; //Counter3 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR3   = 8'h24; //Module3 1 interval3 address
   parameter   [7:0] INTERVAL_REG_2_ADDR3   = 8'h28; //Module3 2 interval3 address
   parameter   [7:0] INTERVAL_REG_3_ADDR3   = 8'h2C; //Module3 3 interval3 address
   parameter   [7:0] MATCH_1_REG_1_ADDR3    = 8'h30; //Module3 1 Match3 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR3    = 8'h34; //Module3 2 Match3 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR3    = 8'h38; //Module3 3 Match3 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR3    = 8'h3C; //Module3 1 Match3 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR3    = 8'h40; //Module3 2 Match3 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR3    = 8'h44; //Module3 3 Match3 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR3    = 8'h48; //Module3 1 Match3 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR3    = 8'h4C; //Module3 2 Match3 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR3    = 8'h50; //Module3 3 Match3 3 address
   parameter   [7:0] IRQ_REG_1_ADDR3        = 8'h54; //Interrupt3 register 1
   parameter   [7:0] IRQ_REG_2_ADDR3        = 8'h58; //Interrupt3 register 2
   parameter   [7:0] IRQ_REG_3_ADDR3        = 8'h5C; //Interrupt3 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR3     = 8'h60; //Interrupt3 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR3     = 8'h64; //Interrupt3 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR3     = 8'h68; //Interrupt3 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals3 & Registers3
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_13;         //Clock3 Control3 Reg3 Select3 TC_13
   reg clk_ctrl_reg_sel_23;         //Clock3 Control3 Reg3 Select3 TC_23 
   reg clk_ctrl_reg_sel_33;         //Clock3 Control3 Reg3 Select3 TC_33 
   reg cntr_ctrl_reg_sel_13;        //Counter3 Control3 Reg3 Select3 TC_13
   reg cntr_ctrl_reg_sel_23;        //Counter3 Control3 Reg3 Select3 TC_23
   reg cntr_ctrl_reg_sel_33;        //Counter3 Control3 Reg3 Select3 TC_33
   reg interval_reg_sel_13;         //Interval3 Interrupt3 Reg3 Select3 TC_13 
   reg interval_reg_sel_23;         //Interval3 Interrupt3 Reg3 Select3 TC_23
   reg interval_reg_sel_33;         //Interval3 Interrupt3 Reg3 Select3 TC_33
   reg match_1_reg_sel_13;          //Match3 Reg3 Select3 TC_13
   reg match_1_reg_sel_23;          //Match3 Reg3 Select3 TC_23
   reg match_1_reg_sel_33;          //Match3 Reg3 Select3 TC_33
   reg match_2_reg_sel_13;          //Match3 Reg3 Select3 TC_13
   reg match_2_reg_sel_23;          //Match3 Reg3 Select3 TC_23
   reg match_2_reg_sel_33;          //Match3 Reg3 Select3 TC_33
   reg match_3_reg_sel_13;          //Match3 Reg3 Select3 TC_13
   reg match_3_reg_sel_23;          //Match3 Reg3 Select3 TC_23
   reg match_3_reg_sel_33;          //Match3 Reg3 Select3 TC_33
   reg [3:1] intr_en_reg_sel3;      //Interrupt3 Enable3 1 Reg3 Select3
   reg [31:0] prdata3;              //APB3 read data
   
   wire [3:1] clear_interrupt3;     // 3-bit clear interrupt3 reg on read
   wire write;                     //APB3 write command  
   wire read;                      //APB3 read command    



   assign write = psel3 & penable3 & pwrite3;  
   assign read  = psel3 & ~pwrite3;  
   assign clear_interrupt3[1] = read & penable3 & (paddr3 == IRQ_REG_1_ADDR3);
   assign clear_interrupt3[2] = read & penable3 & (paddr3 == IRQ_REG_2_ADDR3);
   assign clear_interrupt3[3] = read & penable3 & (paddr3 == IRQ_REG_3_ADDR3);   
   
   //p_write_sel3: Process3 to select3 the required3 regs for write access.

   always @ (paddr3 or write)
   begin: p_write_sel3

       clk_ctrl_reg_sel_13  = (write && (paddr3 == CLK_CTRL_REG_1_ADDR3));
       clk_ctrl_reg_sel_23  = (write && (paddr3 == CLK_CTRL_REG_2_ADDR3));
       clk_ctrl_reg_sel_33  = (write && (paddr3 == CLK_CTRL_REG_3_ADDR3));
       cntr_ctrl_reg_sel_13 = (write && (paddr3 == CNTR_CTRL_REG_1_ADDR3));
       cntr_ctrl_reg_sel_23 = (write && (paddr3 == CNTR_CTRL_REG_2_ADDR3));
       cntr_ctrl_reg_sel_33 = (write && (paddr3 == CNTR_CTRL_REG_3_ADDR3));
       interval_reg_sel_13  = (write && (paddr3 == INTERVAL_REG_1_ADDR3));
       interval_reg_sel_23  = (write && (paddr3 == INTERVAL_REG_2_ADDR3));
       interval_reg_sel_33  = (write && (paddr3 == INTERVAL_REG_3_ADDR3));
       match_1_reg_sel_13   = (write && (paddr3 == MATCH_1_REG_1_ADDR3));
       match_1_reg_sel_23   = (write && (paddr3 == MATCH_1_REG_2_ADDR3));
       match_1_reg_sel_33   = (write && (paddr3 == MATCH_1_REG_3_ADDR3));
       match_2_reg_sel_13   = (write && (paddr3 == MATCH_2_REG_1_ADDR3));
       match_2_reg_sel_23   = (write && (paddr3 == MATCH_2_REG_2_ADDR3));
       match_2_reg_sel_33   = (write && (paddr3 == MATCH_2_REG_3_ADDR3));
       match_3_reg_sel_13   = (write && (paddr3 == MATCH_3_REG_1_ADDR3));
       match_3_reg_sel_23   = (write && (paddr3 == MATCH_3_REG_2_ADDR3));
       match_3_reg_sel_33   = (write && (paddr3 == MATCH_3_REG_3_ADDR3));
       intr_en_reg_sel3[1]  = (write && (paddr3 == IRQ_EN_REG_1_ADDR3));
       intr_en_reg_sel3[2]  = (write && (paddr3 == IRQ_EN_REG_2_ADDR3));
       intr_en_reg_sel3[3]  = (write && (paddr3 == IRQ_EN_REG_3_ADDR3));      
   end  //p_write_sel3
    

//    p_read_sel3: Process3 to enable the read operation3 to occur3.

   always @ (posedge pclk3 or negedge n_p_reset3)
   begin: p_read_sel3

      if (!n_p_reset3)                                   
      begin                                     
         prdata3 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr3)

               CLK_CTRL_REG_1_ADDR3 : prdata3 <= {25'h0000000,clk_ctrl_reg_13};
               CLK_CTRL_REG_2_ADDR3 : prdata3 <= {25'h0000000,clk_ctrl_reg_23};
               CLK_CTRL_REG_3_ADDR3 : prdata3 <= {25'h0000000,clk_ctrl_reg_33};
               CNTR_CTRL_REG_1_ADDR3: prdata3 <= {25'h0000000,cntr_ctrl_reg_13};
               CNTR_CTRL_REG_2_ADDR3: prdata3 <= {25'h0000000,cntr_ctrl_reg_23};
               CNTR_CTRL_REG_3_ADDR3: prdata3 <= {25'h0000000,cntr_ctrl_reg_33};
               CNTR_VAL_REG_1_ADDR3 : prdata3 <= {16'h0000,counter_val_reg_13};
               CNTR_VAL_REG_2_ADDR3 : prdata3 <= {16'h0000,counter_val_reg_23};
               CNTR_VAL_REG_3_ADDR3 : prdata3 <= {16'h0000,counter_val_reg_33};
               INTERVAL_REG_1_ADDR3 : prdata3 <= {16'h0000,interval_reg_13};
               INTERVAL_REG_2_ADDR3 : prdata3 <= {16'h0000,interval_reg_23};
               INTERVAL_REG_3_ADDR3 : prdata3 <= {16'h0000,interval_reg_33};
               MATCH_1_REG_1_ADDR3  : prdata3 <= {16'h0000,match_1_reg_13};
               MATCH_1_REG_2_ADDR3  : prdata3 <= {16'h0000,match_1_reg_23};
               MATCH_1_REG_3_ADDR3  : prdata3 <= {16'h0000,match_1_reg_33};
               MATCH_2_REG_1_ADDR3  : prdata3 <= {16'h0000,match_2_reg_13};
               MATCH_2_REG_2_ADDR3  : prdata3 <= {16'h0000,match_2_reg_23};
               MATCH_2_REG_3_ADDR3  : prdata3 <= {16'h0000,match_2_reg_33};
               MATCH_3_REG_1_ADDR3  : prdata3 <= {16'h0000,match_3_reg_13};
               MATCH_3_REG_2_ADDR3  : prdata3 <= {16'h0000,match_3_reg_23};
               MATCH_3_REG_3_ADDR3  : prdata3 <= {16'h0000,match_3_reg_33};
               IRQ_REG_1_ADDR3      : prdata3 <= {26'h0000,interrupt_reg_13};
               IRQ_REG_2_ADDR3      : prdata3 <= {26'h0000,interrupt_reg_23};
               IRQ_REG_3_ADDR3      : prdata3 <= {26'h0000,interrupt_reg_33};
               IRQ_EN_REG_1_ADDR3   : prdata3 <= {26'h0000,interrupt_en_reg_13};
               IRQ_EN_REG_2_ADDR3   : prdata3 <= {26'h0000,interrupt_en_reg_23};
               IRQ_EN_REG_3_ADDR3   : prdata3 <= {26'h0000,interrupt_en_reg_33};
               default             : prdata3 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata3 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset3)
      
   end // block: p_read_sel3

endmodule

