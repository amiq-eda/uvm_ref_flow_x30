//File26 name   : alut_reg_bank26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
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

// compiler26 directives26
`include "alut_defines26.v"


module alut_reg_bank26
(   
   // Inputs26
   pclk26,
   n_p_reset26,
   psel26,            
   penable26,       
   pwrite26,         
   paddr26,           
   pwdata26,          

   curr_time26,
   add_check_active26,
   age_check_active26,
   inval_in_prog26,
   reused26,
   d_port26,
   lst_inv_addr_nrm26,
   lst_inv_port_nrm26,
   lst_inv_addr_cmd26,
   lst_inv_port_cmd26,

   // Outputs26
   mac_addr26,    
   d_addr26,   
   s_addr26,    
   s_port26,    
   best_bfr_age26,
   div_clk26,     
   command, 
   prdata26,  
   clear_reused26           
);


   // APB26 Inputs26
   input                 pclk26;             // APB26 clock26
   input                 n_p_reset26;        // Reset26
   input                 psel26;             // Module26 select26 signal26
   input                 penable26;          // Enable26 signal26 
   input                 pwrite26;           // Write when HIGH26 and read when LOW26
   input [6:0]           paddr26;            // Address bus for read write
   input [31:0]          pwdata26;           // APB26 write bus

   // Inputs26 from other ALUT26 blocks
   input [31:0]          curr_time26;        // current time
   input                 add_check_active26; // used to calculate26 status[0]
   input                 age_check_active26; // used to calculate26 status[0]
   input                 inval_in_prog26;    // status[1]
   input                 reused26;           // status[2]
   input [4:0]           d_port26;           // calculated26 destination26 port for tx26
   input [47:0]          lst_inv_addr_nrm26; // last invalidated26 addr normal26 op
   input [1:0]           lst_inv_port_nrm26; // last invalidated26 port normal26 op
   input [47:0]          lst_inv_addr_cmd26; // last invalidated26 addr via cmd26
   input [1:0]           lst_inv_port_cmd26; // last invalidated26 port via cmd26
   

   output [47:0]         mac_addr26;         // address of the switch26
   output [47:0]         d_addr26;           // address of frame26 to be checked26
   output [47:0]         s_addr26;           // address of frame26 to be stored26
   output [1:0]          s_port26;           // source26 port of current frame26
   output [31:0]         best_bfr_age26;     // best26 before age26
   output [7:0]          div_clk26;          // programmed26 clock26 divider26 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata26;           // APB26 read bus
   output                clear_reused26;     // indicates26 status reg read 

   reg    [31:0]         prdata26;           //APB26 read bus   
   reg    [31:0]         frm_d_addr_l26;     
   reg    [15:0]         frm_d_addr_u26;     
   reg    [31:0]         frm_s_addr_l26;     
   reg    [15:0]         frm_s_addr_u26;     
   reg    [1:0]          s_port26;           
   reg    [31:0]         mac_addr_l26;       
   reg    [15:0]         mac_addr_u26;       
   reg    [31:0]         best_bfr_age26;     
   reg    [7:0]          div_clk26;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l26;   
   reg    [15:0]         lst_inv_addr_u26;   
   reg    [1:0]          lst_inv_port26;     


   // Internal Signal26 Declarations26
   wire                  read_enable26;      //APB26 read enable
   wire                  write_enable26;     //APB26 write enable
   wire   [47:0]         mac_addr26;        
   wire   [47:0]         d_addr26;          
   wire   [47:0]         src_addr26;        
   wire                  clear_reused26;    
   wire                  active;

   // ----------------------------
   // General26 Assignments26
   // ----------------------------

   assign read_enable26    = (psel26 & ~penable26 & ~pwrite26);
   assign write_enable26   = (psel26 & penable26 & pwrite26);

   assign mac_addr26  = {mac_addr_u26, mac_addr_l26}; 
   assign d_addr26 =    {frm_d_addr_u26, frm_d_addr_l26};
   assign s_addr26    = {frm_s_addr_u26, frm_s_addr_l26}; 

   assign clear_reused26 = read_enable26 & (paddr26 == `AL_STATUS26) & ~active;

   assign active = (add_check_active26 | age_check_active26);

