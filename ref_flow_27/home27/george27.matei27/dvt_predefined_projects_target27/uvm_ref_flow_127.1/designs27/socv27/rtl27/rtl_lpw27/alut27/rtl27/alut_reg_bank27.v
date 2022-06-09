//File27 name   : alut_reg_bank27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

// compiler27 directives27
`include "alut_defines27.v"


module alut_reg_bank27
(   
   // Inputs27
   pclk27,
   n_p_reset27,
   psel27,            
   penable27,       
   pwrite27,         
   paddr27,           
   pwdata27,          

   curr_time27,
   add_check_active27,
   age_check_active27,
   inval_in_prog27,
   reused27,
   d_port27,
   lst_inv_addr_nrm27,
   lst_inv_port_nrm27,
   lst_inv_addr_cmd27,
   lst_inv_port_cmd27,

   // Outputs27
   mac_addr27,    
   d_addr27,   
   s_addr27,    
   s_port27,    
   best_bfr_age27,
   div_clk27,     
   command, 
   prdata27,  
   clear_reused27           
);


   // APB27 Inputs27
   input                 pclk27;             // APB27 clock27
   input                 n_p_reset27;        // Reset27
   input                 psel27;             // Module27 select27 signal27
   input                 penable27;          // Enable27 signal27 
   input                 pwrite27;           // Write when HIGH27 and read when LOW27
   input [6:0]           paddr27;            // Address bus for read write
   input [31:0]          pwdata27;           // APB27 write bus

   // Inputs27 from other ALUT27 blocks
   input [31:0]          curr_time27;        // current time
   input                 add_check_active27; // used to calculate27 status[0]
   input                 age_check_active27; // used to calculate27 status[0]
   input                 inval_in_prog27;    // status[1]
   input                 reused27;           // status[2]
   input [4:0]           d_port27;           // calculated27 destination27 port for tx27
   input [47:0]          lst_inv_addr_nrm27; // last invalidated27 addr normal27 op
   input [1:0]           lst_inv_port_nrm27; // last invalidated27 port normal27 op
   input [47:0]          lst_inv_addr_cmd27; // last invalidated27 addr via cmd27
   input [1:0]           lst_inv_port_cmd27; // last invalidated27 port via cmd27
   

   output [47:0]         mac_addr27;         // address of the switch27
   output [47:0]         d_addr27;           // address of frame27 to be checked27
   output [47:0]         s_addr27;           // address of frame27 to be stored27
   output [1:0]          s_port27;           // source27 port of current frame27
   output [31:0]         best_bfr_age27;     // best27 before age27
   output [7:0]          div_clk27;          // programmed27 clock27 divider27 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata27;           // APB27 read bus
   output                clear_reused27;     // indicates27 status reg read 

   reg    [31:0]         prdata27;           //APB27 read bus   
   reg    [31:0]         frm_d_addr_l27;     
   reg    [15:0]         frm_d_addr_u27;     
   reg    [31:0]         frm_s_addr_l27;     
   reg    [15:0]         frm_s_addr_u27;     
   reg    [1:0]          s_port27;           
   reg    [31:0]         mac_addr_l27;       
   reg    [15:0]         mac_addr_u27;       
   reg    [31:0]         best_bfr_age27;     
   reg    [7:0]          div_clk27;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l27;   
   reg    [15:0]         lst_inv_addr_u27;   
   reg    [1:0]          lst_inv_port27;     


   // Internal Signal27 Declarations27
   wire                  read_enable27;      //APB27 read enable
   wire                  write_enable27;     //APB27 write enable
   wire   [47:0]         mac_addr27;        
   wire   [47:0]         d_addr27;          
   wire   [47:0]         src_addr27;        
   wire                  clear_reused27;    
   wire                  active;

   // ----------------------------
   // General27 Assignments27
   // ----------------------------

   assign read_enable27    = (psel27 & ~penable27 & ~pwrite27);
   assign write_enable27   = (psel27 & penable27 & pwrite27);

   assign mac_addr27  = {mac_addr_u27, mac_addr_l27}; 
   assign d_addr27 =    {frm_d_addr_u27, frm_d_addr_l27};
   assign s_addr27    = {frm_s_addr_u27, frm_s_addr_l27}; 

   assign clear_reused27 = read_enable27 & (paddr27 == `AL_STATUS27) & ~active;

   assign active = (add_check_active27 | age_check_active27);

