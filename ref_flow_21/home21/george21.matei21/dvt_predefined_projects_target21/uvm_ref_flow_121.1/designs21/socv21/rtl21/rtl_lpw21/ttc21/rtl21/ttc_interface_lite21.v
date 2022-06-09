//File21 name   : ttc_interface_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : The APB21 interface with the triple21 timer21 counter
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
//


//----------------------------------------------------------------------------
// Module21 definition21
//----------------------------------------------------------------------------

module ttc_interface_lite21( 

  //inputs21
  n_p_reset21,    
  pclk21,                          
  psel21,
  penable21,
  pwrite21,
  paddr21,
  clk_ctrl_reg_121,
  clk_ctrl_reg_221,
  clk_ctrl_reg_321,
  cntr_ctrl_reg_121,
  cntr_ctrl_reg_221,
  cntr_ctrl_reg_321,
  counter_val_reg_121,
  counter_val_reg_221,
  counter_val_reg_321,
  interval_reg_121,
  match_1_reg_121,
  match_2_reg_121,
  match_3_reg_121,
  interval_reg_221,
  match_1_reg_221,
  match_2_reg_221,
  match_3_reg_221,
  interval_reg_321,
  match_1_reg_321,
  match_2_reg_321,
  match_3_reg_321,
  interrupt_reg_121,
  interrupt_reg_221,
  interrupt_reg_321,      
  interrupt_en_reg_121,
  interrupt_en_reg_221,
  interrupt_en_reg_321,
                  
  //outputs21
  prdata21,
  clk_ctrl_reg_sel_121,
  clk_ctrl_reg_sel_221,
  clk_ctrl_reg_sel_321,
  cntr_ctrl_reg_sel_121,
  cntr_ctrl_reg_sel_221,
  cntr_ctrl_reg_sel_321,
  interval_reg_sel_121,                            
  interval_reg_sel_221,                          
  interval_reg_sel_321,
  match_1_reg_sel_121,                          
  match_1_reg_sel_221,                          
  match_1_reg_sel_321,                
  match_2_reg_sel_121,                          
  match_2_reg_sel_221,
  match_2_reg_sel_321,
  match_3_reg_sel_121,                          
  match_3_reg_sel_221,                         
  match_3_reg_sel_321,
  intr_en_reg_sel21,
  clear_interrupt21        
                  
);