// ------------------------------------------------------------------------
//   Read Mux26 Control26 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         prdata26 <= 32'h0000_0000;
      else if (read_enable26)
         begin
         case (paddr26)
            `AL_FRM_D_ADDR_L26   : prdata26 <= frm_d_addr_l26;
            `AL_FRM_D_ADDR_U26   : prdata26 <= {16'd0, frm_d_addr_u26};    
            `AL_FRM_S_ADDR_L26   : prdata26 <= frm_s_addr_l26; 
            `AL_FRM_S_ADDR_U26   : prdata26 <= {16'd0, frm_s_addr_u26}; 
            `AL_S_PORT26         : prdata26 <= {30'd0, s_port26}; 
            `AL_D_PORT26         : prdata26 <= {27'd0, d_port26}; 
            `AL_MAC_ADDR_L26     : prdata26 <= mac_addr_l26;
            `AL_MAC_ADDR_U26     : prdata26 <= {16'd0, mac_addr_u26};   
            `AL_CUR_TIME26       : prdata26 <= curr_time26; 
            `AL_BB_AGE26         : prdata26 <= best_bfr_age26;
            `AL_DIV_CLK26        : prdata26 <= {24'd0, div_clk26}; 
            `AL_STATUS26         : prdata26 <= {29'd0, reused26, inval_in_prog26,
                                           active};
            `AL_LST_INV_ADDR_L26 : prdata26 <= lst_inv_addr_l26; 
            `AL_LST_INV_ADDR_U26 : prdata26 <= {16'd0, lst_inv_addr_u26};
            `AL_LST_INV_PORT26   : prdata26 <= {30'd0, lst_inv_port26};

            default:   prdata26 <= 32'h0000_0000;
         endcase
         end
      else
         prdata26 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB26 writable26 registers
// ------------------------------------------------------------------------
// Lower26 destination26 frame26 address register  
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         frm_d_addr_l26 <= 32'h0000_0000;         
      else if (write_enable26 & (paddr26 == `AL_FRM_D_ADDR_L26))
         frm_d_addr_l26 <= pwdata26;
      else
         frm_d_addr_l26 <= frm_d_addr_l26;
      end   


// Upper26 destination26 frame26 address register  
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         frm_d_addr_u26 <= 16'h0000;         
      else if (write_enable26 & (paddr26 == `AL_FRM_D_ADDR_U26))
         frm_d_addr_u26 <= pwdata26[15:0];
      else
         frm_d_addr_u26 <= frm_d_addr_u26;
      end   


// Lower26 source26 frame26 address register  
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         frm_s_addr_l26 <= 32'h0000_0000;         
      else if (write_enable26 & (paddr26 == `AL_FRM_S_ADDR_L26))
         frm_s_addr_l26 <= pwdata26;
      else
         frm_s_addr_l26 <= frm_s_addr_l26;
      end   


// Upper26 source26 frame26 address register  
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         frm_s_addr_u26 <= 16'h0000;         
      else if (write_enable26 & (paddr26 == `AL_FRM_S_ADDR_U26))
         frm_s_addr_u26 <= pwdata26[15:0];
      else
         frm_s_addr_u26 <= frm_s_addr_u26;
      end   


// Source26 port  
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         s_port26 <= 2'b00;         
      else if (write_enable26 & (paddr26 == `AL_S_PORT26))
         s_port26 <= pwdata26[1:0];
      else
         s_port26 <= s_port26;
      end   


// Lower26 switch26 MAC26 address
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         mac_addr_l26 <= 32'h0000_0000;         
      else if (write_enable26 & (paddr26 == `AL_MAC_ADDR_L26))
         mac_addr_l26 <= pwdata26;
      else
         mac_addr_l26 <= mac_addr_l26;
      end   


// Upper26 switch26 MAC26 address 
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         mac_addr_u26 <= 16'h0000;         
      else if (write_enable26 & (paddr26 == `AL_MAC_ADDR_U26))
         mac_addr_u26 <= pwdata26[15:0];
      else
         mac_addr_u26 <= mac_addr_u26;
      end   


// Best26 before age26 
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         best_bfr_age26 <= 32'hffff_ffff;         
      else if (write_enable26 & (paddr26 == `AL_BB_AGE26))
         best_bfr_age26 <= pwdata26;
      else
         best_bfr_age26 <= best_bfr_age26;
      end   


// clock26 divider26
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         div_clk26 <= 8'h00;         
      else if (write_enable26 & (paddr26 == `AL_DIV_CLK26))
         div_clk26 <= pwdata26[7:0];
      else
         div_clk26 <= div_clk26;
      end   


// command.  Needs to be automatically26 cleared26 on following26 cycle
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable26 & (paddr26 == `AL_COMMAND26))
         command <= pwdata26[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last26 invalidated26 port and address values.  These26 can either26 be updated
//   by normal26 operation26 of address checker overwriting26 existing values or
//   by the age26 checker being commanded26 to invalidate26 out of date26 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk26 or negedge n_p_reset26)
      begin 
      if (~n_p_reset26)
      begin
         lst_inv_addr_l26 <= 32'd0;
         lst_inv_addr_u26 <= 16'd0;
         lst_inv_port26   <= 2'd0;
      end
      else if (reused26)        // reused26 flag26 from address checker
      begin
         lst_inv_addr_l26 <= lst_inv_addr_nrm26[31:0];
         lst_inv_addr_u26 <= lst_inv_addr_nrm26[47:32];
         lst_inv_port26   <= lst_inv_port_nrm26;
      end
//      else if (command == 2'b01)  // invalidate26 aged26 from age26 checker
      else if (inval_in_prog26)  // invalidate26 aged26 from age26 checker
      begin
         lst_inv_addr_l26 <= lst_inv_addr_cmd26[31:0];
         lst_inv_addr_u26 <= lst_inv_addr_cmd26[47:32];
         lst_inv_port26   <= lst_inv_port_cmd26;
      end
      else
      begin
         lst_inv_addr_l26 <= lst_inv_addr_l26;
         lst_inv_addr_u26 <= lst_inv_addr_u26;
         lst_inv_port26   <= lst_inv_port26;
      end
      end
 


`ifdef ABV_ON26

defparam i_apb_monitor26.ABUS_WIDTH26 = 7;

// APB26 ASSERTION26 VIP26
apb_monitor26 i_apb_monitor26(.pclk_i26(pclk26), 
                          .presetn_i26(n_p_reset26),
                          .penable_i26(penable26),
                          .psel_i26(psel26),
                          .paddr_i26(paddr26),
                          .pwrite_i26(pwrite26),
                          .pwdata_i26(pwdata26),
                          .prdata_i26(prdata26)); 

// psl26 default clock26 = (posedge pclk26);

// ASSUMPTIONS26
//// active (set by address checker) and invalidation26 in progress26 should never both be set
//// psl26 assume_never_active_inval_aged26 : assume never (active & inval_in_prog26);


// ASSERTION26 CHECKS26
// never read and write at the same time
// psl26 assert_never_rd_wr26 : assert never (read_enable26 & write_enable26);

// check apb26 writes, pick26 command reqister26 as arbitary26 example26
// psl26 assert_cmd_wr26 : assert always ((paddr26 == `AL_COMMAND26) & write_enable26) -> 
//                                    next(command == prev(pwdata26[1:0])) abort26(~n_p_reset26);


// check rw writes, pick26 clock26 divider26 reqister26 as arbitary26 example26.  It takes26 2 cycles26 to write
// then26 read back data, therefore26 need to store26 original write data for use in assertion26 check
reg [31:0] pwdata_d26;  // 1 cycle delayed26 
always @ (posedge pclk26) pwdata_d26 <= pwdata26;

// psl26 assert_rw_div_clk26 : 
// assert always {((paddr26 == `AL_DIV_CLK26) & write_enable26) ; ((paddr26 == `AL_DIV_CLK26) & read_enable26)} |=>
// {prev(pwdata_d26[7:0]) == prdata26[7:0]};



// COVER26 SANITY26 CHECKS26
// sanity26 read
// psl26 output_for_div_clk26 : cover {((paddr26 == `AL_DIV_CLK26) & read_enable26); prdata26[7:0] == 8'h55};


`endif


endmodule 


