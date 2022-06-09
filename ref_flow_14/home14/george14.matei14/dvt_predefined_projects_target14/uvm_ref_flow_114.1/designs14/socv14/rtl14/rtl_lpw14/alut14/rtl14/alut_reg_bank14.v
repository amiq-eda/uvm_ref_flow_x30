//File14 name   : alut_reg_bank14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

// compiler14 directives14
`include "alut_defines14.v"


module alut_reg_bank14
(   
   // Inputs14
   pclk14,
   n_p_reset14,
   psel14,            
   penable14,       
   pwrite14,         
   paddr14,           
   pwdata14,          

   curr_time14,
   add_check_active14,
   age_check_active14,
   inval_in_prog14,
   reused14,
   d_port14,
   lst_inv_addr_nrm14,
   lst_inv_port_nrm14,
   lst_inv_addr_cmd14,
   lst_inv_port_cmd14,

   // Outputs14
   mac_addr14,    
   d_addr14,   
   s_addr14,    
   s_port14,    
   best_bfr_age14,
   div_clk14,     
   command, 
   prdata14,  
   clear_reused14           
);


   // APB14 Inputs14
   input                 pclk14;             // APB14 clock14
   input                 n_p_reset14;        // Reset14
   input                 psel14;             // Module14 select14 signal14
   input                 penable14;          // Enable14 signal14 
   input                 pwrite14;           // Write when HIGH14 and read when LOW14
   input [6:0]           paddr14;            // Address bus for read write
   input [31:0]          pwdata14;           // APB14 write bus

   // Inputs14 from other ALUT14 blocks
   input [31:0]          curr_time14;        // current time
   input                 add_check_active14; // used to calculate14 status[0]
   input                 age_check_active14; // used to calculate14 status[0]
   input                 inval_in_prog14;    // status[1]
   input                 reused14;           // status[2]
   input [4:0]           d_port14;           // calculated14 destination14 port for tx14
   input [47:0]          lst_inv_addr_nrm14; // last invalidated14 addr normal14 op
   input [1:0]           lst_inv_port_nrm14; // last invalidated14 port normal14 op
   input [47:0]          lst_inv_addr_cmd14; // last invalidated14 addr via cmd14
   input [1:0]           lst_inv_port_cmd14; // last invalidated14 port via cmd14
   

   output [47:0]         mac_addr14;         // address of the switch14
   output [47:0]         d_addr14;           // address of frame14 to be checked14
   output [47:0]         s_addr14;           // address of frame14 to be stored14
   output [1:0]          s_port14;           // source14 port of current frame14
   output [31:0]         best_bfr_age14;     // best14 before age14
   output [7:0]          div_clk14;          // programmed14 clock14 divider14 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata14;           // APB14 read bus
   output                clear_reused14;     // indicates14 status reg read 

   reg    [31:0]         prdata14;           //APB14 read bus   
   reg    [31:0]         frm_d_addr_l14;     
   reg    [15:0]         frm_d_addr_u14;     
   reg    [31:0]         frm_s_addr_l14;     
   reg    [15:0]         frm_s_addr_u14;     
   reg    [1:0]          s_port14;           
   reg    [31:0]         mac_addr_l14;       
   reg    [15:0]         mac_addr_u14;       
   reg    [31:0]         best_bfr_age14;     
   reg    [7:0]          div_clk14;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l14;   
   reg    [15:0]         lst_inv_addr_u14;   
   reg    [1:0]          lst_inv_port14;     


   // Internal Signal14 Declarations14
   wire                  read_enable14;      //APB14 read enable
   wire                  write_enable14;     //APB14 write enable
   wire   [47:0]         mac_addr14;        
   wire   [47:0]         d_addr14;          
   wire   [47:0]         src_addr14;        
   wire                  clear_reused14;    
   wire                  active;

   // ----------------------------
   // General14 Assignments14
   // ----------------------------

   assign read_enable14    = (psel14 & ~penable14 & ~pwrite14);
   assign write_enable14   = (psel14 & penable14 & pwrite14);

   assign mac_addr14  = {mac_addr_u14, mac_addr_l14}; 
   assign d_addr14 =    {frm_d_addr_u14, frm_d_addr_l14};
   assign s_addr14    = {frm_s_addr_u14, frm_s_addr_l14}; 

   assign clear_reused14 = read_enable14 & (paddr14 == `AL_STATUS14) & ~active;

   assign active = (add_check_active14 | age_check_active14);

