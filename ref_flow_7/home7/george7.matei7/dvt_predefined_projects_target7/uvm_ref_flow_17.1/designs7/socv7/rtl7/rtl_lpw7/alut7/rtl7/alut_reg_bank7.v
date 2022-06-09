//File7 name   : alut_reg_bank7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

// compiler7 directives7
`include "alut_defines7.v"


module alut_reg_bank7
(   
   // Inputs7
   pclk7,
   n_p_reset7,
   psel7,            
   penable7,       
   pwrite7,         
   paddr7,           
   pwdata7,          

   curr_time7,
   add_check_active7,
   age_check_active7,
   inval_in_prog7,
   reused7,
   d_port7,
   lst_inv_addr_nrm7,
   lst_inv_port_nrm7,
   lst_inv_addr_cmd7,
   lst_inv_port_cmd7,

   // Outputs7
   mac_addr7,    
   d_addr7,   
   s_addr7,    
   s_port7,    
   best_bfr_age7,
   div_clk7,     
   command, 
   prdata7,  
   clear_reused7           
);


   // APB7 Inputs7
   input                 pclk7;             // APB7 clock7
   input                 n_p_reset7;        // Reset7
   input                 psel7;             // Module7 select7 signal7
   input                 penable7;          // Enable7 signal7 
   input                 pwrite7;           // Write when HIGH7 and read when LOW7
   input [6:0]           paddr7;            // Address bus for read write
   input [31:0]          pwdata7;           // APB7 write bus

   // Inputs7 from other ALUT7 blocks
   input [31:0]          curr_time7;        // current time
   input                 add_check_active7; // used to calculate7 status[0]
   input                 age_check_active7; // used to calculate7 status[0]
   input                 inval_in_prog7;    // status[1]
   input                 reused7;           // status[2]
   input [4:0]           d_port7;           // calculated7 destination7 port for tx7
   input [47:0]          lst_inv_addr_nrm7; // last invalidated7 addr normal7 op
   input [1:0]           lst_inv_port_nrm7; // last invalidated7 port normal7 op
   input [47:0]          lst_inv_addr_cmd7; // last invalidated7 addr via cmd7
   input [1:0]           lst_inv_port_cmd7; // last invalidated7 port via cmd7
   

   output [47:0]         mac_addr7;         // address of the switch7
   output [47:0]         d_addr7;           // address of frame7 to be checked7
   output [47:0]         s_addr7;           // address of frame7 to be stored7
   output [1:0]          s_port7;           // source7 port of current frame7
   output [31:0]         best_bfr_age7;     // best7 before age7
   output [7:0]          div_clk7;          // programmed7 clock7 divider7 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata7;           // APB7 read bus
   output                clear_reused7;     // indicates7 status reg read 

   reg    [31:0]         prdata7;           //APB7 read bus   
   reg    [31:0]         frm_d_addr_l7;     
   reg    [15:0]         frm_d_addr_u7;     
   reg    [31:0]         frm_s_addr_l7;     
   reg    [15:0]         frm_s_addr_u7;     
   reg    [1:0]          s_port7;           
   reg    [31:0]         mac_addr_l7;       
   reg    [15:0]         mac_addr_u7;       
   reg    [31:0]         best_bfr_age7;     
   reg    [7:0]          div_clk7;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l7;   
   reg    [15:0]         lst_inv_addr_u7;   
   reg    [1:0]          lst_inv_port7;     


   // Internal Signal7 Declarations7
   wire                  read_enable7;      //APB7 read enable
   wire                  write_enable7;     //APB7 write enable
   wire   [47:0]         mac_addr7;        
   wire   [47:0]         d_addr7;          
   wire   [47:0]         src_addr7;        
   wire                  clear_reused7;    
   wire                  active;

   // ----------------------------
   // General7 Assignments7
   // ----------------------------

   assign read_enable7    = (psel7 & ~penable7 & ~pwrite7);
   assign write_enable7   = (psel7 & penable7 & pwrite7);

   assign mac_addr7  = {mac_addr_u7, mac_addr_l7}; 
   assign d_addr7 =    {frm_d_addr_u7, frm_d_addr_l7};
   assign s_addr7    = {frm_s_addr_u7, frm_s_addr_l7}; 

   assign clear_reused7 = read_enable7 & (paddr7 == `AL_STATUS7) & ~active;

   assign active = (add_check_active7 | age_check_active7);

