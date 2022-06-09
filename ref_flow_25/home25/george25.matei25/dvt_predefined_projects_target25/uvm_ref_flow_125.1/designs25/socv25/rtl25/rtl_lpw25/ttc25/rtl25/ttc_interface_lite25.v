//File25 name   : ttc_interface_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : The APB25 interface with the triple25 timer25 counter
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module25 definition25
//----------------------------------------------------------------------------

module ttc_interface_lite25( 

  //inputs25
  n_p_reset25,    
  pclk25,                          
  psel25,
  penable25,
  pwrite25,
  paddr25,
  clk_ctrl_reg_125,
  clk_ctrl_reg_225,
  clk_ctrl_reg_325,
  cntr_ctrl_reg_125,
  cntr_ctrl_reg_225,
  cntr_ctrl_reg_325,
  counter_val_reg_125,
  counter_val_reg_225,
  counter_val_reg_325,
  interval_reg_125,
  match_1_reg_125,
  match_2_reg_125,
  match_3_reg_125,
  interval_reg_225,
  match_1_reg_225,
  match_2_reg_225,
  match_3_reg_225,
  interval_reg_325,
  match_1_reg_325,
  match_2_reg_325,
  match_3_reg_325,
  interrupt_reg_125,
  interrupt_reg_225,
  interrupt_reg_325,      
  interrupt_en_reg_125,
  interrupt_en_reg_225,
  interrupt_en_reg_325,
                  
  //outputs25
  prdata25,
  clk_ctrl_reg_sel_125,
  clk_ctrl_reg_sel_225,
  clk_ctrl_reg_sel_325,
  cntr_ctrl_reg_sel_125,
  cntr_ctrl_reg_sel_225,
  cntr_ctrl_reg_sel_325,
  interval_reg_sel_125,                            
  interval_reg_sel_225,                          
  interval_reg_sel_325,
  match_1_reg_sel_125,                          
  match_1_reg_sel_225,                          
  match_1_reg_sel_325,                
  match_2_reg_sel_125,                          
  match_2_reg_sel_225,
  match_2_reg_sel_325,
  match_3_reg_sel_125,                          
  match_3_reg_sel_225,                         
  match_3_reg_sel_325,
  intr_en_reg_sel25,
  clear_interrupt25        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS25
//----------------------------------------------------------------------------

   //inputs25
   input        n_p_reset25;              //reset signal25
   input        pclk25;                 //System25 Clock25
   input        psel25;                 //Select25 line
   input        penable25;              //Strobe25 line
   input        pwrite25;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr25;                //Address Bus25 register
   input [6:0]  clk_ctrl_reg_125;       //Clock25 Control25 reg for Timer_Counter25 1
   input [6:0]  cntr_ctrl_reg_125;      //Counter25 Control25 reg for Timer_Counter25 1
   input [6:0]  clk_ctrl_reg_225;       //Clock25 Control25 reg for Timer_Counter25 2
   input [6:0]  cntr_ctrl_reg_225;      //Counter25 Control25 reg for Timer25 Counter25 2
   input [6:0]  clk_ctrl_reg_325;       //Clock25 Control25 reg Timer_Counter25 3
   input [6:0]  cntr_ctrl_reg_325;      //Counter25 Control25 reg for Timer25 Counter25 3
   input [15:0] counter_val_reg_125;    //Counter25 Value from Timer_Counter25 1
   input [15:0] counter_val_reg_225;    //Counter25 Value from Timer_Counter25 2
   input [15:0] counter_val_reg_325;    //Counter25 Value from Timer_Counter25 3
   input [15:0] interval_reg_125;       //Interval25 reg value from Timer_Counter25 1
   input [15:0] match_1_reg_125;        //Match25 reg value from Timer_Counter25 
   input [15:0] match_2_reg_125;        //Match25 reg value from Timer_Counter25     
   input [15:0] match_3_reg_125;        //Match25 reg value from Timer_Counter25 
   input [15:0] interval_reg_225;       //Interval25 reg value from Timer_Counter25 2
   input [15:0] match_1_reg_225;        //Match25 reg value from Timer_Counter25     
   input [15:0] match_2_reg_225;        //Match25 reg value from Timer_Counter25     
   input [15:0] match_3_reg_225;        //Match25 reg value from Timer_Counter25 
   input [15:0] interval_reg_325;       //Interval25 reg value from Timer_Counter25 3
   input [15:0] match_1_reg_325;        //Match25 reg value from Timer_Counter25   
   input [15:0] match_2_reg_325;        //Match25 reg value from Timer_Counter25   
   input [15:0] match_3_reg_325;        //Match25 reg value from Timer_Counter25   
   input [5:0]  interrupt_reg_125;      //Interrupt25 Reg25 from Interrupt25 Module25 1
   input [5:0]  interrupt_reg_225;      //Interrupt25 Reg25 from Interrupt25 Module25 2
   input [5:0]  interrupt_reg_325;      //Interrupt25 Reg25 from Interrupt25 Module25 3
   input [5:0]  interrupt_en_reg_125;   //Interrupt25 Enable25 Reg25 from Intrpt25 Module25 1
   input [5:0]  interrupt_en_reg_225;   //Interrupt25 Enable25 Reg25 from Intrpt25 Module25 2
   input [5:0]  interrupt_en_reg_325;   //Interrupt25 Enable25 Reg25 from Intrpt25 Module25 3
   
   //outputs25
   output [31:0] prdata25;              //Read Data from the APB25 Interface25
   output clk_ctrl_reg_sel_125;         //Clock25 Control25 Reg25 Select25 TC_125 
   output clk_ctrl_reg_sel_225;         //Clock25 Control25 Reg25 Select25 TC_225 
   output clk_ctrl_reg_sel_325;         //Clock25 Control25 Reg25 Select25 TC_325 
   output cntr_ctrl_reg_sel_125;        //Counter25 Control25 Reg25 Select25 TC_125
   output cntr_ctrl_reg_sel_225;        //Counter25 Control25 Reg25 Select25 TC_225
   output cntr_ctrl_reg_sel_325;        //Counter25 Control25 Reg25 Select25 TC_325
   output interval_reg_sel_125;         //Interval25 Interrupt25 Reg25 Select25 TC_125 
   output interval_reg_sel_225;         //Interval25 Interrupt25 Reg25 Select25 TC_225 
   output interval_reg_sel_325;         //Interval25 Interrupt25 Reg25 Select25 TC_325 
   output match_1_reg_sel_125;          //Match25 Reg25 Select25 TC_125
   output match_1_reg_sel_225;          //Match25 Reg25 Select25 TC_225
   output match_1_reg_sel_325;          //Match25 Reg25 Select25 TC_325
   output match_2_reg_sel_125;          //Match25 Reg25 Select25 TC_125
   output match_2_reg_sel_225;          //Match25 Reg25 Select25 TC_225
   output match_2_reg_sel_325;          //Match25 Reg25 Select25 TC_325
   output match_3_reg_sel_125;          //Match25 Reg25 Select25 TC_125
   output match_3_reg_sel_225;          //Match25 Reg25 Select25 TC_225
   output match_3_reg_sel_325;          //Match25 Reg25 Select25 TC_325
   output [3:1] intr_en_reg_sel25;      //Interrupt25 Enable25 Reg25 Select25
   output [3:1] clear_interrupt25;      //Clear Interrupt25 line


//-----------------------------------------------------------------------------
// PARAMETER25 DECLARATIONS25
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR25   = 8'h00; //Clock25 control25 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR25   = 8'h04; //Clock25 control25 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR25   = 8'h08; //Clock25 control25 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR25  = 8'h0C; //Counter25 control25 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR25  = 8'h10; //Counter25 control25 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR25  = 8'h14; //Counter25 control25 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR25   = 8'h18; //Counter25 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR25   = 8'h1C; //Counter25 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR25   = 8'h20; //Counter25 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR25   = 8'h24; //Module25 1 interval25 address
   parameter   [7:0] INTERVAL_REG_2_ADDR25   = 8'h28; //Module25 2 interval25 address
   parameter   [7:0] INTERVAL_REG_3_ADDR25   = 8'h2C; //Module25 3 interval25 address
   parameter   [7:0] MATCH_1_REG_1_ADDR25    = 8'h30; //Module25 1 Match25 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR25    = 8'h34; //Module25 2 Match25 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR25    = 8'h38; //Module25 3 Match25 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR25    = 8'h3C; //Module25 1 Match25 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR25    = 8'h40; //Module25 2 Match25 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR25    = 8'h44; //Module25 3 Match25 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR25    = 8'h48; //Module25 1 Match25 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR25    = 8'h4C; //Module25 2 Match25 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR25    = 8'h50; //Module25 3 Match25 3 address
   parameter   [7:0] IRQ_REG_1_ADDR25        = 8'h54; //Interrupt25 register 1
   parameter   [7:0] IRQ_REG_2_ADDR25        = 8'h58; //Interrupt25 register 2
   parameter   [7:0] IRQ_REG_3_ADDR25        = 8'h5C; //Interrupt25 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR25     = 8'h60; //Interrupt25 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR25     = 8'h64; //Interrupt25 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR25     = 8'h68; //Interrupt25 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals25 & Registers25
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_125;         //Clock25 Control25 Reg25 Select25 TC_125
   reg clk_ctrl_reg_sel_225;         //Clock25 Control25 Reg25 Select25 TC_225 
   reg clk_ctrl_reg_sel_325;         //Clock25 Control25 Reg25 Select25 TC_325 
   reg cntr_ctrl_reg_sel_125;        //Counter25 Control25 Reg25 Select25 TC_125
   reg cntr_ctrl_reg_sel_225;        //Counter25 Control25 Reg25 Select25 TC_225
   reg cntr_ctrl_reg_sel_325;        //Counter25 Control25 Reg25 Select25 TC_325
   reg interval_reg_sel_125;         //Interval25 Interrupt25 Reg25 Select25 TC_125 
   reg interval_reg_sel_225;         //Interval25 Interrupt25 Reg25 Select25 TC_225
   reg interval_reg_sel_325;         //Interval25 Interrupt25 Reg25 Select25 TC_325
   reg match_1_reg_sel_125;          //Match25 Reg25 Select25 TC_125
   reg match_1_reg_sel_225;          //Match25 Reg25 Select25 TC_225
   reg match_1_reg_sel_325;          //Match25 Reg25 Select25 TC_325
   reg match_2_reg_sel_125;          //Match25 Reg25 Select25 TC_125
   reg match_2_reg_sel_225;          //Match25 Reg25 Select25 TC_225
   reg match_2_reg_sel_325;          //Match25 Reg25 Select25 TC_325
   reg match_3_reg_sel_125;          //Match25 Reg25 Select25 TC_125
   reg match_3_reg_sel_225;          //Match25 Reg25 Select25 TC_225
   reg match_3_reg_sel_325;          //Match25 Reg25 Select25 TC_325
   reg [3:1] intr_en_reg_sel25;      //Interrupt25 Enable25 1 Reg25 Select25
   reg [31:0] prdata25;              //APB25 read data
   
   wire [3:1] clear_interrupt25;     // 3-bit clear interrupt25 reg on read
   wire write;                     //APB25 write command  
   wire read;                      //APB25 read command    



   assign write = psel25 & penable25 & pwrite25;  
   assign read  = psel25 & ~pwrite25;  
   assign clear_interrupt25[1] = read & penable25 & (paddr25 == IRQ_REG_1_ADDR25);
   assign clear_interrupt25[2] = read & penable25 & (paddr25 == IRQ_REG_2_ADDR25);
   assign clear_interrupt25[3] = read & penable25 & (paddr25 == IRQ_REG_3_ADDR25);   
   
   //p_write_sel25: Process25 to select25 the required25 regs for write access.

   always @ (paddr25 or write)
   begin: p_write_sel25

       clk_ctrl_reg_sel_125  = (write && (paddr25 == CLK_CTRL_REG_1_ADDR25));
       clk_ctrl_reg_sel_225  = (write && (paddr25 == CLK_CTRL_REG_2_ADDR25));
       clk_ctrl_reg_sel_325  = (write && (paddr25 == CLK_CTRL_REG_3_ADDR25));
       cntr_ctrl_reg_sel_125 = (write && (paddr25 == CNTR_CTRL_REG_1_ADDR25));
       cntr_ctrl_reg_sel_225 = (write && (paddr25 == CNTR_CTRL_REG_2_ADDR25));
       cntr_ctrl_reg_sel_325 = (write && (paddr25 == CNTR_CTRL_REG_3_ADDR25));
       interval_reg_sel_125  = (write && (paddr25 == INTERVAL_REG_1_ADDR25));
       interval_reg_sel_225  = (write && (paddr25 == INTERVAL_REG_2_ADDR25));
       interval_reg_sel_325  = (write && (paddr25 == INTERVAL_REG_3_ADDR25));
       match_1_reg_sel_125   = (write && (paddr25 == MATCH_1_REG_1_ADDR25));
       match_1_reg_sel_225   = (write && (paddr25 == MATCH_1_REG_2_ADDR25));
       match_1_reg_sel_325   = (write && (paddr25 == MATCH_1_REG_3_ADDR25));
       match_2_reg_sel_125   = (write && (paddr25 == MATCH_2_REG_1_ADDR25));
       match_2_reg_sel_225   = (write && (paddr25 == MATCH_2_REG_2_ADDR25));
       match_2_reg_sel_325   = (write && (paddr25 == MATCH_2_REG_3_ADDR25));
       match_3_reg_sel_125   = (write && (paddr25 == MATCH_3_REG_1_ADDR25));
       match_3_reg_sel_225   = (write && (paddr25 == MATCH_3_REG_2_ADDR25));
       match_3_reg_sel_325   = (write && (paddr25 == MATCH_3_REG_3_ADDR25));
       intr_en_reg_sel25[1]  = (write && (paddr25 == IRQ_EN_REG_1_ADDR25));
       intr_en_reg_sel25[2]  = (write && (paddr25 == IRQ_EN_REG_2_ADDR25));
       intr_en_reg_sel25[3]  = (write && (paddr25 == IRQ_EN_REG_3_ADDR25));      
   end  //p_write_sel25
    

//    p_read_sel25: Process25 to enable the read operation25 to occur25.

   always @ (posedge pclk25 or negedge n_p_reset25)
   begin: p_read_sel25

      if (!n_p_reset25)                                   
      begin                                     
         prdata25 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr25)

               CLK_CTRL_REG_1_ADDR25 : prdata25 <= {25'h0000000,clk_ctrl_reg_125};
               CLK_CTRL_REG_2_ADDR25 : prdata25 <= {25'h0000000,clk_ctrl_reg_225};
               CLK_CTRL_REG_3_ADDR25 : prdata25 <= {25'h0000000,clk_ctrl_reg_325};
               CNTR_CTRL_REG_1_ADDR25: prdata25 <= {25'h0000000,cntr_ctrl_reg_125};
               CNTR_CTRL_REG_2_ADDR25: prdata25 <= {25'h0000000,cntr_ctrl_reg_225};
               CNTR_CTRL_REG_3_ADDR25: prdata25 <= {25'h0000000,cntr_ctrl_reg_325};
               CNTR_VAL_REG_1_ADDR25 : prdata25 <= {16'h0000,counter_val_reg_125};
               CNTR_VAL_REG_2_ADDR25 : prdata25 <= {16'h0000,counter_val_reg_225};
               CNTR_VAL_REG_3_ADDR25 : prdata25 <= {16'h0000,counter_val_reg_325};
               INTERVAL_REG_1_ADDR25 : prdata25 <= {16'h0000,interval_reg_125};
               INTERVAL_REG_2_ADDR25 : prdata25 <= {16'h0000,interval_reg_225};
               INTERVAL_REG_3_ADDR25 : prdata25 <= {16'h0000,interval_reg_325};
               MATCH_1_REG_1_ADDR25  : prdata25 <= {16'h0000,match_1_reg_125};
               MATCH_1_REG_2_ADDR25  : prdata25 <= {16'h0000,match_1_reg_225};
               MATCH_1_REG_3_ADDR25  : prdata25 <= {16'h0000,match_1_reg_325};
               MATCH_2_REG_1_ADDR25  : prdata25 <= {16'h0000,match_2_reg_125};
               MATCH_2_REG_2_ADDR25  : prdata25 <= {16'h0000,match_2_reg_225};
               MATCH_2_REG_3_ADDR25  : prdata25 <= {16'h0000,match_2_reg_325};
               MATCH_3_REG_1_ADDR25  : prdata25 <= {16'h0000,match_3_reg_125};
               MATCH_3_REG_2_ADDR25  : prdata25 <= {16'h0000,match_3_reg_225};
               MATCH_3_REG_3_ADDR25  : prdata25 <= {16'h0000,match_3_reg_325};
               IRQ_REG_1_ADDR25      : prdata25 <= {26'h0000,interrupt_reg_125};
               IRQ_REG_2_ADDR25      : prdata25 <= {26'h0000,interrupt_reg_225};
               IRQ_REG_3_ADDR25      : prdata25 <= {26'h0000,interrupt_reg_325};
               IRQ_EN_REG_1_ADDR25   : prdata25 <= {26'h0000,interrupt_en_reg_125};
               IRQ_EN_REG_2_ADDR25   : prdata25 <= {26'h0000,interrupt_en_reg_225};
               IRQ_EN_REG_3_ADDR25   : prdata25 <= {26'h0000,interrupt_en_reg_325};
               default             : prdata25 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata25 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset25)
      
   end // block: p_read_sel25

endmodule

