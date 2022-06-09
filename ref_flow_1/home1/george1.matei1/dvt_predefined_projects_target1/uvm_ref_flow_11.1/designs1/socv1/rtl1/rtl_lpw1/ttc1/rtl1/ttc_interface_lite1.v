//File1 name   : ttc_interface_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : The APB1 interface with the triple1 timer1 counter
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module1 definition1
//----------------------------------------------------------------------------

module ttc_interface_lite1( 

  //inputs1
  n_p_reset1,    
  pclk1,                          
  psel1,
  penable1,
  pwrite1,
  paddr1,
  clk_ctrl_reg_11,
  clk_ctrl_reg_21,
  clk_ctrl_reg_31,
  cntr_ctrl_reg_11,
  cntr_ctrl_reg_21,
  cntr_ctrl_reg_31,
  counter_val_reg_11,
  counter_val_reg_21,
  counter_val_reg_31,
  interval_reg_11,
  match_1_reg_11,
  match_2_reg_11,
  match_3_reg_11,
  interval_reg_21,
  match_1_reg_21,
  match_2_reg_21,
  match_3_reg_21,
  interval_reg_31,
  match_1_reg_31,
  match_2_reg_31,
  match_3_reg_31,
  interrupt_reg_11,
  interrupt_reg_21,
  interrupt_reg_31,      
  interrupt_en_reg_11,
  interrupt_en_reg_21,
  interrupt_en_reg_31,
                  
  //outputs1
  prdata1,
  clk_ctrl_reg_sel_11,
  clk_ctrl_reg_sel_21,
  clk_ctrl_reg_sel_31,
  cntr_ctrl_reg_sel_11,
  cntr_ctrl_reg_sel_21,
  cntr_ctrl_reg_sel_31,
  interval_reg_sel_11,                            
  interval_reg_sel_21,                          
  interval_reg_sel_31,
  match_1_reg_sel_11,                          
  match_1_reg_sel_21,                          
  match_1_reg_sel_31,                
  match_2_reg_sel_11,                          
  match_2_reg_sel_21,
  match_2_reg_sel_31,
  match_3_reg_sel_11,                          
  match_3_reg_sel_21,                         
  match_3_reg_sel_31,
  intr_en_reg_sel1,
  clear_interrupt1        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS1
//----------------------------------------------------------------------------

   //inputs1
   input        n_p_reset1;              //reset signal1
   input        pclk1;                 //System1 Clock1
   input        psel1;                 //Select1 line
   input        penable1;              //Strobe1 line
   input        pwrite1;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr1;                //Address Bus1 register
   input [6:0]  clk_ctrl_reg_11;       //Clock1 Control1 reg for Timer_Counter1 1
   input [6:0]  cntr_ctrl_reg_11;      //Counter1 Control1 reg for Timer_Counter1 1
   input [6:0]  clk_ctrl_reg_21;       //Clock1 Control1 reg for Timer_Counter1 2
   input [6:0]  cntr_ctrl_reg_21;      //Counter1 Control1 reg for Timer1 Counter1 2
   input [6:0]  clk_ctrl_reg_31;       //Clock1 Control1 reg Timer_Counter1 3
   input [6:0]  cntr_ctrl_reg_31;      //Counter1 Control1 reg for Timer1 Counter1 3
   input [15:0] counter_val_reg_11;    //Counter1 Value from Timer_Counter1 1
   input [15:0] counter_val_reg_21;    //Counter1 Value from Timer_Counter1 2
   input [15:0] counter_val_reg_31;    //Counter1 Value from Timer_Counter1 3
   input [15:0] interval_reg_11;       //Interval1 reg value from Timer_Counter1 1
   input [15:0] match_1_reg_11;        //Match1 reg value from Timer_Counter1 
   input [15:0] match_2_reg_11;        //Match1 reg value from Timer_Counter1     
   input [15:0] match_3_reg_11;        //Match1 reg value from Timer_Counter1 
   input [15:0] interval_reg_21;       //Interval1 reg value from Timer_Counter1 2
   input [15:0] match_1_reg_21;        //Match1 reg value from Timer_Counter1     
   input [15:0] match_2_reg_21;        //Match1 reg value from Timer_Counter1     
   input [15:0] match_3_reg_21;        //Match1 reg value from Timer_Counter1 
   input [15:0] interval_reg_31;       //Interval1 reg value from Timer_Counter1 3
   input [15:0] match_1_reg_31;        //Match1 reg value from Timer_Counter1   
   input [15:0] match_2_reg_31;        //Match1 reg value from Timer_Counter1   
   input [15:0] match_3_reg_31;        //Match1 reg value from Timer_Counter1   
   input [5:0]  interrupt_reg_11;      //Interrupt1 Reg1 from Interrupt1 Module1 1
   input [5:0]  interrupt_reg_21;      //Interrupt1 Reg1 from Interrupt1 Module1 2
   input [5:0]  interrupt_reg_31;      //Interrupt1 Reg1 from Interrupt1 Module1 3
   input [5:0]  interrupt_en_reg_11;   //Interrupt1 Enable1 Reg1 from Intrpt1 Module1 1
   input [5:0]  interrupt_en_reg_21;   //Interrupt1 Enable1 Reg1 from Intrpt1 Module1 2
   input [5:0]  interrupt_en_reg_31;   //Interrupt1 Enable1 Reg1 from Intrpt1 Module1 3
   
   //outputs1
   output [31:0] prdata1;              //Read Data from the APB1 Interface1
   output clk_ctrl_reg_sel_11;         //Clock1 Control1 Reg1 Select1 TC_11 
   output clk_ctrl_reg_sel_21;         //Clock1 Control1 Reg1 Select1 TC_21 
   output clk_ctrl_reg_sel_31;         //Clock1 Control1 Reg1 Select1 TC_31 
   output cntr_ctrl_reg_sel_11;        //Counter1 Control1 Reg1 Select1 TC_11
   output cntr_ctrl_reg_sel_21;        //Counter1 Control1 Reg1 Select1 TC_21
   output cntr_ctrl_reg_sel_31;        //Counter1 Control1 Reg1 Select1 TC_31
   output interval_reg_sel_11;         //Interval1 Interrupt1 Reg1 Select1 TC_11 
   output interval_reg_sel_21;         //Interval1 Interrupt1 Reg1 Select1 TC_21 
   output interval_reg_sel_31;         //Interval1 Interrupt1 Reg1 Select1 TC_31 
   output match_1_reg_sel_11;          //Match1 Reg1 Select1 TC_11
   output match_1_reg_sel_21;          //Match1 Reg1 Select1 TC_21
   output match_1_reg_sel_31;          //Match1 Reg1 Select1 TC_31
   output match_2_reg_sel_11;          //Match1 Reg1 Select1 TC_11
   output match_2_reg_sel_21;          //Match1 Reg1 Select1 TC_21
   output match_2_reg_sel_31;          //Match1 Reg1 Select1 TC_31
   output match_3_reg_sel_11;          //Match1 Reg1 Select1 TC_11
   output match_3_reg_sel_21;          //Match1 Reg1 Select1 TC_21
   output match_3_reg_sel_31;          //Match1 Reg1 Select1 TC_31
   output [3:1] intr_en_reg_sel1;      //Interrupt1 Enable1 Reg1 Select1
   output [3:1] clear_interrupt1;      //Clear Interrupt1 line


//-----------------------------------------------------------------------------
// PARAMETER1 DECLARATIONS1
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR1   = 8'h00; //Clock1 control1 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR1   = 8'h04; //Clock1 control1 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR1   = 8'h08; //Clock1 control1 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR1  = 8'h0C; //Counter1 control1 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR1  = 8'h10; //Counter1 control1 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR1  = 8'h14; //Counter1 control1 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR1   = 8'h18; //Counter1 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR1   = 8'h1C; //Counter1 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR1   = 8'h20; //Counter1 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR1   = 8'h24; //Module1 1 interval1 address
   parameter   [7:0] INTERVAL_REG_2_ADDR1   = 8'h28; //Module1 2 interval1 address
   parameter   [7:0] INTERVAL_REG_3_ADDR1   = 8'h2C; //Module1 3 interval1 address
   parameter   [7:0] MATCH_1_REG_1_ADDR1    = 8'h30; //Module1 1 Match1 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR1    = 8'h34; //Module1 2 Match1 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR1    = 8'h38; //Module1 3 Match1 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR1    = 8'h3C; //Module1 1 Match1 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR1    = 8'h40; //Module1 2 Match1 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR1    = 8'h44; //Module1 3 Match1 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR1    = 8'h48; //Module1 1 Match1 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR1    = 8'h4C; //Module1 2 Match1 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR1    = 8'h50; //Module1 3 Match1 3 address
   parameter   [7:0] IRQ_REG_1_ADDR1        = 8'h54; //Interrupt1 register 1
   parameter   [7:0] IRQ_REG_2_ADDR1        = 8'h58; //Interrupt1 register 2
   parameter   [7:0] IRQ_REG_3_ADDR1        = 8'h5C; //Interrupt1 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR1     = 8'h60; //Interrupt1 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR1     = 8'h64; //Interrupt1 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR1     = 8'h68; //Interrupt1 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals1 & Registers1
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_11;         //Clock1 Control1 Reg1 Select1 TC_11
   reg clk_ctrl_reg_sel_21;         //Clock1 Control1 Reg1 Select1 TC_21 
   reg clk_ctrl_reg_sel_31;         //Clock1 Control1 Reg1 Select1 TC_31 
   reg cntr_ctrl_reg_sel_11;        //Counter1 Control1 Reg1 Select1 TC_11
   reg cntr_ctrl_reg_sel_21;        //Counter1 Control1 Reg1 Select1 TC_21
   reg cntr_ctrl_reg_sel_31;        //Counter1 Control1 Reg1 Select1 TC_31
   reg interval_reg_sel_11;         //Interval1 Interrupt1 Reg1 Select1 TC_11 
   reg interval_reg_sel_21;         //Interval1 Interrupt1 Reg1 Select1 TC_21
   reg interval_reg_sel_31;         //Interval1 Interrupt1 Reg1 Select1 TC_31
   reg match_1_reg_sel_11;          //Match1 Reg1 Select1 TC_11
   reg match_1_reg_sel_21;          //Match1 Reg1 Select1 TC_21
   reg match_1_reg_sel_31;          //Match1 Reg1 Select1 TC_31
   reg match_2_reg_sel_11;          //Match1 Reg1 Select1 TC_11
   reg match_2_reg_sel_21;          //Match1 Reg1 Select1 TC_21
   reg match_2_reg_sel_31;          //Match1 Reg1 Select1 TC_31
   reg match_3_reg_sel_11;          //Match1 Reg1 Select1 TC_11
   reg match_3_reg_sel_21;          //Match1 Reg1 Select1 TC_21
   reg match_3_reg_sel_31;          //Match1 Reg1 Select1 TC_31
   reg [3:1] intr_en_reg_sel1;      //Interrupt1 Enable1 1 Reg1 Select1
   reg [31:0] prdata1;              //APB1 read data
   
   wire [3:1] clear_interrupt1;     // 3-bit clear interrupt1 reg on read
   wire write;                     //APB1 write command  
   wire read;                      //APB1 read command    



   assign write = psel1 & penable1 & pwrite1;  
   assign read  = psel1 & ~pwrite1;  
   assign clear_interrupt1[1] = read & penable1 & (paddr1 == IRQ_REG_1_ADDR1);
   assign clear_interrupt1[2] = read & penable1 & (paddr1 == IRQ_REG_2_ADDR1);
   assign clear_interrupt1[3] = read & penable1 & (paddr1 == IRQ_REG_3_ADDR1);   
   
   //p_write_sel1: Process1 to select1 the required1 regs for write access.

   always @ (paddr1 or write)
   begin: p_write_sel1

       clk_ctrl_reg_sel_11  = (write && (paddr1 == CLK_CTRL_REG_1_ADDR1));
       clk_ctrl_reg_sel_21  = (write && (paddr1 == CLK_CTRL_REG_2_ADDR1));
       clk_ctrl_reg_sel_31  = (write && (paddr1 == CLK_CTRL_REG_3_ADDR1));
       cntr_ctrl_reg_sel_11 = (write && (paddr1 == CNTR_CTRL_REG_1_ADDR1));
       cntr_ctrl_reg_sel_21 = (write && (paddr1 == CNTR_CTRL_REG_2_ADDR1));
       cntr_ctrl_reg_sel_31 = (write && (paddr1 == CNTR_CTRL_REG_3_ADDR1));
       interval_reg_sel_11  = (write && (paddr1 == INTERVAL_REG_1_ADDR1));
       interval_reg_sel_21  = (write && (paddr1 == INTERVAL_REG_2_ADDR1));
       interval_reg_sel_31  = (write && (paddr1 == INTERVAL_REG_3_ADDR1));
       match_1_reg_sel_11   = (write && (paddr1 == MATCH_1_REG_1_ADDR1));
       match_1_reg_sel_21   = (write && (paddr1 == MATCH_1_REG_2_ADDR1));
       match_1_reg_sel_31   = (write && (paddr1 == MATCH_1_REG_3_ADDR1));
       match_2_reg_sel_11   = (write && (paddr1 == MATCH_2_REG_1_ADDR1));
       match_2_reg_sel_21   = (write && (paddr1 == MATCH_2_REG_2_ADDR1));
       match_2_reg_sel_31   = (write && (paddr1 == MATCH_2_REG_3_ADDR1));
       match_3_reg_sel_11   = (write && (paddr1 == MATCH_3_REG_1_ADDR1));
       match_3_reg_sel_21   = (write && (paddr1 == MATCH_3_REG_2_ADDR1));
       match_3_reg_sel_31   = (write && (paddr1 == MATCH_3_REG_3_ADDR1));
       intr_en_reg_sel1[1]  = (write && (paddr1 == IRQ_EN_REG_1_ADDR1));
       intr_en_reg_sel1[2]  = (write && (paddr1 == IRQ_EN_REG_2_ADDR1));
       intr_en_reg_sel1[3]  = (write && (paddr1 == IRQ_EN_REG_3_ADDR1));      
   end  //p_write_sel1
    

//    p_read_sel1: Process1 to enable the read operation1 to occur1.

   always @ (posedge pclk1 or negedge n_p_reset1)
   begin: p_read_sel1

      if (!n_p_reset1)                                   
      begin                                     
         prdata1 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr1)

               CLK_CTRL_REG_1_ADDR1 : prdata1 <= {25'h0000000,clk_ctrl_reg_11};
               CLK_CTRL_REG_2_ADDR1 : prdata1 <= {25'h0000000,clk_ctrl_reg_21};
               CLK_CTRL_REG_3_ADDR1 : prdata1 <= {25'h0000000,clk_ctrl_reg_31};
               CNTR_CTRL_REG_1_ADDR1: prdata1 <= {25'h0000000,cntr_ctrl_reg_11};
               CNTR_CTRL_REG_2_ADDR1: prdata1 <= {25'h0000000,cntr_ctrl_reg_21};
               CNTR_CTRL_REG_3_ADDR1: prdata1 <= {25'h0000000,cntr_ctrl_reg_31};
               CNTR_VAL_REG_1_ADDR1 : prdata1 <= {16'h0000,counter_val_reg_11};
               CNTR_VAL_REG_2_ADDR1 : prdata1 <= {16'h0000,counter_val_reg_21};
               CNTR_VAL_REG_3_ADDR1 : prdata1 <= {16'h0000,counter_val_reg_31};
               INTERVAL_REG_1_ADDR1 : prdata1 <= {16'h0000,interval_reg_11};
               INTERVAL_REG_2_ADDR1 : prdata1 <= {16'h0000,interval_reg_21};
               INTERVAL_REG_3_ADDR1 : prdata1 <= {16'h0000,interval_reg_31};
               MATCH_1_REG_1_ADDR1  : prdata1 <= {16'h0000,match_1_reg_11};
               MATCH_1_REG_2_ADDR1  : prdata1 <= {16'h0000,match_1_reg_21};
               MATCH_1_REG_3_ADDR1  : prdata1 <= {16'h0000,match_1_reg_31};
               MATCH_2_REG_1_ADDR1  : prdata1 <= {16'h0000,match_2_reg_11};
               MATCH_2_REG_2_ADDR1  : prdata1 <= {16'h0000,match_2_reg_21};
               MATCH_2_REG_3_ADDR1  : prdata1 <= {16'h0000,match_2_reg_31};
               MATCH_3_REG_1_ADDR1  : prdata1 <= {16'h0000,match_3_reg_11};
               MATCH_3_REG_2_ADDR1  : prdata1 <= {16'h0000,match_3_reg_21};
               MATCH_3_REG_3_ADDR1  : prdata1 <= {16'h0000,match_3_reg_31};
               IRQ_REG_1_ADDR1      : prdata1 <= {26'h0000,interrupt_reg_11};
               IRQ_REG_2_ADDR1      : prdata1 <= {26'h0000,interrupt_reg_21};
               IRQ_REG_3_ADDR1      : prdata1 <= {26'h0000,interrupt_reg_31};
               IRQ_EN_REG_1_ADDR1   : prdata1 <= {26'h0000,interrupt_en_reg_11};
               IRQ_EN_REG_2_ADDR1   : prdata1 <= {26'h0000,interrupt_en_reg_21};
               IRQ_EN_REG_3_ADDR1   : prdata1 <= {26'h0000,interrupt_en_reg_31};
               default             : prdata1 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata1 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset1)
      
   end // block: p_read_sel1

endmodule

