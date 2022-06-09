//File2 name   : ttc_interface_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : The APB2 interface with the triple2 timer2 counter
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module2 definition2
//----------------------------------------------------------------------------

module ttc_interface_lite2( 

  //inputs2
  n_p_reset2,    
  pclk2,                          
  psel2,
  penable2,
  pwrite2,
  paddr2,
  clk_ctrl_reg_12,
  clk_ctrl_reg_22,
  clk_ctrl_reg_32,
  cntr_ctrl_reg_12,
  cntr_ctrl_reg_22,
  cntr_ctrl_reg_32,
  counter_val_reg_12,
  counter_val_reg_22,
  counter_val_reg_32,
  interval_reg_12,
  match_1_reg_12,
  match_2_reg_12,
  match_3_reg_12,
  interval_reg_22,
  match_1_reg_22,
  match_2_reg_22,
  match_3_reg_22,
  interval_reg_32,
  match_1_reg_32,
  match_2_reg_32,
  match_3_reg_32,
  interrupt_reg_12,
  interrupt_reg_22,
  interrupt_reg_32,      
  interrupt_en_reg_12,
  interrupt_en_reg_22,
  interrupt_en_reg_32,
                  
  //outputs2
  prdata2,
  clk_ctrl_reg_sel_12,
  clk_ctrl_reg_sel_22,
  clk_ctrl_reg_sel_32,
  cntr_ctrl_reg_sel_12,
  cntr_ctrl_reg_sel_22,
  cntr_ctrl_reg_sel_32,
  interval_reg_sel_12,                            
  interval_reg_sel_22,                          
  interval_reg_sel_32,
  match_1_reg_sel_12,                          
  match_1_reg_sel_22,                          
  match_1_reg_sel_32,                
  match_2_reg_sel_12,                          
  match_2_reg_sel_22,
  match_2_reg_sel_32,
  match_3_reg_sel_12,                          
  match_3_reg_sel_22,                         
  match_3_reg_sel_32,
  intr_en_reg_sel2,
  clear_interrupt2        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS2
//----------------------------------------------------------------------------

   //inputs2
   input        n_p_reset2;              //reset signal2
   input        pclk2;                 //System2 Clock2
   input        psel2;                 //Select2 line
   input        penable2;              //Strobe2 line
   input        pwrite2;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr2;                //Address Bus2 register
   input [6:0]  clk_ctrl_reg_12;       //Clock2 Control2 reg for Timer_Counter2 1
   input [6:0]  cntr_ctrl_reg_12;      //Counter2 Control2 reg for Timer_Counter2 1
   input [6:0]  clk_ctrl_reg_22;       //Clock2 Control2 reg for Timer_Counter2 2
   input [6:0]  cntr_ctrl_reg_22;      //Counter2 Control2 reg for Timer2 Counter2 2
   input [6:0]  clk_ctrl_reg_32;       //Clock2 Control2 reg Timer_Counter2 3
   input [6:0]  cntr_ctrl_reg_32;      //Counter2 Control2 reg for Timer2 Counter2 3
   input [15:0] counter_val_reg_12;    //Counter2 Value from Timer_Counter2 1
   input [15:0] counter_val_reg_22;    //Counter2 Value from Timer_Counter2 2
   input [15:0] counter_val_reg_32;    //Counter2 Value from Timer_Counter2 3
   input [15:0] interval_reg_12;       //Interval2 reg value from Timer_Counter2 1
   input [15:0] match_1_reg_12;        //Match2 reg value from Timer_Counter2 
   input [15:0] match_2_reg_12;        //Match2 reg value from Timer_Counter2     
   input [15:0] match_3_reg_12;        //Match2 reg value from Timer_Counter2 
   input [15:0] interval_reg_22;       //Interval2 reg value from Timer_Counter2 2
   input [15:0] match_1_reg_22;        //Match2 reg value from Timer_Counter2     
   input [15:0] match_2_reg_22;        //Match2 reg value from Timer_Counter2     
   input [15:0] match_3_reg_22;        //Match2 reg value from Timer_Counter2 
   input [15:0] interval_reg_32;       //Interval2 reg value from Timer_Counter2 3
   input [15:0] match_1_reg_32;        //Match2 reg value from Timer_Counter2   
   input [15:0] match_2_reg_32;        //Match2 reg value from Timer_Counter2   
   input [15:0] match_3_reg_32;        //Match2 reg value from Timer_Counter2   
   input [5:0]  interrupt_reg_12;      //Interrupt2 Reg2 from Interrupt2 Module2 1
   input [5:0]  interrupt_reg_22;      //Interrupt2 Reg2 from Interrupt2 Module2 2
   input [5:0]  interrupt_reg_32;      //Interrupt2 Reg2 from Interrupt2 Module2 3
   input [5:0]  interrupt_en_reg_12;   //Interrupt2 Enable2 Reg2 from Intrpt2 Module2 1
   input [5:0]  interrupt_en_reg_22;   //Interrupt2 Enable2 Reg2 from Intrpt2 Module2 2
   input [5:0]  interrupt_en_reg_32;   //Interrupt2 Enable2 Reg2 from Intrpt2 Module2 3
   
   //outputs2
   output [31:0] prdata2;              //Read Data from the APB2 Interface2
   output clk_ctrl_reg_sel_12;         //Clock2 Control2 Reg2 Select2 TC_12 
   output clk_ctrl_reg_sel_22;         //Clock2 Control2 Reg2 Select2 TC_22 
   output clk_ctrl_reg_sel_32;         //Clock2 Control2 Reg2 Select2 TC_32 
   output cntr_ctrl_reg_sel_12;        //Counter2 Control2 Reg2 Select2 TC_12
   output cntr_ctrl_reg_sel_22;        //Counter2 Control2 Reg2 Select2 TC_22
   output cntr_ctrl_reg_sel_32;        //Counter2 Control2 Reg2 Select2 TC_32
   output interval_reg_sel_12;         //Interval2 Interrupt2 Reg2 Select2 TC_12 
   output interval_reg_sel_22;         //Interval2 Interrupt2 Reg2 Select2 TC_22 
   output interval_reg_sel_32;         //Interval2 Interrupt2 Reg2 Select2 TC_32 
   output match_1_reg_sel_12;          //Match2 Reg2 Select2 TC_12
   output match_1_reg_sel_22;          //Match2 Reg2 Select2 TC_22
   output match_1_reg_sel_32;          //Match2 Reg2 Select2 TC_32
   output match_2_reg_sel_12;          //Match2 Reg2 Select2 TC_12
   output match_2_reg_sel_22;          //Match2 Reg2 Select2 TC_22
   output match_2_reg_sel_32;          //Match2 Reg2 Select2 TC_32
   output match_3_reg_sel_12;          //Match2 Reg2 Select2 TC_12
   output match_3_reg_sel_22;          //Match2 Reg2 Select2 TC_22
   output match_3_reg_sel_32;          //Match2 Reg2 Select2 TC_32
   output [3:1] intr_en_reg_sel2;      //Interrupt2 Enable2 Reg2 Select2
   output [3:1] clear_interrupt2;      //Clear Interrupt2 line


//-----------------------------------------------------------------------------
// PARAMETER2 DECLARATIONS2
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR2   = 8'h00; //Clock2 control2 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR2   = 8'h04; //Clock2 control2 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR2   = 8'h08; //Clock2 control2 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR2  = 8'h0C; //Counter2 control2 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR2  = 8'h10; //Counter2 control2 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR2  = 8'h14; //Counter2 control2 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR2   = 8'h18; //Counter2 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR2   = 8'h1C; //Counter2 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR2   = 8'h20; //Counter2 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR2   = 8'h24; //Module2 1 interval2 address
   parameter   [7:0] INTERVAL_REG_2_ADDR2   = 8'h28; //Module2 2 interval2 address
   parameter   [7:0] INTERVAL_REG_3_ADDR2   = 8'h2C; //Module2 3 interval2 address
   parameter   [7:0] MATCH_1_REG_1_ADDR2    = 8'h30; //Module2 1 Match2 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR2    = 8'h34; //Module2 2 Match2 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR2    = 8'h38; //Module2 3 Match2 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR2    = 8'h3C; //Module2 1 Match2 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR2    = 8'h40; //Module2 2 Match2 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR2    = 8'h44; //Module2 3 Match2 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR2    = 8'h48; //Module2 1 Match2 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR2    = 8'h4C; //Module2 2 Match2 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR2    = 8'h50; //Module2 3 Match2 3 address
   parameter   [7:0] IRQ_REG_1_ADDR2        = 8'h54; //Interrupt2 register 1
   parameter   [7:0] IRQ_REG_2_ADDR2        = 8'h58; //Interrupt2 register 2
   parameter   [7:0] IRQ_REG_3_ADDR2        = 8'h5C; //Interrupt2 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR2     = 8'h60; //Interrupt2 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR2     = 8'h64; //Interrupt2 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR2     = 8'h68; //Interrupt2 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals2 & Registers2
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_12;         //Clock2 Control2 Reg2 Select2 TC_12
   reg clk_ctrl_reg_sel_22;         //Clock2 Control2 Reg2 Select2 TC_22 
   reg clk_ctrl_reg_sel_32;         //Clock2 Control2 Reg2 Select2 TC_32 
   reg cntr_ctrl_reg_sel_12;        //Counter2 Control2 Reg2 Select2 TC_12
   reg cntr_ctrl_reg_sel_22;        //Counter2 Control2 Reg2 Select2 TC_22
   reg cntr_ctrl_reg_sel_32;        //Counter2 Control2 Reg2 Select2 TC_32
   reg interval_reg_sel_12;         //Interval2 Interrupt2 Reg2 Select2 TC_12 
   reg interval_reg_sel_22;         //Interval2 Interrupt2 Reg2 Select2 TC_22
   reg interval_reg_sel_32;         //Interval2 Interrupt2 Reg2 Select2 TC_32
   reg match_1_reg_sel_12;          //Match2 Reg2 Select2 TC_12
   reg match_1_reg_sel_22;          //Match2 Reg2 Select2 TC_22
   reg match_1_reg_sel_32;          //Match2 Reg2 Select2 TC_32
   reg match_2_reg_sel_12;          //Match2 Reg2 Select2 TC_12
   reg match_2_reg_sel_22;          //Match2 Reg2 Select2 TC_22
   reg match_2_reg_sel_32;          //Match2 Reg2 Select2 TC_32
   reg match_3_reg_sel_12;          //Match2 Reg2 Select2 TC_12
   reg match_3_reg_sel_22;          //Match2 Reg2 Select2 TC_22
   reg match_3_reg_sel_32;          //Match2 Reg2 Select2 TC_32
   reg [3:1] intr_en_reg_sel2;      //Interrupt2 Enable2 1 Reg2 Select2
   reg [31:0] prdata2;              //APB2 read data
   
   wire [3:1] clear_interrupt2;     // 3-bit clear interrupt2 reg on read
   wire write;                     //APB2 write command  
   wire read;                      //APB2 read command    



   assign write = psel2 & penable2 & pwrite2;  
   assign read  = psel2 & ~pwrite2;  
   assign clear_interrupt2[1] = read & penable2 & (paddr2 == IRQ_REG_1_ADDR2);
   assign clear_interrupt2[2] = read & penable2 & (paddr2 == IRQ_REG_2_ADDR2);
   assign clear_interrupt2[3] = read & penable2 & (paddr2 == IRQ_REG_3_ADDR2);   
   
   //p_write_sel2: Process2 to select2 the required2 regs for write access.

   always @ (paddr2 or write)
   begin: p_write_sel2

       clk_ctrl_reg_sel_12  = (write && (paddr2 == CLK_CTRL_REG_1_ADDR2));
       clk_ctrl_reg_sel_22  = (write && (paddr2 == CLK_CTRL_REG_2_ADDR2));
       clk_ctrl_reg_sel_32  = (write && (paddr2 == CLK_CTRL_REG_3_ADDR2));
       cntr_ctrl_reg_sel_12 = (write && (paddr2 == CNTR_CTRL_REG_1_ADDR2));
       cntr_ctrl_reg_sel_22 = (write && (paddr2 == CNTR_CTRL_REG_2_ADDR2));
       cntr_ctrl_reg_sel_32 = (write && (paddr2 == CNTR_CTRL_REG_3_ADDR2));
       interval_reg_sel_12  = (write && (paddr2 == INTERVAL_REG_1_ADDR2));
       interval_reg_sel_22  = (write && (paddr2 == INTERVAL_REG_2_ADDR2));
       interval_reg_sel_32  = (write && (paddr2 == INTERVAL_REG_3_ADDR2));
       match_1_reg_sel_12   = (write && (paddr2 == MATCH_1_REG_1_ADDR2));
       match_1_reg_sel_22   = (write && (paddr2 == MATCH_1_REG_2_ADDR2));
       match_1_reg_sel_32   = (write && (paddr2 == MATCH_1_REG_3_ADDR2));
       match_2_reg_sel_12   = (write && (paddr2 == MATCH_2_REG_1_ADDR2));
       match_2_reg_sel_22   = (write && (paddr2 == MATCH_2_REG_2_ADDR2));
       match_2_reg_sel_32   = (write && (paddr2 == MATCH_2_REG_3_ADDR2));
       match_3_reg_sel_12   = (write && (paddr2 == MATCH_3_REG_1_ADDR2));
       match_3_reg_sel_22   = (write && (paddr2 == MATCH_3_REG_2_ADDR2));
       match_3_reg_sel_32   = (write && (paddr2 == MATCH_3_REG_3_ADDR2));
       intr_en_reg_sel2[1]  = (write && (paddr2 == IRQ_EN_REG_1_ADDR2));
       intr_en_reg_sel2[2]  = (write && (paddr2 == IRQ_EN_REG_2_ADDR2));
       intr_en_reg_sel2[3]  = (write && (paddr2 == IRQ_EN_REG_3_ADDR2));      
   end  //p_write_sel2
    

//    p_read_sel2: Process2 to enable the read operation2 to occur2.

   always @ (posedge pclk2 or negedge n_p_reset2)
   begin: p_read_sel2

      if (!n_p_reset2)                                   
      begin                                     
         prdata2 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr2)

               CLK_CTRL_REG_1_ADDR2 : prdata2 <= {25'h0000000,clk_ctrl_reg_12};
               CLK_CTRL_REG_2_ADDR2 : prdata2 <= {25'h0000000,clk_ctrl_reg_22};
               CLK_CTRL_REG_3_ADDR2 : prdata2 <= {25'h0000000,clk_ctrl_reg_32};
               CNTR_CTRL_REG_1_ADDR2: prdata2 <= {25'h0000000,cntr_ctrl_reg_12};
               CNTR_CTRL_REG_2_ADDR2: prdata2 <= {25'h0000000,cntr_ctrl_reg_22};
               CNTR_CTRL_REG_3_ADDR2: prdata2 <= {25'h0000000,cntr_ctrl_reg_32};
               CNTR_VAL_REG_1_ADDR2 : prdata2 <= {16'h0000,counter_val_reg_12};
               CNTR_VAL_REG_2_ADDR2 : prdata2 <= {16'h0000,counter_val_reg_22};
               CNTR_VAL_REG_3_ADDR2 : prdata2 <= {16'h0000,counter_val_reg_32};
               INTERVAL_REG_1_ADDR2 : prdata2 <= {16'h0000,interval_reg_12};
               INTERVAL_REG_2_ADDR2 : prdata2 <= {16'h0000,interval_reg_22};
               INTERVAL_REG_3_ADDR2 : prdata2 <= {16'h0000,interval_reg_32};
               MATCH_1_REG_1_ADDR2  : prdata2 <= {16'h0000,match_1_reg_12};
               MATCH_1_REG_2_ADDR2  : prdata2 <= {16'h0000,match_1_reg_22};
               MATCH_1_REG_3_ADDR2  : prdata2 <= {16'h0000,match_1_reg_32};
               MATCH_2_REG_1_ADDR2  : prdata2 <= {16'h0000,match_2_reg_12};
               MATCH_2_REG_2_ADDR2  : prdata2 <= {16'h0000,match_2_reg_22};
               MATCH_2_REG_3_ADDR2  : prdata2 <= {16'h0000,match_2_reg_32};
               MATCH_3_REG_1_ADDR2  : prdata2 <= {16'h0000,match_3_reg_12};
               MATCH_3_REG_2_ADDR2  : prdata2 <= {16'h0000,match_3_reg_22};
               MATCH_3_REG_3_ADDR2  : prdata2 <= {16'h0000,match_3_reg_32};
               IRQ_REG_1_ADDR2      : prdata2 <= {26'h0000,interrupt_reg_12};
               IRQ_REG_2_ADDR2      : prdata2 <= {26'h0000,interrupt_reg_22};
               IRQ_REG_3_ADDR2      : prdata2 <= {26'h0000,interrupt_reg_32};
               IRQ_EN_REG_1_ADDR2   : prdata2 <= {26'h0000,interrupt_en_reg_12};
               IRQ_EN_REG_2_ADDR2   : prdata2 <= {26'h0000,interrupt_en_reg_22};
               IRQ_EN_REG_3_ADDR2   : prdata2 <= {26'h0000,interrupt_en_reg_32};
               default             : prdata2 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata2 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset2)
      
   end // block: p_read_sel2

endmodule

