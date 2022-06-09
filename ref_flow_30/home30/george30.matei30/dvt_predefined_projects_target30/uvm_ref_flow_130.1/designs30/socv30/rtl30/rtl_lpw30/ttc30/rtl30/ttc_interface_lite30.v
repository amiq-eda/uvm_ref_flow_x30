//File30 name   : ttc_interface_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : The APB30 interface with the triple30 timer30 counter
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module30 definition30
//----------------------------------------------------------------------------

module ttc_interface_lite30( 

  //inputs30
  n_p_reset30,    
  pclk30,                          
  psel30,
  penable30,
  pwrite30,
  paddr30,
  clk_ctrl_reg_130,
  clk_ctrl_reg_230,
  clk_ctrl_reg_330,
  cntr_ctrl_reg_130,
  cntr_ctrl_reg_230,
  cntr_ctrl_reg_330,
  counter_val_reg_130,
  counter_val_reg_230,
  counter_val_reg_330,
  interval_reg_130,
  match_1_reg_130,
  match_2_reg_130,
  match_3_reg_130,
  interval_reg_230,
  match_1_reg_230,
  match_2_reg_230,
  match_3_reg_230,
  interval_reg_330,
  match_1_reg_330,
  match_2_reg_330,
  match_3_reg_330,
  interrupt_reg_130,
  interrupt_reg_230,
  interrupt_reg_330,      
  interrupt_en_reg_130,
  interrupt_en_reg_230,
  interrupt_en_reg_330,
                  
  //outputs30
  prdata30,
  clk_ctrl_reg_sel_130,
  clk_ctrl_reg_sel_230,
  clk_ctrl_reg_sel_330,
  cntr_ctrl_reg_sel_130,
  cntr_ctrl_reg_sel_230,
  cntr_ctrl_reg_sel_330,
  interval_reg_sel_130,                            
  interval_reg_sel_230,                          
  interval_reg_sel_330,
  match_1_reg_sel_130,                          
  match_1_reg_sel_230,                          
  match_1_reg_sel_330,                
  match_2_reg_sel_130,                          
  match_2_reg_sel_230,
  match_2_reg_sel_330,
  match_3_reg_sel_130,                          
  match_3_reg_sel_230,                         
  match_3_reg_sel_330,
  intr_en_reg_sel30,
  clear_interrupt30        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS30
//----------------------------------------------------------------------------

   //inputs30
   input        n_p_reset30;              //reset signal30
   input        pclk30;                 //System30 Clock30
   input        psel30;                 //Select30 line
   input        penable30;              //Strobe30 line
   input        pwrite30;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr30;                //Address Bus30 register
   input [6:0]  clk_ctrl_reg_130;       //Clock30 Control30 reg for Timer_Counter30 1
   input [6:0]  cntr_ctrl_reg_130;      //Counter30 Control30 reg for Timer_Counter30 1
   input [6:0]  clk_ctrl_reg_230;       //Clock30 Control30 reg for Timer_Counter30 2
   input [6:0]  cntr_ctrl_reg_230;      //Counter30 Control30 reg for Timer30 Counter30 2
   input [6:0]  clk_ctrl_reg_330;       //Clock30 Control30 reg Timer_Counter30 3
   input [6:0]  cntr_ctrl_reg_330;      //Counter30 Control30 reg for Timer30 Counter30 3
   input [15:0] counter_val_reg_130;    //Counter30 Value from Timer_Counter30 1
   input [15:0] counter_val_reg_230;    //Counter30 Value from Timer_Counter30 2
   input [15:0] counter_val_reg_330;    //Counter30 Value from Timer_Counter30 3
   input [15:0] interval_reg_130;       //Interval30 reg value from Timer_Counter30 1
   input [15:0] match_1_reg_130;        //Match30 reg value from Timer_Counter30 
   input [15:0] match_2_reg_130;        //Match30 reg value from Timer_Counter30     
   input [15:0] match_3_reg_130;        //Match30 reg value from Timer_Counter30 
   input [15:0] interval_reg_230;       //Interval30 reg value from Timer_Counter30 2
   input [15:0] match_1_reg_230;        //Match30 reg value from Timer_Counter30     
   input [15:0] match_2_reg_230;        //Match30 reg value from Timer_Counter30     
   input [15:0] match_3_reg_230;        //Match30 reg value from Timer_Counter30 
   input [15:0] interval_reg_330;       //Interval30 reg value from Timer_Counter30 3
   input [15:0] match_1_reg_330;        //Match30 reg value from Timer_Counter30   
   input [15:0] match_2_reg_330;        //Match30 reg value from Timer_Counter30   
   input [15:0] match_3_reg_330;        //Match30 reg value from Timer_Counter30   
   input [5:0]  interrupt_reg_130;      //Interrupt30 Reg30 from Interrupt30 Module30 1
   input [5:0]  interrupt_reg_230;      //Interrupt30 Reg30 from Interrupt30 Module30 2
   input [5:0]  interrupt_reg_330;      //Interrupt30 Reg30 from Interrupt30 Module30 3
   input [5:0]  interrupt_en_reg_130;   //Interrupt30 Enable30 Reg30 from Intrpt30 Module30 1
   input [5:0]  interrupt_en_reg_230;   //Interrupt30 Enable30 Reg30 from Intrpt30 Module30 2
   input [5:0]  interrupt_en_reg_330;   //Interrupt30 Enable30 Reg30 from Intrpt30 Module30 3
   
   //outputs30
   output [31:0] prdata30;              //Read Data from the APB30 Interface30
   output clk_ctrl_reg_sel_130;         //Clock30 Control30 Reg30 Select30 TC_130 
   output clk_ctrl_reg_sel_230;         //Clock30 Control30 Reg30 Select30 TC_230 
   output clk_ctrl_reg_sel_330;         //Clock30 Control30 Reg30 Select30 TC_330 
   output cntr_ctrl_reg_sel_130;        //Counter30 Control30 Reg30 Select30 TC_130
   output cntr_ctrl_reg_sel_230;        //Counter30 Control30 Reg30 Select30 TC_230
   output cntr_ctrl_reg_sel_330;        //Counter30 Control30 Reg30 Select30 TC_330
   output interval_reg_sel_130;         //Interval30 Interrupt30 Reg30 Select30 TC_130 
   output interval_reg_sel_230;         //Interval30 Interrupt30 Reg30 Select30 TC_230 
   output interval_reg_sel_330;         //Interval30 Interrupt30 Reg30 Select30 TC_330 
   output match_1_reg_sel_130;          //Match30 Reg30 Select30 TC_130
   output match_1_reg_sel_230;          //Match30 Reg30 Select30 TC_230
   output match_1_reg_sel_330;          //Match30 Reg30 Select30 TC_330
   output match_2_reg_sel_130;          //Match30 Reg30 Select30 TC_130
   output match_2_reg_sel_230;          //Match30 Reg30 Select30 TC_230
   output match_2_reg_sel_330;          //Match30 Reg30 Select30 TC_330
   output match_3_reg_sel_130;          //Match30 Reg30 Select30 TC_130
   output match_3_reg_sel_230;          //Match30 Reg30 Select30 TC_230
   output match_3_reg_sel_330;          //Match30 Reg30 Select30 TC_330
   output [3:1] intr_en_reg_sel30;      //Interrupt30 Enable30 Reg30 Select30
   output [3:1] clear_interrupt30;      //Clear Interrupt30 line


//-----------------------------------------------------------------------------
// PARAMETER30 DECLARATIONS30
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR30   = 8'h00; //Clock30 control30 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR30   = 8'h04; //Clock30 control30 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR30   = 8'h08; //Clock30 control30 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR30  = 8'h0C; //Counter30 control30 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR30  = 8'h10; //Counter30 control30 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR30  = 8'h14; //Counter30 control30 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR30   = 8'h18; //Counter30 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR30   = 8'h1C; //Counter30 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR30   = 8'h20; //Counter30 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR30   = 8'h24; //Module30 1 interval30 address
   parameter   [7:0] INTERVAL_REG_2_ADDR30   = 8'h28; //Module30 2 interval30 address
   parameter   [7:0] INTERVAL_REG_3_ADDR30   = 8'h2C; //Module30 3 interval30 address
   parameter   [7:0] MATCH_1_REG_1_ADDR30    = 8'h30; //Module30 1 Match30 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR30    = 8'h34; //Module30 2 Match30 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR30    = 8'h38; //Module30 3 Match30 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR30    = 8'h3C; //Module30 1 Match30 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR30    = 8'h40; //Module30 2 Match30 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR30    = 8'h44; //Module30 3 Match30 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR30    = 8'h48; //Module30 1 Match30 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR30    = 8'h4C; //Module30 2 Match30 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR30    = 8'h50; //Module30 3 Match30 3 address
   parameter   [7:0] IRQ_REG_1_ADDR30        = 8'h54; //Interrupt30 register 1
   parameter   [7:0] IRQ_REG_2_ADDR30        = 8'h58; //Interrupt30 register 2
   parameter   [7:0] IRQ_REG_3_ADDR30        = 8'h5C; //Interrupt30 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR30     = 8'h60; //Interrupt30 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR30     = 8'h64; //Interrupt30 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR30     = 8'h68; //Interrupt30 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals30 & Registers30
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_130;         //Clock30 Control30 Reg30 Select30 TC_130
   reg clk_ctrl_reg_sel_230;         //Clock30 Control30 Reg30 Select30 TC_230 
   reg clk_ctrl_reg_sel_330;         //Clock30 Control30 Reg30 Select30 TC_330 
   reg cntr_ctrl_reg_sel_130;        //Counter30 Control30 Reg30 Select30 TC_130
   reg cntr_ctrl_reg_sel_230;        //Counter30 Control30 Reg30 Select30 TC_230
   reg cntr_ctrl_reg_sel_330;        //Counter30 Control30 Reg30 Select30 TC_330
   reg interval_reg_sel_130;         //Interval30 Interrupt30 Reg30 Select30 TC_130 
   reg interval_reg_sel_230;         //Interval30 Interrupt30 Reg30 Select30 TC_230
   reg interval_reg_sel_330;         //Interval30 Interrupt30 Reg30 Select30 TC_330
   reg match_1_reg_sel_130;          //Match30 Reg30 Select30 TC_130
   reg match_1_reg_sel_230;          //Match30 Reg30 Select30 TC_230
   reg match_1_reg_sel_330;          //Match30 Reg30 Select30 TC_330
   reg match_2_reg_sel_130;          //Match30 Reg30 Select30 TC_130
   reg match_2_reg_sel_230;          //Match30 Reg30 Select30 TC_230
   reg match_2_reg_sel_330;          //Match30 Reg30 Select30 TC_330
   reg match_3_reg_sel_130;          //Match30 Reg30 Select30 TC_130
   reg match_3_reg_sel_230;          //Match30 Reg30 Select30 TC_230
   reg match_3_reg_sel_330;          //Match30 Reg30 Select30 TC_330
   reg [3:1] intr_en_reg_sel30;      //Interrupt30 Enable30 1 Reg30 Select30
   reg [31:0] prdata30;              //APB30 read data
   
   wire [3:1] clear_interrupt30;     // 3-bit clear interrupt30 reg on read
   wire write;                     //APB30 write command  
   wire read;                      //APB30 read command    



   assign write = psel30 & penable30 & pwrite30;  
   assign read  = psel30 & ~pwrite30;  
   assign clear_interrupt30[1] = read & penable30 & (paddr30 == IRQ_REG_1_ADDR30);
   assign clear_interrupt30[2] = read & penable30 & (paddr30 == IRQ_REG_2_ADDR30);
   assign clear_interrupt30[3] = read & penable30 & (paddr30 == IRQ_REG_3_ADDR30);   
   
   //p_write_sel30: Process30 to select30 the required30 regs for write access.

   always @ (paddr30 or write)
   begin: p_write_sel30

       clk_ctrl_reg_sel_130  = (write && (paddr30 == CLK_CTRL_REG_1_ADDR30));
       clk_ctrl_reg_sel_230  = (write && (paddr30 == CLK_CTRL_REG_2_ADDR30));
       clk_ctrl_reg_sel_330  = (write && (paddr30 == CLK_CTRL_REG_3_ADDR30));
       cntr_ctrl_reg_sel_130 = (write && (paddr30 == CNTR_CTRL_REG_1_ADDR30));
       cntr_ctrl_reg_sel_230 = (write && (paddr30 == CNTR_CTRL_REG_2_ADDR30));
       cntr_ctrl_reg_sel_330 = (write && (paddr30 == CNTR_CTRL_REG_3_ADDR30));
       interval_reg_sel_130  = (write && (paddr30 == INTERVAL_REG_1_ADDR30));
       interval_reg_sel_230  = (write && (paddr30 == INTERVAL_REG_2_ADDR30));
       interval_reg_sel_330  = (write && (paddr30 == INTERVAL_REG_3_ADDR30));
       match_1_reg_sel_130   = (write && (paddr30 == MATCH_1_REG_1_ADDR30));
       match_1_reg_sel_230   = (write && (paddr30 == MATCH_1_REG_2_ADDR30));
       match_1_reg_sel_330   = (write && (paddr30 == MATCH_1_REG_3_ADDR30));
       match_2_reg_sel_130   = (write && (paddr30 == MATCH_2_REG_1_ADDR30));
       match_2_reg_sel_230   = (write && (paddr30 == MATCH_2_REG_2_ADDR30));
       match_2_reg_sel_330   = (write && (paddr30 == MATCH_2_REG_3_ADDR30));
       match_3_reg_sel_130   = (write && (paddr30 == MATCH_3_REG_1_ADDR30));
       match_3_reg_sel_230   = (write && (paddr30 == MATCH_3_REG_2_ADDR30));
       match_3_reg_sel_330   = (write && (paddr30 == MATCH_3_REG_3_ADDR30));
       intr_en_reg_sel30[1]  = (write && (paddr30 == IRQ_EN_REG_1_ADDR30));
       intr_en_reg_sel30[2]  = (write && (paddr30 == IRQ_EN_REG_2_ADDR30));
       intr_en_reg_sel30[3]  = (write && (paddr30 == IRQ_EN_REG_3_ADDR30));      
   end  //p_write_sel30
    

//    p_read_sel30: Process30 to enable the read operation30 to occur30.

   always @ (posedge pclk30 or negedge n_p_reset30)
   begin: p_read_sel30

      if (!n_p_reset30)                                   
      begin                                     
         prdata30 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr30)

               CLK_CTRL_REG_1_ADDR30 : prdata30 <= {25'h0000000,clk_ctrl_reg_130};
               CLK_CTRL_REG_2_ADDR30 : prdata30 <= {25'h0000000,clk_ctrl_reg_230};
               CLK_CTRL_REG_3_ADDR30 : prdata30 <= {25'h0000000,clk_ctrl_reg_330};
               CNTR_CTRL_REG_1_ADDR30: prdata30 <= {25'h0000000,cntr_ctrl_reg_130};
               CNTR_CTRL_REG_2_ADDR30: prdata30 <= {25'h0000000,cntr_ctrl_reg_230};
               CNTR_CTRL_REG_3_ADDR30: prdata30 <= {25'h0000000,cntr_ctrl_reg_330};
               CNTR_VAL_REG_1_ADDR30 : prdata30 <= {16'h0000,counter_val_reg_130};
               CNTR_VAL_REG_2_ADDR30 : prdata30 <= {16'h0000,counter_val_reg_230};
               CNTR_VAL_REG_3_ADDR30 : prdata30 <= {16'h0000,counter_val_reg_330};
               INTERVAL_REG_1_ADDR30 : prdata30 <= {16'h0000,interval_reg_130};
               INTERVAL_REG_2_ADDR30 : prdata30 <= {16'h0000,interval_reg_230};
               INTERVAL_REG_3_ADDR30 : prdata30 <= {16'h0000,interval_reg_330};
               MATCH_1_REG_1_ADDR30  : prdata30 <= {16'h0000,match_1_reg_130};
               MATCH_1_REG_2_ADDR30  : prdata30 <= {16'h0000,match_1_reg_230};
               MATCH_1_REG_3_ADDR30  : prdata30 <= {16'h0000,match_1_reg_330};
               MATCH_2_REG_1_ADDR30  : prdata30 <= {16'h0000,match_2_reg_130};
               MATCH_2_REG_2_ADDR30  : prdata30 <= {16'h0000,match_2_reg_230};
               MATCH_2_REG_3_ADDR30  : prdata30 <= {16'h0000,match_2_reg_330};
               MATCH_3_REG_1_ADDR30  : prdata30 <= {16'h0000,match_3_reg_130};
               MATCH_3_REG_2_ADDR30  : prdata30 <= {16'h0000,match_3_reg_230};
               MATCH_3_REG_3_ADDR30  : prdata30 <= {16'h0000,match_3_reg_330};
               IRQ_REG_1_ADDR30      : prdata30 <= {26'h0000,interrupt_reg_130};
               IRQ_REG_2_ADDR30      : prdata30 <= {26'h0000,interrupt_reg_230};
               IRQ_REG_3_ADDR30      : prdata30 <= {26'h0000,interrupt_reg_330};
               IRQ_EN_REG_1_ADDR30   : prdata30 <= {26'h0000,interrupt_en_reg_130};
               IRQ_EN_REG_2_ADDR30   : prdata30 <= {26'h0000,interrupt_en_reg_230};
               IRQ_EN_REG_3_ADDR30   : prdata30 <= {26'h0000,interrupt_en_reg_330};
               default             : prdata30 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata30 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset30)
      
   end // block: p_read_sel30

endmodule