//----------------------------------------------------------------------------
// PORT DECLARATIONS21
//----------------------------------------------------------------------------

   //inputs21
   input        n_p_reset21;              //reset signal21
   input        pclk21;                 //System21 Clock21
   input        psel21;                 //Select21 line
   input        penable21;              //Strobe21 line
   input        pwrite21;               //Write line, 1 for write, 0 for read
   input [7:0]  paddr21;                //Address Bus21 register
   input [6:0]  clk_ctrl_reg_121;       //Clock21 Control21 reg for Timer_Counter21 1
   input [6:0]  cntr_ctrl_reg_121;      //Counter21 Control21 reg for Timer_Counter21 1
   input [6:0]  clk_ctrl_reg_221;       //Clock21 Control21 reg for Timer_Counter21 2
   input [6:0]  cntr_ctrl_reg_221;      //Counter21 Control21 reg for Timer21 Counter21 2
   input [6:0]  clk_ctrl_reg_321;       //Clock21 Control21 reg Timer_Counter21 3
   input [6:0]  cntr_ctrl_reg_321;      //Counter21 Control21 reg for Timer21 Counter21 3
   input [15:0] counter_val_reg_121;    //Counter21 Value from Timer_Counter21 1
   input [15:0] counter_val_reg_221;    //Counter21 Value from Timer_Counter21 2
   input [15:0] counter_val_reg_321;    //Counter21 Value from Timer_Counter21 3
   input [15:0] interval_reg_121;       //Interval21 reg value from Timer_Counter21 1
   input [15:0] match_1_reg_121;        //Match21 reg value from Timer_Counter21 
   input [15:0] match_2_reg_121;        //Match21 reg value from Timer_Counter21     
   input [15:0] match_3_reg_121;        //Match21 reg value from Timer_Counter21 
   input [15:0] interval_reg_221;       //Interval21 reg value from Timer_Counter21 2
   input [15:0] match_1_reg_221;        //Match21 reg value from Timer_Counter21     
   input [15:0] match_2_reg_221;        //Match21 reg value from Timer_Counter21     
   input [15:0] match_3_reg_221;        //Match21 reg value from Timer_Counter21 
   input [15:0] interval_reg_321;       //Interval21 reg value from Timer_Counter21 3
   input [15:0] match_1_reg_321;        //Match21 reg value from Timer_Counter21   
   input [15:0] match_2_reg_321;        //Match21 reg value from Timer_Counter21   
   input [15:0] match_3_reg_321;        //Match21 reg value from Timer_Counter21   
   input [5:0]  interrupt_reg_121;      //Interrupt21 Reg21 from Interrupt21 Module21 1
   input [5:0]  interrupt_reg_221;      //Interrupt21 Reg21 from Interrupt21 Module21 2
   input [5:0]  interrupt_reg_321;      //Interrupt21 Reg21 from Interrupt21 Module21 3
   input [5:0]  interrupt_en_reg_121;   //Interrupt21 Enable21 Reg21 from Intrpt21 Module21 1
   input [5:0]  interrupt_en_reg_221;   //Interrupt21 Enable21 Reg21 from Intrpt21 Module21 2
   input [5:0]  interrupt_en_reg_321;   //Interrupt21 Enable21 Reg21 from Intrpt21 Module21 3
   
   //outputs21
   output [31:0] prdata21;              //Read Data from the APB21 Interface21
   output clk_ctrl_reg_sel_121;         //Clock21 Control21 Reg21 Select21 TC_121 
   output clk_ctrl_reg_sel_221;         //Clock21 Control21 Reg21 Select21 TC_221 
   output clk_ctrl_reg_sel_321;         //Clock21 Control21 Reg21 Select21 TC_321 
   output cntr_ctrl_reg_sel_121;        //Counter21 Control21 Reg21 Select21 TC_121
   output cntr_ctrl_reg_sel_221;        //Counter21 Control21 Reg21 Select21 TC_221
   output cntr_ctrl_reg_sel_321;        //Counter21 Control21 Reg21 Select21 TC_321
   output interval_reg_sel_121;         //Interval21 Interrupt21 Reg21 Select21 TC_121 
   output interval_reg_sel_221;         //Interval21 Interrupt21 Reg21 Select21 TC_221 
   output interval_reg_sel_321;         //Interval21 Interrupt21 Reg21 Select21 TC_321 
   output match_1_reg_sel_121;          //Match21 Reg21 Select21 TC_121
   output match_1_reg_sel_221;          //Match21 Reg21 Select21 TC_221
   output match_1_reg_sel_321;          //Match21 Reg21 Select21 TC_321
   output match_2_reg_sel_121;          //Match21 Reg21 Select21 TC_121
   output match_2_reg_sel_221;          //Match21 Reg21 Select21 TC_221
   output match_2_reg_sel_321;          //Match21 Reg21 Select21 TC_321
   output match_3_reg_sel_121;          //Match21 Reg21 Select21 TC_121
   output match_3_reg_sel_221;          //Match21 Reg21 Select21 TC_221
   output match_3_reg_sel_321;          //Match21 Reg21 Select21 TC_321
   output [3:1] intr_en_reg_sel21;      //Interrupt21 Enable21 Reg21 Select21
   output [3:1] clear_interrupt21;      //Clear Interrupt21 line


