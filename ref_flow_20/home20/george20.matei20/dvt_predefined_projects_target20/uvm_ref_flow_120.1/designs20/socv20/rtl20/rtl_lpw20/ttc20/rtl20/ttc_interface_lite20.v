//File20 name   : ttc_interface_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : The APB20 interface with the triple20 timer20 counter
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module20 definition20
//----------------------------------------------------------------------------

module ttc_interface_lite20( 

  //inputs20
  n_p_reset20,    
  pclk20,                          
  psel20,
  penable20,
  pwrite20,
  paddr20,
  clk_ctrl_reg_120,
  clk_ctrl_reg_220,
  clk_ctrl_reg_320,
  cntr_ctrl_reg_120,
  cntr_ctrl_reg_220,
  cntr_ctrl_reg_320,
  counter_val_reg_120,
  counter_val_reg_220,
  counter_val_reg_320,
  interval_reg_120,
  match_1_reg_120,
  match_2_reg_120,
  match_3_reg_120,
  interval_reg_220,
  match_1_reg_220,
  match_2_reg_220,
  match_3_reg_220,
  interval_reg_320,
  match_1_reg_320,
  match_2_reg_320,
  match_3_reg_320,
  interrupt_reg_120,
  interrupt_reg_220,
  interrupt_reg_320,      
  interrupt_en_reg_120,
  interrupt_en_reg_220,
  interrupt_en_reg_320,
                  
  //outputs20
  prdata20,
  clk_ctrl_reg_sel_120,
  clk_ctrl_reg_sel_220,
  clk_ctrl_reg_sel_320,
  cntr_ctrl_reg_sel_120,
  cntr_ctrl_reg_sel_220,
  cntr_ctrl_reg_sel_320,
  interval_reg_sel_120,                            
  interval_reg_sel_220,                          
  interval_reg_sel_320,
  match_1_reg_sel_120,                          
  match_1_reg_sel_220,                          
  match_1_reg_sel_320,                
  match_2_reg_sel_120,                          
  match_2_reg_sel_220,
  match_2_reg_sel_320,
  match_3_reg_sel_120,                          
  match_3_reg_sel_220,                         
  match_3_reg_sel_320,
  intr_en_reg_sel20,
  clear_interrupt20        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS20
//----------------------------------------------------------------------------

   //inputs20
   input        n_p_reset20;              //reset signal20
   input        pclk20;                 //System20 Clock20
   input        psel20;                 //Select20 line
   input        penable20;              //Strobe20 line
   input        pwrite20;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr20;                //Address Bus20 register
   input [6:0]  clk_ctrl_reg_120;       //Clock20 Control20 reg for Timer_Counter20 1
   input [6:0]  cntr_ctrl_reg_120;      //Counter20 Control20 reg for Timer_Counter20 1
   input [6:0]  clk_ctrl_reg_220;       //Clock20 Control20 reg for Timer_Counter20 2
   input [6:0]  cntr_ctrl_reg_220;      //Counter20 Control20 reg for Timer20 Counter20 2
   input [6:0]  clk_ctrl_reg_320;       //Clock20 Control20 reg Timer_Counter20 3
   input [6:0]  cntr_ctrl_reg_320;      //Counter20 Control20 reg for Timer20 Counter20 3
   input [15:0] counter_val_reg_120;    //Counter20 Value from Timer_Counter20 1
   input [15:0] counter_val_reg_220;    //Counter20 Value from Timer_Counter20 2
   input [15:0] counter_val_reg_320;    //Counter20 Value from Timer_Counter20 3
   input [15:0] interval_reg_120;       //Interval20 reg value from Timer_Counter20 1
   input [15:0] match_1_reg_120;        //Match20 reg value from Timer_Counter20 
   input [15:0] match_2_reg_120;        //Match20 reg value from Timer_Counter20     
   input [15:0] match_3_reg_120;        //Match20 reg value from Timer_Counter20 
   input [15:0] interval_reg_220;       //Interval20 reg value from Timer_Counter20 2
   input [15:0] match_1_reg_220;        //Match20 reg value from Timer_Counter20     
   input [15:0] match_2_reg_220;        //Match20 reg value from Timer_Counter20     
   input [15:0] match_3_reg_220;        //Match20 reg value from Timer_Counter20 
   input [15:0] interval_reg_320;       //Interval20 reg value from Timer_Counter20 3
   input [15:0] match_1_reg_320;        //Match20 reg value from Timer_Counter20   
   input [15:0] match_2_reg_320;        //Match20 reg value from Timer_Counter20   
   input [15:0] match_3_reg_320;        //Match20 reg value from Timer_Counter20   
   input [5:0]  interrupt_reg_120;      //Interrupt20 Reg20 from Interrupt20 Module20 1
   input [5:0]  interrupt_reg_220;      //Interrupt20 Reg20 from Interrupt20 Module20 2
   input [5:0]  interrupt_reg_320;      //Interrupt20 Reg20 from Interrupt20 Module20 3
   input [5:0]  interrupt_en_reg_120;   //Interrupt20 Enable20 Reg20 from Intrpt20 Module20 1
   input [5:0]  interrupt_en_reg_220;   //Interrupt20 Enable20 Reg20 from Intrpt20 Module20 2
   input [5:0]  interrupt_en_reg_320;   //Interrupt20 Enable20 Reg20 from Intrpt20 Module20 3
   
   //outputs20
   output [31:0] prdata20;              //Read Data from the APB20 Interface20
   output clk_ctrl_reg_sel_120;         //Clock20 Control20 Reg20 Select20 TC_120 
   output clk_ctrl_reg_sel_220;         //Clock20 Control20 Reg20 Select20 TC_220 
   output clk_ctrl_reg_sel_320;         //Clock20 Control20 Reg20 Select20 TC_320 
   output cntr_ctrl_reg_sel_120;        //Counter20 Control20 Reg20 Select20 TC_120
   output cntr_ctrl_reg_sel_220;        //Counter20 Control20 Reg20 Select20 TC_220
   output cntr_ctrl_reg_sel_320;        //Counter20 Control20 Reg20 Select20 TC_320
   output interval_reg_sel_120;         //Interval20 Interrupt20 Reg20 Select20 TC_120 
   output interval_reg_sel_220;         //Interval20 Interrupt20 Reg20 Select20 TC_220 
   output interval_reg_sel_320;         //Interval20 Interrupt20 Reg20 Select20 TC_320 
   output match_1_reg_sel_120;          //Match20 Reg20 Select20 TC_120
   output match_1_reg_sel_220;          //Match20 Reg20 Select20 TC_220
   output match_1_reg_sel_320;          //Match20 Reg20 Select20 TC_320
   output match_2_reg_sel_120;          //Match20 Reg20 Select20 TC_120
   output match_2_reg_sel_220;          //Match20 Reg20 Select20 TC_220
   output match_2_reg_sel_320;          //Match20 Reg20 Select20 TC_320
   output match_3_reg_sel_120;          //Match20 Reg20 Select20 TC_120
   output match_3_reg_sel_220;          //Match20 Reg20 Select20 TC_220
   output match_3_reg_sel_320;          //Match20 Reg20 Select20 TC_320
   output [3:1] intr_en_reg_sel20;      //Interrupt20 Enable20 Reg20 Select20
   output [3:1] clear_interrupt20;      //Clear Interrupt20 line


//-----------------------------------------------------------------------------
// PARAMETER20 DECLARATIONS20
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR20   = 8'h00; //Clock20 control20 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR20   = 8'h04; //Clock20 control20 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR20   = 8'h08; //Clock20 control20 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR20  = 8'h0C; //Counter20 control20 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR20  = 8'h10; //Counter20 control20 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR20  = 8'h14; //Counter20 control20 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR20   = 8'h18; //Counter20 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR20   = 8'h1C; //Counter20 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR20   = 8'h20; //Counter20 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR20   = 8'h24; //Module20 1 interval20 address
   parameter   [7:0] INTERVAL_REG_2_ADDR20   = 8'h28; //Module20 2 interval20 address
   parameter   [7:0] INTERVAL_REG_3_ADDR20   = 8'h2C; //Module20 3 interval20 address
   parameter   [7:0] MATCH_1_REG_1_ADDR20    = 8'h30; //Module20 1 Match20 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR20    = 8'h34; //Module20 2 Match20 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR20    = 8'h38; //Module20 3 Match20 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR20    = 8'h3C; //Module20 1 Match20 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR20    = 8'h40; //Module20 2 Match20 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR20    = 8'h44; //Module20 3 Match20 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR20    = 8'h48; //Module20 1 Match20 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR20    = 8'h4C; //Module20 2 Match20 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR20    = 8'h50; //Module20 3 Match20 3 address
   parameter   [7:0] IRQ_REG_1_ADDR20        = 8'h54; //Interrupt20 register 1
   parameter   [7:0] IRQ_REG_2_ADDR20        = 8'h58; //Interrupt20 register 2
   parameter   [7:0] IRQ_REG_3_ADDR20        = 8'h5C; //Interrupt20 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR20     = 8'h60; //Interrupt20 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR20     = 8'h64; //Interrupt20 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR20     = 8'h68; //Interrupt20 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals20 & Registers20
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_120;         //Clock20 Control20 Reg20 Select20 TC_120
   reg clk_ctrl_reg_sel_220;         //Clock20 Control20 Reg20 Select20 TC_220 
   reg clk_ctrl_reg_sel_320;         //Clock20 Control20 Reg20 Select20 TC_320 
   reg cntr_ctrl_reg_sel_120;        //Counter20 Control20 Reg20 Select20 TC_120
   reg cntr_ctrl_reg_sel_220;        //Counter20 Control20 Reg20 Select20 TC_220
   reg cntr_ctrl_reg_sel_320;        //Counter20 Control20 Reg20 Select20 TC_320
   reg interval_reg_sel_120;         //Interval20 Interrupt20 Reg20 Select20 TC_120 
   reg interval_reg_sel_220;         //Interval20 Interrupt20 Reg20 Select20 TC_220
   reg interval_reg_sel_320;         //Interval20 Interrupt20 Reg20 Select20 TC_320
   reg match_1_reg_sel_120;          //Match20 Reg20 Select20 TC_120
   reg match_1_reg_sel_220;          //Match20 Reg20 Select20 TC_220
   reg match_1_reg_sel_320;          //Match20 Reg20 Select20 TC_320
   reg match_2_reg_sel_120;          //Match20 Reg20 Select20 TC_120
   reg match_2_reg_sel_220;          //Match20 Reg20 Select20 TC_220
   reg match_2_reg_sel_320;          //Match20 Reg20 Select20 TC_320
   reg match_3_reg_sel_120;          //Match20 Reg20 Select20 TC_120
   reg match_3_reg_sel_220;          //Match20 Reg20 Select20 TC_220
   reg match_3_reg_sel_320;          //Match20 Reg20 Select20 TC_320
   reg [3:1] intr_en_reg_sel20;      //Interrupt20 Enable20 1 Reg20 Select20
   reg [31:0] prdata20;              //APB20 read data
   
   wire [3:1] clear_interrupt20;     // 3-bit clear interrupt20 reg on read
   wire write;                     //APB20 write command  
   wire read;                      //APB20 read command    



   assign write = psel20 & penable20 & pwrite20;  
   assign read  = psel20 & ~pwrite20;  
   assign clear_interrupt20[1] = read & penable20 & (paddr20 == IRQ_REG_1_ADDR20);
   assign clear_interrupt20[2] = read & penable20 & (paddr20 == IRQ_REG_2_ADDR20);
   assign clear_interrupt20[3] = read & penable20 & (paddr20 == IRQ_REG_3_ADDR20);   
   
   //p_write_sel20: Process20 to select20 the required20 regs for write access.

   always @ (paddr20 or write)
   begin: p_write_sel20

       clk_ctrl_reg_sel_120  = (write && (paddr20 == CLK_CTRL_REG_1_ADDR20));
       clk_ctrl_reg_sel_220  = (write && (paddr20 == CLK_CTRL_REG_2_ADDR20));
       clk_ctrl_reg_sel_320  = (write && (paddr20 == CLK_CTRL_REG_3_ADDR20));
       cntr_ctrl_reg_sel_120 = (write && (paddr20 == CNTR_CTRL_REG_1_ADDR20));
       cntr_ctrl_reg_sel_220 = (write && (paddr20 == CNTR_CTRL_REG_2_ADDR20));
       cntr_ctrl_reg_sel_320 = (write && (paddr20 == CNTR_CTRL_REG_3_ADDR20));
       interval_reg_sel_120  = (write && (paddr20 == INTERVAL_REG_1_ADDR20));
       interval_reg_sel_220  = (write && (paddr20 == INTERVAL_REG_2_ADDR20));
       interval_reg_sel_320  = (write && (paddr20 == INTERVAL_REG_3_ADDR20));
       match_1_reg_sel_120   = (write && (paddr20 == MATCH_1_REG_1_ADDR20));
       match_1_reg_sel_220   = (write && (paddr20 == MATCH_1_REG_2_ADDR20));
       match_1_reg_sel_320   = (write && (paddr20 == MATCH_1_REG_3_ADDR20));
       match_2_reg_sel_120   = (write && (paddr20 == MATCH_2_REG_1_ADDR20));
       match_2_reg_sel_220   = (write && (paddr20 == MATCH_2_REG_2_ADDR20));
       match_2_reg_sel_320   = (write && (paddr20 == MATCH_2_REG_3_ADDR20));
       match_3_reg_sel_120   = (write && (paddr20 == MATCH_3_REG_1_ADDR20));
       match_3_reg_sel_220   = (write && (paddr20 == MATCH_3_REG_2_ADDR20));
       match_3_reg_sel_320   = (write && (paddr20 == MATCH_3_REG_3_ADDR20));
       intr_en_reg_sel20[1]  = (write && (paddr20 == IRQ_EN_REG_1_ADDR20));
       intr_en_reg_sel20[2]  = (write && (paddr20 == IRQ_EN_REG_2_ADDR20));
       intr_en_reg_sel20[3]  = (write && (paddr20 == IRQ_EN_REG_3_ADDR20));      
   end  //p_write_sel20
    

//    p_read_sel20: Process20 to enable the read operation20 to occur20.

   always @ (posedge pclk20 or negedge n_p_reset20)
   begin: p_read_sel20

      if (!n_p_reset20)                                   
      begin                                     
         prdata20 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr20)

               CLK_CTRL_REG_1_ADDR20 : prdata20 <= {25'h0000000,clk_ctrl_reg_120};
               CLK_CTRL_REG_2_ADDR20 : prdata20 <= {25'h0000000,clk_ctrl_reg_220};
               CLK_CTRL_REG_3_ADDR20 : prdata20 <= {25'h0000000,clk_ctrl_reg_320};
               CNTR_CTRL_REG_1_ADDR20: prdata20 <= {25'h0000000,cntr_ctrl_reg_120};
               CNTR_CTRL_REG_2_ADDR20: prdata20 <= {25'h0000000,cntr_ctrl_reg_220};
               CNTR_CTRL_REG_3_ADDR20: prdata20 <= {25'h0000000,cntr_ctrl_reg_320};
               CNTR_VAL_REG_1_ADDR20 : prdata20 <= {16'h0000,counter_val_reg_120};
               CNTR_VAL_REG_2_ADDR20 : prdata20 <= {16'h0000,counter_val_reg_220};
               CNTR_VAL_REG_3_ADDR20 : prdata20 <= {16'h0000,counter_val_reg_320};
               INTERVAL_REG_1_ADDR20 : prdata20 <= {16'h0000,interval_reg_120};
               INTERVAL_REG_2_ADDR20 : prdata20 <= {16'h0000,interval_reg_220};
               INTERVAL_REG_3_ADDR20 : prdata20 <= {16'h0000,interval_reg_320};
               MATCH_1_REG_1_ADDR20  : prdata20 <= {16'h0000,match_1_reg_120};
               MATCH_1_REG_2_ADDR20  : prdata20 <= {16'h0000,match_1_reg_220};
               MATCH_1_REG_3_ADDR20  : prdata20 <= {16'h0000,match_1_reg_320};
               MATCH_2_REG_1_ADDR20  : prdata20 <= {16'h0000,match_2_reg_120};
               MATCH_2_REG_2_ADDR20  : prdata20 <= {16'h0000,match_2_reg_220};
               MATCH_2_REG_3_ADDR20  : prdata20 <= {16'h0000,match_2_reg_320};
               MATCH_3_REG_1_ADDR20  : prdata20 <= {16'h0000,match_3_reg_120};
               MATCH_3_REG_2_ADDR20  : prdata20 <= {16'h0000,match_3_reg_220};
               MATCH_3_REG_3_ADDR20  : prdata20 <= {16'h0000,match_3_reg_320};
               IRQ_REG_1_ADDR20      : prdata20 <= {26'h0000,interrupt_reg_120};
               IRQ_REG_2_ADDR20      : prdata20 <= {26'h0000,interrupt_reg_220};
               IRQ_REG_3_ADDR20      : prdata20 <= {26'h0000,interrupt_reg_320};
               IRQ_EN_REG_1_ADDR20   : prdata20 <= {26'h0000,interrupt_en_reg_120};
               IRQ_EN_REG_2_ADDR20   : prdata20 <= {26'h0000,interrupt_en_reg_220};
               IRQ_EN_REG_3_ADDR20   : prdata20 <= {26'h0000,interrupt_en_reg_320};
               default             : prdata20 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata20 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset20)
      
   end // block: p_read_sel20

endmodule

