//File25 name   : alut_reg_bank25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

// compiler25 directives25
`include "alut_defines25.v"


module alut_reg_bank25
(   
   // Inputs25
   pclk25,
   n_p_reset25,
   psel25,            
   penable25,       
   pwrite25,         
   paddr25,           
   pwdata25,          

   curr_time25,
   add_check_active25,
   age_check_active25,
   inval_in_prog25,
   reused25,
   d_port25,
   lst_inv_addr_nrm25,
   lst_inv_port_nrm25,
   lst_inv_addr_cmd25,
   lst_inv_port_cmd25,

   // Outputs25
   mac_addr25,    
   d_addr25,   
   s_addr25,    
   s_port25,    
   best_bfr_age25,
   div_clk25,     
   command, 
   prdata25,  
   clear_reused25           
);


   // APB25 Inputs25
   input                 pclk25;             // APB25 clock25
   input                 n_p_reset25;        // Reset25
   input                 psel25;             // Module25 select25 signal25
   input                 penable25;          // Enable25 signal25 
   input                 pwrite25;           // Write when HIGH25 and read when LOW25
   input [6:0]           paddr25;            // Address bus for read write
   input [31:0]          pwdata25;           // APB25 write bus

   // Inputs25 from other ALUT25 blocks
   input [31:0]          curr_time25;        // current time
   input                 add_check_active25; // used to calculate25 status[0]
   input                 age_check_active25; // used to calculate25 status[0]
   input                 inval_in_prog25;    // status[1]
   input                 reused25;           // status[2]
   input [4:0]           d_port25;           // calculated25 destination25 port for tx25
   input [47:0]          lst_inv_addr_nrm25; // last invalidated25 addr normal25 op
   input [1:0]           lst_inv_port_nrm25; // last invalidated25 port normal25 op
   input [47:0]          lst_inv_addr_cmd25; // last invalidated25 addr via cmd25
   input [1:0]           lst_inv_port_cmd25; // last invalidated25 port via cmd25
   

   output [47:0]         mac_addr25;         // address of the switch25
   output [47:0]         d_addr25;           // address of frame25 to be checked25
   output [47:0]         s_addr25;           // address of frame25 to be stored25
   output [1:0]          s_port25;           // source25 port of current frame25
   output [31:0]         best_bfr_age25;     // best25 before age25
   output [7:0]          div_clk25;          // programmed25 clock25 divider25 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata25;           // APB25 read bus
   output                clear_reused25;     // indicates25 status reg read 

   reg    [31:0]         prdata25;           //APB25 read bus   
   reg    [31:0]         frm_d_addr_l25;     
   reg    [15:0]         frm_d_addr_u25;     
   reg    [31:0]         frm_s_addr_l25;     
   reg    [15:0]         frm_s_addr_u25;     
   reg    [1:0]          s_port25;           
   reg    [31:0]         mac_addr_l25;       
   reg    [15:0]         mac_addr_u25;       
   reg    [31:0]         best_bfr_age25;     
   reg    [7:0]          div_clk25;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l25;   
   reg    [15:0]         lst_inv_addr_u25;   
   reg    [1:0]          lst_inv_port25;     


   // Internal Signal25 Declarations25
   wire                  read_enable25;      //APB25 read enable
   wire                  write_enable25;     //APB25 write enable
   wire   [47:0]         mac_addr25;        
   wire   [47:0]         d_addr25;          
   wire   [47:0]         src_addr25;        
   wire                  clear_reused25;    
   wire                  active;

   // ----------------------------
   // General25 Assignments25
   // ----------------------------

   assign read_enable25    = (psel25 & ~penable25 & ~pwrite25);
   assign write_enable25   = (psel25 & penable25 & pwrite25);

   assign mac_addr25  = {mac_addr_u25, mac_addr_l25}; 
   assign d_addr25 =    {frm_d_addr_u25, frm_d_addr_l25};
   assign s_addr25    = {frm_s_addr_u25, frm_s_addr_l25}; 

   assign clear_reused25 = read_enable25 & (paddr25 == `AL_STATUS25) & ~active;

   assign active = (add_check_active25 | age_check_active25);