//-----------------------------------------------------------------------------
// PARAMETER21 DECLARATIONS21
//-----------------------------------------------------------------------------

   parameter   [7:0] CLK_CTRL_REG_1_ADDR21   = 8'h00; //Clock21 control21 1 address
   parameter   [7:0] CLK_CTRL_REG_2_ADDR21   = 8'h04; //Clock21 control21 2 address
   parameter   [7:0] CLK_CTRL_REG_3_ADDR21   = 8'h08; //Clock21 control21 3 address
   parameter   [7:0] CNTR_CTRL_REG_1_ADDR21  = 8'h0C; //Counter21 control21 1 address
   parameter   [7:0] CNTR_CTRL_REG_2_ADDR21  = 8'h10; //Counter21 control21 2 address
   parameter   [7:0] CNTR_CTRL_REG_3_ADDR21  = 8'h14; //Counter21 control21 3 address
   parameter   [7:0] CNTR_VAL_REG_1_ADDR21   = 8'h18; //Counter21 value 1 address
   parameter   [7:0] CNTR_VAL_REG_2_ADDR21   = 8'h1C; //Counter21 value 2 address
   parameter   [7:0] CNTR_VAL_REG_3_ADDR21   = 8'h20; //Counter21 value 3 address
   parameter   [7:0] INTERVAL_REG_1_ADDR21   = 8'h24; //Module21 1 interval21 address
   parameter   [7:0] INTERVAL_REG_2_ADDR21   = 8'h28; //Module21 2 interval21 address
   parameter   [7:0] INTERVAL_REG_3_ADDR21   = 8'h2C; //Module21 3 interval21 address
   parameter   [7:0] MATCH_1_REG_1_ADDR21    = 8'h30; //Module21 1 Match21 1 address
   parameter   [7:0] MATCH_1_REG_2_ADDR21    = 8'h34; //Module21 2 Match21 1 address
   parameter   [7:0] MATCH_1_REG_3_ADDR21    = 8'h38; //Module21 3 Match21 1 address
   parameter   [7:0] MATCH_2_REG_1_ADDR21    = 8'h3C; //Module21 1 Match21 2 address
   parameter   [7:0] MATCH_2_REG_2_ADDR21    = 8'h40; //Module21 2 Match21 2 address
   parameter   [7:0] MATCH_2_REG_3_ADDR21    = 8'h44; //Module21 3 Match21 2 address
   parameter   [7:0] MATCH_3_REG_1_ADDR21    = 8'h48; //Module21 1 Match21 3 address
   parameter   [7:0] MATCH_3_REG_2_ADDR21    = 8'h4C; //Module21 2 Match21 3 address
   parameter   [7:0] MATCH_3_REG_3_ADDR21    = 8'h50; //Module21 3 Match21 3 address
   parameter   [7:0] IRQ_REG_1_ADDR21        = 8'h54; //Interrupt21 register 1
   parameter   [7:0] IRQ_REG_2_ADDR21        = 8'h58; //Interrupt21 register 2
   parameter   [7:0] IRQ_REG_3_ADDR21        = 8'h5C; //Interrupt21 register 3
   parameter   [7:0] IRQ_EN_REG_1_ADDR21     = 8'h60; //Interrupt21 enable register 1
   parameter   [7:0] IRQ_EN_REG_2_ADDR21     = 8'h64; //Interrupt21 enable register 2
   parameter   [7:0] IRQ_EN_REG_3_ADDR21     = 8'h68; //Interrupt21 enable register 3
   