// ------------------------------------------------------------------------
//   Read Mux7 Control7 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         prdata7 <= 32'h0000_0000;
      else if (read_enable7)
         begin
         case (paddr7)
            `AL_FRM_D_ADDR_L7   : prdata7 <= frm_d_addr_l7;
            `AL_FRM_D_ADDR_U7   : prdata7 <= {16'd0, frm_d_addr_u7};    
            `AL_FRM_S_ADDR_L7   : prdata7 <= frm_s_addr_l7; 
            `AL_FRM_S_ADDR_U7   : prdata7 <= {16'd0, frm_s_addr_u7}; 
            `AL_S_PORT7         : prdata7 <= {30'd0, s_port7}; 
            `AL_D_PORT7         : prdata7 <= {27'd0, d_port7}; 
            `AL_MAC_ADDR_L7     : prdata7 <= mac_addr_l7;
            `AL_MAC_ADDR_U7     : prdata7 <= {16'd0, mac_addr_u7};   
            `AL_CUR_TIME7       : prdata7 <= curr_time7; 
            `AL_BB_AGE7         : prdata7 <= best_bfr_age7;
            `AL_DIV_CLK7        : prdata7 <= {24'd0, div_clk7}; 
            `AL_STATUS7         : prdata7 <= {29'd0, reused7, inval_in_prog7,
                                           active};
            `AL_LST_INV_ADDR_L7 : prdata7 <= lst_inv_addr_l7; 
            `AL_LST_INV_ADDR_U7 : prdata7 <= {16'd0, lst_inv_addr_u7};
            `AL_LST_INV_PORT7   : prdata7 <= {30'd0, lst_inv_port7};

            default:   prdata7 <= 32'h0000_0000;
         endcase
         end
      else
         prdata7 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB7 writable7 registers
// ------------------------------------------------------------------------
// Lower7 destination7 frame7 address register  
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         frm_d_addr_l7 <= 32'h0000_0000;         
      else if (write_enable7 & (paddr7 == `AL_FRM_D_ADDR_L7))
         frm_d_addr_l7 <= pwdata7;
      else
         frm_d_addr_l7 <= frm_d_addr_l7;
      end   


// Upper7 destination7 frame7 address register  
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         frm_d_addr_u7 <= 16'h0000;         
      else if (write_enable7 & (paddr7 == `AL_FRM_D_ADDR_U7))
         frm_d_addr_u7 <= pwdata7[15:0];
      else
         frm_d_addr_u7 <= frm_d_addr_u7;
      end   


// Lower7 source7 frame7 address register  
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         frm_s_addr_l7 <= 32'h0000_0000;         
      else if (write_enable7 & (paddr7 == `AL_FRM_S_ADDR_L7))
         frm_s_addr_l7 <= pwdata7;
      else
         frm_s_addr_l7 <= frm_s_addr_l7;
      end   


// Upper7 source7 frame7 address register  
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         frm_s_addr_u7 <= 16'h0000;         
      else if (write_enable7 & (paddr7 == `AL_FRM_S_ADDR_U7))
         frm_s_addr_u7 <= pwdata7[15:0];
      else
         frm_s_addr_u7 <= frm_s_addr_u7;
      end   


// Source7 port  
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         s_port7 <= 2'b00;         
      else if (write_enable7 & (paddr7 == `AL_S_PORT7))
         s_port7 <= pwdata7[1:0];
      else
         s_port7 <= s_port7;
      end   


// Lower7 switch7 MAC7 address
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         mac_addr_l7 <= 32'h0000_0000;         
      else if (write_enable7 & (paddr7 == `AL_MAC_ADDR_L7))
         mac_addr_l7 <= pwdata7;
      else
         mac_addr_l7 <= mac_addr_l7;
      end   


// Upper7 switch7 MAC7 address 
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         mac_addr_u7 <= 16'h0000;         
      else if (write_enable7 & (paddr7 == `AL_MAC_ADDR_U7))
         mac_addr_u7 <= pwdata7[15:0];
      else
         mac_addr_u7 <= mac_addr_u7;
      end   


// Best7 before age7 
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         best_bfr_age7 <= 32'hffff_ffff;         
      else if (write_enable7 & (paddr7 == `AL_BB_AGE7))
         best_bfr_age7 <= pwdata7;
      else
         best_bfr_age7 <= best_bfr_age7;
      end   


// clock7 divider7
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         div_clk7 <= 8'h00;         
      else if (write_enable7 & (paddr7 == `AL_DIV_CLK7))
         div_clk7 <= pwdata7[7:0];
      else
         div_clk7 <= div_clk7;
      end   


// command.  Needs to be automatically7 cleared7 on following7 cycle
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable7 & (paddr7 == `AL_COMMAND7))
         command <= pwdata7[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last7 invalidated7 port and address values.  These7 can either7 be updated
//   by normal7 operation7 of address checker overwriting7 existing values or
//   by the age7 checker being commanded7 to invalidate7 out of date7 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk7 or negedge n_p_reset7)
      begin 
      if (~n_p_reset7)
      begin
         lst_inv_addr_l7 <= 32'd0;
         lst_inv_addr_u7 <= 16'd0;
         lst_inv_port7   <= 2'd0;
      end
      else if (reused7)        // reused7 flag7 from address checker
      begin
         lst_inv_addr_l7 <= lst_inv_addr_nrm7[31:0];
         lst_inv_addr_u7 <= lst_inv_addr_nrm7[47:32];
         lst_inv_port7   <= lst_inv_port_nrm7;
      end
//      else if (command == 2'b01)  // invalidate7 aged7 from age7 checker
      else if (inval_in_prog7)  // invalidate7 aged7 from age7 checker
      begin
         lst_inv_addr_l7 <= lst_inv_addr_cmd7[31:0];
         lst_inv_addr_u7 <= lst_inv_addr_cmd7[47:32];
         lst_inv_port7   <= lst_inv_port_cmd7;
      end
      else
      begin
         lst_inv_addr_l7 <= lst_inv_addr_l7;
         lst_inv_addr_u7 <= lst_inv_addr_u7;
         lst_inv_port7   <= lst_inv_port7;
      end
      end
 


`ifdef ABV_ON7

defparam i_apb_monitor7.ABUS_WIDTH7 = 7;

// APB7 ASSERTION7 VIP7
apb_monitor7 i_apb_monitor7(.pclk_i7(pclk7), 
                          .presetn_i7(n_p_reset7),
                          .penable_i7(penable7),
                          .psel_i7(psel7),
                          .paddr_i7(paddr7),
                          .pwrite_i7(pwrite7),
                          .pwdata_i7(pwdata7),
                          .prdata_i7(prdata7)); 

// psl7 default clock7 = (posedge pclk7);

// ASSUMPTIONS7
//// active (set by address checker) and invalidation7 in progress7 should never both be set
//// psl7 assume_never_active_inval_aged7 : assume never (active & inval_in_prog7);


// ASSERTION7 CHECKS7
// never read and write at the same time
// psl7 assert_never_rd_wr7 : assert never (read_enable7 & write_enable7);

// check apb7 writes, pick7 command reqister7 as arbitary7 example7
// psl7 assert_cmd_wr7 : assert always ((paddr7 == `AL_COMMAND7) & write_enable7) -> 
//                                    next(command == prev(pwdata7[1:0])) abort7(~n_p_reset7);


// check rw writes, pick7 clock7 divider7 reqister7 as arbitary7 example7.  It takes7 2 cycles7 to write
// then7 read back data, therefore7 need to store7 original write data for use in assertion7 check
reg [31:0] pwdata_d7;  // 1 cycle delayed7 
always @ (posedge pclk7) pwdata_d7 <= pwdata7;

// psl7 assert_rw_div_clk7 : 
// assert always {((paddr7 == `AL_DIV_CLK7) & write_enable7) ; ((paddr7 == `AL_DIV_CLK7) & read_enable7)} |=>
// {prev(pwdata_d7[7:0]) == prdata7[7:0]};



// COVER7 SANITY7 CHECKS7
// sanity7 read
// psl7 output_for_div_clk7 : cover {((paddr7 == `AL_DIV_CLK7) & read_enable7); prdata7[7:0] == 8'h55};


`endif


endmodule 


