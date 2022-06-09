//File18 name   : ttc_interface_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : The APB18 interface with the triple18 timer18 counter
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module18 definition18
//----------------------------------------------------------------------------

module ttc_interface_lite18( 

  //inputs18
  n_p_reset18,    
  pclk18,                          
  psel18,
  penable18,
  pwrite18,
  paddr18,
  clk_ctrl_reg_118,
  clk_ctrl_reg_218,
  clk_ctrl_reg_318,
  cntr_ctrl_reg_118,
  cntr_ctrl_reg_218,
  cntr_ctrl_reg_318,
  counter_val_reg_118,
  counter_val_reg_218,
  counter_val_reg_318,
  interval_reg_118,
  match_1_reg_118,
  match_2_reg_118,
  match_3_reg_118,
  interval_reg_218,
  match_1_reg_218,
  match_2_reg_218,
  match_3_reg_218,
  interval_reg_318,
  match_1_reg_318,
  match_2_reg_318,
  match_3_reg_318,
  interrupt_reg_118,
  interrupt_reg_218,
  interrupt_reg_318,      
  interrupt_en_reg_118,
  interrupt_en_reg_218,
  interrupt_en_reg_318,
                  
  //outputs18
  prdata18,
  clk_ctrl_reg_sel_118,
  clk_ctrl_reg_sel_218,
  clk_ctrl_reg_sel_318,
  cntr_ctrl_reg_sel_118,
  cntr_ctrl_reg_sel_218,
  cntr_ctrl_reg_sel_318,
  interval_reg_sel_118,                            
  interval_reg_sel_218,                          
  interval_reg_sel_318,
  match_1_reg_sel_118,                          
  match_1_reg_sel_218,                          
  match_1_reg_sel_318,                
  match_2_reg_sel_118,                          
  match_2_reg_sel_218,
  match_2_reg_sel_318,
  match_3_reg_sel_118,                          
  match_3_reg_sel_218,                         
  match_3_reg_sel_318,
  intr_en_reg_sel18,
  clear_interrupt18        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS18
//----------------------------------------------------------------------------

   //inputs18
   input        n_p_reset18;              //reset signal18
   input        pclk18;                 //System18 Clock18
   input        psel18;                 //Select18 line
   input        penable18;              //Strobe18 line
   input        pwrite18;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr18;                //Address Bus18 register
   input [6:0]  clk_ctrl_reg_118;       //Clock18 Control18 reg for Timer_Counter18 1
   input [6:0]  cntr_ctrl_reg_118;      //Counter18 Control18 reg for Timer_Counter18 1
   input [6:0]  clk_ctrl_reg_218;       //Clock18 Control18 reg for Timer_Counter18 2
   input [6:0]  cntr_ctrl_reg_218;      //Counter18 Control18 reg for Timer18 Counter18 2
   input [6:0]  clk_ctrl_reg_318;       //Clock18 Control18 reg Timer_Counter18 3
   input [6:0]  cntr_ctrl_reg_318;      //Counter18 Control18 reg for Timer18 Counter18 3
   input [15:0] counter_val_reg_118;    //Counter18 Value from Timer_Counter18 1
   input [15:0] counter_val_reg_218;    //Counter18 Value from Timer_Counter18 2
   input [15:0] counter_val_reg_318;    //Counter18 Value from Timer_Counter18 3
   input [15:0] interval_reg_118;       //Interval18 reg value from Timer_Counter18 1
   input [15:0] match_1_reg_118;        //Match18 reg value from Timer_Counter18 
   input [15:0] match_2_reg_118;        //Match18 reg value from Timer_Counter18     
   input [15:0] match_3_reg_118;        //Match18 reg value from Timer_Counter18 
   input [15:0] interval_reg_218;       //Interval18 reg value from Timer_Counter18 2
   input [15:0] match_1_reg_218;        //Match18 reg value from Timer_Counter18     
   input [15:0] match_2_reg_218;        //Match18 reg value from Timer_Counter18     
   input [15:0] match_3_reg_218;        //Match18 reg value from Timer_Counter18 
   input [15:0] interval_reg_318;       //Interval18 reg value from Timer_Counter18 3
   input [15:0] match_1_reg_318;        //Match18 reg value from Timer_Counter18   
   input [15:0] match_2_reg_318;        //Match18 reg value from Timer_Counter18   
   input [15:0] match_3_reg_318;        //Match18 reg value from Timer_Counter18   
   input [5:0]  interrupt_reg_118;      //Interrupt18 Reg18 from Interrupt18 Module18 1
   input [5:0]  interrupt_reg_218;      //Interrupt18 Reg18 from Interrupt18 Module18 2
   input [5:0]  interrupt_reg_318;      //Interrupt18 Reg18 from Interrupt18 Module18 3
   input [5:0]  interrupt_en_reg_118;   //Interrupt18 Enable18 Reg18 from Intrpt18 Module18 1
   input [5:0]  interrupt_en_reg_218;   //Interrupt18 Enable18 Reg18 from Intrpt18 Module18 2
   input [5:0]  interrupt_en_reg_318;   //Interrupt18 Enable18 Reg18 from Intrpt18 Module18 3
   
   //outputs18
   output [31:0] prdata18;              //Read Data from the APB18 Interface18
   output clk_ctrl_reg_sel_118;         //Clock18 Control18 Reg18 Select18 TC_118 
   output clk_ctrl_reg_sel_218;         //Clock18 Control18 Reg18 Select18 TC_218 
   output clk_ctrl_reg_sel_318;         //Clock18 Control18 Reg18 Select18 TC_318 
   output cntr_ctrl_reg_sel_118;        //Counter18 Control18 Reg18 Select18 TC_118
   output cntr_ctrl_reg_sel_218;        //Counter18 Control18 Reg18 Select18 TC_218
   output cntr_ctrl_reg_sel_318;        //Counter18 Control18 Reg18 Select18 TC_318
   output interval_reg_sel_118;         //Interval18 Interrupt18 Reg18 Select18 TC_118 
   output interval_reg_sel_218;         //Interval18 Interrupt18 Reg18 Select18 TC_218 
   output interval_reg_sel_318;         //Interval18 Interrupt18 Reg18 Select18 TC_318 
   output match_1_reg_sel_118;          //Match18 Reg18 Select18 TC_118
   output match_1_reg_sel_218;          //Match18 Reg18 Select18 TC_218
   output match_1_reg_sel_318;          //Match18 Reg18 Select18 TC_318
   output match_2_reg_sel_118;          //Match18 Reg18 Select18 TC_118
   output match_2_reg_sel_218;          //Match18 Reg18 Select18 TC_218
   output match_2_reg_sel_318;          //Match18 Reg18 Select18 TC_318
   output match_3_reg_sel_118;          //Match18 Reg18 Select18 TC_118
   output match_3_reg_sel_218;          //Match18 Reg18 Select18 TC_218
   output match_3_reg_sel_318;          //Match18 Reg18 Select18 TC_318
   output [3:1] intr_en_reg_sel18;      //Interrupt18 Enable18 Reg18 Select18
   output [3:1] clear_interrupt18;      //Clear Interrupt18 line


//-----------------------------------------------------------------------------
// PARAMETER18 DECLARATIONS18
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR18   = 8'h00; //Clock18 control18 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR18   = 8'h04; //Clock18 control18 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR18   = 8'h08; //Clock18 control18 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR18  = 8'h0C; //Counter18 control18 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR18  = 8'h10; //Counter18 control18 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR18  = 8'h14; //Counter18 control18 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR18   = 8'h18; //Counter18 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR18   = 8'h1C; //Counter18 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR18   = 8'h20; //Counter18 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR18   = 8'h24; //Module18 1 interval18 address
   parameter   [7:0] INTERVAL_REG_2_ADDR18   = 8'h28; //Module18 2 interval18 address
   parameter   [7:0] INTERVAL_REG_3_ADDR18   = 8'h2C; //Module18 3 interval18 address
   parameter   [7:0] MATCH_1_REG_1_ADDR18    = 8'h30; //Module18 1 Match18 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR18    = 8'h34; //Module18 2 Match18 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR18    = 8'h38; //Module18 3 Match18 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR18    = 8'h3C; //Module18 1 Match18 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR18    = 8'h40; //Module18 2 Match18 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR18    = 8'h44; //Module18 3 Match18 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR18    = 8'h48; //Module18 1 Match18 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR18    = 8'h4C; //Module18 2 Match18 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR18    = 8'h50; //Module18 3 Match18 3 address
   parameter   [7:0] IRQ_REG_1_ADDR18        = 8'h54; //Interrupt18 register 1
   parameter   [7:0] IRQ_REG_2_ADDR18        = 8'h58; //Interrupt18 register 2
   parameter   [7:0] IRQ_REG_3_ADDR18        = 8'h5C; //Interrupt18 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR18     = 8'h60; //Interrupt18 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR18     = 8'h64; //Interrupt18 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR18     = 8'h68; //Interrupt18 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals18 & Registers18
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_118;         //Clock18 Control18 Reg18 Select18 TC_118
   reg clk_ctrl_reg_sel_218;         //Clock18 Control18 Reg18 Select18 TC_218 
   reg clk_ctrl_reg_sel_318;         //Clock18 Control18 Reg18 Select18 TC_318 
   reg cntr_ctrl_reg_sel_118;        //Counter18 Control18 Reg18 Select18 TC_118
   reg cntr_ctrl_reg_sel_218;        //Counter18 Control18 Reg18 Select18 TC_218
   reg cntr_ctrl_reg_sel_318;        //Counter18 Control18 Reg18 Select18 TC_318
   reg interval_reg_sel_118;         //Interval18 Interrupt18 Reg18 Select18 TC_118 
   reg interval_reg_sel_218;         //Interval18 Interrupt18 Reg18 Select18 TC_218
   reg interval_reg_sel_318;         //Interval18 Interrupt18 Reg18 Select18 TC_318
   reg match_1_reg_sel_118;          //Match18 Reg18 Select18 TC_118
   reg match_1_reg_sel_218;          //Match18 Reg18 Select18 TC_218
   reg match_1_reg_sel_318;          //Match18 Reg18 Select18 TC_318
   reg match_2_reg_sel_118;          //Match18 Reg18 Select18 TC_118
   reg match_2_reg_sel_218;          //Match18 Reg18 Select18 TC_218
   reg match_2_reg_sel_318;          //Match18 Reg18 Select18 TC_318
   reg match_3_reg_sel_118;          //Match18 Reg18 Select18 TC_118
   reg match_3_reg_sel_218;          //Match18 Reg18 Select18 TC_218
   reg match_3_reg_sel_318;          //Match18 Reg18 Select18 TC_318
   reg [3:1] intr_en_reg_sel18;      //Interrupt18 Enable18 1 Reg18 Select18
   reg [31:0] prdata18;              //APB18 read data
   
   wire [3:1] clear_interrupt18;     // 3-bit clear interrupt18 reg on read
   wire write;                     //APB18 write command  
   wire read;                      //APB18 read command    



   assign write = psel18 & penable18 & pwrite18;  
   assign read  = psel18 & ~pwrite18;  
   assign clear_interrupt18[1] = read & penable18 & (paddr18 == IRQ_REG_1_ADDR18);
   assign clear_interrupt18[2] = read & penable18 & (paddr18 == IRQ_REG_2_ADDR18);
   assign clear_interrupt18[3] = read & penable18 & (paddr18 == IRQ_REG_3_ADDR18);   
   
   //p_write_sel18: Process18 to select18 the required18 regs for write access.

   always @ (paddr18 or write)
   begin: p_write_sel18

       clk_ctrl_reg_sel_118  = (write && (paddr18 == CLK_CTRL_REG_1_ADDR18));
       clk_ctrl_reg_sel_218  = (write && (paddr18 == CLK_CTRL_REG_2_ADDR18));
       clk_ctrl_reg_sel_318  = (write && (paddr18 == CLK_CTRL_REG_3_ADDR18));
       cntr_ctrl_reg_sel_118 = (write && (paddr18 == CNTR_CTRL_REG_1_ADDR18));
       cntr_ctrl_reg_sel_218 = (write && (paddr18 == CNTR_CTRL_REG_2_ADDR18));
       cntr_ctrl_reg_sel_318 = (write && (paddr18 == CNTR_CTRL_REG_3_ADDR18));
       interval_reg_sel_118  = (write && (paddr18 == INTERVAL_REG_1_ADDR18));
       interval_reg_sel_218  = (write && (paddr18 == INTERVAL_REG_2_ADDR18));
       interval_reg_sel_318  = (write && (paddr18 == INTERVAL_REG_3_ADDR18));
       match_1_reg_sel_118   = (write && (paddr18 == MATCH_1_REG_1_ADDR18));
       match_1_reg_sel_218   = (write && (paddr18 == MATCH_1_REG_2_ADDR18));
       match_1_reg_sel_318   = (write && (paddr18 == MATCH_1_REG_3_ADDR18));
       match_2_reg_sel_118   = (write && (paddr18 == MATCH_2_REG_1_ADDR18));
       match_2_reg_sel_218   = (write && (paddr18 == MATCH_2_REG_2_ADDR18));
       match_2_reg_sel_318   = (write && (paddr18 == MATCH_2_REG_3_ADDR18));
       match_3_reg_sel_118   = (write && (paddr18 == MATCH_3_REG_1_ADDR18));
       match_3_reg_sel_218   = (write && (paddr18 == MATCH_3_REG_2_ADDR18));
       match_3_reg_sel_318   = (write && (paddr18 == MATCH_3_REG_3_ADDR18));
       intr_en_reg_sel18[1]  = (write && (paddr18 == IRQ_EN_REG_1_ADDR18));
       intr_en_reg_sel18[2]  = (write && (paddr18 == IRQ_EN_REG_2_ADDR18));
       intr_en_reg_sel18[3]  = (write && (paddr18 == IRQ_EN_REG_3_ADDR18));      
   end  //p_write_sel18
    

//    p_read_sel18: Process18 to enable the read operation18 to occur18.

   always @ (posedge pclk18 or negedge n_p_reset18)
   begin: p_read_sel18

      if (!n_p_reset18)                                   
      begin                                     
         prdata18 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr18)

               CLK_CTRL_REG_1_ADDR18 : prdata18 <= {25'h0000000,clk_ctrl_reg_118};
               CLK_CTRL_REG_2_ADDR18 : prdata18 <= {25'h0000000,clk_ctrl_reg_218};
               CLK_CTRL_REG_3_ADDR18 : prdata18 <= {25'h0000000,clk_ctrl_reg_318};
               CNTR_CTRL_REG_1_ADDR18: prdata18 <= {25'h0000000,cntr_ctrl_reg_118};
               CNTR_CTRL_REG_2_ADDR18: prdata18 <= {25'h0000000,cntr_ctrl_reg_218};
               CNTR_CTRL_REG_3_ADDR18: prdata18 <= {25'h0000000,cntr_ctrl_reg_318};
               CNTR_VAL_REG_1_ADDR18 : prdata18 <= {16'h0000,counter_val_reg_118};
               CNTR_VAL_REG_2_ADDR18 : prdata18 <= {16'h0000,counter_val_reg_218};
               CNTR_VAL_REG_3_ADDR18 : prdata18 <= {16'h0000,counter_val_reg_318};
               INTERVAL_REG_1_ADDR18 : prdata18 <= {16'h0000,interval_reg_118};
               INTERVAL_REG_2_ADDR18 : prdata18 <= {16'h0000,interval_reg_218};
               INTERVAL_REG_3_ADDR18 : prdata18 <= {16'h0000,interval_reg_318};
               MATCH_1_REG_1_ADDR18  : prdata18 <= {16'h0000,match_1_reg_118};
               MATCH_1_REG_2_ADDR18  : prdata18 <= {16'h0000,match_1_reg_218};
               MATCH_1_REG_3_ADDR18  : prdata18 <= {16'h0000,match_1_reg_318};
               MATCH_2_REG_1_ADDR18  : prdata18 <= {16'h0000,match_2_reg_118};
               MATCH_2_REG_2_ADDR18  : prdata18 <= {16'h0000,match_2_reg_218};
               MATCH_2_REG_3_ADDR18  : prdata18 <= {16'h0000,match_2_reg_318};
               MATCH_3_REG_1_ADDR18  : prdata18 <= {16'h0000,match_3_reg_118};
               MATCH_3_REG_2_ADDR18  : prdata18 <= {16'h0000,match_3_reg_218};
               MATCH_3_REG_3_ADDR18  : prdata18 <= {16'h0000,match_3_reg_318};
               IRQ_REG_1_ADDR18      : prdata18 <= {26'h0000,interrupt_reg_118};
               IRQ_REG_2_ADDR18      : prdata18 <= {26'h0000,interrupt_reg_218};
               IRQ_REG_3_ADDR18      : prdata18 <= {26'h0000,interrupt_reg_318};
               IRQ_EN_REG_1_ADDR18   : prdata18 <= {26'h0000,interrupt_en_reg_118};
               IRQ_EN_REG_2_ADDR18   : prdata18 <= {26'h0000,interrupt_en_reg_218};
               IRQ_EN_REG_3_ADDR18   : prdata18 <= {26'h0000,interrupt_en_reg_318};
               default             : prdata18 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata18 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset18)
      
   end // block: p_read_sel18

endmodule