// ------------------------------------------------------------------------
//   Read Mux14 Control14 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         prdata14 <= 32'h0000_0000;
      else if (read_enable14)
         begin
         case (paddr14)
            `AL_FRM_D_ADDR_L14   : prdata14 <= frm_d_addr_l14;
            `AL_FRM_D_ADDR_U14   : prdata14 <= {16'd0, frm_d_addr_u14};    
            `AL_FRM_S_ADDR_L14   : prdata14 <= frm_s_addr_l14; 
            `AL_FRM_S_ADDR_U14   : prdata14 <= {16'd0, frm_s_addr_u14}; 
            `AL_S_PORT14         : prdata14 <= {30'd0, s_port14}; 
            `AL_D_PORT14         : prdata14 <= {27'd0, d_port14}; 
            `AL_MAC_ADDR_L14     : prdata14 <= mac_addr_l14;
            `AL_MAC_ADDR_U14     : prdata14 <= {16'd0, mac_addr_u14};   
            `AL_CUR_TIME14       : prdata14 <= curr_time14; 
            `AL_BB_AGE14         : prdata14 <= best_bfr_age14;
            `AL_DIV_CLK14        : prdata14 <= {24'd0, div_clk14}; 
            `AL_STATUS14         : prdata14 <= {29'd0, reused14, inval_in_prog14,
                                           active};
            `AL_LST_INV_ADDR_L14 : prdata14 <= lst_inv_addr_l14; 
            `AL_LST_INV_ADDR_U14 : prdata14 <= {16'd0, lst_inv_addr_u14};
            `AL_LST_INV_PORT14   : prdata14 <= {30'd0, lst_inv_port14};

            default:   prdata14 <= 32'h0000_0000;
         endcase
         end
      else
         prdata14 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB14 writable14 registers
// ------------------------------------------------------------------------
// Lower14 destination14 frame14 address register  
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         frm_d_addr_l14 <= 32'h0000_0000;         
      else if (write_enable14 & (paddr14 == `AL_FRM_D_ADDR_L14))
         frm_d_addr_l14 <= pwdata14;
      else
         frm_d_addr_l14 <= frm_d_addr_l14;
      end   


// Upper14 destination14 frame14 address register  
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         frm_d_addr_u14 <= 16'h0000;         
      else if (write_enable14 & (paddr14 == `AL_FRM_D_ADDR_U14))
         frm_d_addr_u14 <= pwdata14[15:0];
      else
         frm_d_addr_u14 <= frm_d_addr_u14;
      end   


// Lower14 source14 frame14 address register  
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         frm_s_addr_l14 <= 32'h0000_0000;         
      else if (write_enable14 & (paddr14 == `AL_FRM_S_ADDR_L14))
         frm_s_addr_l14 <= pwdata14;
      else
         frm_s_addr_l14 <= frm_s_addr_l14;
      end   


// Upper14 source14 frame14 address register  
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         frm_s_addr_u14 <= 16'h0000;         
      else if (write_enable14 & (paddr14 == `AL_FRM_S_ADDR_U14))
         frm_s_addr_u14 <= pwdata14[15:0];
      else
         frm_s_addr_u14 <= frm_s_addr_u14;
      end   


// Source14 port  
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         s_port14 <= 2'b00;         
      else if (write_enable14 & (paddr14 == `AL_S_PORT14))
         s_port14 <= pwdata14[1:0];
      else
         s_port14 <= s_port14;
      end   


// Lower14 switch14 MAC14 address
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         mac_addr_l14 <= 32'h0000_0000;         
      else if (write_enable14 & (paddr14 == `AL_MAC_ADDR_L14))
         mac_addr_l14 <= pwdata14;
      else
         mac_addr_l14 <= mac_addr_l14;
      end   


// Upper14 switch14 MAC14 address 
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         mac_addr_u14 <= 16'h0000;         
      else if (write_enable14 & (paddr14 == `AL_MAC_ADDR_U14))
         mac_addr_u14 <= pwdata14[15:0];
      else
         mac_addr_u14 <= mac_addr_u14;
      end   


// Best14 before age14 
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         best_bfr_age14 <= 32'hffff_ffff;         
      else if (write_enable14 & (paddr14 == `AL_BB_AGE14))
         best_bfr_age14 <= pwdata14;
      else
         best_bfr_age14 <= best_bfr_age14;
      end   


// clock14 divider14
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         div_clk14 <= 8'h00;         
      else if (write_enable14 & (paddr14 == `AL_DIV_CLK14))
         div_clk14 <= pwdata14[7:0];
      else
         div_clk14 <= div_clk14;
      end   


// command.  Needs to be automatically14 cleared14 on following14 cycle
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable14 & (paddr14 == `AL_COMMAND14))
         command <= pwdata14[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last14 invalidated14 port and address values.  These14 can either14 be updated
//   by normal14 operation14 of address checker overwriting14 existing values or
//   by the age14 checker being commanded14 to invalidate14 out of date14 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk14 or negedge n_p_reset14)
      begin 
      if (~n_p_reset14)
      begin
         lst_inv_addr_l14 <= 32'd0;
         lst_inv_addr_u14 <= 16'd0;
         lst_inv_port14   <= 2'd0;
      end
      else if (reused14)        // reused14 flag14 from address checker
      begin
         lst_inv_addr_l14 <= lst_inv_addr_nrm14[31:0];
         lst_inv_addr_u14 <= lst_inv_addr_nrm14[47:32];
         lst_inv_port14   <= lst_inv_port_nrm14;
      end
//      else if (command == 2'b01)  // invalidate14 aged14 from age14 checker
      else if (inval_in_prog14)  // invalidate14 aged14 from age14 checker
      begin
         lst_inv_addr_l14 <= lst_inv_addr_cmd14[31:0];
         lst_inv_addr_u14 <= lst_inv_addr_cmd14[47:32];
         lst_inv_port14   <= lst_inv_port_cmd14;
      end
      else
      begin
         lst_inv_addr_l14 <= lst_inv_addr_l14;
         lst_inv_addr_u14 <= lst_inv_addr_u14;
         lst_inv_port14   <= lst_inv_port14;
      end
      end
 


`ifdef ABV_ON14

defparam i_apb_monitor14.ABUS_WIDTH14 = 7;

// APB14 ASSERTION14 VIP14
apb_monitor14 i_apb_monitor14(.pclk_i14(pclk14), 
                          .presetn_i14(n_p_reset14),
                          .penable_i14(penable14),
                          .psel_i14(psel14),
                          .paddr_i14(paddr14),
                          .pwrite_i14(pwrite14),
                          .pwdata_i14(pwdata14),
                          .prdata_i14(prdata14)); 

// psl14 default clock14 = (posedge pclk14);

// ASSUMPTIONS14
//// active (set by address checker) and invalidation14 in progress14 should never both be set
//// psl14 assume_never_active_inval_aged14 : assume never (active & inval_in_prog14);


// ASSERTION14 CHECKS14
// never read and write at the same time
// psl14 assert_never_rd_wr14 : assert never (read_enable14 & write_enable14);

// check apb14 writes, pick14 command reqister14 as arbitary14 example14
// psl14 assert_cmd_wr14 : assert always ((paddr14 == `AL_COMMAND14) & write_enable14) -> 
//                                    next(command == prev(pwdata14[1:0])) abort14(~n_p_reset14);


// check rw writes, pick14 clock14 divider14 reqister14 as arbitary14 example14.  It takes14 2 cycles14 to write
// then14 read back data, therefore14 need to store14 original write data for use in assertion14 check
reg [31:0] pwdata_d14;  // 1 cycle delayed14 
always @ (posedge pclk14) pwdata_d14 <= pwdata14;

// psl14 assert_rw_div_clk14 : 
// assert always {((paddr14 == `AL_DIV_CLK14) & write_enable14) ; ((paddr14 == `AL_DIV_CLK14) & read_enable14)} |=>
// {prev(pwdata_d14[7:0]) == prdata14[7:0]};



// COVER14 SANITY14 CHECKS14
// sanity14 read
// psl14 output_for_div_clk14 : cover {((paddr14 == `AL_DIV_CLK14) & read_enable14); prdata14[7:0] == 8'h55};


`endif


endmodule 


