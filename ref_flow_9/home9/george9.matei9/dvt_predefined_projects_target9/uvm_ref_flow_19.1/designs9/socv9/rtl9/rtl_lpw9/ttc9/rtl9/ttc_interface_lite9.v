//File9 name   : ttc_interface_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : The APB9 interface with the triple9 timer9 counter
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module9 definition9
//----------------------------------------------------------------------------

module ttc_interface_lite9( 

  //inputs9
  n_p_reset9,    
  pclk9,                          
  psel9,
  penable9,
  pwrite9,
  paddr9,
  clk_ctrl_reg_19,
  clk_ctrl_reg_29,
  clk_ctrl_reg_39,
  cntr_ctrl_reg_19,
  cntr_ctrl_reg_29,
  cntr_ctrl_reg_39,
  counter_val_reg_19,
  counter_val_reg_29,
  counter_val_reg_39,
  interval_reg_19,
  match_1_reg_19,
  match_2_reg_19,
  match_3_reg_19,
  interval_reg_29,
  match_1_reg_29,
  match_2_reg_29,
  match_3_reg_29,
  interval_reg_39,
  match_1_reg_39,
  match_2_reg_39,
  match_3_reg_39,
  interrupt_reg_19,
  interrupt_reg_29,
  interrupt_reg_39,      
  interrupt_en_reg_19,
  interrupt_en_reg_29,
  interrupt_en_reg_39,
                  
  //outputs9
  prdata9,
  clk_ctrl_reg_sel_19,
  clk_ctrl_reg_sel_29,
  clk_ctrl_reg_sel_39,
  cntr_ctrl_reg_sel_19,
  cntr_ctrl_reg_sel_29,
  cntr_ctrl_reg_sel_39,
  interval_reg_sel_19,                            
  interval_reg_sel_29,                          
  interval_reg_sel_39,
  match_1_reg_sel_19,                          
  match_1_reg_sel_29,                          
  match_1_reg_sel_39,                
  match_2_reg_sel_19,                          
  match_2_reg_sel_29,
  match_2_reg_sel_39,
  match_3_reg_sel_19,                          
  match_3_reg_sel_29,                         
  match_3_reg_sel_39,
  intr_en_reg_sel9,
  clear_interrupt9        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS9
//----------------------------------------------------------------------------

   //inputs9
   input        n_p_reset9;              //reset signal9
   input        pclk9;                 //System9 Clock9
   input        psel9;                 //Select9 line
   input        penable9;              //Strobe9 line
   input        pwrite9;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr9;                //Address Bus9 register
   input [6:0]  clk_ctrl_reg_19;       //Clock9 Control9 reg for Timer_Counter9 1
   input [6:0]  cntr_ctrl_reg_19;      //Counter9 Control9 reg for Timer_Counter9 1
   input [6:0]  clk_ctrl_reg_29;       //Clock9 Control9 reg for Timer_Counter9 2
   input [6:0]  cntr_ctrl_reg_29;      //Counter9 Control9 reg for Timer9 Counter9 2
   input [6:0]  clk_ctrl_reg_39;       //Clock9 Control9 reg Timer_Counter9 3
   input [6:0]  cntr_ctrl_reg_39;      //Counter9 Control9 reg for Timer9 Counter9 3
   input [15:0] counter_val_reg_19;    //Counter9 Value from Timer_Counter9 1
   input [15:0] counter_val_reg_29;    //Counter9 Value from Timer_Counter9 2
   input [15:0] counter_val_reg_39;    //Counter9 Value from Timer_Counter9 3
   input [15:0] interval_reg_19;       //Interval9 reg value from Timer_Counter9 1
   input [15:0] match_1_reg_19;        //Match9 reg value from Timer_Counter9 
   input [15:0] match_2_reg_19;        //Match9 reg value from Timer_Counter9     
   input [15:0] match_3_reg_19;        //Match9 reg value from Timer_Counter9 
   input [15:0] interval_reg_29;       //Interval9 reg value from Timer_Counter9 2
   input [15:0] match_1_reg_29;        //Match9 reg value from Timer_Counter9     
   input [15:0] match_2_reg_29;        //Match9 reg value from Timer_Counter9     
   input [15:0] match_3_reg_29;        //Match9 reg value from Timer_Counter9 
   input [15:0] interval_reg_39;       //Interval9 reg value from Timer_Counter9 3
   input [15:0] match_1_reg_39;        //Match9 reg value from Timer_Counter9   
   input [15:0] match_2_reg_39;        //Match9 reg value from Timer_Counter9   
   input [15:0] match_3_reg_39;        //Match9 reg value from Timer_Counter9   
   input [5:0]  interrupt_reg_19;      //Interrupt9 Reg9 from Interrupt9 Module9 1
   input [5:0]  interrupt_reg_29;      //Interrupt9 Reg9 from Interrupt9 Module9 2
   input [5:0]  interrupt_reg_39;      //Interrupt9 Reg9 from Interrupt9 Module9 3
   input [5:0]  interrupt_en_reg_19;   //Interrupt9 Enable9 Reg9 from Intrpt9 Module9 1
   input [5:0]  interrupt_en_reg_29;   //Interrupt9 Enable9 Reg9 from Intrpt9 Module9 2
   input [5:0]  interrupt_en_reg_39;   //Interrupt9 Enable9 Reg9 from Intrpt9 Module9 3
   
   //outputs9
   output [31:0] prdata9;              //Read Data from the APB9 Interface9
   output clk_ctrl_reg_sel_19;         //Clock9 Control9 Reg9 Select9 TC_19 
   output clk_ctrl_reg_sel_29;         //Clock9 Control9 Reg9 Select9 TC_29 
   output clk_ctrl_reg_sel_39;         //Clock9 Control9 Reg9 Select9 TC_39 
   output cntr_ctrl_reg_sel_19;        //Counter9 Control9 Reg9 Select9 TC_19
   output cntr_ctrl_reg_sel_29;        //Counter9 Control9 Reg9 Select9 TC_29
   output cntr_ctrl_reg_sel_39;        //Counter9 Control9 Reg9 Select9 TC_39
   output interval_reg_sel_19;         //Interval9 Interrupt9 Reg9 Select9 TC_19 
   output interval_reg_sel_29;         //Interval9 Interrupt9 Reg9 Select9 TC_29 
   output interval_reg_sel_39;         //Interval9 Interrupt9 Reg9 Select9 TC_39 
   output match_1_reg_sel_19;          //Match9 Reg9 Select9 TC_19
   output match_1_reg_sel_29;          //Match9 Reg9 Select9 TC_29
   output match_1_reg_sel_39;          //Match9 Reg9 Select9 TC_39
   output match_2_reg_sel_19;          //Match9 Reg9 Select9 TC_19
   output match_2_reg_sel_29;          //Match9 Reg9 Select9 TC_29
   output match_2_reg_sel_39;          //Match9 Reg9 Select9 TC_39
   output match_3_reg_sel_19;          //Match9 Reg9 Select9 TC_19
   output match_3_reg_sel_29;          //Match9 Reg9 Select9 TC_29
   output match_3_reg_sel_39;          //Match9 Reg9 Select9 TC_39
   output [3:1] intr_en_reg_sel9;      //Interrupt9 Enable9 Reg9 Select9
   output [3:1] clear_interrupt9;      //Clear Interrupt9 line


//-----------------------------------------------------------------------------
// PARAMETER9 DECLARATIONS9
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR9   = 8'h00; //Clock9 control9 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR9   = 8'h04; //Clock9 control9 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR9   = 8'h08; //Clock9 control9 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR9  = 8'h0C; //Counter9 control9 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR9  = 8'h10; //Counter9 control9 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR9  = 8'h14; //Counter9 control9 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR9   = 8'h18; //Counter9 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR9   = 8'h1C; //Counter9 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR9   = 8'h20; //Counter9 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR9   = 8'h24; //Module9 1 interval9 address
   parameter   [7:0] INTERVAL_REG_2_ADDR9   = 8'h28; //Module9 2 interval9 address
   parameter   [7:0] INTERVAL_REG_3_ADDR9   = 8'h2C; //Module9 3 interval9 address
   parameter   [7:0] MATCH_1_REG_1_ADDR9    = 8'h30; //Module9 1 Match9 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR9    = 8'h34; //Module9 2 Match9 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR9    = 8'h38; //Module9 3 Match9 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR9    = 8'h3C; //Module9 1 Match9 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR9    = 8'h40; //Module9 2 Match9 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR9    = 8'h44; //Module9 3 Match9 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR9    = 8'h48; //Module9 1 Match9 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR9    = 8'h4C; //Module9 2 Match9 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR9    = 8'h50; //Module9 3 Match9 3 address
   parameter   [7:0] IRQ_REG_1_ADDR9        = 8'h54; //Interrupt9 register 1
   parameter   [7:0] IRQ_REG_2_ADDR9        = 8'h58; //Interrupt9 register 2
   parameter   [7:0] IRQ_REG_3_ADDR9        = 8'h5C; //Interrupt9 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR9     = 8'h60; //Interrupt9 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR9     = 8'h64; //Interrupt9 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR9     = 8'h68; //Interrupt9 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals9 & Registers9
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_19;         //Clock9 Control9 Reg9 Select9 TC_19
   reg clk_ctrl_reg_sel_29;         //Clock9 Control9 Reg9 Select9 TC_29 
   reg clk_ctrl_reg_sel_39;         //Clock9 Control9 Reg9 Select9 TC_39 
   reg cntr_ctrl_reg_sel_19;        //Counter9 Control9 Reg9 Select9 TC_19
   reg cntr_ctrl_reg_sel_29;        //Counter9 Control9 Reg9 Select9 TC_29
   reg cntr_ctrl_reg_sel_39;        //Counter9 Control9 Reg9 Select9 TC_39
   reg interval_reg_sel_19;         //Interval9 Interrupt9 Reg9 Select9 TC_19 
   reg interval_reg_sel_29;         //Interval9 Interrupt9 Reg9 Select9 TC_29
   reg interval_reg_sel_39;         //Interval9 Interrupt9 Reg9 Select9 TC_39
   reg match_1_reg_sel_19;          //Match9 Reg9 Select9 TC_19
   reg match_1_reg_sel_29;          //Match9 Reg9 Select9 TC_29
   reg match_1_reg_sel_39;          //Match9 Reg9 Select9 TC_39
   reg match_2_reg_sel_19;          //Match9 Reg9 Select9 TC_19
   reg match_2_reg_sel_29;          //Match9 Reg9 Select9 TC_29
   reg match_2_reg_sel_39;          //Match9 Reg9 Select9 TC_39
   reg match_3_reg_sel_19;          //Match9 Reg9 Select9 TC_19
   reg match_3_reg_sel_29;          //Match9 Reg9 Select9 TC_29
   reg match_3_reg_sel_39;          //Match9 Reg9 Select9 TC_39
   reg [3:1] intr_en_reg_sel9;      //Interrupt9 Enable9 1 Reg9 Select9
   reg [31:0] prdata9;              //APB9 read data
   
   wire [3:1] clear_interrupt9;     // 3-bit clear interrupt9 reg on read
   wire write;                     //APB9 write command  
   wire read;                      //APB9 read command    



   assign write = psel9 & penable9 & pwrite9;  
   assign read  = psel9 & ~pwrite9;  
   assign clear_interrupt9[1] = read & penable9 & (paddr9 == IRQ_REG_1_ADDR9);
   assign clear_interrupt9[2] = read & penable9 & (paddr9 == IRQ_REG_2_ADDR9);
   assign clear_interrupt9[3] = read & penable9 & (paddr9 == IRQ_REG_3_ADDR9);   
   
   //p_write_sel9: Process9 to select9 the required9 regs for write access.

   always @ (paddr9 or write)
   begin: p_write_sel9

       clk_ctrl_reg_sel_19  = (write && (paddr9 == CLK_CTRL_REG_1_ADDR9));
       clk_ctrl_reg_sel_29  = (write && (paddr9 == CLK_CTRL_REG_2_ADDR9));
       clk_ctrl_reg_sel_39  = (write && (paddr9 == CLK_CTRL_REG_3_ADDR9));
       cntr_ctrl_reg_sel_19 = (write && (paddr9 == CNTR_CTRL_REG_1_ADDR9));
       cntr_ctrl_reg_sel_29 = (write && (paddr9 == CNTR_CTRL_REG_2_ADDR9));
       cntr_ctrl_reg_sel_39 = (write && (paddr9 == CNTR_CTRL_REG_3_ADDR9));
       interval_reg_sel_19  = (write && (paddr9 == INTERVAL_REG_1_ADDR9));
       interval_reg_sel_29  = (write && (paddr9 == INTERVAL_REG_2_ADDR9));
       interval_reg_sel_39  = (write && (paddr9 == INTERVAL_REG_3_ADDR9));
       match_1_reg_sel_19   = (write && (paddr9 == MATCH_1_REG_1_ADDR9));
       match_1_reg_sel_29   = (write && (paddr9 == MATCH_1_REG_2_ADDR9));
       match_1_reg_sel_39   = (write && (paddr9 == MATCH_1_REG_3_ADDR9));
       match_2_reg_sel_19   = (write && (paddr9 == MATCH_2_REG_1_ADDR9));
       match_2_reg_sel_29   = (write && (paddr9 == MATCH_2_REG_2_ADDR9));
       match_2_reg_sel_39   = (write && (paddr9 == MATCH_2_REG_3_ADDR9));
       match_3_reg_sel_19   = (write && (paddr9 == MATCH_3_REG_1_ADDR9));
       match_3_reg_sel_29   = (write && (paddr9 == MATCH_3_REG_2_ADDR9));
       match_3_reg_sel_39   = (write && (paddr9 == MATCH_3_REG_3_ADDR9));
       intr_en_reg_sel9[1]  = (write && (paddr9 == IRQ_EN_REG_1_ADDR9));
       intr_en_reg_sel9[2]  = (write && (paddr9 == IRQ_EN_REG_2_ADDR9));
       intr_en_reg_sel9[3]  = (write && (paddr9 == IRQ_EN_REG_3_ADDR9));      
   end  //p_write_sel9
    

//    p_read_sel9: Process9 to enable the read operation9 to occur9.

   always @ (posedge pclk9 or negedge n_p_reset9)
   begin: p_read_sel9

      if (!n_p_reset9)                                   
      begin                                     
         prdata9 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr9)

               CLK_CTRL_REG_1_ADDR9 : prdata9 <= {25'h0000000,clk_ctrl_reg_19};
               CLK_CTRL_REG_2_ADDR9 : prdata9 <= {25'h0000000,clk_ctrl_reg_29};
               CLK_CTRL_REG_3_ADDR9 : prdata9 <= {25'h0000000,clk_ctrl_reg_39};
               CNTR_CTRL_REG_1_ADDR9: prdata9 <= {25'h0000000,cntr_ctrl_reg_19};
               CNTR_CTRL_REG_2_ADDR9: prdata9 <= {25'h0000000,cntr_ctrl_reg_29};
               CNTR_CTRL_REG_3_ADDR9: prdata9 <= {25'h0000000,cntr_ctrl_reg_39};
               CNTR_VAL_REG_1_ADDR9 : prdata9 <= {16'h0000,counter_val_reg_19};
               CNTR_VAL_REG_2_ADDR9 : prdata9 <= {16'h0000,counter_val_reg_29};
               CNTR_VAL_REG_3_ADDR9 : prdata9 <= {16'h0000,counter_val_reg_39};
               INTERVAL_REG_1_ADDR9 : prdata9 <= {16'h0000,interval_reg_19};
               INTERVAL_REG_2_ADDR9 : prdata9 <= {16'h0000,interval_reg_29};
               INTERVAL_REG_3_ADDR9 : prdata9 <= {16'h0000,interval_reg_39};
               MATCH_1_REG_1_ADDR9  : prdata9 <= {16'h0000,match_1_reg_19};
               MATCH_1_REG_2_ADDR9  : prdata9 <= {16'h0000,match_1_reg_29};
               MATCH_1_REG_3_ADDR9  : prdata9 <= {16'h0000,match_1_reg_39};
               MATCH_2_REG_1_ADDR9  : prdata9 <= {16'h0000,match_2_reg_19};
               MATCH_2_REG_2_ADDR9  : prdata9 <= {16'h0000,match_2_reg_29};
               MATCH_2_REG_3_ADDR9  : prdata9 <= {16'h0000,match_2_reg_39};
               MATCH_3_REG_1_ADDR9  : prdata9 <= {16'h0000,match_3_reg_19};
               MATCH_3_REG_2_ADDR9  : prdata9 <= {16'h0000,match_3_reg_29};
               MATCH_3_REG_3_ADDR9  : prdata9 <= {16'h0000,match_3_reg_39};
               IRQ_REG_1_ADDR9      : prdata9 <= {26'h0000,interrupt_reg_19};
               IRQ_REG_2_ADDR9      : prdata9 <= {26'h0000,interrupt_reg_29};
               IRQ_REG_3_ADDR9      : prdata9 <= {26'h0000,interrupt_reg_39};
               IRQ_EN_REG_1_ADDR9   : prdata9 <= {26'h0000,interrupt_en_reg_19};
               IRQ_EN_REG_2_ADDR9   : prdata9 <= {26'h0000,interrupt_en_reg_29};
               IRQ_EN_REG_3_ADDR9   : prdata9 <= {26'h0000,interrupt_en_reg_39};
               default             : prdata9 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata9 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset9)
      
   end // block: p_read_sel9

endmodule

