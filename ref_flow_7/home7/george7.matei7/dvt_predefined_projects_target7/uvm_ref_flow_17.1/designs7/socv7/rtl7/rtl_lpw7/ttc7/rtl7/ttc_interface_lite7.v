//File7 name   : ttc_interface_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : The APB7 interface with the triple7 timer7 counter
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module7 definition7
//----------------------------------------------------------------------------

module ttc_interface_lite7( 

  //inputs7
  n_p_reset7,    
  pclk7,                          
  psel7,
  penable7,
  pwrite7,
  paddr7,
  clk_ctrl_reg_17,
  clk_ctrl_reg_27,
  clk_ctrl_reg_37,
  cntr_ctrl_reg_17,
  cntr_ctrl_reg_27,
  cntr_ctrl_reg_37,
  counter_val_reg_17,
  counter_val_reg_27,
  counter_val_reg_37,
  interval_reg_17,
  match_1_reg_17,
  match_2_reg_17,
  match_3_reg_17,
  interval_reg_27,
  match_1_reg_27,
  match_2_reg_27,
  match_3_reg_27,
  interval_reg_37,
  match_1_reg_37,
  match_2_reg_37,
  match_3_reg_37,
  interrupt_reg_17,
  interrupt_reg_27,
  interrupt_reg_37,      
  interrupt_en_reg_17,
  interrupt_en_reg_27,
  interrupt_en_reg_37,
                  
  //outputs7
  prdata7,
  clk_ctrl_reg_sel_17,
  clk_ctrl_reg_sel_27,
  clk_ctrl_reg_sel_37,
  cntr_ctrl_reg_sel_17,
  cntr_ctrl_reg_sel_27,
  cntr_ctrl_reg_sel_37,
  interval_reg_sel_17,                            
  interval_reg_sel_27,                          
  interval_reg_sel_37,
  match_1_reg_sel_17,                          
  match_1_reg_sel_27,                          
  match_1_reg_sel_37,                
  match_2_reg_sel_17,                          
  match_2_reg_sel_27,
  match_2_reg_sel_37,
  match_3_reg_sel_17,                          
  match_3_reg_sel_27,                         
  match_3_reg_sel_37,
  intr_en_reg_sel7,
  clear_interrupt7        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS7
//----------------------------------------------------------------------------

   //inputs7
   input        n_p_reset7;              //reset signal7
   input        pclk7;                 //System7 Clock7
   input        psel7;                 //Select7 line
   input        penable7;              //Strobe7 line
   input        pwrite7;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr7;                //Address Bus7 register
   input [6:0]  clk_ctrl_reg_17;       //Clock7 Control7 reg for Timer_Counter7 1
   input [6:0]  cntr_ctrl_reg_17;      //Counter7 Control7 reg for Timer_Counter7 1
   input [6:0]  clk_ctrl_reg_27;       //Clock7 Control7 reg for Timer_Counter7 2
   input [6:0]  cntr_ctrl_reg_27;      //Counter7 Control7 reg for Timer7 Counter7 2
   input [6:0]  clk_ctrl_reg_37;       //Clock7 Control7 reg Timer_Counter7 3
   input [6:0]  cntr_ctrl_reg_37;      //Counter7 Control7 reg for Timer7 Counter7 3
   input [15:0] counter_val_reg_17;    //Counter7 Value from Timer_Counter7 1
   input [15:0] counter_val_reg_27;    //Counter7 Value from Timer_Counter7 2
   input [15:0] counter_val_reg_37;    //Counter7 Value from Timer_Counter7 3
   input [15:0] interval_reg_17;       //Interval7 reg value from Timer_Counter7 1
   input [15:0] match_1_reg_17;        //Match7 reg value from Timer_Counter7 
   input [15:0] match_2_reg_17;        //Match7 reg value from Timer_Counter7     
   input [15:0] match_3_reg_17;        //Match7 reg value from Timer_Counter7 
   input [15:0] interval_reg_27;       //Interval7 reg value from Timer_Counter7 2
   input [15:0] match_1_reg_27;        //Match7 reg value from Timer_Counter7     
   input [15:0] match_2_reg_27;        //Match7 reg value from Timer_Counter7     
   input [15:0] match_3_reg_27;        //Match7 reg value from Timer_Counter7 
   input [15:0] interval_reg_37;       //Interval7 reg value from Timer_Counter7 3
   input [15:0] match_1_reg_37;        //Match7 reg value from Timer_Counter7   
   input [15:0] match_2_reg_37;        //Match7 reg value from Timer_Counter7   
   input [15:0] match_3_reg_37;        //Match7 reg value from Timer_Counter7   
   input [5:0]  interrupt_reg_17;      //Interrupt7 Reg7 from Interrupt7 Module7 1
   input [5:0]  interrupt_reg_27;      //Interrupt7 Reg7 from Interrupt7 Module7 2
   input [5:0]  interrupt_reg_37;      //Interrupt7 Reg7 from Interrupt7 Module7 3
   input [5:0]  interrupt_en_reg_17;   //Interrupt7 Enable7 Reg7 from Intrpt7 Module7 1
   input [5:0]  interrupt_en_reg_27;   //Interrupt7 Enable7 Reg7 from Intrpt7 Module7 2
   input [5:0]  interrupt_en_reg_37;   //Interrupt7 Enable7 Reg7 from Intrpt7 Module7 3
   
   //outputs7
   output [31:0] prdata7;              //Read Data from the APB7 Interface7
   output clk_ctrl_reg_sel_17;         //Clock7 Control7 Reg7 Select7 TC_17 
   output clk_ctrl_reg_sel_27;         //Clock7 Control7 Reg7 Select7 TC_27 
   output clk_ctrl_reg_sel_37;         //Clock7 Control7 Reg7 Select7 TC_37 
   output cntr_ctrl_reg_sel_17;        //Counter7 Control7 Reg7 Select7 TC_17
   output cntr_ctrl_reg_sel_27;        //Counter7 Control7 Reg7 Select7 TC_27
   output cntr_ctrl_reg_sel_37;        //Counter7 Control7 Reg7 Select7 TC_37
   output interval_reg_sel_17;         //Interval7 Interrupt7 Reg7 Select7 TC_17 
   output interval_reg_sel_27;         //Interval7 Interrupt7 Reg7 Select7 TC_27 
   output interval_reg_sel_37;         //Interval7 Interrupt7 Reg7 Select7 TC_37 
   output match_1_reg_sel_17;          //Match7 Reg7 Select7 TC_17
   output match_1_reg_sel_27;          //Match7 Reg7 Select7 TC_27
   output match_1_reg_sel_37;          //Match7 Reg7 Select7 TC_37
   output match_2_reg_sel_17;          //Match7 Reg7 Select7 TC_17
   output match_2_reg_sel_27;          //Match7 Reg7 Select7 TC_27
   output match_2_reg_sel_37;          //Match7 Reg7 Select7 TC_37
   output match_3_reg_sel_17;          //Match7 Reg7 Select7 TC_17
   output match_3_reg_sel_27;          //Match7 Reg7 Select7 TC_27
   output match_3_reg_sel_37;          //Match7 Reg7 Select7 TC_37
   output [3:1] intr_en_reg_sel7;      //Interrupt7 Enable7 Reg7 Select7
   output [3:1] clear_interrupt7;      //Clear Interrupt7 line


//-----------------------------------------------------------------------------
// PARAMETER7 DECLARATIONS7
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR7   = 8'h00; //Clock7 control7 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR7   = 8'h04; //Clock7 control7 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR7   = 8'h08; //Clock7 control7 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR7  = 8'h0C; //Counter7 control7 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR7  = 8'h10; //Counter7 control7 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR7  = 8'h14; //Counter7 control7 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR7   = 8'h18; //Counter7 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR7   = 8'h1C; //Counter7 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR7   = 8'h20; //Counter7 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR7   = 8'h24; //Module7 1 interval7 address
   parameter   [7:0] INTERVAL_REG_2_ADDR7   = 8'h28; //Module7 2 interval7 address
   parameter   [7:0] INTERVAL_REG_3_ADDR7   = 8'h2C; //Module7 3 interval7 address
   parameter   [7:0] MATCH_1_REG_1_ADDR7    = 8'h30; //Module7 1 Match7 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR7    = 8'h34; //Module7 2 Match7 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR7    = 8'h38; //Module7 3 Match7 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR7    = 8'h3C; //Module7 1 Match7 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR7    = 8'h40; //Module7 2 Match7 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR7    = 8'h44; //Module7 3 Match7 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR7    = 8'h48; //Module7 1 Match7 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR7    = 8'h4C; //Module7 2 Match7 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR7    = 8'h50; //Module7 3 Match7 3 address
   parameter   [7:0] IRQ_REG_1_ADDR7        = 8'h54; //Interrupt7 register 1
   parameter   [7:0] IRQ_REG_2_ADDR7        = 8'h58; //Interrupt7 register 2
   parameter   [7:0] IRQ_REG_3_ADDR7        = 8'h5C; //Interrupt7 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR7     = 8'h60; //Interrupt7 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR7     = 8'h64; //Interrupt7 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR7     = 8'h68; //Interrupt7 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals7 & Registers7
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_17;         //Clock7 Control7 Reg7 Select7 TC_17
   reg clk_ctrl_reg_sel_27;         //Clock7 Control7 Reg7 Select7 TC_27 
   reg clk_ctrl_reg_sel_37;         //Clock7 Control7 Reg7 Select7 TC_37 
   reg cntr_ctrl_reg_sel_17;        //Counter7 Control7 Reg7 Select7 TC_17
   reg cntr_ctrl_reg_sel_27;        //Counter7 Control7 Reg7 Select7 TC_27
   reg cntr_ctrl_reg_sel_37;        //Counter7 Control7 Reg7 Select7 TC_37
   reg interval_reg_sel_17;         //Interval7 Interrupt7 Reg7 Select7 TC_17 
   reg interval_reg_sel_27;         //Interval7 Interrupt7 Reg7 Select7 TC_27
   reg interval_reg_sel_37;         //Interval7 Interrupt7 Reg7 Select7 TC_37
   reg match_1_reg_sel_17;          //Match7 Reg7 Select7 TC_17
   reg match_1_reg_sel_27;          //Match7 Reg7 Select7 TC_27
   reg match_1_reg_sel_37;          //Match7 Reg7 Select7 TC_37
   reg match_2_reg_sel_17;          //Match7 Reg7 Select7 TC_17
   reg match_2_reg_sel_27;          //Match7 Reg7 Select7 TC_27
   reg match_2_reg_sel_37;          //Match7 Reg7 Select7 TC_37
   reg match_3_reg_sel_17;          //Match7 Reg7 Select7 TC_17
   reg match_3_reg_sel_27;          //Match7 Reg7 Select7 TC_27
   reg match_3_reg_sel_37;          //Match7 Reg7 Select7 TC_37
   reg [3:1] intr_en_reg_sel7;      //Interrupt7 Enable7 1 Reg7 Select7
   reg [31:0] prdata7;              //APB7 read data
   
   wire [3:1] clear_interrupt7;     // 3-bit clear interrupt7 reg on read
   wire write;                     //APB7 write command  
   wire read;                      //APB7 read command    



   assign write = psel7 & penable7 & pwrite7;  
   assign read  = psel7 & ~pwrite7;  
   assign clear_interrupt7[1] = read & penable7 & (paddr7 == IRQ_REG_1_ADDR7);
   assign clear_interrupt7[2] = read & penable7 & (paddr7 == IRQ_REG_2_ADDR7);
   assign clear_interrupt7[3] = read & penable7 & (paddr7 == IRQ_REG_3_ADDR7);   
   
   //p_write_sel7: Process7 to select7 the required7 regs for write access.

   always @ (paddr7 or write)
   begin: p_write_sel7

       clk_ctrl_reg_sel_17  = (write && (paddr7 == CLK_CTRL_REG_1_ADDR7));
       clk_ctrl_reg_sel_27  = (write && (paddr7 == CLK_CTRL_REG_2_ADDR7));
       clk_ctrl_reg_sel_37  = (write && (paddr7 == CLK_CTRL_REG_3_ADDR7));
       cntr_ctrl_reg_sel_17 = (write && (paddr7 == CNTR_CTRL_REG_1_ADDR7));
       cntr_ctrl_reg_sel_27 = (write && (paddr7 == CNTR_CTRL_REG_2_ADDR7));
       cntr_ctrl_reg_sel_37 = (write && (paddr7 == CNTR_CTRL_REG_3_ADDR7));
       interval_reg_sel_17  = (write && (paddr7 == INTERVAL_REG_1_ADDR7));
       interval_reg_sel_27  = (write && (paddr7 == INTERVAL_REG_2_ADDR7));
       interval_reg_sel_37  = (write && (paddr7 == INTERVAL_REG_3_ADDR7));
       match_1_reg_sel_17   = (write && (paddr7 == MATCH_1_REG_1_ADDR7));
       match_1_reg_sel_27   = (write && (paddr7 == MATCH_1_REG_2_ADDR7));
       match_1_reg_sel_37   = (write && (paddr7 == MATCH_1_REG_3_ADDR7));
       match_2_reg_sel_17   = (write && (paddr7 == MATCH_2_REG_1_ADDR7));
       match_2_reg_sel_27   = (write && (paddr7 == MATCH_2_REG_2_ADDR7));
       match_2_reg_sel_37   = (write && (paddr7 == MATCH_2_REG_3_ADDR7));
       match_3_reg_sel_17   = (write && (paddr7 == MATCH_3_REG_1_ADDR7));
       match_3_reg_sel_27   = (write && (paddr7 == MATCH_3_REG_2_ADDR7));
       match_3_reg_sel_37   = (write && (paddr7 == MATCH_3_REG_3_ADDR7));
       intr_en_reg_sel7[1]  = (write && (paddr7 == IRQ_EN_REG_1_ADDR7));
       intr_en_reg_sel7[2]  = (write && (paddr7 == IRQ_EN_REG_2_ADDR7));
       intr_en_reg_sel7[3]  = (write && (paddr7 == IRQ_EN_REG_3_ADDR7));      
   end  //p_write_sel7
    

//    p_read_sel7: Process7 to enable the read operation7 to occur7.

   always @ (posedge pclk7 or negedge n_p_reset7)
   begin: p_read_sel7

      if (!n_p_reset7)                                   
      begin                                     
         prdata7 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr7)

               CLK_CTRL_REG_1_ADDR7 : prdata7 <= {25'h0000000,clk_ctrl_reg_17};
               CLK_CTRL_REG_2_ADDR7 : prdata7 <= {25'h0000000,clk_ctrl_reg_27};
               CLK_CTRL_REG_3_ADDR7 : prdata7 <= {25'h0000000,clk_ctrl_reg_37};
               CNTR_CTRL_REG_1_ADDR7: prdata7 <= {25'h0000000,cntr_ctrl_reg_17};
               CNTR_CTRL_REG_2_ADDR7: prdata7 <= {25'h0000000,cntr_ctrl_reg_27};
               CNTR_CTRL_REG_3_ADDR7: prdata7 <= {25'h0000000,cntr_ctrl_reg_37};
               CNTR_VAL_REG_1_ADDR7 : prdata7 <= {16'h0000,counter_val_reg_17};
               CNTR_VAL_REG_2_ADDR7 : prdata7 <= {16'h0000,counter_val_reg_27};
               CNTR_VAL_REG_3_ADDR7 : prdata7 <= {16'h0000,counter_val_reg_37};
               INTERVAL_REG_1_ADDR7 : prdata7 <= {16'h0000,interval_reg_17};
               INTERVAL_REG_2_ADDR7 : prdata7 <= {16'h0000,interval_reg_27};
               INTERVAL_REG_3_ADDR7 : prdata7 <= {16'h0000,interval_reg_37};
               MATCH_1_REG_1_ADDR7  : prdata7 <= {16'h0000,match_1_reg_17};
               MATCH_1_REG_2_ADDR7  : prdata7 <= {16'h0000,match_1_reg_27};
               MATCH_1_REG_3_ADDR7  : prdata7 <= {16'h0000,match_1_reg_37};
               MATCH_2_REG_1_ADDR7  : prdata7 <= {16'h0000,match_2_reg_17};
               MATCH_2_REG_2_ADDR7  : prdata7 <= {16'h0000,match_2_reg_27};
               MATCH_2_REG_3_ADDR7  : prdata7 <= {16'h0000,match_2_reg_37};
               MATCH_3_REG_1_ADDR7  : prdata7 <= {16'h0000,match_3_reg_17};
               MATCH_3_REG_2_ADDR7  : prdata7 <= {16'h0000,match_3_reg_27};
               MATCH_3_REG_3_ADDR7  : prdata7 <= {16'h0000,match_3_reg_37};
               IRQ_REG_1_ADDR7      : prdata7 <= {26'h0000,interrupt_reg_17};
               IRQ_REG_2_ADDR7      : prdata7 <= {26'h0000,interrupt_reg_27};
               IRQ_REG_3_ADDR7      : prdata7 <= {26'h0000,interrupt_reg_37};
               IRQ_EN_REG_1_ADDR7   : prdata7 <= {26'h0000,interrupt_en_reg_17};
               IRQ_EN_REG_2_ADDR7   : prdata7 <= {26'h0000,interrupt_en_reg_27};
               IRQ_EN_REG_3_ADDR7   : prdata7 <= {26'h0000,interrupt_en_reg_37};
               default             : prdata7 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata7 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset7)
      
   end // block: p_read_sel7

endmodule

