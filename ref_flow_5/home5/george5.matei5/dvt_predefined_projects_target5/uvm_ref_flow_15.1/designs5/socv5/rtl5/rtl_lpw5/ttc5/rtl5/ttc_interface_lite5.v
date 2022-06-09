//File5 name   : ttc_interface_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : The APB5 interface with the triple5 timer5 counter
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module5 definition5
//----------------------------------------------------------------------------

module ttc_interface_lite5( 

  //inputs5
  n_p_reset5,    
  pclk5,                          
  psel5,
  penable5,
  pwrite5,
  paddr5,
  clk_ctrl_reg_15,
  clk_ctrl_reg_25,
  clk_ctrl_reg_35,
  cntr_ctrl_reg_15,
  cntr_ctrl_reg_25,
  cntr_ctrl_reg_35,
  counter_val_reg_15,
  counter_val_reg_25,
  counter_val_reg_35,
  interval_reg_15,
  match_1_reg_15,
  match_2_reg_15,
  match_3_reg_15,
  interval_reg_25,
  match_1_reg_25,
  match_2_reg_25,
  match_3_reg_25,
  interval_reg_35,
  match_1_reg_35,
  match_2_reg_35,
  match_3_reg_35,
  interrupt_reg_15,
  interrupt_reg_25,
  interrupt_reg_35,      
  interrupt_en_reg_15,
  interrupt_en_reg_25,
  interrupt_en_reg_35,
                  
  //outputs5
  prdata5,
  clk_ctrl_reg_sel_15,
  clk_ctrl_reg_sel_25,
  clk_ctrl_reg_sel_35,
  cntr_ctrl_reg_sel_15,
  cntr_ctrl_reg_sel_25,
  cntr_ctrl_reg_sel_35,
  interval_reg_sel_15,                            
  interval_reg_sel_25,                          
  interval_reg_sel_35,
  match_1_reg_sel_15,                          
  match_1_reg_sel_25,                          
  match_1_reg_sel_35,                
  match_2_reg_sel_15,                          
  match_2_reg_sel_25,
  match_2_reg_sel_35,
  match_3_reg_sel_15,                          
  match_3_reg_sel_25,                         
  match_3_reg_sel_35,
  intr_en_reg_sel5,
  clear_interrupt5        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS5
//----------------------------------------------------------------------------

   //inputs5
   input        n_p_reset5;              //reset signal5
   input        pclk5;                 //System5 Clock5
   input        psel5;                 //Select5 line
   input        penable5;              //Strobe5 line
   input        pwrite5;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr5;                //Address Bus5 register
   input [6:0]  clk_ctrl_reg_15;       //Clock5 Control5 reg for Timer_Counter5 1
   input [6:0]  cntr_ctrl_reg_15;      //Counter5 Control5 reg for Timer_Counter5 1
   input [6:0]  clk_ctrl_reg_25;       //Clock5 Control5 reg for Timer_Counter5 2
   input [6:0]  cntr_ctrl_reg_25;      //Counter5 Control5 reg for Timer5 Counter5 2
   input [6:0]  clk_ctrl_reg_35;       //Clock5 Control5 reg Timer_Counter5 3
   input [6:0]  cntr_ctrl_reg_35;      //Counter5 Control5 reg for Timer5 Counter5 3
   input [15:0] counter_val_reg_15;    //Counter5 Value from Timer_Counter5 1
   input [15:0] counter_val_reg_25;    //Counter5 Value from Timer_Counter5 2
   input [15:0] counter_val_reg_35;    //Counter5 Value from Timer_Counter5 3
   input [15:0] interval_reg_15;       //Interval5 reg value from Timer_Counter5 1
   input [15:0] match_1_reg_15;        //Match5 reg value from Timer_Counter5 
   input [15:0] match_2_reg_15;        //Match5 reg value from Timer_Counter5     
   input [15:0] match_3_reg_15;        //Match5 reg value from Timer_Counter5 
   input [15:0] interval_reg_25;       //Interval5 reg value from Timer_Counter5 2
   input [15:0] match_1_reg_25;        //Match5 reg value from Timer_Counter5     
   input [15:0] match_2_reg_25;        //Match5 reg value from Timer_Counter5     
   input [15:0] match_3_reg_25;        //Match5 reg value from Timer_Counter5 
   input [15:0] interval_reg_35;       //Interval5 reg value from Timer_Counter5 3
   input [15:0] match_1_reg_35;        //Match5 reg value from Timer_Counter5   
   input [15:0] match_2_reg_35;        //Match5 reg value from Timer_Counter5   
   input [15:0] match_3_reg_35;        //Match5 reg value from Timer_Counter5   
   input [5:0]  interrupt_reg_15;      //Interrupt5 Reg5 from Interrupt5 Module5 1
   input [5:0]  interrupt_reg_25;      //Interrupt5 Reg5 from Interrupt5 Module5 2
   input [5:0]  interrupt_reg_35;      //Interrupt5 Reg5 from Interrupt5 Module5 3
   input [5:0]  interrupt_en_reg_15;   //Interrupt5 Enable5 Reg5 from Intrpt5 Module5 1
   input [5:0]  interrupt_en_reg_25;   //Interrupt5 Enable5 Reg5 from Intrpt5 Module5 2
   input [5:0]  interrupt_en_reg_35;   //Interrupt5 Enable5 Reg5 from Intrpt5 Module5 3
   
   //outputs5
   output [31:0] prdata5;              //Read Data from the APB5 Interface5
   output clk_ctrl_reg_sel_15;         //Clock5 Control5 Reg5 Select5 TC_15 
   output clk_ctrl_reg_sel_25;         //Clock5 Control5 Reg5 Select5 TC_25 
   output clk_ctrl_reg_sel_35;         //Clock5 Control5 Reg5 Select5 TC_35 
   output cntr_ctrl_reg_sel_15;        //Counter5 Control5 Reg5 Select5 TC_15
   output cntr_ctrl_reg_sel_25;        //Counter5 Control5 Reg5 Select5 TC_25
   output cntr_ctrl_reg_sel_35;        //Counter5 Control5 Reg5 Select5 TC_35
   output interval_reg_sel_15;         //Interval5 Interrupt5 Reg5 Select5 TC_15 
   output interval_reg_sel_25;         //Interval5 Interrupt5 Reg5 Select5 TC_25 
   output interval_reg_sel_35;         //Interval5 Interrupt5 Reg5 Select5 TC_35 
   output match_1_reg_sel_15;          //Match5 Reg5 Select5 TC_15
   output match_1_reg_sel_25;          //Match5 Reg5 Select5 TC_25
   output match_1_reg_sel_35;          //Match5 Reg5 Select5 TC_35
   output match_2_reg_sel_15;          //Match5 Reg5 Select5 TC_15
   output match_2_reg_sel_25;          //Match5 Reg5 Select5 TC_25
   output match_2_reg_sel_35;          //Match5 Reg5 Select5 TC_35
   output match_3_reg_sel_15;          //Match5 Reg5 Select5 TC_15
   output match_3_reg_sel_25;          //Match5 Reg5 Select5 TC_25
   output match_3_reg_sel_35;          //Match5 Reg5 Select5 TC_35
   output [3:1] intr_en_reg_sel5;      //Interrupt5 Enable5 Reg5 Select5
   output [3:1] clear_interrupt5;      //Clear Interrupt5 line


//-----------------------------------------------------------------------------
// PARAMETER5 DECLARATIONS5
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR5   = 8'h00; //Clock5 control5 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR5   = 8'h04; //Clock5 control5 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR5   = 8'h08; //Clock5 control5 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR5  = 8'h0C; //Counter5 control5 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR5  = 8'h10; //Counter5 control5 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR5  = 8'h14; //Counter5 control5 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR5   = 8'h18; //Counter5 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR5   = 8'h1C; //Counter5 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR5   = 8'h20; //Counter5 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR5   = 8'h24; //Module5 1 interval5 address
   parameter   [7:0] INTERVAL_REG_2_ADDR5   = 8'h28; //Module5 2 interval5 address
   parameter   [7:0] INTERVAL_REG_3_ADDR5   = 8'h2C; //Module5 3 interval5 address
   parameter   [7:0] MATCH_1_REG_1_ADDR5    = 8'h30; //Module5 1 Match5 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR5    = 8'h34; //Module5 2 Match5 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR5    = 8'h38; //Module5 3 Match5 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR5    = 8'h3C; //Module5 1 Match5 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR5    = 8'h40; //Module5 2 Match5 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR5    = 8'h44; //Module5 3 Match5 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR5    = 8'h48; //Module5 1 Match5 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR5    = 8'h4C; //Module5 2 Match5 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR5    = 8'h50; //Module5 3 Match5 3 address
   parameter   [7:0] IRQ_REG_1_ADDR5        = 8'h54; //Interrupt5 register 1
   parameter   [7:0] IRQ_REG_2_ADDR5        = 8'h58; //Interrupt5 register 2
   parameter   [7:0] IRQ_REG_3_ADDR5        = 8'h5C; //Interrupt5 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR5     = 8'h60; //Interrupt5 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR5     = 8'h64; //Interrupt5 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR5     = 8'h68; //Interrupt5 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals5 & Registers5
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_15;         //Clock5 Control5 Reg5 Select5 TC_15
   reg clk_ctrl_reg_sel_25;         //Clock5 Control5 Reg5 Select5 TC_25 
   reg clk_ctrl_reg_sel_35;         //Clock5 Control5 Reg5 Select5 TC_35 
   reg cntr_ctrl_reg_sel_15;        //Counter5 Control5 Reg5 Select5 TC_15
   reg cntr_ctrl_reg_sel_25;        //Counter5 Control5 Reg5 Select5 TC_25
   reg cntr_ctrl_reg_sel_35;        //Counter5 Control5 Reg5 Select5 TC_35
   reg interval_reg_sel_15;         //Interval5 Interrupt5 Reg5 Select5 TC_15 
   reg interval_reg_sel_25;         //Interval5 Interrupt5 Reg5 Select5 TC_25
   reg interval_reg_sel_35;         //Interval5 Interrupt5 Reg5 Select5 TC_35
   reg match_1_reg_sel_15;          //Match5 Reg5 Select5 TC_15
   reg match_1_reg_sel_25;          //Match5 Reg5 Select5 TC_25
   reg match_1_reg_sel_35;          //Match5 Reg5 Select5 TC_35
   reg match_2_reg_sel_15;          //Match5 Reg5 Select5 TC_15
   reg match_2_reg_sel_25;          //Match5 Reg5 Select5 TC_25
   reg match_2_reg_sel_35;          //Match5 Reg5 Select5 TC_35
   reg match_3_reg_sel_15;          //Match5 Reg5 Select5 TC_15
   reg match_3_reg_sel_25;          //Match5 Reg5 Select5 TC_25
   reg match_3_reg_sel_35;          //Match5 Reg5 Select5 TC_35
   reg [3:1] intr_en_reg_sel5;      //Interrupt5 Enable5 1 Reg5 Select5
   reg [31:0] prdata5;              //APB5 read data
   
   wire [3:1] clear_interrupt5;     // 3-bit clear interrupt5 reg on read
   wire write;                     //APB5 write command  
   wire read;                      //APB5 read command    



   assign write = psel5 & penable5 & pwrite5;  
   assign read  = psel5 & ~pwrite5;  
   assign clear_interrupt5[1] = read & penable5 & (paddr5 == IRQ_REG_1_ADDR5);
   assign clear_interrupt5[2] = read & penable5 & (paddr5 == IRQ_REG_2_ADDR5);
   assign clear_interrupt5[3] = read & penable5 & (paddr5 == IRQ_REG_3_ADDR5);   
   
   //p_write_sel5: Process5 to select5 the required5 regs for write access.

   always @ (paddr5 or write)
   begin: p_write_sel5

       clk_ctrl_reg_sel_15  = (write && (paddr5 == CLK_CTRL_REG_1_ADDR5));
       clk_ctrl_reg_sel_25  = (write && (paddr5 == CLK_CTRL_REG_2_ADDR5));
       clk_ctrl_reg_sel_35  = (write && (paddr5 == CLK_CTRL_REG_3_ADDR5));
       cntr_ctrl_reg_sel_15 = (write && (paddr5 == CNTR_CTRL_REG_1_ADDR5));
       cntr_ctrl_reg_sel_25 = (write && (paddr5 == CNTR_CTRL_REG_2_ADDR5));
       cntr_ctrl_reg_sel_35 = (write && (paddr5 == CNTR_CTRL_REG_3_ADDR5));
       interval_reg_sel_15  = (write && (paddr5 == INTERVAL_REG_1_ADDR5));
       interval_reg_sel_25  = (write && (paddr5 == INTERVAL_REG_2_ADDR5));
       interval_reg_sel_35  = (write && (paddr5 == INTERVAL_REG_3_ADDR5));
       match_1_reg_sel_15   = (write && (paddr5 == MATCH_1_REG_1_ADDR5));
       match_1_reg_sel_25   = (write && (paddr5 == MATCH_1_REG_2_ADDR5));
       match_1_reg_sel_35   = (write && (paddr5 == MATCH_1_REG_3_ADDR5));
       match_2_reg_sel_15   = (write && (paddr5 == MATCH_2_REG_1_ADDR5));
       match_2_reg_sel_25   = (write && (paddr5 == MATCH_2_REG_2_ADDR5));
       match_2_reg_sel_35   = (write && (paddr5 == MATCH_2_REG_3_ADDR5));
       match_3_reg_sel_15   = (write && (paddr5 == MATCH_3_REG_1_ADDR5));
       match_3_reg_sel_25   = (write && (paddr5 == MATCH_3_REG_2_ADDR5));
       match_3_reg_sel_35   = (write && (paddr5 == MATCH_3_REG_3_ADDR5));
       intr_en_reg_sel5[1]  = (write && (paddr5 == IRQ_EN_REG_1_ADDR5));
       intr_en_reg_sel5[2]  = (write && (paddr5 == IRQ_EN_REG_2_ADDR5));
       intr_en_reg_sel5[3]  = (write && (paddr5 == IRQ_EN_REG_3_ADDR5));      
   end  //p_write_sel5
    

//    p_read_sel5: Process5 to enable the read operation5 to occur5.

   always @ (posedge pclk5 or negedge n_p_reset5)
   begin: p_read_sel5

      if (!n_p_reset5)                                   
      begin                                     
         prdata5 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr5)

               CLK_CTRL_REG_1_ADDR5 : prdata5 <= {25'h0000000,clk_ctrl_reg_15};
               CLK_CTRL_REG_2_ADDR5 : prdata5 <= {25'h0000000,clk_ctrl_reg_25};
               CLK_CTRL_REG_3_ADDR5 : prdata5 <= {25'h0000000,clk_ctrl_reg_35};
               CNTR_CTRL_REG_1_ADDR5: prdata5 <= {25'h0000000,cntr_ctrl_reg_15};
               CNTR_CTRL_REG_2_ADDR5: prdata5 <= {25'h0000000,cntr_ctrl_reg_25};
               CNTR_CTRL_REG_3_ADDR5: prdata5 <= {25'h0000000,cntr_ctrl_reg_35};
               CNTR_VAL_REG_1_ADDR5 : prdata5 <= {16'h0000,counter_val_reg_15};
               CNTR_VAL_REG_2_ADDR5 : prdata5 <= {16'h0000,counter_val_reg_25};
               CNTR_VAL_REG_3_ADDR5 : prdata5 <= {16'h0000,counter_val_reg_35};
               INTERVAL_REG_1_ADDR5 : prdata5 <= {16'h0000,interval_reg_15};
               INTERVAL_REG_2_ADDR5 : prdata5 <= {16'h0000,interval_reg_25};
               INTERVAL_REG_3_ADDR5 : prdata5 <= {16'h0000,interval_reg_35};
               MATCH_1_REG_1_ADDR5  : prdata5 <= {16'h0000,match_1_reg_15};
               MATCH_1_REG_2_ADDR5  : prdata5 <= {16'h0000,match_1_reg_25};
               MATCH_1_REG_3_ADDR5  : prdata5 <= {16'h0000,match_1_reg_35};
               MATCH_2_REG_1_ADDR5  : prdata5 <= {16'h0000,match_2_reg_15};
               MATCH_2_REG_2_ADDR5  : prdata5 <= {16'h0000,match_2_reg_25};
               MATCH_2_REG_3_ADDR5  : prdata5 <= {16'h0000,match_2_reg_35};
               MATCH_3_REG_1_ADDR5  : prdata5 <= {16'h0000,match_3_reg_15};
               MATCH_3_REG_2_ADDR5  : prdata5 <= {16'h0000,match_3_reg_25};
               MATCH_3_REG_3_ADDR5  : prdata5 <= {16'h0000,match_3_reg_35};
               IRQ_REG_1_ADDR5      : prdata5 <= {26'h0000,interrupt_reg_15};
               IRQ_REG_2_ADDR5      : prdata5 <= {26'h0000,interrupt_reg_25};
               IRQ_REG_3_ADDR5      : prdata5 <= {26'h0000,interrupt_reg_35};
               IRQ_EN_REG_1_ADDR5   : prdata5 <= {26'h0000,interrupt_en_reg_15};
               IRQ_EN_REG_2_ADDR5   : prdata5 <= {26'h0000,interrupt_en_reg_25};
               IRQ_EN_REG_3_ADDR5   : prdata5 <= {26'h0000,interrupt_en_reg_35};
               default             : prdata5 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata5 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset5)
      
   end // block: p_read_sel5

endmodule