// ------------------------------------------------------------------------
//   Read Mux25 Control25 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         prdata25 <= 32'h0000_0000;
      else if (read_enable25)
         begin
         case (paddr25)
            `AL_FRM_D_ADDR_L25   : prdata25 <= frm_d_addr_l25;
            `AL_FRM_D_ADDR_U25   : prdata25 <= {16'd0, frm_d_addr_u25};    
            `AL_FRM_S_ADDR_L25   : prdata25 <= frm_s_addr_l25; 
            `AL_FRM_S_ADDR_U25   : prdata25 <= {16'd0, frm_s_addr_u25}; 
            `AL_S_PORT25         : prdata25 <= {30'd0, s_port25}; 
            `AL_D_PORT25         : prdata25 <= {27'd0, d_port25}; 
            `AL_MAC_ADDR_L25     : prdata25 <= mac_addr_l25;
            `AL_MAC_ADDR_U25     : prdata25 <= {16'd0, mac_addr_u25};   
            `AL_CUR_TIME25       : prdata25 <= curr_time25; 
            `AL_BB_AGE25         : prdata25 <= best_bfr_age25;
            `AL_DIV_CLK25        : prdata25 <= {24'd0, div_clk25}; 
            `AL_STATUS25         : prdata25 <= {29'd0, reused25, inval_in_prog25,
                                           active};
            `AL_LST_INV_ADDR_L25 : prdata25 <= lst_inv_addr_l25; 
            `AL_LST_INV_ADDR_U25 : prdata25 <= {16'd0, lst_inv_addr_u25};
            `AL_LST_INV_PORT25   : prdata25 <= {30'd0, lst_inv_port25};

            default:   prdata25 <= 32'h0000_0000;
         endcase
         end
      else
         prdata25 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB25 writable25 registers
// ------------------------------------------------------------------------
// Lower25 destination25 frame25 address register  
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         frm_d_addr_l25 <= 32'h0000_0000;         
      else if (write_enable25 & (paddr25 == `AL_FRM_D_ADDR_L25))
         frm_d_addr_l25 <= pwdata25;
      else
         frm_d_addr_l25 <= frm_d_addr_l25;
      end   


// Upper25 destination25 frame25 address register  
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         frm_d_addr_u25 <= 16'h0000;         
      else if (write_enable25 & (paddr25 == `AL_FRM_D_ADDR_U25))
         frm_d_addr_u25 <= pwdata25[15:0];
      else
         frm_d_addr_u25 <= frm_d_addr_u25;
      end   


// Lower25 source25 frame25 address register  
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         frm_s_addr_l25 <= 32'h0000_0000;         
      else if (write_enable25 & (paddr25 == `AL_FRM_S_ADDR_L25))
         frm_s_addr_l25 <= pwdata25;
      else
         frm_s_addr_l25 <= frm_s_addr_l25;
      end   


// Upper25 source25 frame25 address register  
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         frm_s_addr_u25 <= 16'h0000;         
      else if (write_enable25 & (paddr25 == `AL_FRM_S_ADDR_U25))
         frm_s_addr_u25 <= pwdata25[15:0];
      else
         frm_s_addr_u25 <= frm_s_addr_u25;
      end   


// Source25 port  
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         s_port25 <= 2'b00;         
      else if (write_enable25 & (paddr25 == `AL_S_PORT25))
         s_port25 <= pwdata25[1:0];
      else
         s_port25 <= s_port25;
      end   


// Lower25 switch25 MAC25 address
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         mac_addr_l25 <= 32'h0000_0000;         
      else if (write_enable25 & (paddr25 == `AL_MAC_ADDR_L25))
         mac_addr_l25 <= pwdata25;
      else
         mac_addr_l25 <= mac_addr_l25;
      end   


// Upper25 switch25 MAC25 address 
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         mac_addr_u25 <= 16'h0000;         
      else if (write_enable25 & (paddr25 == `AL_MAC_ADDR_U25))
         mac_addr_u25 <= pwdata25[15:0];
      else
         mac_addr_u25 <= mac_addr_u25;
      end   


// Best25 before age25 
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         best_bfr_age25 <= 32'hffff_ffff;         
      else if (write_enable25 & (paddr25 == `AL_BB_AGE25))
         best_bfr_age25 <= pwdata25;
      else
         best_bfr_age25 <= best_bfr_age25;
      end   


// clock25 divider25
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         div_clk25 <= 8'h00;         
      else if (write_enable25 & (paddr25 == `AL_DIV_CLK25))
         div_clk25 <= pwdata25[7:0];
      else
         div_clk25 <= div_clk25;
      end   


// command.  Needs to be automatically25 cleared25 on following25 cycle
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable25 & (paddr25 == `AL_COMMAND25))
         command <= pwdata25[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last25 invalidated25 port and address values.  These25 can either25 be updated
//   by normal25 operation25 of address checker overwriting25 existing values or
//   by the age25 checker being commanded25 to invalidate25 out of date25 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk25 or negedge n_p_reset25)
      begin 
      if (~n_p_reset25)
      begin
         lst_inv_addr_l25 <= 32'd0;
         lst_inv_addr_u25 <= 16'd0;
         lst_inv_port25   <= 2'd0;
      end
      else if (reused25)        // reused25 flag25 from address checker
      begin
         lst_inv_addr_l25 <= lst_inv_addr_nrm25[31:0];
         lst_inv_addr_u25 <= lst_inv_addr_nrm25[47:32];
         lst_inv_port25   <= lst_inv_port_nrm25;
      end
//      else if (command == 2'b01)  // invalidate25 aged25 from age25 checker
      else if (inval_in_prog25)  // invalidate25 aged25 from age25 checker
      begin
         lst_inv_addr_l25 <= lst_inv_addr_cmd25[31:0];
         lst_inv_addr_u25 <= lst_inv_addr_cmd25[47:32];
         lst_inv_port25   <= lst_inv_port_cmd25;
      end
      else
      begin
         lst_inv_addr_l25 <= lst_inv_addr_l25;
         lst_inv_addr_u25 <= lst_inv_addr_u25;
         lst_inv_port25   <= lst_inv_port25;
      end
      end
 


`ifdef ABV_ON25

defparam i_apb_monitor25.ABUS_WIDTH25 = 7;

// APB25 ASSERTION25 VIP25
apb_monitor25 i_apb_monitor25(.pclk_i25(pclk25), 
                          .presetn_i25(n_p_reset25),
                          .penable_i25(penable25),
                          .psel_i25(psel25),
                          .paddr_i25(paddr25),
                          .pwrite_i25(pwrite25),
                          .pwdata_i25(pwdata25),
                          .prdata_i25(prdata25)); 

// psl25 default clock25 = (posedge pclk25);

// ASSUMPTIONS25
//// active (set by address checker) and invalidation25 in progress25 should never both be set
//// psl25 assume_never_active_inval_aged25 : assume never (active & inval_in_prog25);


// ASSERTION25 CHECKS25
// never read and write at the same time
// psl25 assert_never_rd_wr25 : assert never (read_enable25 & write_enable25);

// check apb25 writes, pick25 command reqister25 as arbitary25 example25
// psl25 assert_cmd_wr25 : assert always ((paddr25 == `AL_COMMAND25) & write_enable25) -> 
//                                    next(command == prev(pwdata25[1:0])) abort25(~n_p_reset25);


// check rw writes, pick25 clock25 divider25 reqister25 as arbitary25 example25.  It takes25 2 cycles25 to write
// then25 read back data, therefore25 need to store25 original write data for use in assertion25 check
reg [31:0] pwdata_d25;  // 1 cycle delayed25 
always @ (posedge pclk25) pwdata_d25 <= pwdata25;

// psl25 assert_rw_div_clk25 : 
// assert always {((paddr25 == `AL_DIV_CLK25) & write_enable25) ; ((paddr25 == `AL_DIV_CLK25) & read_enable25)} |=>
// {prev(pwdata_d25[7:0]) == prdata25[7:0]};



// COVER25 SANITY25 CHECKS25
// sanity25 read
// psl25 output_for_div_clk25 : cover {((paddr25 == `AL_DIV_CLK25) & read_enable25); prdata25[7:0] == 8'h55};


`endif


endmodule 


