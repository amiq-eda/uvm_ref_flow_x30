//File29 name   : ttc_interface_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : The APB29 interface with the triple29 timer29 counter
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module29 definition29
//----------------------------------------------------------------------------

module ttc_interface_lite29( 

  //inputs29
  n_p_reset29,    
  pclk29,                          
  psel29,
  penable29,
  pwrite29,
  paddr29,
  clk_ctrl_reg_129,
  clk_ctrl_reg_229,
  clk_ctrl_reg_329,
  cntr_ctrl_reg_129,
  cntr_ctrl_reg_229,
  cntr_ctrl_reg_329,
  counter_val_reg_129,
  counter_val_reg_229,
  counter_val_reg_329,
  interval_reg_129,
  match_1_reg_129,
  match_2_reg_129,
  match_3_reg_129,
  interval_reg_229,
  match_1_reg_229,
  match_2_reg_229,
  match_3_reg_229,
  interval_reg_329,
  match_1_reg_329,
  match_2_reg_329,
  match_3_reg_329,
  interrupt_reg_129,
  interrupt_reg_229,
  interrupt_reg_329,      
  interrupt_en_reg_129,
  interrupt_en_reg_229,
  interrupt_en_reg_329,
                  
  //outputs29
  prdata29,
  clk_ctrl_reg_sel_129,
  clk_ctrl_reg_sel_229,
  clk_ctrl_reg_sel_329,
  cntr_ctrl_reg_sel_129,
  cntr_ctrl_reg_sel_229,
  cntr_ctrl_reg_sel_329,
  interval_reg_sel_129,                            
  interval_reg_sel_229,                          
  interval_reg_sel_329,
  match_1_reg_sel_129,                          
  match_1_reg_sel_229,                          
  match_1_reg_sel_329,                
  match_2_reg_sel_129,                          
  match_2_reg_sel_229,
  match_2_reg_sel_329,
  match_3_reg_sel_129,                          
  match_3_reg_sel_229,                         
  match_3_reg_sel_329,
  intr_en_reg_sel29,
  clear_interrupt29        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS29
//----------------------------------------------------------------------------

   //inputs29
   input        n_p_reset29;              //reset signal29
   input        pclk29;                 //System29 Clock29
   input        psel29;                 //Select29 line
   input        penable29;              //Strobe29 line
   input        pwrite29;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr29;                //Address Bus29 register
   input [6:0]  clk_ctrl_reg_129;       //Clock29 Control29 reg for Timer_Counter29 1
   input [6:0]  cntr_ctrl_reg_129;      //Counter29 Control29 reg for Timer_Counter29 1
   input [6:0]  clk_ctrl_reg_229;       //Clock29 Control29 reg for Timer_Counter29 2
   input [6:0]  cntr_ctrl_reg_229;      //Counter29 Control29 reg for Timer29 Counter29 2
   input [6:0]  clk_ctrl_reg_329;       //Clock29 Control29 reg Timer_Counter29 3
   input [6:0]  cntr_ctrl_reg_329;      //Counter29 Control29 reg for Timer29 Counter29 3
   input [15:0] counter_val_reg_129;    //Counter29 Value from Timer_Counter29 1
   input [15:0] counter_val_reg_229;    //Counter29 Value from Timer_Counter29 2
   input [15:0] counter_val_reg_329;    //Counter29 Value from Timer_Counter29 3
   input [15:0] interval_reg_129;       //Interval29 reg value from Timer_Counter29 1
   input [15:0] match_1_reg_129;        //Match29 reg value from Timer_Counter29 
   input [15:0] match_2_reg_129;        //Match29 reg value from Timer_Counter29     
   input [15:0] match_3_reg_129;        //Match29 reg value from Timer_Counter29 
   input [15:0] interval_reg_229;       //Interval29 reg value from Timer_Counter29 2
   input [15:0] match_1_reg_229;        //Match29 reg value from Timer_Counter29     
   input [15:0] match_2_reg_229;        //Match29 reg value from Timer_Counter29     
   input [15:0] match_3_reg_229;        //Match29 reg value from Timer_Counter29 
   input [15:0] interval_reg_329;       //Interval29 reg value from Timer_Counter29 3
   input [15:0] match_1_reg_329;        //Match29 reg value from Timer_Counter29   
   input [15:0] match_2_reg_329;        //Match29 reg value from Timer_Counter29   
   input [15:0] match_3_reg_329;        //Match29 reg value from Timer_Counter29   
   input [5:0]  interrupt_reg_129;      //Interrupt29 Reg29 from Interrupt29 Module29 1
   input [5:0]  interrupt_reg_229;      //Interrupt29 Reg29 from Interrupt29 Module29 2
   input [5:0]  interrupt_reg_329;      //Interrupt29 Reg29 from Interrupt29 Module29 3
   input [5:0]  interrupt_en_reg_129;   //Interrupt29 Enable29 Reg29 from Intrpt29 Module29 1
   input [5:0]  interrupt_en_reg_229;   //Interrupt29 Enable29 Reg29 from Intrpt29 Module29 2
   input [5:0]  interrupt_en_reg_329;   //Interrupt29 Enable29 Reg29 from Intrpt29 Module29 3
   
   //outputs29
   output [31:0] prdata29;              //Read Data from the APB29 Interface29
   output clk_ctrl_reg_sel_129;         //Clock29 Control29 Reg29 Select29 TC_129 
   output clk_ctrl_reg_sel_229;         //Clock29 Control29 Reg29 Select29 TC_229 
   output clk_ctrl_reg_sel_329;         //Clock29 Control29 Reg29 Select29 TC_329 
   output cntr_ctrl_reg_sel_129;        //Counter29 Control29 Reg29 Select29 TC_129
   output cntr_ctrl_reg_sel_229;        //Counter29 Control29 Reg29 Select29 TC_229
   output cntr_ctrl_reg_sel_329;        //Counter29 Control29 Reg29 Select29 TC_329
   output interval_reg_sel_129;         //Interval29 Interrupt29 Reg29 Select29 TC_129 
   output interval_reg_sel_229;         //Interval29 Interrupt29 Reg29 Select29 TC_229 
   output interval_reg_sel_329;         //Interval29 Interrupt29 Reg29 Select29 TC_329 
   output match_1_reg_sel_129;          //Match29 Reg29 Select29 TC_129
   output match_1_reg_sel_229;          //Match29 Reg29 Select29 TC_229
   output match_1_reg_sel_329;          //Match29 Reg29 Select29 TC_329
   output match_2_reg_sel_129;          //Match29 Reg29 Select29 TC_129
   output match_2_reg_sel_229;          //Match29 Reg29 Select29 TC_229
   output match_2_reg_sel_329;          //Match29 Reg29 Select29 TC_329
   output match_3_reg_sel_129;          //Match29 Reg29 Select29 TC_129
   output match_3_reg_sel_229;          //Match29 Reg29 Select29 TC_229
   output match_3_reg_sel_329;          //Match29 Reg29 Select29 TC_329
   output [3:1] intr_en_reg_sel29;      //Interrupt29 Enable29 Reg29 Select29
   output [3:1] clear_interrupt29;      //Clear Interrupt29 line


//-----------------------------------------------------------------------------
// PARAMETER29 DECLARATIONS29
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR29   = 8'h00; //Clock29 control29 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR29   = 8'h04; //Clock29 control29 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR29   = 8'h08; //Clock29 control29 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR29  = 8'h0C; //Counter29 control29 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR29  = 8'h10; //Counter29 control29 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR29  = 8'h14; //Counter29 control29 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR29   = 8'h18; //Counter29 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR29   = 8'h1C; //Counter29 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR29   = 8'h20; //Counter29 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR29   = 8'h24; //Module29 1 interval29 address
   parameter   [7:0] INTERVAL_REG_2_ADDR29   = 8'h28; //Module29 2 interval29 address
   parameter   [7:0] INTERVAL_REG_3_ADDR29   = 8'h2C; //Module29 3 interval29 address
   parameter   [7:0] MATCH_1_REG_1_ADDR29    = 8'h30; //Module29 1 Match29 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR29    = 8'h34; //Module29 2 Match29 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR29    = 8'h38; //Module29 3 Match29 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR29    = 8'h3C; //Module29 1 Match29 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR29    = 8'h40; //Module29 2 Match29 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR29    = 8'h44; //Module29 3 Match29 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR29    = 8'h48; //Module29 1 Match29 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR29    = 8'h4C; //Module29 2 Match29 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR29    = 8'h50; //Module29 3 Match29 3 address
   parameter   [7:0] IRQ_REG_1_ADDR29        = 8'h54; //Interrupt29 register 1
   parameter   [7:0] IRQ_REG_2_ADDR29        = 8'h58; //Interrupt29 register 2
   parameter   [7:0] IRQ_REG_3_ADDR29        = 8'h5C; //Interrupt29 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR29     = 8'h60; //Interrupt29 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR29     = 8'h64; //Interrupt29 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR29     = 8'h68; //Interrupt29 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals29 & Registers29
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_129;         //Clock29 Control29 Reg29 Select29 TC_129
   reg clk_ctrl_reg_sel_229;         //Clock29 Control29 Reg29 Select29 TC_229 
   reg clk_ctrl_reg_sel_329;         //Clock29 Control29 Reg29 Select29 TC_329 
   reg cntr_ctrl_reg_sel_129;        //Counter29 Control29 Reg29 Select29 TC_129
   reg cntr_ctrl_reg_sel_229;        //Counter29 Control29 Reg29 Select29 TC_229
   reg cntr_ctrl_reg_sel_329;        //Counter29 Control29 Reg29 Select29 TC_329
   reg interval_reg_sel_129;         //Interval29 Interrupt29 Reg29 Select29 TC_129 
   reg interval_reg_sel_229;         //Interval29 Interrupt29 Reg29 Select29 TC_229
   reg interval_reg_sel_329;         //Interval29 Interrupt29 Reg29 Select29 TC_329
   reg match_1_reg_sel_129;          //Match29 Reg29 Select29 TC_129
   reg match_1_reg_sel_229;          //Match29 Reg29 Select29 TC_229
   reg match_1_reg_sel_329;          //Match29 Reg29 Select29 TC_329
   reg match_2_reg_sel_129;          //Match29 Reg29 Select29 TC_129
   reg match_2_reg_sel_229;          //Match29 Reg29 Select29 TC_229
   reg match_2_reg_sel_329;          //Match29 Reg29 Select29 TC_329
   reg match_3_reg_sel_129;          //Match29 Reg29 Select29 TC_129
   reg match_3_reg_sel_229;          //Match29 Reg29 Select29 TC_229
   reg match_3_reg_sel_329;          //Match29 Reg29 Select29 TC_329
   reg [3:1] intr_en_reg_sel29;      //Interrupt29 Enable29 1 Reg29 Select29
   reg [31:0] prdata29;              //APB29 read data
   
   wire [3:1] clear_interrupt29;     // 3-bit clear interrupt29 reg on read
   wire write;                     //APB29 write command  
   wire read;                      //APB29 read command    



   assign write = psel29 & penable29 & pwrite29;  
   assign read  = psel29 & ~pwrite29;  
   assign clear_interrupt29[1] = read & penable29 & (paddr29 == IRQ_REG_1_ADDR29);
   assign clear_interrupt29[2] = read & penable29 & (paddr29 == IRQ_REG_2_ADDR29);
   assign clear_interrupt29[3] = read & penable29 & (paddr29 == IRQ_REG_3_ADDR29);   
   
   //p_write_sel29: Process29 to select29 the required29 regs for write access.

   always @ (paddr29 or write)
   begin: p_write_sel29

       clk_ctrl_reg_sel_129  = (write && (paddr29 == CLK_CTRL_REG_1_ADDR29));
       clk_ctrl_reg_sel_229  = (write && (paddr29 == CLK_CTRL_REG_2_ADDR29));
       clk_ctrl_reg_sel_329  = (write && (paddr29 == CLK_CTRL_REG_3_ADDR29));
       cntr_ctrl_reg_sel_129 = (write && (paddr29 == CNTR_CTRL_REG_1_ADDR29));
       cntr_ctrl_reg_sel_229 = (write && (paddr29 == CNTR_CTRL_REG_2_ADDR29));
       cntr_ctrl_reg_sel_329 = (write && (paddr29 == CNTR_CTRL_REG_3_ADDR29));
       interval_reg_sel_129  = (write && (paddr29 == INTERVAL_REG_1_ADDR29));
       interval_reg_sel_229  = (write && (paddr29 == INTERVAL_REG_2_ADDR29));
       interval_reg_sel_329  = (write && (paddr29 == INTERVAL_REG_3_ADDR29));
       match_1_reg_sel_129   = (write && (paddr29 == MATCH_1_REG_1_ADDR29));
       match_1_reg_sel_229   = (write && (paddr29 == MATCH_1_REG_2_ADDR29));
       match_1_reg_sel_329   = (write && (paddr29 == MATCH_1_REG_3_ADDR29));
       match_2_reg_sel_129   = (write && (paddr29 == MATCH_2_REG_1_ADDR29));
       match_2_reg_sel_229   = (write && (paddr29 == MATCH_2_REG_2_ADDR29));
       match_2_reg_sel_329   = (write && (paddr29 == MATCH_2_REG_3_ADDR29));
       match_3_reg_sel_129   = (write && (paddr29 == MATCH_3_REG_1_ADDR29));
       match_3_reg_sel_229   = (write && (paddr29 == MATCH_3_REG_2_ADDR29));
       match_3_reg_sel_329   = (write && (paddr29 == MATCH_3_REG_3_ADDR29));
       intr_en_reg_sel29[1]  = (write && (paddr29 == IRQ_EN_REG_1_ADDR29));
       intr_en_reg_sel29[2]  = (write && (paddr29 == IRQ_EN_REG_2_ADDR29));
       intr_en_reg_sel29[3]  = (write && (paddr29 == IRQ_EN_REG_3_ADDR29));      
   end  //p_write_sel29
    

//    p_read_sel29: Process29 to enable the read operation29 to occur29.

   always @ (posedge pclk29 or negedge n_p_reset29)
   begin: p_read_sel29

      if (!n_p_reset29)                                   
      begin                                     
         prdata29 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr29)

               CLK_CTRL_REG_1_ADDR29 : prdata29 <= {25'h0000000,clk_ctrl_reg_129};
               CLK_CTRL_REG_2_ADDR29 : prdata29 <= {25'h0000000,clk_ctrl_reg_229};
               CLK_CTRL_REG_3_ADDR29 : prdata29 <= {25'h0000000,clk_ctrl_reg_329};
               CNTR_CTRL_REG_1_ADDR29: prdata29 <= {25'h0000000,cntr_ctrl_reg_129};
               CNTR_CTRL_REG_2_ADDR29: prdata29 <= {25'h0000000,cntr_ctrl_reg_229};
               CNTR_CTRL_REG_3_ADDR29: prdata29 <= {25'h0000000,cntr_ctrl_reg_329};
               CNTR_VAL_REG_1_ADDR29 : prdata29 <= {16'h0000,counter_val_reg_129};
               CNTR_VAL_REG_2_ADDR29 : prdata29 <= {16'h0000,counter_val_reg_229};
               CNTR_VAL_REG_3_ADDR29 : prdata29 <= {16'h0000,counter_val_reg_329};
               INTERVAL_REG_1_ADDR29 : prdata29 <= {16'h0000,interval_reg_129};
               INTERVAL_REG_2_ADDR29 : prdata29 <= {16'h0000,interval_reg_229};
               INTERVAL_REG_3_ADDR29 : prdata29 <= {16'h0000,interval_reg_329};
               MATCH_1_REG_1_ADDR29  : prdata29 <= {16'h0000,match_1_reg_129};
               MATCH_1_REG_2_ADDR29  : prdata29 <= {16'h0000,match_1_reg_229};
               MATCH_1_REG_3_ADDR29  : prdata29 <= {16'h0000,match_1_reg_329};
               MATCH_2_REG_1_ADDR29  : prdata29 <= {16'h0000,match_2_reg_129};
               MATCH_2_REG_2_ADDR29  : prdata29 <= {16'h0000,match_2_reg_229};
               MATCH_2_REG_3_ADDR29  : prdata29 <= {16'h0000,match_2_reg_329};
               MATCH_3_REG_1_ADDR29  : prdata29 <= {16'h0000,match_3_reg_129};
               MATCH_3_REG_2_ADDR29  : prdata29 <= {16'h0000,match_3_reg_229};
               MATCH_3_REG_3_ADDR29  : prdata29 <= {16'h0000,match_3_reg_329};
               IRQ_REG_1_ADDR29      : prdata29 <= {26'h0000,interrupt_reg_129};
               IRQ_REG_2_ADDR29      : prdata29 <= {26'h0000,interrupt_reg_229};
               IRQ_REG_3_ADDR29      : prdata29 <= {26'h0000,interrupt_reg_329};
               IRQ_EN_REG_1_ADDR29   : prdata29 <= {26'h0000,interrupt_en_reg_129};
               IRQ_EN_REG_2_ADDR29   : prdata29 <= {26'h0000,interrupt_en_reg_229};
               IRQ_EN_REG_3_ADDR29   : prdata29 <= {26'h0000,interrupt_en_reg_329};
               default             : prdata29 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata29 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset29)
      
   end // block: p_read_sel29

endmodule

