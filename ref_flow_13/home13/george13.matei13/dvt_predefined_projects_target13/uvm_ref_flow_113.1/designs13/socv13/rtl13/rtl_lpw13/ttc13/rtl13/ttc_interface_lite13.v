//File13 name   : ttc_interface_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : The APB13 interface with the triple13 timer13 counter
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module13 definition13
//----------------------------------------------------------------------------

module ttc_interface_lite13( 

  //inputs13
  n_p_reset13,    
  pclk13,                          
  psel13,
  penable13,
  pwrite13,
  paddr13,
  clk_ctrl_reg_113,
  clk_ctrl_reg_213,
  clk_ctrl_reg_313,
  cntr_ctrl_reg_113,
  cntr_ctrl_reg_213,
  cntr_ctrl_reg_313,
  counter_val_reg_113,
  counter_val_reg_213,
  counter_val_reg_313,
  interval_reg_113,
  match_1_reg_113,
  match_2_reg_113,
  match_3_reg_113,
  interval_reg_213,
  match_1_reg_213,
  match_2_reg_213,
  match_3_reg_213,
  interval_reg_313,
  match_1_reg_313,
  match_2_reg_313,
  match_3_reg_313,
  interrupt_reg_113,
  interrupt_reg_213,
  interrupt_reg_313,      
  interrupt_en_reg_113,
  interrupt_en_reg_213,
  interrupt_en_reg_313,
                  
  //outputs13
  prdata13,
  clk_ctrl_reg_sel_113,
  clk_ctrl_reg_sel_213,
  clk_ctrl_reg_sel_313,
  cntr_ctrl_reg_sel_113,
  cntr_ctrl_reg_sel_213,
  cntr_ctrl_reg_sel_313,
  interval_reg_sel_113,                            
  interval_reg_sel_213,                          
  interval_reg_sel_313,
  match_1_reg_sel_113,                          
  match_1_reg_sel_213,                          
  match_1_reg_sel_313,                
  match_2_reg_sel_113,                          
  match_2_reg_sel_213,
  match_2_reg_sel_313,
  match_3_reg_sel_113,                          
  match_3_reg_sel_213,                         
  match_3_reg_sel_313,
  intr_en_reg_sel13,
  clear_interrupt13        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS13
//----------------------------------------------------------------------------

   //inputs13
   input        n_p_reset13;              //reset signal13
   input        pclk13;                 //System13 Clock13
   input        psel13;                 //Select13 line
   input        penable13;              //Strobe13 line
   input        pwrite13;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr13;                //Address Bus13 register
   input [6:0]  clk_ctrl_reg_113;       //Clock13 Control13 reg for Timer_Counter13 1
   input [6:0]  cntr_ctrl_reg_113;      //Counter13 Control13 reg for Timer_Counter13 1
   input [6:0]  clk_ctrl_reg_213;       //Clock13 Control13 reg for Timer_Counter13 2
   input [6:0]  cntr_ctrl_reg_213;      //Counter13 Control13 reg for Timer13 Counter13 2
   input [6:0]  clk_ctrl_reg_313;       //Clock13 Control13 reg Timer_Counter13 3
   input [6:0]  cntr_ctrl_reg_313;      //Counter13 Control13 reg for Timer13 Counter13 3
   input [15:0] counter_val_reg_113;    //Counter13 Value from Timer_Counter13 1
   input [15:0] counter_val_reg_213;    //Counter13 Value from Timer_Counter13 2
   input [15:0] counter_val_reg_313;    //Counter13 Value from Timer_Counter13 3
   input [15:0] interval_reg_113;       //Interval13 reg value from Timer_Counter13 1
   input [15:0] match_1_reg_113;        //Match13 reg value from Timer_Counter13 
   input [15:0] match_2_reg_113;        //Match13 reg value from Timer_Counter13     
   input [15:0] match_3_reg_113;        //Match13 reg value from Timer_Counter13 
   input [15:0] interval_reg_213;       //Interval13 reg value from Timer_Counter13 2
   input [15:0] match_1_reg_213;        //Match13 reg value from Timer_Counter13     
   input [15:0] match_2_reg_213;        //Match13 reg value from Timer_Counter13     
   input [15:0] match_3_reg_213;        //Match13 reg value from Timer_Counter13 
   input [15:0] interval_reg_313;       //Interval13 reg value from Timer_Counter13 3
   input [15:0] match_1_reg_313;        //Match13 reg value from Timer_Counter13   
   input [15:0] match_2_reg_313;        //Match13 reg value from Timer_Counter13   
   input [15:0] match_3_reg_313;        //Match13 reg value from Timer_Counter13   
   input [5:0]  interrupt_reg_113;      //Interrupt13 Reg13 from Interrupt13 Module13 1
   input [5:0]  interrupt_reg_213;      //Interrupt13 Reg13 from Interrupt13 Module13 2
   input [5:0]  interrupt_reg_313;      //Interrupt13 Reg13 from Interrupt13 Module13 3
   input [5:0]  interrupt_en_reg_113;   //Interrupt13 Enable13 Reg13 from Intrpt13 Module13 1
   input [5:0]  interrupt_en_reg_213;   //Interrupt13 Enable13 Reg13 from Intrpt13 Module13 2
   input [5:0]  interrupt_en_reg_313;   //Interrupt13 Enable13 Reg13 from Intrpt13 Module13 3
   
   //outputs13
   output [31:0] prdata13;              //Read Data from the APB13 Interface13
   output clk_ctrl_reg_sel_113;         //Clock13 Control13 Reg13 Select13 TC_113 
   output clk_ctrl_reg_sel_213;         //Clock13 Control13 Reg13 Select13 TC_213 
   output clk_ctrl_reg_sel_313;         //Clock13 Control13 Reg13 Select13 TC_313 
   output cntr_ctrl_reg_sel_113;        //Counter13 Control13 Reg13 Select13 TC_113
   output cntr_ctrl_reg_sel_213;        //Counter13 Control13 Reg13 Select13 TC_213
   output cntr_ctrl_reg_sel_313;        //Counter13 Control13 Reg13 Select13 TC_313
   output interval_reg_sel_113;         //Interval13 Interrupt13 Reg13 Select13 TC_113 
   output interval_reg_sel_213;         //Interval13 Interrupt13 Reg13 Select13 TC_213 
   output interval_reg_sel_313;         //Interval13 Interrupt13 Reg13 Select13 TC_313 
   output match_1_reg_sel_113;          //Match13 Reg13 Select13 TC_113
   output match_1_reg_sel_213;          //Match13 Reg13 Select13 TC_213
   output match_1_reg_sel_313;          //Match13 Reg13 Select13 TC_313
   output match_2_reg_sel_113;          //Match13 Reg13 Select13 TC_113
   output match_2_reg_sel_213;          //Match13 Reg13 Select13 TC_213
   output match_2_reg_sel_313;          //Match13 Reg13 Select13 TC_313
   output match_3_reg_sel_113;          //Match13 Reg13 Select13 TC_113
   output match_3_reg_sel_213;          //Match13 Reg13 Select13 TC_213
   output match_3_reg_sel_313;          //Match13 Reg13 Select13 TC_313
   output [3:1] intr_en_reg_sel13;      //Interrupt13 Enable13 Reg13 Select13
   output [3:1] clear_interrupt13;      //Clear Interrupt13 line


//-----------------------------------------------------------------------------
// PARAMETER13 DECLARATIONS13
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR13   = 8'h00; //Clock13 control13 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR13   = 8'h04; //Clock13 control13 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR13   = 8'h08; //Clock13 control13 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR13  = 8'h0C; //Counter13 control13 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR13  = 8'h10; //Counter13 control13 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR13  = 8'h14; //Counter13 control13 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR13   = 8'h18; //Counter13 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR13   = 8'h1C; //Counter13 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR13   = 8'h20; //Counter13 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR13   = 8'h24; //Module13 1 interval13 address
   parameter   [7:0] INTERVAL_REG_2_ADDR13   = 8'h28; //Module13 2 interval13 address
   parameter   [7:0] INTERVAL_REG_3_ADDR13   = 8'h2C; //Module13 3 interval13 address
   parameter   [7:0] MATCH_1_REG_1_ADDR13    = 8'h30; //Module13 1 Match13 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR13    = 8'h34; //Module13 2 Match13 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR13    = 8'h38; //Module13 3 Match13 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR13    = 8'h3C; //Module13 1 Match13 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR13    = 8'h40; //Module13 2 Match13 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR13    = 8'h44; //Module13 3 Match13 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR13    = 8'h48; //Module13 1 Match13 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR13    = 8'h4C; //Module13 2 Match13 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR13    = 8'h50; //Module13 3 Match13 3 address
   parameter   [7:0] IRQ_REG_1_ADDR13        = 8'h54; //Interrupt13 register 1
   parameter   [7:0] IRQ_REG_2_ADDR13        = 8'h58; //Interrupt13 register 2
   parameter   [7:0] IRQ_REG_3_ADDR13        = 8'h5C; //Interrupt13 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR13     = 8'h60; //Interrupt13 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR13     = 8'h64; //Interrupt13 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR13     = 8'h68; //Interrupt13 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals13 & Registers13
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_113;         //Clock13 Control13 Reg13 Select13 TC_113
   reg clk_ctrl_reg_sel_213;         //Clock13 Control13 Reg13 Select13 TC_213 
   reg clk_ctrl_reg_sel_313;         //Clock13 Control13 Reg13 Select13 TC_313 
   reg cntr_ctrl_reg_sel_113;        //Counter13 Control13 Reg13 Select13 TC_113
   reg cntr_ctrl_reg_sel_213;        //Counter13 Control13 Reg13 Select13 TC_213
   reg cntr_ctrl_reg_sel_313;        //Counter13 Control13 Reg13 Select13 TC_313
   reg interval_reg_sel_113;         //Interval13 Interrupt13 Reg13 Select13 TC_113 
   reg interval_reg_sel_213;         //Interval13 Interrupt13 Reg13 Select13 TC_213
   reg interval_reg_sel_313;         //Interval13 Interrupt13 Reg13 Select13 TC_313
   reg match_1_reg_sel_113;          //Match13 Reg13 Select13 TC_113
   reg match_1_reg_sel_213;          //Match13 Reg13 Select13 TC_213
   reg match_1_reg_sel_313;          //Match13 Reg13 Select13 TC_313
   reg match_2_reg_sel_113;          //Match13 Reg13 Select13 TC_113
   reg match_2_reg_sel_213;          //Match13 Reg13 Select13 TC_213
   reg match_2_reg_sel_313;          //Match13 Reg13 Select13 TC_313
   reg match_3_reg_sel_113;          //Match13 Reg13 Select13 TC_113
   reg match_3_reg_sel_213;          //Match13 Reg13 Select13 TC_213
   reg match_3_reg_sel_313;          //Match13 Reg13 Select13 TC_313
   reg [3:1] intr_en_reg_sel13;      //Interrupt13 Enable13 1 Reg13 Select13
   reg [31:0] prdata13;              //APB13 read data
   
   wire [3:1] clear_interrupt13;     // 3-bit clear interrupt13 reg on read
   wire write;                     //APB13 write command  
   wire read;                      //APB13 read command    



   assign write = psel13 & penable13 & pwrite13;  
   assign read  = psel13 & ~pwrite13;  
   assign clear_interrupt13[1] = read & penable13 & (paddr13 == IRQ_REG_1_ADDR13);
   assign clear_interrupt13[2] = read & penable13 & (paddr13 == IRQ_REG_2_ADDR13);
   assign clear_interrupt13[3] = read & penable13 & (paddr13 == IRQ_REG_3_ADDR13);   
   
   //p_write_sel13: Process13 to select13 the required13 regs for write access.

   always @ (paddr13 or write)
   begin: p_write_sel13

       clk_ctrl_reg_sel_113  = (write && (paddr13 == CLK_CTRL_REG_1_ADDR13));
       clk_ctrl_reg_sel_213  = (write && (paddr13 == CLK_CTRL_REG_2_ADDR13));
       clk_ctrl_reg_sel_313  = (write && (paddr13 == CLK_CTRL_REG_3_ADDR13));
       cntr_ctrl_reg_sel_113 = (write && (paddr13 == CNTR_CTRL_REG_1_ADDR13));
       cntr_ctrl_reg_sel_213 = (write && (paddr13 == CNTR_CTRL_REG_2_ADDR13));
       cntr_ctrl_reg_sel_313 = (write && (paddr13 == CNTR_CTRL_REG_3_ADDR13));
       interval_reg_sel_113  = (write && (paddr13 == INTERVAL_REG_1_ADDR13));
       interval_reg_sel_213  = (write && (paddr13 == INTERVAL_REG_2_ADDR13));
       interval_reg_sel_313  = (write && (paddr13 == INTERVAL_REG_3_ADDR13));
       match_1_reg_sel_113   = (write && (paddr13 == MATCH_1_REG_1_ADDR13));
       match_1_reg_sel_213   = (write && (paddr13 == MATCH_1_REG_2_ADDR13));
       match_1_reg_sel_313   = (write && (paddr13 == MATCH_1_REG_3_ADDR13));
       match_2_reg_sel_113   = (write && (paddr13 == MATCH_2_REG_1_ADDR13));
       match_2_reg_sel_213   = (write && (paddr13 == MATCH_2_REG_2_ADDR13));
       match_2_reg_sel_313   = (write && (paddr13 == MATCH_2_REG_3_ADDR13));
       match_3_reg_sel_113   = (write && (paddr13 == MATCH_3_REG_1_ADDR13));
       match_3_reg_sel_213   = (write && (paddr13 == MATCH_3_REG_2_ADDR13));
       match_3_reg_sel_313   = (write && (paddr13 == MATCH_3_REG_3_ADDR13));
       intr_en_reg_sel13[1]  = (write && (paddr13 == IRQ_EN_REG_1_ADDR13));
       intr_en_reg_sel13[2]  = (write && (paddr13 == IRQ_EN_REG_2_ADDR13));
       intr_en_reg_sel13[3]  = (write && (paddr13 == IRQ_EN_REG_3_ADDR13));      
   end  //p_write_sel13
    

//    p_read_sel13: Process13 to enable the read operation13 to occur13.

   always @ (posedge pclk13 or negedge n_p_reset13)
   begin: p_read_sel13

      if (!n_p_reset13)                                   
      begin                                     
         prdata13 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr13)

               CLK_CTRL_REG_1_ADDR13 : prdata13 <= {25'h0000000,clk_ctrl_reg_113};
               CLK_CTRL_REG_2_ADDR13 : prdata13 <= {25'h0000000,clk_ctrl_reg_213};
               CLK_CTRL_REG_3_ADDR13 : prdata13 <= {25'h0000000,clk_ctrl_reg_313};
               CNTR_CTRL_REG_1_ADDR13: prdata13 <= {25'h0000000,cntr_ctrl_reg_113};
               CNTR_CTRL_REG_2_ADDR13: prdata13 <= {25'h0000000,cntr_ctrl_reg_213};
               CNTR_CTRL_REG_3_ADDR13: prdata13 <= {25'h0000000,cntr_ctrl_reg_313};
               CNTR_VAL_REG_1_ADDR13 : prdata13 <= {16'h0000,counter_val_reg_113};
               CNTR_VAL_REG_2_ADDR13 : prdata13 <= {16'h0000,counter_val_reg_213};
               CNTR_VAL_REG_3_ADDR13 : prdata13 <= {16'h0000,counter_val_reg_313};
               INTERVAL_REG_1_ADDR13 : prdata13 <= {16'h0000,interval_reg_113};
               INTERVAL_REG_2_ADDR13 : prdata13 <= {16'h0000,interval_reg_213};
               INTERVAL_REG_3_ADDR13 : prdata13 <= {16'h0000,interval_reg_313};
               MATCH_1_REG_1_ADDR13  : prdata13 <= {16'h0000,match_1_reg_113};
               MATCH_1_REG_2_ADDR13  : prdata13 <= {16'h0000,match_1_reg_213};
               MATCH_1_REG_3_ADDR13  : prdata13 <= {16'h0000,match_1_reg_313};
               MATCH_2_REG_1_ADDR13  : prdata13 <= {16'h0000,match_2_reg_113};
               MATCH_2_REG_2_ADDR13  : prdata13 <= {16'h0000,match_2_reg_213};
               MATCH_2_REG_3_ADDR13  : prdata13 <= {16'h0000,match_2_reg_313};
               MATCH_3_REG_1_ADDR13  : prdata13 <= {16'h0000,match_3_reg_113};
               MATCH_3_REG_2_ADDR13  : prdata13 <= {16'h0000,match_3_reg_213};
               MATCH_3_REG_3_ADDR13  : prdata13 <= {16'h0000,match_3_reg_313};
               IRQ_REG_1_ADDR13      : prdata13 <= {26'h0000,interrupt_reg_113};
               IRQ_REG_2_ADDR13      : prdata13 <= {26'h0000,interrupt_reg_213};
               IRQ_REG_3_ADDR13      : prdata13 <= {26'h0000,interrupt_reg_313};
               IRQ_EN_REG_1_ADDR13   : prdata13 <= {26'h0000,interrupt_en_reg_113};
               IRQ_EN_REG_2_ADDR13   : prdata13 <= {26'h0000,interrupt_en_reg_213};
               IRQ_EN_REG_3_ADDR13   : prdata13 <= {26'h0000,interrupt_en_reg_313};
               default             : prdata13 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata13 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset13)
      
   end // block: p_read_sel13

endmodule

