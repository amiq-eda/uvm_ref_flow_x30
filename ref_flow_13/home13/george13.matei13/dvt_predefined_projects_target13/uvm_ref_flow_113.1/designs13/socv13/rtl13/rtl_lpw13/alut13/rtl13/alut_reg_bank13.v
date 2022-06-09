//File13 name   : alut_reg_bank13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

// compiler13 directives13
`include "alut_defines13.v"


module alut_reg_bank13
(   
   // Inputs13
   pclk13,
   n_p_reset13,
   psel13,            
   penable13,       
   pwrite13,         
   paddr13,           
   pwdata13,          

   curr_time13,
   add_check_active13,
   age_check_active13,
   inval_in_prog13,
   reused13,
   d_port13,
   lst_inv_addr_nrm13,
   lst_inv_port_nrm13,
   lst_inv_addr_cmd13,
   lst_inv_port_cmd13,

   // Outputs13
   mac_addr13,    
   d_addr13,   
   s_addr13,    
   s_port13,    
   best_bfr_age13,
   div_clk13,     
   command, 
   prdata13,  
   clear_reused13           
);


   // APB13 Inputs13
   input                 pclk13;             // APB13 clock13
   input                 n_p_reset13;        // Reset13
   input                 psel13;             // Module13 select13 signal13
   input                 penable13;          // Enable13 signal13 
   input                 pwrite13;           // Write when HIGH13 and read when LOW13
   input [6:0]           paddr13;            // Address bus for read write
   input [31:0]          pwdata13;           // APB13 write bus

   // Inputs13 from other ALUT13 blocks
   input [31:0]          curr_time13;        // current time
   input                 add_check_active13; // used to calculate13 status[0]
   input                 age_check_active13; // used to calculate13 status[0]
   input                 inval_in_prog13;    // status[1]
   input                 reused13;           // status[2]
   input [4:0]           d_port13;           // calculated13 destination13 port for tx13
   input [47:0]          lst_inv_addr_nrm13; // last invalidated13 addr normal13 op
   input [1:0]           lst_inv_port_nrm13; // last invalidated13 port normal13 op
   input [47:0]          lst_inv_addr_cmd13; // last invalidated13 addr via cmd13
   input [1:0]           lst_inv_port_cmd13; // last invalidated13 port via cmd13
   

   output [47:0]         mac_addr13;         // address of the switch13
   output [47:0]         d_addr13;           // address of frame13 to be checked13
   output [47:0]         s_addr13;           // address of frame13 to be stored13
   output [1:0]          s_port13;           // source13 port of current frame13
   output [31:0]         best_bfr_age13;     // best13 before age13
   output [7:0]          div_clk13;          // programmed13 clock13 divider13 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata13;           // APB13 read bus
   output                clear_reused13;     // indicates13 status reg read 

   reg    [31:0]         prdata13;           //APB13 read bus   
   reg    [31:0]         frm_d_addr_l13;     
   reg    [15:0]         frm_d_addr_u13;     
   reg    [31:0]         frm_s_addr_l13;     
   reg    [15:0]         frm_s_addr_u13;     
   reg    [1:0]          s_port13;           
   reg    [31:0]         mac_addr_l13;       
   reg    [15:0]         mac_addr_u13;       
   reg    [31:0]         best_bfr_age13;     
   reg    [7:0]          div_clk13;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l13;   
   reg    [15:0]         lst_inv_addr_u13;   
   reg    [1:0]          lst_inv_port13;     


   // Internal Signal13 Declarations13
   wire                  read_enable13;      //APB13 read enable
   wire                  write_enable13;     //APB13 write enable
   wire   [47:0]         mac_addr13;        
   wire   [47:0]         d_addr13;          
   wire   [47:0]         src_addr13;        
   wire                  clear_reused13;    
   wire                  active;

   // ----------------------------
   // General13 Assignments13
   // ----------------------------

   assign read_enable13    = (psel13 & ~penable13 & ~pwrite13);
   assign write_enable13   = (psel13 & penable13 & pwrite13);

   assign mac_addr13  = {mac_addr_u13, mac_addr_l13}; 
   assign d_addr13 =    {frm_d_addr_u13, frm_d_addr_l13};
   assign s_addr13    = {frm_s_addr_u13, frm_s_addr_l13}; 

   assign clear_reused13 = read_enable13 & (paddr13 == `AL_STATUS13) & ~active;

   assign active = (add_check_active13 | age_check_active13);

