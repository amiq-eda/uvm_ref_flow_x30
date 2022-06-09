//File10 name   : alut_reg_bank10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

// compiler10 directives10
`include "alut_defines10.v"


module alut_reg_bank10
(   
   // Inputs10
   pclk10,
   n_p_reset10,
   psel10,            
   penable10,       
   pwrite10,         
   paddr10,           
   pwdata10,          

   curr_time10,
   add_check_active10,
   age_check_active10,
   inval_in_prog10,
   reused10,
   d_port10,
   lst_inv_addr_nrm10,
   lst_inv_port_nrm10,
   lst_inv_addr_cmd10,
   lst_inv_port_cmd10,

   // Outputs10
   mac_addr10,    
   d_addr10,   
   s_addr10,    
   s_port10,    
   best_bfr_age10,
   div_clk10,     
   command, 
   prdata10,  
   clear_reused10           
);


   // APB10 Inputs10
   input                 pclk10;             // APB10 clock10
   input                 n_p_reset10;        // Reset10
   input                 psel10;             // Module10 select10 signal10
   input                 penable10;          // Enable10 signal10 
   input                 pwrite10;           // Write when HIGH10 and read when LOW10
   input [6:0]           paddr10;            // Address bus for read write
   input [31:0]          pwdata10;           // APB10 write bus

   // Inputs10 from other ALUT10 blocks
   input [31:0]          curr_time10;        // current time
   input                 add_check_active10; // used to calculate10 status[0]
   input                 age_check_active10; // used to calculate10 status[0]
   input                 inval_in_prog10;    // status[1]
   input                 reused10;           // status[2]
   input [4:0]           d_port10;           // calculated10 destination10 port for tx10
   input [47:0]          lst_inv_addr_nrm10; // last invalidated10 addr normal10 op
   input [1:0]           lst_inv_port_nrm10; // last invalidated10 port normal10 op
   input [47:0]          lst_inv_addr_cmd10; // last invalidated10 addr via cmd10
   input [1:0]           lst_inv_port_cmd10; // last invalidated10 port via cmd10
   

   output [47:0]         mac_addr10;         // address of the switch10
   output [47:0]         d_addr10;           // address of frame10 to be checked10
   output [47:0]         s_addr10;           // address of frame10 to be stored10
   output [1:0]          s_port10;           // source10 port of current frame10
   output [31:0]         best_bfr_age10;     // best10 before age10
   output [7:0]          div_clk10;          // programmed10 clock10 divider10 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata10;           // APB10 read bus
   output                clear_reused10;     // indicates10 status reg read 

   reg    [31:0]         prdata10;           //APB10 read bus   
   reg    [31:0]         frm_d_addr_l10;     
   reg    [15:0]         frm_d_addr_u10;     
   reg    [31:0]         frm_s_addr_l10;     
   reg    [15:0]         frm_s_addr_u10;     
   reg    [1:0]          s_port10;           
   reg    [31:0]         mac_addr_l10;       
   reg    [15:0]         mac_addr_u10;       
   reg    [31:0]         best_bfr_age10;     
   reg    [7:0]          div_clk10;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l10;   
   reg    [15:0]         lst_inv_addr_u10;   
   reg    [1:0]          lst_inv_port10;     


   // Internal Signal10 Declarations10
   wire                  read_enable10;      //APB10 read enable
   wire                  write_enable10;     //APB10 write enable
   wire   [47:0]         mac_addr10;        
   wire   [47:0]         d_addr10;          
   wire   [47:0]         src_addr10;        
   wire                  clear_reused10;    
   wire                  active;

   // ----------------------------
   // General10 Assignments10
   // ----------------------------

   assign read_enable10    = (psel10 & ~penable10 & ~pwrite10);
   assign write_enable10   = (psel10 & penable10 & pwrite10);

   assign mac_addr10  = {mac_addr_u10, mac_addr_l10}; 
   assign d_addr10 =    {frm_d_addr_u10, frm_d_addr_l10};
   assign s_addr10    = {frm_s_addr_u10, frm_s_addr_l10}; 

   assign clear_reused10 = read_enable10 & (paddr10 == `AL_STATUS10) & ~active;

   assign active = (add_check_active10 | age_check_active10);