// ------------------------------------------------------------------------
//   Read Mux27 Control27 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         prdata27 <= 32'h0000_0000;
      else if (read_enable27)
         begin
         case (paddr27)
            `AL_FRM_D_ADDR_L27   : prdata27 <= frm_d_addr_l27;
            `AL_FRM_D_ADDR_U27   : prdata27 <= {16'd0, frm_d_addr_u27};    
            `AL_FRM_S_ADDR_L27   : prdata27 <= frm_s_addr_l27; 
            `AL_FRM_S_ADDR_U27   : prdata27 <= {16'd0, frm_s_addr_u27}; 
            `AL_S_PORT27         : prdata27 <= {30'd0, s_port27}; 
            `AL_D_PORT27         : prdata27 <= {27'd0, d_port27}; 
            `AL_MAC_ADDR_L27     : prdata27 <= mac_addr_l27;
            `AL_MAC_ADDR_U27     : prdata27 <= {16'd0, mac_addr_u27};   
            `AL_CUR_TIME27       : prdata27 <= curr_time27; 
            `AL_BB_AGE27         : prdata27 <= best_bfr_age27;
            `AL_DIV_CLK27        : prdata27 <= {24'd0, div_clk27}; 
            `AL_STATUS27         : prdata27 <= {29'd0, reused27, inval_in_prog27,
                                           active};
            `AL_LST_INV_ADDR_L27 : prdata27 <= lst_inv_addr_l27; 
            `AL_LST_INV_ADDR_U27 : prdata27 <= {16'd0, lst_inv_addr_u27};
            `AL_LST_INV_PORT27   : prdata27 <= {30'd0, lst_inv_port27};

            default:   prdata27 <= 32'h0000_0000;
         endcase
         end
      else
         prdata27 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB27 writable27 registers
// ------------------------------------------------------------------------
// Lower27 destination27 frame27 address register  
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         frm_d_addr_l27 <= 32'h0000_0000;         
      else if (write_enable27 & (paddr27 == `AL_FRM_D_ADDR_L27))
         frm_d_addr_l27 <= pwdata27;
      else
         frm_d_addr_l27 <= frm_d_addr_l27;
      end   


// Upper27 destination27 frame27 address register  
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         frm_d_addr_u27 <= 16'h0000;         
      else if (write_enable27 & (paddr27 == `AL_FRM_D_ADDR_U27))
         frm_d_addr_u27 <= pwdata27[15:0];
      else
         frm_d_addr_u27 <= frm_d_addr_u27;
      end   


// Lower27 source27 frame27 address register  
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         frm_s_addr_l27 <= 32'h0000_0000;         
      else if (write_enable27 & (paddr27 == `AL_FRM_S_ADDR_L27))
         frm_s_addr_l27 <= pwdata27;
      else
         frm_s_addr_l27 <= frm_s_addr_l27;
      end   


// Upper27 source27 frame27 address register  
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         frm_s_addr_u27 <= 16'h0000;         
      else if (write_enable27 & (paddr27 == `AL_FRM_S_ADDR_U27))
         frm_s_addr_u27 <= pwdata27[15:0];
      else
         frm_s_addr_u27 <= frm_s_addr_u27;
      end   


// Source27 port  
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         s_port27 <= 2'b00;         
      else if (write_enable27 & (paddr27 == `AL_S_PORT27))
         s_port27 <= pwdata27[1:0];
      else
         s_port27 <= s_port27;
      end   


// Lower27 switch27 MAC27 address
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         mac_addr_l27 <= 32'h0000_0000;         
      else if (write_enable27 & (paddr27 == `AL_MAC_ADDR_L27))
         mac_addr_l27 <= pwdata27;
      else
         mac_addr_l27 <= mac_addr_l27;
      end   


// Upper27 switch27 MAC27 address 
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         mac_addr_u27 <= 16'h0000;         
      else if (write_enable27 & (paddr27 == `AL_MAC_ADDR_U27))
         mac_addr_u27 <= pwdata27[15:0];
      else
         mac_addr_u27 <= mac_addr_u27;
      end   


// Best27 before age27 
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         best_bfr_age27 <= 32'hffff_ffff;         
      else if (write_enable27 & (paddr27 == `AL_BB_AGE27))
         best_bfr_age27 <= pwdata27;
      else
         best_bfr_age27 <= best_bfr_age27;
      end   


// clock27 divider27
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         div_clk27 <= 8'h00;         
      else if (write_enable27 & (paddr27 == `AL_DIV_CLK27))
         div_clk27 <= pwdata27[7:0];
      else
         div_clk27 <= div_clk27;
      end   


// command.  Needs to be automatically27 cleared27 on following27 cycle
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable27 & (paddr27 == `AL_COMMAND27))
         command <= pwdata27[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last27 invalidated27 port and address values.  These27 can either27 be updated
//   by normal27 operation27 of address checker overwriting27 existing values or
//   by the age27 checker being commanded27 to invalidate27 out of date27 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk27 or negedge n_p_reset27)
      begin 
      if (~n_p_reset27)
      begin
         lst_inv_addr_l27 <= 32'd0;
         lst_inv_addr_u27 <= 16'd0;
         lst_inv_port27   <= 2'd0;
      end
      else if (reused27)        // reused27 flag27 from address checker
      begin
         lst_inv_addr_l27 <= lst_inv_addr_nrm27[31:0];
         lst_inv_addr_u27 <= lst_inv_addr_nrm27[47:32];
         lst_inv_port27   <= lst_inv_port_nrm27;
      end
//      else if (command == 2'b01)  // invalidate27 aged27 from age27 checker
      else if (inval_in_prog27)  // invalidate27 aged27 from age27 checker
      begin
         lst_inv_addr_l27 <= lst_inv_addr_cmd27[31:0];
         lst_inv_addr_u27 <= lst_inv_addr_cmd27[47:32];
         lst_inv_port27   <= lst_inv_port_cmd27;
      end
      else
      begin
         lst_inv_addr_l27 <= lst_inv_addr_l27;
         lst_inv_addr_u27 <= lst_inv_addr_u27;
         lst_inv_port27   <= lst_inv_port27;
      end
      end
 


`ifdef ABV_ON27

defparam i_apb_monitor27.ABUS_WIDTH27 = 7;

// APB27 ASSERTION27 VIP27
apb_monitor27 i_apb_monitor27(.pclk_i27(pclk27), 
                          .presetn_i27(n_p_reset27),
                          .penable_i27(penable27),
                          .psel_i27(psel27),
                          .paddr_i27(paddr27),
                          .pwrite_i27(pwrite27),
                          .pwdata_i27(pwdata27),
                          .prdata_i27(prdata27)); 

// psl27 default clock27 = (posedge pclk27);

// ASSUMPTIONS27
//// active (set by address checker) and invalidation27 in progress27 should never both be set
//// psl27 assume_never_active_inval_aged27 : assume never (active & inval_in_prog27);


// ASSERTION27 CHECKS27
// never read and write at the same time
// psl27 assert_never_rd_wr27 : assert never (read_enable27 & write_enable27);

// check apb27 writes, pick27 command reqister27 as arbitary27 example27
// psl27 assert_cmd_wr27 : assert always ((paddr27 == `AL_COMMAND27) & write_enable27) -> 
//                                    next(command == prev(pwdata27[1:0])) abort27(~n_p_reset27);


// check rw writes, pick27 clock27 divider27 reqister27 as arbitary27 example27.  It takes27 2 cycles27 to write
// then27 read back data, therefore27 need to store27 original write data for use in assertion27 check
reg [31:0] pwdata_d27;  // 1 cycle delayed27 
always @ (posedge pclk27) pwdata_d27 <= pwdata27;

// psl27 assert_rw_div_clk27 : 
// assert always {((paddr27 == `AL_DIV_CLK27) & write_enable27) ; ((paddr27 == `AL_DIV_CLK27) & read_enable27)} |=>
// {prev(pwdata_d27[7:0]) == prdata27[7:0]};



// COVER27 SANITY27 CHECKS27
// sanity27 read
// psl27 output_for_div_clk27 : cover {((paddr27 == `AL_DIV_CLK27) & read_enable27); prdata27[7:0] == 8'h55};


`endif


endmodule 


