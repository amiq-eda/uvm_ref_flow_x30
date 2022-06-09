//File14 name   : ttc_interface_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : The APB14 interface with the triple14 timer14 counter
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module14 definition14
//----------------------------------------------------------------------------

module ttc_interface_lite14( 

  //inputs14
  n_p_reset14,    
  pclk14,                          
  psel14,
  penable14,
  pwrite14,
  paddr14,
  clk_ctrl_reg_114,
  clk_ctrl_reg_214,
  clk_ctrl_reg_314,
  cntr_ctrl_reg_114,
  cntr_ctrl_reg_214,
  cntr_ctrl_reg_314,
  counter_val_reg_114,
  counter_val_reg_214,
  counter_val_reg_314,
  interval_reg_114,
  match_1_reg_114,
  match_2_reg_114,
  match_3_reg_114,
  interval_reg_214,
  match_1_reg_214,
  match_2_reg_214,
  match_3_reg_214,
  interval_reg_314,
  match_1_reg_314,
  match_2_reg_314,
  match_3_reg_314,
  interrupt_reg_114,
  interrupt_reg_214,
  interrupt_reg_314,      
  interrupt_en_reg_114,
  interrupt_en_reg_214,
  interrupt_en_reg_314,
                  
  //outputs14
  prdata14,
  clk_ctrl_reg_sel_114,
  clk_ctrl_reg_sel_214,
  clk_ctrl_reg_sel_314,
  cntr_ctrl_reg_sel_114,
  cntr_ctrl_reg_sel_214,
  cntr_ctrl_reg_sel_314,
  interval_reg_sel_114,                            
  interval_reg_sel_214,                          
  interval_reg_sel_314,
  match_1_reg_sel_114,                          
  match_1_reg_sel_214,                          
  match_1_reg_sel_314,                
  match_2_reg_sel_114,                          
  match_2_reg_sel_214,
  match_2_reg_sel_314,
  match_3_reg_sel_114,                          
  match_3_reg_sel_214,                         
  match_3_reg_sel_314,
  intr_en_reg_sel14,
  clear_interrupt14        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS14
//----------------------------------------------------------------------------

   //inputs14
   input        n_p_reset14;              //reset signal14
   input        pclk14;                 //System14 Clock14
   input        psel14;                 //Select14 line
   input        penable14;              //Strobe14 line
   input        pwrite14;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr14;                //Address Bus14 register
   input [6:0]  clk_ctrl_reg_114;       //Clock14 Control14 reg for Timer_Counter14 1
   input [6:0]  cntr_ctrl_reg_114;      //Counter14 Control14 reg for Timer_Counter14 1
   input [6:0]  clk_ctrl_reg_214;       //Clock14 Control14 reg for Timer_Counter14 2
   input [6:0]  cntr_ctrl_reg_214;      //Counter14 Control14 reg for Timer14 Counter14 2
   input [6:0]  clk_ctrl_reg_314;       //Clock14 Control14 reg Timer_Counter14 3
   input [6:0]  cntr_ctrl_reg_314;      //Counter14 Control14 reg for Timer14 Counter14 3
   input [15:0] counter_val_reg_114;    //Counter14 Value from Timer_Counter14 1
   input [15:0] counter_val_reg_214;    //Counter14 Value from Timer_Counter14 2
   input [15:0] counter_val_reg_314;    //Counter14 Value from Timer_Counter14 3
   input [15:0] interval_reg_114;       //Interval14 reg value from Timer_Counter14 1
   input [15:0] match_1_reg_114;        //Match14 reg value from Timer_Counter14 
   input [15:0] match_2_reg_114;        //Match14 reg value from Timer_Counter14     
   input [15:0] match_3_reg_114;        //Match14 reg value from Timer_Counter14 
   input [15:0] interval_reg_214;       //Interval14 reg value from Timer_Counter14 2
   input [15:0] match_1_reg_214;        //Match14 reg value from Timer_Counter14     
   input [15:0] match_2_reg_214;        //Match14 reg value from Timer_Counter14     
   input [15:0] match_3_reg_214;        //Match14 reg value from Timer_Counter14 
   input [15:0] interval_reg_314;       //Interval14 reg value from Timer_Counter14 3
   input [15:0] match_1_reg_314;        //Match14 reg value from Timer_Counter14   
   input [15:0] match_2_reg_314;        //Match14 reg value from Timer_Counter14   
   input [15:0] match_3_reg_314;        //Match14 reg value from Timer_Counter14   
   input [5:0]  interrupt_reg_114;      //Interrupt14 Reg14 from Interrupt14 Module14 1
   input [5:0]  interrupt_reg_214;      //Interrupt14 Reg14 from Interrupt14 Module14 2
   input [5:0]  interrupt_reg_314;      //Interrupt14 Reg14 from Interrupt14 Module14 3
   input [5:0]  interrupt_en_reg_114;   //Interrupt14 Enable14 Reg14 from Intrpt14 Module14 1
   input [5:0]  interrupt_en_reg_214;   //Interrupt14 Enable14 Reg14 from Intrpt14 Module14 2
   input [5:0]  interrupt_en_reg_314;   //Interrupt14 Enable14 Reg14 from Intrpt14 Module14 3
   
   //outputs14
   output [31:0] prdata14;              //Read Data from the APB14 Interface14
   output clk_ctrl_reg_sel_114;         //Clock14 Control14 Reg14 Select14 TC_114 
   output clk_ctrl_reg_sel_214;         //Clock14 Control14 Reg14 Select14 TC_214 
   output clk_ctrl_reg_sel_314;         //Clock14 Control14 Reg14 Select14 TC_314 
   output cntr_ctrl_reg_sel_114;        //Counter14 Control14 Reg14 Select14 TC_114
   output cntr_ctrl_reg_sel_214;        //Counter14 Control14 Reg14 Select14 TC_214
   output cntr_ctrl_reg_sel_314;        //Counter14 Control14 Reg14 Select14 TC_314
   output interval_reg_sel_114;         //Interval14 Interrupt14 Reg14 Select14 TC_114 
   output interval_reg_sel_214;         //Interval14 Interrupt14 Reg14 Select14 TC_214 
   output interval_reg_sel_314;         //Interval14 Interrupt14 Reg14 Select14 TC_314 
   output match_1_reg_sel_114;          //Match14 Reg14 Select14 TC_114
   output match_1_reg_sel_214;          //Match14 Reg14 Select14 TC_214
   output match_1_reg_sel_314;          //Match14 Reg14 Select14 TC_314
   output match_2_reg_sel_114;          //Match14 Reg14 Select14 TC_114
   output match_2_reg_sel_214;          //Match14 Reg14 Select14 TC_214
   output match_2_reg_sel_314;          //Match14 Reg14 Select14 TC_314
   output match_3_reg_sel_114;          //Match14 Reg14 Select14 TC_114
   output match_3_reg_sel_214;          //Match14 Reg14 Select14 TC_214
   output match_3_reg_sel_314;          //Match14 Reg14 Select14 TC_314
   output [3:1] intr_en_reg_sel14;      //Interrupt14 Enable14 Reg14 Select14
   output [3:1] clear_interrupt14;      //Clear Interrupt14 line


//-----------------------------------------------------------------------------
// PARAMETER14 DECLARATIONS14
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR14   = 8'h00; //Clock14 control14 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR14   = 8'h04; //Clock14 control14 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR14   = 8'h08; //Clock14 control14 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR14  = 8'h0C; //Counter14 control14 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR14  = 8'h10; //Counter14 control14 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR14  = 8'h14; //Counter14 control14 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR14   = 8'h18; //Counter14 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR14   = 8'h1C; //Counter14 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR14   = 8'h20; //Counter14 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR14   = 8'h24; //Module14 1 interval14 address
   parameter   [7:0] INTERVAL_REG_2_ADDR14   = 8'h28; //Module14 2 interval14 address
   parameter   [7:0] INTERVAL_REG_3_ADDR14   = 8'h2C; //Module14 3 interval14 address
   parameter   [7:0] MATCH_1_REG_1_ADDR14    = 8'h30; //Module14 1 Match14 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR14    = 8'h34; //Module14 2 Match14 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR14    = 8'h38; //Module14 3 Match14 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR14    = 8'h3C; //Module14 1 Match14 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR14    = 8'h40; //Module14 2 Match14 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR14    = 8'h44; //Module14 3 Match14 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR14    = 8'h48; //Module14 1 Match14 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR14    = 8'h4C; //Module14 2 Match14 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR14    = 8'h50; //Module14 3 Match14 3 address
   parameter   [7:0] IRQ_REG_1_ADDR14        = 8'h54; //Interrupt14 register 1
   parameter   [7:0] IRQ_REG_2_ADDR14        = 8'h58; //Interrupt14 register 2
   parameter   [7:0] IRQ_REG_3_ADDR14        = 8'h5C; //Interrupt14 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR14     = 8'h60; //Interrupt14 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR14     = 8'h64; //Interrupt14 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR14     = 8'h68; //Interrupt14 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals14 & Registers14
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_114;         //Clock14 Control14 Reg14 Select14 TC_114
   reg clk_ctrl_reg_sel_214;         //Clock14 Control14 Reg14 Select14 TC_214 
   reg clk_ctrl_reg_sel_314;         //Clock14 Control14 Reg14 Select14 TC_314 
   reg cntr_ctrl_reg_sel_114;        //Counter14 Control14 Reg14 Select14 TC_114
   reg cntr_ctrl_reg_sel_214;        //Counter14 Control14 Reg14 Select14 TC_214
   reg cntr_ctrl_reg_sel_314;        //Counter14 Control14 Reg14 Select14 TC_314
   reg interval_reg_sel_114;         //Interval14 Interrupt14 Reg14 Select14 TC_114 
   reg interval_reg_sel_214;         //Interval14 Interrupt14 Reg14 Select14 TC_214
   reg interval_reg_sel_314;         //Interval14 Interrupt14 Reg14 Select14 TC_314
   reg match_1_reg_sel_114;          //Match14 Reg14 Select14 TC_114
   reg match_1_reg_sel_214;          //Match14 Reg14 Select14 TC_214
   reg match_1_reg_sel_314;          //Match14 Reg14 Select14 TC_314
   reg match_2_reg_sel_114;          //Match14 Reg14 Select14 TC_114
   reg match_2_reg_sel_214;          //Match14 Reg14 Select14 TC_214
   reg match_2_reg_sel_314;          //Match14 Reg14 Select14 TC_314
   reg match_3_reg_sel_114;          //Match14 Reg14 Select14 TC_114
   reg match_3_reg_sel_214;          //Match14 Reg14 Select14 TC_214
   reg match_3_reg_sel_314;          //Match14 Reg14 Select14 TC_314
   reg [3:1] intr_en_reg_sel14;      //Interrupt14 Enable14 1 Reg14 Select14
   reg [31:0] prdata14;              //APB14 read data
   
   wire [3:1] clear_interrupt14;     // 3-bit clear interrupt14 reg on read
   wire write;                     //APB14 write command  
   wire read;                      //APB14 read command    



   assign write = psel14 & penable14 & pwrite14;  
   assign read  = psel14 & ~pwrite14;  
   assign clear_interrupt14[1] = read & penable14 & (paddr14 == IRQ_REG_1_ADDR14);
   assign clear_interrupt14[2] = read & penable14 & (paddr14 == IRQ_REG_2_ADDR14);
   assign clear_interrupt14[3] = read & penable14 & (paddr14 == IRQ_REG_3_ADDR14);   
   
   //p_write_sel14: Process14 to select14 the required14 regs for write access.

   always @ (paddr14 or write)
   begin: p_write_sel14

       clk_ctrl_reg_sel_114  = (write && (paddr14 == CLK_CTRL_REG_1_ADDR14));
       clk_ctrl_reg_sel_214  = (write && (paddr14 == CLK_CTRL_REG_2_ADDR14));
       clk_ctrl_reg_sel_314  = (write && (paddr14 == CLK_CTRL_REG_3_ADDR14));
       cntr_ctrl_reg_sel_114 = (write && (paddr14 == CNTR_CTRL_REG_1_ADDR14));
       cntr_ctrl_reg_sel_214 = (write && (paddr14 == CNTR_CTRL_REG_2_ADDR14));
       cntr_ctrl_reg_sel_314 = (write && (paddr14 == CNTR_CTRL_REG_3_ADDR14));
       interval_reg_sel_114  = (write && (paddr14 == INTERVAL_REG_1_ADDR14));
       interval_reg_sel_214  = (write && (paddr14 == INTERVAL_REG_2_ADDR14));
       interval_reg_sel_314  = (write && (paddr14 == INTERVAL_REG_3_ADDR14));
       match_1_reg_sel_114   = (write && (paddr14 == MATCH_1_REG_1_ADDR14));
       match_1_reg_sel_214   = (write && (paddr14 == MATCH_1_REG_2_ADDR14));
       match_1_reg_sel_314   = (write && (paddr14 == MATCH_1_REG_3_ADDR14));
       match_2_reg_sel_114   = (write && (paddr14 == MATCH_2_REG_1_ADDR14));
       match_2_reg_sel_214   = (write && (paddr14 == MATCH_2_REG_2_ADDR14));
       match_2_reg_sel_314   = (write && (paddr14 == MATCH_2_REG_3_ADDR14));
       match_3_reg_sel_114   = (write && (paddr14 == MATCH_3_REG_1_ADDR14));
       match_3_reg_sel_214   = (write && (paddr14 == MATCH_3_REG_2_ADDR14));
       match_3_reg_sel_314   = (write && (paddr14 == MATCH_3_REG_3_ADDR14));
       intr_en_reg_sel14[1]  = (write && (paddr14 == IRQ_EN_REG_1_ADDR14));
       intr_en_reg_sel14[2]  = (write && (paddr14 == IRQ_EN_REG_2_ADDR14));
       intr_en_reg_sel14[3]  = (write && (paddr14 == IRQ_EN_REG_3_ADDR14));      
   end  //p_write_sel14
    

//    p_read_sel14: Process14 to enable the read operation14 to occur14.

   always @ (posedge pclk14 or negedge n_p_reset14)
   begin: p_read_sel14

      if (!n_p_reset14)                                   
      begin                                     
         prdata14 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr14)

               CLK_CTRL_REG_1_ADDR14 : prdata14 <= {25'h0000000,clk_ctrl_reg_114};
               CLK_CTRL_REG_2_ADDR14 : prdata14 <= {25'h0000000,clk_ctrl_reg_214};
               CLK_CTRL_REG_3_ADDR14 : prdata14 <= {25'h0000000,clk_ctrl_reg_314};
               CNTR_CTRL_REG_1_ADDR14: prdata14 <= {25'h0000000,cntr_ctrl_reg_114};
               CNTR_CTRL_REG_2_ADDR14: prdata14 <= {25'h0000000,cntr_ctrl_reg_214};
               CNTR_CTRL_REG_3_ADDR14: prdata14 <= {25'h0000000,cntr_ctrl_reg_314};
               CNTR_VAL_REG_1_ADDR14 : prdata14 <= {16'h0000,counter_val_reg_114};
               CNTR_VAL_REG_2_ADDR14 : prdata14 <= {16'h0000,counter_val_reg_214};
               CNTR_VAL_REG_3_ADDR14 : prdata14 <= {16'h0000,counter_val_reg_314};
               INTERVAL_REG_1_ADDR14 : prdata14 <= {16'h0000,interval_reg_114};
               INTERVAL_REG_2_ADDR14 : prdata14 <= {16'h0000,interval_reg_214};
               INTERVAL_REG_3_ADDR14 : prdata14 <= {16'h0000,interval_reg_314};
               MATCH_1_REG_1_ADDR14  : prdata14 <= {16'h0000,match_1_reg_114};
               MATCH_1_REG_2_ADDR14  : prdata14 <= {16'h0000,match_1_reg_214};
               MATCH_1_REG_3_ADDR14  : prdata14 <= {16'h0000,match_1_reg_314};
               MATCH_2_REG_1_ADDR14  : prdata14 <= {16'h0000,match_2_reg_114};
               MATCH_2_REG_2_ADDR14  : prdata14 <= {16'h0000,match_2_reg_214};
               MATCH_2_REG_3_ADDR14  : prdata14 <= {16'h0000,match_2_reg_314};
               MATCH_3_REG_1_ADDR14  : prdata14 <= {16'h0000,match_3_reg_114};
               MATCH_3_REG_2_ADDR14  : prdata14 <= {16'h0000,match_3_reg_214};
               MATCH_3_REG_3_ADDR14  : prdata14 <= {16'h0000,match_3_reg_314};
               IRQ_REG_1_ADDR14      : prdata14 <= {26'h0000,interrupt_reg_114};
               IRQ_REG_2_ADDR14      : prdata14 <= {26'h0000,interrupt_reg_214};
               IRQ_REG_3_ADDR14      : prdata14 <= {26'h0000,interrupt_reg_314};
               IRQ_EN_REG_1_ADDR14   : prdata14 <= {26'h0000,interrupt_en_reg_114};
               IRQ_EN_REG_2_ADDR14   : prdata14 <= {26'h0000,interrupt_en_reg_214};
               IRQ_EN_REG_3_ADDR14   : prdata14 <= {26'h0000,interrupt_en_reg_314};
               default             : prdata14 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata14 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset14)
      
   end // block: p_read_sel14

endmodule