//-----------------------------------------------------------------------------
// Internal Signals21 & Registers21
//-----------------------------------------------------------------------------

   reg clk_ctrl_reg_sel_121;         //Clock21 Control21 Reg21 Select21 TC_121
   reg clk_ctrl_reg_sel_221;         //Clock21 Control21 Reg21 Select21 TC_221 
   reg clk_ctrl_reg_sel_321;         //Clock21 Control21 Reg21 Select21 TC_321 
   reg cntr_ctrl_reg_sel_121;        //Counter21 Control21 Reg21 Select21 TC_121
   reg cntr_ctrl_reg_sel_221;        //Counter21 Control21 Reg21 Select21 TC_221
   reg cntr_ctrl_reg_sel_321;        //Counter21 Control21 Reg21 Select21 TC_321
   reg interval_reg_sel_121;         //Interval21 Interrupt21 Reg21 Select21 TC_121 
   reg interval_reg_sel_221;         //Interval21 Interrupt21 Reg21 Select21 TC_221
   reg interval_reg_sel_321;         //Interval21 Interrupt21 Reg21 Select21 TC_321
   reg match_1_reg_sel_121;          //Match21 Reg21 Select21 TC_121
   reg match_1_reg_sel_221;          //Match21 Reg21 Select21 TC_221
   reg match_1_reg_sel_321;          //Match21 Reg21 Select21 TC_321
   reg match_2_reg_sel_121;          //Match21 Reg21 Select21 TC_121
   reg match_2_reg_sel_221;          //Match21 Reg21 Select21 TC_221
   reg match_2_reg_sel_321;          //Match21 Reg21 Select21 TC_321
   reg match_3_reg_sel_121;          //Match21 Reg21 Select21 TC_121
   reg match_3_reg_sel_221;          //Match21 Reg21 Select21 TC_221
   reg match_3_reg_sel_321;          //Match21 Reg21 Select21 TC_321
   reg [3:1] intr_en_reg_sel21;      //Interrupt21 Enable21 1 Reg21 Select21
   reg [31:0] prdata21;              //APB21 read data
   
   wire [3:1] clear_interrupt21;     // 3-bit clear interrupt21 reg on read
   wire write;                     //APB21 write command  
   wire read;                      //APB21 read command    



   assign write = psel21 & penable21 & pwrite21;  
   assign read  = psel21 & ~pwrite21;  
   assign clear_interrupt21[1] = read & penable21 & (paddr21 == IRQ_REG_1_ADDR21);
   assign clear_interrupt21[2] = read & penable21 & (paddr21 == IRQ_REG_2_ADDR21);
   assign clear_interrupt21[3] = read & penable21 & (paddr21 == IRQ_REG_3_ADDR21);   
   
   //p_write_sel21: Process21 to select21 the required21 regs for write access.

   always @ (paddr21 or write)
   begin: p_write_sel21

       clk_ctrl_reg_sel_121  = (write && (paddr21 == CLK_CTRL_REG_1_ADDR21));
       clk_ctrl_reg_sel_221  = (write && (paddr21 == CLK_CTRL_REG_2_ADDR21));
       clk_ctrl_reg_sel_321  = (write && (paddr21 == CLK_CTRL_REG_3_ADDR21));
       cntr_ctrl_reg_sel_121 = (write && (paddr21 == CNTR_CTRL_REG_1_ADDR21));
       cntr_ctrl_reg_sel_221 = (write && (paddr21 == CNTR_CTRL_REG_2_ADDR21));
       cntr_ctrl_reg_sel_321 = (write && (paddr21 == CNTR_CTRL_REG_3_ADDR21));
       interval_reg_sel_121  = (write && (paddr21 == INTERVAL_REG_1_ADDR21));
       interval_reg_sel_221  = (write && (paddr21 == INTERVAL_REG_2_ADDR21));
       interval_reg_sel_321  = (write && (paddr21 == INTERVAL_REG_3_ADDR21));
       match_1_reg_sel_121   = (write && (paddr21 == MATCH_1_REG_1_ADDR21));
       match_1_reg_sel_221   = (write && (paddr21 == MATCH_1_REG_2_ADDR21));
       match_1_reg_sel_321   = (write && (paddr21 == MATCH_1_REG_3_ADDR21));
       match_2_reg_sel_121   = (write && (paddr21 == MATCH_2_REG_1_ADDR21));
       match_2_reg_sel_221   = (write && (paddr21 == MATCH_2_REG_2_ADDR21));
       match_2_reg_sel_321   = (write && (paddr21 == MATCH_2_REG_3_ADDR21));
       match_3_reg_sel_121   = (write && (paddr21 == MATCH_3_REG_1_ADDR21));
       match_3_reg_sel_221   = (write && (paddr21 == MATCH_3_REG_2_ADDR21));
       match_3_reg_sel_321   = (write && (paddr21 == MATCH_3_REG_3_ADDR21));
       intr_en_reg_sel21[1]  = (write && (paddr21 == IRQ_EN_REG_1_ADDR21));
       intr_en_reg_sel21[2]  = (write && (paddr21 == IRQ_EN_REG_2_ADDR21));
       intr_en_reg_sel21[3]  = (write && (paddr21 == IRQ_EN_REG_3_ADDR21));      
   end  //p_write_sel21
    