// ------------------------------------------------------------------------
//   Read Mux10 Control10 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         prdata10 <= 32'h0000_0000;
      else if (read_enable10)
         begin
         case (paddr10)
            `AL_FRM_D_ADDR_L10   : prdata10 <= frm_d_addr_l10;
            `AL_FRM_D_ADDR_U10   : prdata10 <= {16'd0, frm_d_addr_u10};    
            `AL_FRM_S_ADDR_L10   : prdata10 <= frm_s_addr_l10; 
            `AL_FRM_S_ADDR_U10   : prdata10 <= {16'd0, frm_s_addr_u10}; 
            `AL_S_PORT10         : prdata10 <= {30'd0, s_port10}; 
            `AL_D_PORT10         : prdata10 <= {27'd0, d_port10}; 
            `AL_MAC_ADDR_L10     : prdata10 <= mac_addr_l10;
            `AL_MAC_ADDR_U10     : prdata10 <= {16'd0, mac_addr_u10};   
            `AL_CUR_TIME10       : prdata10 <= curr_time10; 
            `AL_BB_AGE10         : prdata10 <= best_bfr_age10;
            `AL_DIV_CLK10        : prdata10 <= {24'd0, div_clk10}; 
            `AL_STATUS10         : prdata10 <= {29'd0, reused10, inval_in_prog10,
                                           active};
            `AL_LST_INV_ADDR_L10 : prdata10 <= lst_inv_addr_l10; 
            `AL_LST_INV_ADDR_U10 : prdata10 <= {16'd0, lst_inv_addr_u10};
            `AL_LST_INV_PORT10   : prdata10 <= {30'd0, lst_inv_port10};

            default:   prdata10 <= 32'h0000_0000;
         endcase
         end
      else
         prdata10 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB10 writable10 registers
// ------------------------------------------------------------------------
// Lower10 destination10 frame10 address register  
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         frm_d_addr_l10 <= 32'h0000_0000;         
      else if (write_enable10 & (paddr10 == `AL_FRM_D_ADDR_L10))
         frm_d_addr_l10 <= pwdata10;
      else
         frm_d_addr_l10 <= frm_d_addr_l10;
      end   


// Upper10 destination10 frame10 address register  
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         frm_d_addr_u10 <= 16'h0000;         
      else if (write_enable10 & (paddr10 == `AL_FRM_D_ADDR_U10))
         frm_d_addr_u10 <= pwdata10[15:0];
      else
         frm_d_addr_u10 <= frm_d_addr_u10;
      end   


// Lower10 source10 frame10 address register  
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         frm_s_addr_l10 <= 32'h0000_0000;         
      else if (write_enable10 & (paddr10 == `AL_FRM_S_ADDR_L10))
         frm_s_addr_l10 <= pwdata10;
      else
         frm_s_addr_l10 <= frm_s_addr_l10;
      end   


// Upper10 source10 frame10 address register  
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         frm_s_addr_u10 <= 16'h0000;         
      else if (write_enable10 & (paddr10 == `AL_FRM_S_ADDR_U10))
         frm_s_addr_u10 <= pwdata10[15:0];
      else
         frm_s_addr_u10 <= frm_s_addr_u10;
      end   


// Source10 port  
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         s_port10 <= 2'b00;         
      else if (write_enable10 & (paddr10 == `AL_S_PORT10))
         s_port10 <= pwdata10[1:0];
      else
         s_port10 <= s_port10;
      end   


// Lower10 switch10 MAC10 address
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         mac_addr_l10 <= 32'h0000_0000;         
      else if (write_enable10 & (paddr10 == `AL_MAC_ADDR_L10))
         mac_addr_l10 <= pwdata10;
      else
         mac_addr_l10 <= mac_addr_l10;
      end   


// Upper10 switch10 MAC10 address 
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         mac_addr_u10 <= 16'h0000;         
      else if (write_enable10 & (paddr10 == `AL_MAC_ADDR_U10))
         mac_addr_u10 <= pwdata10[15:0];
      else
         mac_addr_u10 <= mac_addr_u10;
      end   


// Best10 before age10 
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         best_bfr_age10 <= 32'hffff_ffff;         
      else if (write_enable10 & (paddr10 == `AL_BB_AGE10))
         best_bfr_age10 <= pwdata10;
      else
         best_bfr_age10 <= best_bfr_age10;
      end   


// clock10 divider10
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         div_clk10 <= 8'h00;         
      else if (write_enable10 & (paddr10 == `AL_DIV_CLK10))
         div_clk10 <= pwdata10[7:0];
      else
         div_clk10 <= div_clk10;
      end   


// command.  Needs to be automatically10 cleared10 on following10 cycle
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable10 & (paddr10 == `AL_COMMAND10))
         command <= pwdata10[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last10 invalidated10 port and address values.  These10 can either10 be updated
//   by normal10 operation10 of address checker overwriting10 existing values or
//   by the age10 checker being commanded10 to invalidate10 out of date10 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk10 or negedge n_p_reset10)
      begin 
      if (~n_p_reset10)
      begin
         lst_inv_addr_l10 <= 32'd0;
         lst_inv_addr_u10 <= 16'd0;
         lst_inv_port10   <= 2'd0;
      end
      else if (reused10)        // reused10 flag10 from address checker
      begin
         lst_inv_addr_l10 <= lst_inv_addr_nrm10[31:0];
         lst_inv_addr_u10 <= lst_inv_addr_nrm10[47:32];
         lst_inv_port10   <= lst_inv_port_nrm10;
      end
//      else if (command == 2'b01)  // invalidate10 aged10 from age10 checker
      else if (inval_in_prog10)  // invalidate10 aged10 from age10 checker
      begin
         lst_inv_addr_l10 <= lst_inv_addr_cmd10[31:0];
         lst_inv_addr_u10 <= lst_inv_addr_cmd10[47:32];
         lst_inv_port10   <= lst_inv_port_cmd10;
      end
      else
      begin
         lst_inv_addr_l10 <= lst_inv_addr_l10;
         lst_inv_addr_u10 <= lst_inv_addr_u10;
         lst_inv_port10   <= lst_inv_port10;
      end
      end
 


`ifdef ABV_ON10

defparam i_apb_monitor10.ABUS_WIDTH10 = 7;

// APB10 ASSERTION10 VIP10
apb_monitor10 i_apb_monitor10(.pclk_i10(pclk10), 
                          .presetn_i10(n_p_reset10),
                          .penable_i10(penable10),
                          .psel_i10(psel10),
                          .paddr_i10(paddr10),
                          .pwrite_i10(pwrite10),
                          .pwdata_i10(pwdata10),
                          .prdata_i10(prdata10)); 

// psl10 default clock10 = (posedge pclk10);

// ASSUMPTIONS10
//// active (set by address checker) and invalidation10 in progress10 should never both be set
//// psl10 assume_never_active_inval_aged10 : assume never (active & inval_in_prog10);


// ASSERTION10 CHECKS10
// never read and write at the same time
// psl10 assert_never_rd_wr10 : assert never (read_enable10 & write_enable10);

// check apb10 writes, pick10 command reqister10 as arbitary10 example10
// psl10 assert_cmd_wr10 : assert always ((paddr10 == `AL_COMMAND10) & write_enable10) -> 
//                                    next(command == prev(pwdata10[1:0])) abort10(~n_p_reset10);


// check rw writes, pick10 clock10 divider10 reqister10 as arbitary10 example10.  It takes10 2 cycles10 to write
// then10 read back data, therefore10 need to store10 original write data for use in assertion10 check
reg [31:0] pwdata_d10;  // 1 cycle delayed10 
always @ (posedge pclk10) pwdata_d10 <= pwdata10;

// psl10 assert_rw_div_clk10 : 
// assert always {((paddr10 == `AL_DIV_CLK10) & write_enable10) ; ((paddr10 == `AL_DIV_CLK10) & read_enable10)} |=>
// {prev(pwdata_d10[7:0]) == prdata10[7:0]};



// COVER10 SANITY10 CHECKS10
// sanity10 read
// psl10 output_for_div_clk10 : cover {((paddr10 == `AL_DIV_CLK10) & read_enable10); prdata10[7:0] == 8'h55};


`endif


endmodule 


