//File6 name   : alut_reg_bank6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

// compiler6 directives6
`include "alut_defines6.v"


module alut_reg_bank6
(   
   // Inputs6
   pclk6,
   n_p_reset6,
   psel6,            
   penable6,       
   pwrite6,         
   paddr6,           
   pwdata6,          

   curr_time6,
   add_check_active6,
   age_check_active6,
   inval_in_prog6,
   reused6,
   d_port6,
   lst_inv_addr_nrm6,
   lst_inv_port_nrm6,
   lst_inv_addr_cmd6,
   lst_inv_port_cmd6,

   // Outputs6
   mac_addr6,    
   d_addr6,   
   s_addr6,    
   s_port6,    
   best_bfr_age6,
   div_clk6,     
   command, 
   prdata6,  
   clear_reused6           
);


   // APB6 Inputs6
   input                 pclk6;             // APB6 clock6
   input                 n_p_reset6;        // Reset6
   input                 psel6;             // Module6 select6 signal6
   input                 penable6;          // Enable6 signal6 
   input                 pwrite6;           // Write when HIGH6 and read when LOW6
   input [6:0]           paddr6;            // Address bus for read write
   input [31:0]          pwdata6;           // APB6 write bus

   // Inputs6 from other ALUT6 blocks
   input [31:0]          curr_time6;        // current time
   input                 add_check_active6; // used to calculate6 status[0]
   input                 age_check_active6; // used to calculate6 status[0]
   input                 inval_in_prog6;    // status[1]
   input                 reused6;           // status[2]
   input [4:0]           d_port6;           // calculated6 destination6 port for tx6
   input [47:0]          lst_inv_addr_nrm6; // last invalidated6 addr normal6 op
   input [1:0]           lst_inv_port_nrm6; // last invalidated6 port normal6 op
   input [47:0]          lst_inv_addr_cmd6; // last invalidated6 addr via cmd6
   input [1:0]           lst_inv_port_cmd6; // last invalidated6 port via cmd6
   

   output [47:0]         mac_addr6;         // address of the switch6
   output [47:0]         d_addr6;           // address of frame6 to be checked6
   output [47:0]         s_addr6;           // address of frame6 to be stored6
   output [1:0]          s_port6;           // source6 port of current frame6
   output [31:0]         best_bfr_age6;     // best6 before age6
   output [7:0]          div_clk6;          // programmed6 clock6 divider6 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata6;           // APB6 read bus
   output                clear_reused6;     // indicates6 status reg read 

   reg    [31:0]         prdata6;           //APB6 read bus   
   reg    [31:0]         frm_d_addr_l6;     
   reg    [15:0]         frm_d_addr_u6;     
   reg    [31:0]         frm_s_addr_l6;     
   reg    [15:0]         frm_s_addr_u6;     
   reg    [1:0]          s_port6;           
   reg    [31:0]         mac_addr_l6;       
   reg    [15:0]         mac_addr_u6;       
   reg    [31:0]         best_bfr_age6;     
   reg    [7:0]          div_clk6;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l6;   
   reg    [15:0]         lst_inv_addr_u6;   
   reg    [1:0]          lst_inv_port6;     


   // Internal Signal6 Declarations6
   wire                  read_enable6;      //APB6 read enable
   wire                  write_enable6;     //APB6 write enable
   wire   [47:0]         mac_addr6;        
   wire   [47:0]         d_addr6;          
   wire   [47:0]         src_addr6;        
   wire                  clear_reused6;    
   wire                  active;

   // ----------------------------
   // General6 Assignments6
   // ----------------------------

   assign read_enable6    = (psel6 & ~penable6 & ~pwrite6);
   assign write_enable6   = (psel6 & penable6 & pwrite6);

   assign mac_addr6  = {mac_addr_u6, mac_addr_l6}; 
   assign d_addr6 =    {frm_d_addr_u6, frm_d_addr_l6};
   assign s_addr6    = {frm_s_addr_u6, frm_s_addr_l6}; 

   assign clear_reused6 = read_enable6 & (paddr6 == `AL_STATUS6) & ~active;

   assign active = (add_check_active6 | age_check_active6);