//    p_read_sel21: Process21 to enable the read operation21 to occur21.

   always @ (posedge pclk21 or negedge n_p_reset21)
   begin: p_read_sel21

      if (!n_p_reset21)                                   
      begin                                     
         prdata21 <= 32'h00000000;
      end    
      else
      begin 

         if (read == 1'b1)
         begin
            
            case (paddr21)

               CLK_CTRL_REG_1_ADDR21 : prdata21 <= {25'h0000000,clk_ctrl_reg_121};
               CLK_CTRL_REG_2_ADDR21 : prdata21 <= {25'h0000000,clk_ctrl_reg_221};
               CLK_CTRL_REG_3_ADDR21 : prdata21 <= {25'h0000000,clk_ctrl_reg_321};
               CNTR_CTRL_REG_1_ADDR21: prdata21 <= {25'h0000000,cntr_ctrl_reg_121};
               CNTR_CTRL_REG_2_ADDR21: prdata21 <= {25'h0000000,cntr_ctrl_reg_221};
               CNTR_CTRL_REG_3_ADDR21: prdata21 <= {25'h0000000,cntr_ctrl_reg_321};
               CNTR_VAL_REG_1_ADDR21 : prdata21 <= {16'h0000,counter_val_reg_121};
               CNTR_VAL_REG_2_ADDR21 : prdata21 <= {16'h0000,counter_val_reg_221};
               CNTR_VAL_REG_3_ADDR21 : prdata21 <= {16'h0000,counter_val_reg_321};
               INTERVAL_REG_1_ADDR21 : prdata21 <= {16'h0000,interval_reg_121};
               INTERVAL_REG_2_ADDR21 : prdata21 <= {16'h0000,interval_reg_221};
               INTERVAL_REG_3_ADDR21 : prdata21 <= {16'h0000,interval_reg_321};
               MATCH_1_REG_1_ADDR21  : prdata21 <= {16'h0000,match_1_reg_121};
               MATCH_1_REG_2_ADDR21  : prdata21 <= {16'h0000,match_1_reg_221};
               MATCH_1_REG_3_ADDR21  : prdata21 <= {16'h0000,match_1_reg_321};
               MATCH_2_REG_1_ADDR21  : prdata21 <= {16'h0000,match_2_reg_121};
               MATCH_2_REG_2_ADDR21  : prdata21 <= {16'h0000,match_2_reg_221};
               MATCH_2_REG_3_ADDR21  : prdata21 <= {16'h0000,match_2_reg_321};
               MATCH_3_REG_1_ADDR21  : prdata21 <= {16'h0000,match_3_reg_121};
               MATCH_3_REG_2_ADDR21  : prdata21 <= {16'h0000,match_3_reg_221};
               MATCH_3_REG_3_ADDR21  : prdata21 <= {16'h0000,match_3_reg_321};
               IRQ_REG_1_ADDR21      : prdata21 <= {26'h0000,interrupt_reg_121};
               IRQ_REG_2_ADDR21      : prdata21 <= {26'h0000,interrupt_reg_221};
               IRQ_REG_3_ADDR21      : prdata21 <= {26'h0000,interrupt_reg_321};
               IRQ_EN_REG_1_ADDR21   : prdata21 <= {26'h0000,interrupt_en_reg_121};
               IRQ_EN_REG_2_ADDR21   : prdata21 <= {26'h0000,interrupt_en_reg_221};
               IRQ_EN_REG_3_ADDR21   : prdata21 <= {26'h0000,interrupt_en_reg_321};
               default             : prdata21 <= 32'h00000000;

            endcase

         end // if (read == 1'b1)
         
         else
            
         begin
            
            prdata21 <= 32'h00000000;
            
         end // else: !if(read == 1'b1)         
         
      end // else: !if(!n_p_reset21)
      
   end // block: p_read_sel21

endmodule