// ------------------------------------------------------------------------
//   Read Mux13 Control13 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         prdata13 <= 32'h0000_0000;
      else if (read_enable13)
         begin
         case (paddr13)
            `AL_FRM_D_ADDR_L13   : prdata13 <= frm_d_addr_l13;
            `AL_FRM_D_ADDR_U13   : prdata13 <= {16'd0, frm_d_addr_u13};    
            `AL_FRM_S_ADDR_L13   : prdata13 <= frm_s_addr_l13; 
            `AL_FRM_S_ADDR_U13   : prdata13 <= {16'd0, frm_s_addr_u13}; 
            `AL_S_PORT13         : prdata13 <= {30'd0, s_port13}; 
            `AL_D_PORT13         : prdata13 <= {27'd0, d_port13}; 
            `AL_MAC_ADDR_L13     : prdata13 <= mac_addr_l13;
            `AL_MAC_ADDR_U13     : prdata13 <= {16'd0, mac_addr_u13};   
            `AL_CUR_TIME13       : prdata13 <= curr_time13; 
            `AL_BB_AGE13         : prdata13 <= best_bfr_age13;
            `AL_DIV_CLK13        : prdata13 <= {24'd0, div_clk13}; 
            `AL_STATUS13         : prdata13 <= {29'd0, reused13, inval_in_prog13,
                                           active};
            `AL_LST_INV_ADDR_L13 : prdata13 <= lst_inv_addr_l13; 
            `AL_LST_INV_ADDR_U13 : prdata13 <= {16'd0, lst_inv_addr_u13};
            `AL_LST_INV_PORT13   : prdata13 <= {30'd0, lst_inv_port13};

            default:   prdata13 <= 32'h0000_0000;
         endcase
         end
      else
         prdata13 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB13 writable13 registers
// ------------------------------------------------------------------------
// Lower13 destination13 frame13 address register  
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         frm_d_addr_l13 <= 32'h0000_0000;         
      else if (write_enable13 & (paddr13 == `AL_FRM_D_ADDR_L13))
         frm_d_addr_l13 <= pwdata13;
      else
         frm_d_addr_l13 <= frm_d_addr_l13;
      end   


// Upper13 destination13 frame13 address register  
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         frm_d_addr_u13 <= 16'h0000;         
      else if (write_enable13 & (paddr13 == `AL_FRM_D_ADDR_U13))
         frm_d_addr_u13 <= pwdata13[15:0];
      else
         frm_d_addr_u13 <= frm_d_addr_u13;
      end   


// Lower13 source13 frame13 address register  
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         frm_s_addr_l13 <= 32'h0000_0000;         
      else if (write_enable13 & (paddr13 == `AL_FRM_S_ADDR_L13))
         frm_s_addr_l13 <= pwdata13;
      else
         frm_s_addr_l13 <= frm_s_addr_l13;
      end   


// Upper13 source13 frame13 address register  
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         frm_s_addr_u13 <= 16'h0000;         
      else if (write_enable13 & (paddr13 == `AL_FRM_S_ADDR_U13))
         frm_s_addr_u13 <= pwdata13[15:0];
      else
         frm_s_addr_u13 <= frm_s_addr_u13;
      end   


// Source13 port  
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         s_port13 <= 2'b00;         
      else if (write_enable13 & (paddr13 == `AL_S_PORT13))
         s_port13 <= pwdata13[1:0];
      else
         s_port13 <= s_port13;
      end   


// Lower13 switch13 MAC13 address
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         mac_addr_l13 <= 32'h0000_0000;         
      else if (write_enable13 & (paddr13 == `AL_MAC_ADDR_L13))
         mac_addr_l13 <= pwdata13;
      else
         mac_addr_l13 <= mac_addr_l13;
      end   


// Upper13 switch13 MAC13 address 
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         mac_addr_u13 <= 16'h0000;         
      else if (write_enable13 & (paddr13 == `AL_MAC_ADDR_U13))
         mac_addr_u13 <= pwdata13[15:0];
      else
         mac_addr_u13 <= mac_addr_u13;
      end   


// Best13 before age13 
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         best_bfr_age13 <= 32'hffff_ffff;         
      else if (write_enable13 & (paddr13 == `AL_BB_AGE13))
         best_bfr_age13 <= pwdata13;
      else
         best_bfr_age13 <= best_bfr_age13;
      end   


// clock13 divider13
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         div_clk13 <= 8'h00;         
      else if (write_enable13 & (paddr13 == `AL_DIV_CLK13))
         div_clk13 <= pwdata13[7:0];
      else
         div_clk13 <= div_clk13;
      end   


// command.  Needs to be automatically13 cleared13 on following13 cycle
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable13 & (paddr13 == `AL_COMMAND13))
         command <= pwdata13[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last13 invalidated13 port and address values.  These13 can either13 be updated
//   by normal13 operation13 of address checker overwriting13 existing values or
//   by the age13 checker being commanded13 to invalidate13 out of date13 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk13 or negedge n_p_reset13)
      begin 
      if (~n_p_reset13)
      begin
         lst_inv_addr_l13 <= 32'd0;
         lst_inv_addr_u13 <= 16'd0;
         lst_inv_port13   <= 2'd0;
      end
      else if (reused13)        // reused13 flag13 from address checker
      begin
         lst_inv_addr_l13 <= lst_inv_addr_nrm13[31:0];
         lst_inv_addr_u13 <= lst_inv_addr_nrm13[47:32];
         lst_inv_port13   <= lst_inv_port_nrm13;
      end
//      else if (command == 2'b01)  // invalidate13 aged13 from age13 checker
      else if (inval_in_prog13)  // invalidate13 aged13 from age13 checker
      begin
         lst_inv_addr_l13 <= lst_inv_addr_cmd13[31:0];
         lst_inv_addr_u13 <= lst_inv_addr_cmd13[47:32];
         lst_inv_port13   <= lst_inv_port_cmd13;
      end
      else
      begin
         lst_inv_addr_l13 <= lst_inv_addr_l13;
         lst_inv_addr_u13 <= lst_inv_addr_u13;
         lst_inv_port13   <= lst_inv_port13;
      end
      end
 


`ifdef ABV_ON13

defparam i_apb_monitor13.ABUS_WIDTH13 = 7;

// APB13 ASSERTION13 VIP13
apb_monitor13 i_apb_monitor13(.pclk_i13(pclk13), 
                          .presetn_i13(n_p_reset13),
                          .penable_i13(penable13),
                          .psel_i13(psel13),
                          .paddr_i13(paddr13),
                          .pwrite_i13(pwrite13),
                          .pwdata_i13(pwdata13),
                          .prdata_i13(prdata13)); 

// psl13 default clock13 = (posedge pclk13);

// ASSUMPTIONS13
//// active (set by address checker) and invalidation13 in progress13 should never both be set
//// psl13 assume_never_active_inval_aged13 : assume never (active & inval_in_prog13);


// ASSERTION13 CHECKS13
// never read and write at the same time
// psl13 assert_never_rd_wr13 : assert never (read_enable13 & write_enable13);

// check apb13 writes, pick13 command reqister13 as arbitary13 example13
// psl13 assert_cmd_wr13 : assert always ((paddr13 == `AL_COMMAND13) & write_enable13) -> 
//                                    next(command == prev(pwdata13[1:0])) abort13(~n_p_reset13);


// check rw writes, pick13 clock13 divider13 reqister13 as arbitary13 example13.  It takes13 2 cycles13 to write
// then13 read back data, therefore13 need to store13 original write data for use in assertion13 check
reg [31:0] pwdata_d13;  // 1 cycle delayed13 
always @ (posedge pclk13) pwdata_d13 <= pwdata13;

// psl13 assert_rw_div_clk13 : 
// assert always {((paddr13 == `AL_DIV_CLK13) & write_enable13) ; ((paddr13 == `AL_DIV_CLK13) & read_enable13)} |=>
// {prev(pwdata_d13[7:0]) == prdata13[7:0]};



// COVER13 SANITY13 CHECKS13
// sanity13 read
// psl13 output_for_div_clk13 : cover {((paddr13 == `AL_DIV_CLK13) & read_enable13); prdata13[7:0] == 8'h55};


`endif


endmodule 


