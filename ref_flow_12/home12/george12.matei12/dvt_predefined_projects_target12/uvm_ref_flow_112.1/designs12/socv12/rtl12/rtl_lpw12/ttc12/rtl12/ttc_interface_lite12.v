//File12 name   : ttc_interface_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : The APB12 interface with the triple12 timer12 counter
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module12 definition12
//----------------------------------------------------------------------------

module ttc_interface_lite12( 

  //inputs12
  n_p_reset12,    
  pclk12,                          
  psel12,
  penable12,
  pwrite12,
  paddr12,
  clk_ctrl_reg_112,
  clk_ctrl_reg_212,
  clk_ctrl_reg_312,
  cntr_ctrl_reg_112,
  cntr_ctrl_reg_212,
  cntr_ctrl_reg_312,
  counter_val_reg_112,
  counter_val_reg_212,
  counter_val_reg_312,
  interval_reg_112,
  match_1_reg_112,
  match_2_reg_112,
  match_3_reg_112,
  interval_reg_212,
  match_1_reg_212,
  match_2_reg_212,
  match_3_reg_212,
  interval_reg_312,
  match_1_reg_312,
  match_2_reg_312,
  match_3_reg_312,
  interrupt_reg_112,
  interrupt_reg_212,
  interrupt_reg_312,      
  interrupt_en_reg_112,
  interrupt_en_reg_212,
  interrupt_en_reg_312,
                  
  //outputs12
  prdata12,
  clk_ctrl_reg_sel_112,
  clk_ctrl_reg_sel_212,
  clk_ctrl_reg_sel_312,
  cntr_ctrl_reg_sel_112,
  cntr_ctrl_reg_sel_212,
  cntr_ctrl_reg_sel_312,
  interval_reg_sel_112,                            
  interval_reg_sel_212,                          
  interval_reg_sel_312,
  match_1_reg_sel_112,                          
  match_1_reg_sel_212,                          
  match_1_reg_sel_312,                
  match_2_reg_sel_112,                          
  match_2_reg_sel_212,
  match_2_reg_sel_312,
  match_3_reg_sel_112,                          
  match_3_reg_sel_212,                         
  match_3_reg_sel_312,
  intr_en_reg_sel12,
  clear_interrupt12        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS12
//----------------------------------------------------------------------------

   //inputs12
   input        n_p_reset12;              //reset signal12
   input        pclk12;                 //System12 Clock12
   input        psel12;                 //Select12 line
   input        penable12;              //Strobe12 line
   input        pwrite12;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr12;                //Address Bus12 register
   input [6:0]  clk_ctrl_reg_112;       //Clock12 Control12 reg for Timer_Counter12 1
   input [6:0]  cntr_ctrl_reg_112;      //Counter12 Control12 reg for Timer_Counter12 1
   input [6:0]  clk_ctrl_reg_212;       //Clock12 Control12 reg for Timer_Counter12 2
   input [6:0]  cntr_ctrl_reg_212;      //Counter12 Control12 reg for Timer12 Counter12 2
   input [6:0]  clk_ctrl_reg_312;       //Clock12 Control12 reg Timer_Counter12 3
   input [6:0]  cntr_ctrl_reg_312;      //Counter12 Control12 reg for Timer12 Counter12 3
   input [15:0] counter_val_reg_112;    //Counter12 Value from Timer_Counter12 1
   input [15:0] counter_val_reg_212;    //Counter12 Value from Timer_Counter12 2
   input [15:0] counter_val_reg_312;    //Counter12 Value from Timer_Counter12 3
   input [15:0] interval_reg_112;       //Interval12 reg value from Timer_Counter12 1
   input [15:0] match_1_reg_112;        //Match12 reg value from Timer_Counter12 
   input [15:0] match_2_reg_112;        //Match12 reg value from Timer_Counter12     
   input [15:0] match_3_reg_112;        //Match12 reg value from Timer_Counter12 
   input [15:0] interval_reg_212;       //Interval12 reg value from Timer_Counter12 2
   input [15:0] match_1_reg_212;        //Match12 reg value from Timer_Counter12     
   input [15:0] match_2_reg_212;        //Match12 reg value from Timer_Counter12     
   input [15:0] match_3_reg_212;        //Match12 reg value from Timer_Counter12 
   input [15:0] interval_reg_312;       //Interval12 reg value from Timer_Counter12 3
   input [15:0] match_1_reg_312;        //Match12 reg value from Timer_Counter12   
   input [15:0] match_2_reg_312;        //Match12 reg value from Timer_Counter12   
   input [15:0] match_3_reg_312;        //Match12 reg value from Timer_Counter12   
   input [5:0]  interrupt_reg_112;      //Interrupt12 Reg12 from Interrupt12 Module12 1
   input [5:0]  interrupt_reg_212;      //Interrupt12 Reg12 from Interrupt12 Module12 2
   input [5:0]  interrupt_reg_312;      //Interrupt12 Reg12 from Interrupt12 Module12 3
   input [5:0]  interrupt_en_reg_112;   //Interrupt12 Enable12 Reg12 from Intrpt12 Module12 1
   input [5:0]  interrupt_en_reg_212;   //Interrupt12 Enable12 Reg12 from Intrpt12 Module12 2
   input [5:0]  interrupt_en_reg_312;   //Interrupt12 Enable12 Reg12 from Intrpt12 Module12 3
   
   //outputs12
   output [31:0] prdata12;              //Read Data from the APB12 Interface12
   output clk_ctrl_reg_sel_112;         //Clock12 Control12 Reg12 Select12 TC_112 
   output clk_ctrl_reg_sel_212;         //Clock12 Control12 Reg12 Select12 TC_212 
   output clk_ctrl_reg_sel_312;         //Clock12 Control12 Reg12 Select12 TC_312 
   output cntr_ctrl_reg_sel_112;        //Counter12 Control12 Reg12 Select12 TC_112
   output cntr_ctrl_reg_sel_212;        //Counter12 Control12 Reg12 Select12 TC_212
   output cntr_ctrl_reg_sel_312;        //Counter12 Control12 Reg12 Select12 TC_312
   output interval_reg_sel_112;         //Interval12 Interrupt12 Reg12 Select12 TC_112 
   output interval_reg_sel_212;         //Interval12 Interrupt12 Reg12 Select12 TC_212 
   output interval_reg_sel_312;         //Interval12 Interrupt12 Reg12 Select12 TC_312 
   output match_1_reg_sel_112;          //Match12 Reg12 Select12 TC_112
   output match_1_reg_sel_212;          //Match12 Reg12 Select12 TC_212
   output match_1_reg_sel_312;          //Match12 Reg12 Select12 TC_312
   output match_2_reg_sel_112;          //Match12 Reg12 Select12 TC_112
   output match_2_reg_sel_212;          //Match12 Reg12 Select12 TC_212
   output match_2_reg_sel_312;          //Match12 Reg12 Select12 TC_312
   output match_3_reg_sel_112;          //Match12 Reg12 Select12 TC_112
   output match_3_reg_sel_212;          //Match12 Reg12 Select12 TC_212
   output match_3_reg_sel_312;          //Match12 Reg12 Select12 TC_312
   output [3:1] intr_en_reg_sel12;      //Interrupt12 Enable12 Reg12 Select12
   output [3:1] clear_interrupt12;      //Clear Interrupt12 line


//-----------------------------------------------------------------------------
// PARAMETER12 DECLARATIONS12
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR12   = 8'h00; //Clock12 control12 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR12   = 8'h04; //Clock12 control12 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR12   = 8'h08; //Clock12 control12 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR12  = 8'h0C; //Counter12 control12 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR12  = 8'h10; //Counter12 control12 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR12  = 8'h14; //Counter12 control12 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR12   = 8'h18; //Counter12 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR12   = 8'h1C; //Counter12 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR12   = 8'h20; //Counter12 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR12   = 8'h24; //Module12 1 interval12 address
   parameter   [7:0] INTERVAL_REG_2_ADDR12   = 8'h28; //Module12 2 interval12 address
   parameter   [7:0] INTERVAL_REG_3_ADDR12   = 8'h2C; //Module12 3 interval12 address
   parameter   [7:0] MATCH_1_REG_1_ADDR12    = 8'h30; //Module12 1 Match12 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR12    = 8'h34; //Module12 2 Match12 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR12    = 8'h38; //Module12 3 Match12 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR12    = 8'h3C; //Module12 1 Match12 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR12    = 8'h40; //Module12 2 Match12 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR12    = 8'h44; //Module12 3 Match12 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR12    = 8'h48; //Module12 1 Match12 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR12    = 8'h4C; //Module12 2 Match12 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR12    = 8'h50; //Module12 3 Match12 3 address
   parameter   [7:0] IRQ_REG_1_ADDR12        = 8'h54; //Interrupt12 register 1
   parameter   [7:0] IRQ_REG_2_ADDR12        = 8'h58; //Interrupt12 register 2
   parameter   [7:0] IRQ_REG_3_ADDR12        = 8'h5C; //Interrupt12 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR12     = 8'h60; //Interrupt12 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR12     = 8'h64; //Interrupt12 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR12     = 8'h68; //Interrupt12 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals12 & Registers12
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_112;         //Clock12 Control12 Reg12 Select12 TC_112
   reg clk_ctrl_reg_sel_212;         //Clock12 Control12 Reg12 Select12 TC_212 
   reg clk_ctrl_reg_sel_312;         //Clock12 Control12 Reg12 Select12 TC_312 
   reg cntr_ctrl_reg_sel_112;        //Counter12 Control12 Reg12 Select12 TC_112
   reg cntr_ctrl_reg_sel_212;        //Counter12 Control12 Reg12 Select12 TC_212
   reg cntr_ctrl_reg_sel_312;        //Counter12 Control12 Reg12 Select12 TC_312
   reg interval_reg_sel_112;         //Interval12 Interrupt12 Reg12 Select12 TC_112 
   reg interval_reg_sel_212;         //Interval12 Interrupt12 Reg12 Select12 TC_212
   reg interval_reg_sel_312;         //Interval12 Interrupt12 Reg12 Select12 TC_312
   reg match_1_reg_sel_112;          //Match12 Reg12 Select12 TC_112
   reg match_1_reg_sel_212;          //Match12 Reg12 Select12 TC_212
   reg match_1_reg_sel_312;          //Match12 Reg12 Select12 TC_312
   reg match_2_reg_sel_112;          //Match12 Reg12 Select12 TC_112
   reg match_2_reg_sel_212;          //Match12 Reg12 Select12 TC_212
   reg match_2_reg_sel_312;          //Match12 Reg12 Select12 TC_312
   reg match_3_reg_sel_112;          //Match12 Reg12 Select12 TC_112
   reg match_3_reg_sel_212;          //Match12 Reg12 Select12 TC_212
   reg match_3_reg_sel_312;          //Match12 Reg12 Select12 TC_312
   reg [3:1] intr_en_reg_sel12;      //Interrupt12 Enable12 1 Reg12 Select12
   reg [31:0] prdata12;              //APB12 read data
   
   wire [3:1] clear_interrupt12;     // 3-bit clear interrupt12 reg on read
   wire write;                     //APB12 write command  
   wire read;                      //APB12 read command    



   assign write = psel12 & penable12 & pwrite12;  
   assign read  = psel12 & ~pwrite12;  
   assign clear_interrupt12[1] = read & penable12 & (paddr12 == IRQ_REG_1_ADDR12);
   assign clear_interrupt12[2] = read & penable12 & (paddr12 == IRQ_REG_2_ADDR12);
   assign clear_interrupt12[3] = read & penable12 & (paddr12 == IRQ_REG_3_ADDR12);   
   
   //p_write_sel12: Process12 to select12 the required12 regs for write access.

   always @ (paddr12 or write)
   begin: p_write_sel12

       clk_ctrl_reg_sel_112  = (write && (paddr12 == CLK_CTRL_REG_1_ADDR12));
       clk_ctrl_reg_sel_212  = (write && (paddr12 == CLK_CTRL_REG_2_ADDR12));
       clk_ctrl_reg_sel_312  = (write && (paddr12 == CLK_CTRL_REG_3_ADDR12));
       cntr_ctrl_reg_sel_112 = (write && (paddr12 == CNTR_CTRL_REG_1_ADDR12));
       cntr_ctrl_reg_sel_212 = (write && (paddr12 == CNTR_CTRL_REG_2_ADDR12));
       cntr_ctrl_reg_sel_312 = (write && (paddr12 == CNTR_CTRL_REG_3_ADDR12));
       interval_reg_sel_112  = (write && (paddr12 == INTERVAL_REG_1_ADDR12));
       interval_reg_sel_212  = (write && (paddr12 == INTERVAL_REG_2_ADDR12));
       interval_reg_sel_312  = (write && (paddr12 == INTERVAL_REG_3_ADDR12));
       match_1_reg_sel_112   = (write && (paddr12 == MATCH_1_REG_1_ADDR12));
       match_1_reg_sel_212   = (write && (paddr12 == MATCH_1_REG_2_ADDR12));
       match_1_reg_sel_312   = (write && (paddr12 == MATCH_1_REG_3_ADDR12));
       match_2_reg_sel_112   = (write && (paddr12 == MATCH_2_REG_1_ADDR12));
       match_2_reg_sel_212   = (write && (paddr12 == MATCH_2_REG_2_ADDR12));
       match_2_reg_sel_312   = (write && (paddr12 == MATCH_2_REG_3_ADDR12));
       match_3_reg_sel_112   = (write && (paddr12 == MATCH_3_REG_1_ADDR12));
       match_3_reg_sel_212   = (write && (paddr12 == MATCH_3_REG_2_ADDR12));
       match_3_reg_sel_312   = (write && (paddr12 == MATCH_3_REG_3_ADDR12));
       intr_en_reg_sel12[1]  = (write && (paddr12 == IRQ_EN_REG_1_ADDR12));
       intr_en_reg_sel12[2]  = (write && (paddr12 == IRQ_EN_REG_2_ADDR12));
       intr_en_reg_sel12[3]  = (write && (paddr12 == IRQ_EN_REG_3_ADDR12));      
   end  //p_write_sel12
    

//    p_read_sel12: Process12 to enable the read operation12 to occur12.

   always @ (posedge pclk12 or negedge n_p_reset12)
   begin: p_read_sel12

      if (!n_p_reset12)                                   
      begin                                     
         prdata12 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr12)

               CLK_CTRL_REG_1_ADDR12 : prdata12 <= {25'h0000000,clk_ctrl_reg_112};
               CLK_CTRL_REG_2_ADDR12 : prdata12 <= {25'h0000000,clk_ctrl_reg_212};
               CLK_CTRL_REG_3_ADDR12 : prdata12 <= {25'h0000000,clk_ctrl_reg_312};
               CNTR_CTRL_REG_1_ADDR12: prdata12 <= {25'h0000000,cntr_ctrl_reg_112};
               CNTR_CTRL_REG_2_ADDR12: prdata12 <= {25'h0000000,cntr_ctrl_reg_212};
               CNTR_CTRL_REG_3_ADDR12: prdata12 <= {25'h0000000,cntr_ctrl_reg_312};
               CNTR_VAL_REG_1_ADDR12 : prdata12 <= {16'h0000,counter_val_reg_112};
               CNTR_VAL_REG_2_ADDR12 : prdata12 <= {16'h0000,counter_val_reg_212};
               CNTR_VAL_REG_3_ADDR12 : prdata12 <= {16'h0000,counter_val_reg_312};
               INTERVAL_REG_1_ADDR12 : prdata12 <= {16'h0000,interval_reg_112};
               INTERVAL_REG_2_ADDR12 : prdata12 <= {16'h0000,interval_reg_212};
               INTERVAL_REG_3_ADDR12 : prdata12 <= {16'h0000,interval_reg_312};
               MATCH_1_REG_1_ADDR12  : prdata12 <= {16'h0000,match_1_reg_112};
               MATCH_1_REG_2_ADDR12  : prdata12 <= {16'h0000,match_1_reg_212};
               MATCH_1_REG_3_ADDR12  : prdata12 <= {16'h0000,match_1_reg_312};
               MATCH_2_REG_1_ADDR12  : prdata12 <= {16'h0000,match_2_reg_112};
               MATCH_2_REG_2_ADDR12  : prdata12 <= {16'h0000,match_2_reg_212};
               MATCH_2_REG_3_ADDR12  : prdata12 <= {16'h0000,match_2_reg_312};
               MATCH_3_REG_1_ADDR12  : prdata12 <= {16'h0000,match_3_reg_112};
               MATCH_3_REG_2_ADDR12  : prdata12 <= {16'h0000,match_3_reg_212};
               MATCH_3_REG_3_ADDR12  : prdata12 <= {16'h0000,match_3_reg_312};
               IRQ_REG_1_ADDR12      : prdata12 <= {26'h0000,interrupt_reg_112};
               IRQ_REG_2_ADDR12      : prdata12 <= {26'h0000,interrupt_reg_212};
               IRQ_REG_3_ADDR12      : prdata12 <= {26'h0000,interrupt_reg_312};
               IRQ_EN_REG_1_ADDR12   : prdata12 <= {26'h0000,interrupt_en_reg_112};
               IRQ_EN_REG_2_ADDR12   : prdata12 <= {26'h0000,interrupt_en_reg_212};
               IRQ_EN_REG_3_ADDR12   : prdata12 <= {26'h0000,interrupt_en_reg_312};
               default             : prdata12 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata12 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset12)
      
   end // block: p_read_sel12

endmodule

