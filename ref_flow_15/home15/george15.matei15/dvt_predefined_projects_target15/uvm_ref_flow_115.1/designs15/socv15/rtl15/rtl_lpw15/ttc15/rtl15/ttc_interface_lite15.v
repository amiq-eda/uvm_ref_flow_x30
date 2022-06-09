//File15 name   : ttc_interface_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : The APB15 interface with the triple15 timer15 counter
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module15 definition15
//----------------------------------------------------------------------------

module ttc_interface_lite15( 

  //inputs15
  n_p_reset15,    
  pclk15,                          
  psel15,
  penable15,
  pwrite15,
  paddr15,
  clk_ctrl_reg_115,
  clk_ctrl_reg_215,
  clk_ctrl_reg_315,
  cntr_ctrl_reg_115,
  cntr_ctrl_reg_215,
  cntr_ctrl_reg_315,
  counter_val_reg_115,
  counter_val_reg_215,
  counter_val_reg_315,
  interval_reg_115,
  match_1_reg_115,
  match_2_reg_115,
  match_3_reg_115,
  interval_reg_215,
  match_1_reg_215,
  match_2_reg_215,
  match_3_reg_215,
  interval_reg_315,
  match_1_reg_315,
  match_2_reg_315,
  match_3_reg_315,
  interrupt_reg_115,
  interrupt_reg_215,
  interrupt_reg_315,      
  interrupt_en_reg_115,
  interrupt_en_reg_215,
  interrupt_en_reg_315,
                  
  //outputs15
  prdata15,
  clk_ctrl_reg_sel_115,
  clk_ctrl_reg_sel_215,
  clk_ctrl_reg_sel_315,
  cntr_ctrl_reg_sel_115,
  cntr_ctrl_reg_sel_215,
  cntr_ctrl_reg_sel_315,
  interval_reg_sel_115,                            
  interval_reg_sel_215,                          
  interval_reg_sel_315,
  match_1_reg_sel_115,                          
  match_1_reg_sel_215,                          
  match_1_reg_sel_315,                
  match_2_reg_sel_115,                          
  match_2_reg_sel_215,
  match_2_reg_sel_315,
  match_3_reg_sel_115,                          
  match_3_reg_sel_215,                         
  match_3_reg_sel_315,
  intr_en_reg_sel15,
  clear_interrupt15        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS15
//----------------------------------------------------------------------------

   //inputs15
   input        n_p_reset15;              //reset signal15
   input        pclk15;                 //System15 Clock15
   input        psel15;                 //Select15 line
   input        penable15;              //Strobe15 line
   input        pwrite15;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr15;                //Address Bus15 register
   input [6:0]  clk_ctrl_reg_115;       //Clock15 Control15 reg for Timer_Counter15 1
   input [6:0]  cntr_ctrl_reg_115;      //Counter15 Control15 reg for Timer_Counter15 1
   input [6:0]  clk_ctrl_reg_215;       //Clock15 Control15 reg for Timer_Counter15 2
   input [6:0]  cntr_ctrl_reg_215;      //Counter15 Control15 reg for Timer15 Counter15 2
   input [6:0]  clk_ctrl_reg_315;       //Clock15 Control15 reg Timer_Counter15 3
   input [6:0]  cntr_ctrl_reg_315;      //Counter15 Control15 reg for Timer15 Counter15 3
   input [15:0] counter_val_reg_115;    //Counter15 Value from Timer_Counter15 1
   input [15:0] counter_val_reg_215;    //Counter15 Value from Timer_Counter15 2
   input [15:0] counter_val_reg_315;    //Counter15 Value from Timer_Counter15 3
   input [15:0] interval_reg_115;       //Interval15 reg value from Timer_Counter15 1
   input [15:0] match_1_reg_115;        //Match15 reg value from Timer_Counter15 
   input [15:0] match_2_reg_115;        //Match15 reg value from Timer_Counter15     
   input [15:0] match_3_reg_115;        //Match15 reg value from Timer_Counter15 
   input [15:0] interval_reg_215;       //Interval15 reg value from Timer_Counter15 2
   input [15:0] match_1_reg_215;        //Match15 reg value from Timer_Counter15     
   input [15:0] match_2_reg_215;        //Match15 reg value from Timer_Counter15     
   input [15:0] match_3_reg_215;        //Match15 reg value from Timer_Counter15 
   input [15:0] interval_reg_315;       //Interval15 reg value from Timer_Counter15 3
   input [15:0] match_1_reg_315;        //Match15 reg value from Timer_Counter15   
   input [15:0] match_2_reg_315;        //Match15 reg value from Timer_Counter15   
   input [15:0] match_3_reg_315;        //Match15 reg value from Timer_Counter15   
   input [5:0]  interrupt_reg_115;      //Interrupt15 Reg15 from Interrupt15 Module15 1
   input [5:0]  interrupt_reg_215;      //Interrupt15 Reg15 from Interrupt15 Module15 2
   input [5:0]  interrupt_reg_315;      //Interrupt15 Reg15 from Interrupt15 Module15 3
   input [5:0]  interrupt_en_reg_115;   //Interrupt15 Enable15 Reg15 from Intrpt15 Module15 1
   input [5:0]  interrupt_en_reg_215;   //Interrupt15 Enable15 Reg15 from Intrpt15 Module15 2
   input [5:0]  interrupt_en_reg_315;   //Interrupt15 Enable15 Reg15 from Intrpt15 Module15 3
   
   //outputs15
   output [31:0] prdata15;              //Read Data from the APB15 Interface15
   output clk_ctrl_reg_sel_115;         //Clock15 Control15 Reg15 Select15 TC_115 
   output clk_ctrl_reg_sel_215;         //Clock15 Control15 Reg15 Select15 TC_215 
   output clk_ctrl_reg_sel_315;         //Clock15 Control15 Reg15 Select15 TC_315 
   output cntr_ctrl_reg_sel_115;        //Counter15 Control15 Reg15 Select15 TC_115
   output cntr_ctrl_reg_sel_215;        //Counter15 Control15 Reg15 Select15 TC_215
   output cntr_ctrl_reg_sel_315;        //Counter15 Control15 Reg15 Select15 TC_315
   output interval_reg_sel_115;         //Interval15 Interrupt15 Reg15 Select15 TC_115 
   output interval_reg_sel_215;         //Interval15 Interrupt15 Reg15 Select15 TC_215 
   output interval_reg_sel_315;         //Interval15 Interrupt15 Reg15 Select15 TC_315 
   output match_1_reg_sel_115;          //Match15 Reg15 Select15 TC_115
   output match_1_reg_sel_215;          //Match15 Reg15 Select15 TC_215
   output match_1_reg_sel_315;          //Match15 Reg15 Select15 TC_315
   output match_2_reg_sel_115;          //Match15 Reg15 Select15 TC_115
   output match_2_reg_sel_215;          //Match15 Reg15 Select15 TC_215
   output match_2_reg_sel_315;          //Match15 Reg15 Select15 TC_315
   output match_3_reg_sel_115;          //Match15 Reg15 Select15 TC_115
   output match_3_reg_sel_215;          //Match15 Reg15 Select15 TC_215
   output match_3_reg_sel_315;          //Match15 Reg15 Select15 TC_315
   output [3:1] intr_en_reg_sel15;      //Interrupt15 Enable15 Reg15 Select15
   output [3:1] clear_interrupt15;      //Clear Interrupt15 line


//-----------------------------------------------------------------------------
// PARAMETER15 DECLARATIONS15
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR15   = 8'h00; //Clock15 control15 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR15   = 8'h04; //Clock15 control15 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR15   = 8'h08; //Clock15 control15 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR15  = 8'h0C; //Counter15 control15 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR15  = 8'h10; //Counter15 control15 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR15  = 8'h14; //Counter15 control15 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR15   = 8'h18; //Counter15 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR15   = 8'h1C; //Counter15 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR15   = 8'h20; //Counter15 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR15   = 8'h24; //Module15 1 interval15 address
   parameter   [7:0] INTERVAL_REG_2_ADDR15   = 8'h28; //Module15 2 interval15 address
   parameter   [7:0] INTERVAL_REG_3_ADDR15   = 8'h2C; //Module15 3 interval15 address
   parameter   [7:0] MATCH_1_REG_1_ADDR15    = 8'h30; //Module15 1 Match15 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR15    = 8'h34; //Module15 2 Match15 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR15    = 8'h38; //Module15 3 Match15 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR15    = 8'h3C; //Module15 1 Match15 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR15    = 8'h40; //Module15 2 Match15 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR15    = 8'h44; //Module15 3 Match15 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR15    = 8'h48; //Module15 1 Match15 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR15    = 8'h4C; //Module15 2 Match15 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR15    = 8'h50; //Module15 3 Match15 3 address
   parameter   [7:0] IRQ_REG_1_ADDR15        = 8'h54; //Interrupt15 register 1
   parameter   [7:0] IRQ_REG_2_ADDR15        = 8'h58; //Interrupt15 register 2
   parameter   [7:0] IRQ_REG_3_ADDR15        = 8'h5C; //Interrupt15 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR15     = 8'h60; //Interrupt15 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR15     = 8'h64; //Interrupt15 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR15     = 8'h68; //Interrupt15 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals15 & Registers15
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_115;         //Clock15 Control15 Reg15 Select15 TC_115
   reg clk_ctrl_reg_sel_215;         //Clock15 Control15 Reg15 Select15 TC_215 
   reg clk_ctrl_reg_sel_315;         //Clock15 Control15 Reg15 Select15 TC_315 
   reg cntr_ctrl_reg_sel_115;        //Counter15 Control15 Reg15 Select15 TC_115
   reg cntr_ctrl_reg_sel_215;        //Counter15 Control15 Reg15 Select15 TC_215
   reg cntr_ctrl_reg_sel_315;        //Counter15 Control15 Reg15 Select15 TC_315
   reg interval_reg_sel_115;         //Interval15 Interrupt15 Reg15 Select15 TC_115 
   reg interval_reg_sel_215;         //Interval15 Interrupt15 Reg15 Select15 TC_215
   reg interval_reg_sel_315;         //Interval15 Interrupt15 Reg15 Select15 TC_315
   reg match_1_reg_sel_115;          //Match15 Reg15 Select15 TC_115
   reg match_1_reg_sel_215;          //Match15 Reg15 Select15 TC_215
   reg match_1_reg_sel_315;          //Match15 Reg15 Select15 TC_315
   reg match_2_reg_sel_115;          //Match15 Reg15 Select15 TC_115
   reg match_2_reg_sel_215;          //Match15 Reg15 Select15 TC_215
   reg match_2_reg_sel_315;          //Match15 Reg15 Select15 TC_315
   reg match_3_reg_sel_115;          //Match15 Reg15 Select15 TC_115
   reg match_3_reg_sel_215;          //Match15 Reg15 Select15 TC_215
   reg match_3_reg_sel_315;          //Match15 Reg15 Select15 TC_315
   reg [3:1] intr_en_reg_sel15;      //Interrupt15 Enable15 1 Reg15 Select15
   reg [31:0] prdata15;              //APB15 read data
   
   wire [3:1] clear_interrupt15;     // 3-bit clear interrupt15 reg on read
   wire write;                     //APB15 write command  
   wire read;                      //APB15 read command    



   assign write = psel15 & penable15 & pwrite15;  
   assign read  = psel15 & ~pwrite15;  
   assign clear_interrupt15[1] = read & penable15 & (paddr15 == IRQ_REG_1_ADDR15);
   assign clear_interrupt15[2] = read & penable15 & (paddr15 == IRQ_REG_2_ADDR15);
   assign clear_interrupt15[3] = read & penable15 & (paddr15 == IRQ_REG_3_ADDR15);   
   
   //p_write_sel15: Process15 to select15 the required15 regs for write access.

   always @ (paddr15 or write)
   begin: p_write_sel15

       clk_ctrl_reg_sel_115  = (write && (paddr15 == CLK_CTRL_REG_1_ADDR15));
       clk_ctrl_reg_sel_215  = (write && (paddr15 == CLK_CTRL_REG_2_ADDR15));
       clk_ctrl_reg_sel_315  = (write && (paddr15 == CLK_CTRL_REG_3_ADDR15));
       cntr_ctrl_reg_sel_115 = (write && (paddr15 == CNTR_CTRL_REG_1_ADDR15));
       cntr_ctrl_reg_sel_215 = (write && (paddr15 == CNTR_CTRL_REG_2_ADDR15));
       cntr_ctrl_reg_sel_315 = (write && (paddr15 == CNTR_CTRL_REG_3_ADDR15));
       interval_reg_sel_115  = (write && (paddr15 == INTERVAL_REG_1_ADDR15));
       interval_reg_sel_215  = (write && (paddr15 == INTERVAL_REG_2_ADDR15));
       interval_reg_sel_315  = (write && (paddr15 == INTERVAL_REG_3_ADDR15));
       match_1_reg_sel_115   = (write && (paddr15 == MATCH_1_REG_1_ADDR15));
       match_1_reg_sel_215   = (write && (paddr15 == MATCH_1_REG_2_ADDR15));
       match_1_reg_sel_315   = (write && (paddr15 == MATCH_1_REG_3_ADDR15));
       match_2_reg_sel_115   = (write && (paddr15 == MATCH_2_REG_1_ADDR15));
       match_2_reg_sel_215   = (write && (paddr15 == MATCH_2_REG_2_ADDR15));
       match_2_reg_sel_315   = (write && (paddr15 == MATCH_2_REG_3_ADDR15));
       match_3_reg_sel_115   = (write && (paddr15 == MATCH_3_REG_1_ADDR15));
       match_3_reg_sel_215   = (write && (paddr15 == MATCH_3_REG_2_ADDR15));
       match_3_reg_sel_315   = (write && (paddr15 == MATCH_3_REG_3_ADDR15));
       intr_en_reg_sel15[1]  = (write && (paddr15 == IRQ_EN_REG_1_ADDR15));
       intr_en_reg_sel15[2]  = (write && (paddr15 == IRQ_EN_REG_2_ADDR15));
       intr_en_reg_sel15[3]  = (write && (paddr15 == IRQ_EN_REG_3_ADDR15));      
   end  //p_write_sel15
    

//    p_read_sel15: Process15 to enable the read operation15 to occur15.

   always @ (posedge pclk15 or negedge n_p_reset15)
   begin: p_read_sel15

      if (!n_p_reset15)                                   
      begin                                     
         prdata15 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr15)

               CLK_CTRL_REG_1_ADDR15 : prdata15 <= {25'h0000000,clk_ctrl_reg_115};
               CLK_CTRL_REG_2_ADDR15 : prdata15 <= {25'h0000000,clk_ctrl_reg_215};
               CLK_CTRL_REG_3_ADDR15 : prdata15 <= {25'h0000000,clk_ctrl_reg_315};
               CNTR_CTRL_REG_1_ADDR15: prdata15 <= {25'h0000000,cntr_ctrl_reg_115};
               CNTR_CTRL_REG_2_ADDR15: prdata15 <= {25'h0000000,cntr_ctrl_reg_215};
               CNTR_CTRL_REG_3_ADDR15: prdata15 <= {25'h0000000,cntr_ctrl_reg_315};
               CNTR_VAL_REG_1_ADDR15 : prdata15 <= {16'h0000,counter_val_reg_115};
               CNTR_VAL_REG_2_ADDR15 : prdata15 <= {16'h0000,counter_val_reg_215};
               CNTR_VAL_REG_3_ADDR15 : prdata15 <= {16'h0000,counter_val_reg_315};
               INTERVAL_REG_1_ADDR15 : prdata15 <= {16'h0000,interval_reg_115};
               INTERVAL_REG_2_ADDR15 : prdata15 <= {16'h0000,interval_reg_215};
               INTERVAL_REG_3_ADDR15 : prdata15 <= {16'h0000,interval_reg_315};
               MATCH_1_REG_1_ADDR15  : prdata15 <= {16'h0000,match_1_reg_115};
               MATCH_1_REG_2_ADDR15  : prdata15 <= {16'h0000,match_1_reg_215};
               MATCH_1_REG_3_ADDR15  : prdata15 <= {16'h0000,match_1_reg_315};
               MATCH_2_REG_1_ADDR15  : prdata15 <= {16'h0000,match_2_reg_115};
               MATCH_2_REG_2_ADDR15  : prdata15 <= {16'h0000,match_2_reg_215};
               MATCH_2_REG_3_ADDR15  : prdata15 <= {16'h0000,match_2_reg_315};
               MATCH_3_REG_1_ADDR15  : prdata15 <= {16'h0000,match_3_reg_115};
               MATCH_3_REG_2_ADDR15  : prdata15 <= {16'h0000,match_3_reg_215};
               MATCH_3_REG_3_ADDR15  : prdata15 <= {16'h0000,match_3_reg_315};
               IRQ_REG_1_ADDR15      : prdata15 <= {26'h0000,interrupt_reg_115};
               IRQ_REG_2_ADDR15      : prdata15 <= {26'h0000,interrupt_reg_215};
               IRQ_REG_3_ADDR15      : prdata15 <= {26'h0000,interrupt_reg_315};
               IRQ_EN_REG_1_ADDR15   : prdata15 <= {26'h0000,interrupt_en_reg_115};
               IRQ_EN_REG_2_ADDR15   : prdata15 <= {26'h0000,interrupt_en_reg_215};
               IRQ_EN_REG_3_ADDR15   : prdata15 <= {26'h0000,interrupt_en_reg_315};
               default             : prdata15 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata15 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset15)
      
   end // block: p_read_sel15

endmodule

