//File6 name   : ttc_interface_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : The APB6 interface with the triple6 timer6 counter
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module6 definition6
//----------------------------------------------------------------------------

module ttc_interface_lite6( 

  //inputs6
  n_p_reset6,    
  pclk6,                          
  psel6,
  penable6,
  pwrite6,
  paddr6,
  clk_ctrl_reg_16,
  clk_ctrl_reg_26,
  clk_ctrl_reg_36,
  cntr_ctrl_reg_16,
  cntr_ctrl_reg_26,
  cntr_ctrl_reg_36,
  counter_val_reg_16,
  counter_val_reg_26,
  counter_val_reg_36,
  interval_reg_16,
  match_1_reg_16,
  match_2_reg_16,
  match_3_reg_16,
  interval_reg_26,
  match_1_reg_26,
  match_2_reg_26,
  match_3_reg_26,
  interval_reg_36,
  match_1_reg_36,
  match_2_reg_36,
  match_3_reg_36,
  interrupt_reg_16,
  interrupt_reg_26,
  interrupt_reg_36,      
  interrupt_en_reg_16,
  interrupt_en_reg_26,
  interrupt_en_reg_36,
                  
  //outputs6
  prdata6,
  clk_ctrl_reg_sel_16,
  clk_ctrl_reg_sel_26,
  clk_ctrl_reg_sel_36,
  cntr_ctrl_reg_sel_16,
  cntr_ctrl_reg_sel_26,
  cntr_ctrl_reg_sel_36,
  interval_reg_sel_16,                            
  interval_reg_sel_26,                          
  interval_reg_sel_36,
  match_1_reg_sel_16,                          
  match_1_reg_sel_26,                          
  match_1_reg_sel_36,                
  match_2_reg_sel_16,                          
  match_2_reg_sel_26,
  match_2_reg_sel_36,
  match_3_reg_sel_16,                          
  match_3_reg_sel_26,                         
  match_3_reg_sel_36,
  intr_en_reg_sel6,
  clear_interrupt6        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS6
//----------------------------------------------------------------------------

   //inputs6
   input        n_p_reset6;              //reset signal6
   input        pclk6;                 //System6 Clock6
   input        psel6;                 //Select6 line
   input        penable6;              //Strobe6 line
   input        pwrite6;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr6;                //Address Bus6 register
   input [6:0]  clk_ctrl_reg_16;       //Clock6 Control6 reg for Timer_Counter6 1
   input [6:0]  cntr_ctrl_reg_16;      //Counter6 Control6 reg for Timer_Counter6 1
   input [6:0]  clk_ctrl_reg_26;       //Clock6 Control6 reg for Timer_Counter6 2
   input [6:0]  cntr_ctrl_reg_26;      //Counter6 Control6 reg for Timer6 Counter6 2
   input [6:0]  clk_ctrl_reg_36;       //Clock6 Control6 reg Timer_Counter6 3
   input [6:0]  cntr_ctrl_reg_36;      //Counter6 Control6 reg for Timer6 Counter6 3
   input [15:0] counter_val_reg_16;    //Counter6 Value from Timer_Counter6 1
   input [15:0] counter_val_reg_26;    //Counter6 Value from Timer_Counter6 2
   input [15:0] counter_val_reg_36;    //Counter6 Value from Timer_Counter6 3
   input [15:0] interval_reg_16;       //Interval6 reg value from Timer_Counter6 1
   input [15:0] match_1_reg_16;        //Match6 reg value from Timer_Counter6 
   input [15:0] match_2_reg_16;        //Match6 reg value from Timer_Counter6     
   input [15:0] match_3_reg_16;        //Match6 reg value from Timer_Counter6 
   input [15:0] interval_reg_26;       //Interval6 reg value from Timer_Counter6 2
   input [15:0] match_1_reg_26;        //Match6 reg value from Timer_Counter6     
   input [15:0] match_2_reg_26;        //Match6 reg value from Timer_Counter6     
   input [15:0] match_3_reg_26;        //Match6 reg value from Timer_Counter6 
   input [15:0] interval_reg_36;       //Interval6 reg value from Timer_Counter6 3
   input [15:0] match_1_reg_36;        //Match6 reg value from Timer_Counter6   
   input [15:0] match_2_reg_36;        //Match6 reg value from Timer_Counter6   
   input [15:0] match_3_reg_36;        //Match6 reg value from Timer_Counter6   
   input [5:0]  interrupt_reg_16;      //Interrupt6 Reg6 from Interrupt6 Module6 1
   input [5:0]  interrupt_reg_26;      //Interrupt6 Reg6 from Interrupt6 Module6 2
   input [5:0]  interrupt_reg_36;      //Interrupt6 Reg6 from Interrupt6 Module6 3
   input [5:0]  interrupt_en_reg_16;   //Interrupt6 Enable6 Reg6 from Intrpt6 Module6 1
   input [5:0]  interrupt_en_reg_26;   //Interrupt6 Enable6 Reg6 from Intrpt6 Module6 2
   input [5:0]  interrupt_en_reg_36;   //Interrupt6 Enable6 Reg6 from Intrpt6 Module6 3
   
   //outputs6
   output [31:0] prdata6;              //Read Data from the APB6 Interface6
   output clk_ctrl_reg_sel_16;         //Clock6 Control6 Reg6 Select6 TC_16 
   output clk_ctrl_reg_sel_26;         //Clock6 Control6 Reg6 Select6 TC_26 
   output clk_ctrl_reg_sel_36;         //Clock6 Control6 Reg6 Select6 TC_36 
   output cntr_ctrl_reg_sel_16;        //Counter6 Control6 Reg6 Select6 TC_16
   output cntr_ctrl_reg_sel_26;        //Counter6 Control6 Reg6 Select6 TC_26
   output cntr_ctrl_reg_sel_36;        //Counter6 Control6 Reg6 Select6 TC_36
   output interval_reg_sel_16;         //Interval6 Interrupt6 Reg6 Select6 TC_16 
   output interval_reg_sel_26;         //Interval6 Interrupt6 Reg6 Select6 TC_26 
   output interval_reg_sel_36;         //Interval6 Interrupt6 Reg6 Select6 TC_36 
   output match_1_reg_sel_16;          //Match6 Reg6 Select6 TC_16
   output match_1_reg_sel_26;          //Match6 Reg6 Select6 TC_26
   output match_1_reg_sel_36;          //Match6 Reg6 Select6 TC_36
   output match_2_reg_sel_16;          //Match6 Reg6 Select6 TC_16
   output match_2_reg_sel_26;          //Match6 Reg6 Select6 TC_26
   output match_2_reg_sel_36;          //Match6 Reg6 Select6 TC_36
   output match_3_reg_sel_16;          //Match6 Reg6 Select6 TC_16
   output match_3_reg_sel_26;          //Match6 Reg6 Select6 TC_26
   output match_3_reg_sel_36;          //Match6 Reg6 Select6 TC_36
   output [3:1] intr_en_reg_sel6;      //Interrupt6 Enable6 Reg6 Select6
   output [3:1] clear_interrupt6;      //Clear Interrupt6 line


//-----------------------------------------------------------------------------
// PARAMETER6 DECLARATIONS6
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR6   = 8'h00; //Clock6 control6 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR6   = 8'h04; //Clock6 control6 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR6   = 8'h08; //Clock6 control6 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR6  = 8'h0C; //Counter6 control6 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR6  = 8'h10; //Counter6 control6 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR6  = 8'h14; //Counter6 control6 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR6   = 8'h18; //Counter6 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR6   = 8'h1C; //Counter6 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR6   = 8'h20; //Counter6 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR6   = 8'h24; //Module6 1 interval6 address
   parameter   [7:0] INTERVAL_REG_2_ADDR6   = 8'h28; //Module6 2 interval6 address
   parameter   [7:0] INTERVAL_REG_3_ADDR6   = 8'h2C; //Module6 3 interval6 address
   parameter   [7:0] MATCH_1_REG_1_ADDR6    = 8'h30; //Module6 1 Match6 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR6    = 8'h34; //Module6 2 Match6 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR6    = 8'h38; //Module6 3 Match6 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR6    = 8'h3C; //Module6 1 Match6 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR6    = 8'h40; //Module6 2 Match6 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR6    = 8'h44; //Module6 3 Match6 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR6    = 8'h48; //Module6 1 Match6 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR6    = 8'h4C; //Module6 2 Match6 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR6    = 8'h50; //Module6 3 Match6 3 address
   parameter   [7:0] IRQ_REG_1_ADDR6        = 8'h54; //Interrupt6 register 1
   parameter   [7:0] IRQ_REG_2_ADDR6        = 8'h58; //Interrupt6 register 2
   parameter   [7:0] IRQ_REG_3_ADDR6        = 8'h5C; //Interrupt6 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR6     = 8'h60; //Interrupt6 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR6     = 8'h64; //Interrupt6 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR6     = 8'h68; //Interrupt6 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals6 & Registers6
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_16;         //Clock6 Control6 Reg6 Select6 TC_16
   reg clk_ctrl_reg_sel_26;         //Clock6 Control6 Reg6 Select6 TC_26 
   reg clk_ctrl_reg_sel_36;         //Clock6 Control6 Reg6 Select6 TC_36 
   reg cntr_ctrl_reg_sel_16;        //Counter6 Control6 Reg6 Select6 TC_16
   reg cntr_ctrl_reg_sel_26;        //Counter6 Control6 Reg6 Select6 TC_26
   reg cntr_ctrl_reg_sel_36;        //Counter6 Control6 Reg6 Select6 TC_36
   reg interval_reg_sel_16;         //Interval6 Interrupt6 Reg6 Select6 TC_16 
   reg interval_reg_sel_26;         //Interval6 Interrupt6 Reg6 Select6 TC_26
   reg interval_reg_sel_36;         //Interval6 Interrupt6 Reg6 Select6 TC_36
   reg match_1_reg_sel_16;          //Match6 Reg6 Select6 TC_16
   reg match_1_reg_sel_26;          //Match6 Reg6 Select6 TC_26
   reg match_1_reg_sel_36;          //Match6 Reg6 Select6 TC_36
   reg match_2_reg_sel_16;          //Match6 Reg6 Select6 TC_16
   reg match_2_reg_sel_26;          //Match6 Reg6 Select6 TC_26
   reg match_2_reg_sel_36;          //Match6 Reg6 Select6 TC_36
   reg match_3_reg_sel_16;          //Match6 Reg6 Select6 TC_16
   reg match_3_reg_sel_26;          //Match6 Reg6 Select6 TC_26
   reg match_3_reg_sel_36;          //Match6 Reg6 Select6 TC_36
   reg [3:1] intr_en_reg_sel6;      //Interrupt6 Enable6 1 Reg6 Select6
   reg [31:0] prdata6;              //APB6 read data
   
   wire [3:1] clear_interrupt6;     // 3-bit clear interrupt6 reg on read
   wire write;                     //APB6 write command  
   wire read;                      //APB6 read command    



   assign write = psel6 & penable6 & pwrite6;  
   assign read  = psel6 & ~pwrite6;  
   assign clear_interrupt6[1] = read & penable6 & (paddr6 == IRQ_REG_1_ADDR6);
   assign clear_interrupt6[2] = read & penable6 & (paddr6 == IRQ_REG_2_ADDR6);
   assign clear_interrupt6[3] = read & penable6 & (paddr6 == IRQ_REG_3_ADDR6);   
   
   //p_write_sel6: Process6 to select6 the required6 regs for write access.

   always @ (paddr6 or write)
   begin: p_write_sel6

       clk_ctrl_reg_sel_16  = (write && (paddr6 == CLK_CTRL_REG_1_ADDR6));
       clk_ctrl_reg_sel_26  = (write && (paddr6 == CLK_CTRL_REG_2_ADDR6));
       clk_ctrl_reg_sel_36  = (write && (paddr6 == CLK_CTRL_REG_3_ADDR6));
       cntr_ctrl_reg_sel_16 = (write && (paddr6 == CNTR_CTRL_REG_1_ADDR6));
       cntr_ctrl_reg_sel_26 = (write && (paddr6 == CNTR_CTRL_REG_2_ADDR6));
       cntr_ctrl_reg_sel_36 = (write && (paddr6 == CNTR_CTRL_REG_3_ADDR6));
       interval_reg_sel_16  = (write && (paddr6 == INTERVAL_REG_1_ADDR6));
       interval_reg_sel_26  = (write && (paddr6 == INTERVAL_REG_2_ADDR6));
       interval_reg_sel_36  = (write && (paddr6 == INTERVAL_REG_3_ADDR6));
       match_1_reg_sel_16   = (write && (paddr6 == MATCH_1_REG_1_ADDR6));
       match_1_reg_sel_26   = (write && (paddr6 == MATCH_1_REG_2_ADDR6));
       match_1_reg_sel_36   = (write && (paddr6 == MATCH_1_REG_3_ADDR6));
       match_2_reg_sel_16   = (write && (paddr6 == MATCH_2_REG_1_ADDR6));
       match_2_reg_sel_26   = (write && (paddr6 == MATCH_2_REG_2_ADDR6));
       match_2_reg_sel_36   = (write && (paddr6 == MATCH_2_REG_3_ADDR6));
       match_3_reg_sel_16   = (write && (paddr6 == MATCH_3_REG_1_ADDR6));
       match_3_reg_sel_26   = (write && (paddr6 == MATCH_3_REG_2_ADDR6));
       match_3_reg_sel_36   = (write && (paddr6 == MATCH_3_REG_3_ADDR6));
       intr_en_reg_sel6[1]  = (write && (paddr6 == IRQ_EN_REG_1_ADDR6));
       intr_en_reg_sel6[2]  = (write && (paddr6 == IRQ_EN_REG_2_ADDR6));
       intr_en_reg_sel6[3]  = (write && (paddr6 == IRQ_EN_REG_3_ADDR6));      
   end  //p_write_sel6
    

//    p_read_sel6: Process6 to enable the read operation6 to occur6.

   always @ (posedge pclk6 or negedge n_p_reset6)
   begin: p_read_sel6

      if (!n_p_reset6)                                   
      begin                                     
         prdata6 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr6)

               CLK_CTRL_REG_1_ADDR6 : prdata6 <= {25'h0000000,clk_ctrl_reg_16};
               CLK_CTRL_REG_2_ADDR6 : prdata6 <= {25'h0000000,clk_ctrl_reg_26};
               CLK_CTRL_REG_3_ADDR6 : prdata6 <= {25'h0000000,clk_ctrl_reg_36};
               CNTR_CTRL_REG_1_ADDR6: prdata6 <= {25'h0000000,cntr_ctrl_reg_16};
               CNTR_CTRL_REG_2_ADDR6: prdata6 <= {25'h0000000,cntr_ctrl_reg_26};
               CNTR_CTRL_REG_3_ADDR6: prdata6 <= {25'h0000000,cntr_ctrl_reg_36};
               CNTR_VAL_REG_1_ADDR6 : prdata6 <= {16'h0000,counter_val_reg_16};
               CNTR_VAL_REG_2_ADDR6 : prdata6 <= {16'h0000,counter_val_reg_26};
               CNTR_VAL_REG_3_ADDR6 : prdata6 <= {16'h0000,counter_val_reg_36};
               INTERVAL_REG_1_ADDR6 : prdata6 <= {16'h0000,interval_reg_16};
               INTERVAL_REG_2_ADDR6 : prdata6 <= {16'h0000,interval_reg_26};
               INTERVAL_REG_3_ADDR6 : prdata6 <= {16'h0000,interval_reg_36};
               MATCH_1_REG_1_ADDR6  : prdata6 <= {16'h0000,match_1_reg_16};
               MATCH_1_REG_2_ADDR6  : prdata6 <= {16'h0000,match_1_reg_26};
               MATCH_1_REG_3_ADDR6  : prdata6 <= {16'h0000,match_1_reg_36};
               MATCH_2_REG_1_ADDR6  : prdata6 <= {16'h0000,match_2_reg_16};
               MATCH_2_REG_2_ADDR6  : prdata6 <= {16'h0000,match_2_reg_26};
               MATCH_2_REG_3_ADDR6  : prdata6 <= {16'h0000,match_2_reg_36};
               MATCH_3_REG_1_ADDR6  : prdata6 <= {16'h0000,match_3_reg_16};
               MATCH_3_REG_2_ADDR6  : prdata6 <= {16'h0000,match_3_reg_26};
               MATCH_3_REG_3_ADDR6  : prdata6 <= {16'h0000,match_3_reg_36};
               IRQ_REG_1_ADDR6      : prdata6 <= {26'h0000,interrupt_reg_16};
               IRQ_REG_2_ADDR6      : prdata6 <= {26'h0000,interrupt_reg_26};
               IRQ_REG_3_ADDR6      : prdata6 <= {26'h0000,interrupt_reg_36};
               IRQ_EN_REG_1_ADDR6   : prdata6 <= {26'h0000,interrupt_en_reg_16};
               IRQ_EN_REG_2_ADDR6   : prdata6 <= {26'h0000,interrupt_en_reg_26};
               IRQ_EN_REG_3_ADDR6   : prdata6 <= {26'h0000,interrupt_en_reg_36};
               default             : prdata6 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata6 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset6)
      
   end // block: p_read_sel6

endmodule