// ------------------------------------------------------------------------
//   Read Mux6 Control6 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         prdata6 <= 32'h0000_0000;
      else if (read_enable6)
         begin
         case (paddr6)
            `AL_FRM_D_ADDR_L6   : prdata6 <= frm_d_addr_l6;
            `AL_FRM_D_ADDR_U6   : prdata6 <= {16'd0, frm_d_addr_u6};    
            `AL_FRM_S_ADDR_L6   : prdata6 <= frm_s_addr_l6; 
            `AL_FRM_S_ADDR_U6   : prdata6 <= {16'd0, frm_s_addr_u6}; 
            `AL_S_PORT6         : prdata6 <= {30'd0, s_port6}; 
            `AL_D_PORT6         : prdata6 <= {27'd0, d_port6}; 
            `AL_MAC_ADDR_L6     : prdata6 <= mac_addr_l6;
            `AL_MAC_ADDR_U6     : prdata6 <= {16'd0, mac_addr_u6};   
            `AL_CUR_TIME6       : prdata6 <= curr_time6; 
            `AL_BB_AGE6         : prdata6 <= best_bfr_age6;
            `AL_DIV_CLK6        : prdata6 <= {24'd0, div_clk6}; 
            `AL_STATUS6         : prdata6 <= {29'd0, reused6, inval_in_prog6,
                                           active};
            `AL_LST_INV_ADDR_L6 : prdata6 <= lst_inv_addr_l6; 
            `AL_LST_INV_ADDR_U6 : prdata6 <= {16'd0, lst_inv_addr_u6};
            `AL_LST_INV_PORT6   : prdata6 <= {30'd0, lst_inv_port6};

            default:   prdata6 <= 32'h0000_0000;
         endcase
         end
      else
         prdata6 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB6 writable6 registers
// ------------------------------------------------------------------------
// Lower6 destination6 frame6 address register  
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         frm_d_addr_l6 <= 32'h0000_0000;         
      else if (write_enable6 & (paddr6 == `AL_FRM_D_ADDR_L6))
         frm_d_addr_l6 <= pwdata6;
      else
         frm_d_addr_l6 <= frm_d_addr_l6;
      end   


// Upper6 destination6 frame6 address register  
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         frm_d_addr_u6 <= 16'h0000;         
      else if (write_enable6 & (paddr6 == `AL_FRM_D_ADDR_U6))
         frm_d_addr_u6 <= pwdata6[15:0];
      else
         frm_d_addr_u6 <= frm_d_addr_u6;
      end   


// Lower6 source6 frame6 address register  
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         frm_s_addr_l6 <= 32'h0000_0000;         
      else if (write_enable6 & (paddr6 == `AL_FRM_S_ADDR_L6))
         frm_s_addr_l6 <= pwdata6;
      else
         frm_s_addr_l6 <= frm_s_addr_l6;
      end   


// Upper6 source6 frame6 address register  
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         frm_s_addr_u6 <= 16'h0000;         
      else if (write_enable6 & (paddr6 == `AL_FRM_S_ADDR_U6))
         frm_s_addr_u6 <= pwdata6[15:0];
      else
         frm_s_addr_u6 <= frm_s_addr_u6;
      end   


// Source6 port  
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         s_port6 <= 2'b00;         
      else if (write_enable6 & (paddr6 == `AL_S_PORT6))
         s_port6 <= pwdata6[1:0];
      else
         s_port6 <= s_port6;
      end   


// Lower6 switch6 MAC6 address
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         mac_addr_l6 <= 32'h0000_0000;         
      else if (write_enable6 & (paddr6 == `AL_MAC_ADDR_L6))
         mac_addr_l6 <= pwdata6;
      else
         mac_addr_l6 <= mac_addr_l6;
      end   


// Upper6 switch6 MAC6 address 
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         mac_addr_u6 <= 16'h0000;         
      else if (write_enable6 & (paddr6 == `AL_MAC_ADDR_U6))
         mac_addr_u6 <= pwdata6[15:0];
      else
         mac_addr_u6 <= mac_addr_u6;
      end   


// Best6 before age6 
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         best_bfr_age6 <= 32'hffff_ffff;         
      else if (write_enable6 & (paddr6 == `AL_BB_AGE6))
         best_bfr_age6 <= pwdata6;
      else
         best_bfr_age6 <= best_bfr_age6;
      end   


// clock6 divider6
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         div_clk6 <= 8'h00;         
      else if (write_enable6 & (paddr6 == `AL_DIV_CLK6))
         div_clk6 <= pwdata6[7:0];
      else
         div_clk6 <= div_clk6;
      end   


// command.  Needs to be automatically6 cleared6 on following6 cycle
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable6 & (paddr6 == `AL_COMMAND6))
         command <= pwdata6[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last6 invalidated6 port and address values.  These6 can either6 be updated
//   by normal6 operation6 of address checker overwriting6 existing values or
//   by the age6 checker being commanded6 to invalidate6 out of date6 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk6 or negedge n_p_reset6)
      begin 
      if (~n_p_reset6)
      begin
         lst_inv_addr_l6 <= 32'd0;
         lst_inv_addr_u6 <= 16'd0;
         lst_inv_port6   <= 2'd0;
      end
      else if (reused6)        // reused6 flag6 from address checker
      begin
         lst_inv_addr_l6 <= lst_inv_addr_nrm6[31:0];
         lst_inv_addr_u6 <= lst_inv_addr_nrm6[47:32];
         lst_inv_port6   <= lst_inv_port_nrm6;
      end
//      else if (command == 2'b01)  // invalidate6 aged6 from age6 checker
      else if (inval_in_prog6)  // invalidate6 aged6 from age6 checker
      begin
         lst_inv_addr_l6 <= lst_inv_addr_cmd6[31:0];
         lst_inv_addr_u6 <= lst_inv_addr_cmd6[47:32];
         lst_inv_port6   <= lst_inv_port_cmd6;
      end
      else
      begin
         lst_inv_addr_l6 <= lst_inv_addr_l6;
         lst_inv_addr_u6 <= lst_inv_addr_u6;
         lst_inv_port6   <= lst_inv_port6;
      end
      end
 


`ifdef ABV_ON6

defparam i_apb_monitor6.ABUS_WIDTH6 = 7;

// APB6 ASSERTION6 VIP6
apb_monitor6 i_apb_monitor6(.pclk_i6(pclk6), 
                          .presetn_i6(n_p_reset6),
                          .penable_i6(penable6),
                          .psel_i6(psel6),
                          .paddr_i6(paddr6),
                          .pwrite_i6(pwrite6),
                          .pwdata_i6(pwdata6),
                          .prdata_i6(prdata6)); 

// psl6 default clock6 = (posedge pclk6);

// ASSUMPTIONS6
//// active (set by address checker) and invalidation6 in progress6 should never both be set
//// psl6 assume_never_active_inval_aged6 : assume never (active & inval_in_prog6);


// ASSERTION6 CHECKS6
// never read and write at the same time
// psl6 assert_never_rd_wr6 : assert never (read_enable6 & write_enable6);

// check apb6 writes, pick6 command reqister6 as arbitary6 example6
// psl6 assert_cmd_wr6 : assert always ((paddr6 == `AL_COMMAND6) & write_enable6) -> 
//                                    next(command == prev(pwdata6[1:0])) abort6(~n_p_reset6);


// check rw writes, pick6 clock6 divider6 reqister6 as arbitary6 example6.  It takes6 2 cycles6 to write
// then6 read back data, therefore6 need to store6 original write data for use in assertion6 check
reg [31:0] pwdata_d6;  // 1 cycle delayed6 
always @ (posedge pclk6) pwdata_d6 <= pwdata6;

// psl6 assert_rw_div_clk6 : 
// assert always {((paddr6 == `AL_DIV_CLK6) & write_enable6) ; ((paddr6 == `AL_DIV_CLK6) & read_enable6)} |=>
// {prev(pwdata_d6[7:0]) == prdata6[7:0]};



// COVER6 SANITY6 CHECKS6
// sanity6 read
// psl6 output_for_div_clk6 : cover {((paddr6 == `AL_DIV_CLK6) & read_enable6); prdata6[7:0] == 8'h55};


`endif


endmodule 


