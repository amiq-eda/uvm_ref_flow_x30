//File17 name   : ttc_interface_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : The APB17 interface with the triple17 timer17 counter
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module17 definition17
//----------------------------------------------------------------------------

module ttc_interface_lite17( 

  //inputs17
  n_p_reset17,    
  pclk17,                          
  psel17,
  penable17,
  pwrite17,
  paddr17,
  clk_ctrl_reg_117,
  clk_ctrl_reg_217,
  clk_ctrl_reg_317,
  cntr_ctrl_reg_117,
  cntr_ctrl_reg_217,
  cntr_ctrl_reg_317,
  counter_val_reg_117,
  counter_val_reg_217,
  counter_val_reg_317,
  interval_reg_117,
  match_1_reg_117,
  match_2_reg_117,
  match_3_reg_117,
  interval_reg_217,
  match_1_reg_217,
  match_2_reg_217,
  match_3_reg_217,
  interval_reg_317,
  match_1_reg_317,
  match_2_reg_317,
  match_3_reg_317,
  interrupt_reg_117,
  interrupt_reg_217,
  interrupt_reg_317,      
  interrupt_en_reg_117,
  interrupt_en_reg_217,
  interrupt_en_reg_317,
                  
  //outputs17
  prdata17,
  clk_ctrl_reg_sel_117,
  clk_ctrl_reg_sel_217,
  clk_ctrl_reg_sel_317,
  cntr_ctrl_reg_sel_117,
  cntr_ctrl_reg_sel_217,
  cntr_ctrl_reg_sel_317,
  interval_reg_sel_117,                            
  interval_reg_sel_217,                          
  interval_reg_sel_317,
  match_1_reg_sel_117,                          
  match_1_reg_sel_217,                          
  match_1_reg_sel_317,                
  match_2_reg_sel_117,                          
  match_2_reg_sel_217,
  match_2_reg_sel_317,
  match_3_reg_sel_117,                          
  match_3_reg_sel_217,                         
  match_3_reg_sel_317,
  intr_en_reg_sel17,
  clear_interrupt17        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS17
//----------------------------------------------------------------------------

   //inputs17
   input        n_p_reset17;              //reset signal17
   input        pclk17;                 //System17 Clock17
   input        psel17;                 //Select17 line
   input        penable17;              //Strobe17 line
   input        pwrite17;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr17;                //Address Bus17 register
   input [6:0]  clk_ctrl_reg_117;       //Clock17 Control17 reg for Timer_Counter17 1
   input [6:0]  cntr_ctrl_reg_117;      //Counter17 Control17 reg for Timer_Counter17 1
   input [6:0]  clk_ctrl_reg_217;       //Clock17 Control17 reg for Timer_Counter17 2
   input [6:0]  cntr_ctrl_reg_217;      //Counter17 Control17 reg for Timer17 Counter17 2
   input [6:0]  clk_ctrl_reg_317;       //Clock17 Control17 reg Timer_Counter17 3
   input [6:0]  cntr_ctrl_reg_317;      //Counter17 Control17 reg for Timer17 Counter17 3
   input [15:0] counter_val_reg_117;    //Counter17 Value from Timer_Counter17 1
   input [15:0] counter_val_reg_217;    //Counter17 Value from Timer_Counter17 2
   input [15:0] counter_val_reg_317;    //Counter17 Value from Timer_Counter17 3
   input [15:0] interval_reg_117;       //Interval17 reg value from Timer_Counter17 1
   input [15:0] match_1_reg_117;        //Match17 reg value from Timer_Counter17 
   input [15:0] match_2_reg_117;        //Match17 reg value from Timer_Counter17     
   input [15:0] match_3_reg_117;        //Match17 reg value from Timer_Counter17 
   input [15:0] interval_reg_217;       //Interval17 reg value from Timer_Counter17 2
   input [15:0] match_1_reg_217;        //Match17 reg value from Timer_Counter17     
   input [15:0] match_2_reg_217;        //Match17 reg value from Timer_Counter17     
   input [15:0] match_3_reg_217;        //Match17 reg value from Timer_Counter17 
   input [15:0] interval_reg_317;       //Interval17 reg value from Timer_Counter17 3
   input [15:0] match_1_reg_317;        //Match17 reg value from Timer_Counter17   
   input [15:0] match_2_reg_317;        //Match17 reg value from Timer_Counter17   
   input [15:0] match_3_reg_317;        //Match17 reg value from Timer_Counter17   
   input [5:0]  interrupt_reg_117;      //Interrupt17 Reg17 from Interrupt17 Module17 1
   input [5:0]  interrupt_reg_217;      //Interrupt17 Reg17 from Interrupt17 Module17 2
   input [5:0]  interrupt_reg_317;      //Interrupt17 Reg17 from Interrupt17 Module17 3
   input [5:0]  interrupt_en_reg_117;   //Interrupt17 Enable17 Reg17 from Intrpt17 Module17 1
   input [5:0]  interrupt_en_reg_217;   //Interrupt17 Enable17 Reg17 from Intrpt17 Module17 2
   input [5:0]  interrupt_en_reg_317;   //Interrupt17 Enable17 Reg17 from Intrpt17 Module17 3
   
   //outputs17
   output [31:0] prdata17;              //Read Data from the APB17 Interface17
   output clk_ctrl_reg_sel_117;         //Clock17 Control17 Reg17 Select17 TC_117 
   output clk_ctrl_reg_sel_217;         //Clock17 Control17 Reg17 Select17 TC_217 
   output clk_ctrl_reg_sel_317;         //Clock17 Control17 Reg17 Select17 TC_317 
   output cntr_ctrl_reg_sel_117;        //Counter17 Control17 Reg17 Select17 TC_117
   output cntr_ctrl_reg_sel_217;        //Counter17 Control17 Reg17 Select17 TC_217
   output cntr_ctrl_reg_sel_317;        //Counter17 Control17 Reg17 Select17 TC_317
   output interval_reg_sel_117;         //Interval17 Interrupt17 Reg17 Select17 TC_117 
   output interval_reg_sel_217;         //Interval17 Interrupt17 Reg17 Select17 TC_217 
   output interval_reg_sel_317;         //Interval17 Interrupt17 Reg17 Select17 TC_317 
   output match_1_reg_sel_117;          //Match17 Reg17 Select17 TC_117
   output match_1_reg_sel_217;          //Match17 Reg17 Select17 TC_217
   output match_1_reg_sel_317;          //Match17 Reg17 Select17 TC_317
   output match_2_reg_sel_117;          //Match17 Reg17 Select17 TC_117
   output match_2_reg_sel_217;          //Match17 Reg17 Select17 TC_217
   output match_2_reg_sel_317;          //Match17 Reg17 Select17 TC_317
   output match_3_reg_sel_117;          //Match17 Reg17 Select17 TC_117
   output match_3_reg_sel_217;          //Match17 Reg17 Select17 TC_217
   output match_3_reg_sel_317;          //Match17 Reg17 Select17 TC_317
   output [3:1] intr_en_reg_sel17;      //Interrupt17 Enable17 Reg17 Select17
   output [3:1] clear_interrupt17;      //Clear Interrupt17 line


//-----------------------------------------------------------------------------
// PARAMETER17 DECLARATIONS17
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR17   = 8'h00; //Clock17 control17 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR17   = 8'h04; //Clock17 control17 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR17   = 8'h08; //Clock17 control17 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR17  = 8'h0C; //Counter17 control17 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR17  = 8'h10; //Counter17 control17 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR17  = 8'h14; //Counter17 control17 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR17   = 8'h18; //Counter17 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR17   = 8'h1C; //Counter17 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR17   = 8'h20; //Counter17 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR17   = 8'h24; //Module17 1 interval17 address
   parameter   [7:0] INTERVAL_REG_2_ADDR17   = 8'h28; //Module17 2 interval17 address
   parameter   [7:0] INTERVAL_REG_3_ADDR17   = 8'h2C; //Module17 3 interval17 address
   parameter   [7:0] MATCH_1_REG_1_ADDR17    = 8'h30; //Module17 1 Match17 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR17    = 8'h34; //Module17 2 Match17 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR17    = 8'h38; //Module17 3 Match17 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR17    = 8'h3C; //Module17 1 Match17 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR17    = 8'h40; //Module17 2 Match17 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR17    = 8'h44; //Module17 3 Match17 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR17    = 8'h48; //Module17 1 Match17 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR17    = 8'h4C; //Module17 2 Match17 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR17    = 8'h50; //Module17 3 Match17 3 address
   parameter   [7:0] IRQ_REG_1_ADDR17        = 8'h54; //Interrupt17 register 1
   parameter   [7:0] IRQ_REG_2_ADDR17        = 8'h58; //Interrupt17 register 2
   parameter   [7:0] IRQ_REG_3_ADDR17        = 8'h5C; //Interrupt17 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR17     = 8'h60; //Interrupt17 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR17     = 8'h64; //Interrupt17 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR17     = 8'h68; //Interrupt17 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals17 & Registers17
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_117;         //Clock17 Control17 Reg17 Select17 TC_117
   reg clk_ctrl_reg_sel_217;         //Clock17 Control17 Reg17 Select17 TC_217 
   reg clk_ctrl_reg_sel_317;         //Clock17 Control17 Reg17 Select17 TC_317 
   reg cntr_ctrl_reg_sel_117;        //Counter17 Control17 Reg17 Select17 TC_117
   reg cntr_ctrl_reg_sel_217;        //Counter17 Control17 Reg17 Select17 TC_217
   reg cntr_ctrl_reg_sel_317;        //Counter17 Control17 Reg17 Select17 TC_317
   reg interval_reg_sel_117;         //Interval17 Interrupt17 Reg17 Select17 TC_117 
   reg interval_reg_sel_217;         //Interval17 Interrupt17 Reg17 Select17 TC_217
   reg interval_reg_sel_317;         //Interval17 Interrupt17 Reg17 Select17 TC_317
   reg match_1_reg_sel_117;          //Match17 Reg17 Select17 TC_117
   reg match_1_reg_sel_217;          //Match17 Reg17 Select17 TC_217
   reg match_1_reg_sel_317;          //Match17 Reg17 Select17 TC_317
   reg match_2_reg_sel_117;          //Match17 Reg17 Select17 TC_117
   reg match_2_reg_sel_217;          //Match17 Reg17 Select17 TC_217
   reg match_2_reg_sel_317;          //Match17 Reg17 Select17 TC_317
   reg match_3_reg_sel_117;          //Match17 Reg17 Select17 TC_117
   reg match_3_reg_sel_217;          //Match17 Reg17 Select17 TC_217
   reg match_3_reg_sel_317;          //Match17 Reg17 Select17 TC_317
   reg [3:1] intr_en_reg_sel17;      //Interrupt17 Enable17 1 Reg17 Select17
   reg [31:0] prdata17;              //APB17 read data
   
   wire [3:1] clear_interrupt17;     // 3-bit clear interrupt17 reg on read
   wire write;                     //APB17 write command  
   wire read;                      //APB17 read command    



   assign write = psel17 & penable17 & pwrite17;  
   assign read  = psel17 & ~pwrite17;  
   assign clear_interrupt17[1] = read & penable17 & (paddr17 == IRQ_REG_1_ADDR17);
   assign clear_interrupt17[2] = read & penable17 & (paddr17 == IRQ_REG_2_ADDR17);
   assign clear_interrupt17[3] = read & penable17 & (paddr17 == IRQ_REG_3_ADDR17);   
   
   //p_write_sel17: Process17 to select17 the required17 regs for write access.

   always @ (paddr17 or write)
   begin: p_write_sel17

       clk_ctrl_reg_sel_117  = (write && (paddr17 == CLK_CTRL_REG_1_ADDR17));
       clk_ctrl_reg_sel_217  = (write && (paddr17 == CLK_CTRL_REG_2_ADDR17));
       clk_ctrl_reg_sel_317  = (write && (paddr17 == CLK_CTRL_REG_3_ADDR17));
       cntr_ctrl_reg_sel_117 = (write && (paddr17 == CNTR_CTRL_REG_1_ADDR17));
       cntr_ctrl_reg_sel_217 = (write && (paddr17 == CNTR_CTRL_REG_2_ADDR17));
       cntr_ctrl_reg_sel_317 = (write && (paddr17 == CNTR_CTRL_REG_3_ADDR17));
       interval_reg_sel_117  = (write && (paddr17 == INTERVAL_REG_1_ADDR17));
       interval_reg_sel_217  = (write && (paddr17 == INTERVAL_REG_2_ADDR17));
       interval_reg_sel_317  = (write && (paddr17 == INTERVAL_REG_3_ADDR17));
       match_1_reg_sel_117   = (write && (paddr17 == MATCH_1_REG_1_ADDR17));
       match_1_reg_sel_217   = (write && (paddr17 == MATCH_1_REG_2_ADDR17));
       match_1_reg_sel_317   = (write && (paddr17 == MATCH_1_REG_3_ADDR17));
       match_2_reg_sel_117   = (write && (paddr17 == MATCH_2_REG_1_ADDR17));
       match_2_reg_sel_217   = (write && (paddr17 == MATCH_2_REG_2_ADDR17));
       match_2_reg_sel_317   = (write && (paddr17 == MATCH_2_REG_3_ADDR17));
       match_3_reg_sel_117   = (write && (paddr17 == MATCH_3_REG_1_ADDR17));
       match_3_reg_sel_217   = (write && (paddr17 == MATCH_3_REG_2_ADDR17));
       match_3_reg_sel_317   = (write && (paddr17 == MATCH_3_REG_3_ADDR17));
       intr_en_reg_sel17[1]  = (write && (paddr17 == IRQ_EN_REG_1_ADDR17));
       intr_en_reg_sel17[2]  = (write && (paddr17 == IRQ_EN_REG_2_ADDR17));
       intr_en_reg_sel17[3]  = (write && (paddr17 == IRQ_EN_REG_3_ADDR17));      
   end  //p_write_sel17
    

//    p_read_sel17: Process17 to enable the read operation17 to occur17.

   always @ (posedge pclk17 or negedge n_p_reset17)
   begin: p_read_sel17

      if (!n_p_reset17)                                   
      begin                                     
         prdata17 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr17)

               CLK_CTRL_REG_1_ADDR17 : prdata17 <= {25'h0000000,clk_ctrl_reg_117};
               CLK_CTRL_REG_2_ADDR17 : prdata17 <= {25'h0000000,clk_ctrl_reg_217};
               CLK_CTRL_REG_3_ADDR17 : prdata17 <= {25'h0000000,clk_ctrl_reg_317};
               CNTR_CTRL_REG_1_ADDR17: prdata17 <= {25'h0000000,cntr_ctrl_reg_117};
               CNTR_CTRL_REG_2_ADDR17: prdata17 <= {25'h0000000,cntr_ctrl_reg_217};
               CNTR_CTRL_REG_3_ADDR17: prdata17 <= {25'h0000000,cntr_ctrl_reg_317};
               CNTR_VAL_REG_1_ADDR17 : prdata17 <= {16'h0000,counter_val_reg_117};
               CNTR_VAL_REG_2_ADDR17 : prdata17 <= {16'h0000,counter_val_reg_217};
               CNTR_VAL_REG_3_ADDR17 : prdata17 <= {16'h0000,counter_val_reg_317};
               INTERVAL_REG_1_ADDR17 : prdata17 <= {16'h0000,interval_reg_117};
               INTERVAL_REG_2_ADDR17 : prdata17 <= {16'h0000,interval_reg_217};
               INTERVAL_REG_3_ADDR17 : prdata17 <= {16'h0000,interval_reg_317};
               MATCH_1_REG_1_ADDR17  : prdata17 <= {16'h0000,match_1_reg_117};
               MATCH_1_REG_2_ADDR17  : prdata17 <= {16'h0000,match_1_reg_217};
               MATCH_1_REG_3_ADDR17  : prdata17 <= {16'h0000,match_1_reg_317};
               MATCH_2_REG_1_ADDR17  : prdata17 <= {16'h0000,match_2_reg_117};
               MATCH_2_REG_2_ADDR17  : prdata17 <= {16'h0000,match_2_reg_217};
               MATCH_2_REG_3_ADDR17  : prdata17 <= {16'h0000,match_2_reg_317};
               MATCH_3_REG_1_ADDR17  : prdata17 <= {16'h0000,match_3_reg_117};
               MATCH_3_REG_2_ADDR17  : prdata17 <= {16'h0000,match_3_reg_217};
               MATCH_3_REG_3_ADDR17  : prdata17 <= {16'h0000,match_3_reg_317};
               IRQ_REG_1_ADDR17      : prdata17 <= {26'h0000,interrupt_reg_117};
               IRQ_REG_2_ADDR17      : prdata17 <= {26'h0000,interrupt_reg_217};
               IRQ_REG_3_ADDR17      : prdata17 <= {26'h0000,interrupt_reg_317};
               IRQ_EN_REG_1_ADDR17   : prdata17 <= {26'h0000,interrupt_en_reg_117};
               IRQ_EN_REG_2_ADDR17   : prdata17 <= {26'h0000,interrupt_en_reg_217};
               IRQ_EN_REG_3_ADDR17   : prdata17 <= {26'h0000,interrupt_en_reg_317};
               default             : prdata17 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata17 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset17)
      
   end // block: p_read_sel17

endmodule

