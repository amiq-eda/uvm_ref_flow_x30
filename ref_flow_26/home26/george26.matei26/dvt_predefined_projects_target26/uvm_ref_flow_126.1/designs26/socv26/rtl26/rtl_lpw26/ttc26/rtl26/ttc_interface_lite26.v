//File26 name   : ttc_interface_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : The APB26 interface with the triple26 timer26 counter
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module26 definition26
//----------------------------------------------------------------------------

module ttc_interface_lite26( 

  //inputs26
  n_p_reset26,    
  pclk26,                          
  psel26,
  penable26,
  pwrite26,
  paddr26,
  clk_ctrl_reg_126,
  clk_ctrl_reg_226,
  clk_ctrl_reg_326,
  cntr_ctrl_reg_126,
  cntr_ctrl_reg_226,
  cntr_ctrl_reg_326,
  counter_val_reg_126,
  counter_val_reg_226,
  counter_val_reg_326,
  interval_reg_126,
  match_1_reg_126,
  match_2_reg_126,
  match_3_reg_126,
  interval_reg_226,
  match_1_reg_226,
  match_2_reg_226,
  match_3_reg_226,
  interval_reg_326,
  match_1_reg_326,
  match_2_reg_326,
  match_3_reg_326,
  interrupt_reg_126,
  interrupt_reg_226,
  interrupt_reg_326,      
  interrupt_en_reg_126,
  interrupt_en_reg_226,
  interrupt_en_reg_326,
                  
  //outputs26
  prdata26,
  clk_ctrl_reg_sel_126,
  clk_ctrl_reg_sel_226,
  clk_ctrl_reg_sel_326,
  cntr_ctrl_reg_sel_126,
  cntr_ctrl_reg_sel_226,
  cntr_ctrl_reg_sel_326,
  interval_reg_sel_126,                            
  interval_reg_sel_226,                          
  interval_reg_sel_326,
  match_1_reg_sel_126,                          
  match_1_reg_sel_226,                          
  match_1_reg_sel_326,                
  match_2_reg_sel_126,                          
  match_2_reg_sel_226,
  match_2_reg_sel_326,
  match_3_reg_sel_126,                          
  match_3_reg_sel_226,                         
  match_3_reg_sel_326,
  intr_en_reg_sel26,
  clear_interrupt26        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS26
//----------------------------------------------------------------------------

   //inputs26
   input        n_p_reset26;              //reset signal26
   input        pclk26;                 //System26 Clock26
   input        psel26;                 //Select26 line
   input        penable26;              //Strobe26 line
   input        pwrite26;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr26;                //Address Bus26 register
   input [6:0]  clk_ctrl_reg_126;       //Clock26 Control26 reg for Timer_Counter26 1
   input [6:0]  cntr_ctrl_reg_126;      //Counter26 Control26 reg for Timer_Counter26 1
   input [6:0]  clk_ctrl_reg_226;       //Clock26 Control26 reg for Timer_Counter26 2
   input [6:0]  cntr_ctrl_reg_226;      //Counter26 Control26 reg for Timer26 Counter26 2
   input [6:0]  clk_ctrl_reg_326;       //Clock26 Control26 reg Timer_Counter26 3
   input [6:0]  cntr_ctrl_reg_326;      //Counter26 Control26 reg for Timer26 Counter26 3
   input [15:0] counter_val_reg_126;    //Counter26 Value from Timer_Counter26 1
   input [15:0] counter_val_reg_226;    //Counter26 Value from Timer_Counter26 2
   input [15:0] counter_val_reg_326;    //Counter26 Value from Timer_Counter26 3
   input [15:0] interval_reg_126;       //Interval26 reg value from Timer_Counter26 1
   input [15:0] match_1_reg_126;        //Match26 reg value from Timer_Counter26 
   input [15:0] match_2_reg_126;        //Match26 reg value from Timer_Counter26     
   input [15:0] match_3_reg_126;        //Match26 reg value from Timer_Counter26 
   input [15:0] interval_reg_226;       //Interval26 reg value from Timer_Counter26 2
   input [15:0] match_1_reg_226;        //Match26 reg value from Timer_Counter26     
   input [15:0] match_2_reg_226;        //Match26 reg value from Timer_Counter26     
   input [15:0] match_3_reg_226;        //Match26 reg value from Timer_Counter26 
   input [15:0] interval_reg_326;       //Interval26 reg value from Timer_Counter26 3
   input [15:0] match_1_reg_326;        //Match26 reg value from Timer_Counter26   
   input [15:0] match_2_reg_326;        //Match26 reg value from Timer_Counter26   
   input [15:0] match_3_reg_326;        //Match26 reg value from Timer_Counter26   
   input [5:0]  interrupt_reg_126;      //Interrupt26 Reg26 from Interrupt26 Module26 1
   input [5:0]  interrupt_reg_226;      //Interrupt26 Reg26 from Interrupt26 Module26 2
   input [5:0]  interrupt_reg_326;      //Interrupt26 Reg26 from Interrupt26 Module26 3
   input [5:0]  interrupt_en_reg_126;   //Interrupt26 Enable26 Reg26 from Intrpt26 Module26 1
   input [5:0]  interrupt_en_reg_226;   //Interrupt26 Enable26 Reg26 from Intrpt26 Module26 2
   input [5:0]  interrupt_en_reg_326;   //Interrupt26 Enable26 Reg26 from Intrpt26 Module26 3
   
   //outputs26
   output [31:0] prdata26;              //Read Data from the APB26 Interface26
   output clk_ctrl_reg_sel_126;         //Clock26 Control26 Reg26 Select26 TC_126 
   output clk_ctrl_reg_sel_226;         //Clock26 Control26 Reg26 Select26 TC_226 
   output clk_ctrl_reg_sel_326;         //Clock26 Control26 Reg26 Select26 TC_326 
   output cntr_ctrl_reg_sel_126;        //Counter26 Control26 Reg26 Select26 TC_126
   output cntr_ctrl_reg_sel_226;        //Counter26 Control26 Reg26 Select26 TC_226
   output cntr_ctrl_reg_sel_326;        //Counter26 Control26 Reg26 Select26 TC_326
   output interval_reg_sel_126;         //Interval26 Interrupt26 Reg26 Select26 TC_126 
   output interval_reg_sel_226;         //Interval26 Interrupt26 Reg26 Select26 TC_226 
   output interval_reg_sel_326;         //Interval26 Interrupt26 Reg26 Select26 TC_326 
   output match_1_reg_sel_126;          //Match26 Reg26 Select26 TC_126
   output match_1_reg_sel_226;          //Match26 Reg26 Select26 TC_226
   output match_1_reg_sel_326;          //Match26 Reg26 Select26 TC_326
   output match_2_reg_sel_126;          //Match26 Reg26 Select26 TC_126
   output match_2_reg_sel_226;          //Match26 Reg26 Select26 TC_226
   output match_2_reg_sel_326;          //Match26 Reg26 Select26 TC_326
   output match_3_reg_sel_126;          //Match26 Reg26 Select26 TC_126
   output match_3_reg_sel_226;          //Match26 Reg26 Select26 TC_226
   output match_3_reg_sel_326;          //Match26 Reg26 Select26 TC_326
   output [3:1] intr_en_reg_sel26;      //Interrupt26 Enable26 Reg26 Select26
   output [3:1] clear_interrupt26;      //Clear Interrupt26 line


//-----------------------------------------------------------------------------
// PARAMETER26 DECLARATIONS26
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR26   = 8'h00; //Clock26 control26 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR26   = 8'h04; //Clock26 control26 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR26   = 8'h08; //Clock26 control26 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR26  = 8'h0C; //Counter26 control26 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR26  = 8'h10; //Counter26 control26 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR26  = 8'h14; //Counter26 control26 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR26   = 8'h18; //Counter26 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR26   = 8'h1C; //Counter26 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR26   = 8'h20; //Counter26 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR26   = 8'h24; //Module26 1 interval26 address
   parameter   [7:0] INTERVAL_REG_2_ADDR26   = 8'h28; //Module26 2 interval26 address
   parameter   [7:0] INTERVAL_REG_3_ADDR26   = 8'h2C; //Module26 3 interval26 address
   parameter   [7:0] MATCH_1_REG_1_ADDR26    = 8'h30; //Module26 1 Match26 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR26    = 8'h34; //Module26 2 Match26 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR26    = 8'h38; //Module26 3 Match26 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR26    = 8'h3C; //Module26 1 Match26 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR26    = 8'h40; //Module26 2 Match26 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR26    = 8'h44; //Module26 3 Match26 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR26    = 8'h48; //Module26 1 Match26 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR26    = 8'h4C; //Module26 2 Match26 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR26    = 8'h50; //Module26 3 Match26 3 address
   parameter   [7:0] IRQ_REG_1_ADDR26        = 8'h54; //Interrupt26 register 1
   parameter   [7:0] IRQ_REG_2_ADDR26        = 8'h58; //Interrupt26 register 2
   parameter   [7:0] IRQ_REG_3_ADDR26        = 8'h5C; //Interrupt26 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR26     = 8'h60; //Interrupt26 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR26     = 8'h64; //Interrupt26 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR26     = 8'h68; //Interrupt26 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals26 & Registers26
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_126;         //Clock26 Control26 Reg26 Select26 TC_126
   reg clk_ctrl_reg_sel_226;         //Clock26 Control26 Reg26 Select26 TC_226 
   reg clk_ctrl_reg_sel_326;         //Clock26 Control26 Reg26 Select26 TC_326 
   reg cntr_ctrl_reg_sel_126;        //Counter26 Control26 Reg26 Select26 TC_126
   reg cntr_ctrl_reg_sel_226;        //Counter26 Control26 Reg26 Select26 TC_226
   reg cntr_ctrl_reg_sel_326;        //Counter26 Control26 Reg26 Select26 TC_326
   reg interval_reg_sel_126;         //Interval26 Interrupt26 Reg26 Select26 TC_126 
   reg interval_reg_sel_226;         //Interval26 Interrupt26 Reg26 Select26 TC_226
   reg interval_reg_sel_326;         //Interval26 Interrupt26 Reg26 Select26 TC_326
   reg match_1_reg_sel_126;          //Match26 Reg26 Select26 TC_126
   reg match_1_reg_sel_226;          //Match26 Reg26 Select26 TC_226
   reg match_1_reg_sel_326;          //Match26 Reg26 Select26 TC_326
   reg match_2_reg_sel_126;          //Match26 Reg26 Select26 TC_126
   reg match_2_reg_sel_226;          //Match26 Reg26 Select26 TC_226
   reg match_2_reg_sel_326;          //Match26 Reg26 Select26 TC_326
   reg match_3_reg_sel_126;          //Match26 Reg26 Select26 TC_126
   reg match_3_reg_sel_226;          //Match26 Reg26 Select26 TC_226
   reg match_3_reg_sel_326;          //Match26 Reg26 Select26 TC_326
   reg [3:1] intr_en_reg_sel26;      //Interrupt26 Enable26 1 Reg26 Select26
   reg [31:0] prdata26;              //APB26 read data
   
   wire [3:1] clear_interrupt26;     // 3-bit clear interrupt26 reg on read
   wire write;                     //APB26 write command  
   wire read;                      //APB26 read command    



   assign write = psel26 & penable26 & pwrite26;  
   assign read  = psel26 & ~pwrite26;  
   assign clear_interrupt26[1] = read & penable26 & (paddr26 == IRQ_REG_1_ADDR26);
   assign clear_interrupt26[2] = read & penable26 & (paddr26 == IRQ_REG_2_ADDR26);
   assign clear_interrupt26[3] = read & penable26 & (paddr26 == IRQ_REG_3_ADDR26);   
   
   //p_write_sel26: Process26 to select26 the required26 regs for write access.

   always @ (paddr26 or write)
   begin: p_write_sel26

       clk_ctrl_reg_sel_126  = (write && (paddr26 == CLK_CTRL_REG_1_ADDR26));
       clk_ctrl_reg_sel_226  = (write && (paddr26 == CLK_CTRL_REG_2_ADDR26));
       clk_ctrl_reg_sel_326  = (write && (paddr26 == CLK_CTRL_REG_3_ADDR26));
       cntr_ctrl_reg_sel_126 = (write && (paddr26 == CNTR_CTRL_REG_1_ADDR26));
       cntr_ctrl_reg_sel_226 = (write && (paddr26 == CNTR_CTRL_REG_2_ADDR26));
       cntr_ctrl_reg_sel_326 = (write && (paddr26 == CNTR_CTRL_REG_3_ADDR26));
       interval_reg_sel_126  = (write && (paddr26 == INTERVAL_REG_1_ADDR26));
       interval_reg_sel_226  = (write && (paddr26 == INTERVAL_REG_2_ADDR26));
       interval_reg_sel_326  = (write && (paddr26 == INTERVAL_REG_3_ADDR26));
       match_1_reg_sel_126   = (write && (paddr26 == MATCH_1_REG_1_ADDR26));
       match_1_reg_sel_226   = (write && (paddr26 == MATCH_1_REG_2_ADDR26));
       match_1_reg_sel_326   = (write && (paddr26 == MATCH_1_REG_3_ADDR26));
       match_2_reg_sel_126   = (write && (paddr26 == MATCH_2_REG_1_ADDR26));
       match_2_reg_sel_226   = (write && (paddr26 == MATCH_2_REG_2_ADDR26));
       match_2_reg_sel_326   = (write && (paddr26 == MATCH_2_REG_3_ADDR26));
       match_3_reg_sel_126   = (write && (paddr26 == MATCH_3_REG_1_ADDR26));
       match_3_reg_sel_226   = (write && (paddr26 == MATCH_3_REG_2_ADDR26));
       match_3_reg_sel_326   = (write && (paddr26 == MATCH_3_REG_3_ADDR26));
       intr_en_reg_sel26[1]  = (write && (paddr26 == IRQ_EN_REG_1_ADDR26));
       intr_en_reg_sel26[2]  = (write && (paddr26 == IRQ_EN_REG_2_ADDR26));
       intr_en_reg_sel26[3]  = (write && (paddr26 == IRQ_EN_REG_3_ADDR26));      
   end  //p_write_sel26
    

//    p_read_sel26: Process26 to enable the read operation26 to occur26.

   always @ (posedge pclk26 or negedge n_p_reset26)
   begin: p_read_sel26

      if (!n_p_reset26)                                   
      begin                                     
         prdata26 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr26)

               CLK_CTRL_REG_1_ADDR26 : prdata26 <= {25'h0000000,clk_ctrl_reg_126};
               CLK_CTRL_REG_2_ADDR26 : prdata26 <= {25'h0000000,clk_ctrl_reg_226};
               CLK_CTRL_REG_3_ADDR26 : prdata26 <= {25'h0000000,clk_ctrl_reg_326};
               CNTR_CTRL_REG_1_ADDR26: prdata26 <= {25'h0000000,cntr_ctrl_reg_126};
               CNTR_CTRL_REG_2_ADDR26: prdata26 <= {25'h0000000,cntr_ctrl_reg_226};
               CNTR_CTRL_REG_3_ADDR26: prdata26 <= {25'h0000000,cntr_ctrl_reg_326};
               CNTR_VAL_REG_1_ADDR26 : prdata26 <= {16'h0000,counter_val_reg_126};
               CNTR_VAL_REG_2_ADDR26 : prdata26 <= {16'h0000,counter_val_reg_226};
               CNTR_VAL_REG_3_ADDR26 : prdata26 <= {16'h0000,counter_val_reg_326};
               INTERVAL_REG_1_ADDR26 : prdata26 <= {16'h0000,interval_reg_126};
               INTERVAL_REG_2_ADDR26 : prdata26 <= {16'h0000,interval_reg_226};
               INTERVAL_REG_3_ADDR26 : prdata26 <= {16'h0000,interval_reg_326};
               MATCH_1_REG_1_ADDR26  : prdata26 <= {16'h0000,match_1_reg_126};
               MATCH_1_REG_2_ADDR26  : prdata26 <= {16'h0000,match_1_reg_226};
               MATCH_1_REG_3_ADDR26  : prdata26 <= {16'h0000,match_1_reg_326};
               MATCH_2_REG_1_ADDR26  : prdata26 <= {16'h0000,match_2_reg_126};
               MATCH_2_REG_2_ADDR26  : prdata26 <= {16'h0000,match_2_reg_226};
               MATCH_2_REG_3_ADDR26  : prdata26 <= {16'h0000,match_2_reg_326};
               MATCH_3_REG_1_ADDR26  : prdata26 <= {16'h0000,match_3_reg_126};
               MATCH_3_REG_2_ADDR26  : prdata26 <= {16'h0000,match_3_reg_226};
               MATCH_3_REG_3_ADDR26  : prdata26 <= {16'h0000,match_3_reg_326};
               IRQ_REG_1_ADDR26      : prdata26 <= {26'h0000,interrupt_reg_126};
               IRQ_REG_2_ADDR26      : prdata26 <= {26'h0000,interrupt_reg_226};
               IRQ_REG_3_ADDR26      : prdata26 <= {26'h0000,interrupt_reg_326};
               IRQ_EN_REG_1_ADDR26   : prdata26 <= {26'h0000,interrupt_en_reg_126};
               IRQ_EN_REG_2_ADDR26   : prdata26 <= {26'h0000,interrupt_en_reg_226};
               IRQ_EN_REG_3_ADDR26   : prdata26 <= {26'h0000,interrupt_en_reg_326};
               default             : prdata26 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata26 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset26)
      
   end // block: p_read_sel26

endmodule

