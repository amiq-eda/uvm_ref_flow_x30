//File11 name   : alut_reg_bank11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

// compiler11 directives11
`include "alut_defines11.v"


module alut_reg_bank11
(   
   // Inputs11
   pclk11,
   n_p_reset11,
   psel11,            
   penable11,       
   pwrite11,         
   paddr11,           
   pwdata11,          

   curr_time11,
   add_check_active11,
   age_check_active11,
   inval_in_prog11,
   reused11,
   d_port11,
   lst_inv_addr_nrm11,
   lst_inv_port_nrm11,
   lst_inv_addr_cmd11,
   lst_inv_port_cmd11,

   // Outputs11
   mac_addr11,    
   d_addr11,   
   s_addr11,    
   s_port11,    
   best_bfr_age11,
   div_clk11,     
   command, 
   prdata11,  
   clear_reused11           
);


   // APB11 Inputs11
   input                 pclk11;             // APB11 clock11
   input                 n_p_reset11;        // Reset11
   input                 psel11;             // Module11 select11 signal11
   input                 penable11;          // Enable11 signal11 
   input                 pwrite11;           // Write when HIGH11 and read when LOW11
   input [6:0]           paddr11;            // Address bus for read write
   input [31:0]          pwdata11;           // APB11 write bus

   // Inputs11 from other ALUT11 blocks
   input [31:0]          curr_time11;        // current time
   input                 add_check_active11; // used to calculate11 status[0]
   input                 age_check_active11; // used to calculate11 status[0]
   input                 inval_in_prog11;    // status[1]
   input                 reused11;           // status[2]
   input [4:0]           d_port11;           // calculated11 destination11 port for tx11
   input [47:0]          lst_inv_addr_nrm11; // last invalidated11 addr normal11 op
   input [1:0]           lst_inv_port_nrm11; // last invalidated11 port normal11 op
   input [47:0]          lst_inv_addr_cmd11; // last invalidated11 addr via cmd11
   input [1:0]           lst_inv_port_cmd11; // last invalidated11 port via cmd11
   

   output [47:0]         mac_addr11;         // address of the switch11
   output [47:0]         d_addr11;           // address of frame11 to be checked11
   output [47:0]         s_addr11;           // address of frame11 to be stored11
   output [1:0]          s_port11;           // source11 port of current frame11
   output [31:0]         best_bfr_age11;     // best11 before age11
   output [7:0]          div_clk11;          // programmed11 clock11 divider11 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata11;           // APB11 read bus
   output                clear_reused11;     // indicates11 status reg read 

   reg    [31:0]         prdata11;           //APB11 read bus   
   reg    [31:0]         frm_d_addr_l11;     
   reg    [15:0]         frm_d_addr_u11;     
   reg    [31:0]         frm_s_addr_l11;     
   reg    [15:0]         frm_s_addr_u11;     
   reg    [1:0]          s_port11;           
   reg    [31:0]         mac_addr_l11;       
   reg    [15:0]         mac_addr_u11;       
   reg    [31:0]         best_bfr_age11;     
   reg    [7:0]          div_clk11;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l11;   
   reg    [15:0]         lst_inv_addr_u11;   
   reg    [1:0]          lst_inv_port11;     


   // Internal Signal11 Declarations11
   wire                  read_enable11;      //APB11 read enable
   wire                  write_enable11;     //APB11 write enable
   wire   [47:0]         mac_addr11;        
   wire   [47:0]         d_addr11;          
   wire   [47:0]         src_addr11;        
   wire                  clear_reused11;    
   wire                  active;

   // ----------------------------
   // General11 Assignments11
   // ----------------------------

   assign read_enable11    = (psel11 & ~penable11 & ~pwrite11);
   assign write_enable11   = (psel11 & penable11 & pwrite11);

   assign mac_addr11  = {mac_addr_u11, mac_addr_l11}; 
   assign d_addr11 =    {frm_d_addr_u11, frm_d_addr_l11};
   assign s_addr11    = {frm_s_addr_u11, frm_s_addr_l11}; 

   assign clear_reused11 = read_enable11 & (paddr11 == `AL_STATUS11) & ~active;

   assign active = (add_check_active11 | age_check_active11);

// ------------------------------------------------------------------------
//   Read Mux11 Control11 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         prdata11 <= 32'h0000_0000;
      else if (read_enable11)
         begin
         case (paddr11)
            `AL_FRM_D_ADDR_L11   : prdata11 <= frm_d_addr_l11;
            `AL_FRM_D_ADDR_U11   : prdata11 <= {16'd0, frm_d_addr_u11};    
            `AL_FRM_S_ADDR_L11   : prdata11 <= frm_s_addr_l11; 
            `AL_FRM_S_ADDR_U11   : prdata11 <= {16'd0, frm_s_addr_u11}; 
            `AL_S_PORT11         : prdata11 <= {30'd0, s_port11}; 
            `AL_D_PORT11         : prdata11 <= {27'd0, d_port11}; 
            `AL_MAC_ADDR_L11     : prdata11 <= mac_addr_l11;
            `AL_MAC_ADDR_U11     : prdata11 <= {16'd0, mac_addr_u11};   
            `AL_CUR_TIME11       : prdata11 <= curr_time11; 
            `AL_BB_AGE11         : prdata11 <= best_bfr_age11;
            `AL_DIV_CLK11        : prdata11 <= {24'd0, div_clk11}; 
            `AL_STATUS11         : prdata11 <= {29'd0, reused11, inval_in_prog11,
                                           active};
            `AL_LST_INV_ADDR_L11 : prdata11 <= lst_inv_addr_l11; 
            `AL_LST_INV_ADDR_U11 : prdata11 <= {16'd0, lst_inv_addr_u11};
            `AL_LST_INV_PORT11   : prdata11 <= {30'd0, lst_inv_port11};

            default:   prdata11 <= 32'h0000_0000;
         endcase
         end
      else
         prdata11 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB11 writable11 registers
// ------------------------------------------------------------------------
// Lower11 destination11 frame11 address register  
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         frm_d_addr_l11 <= 32'h0000_0000;         
      else if (write_enable11 & (paddr11 == `AL_FRM_D_ADDR_L11))
         frm_d_addr_l11 <= pwdata11;
      else
         frm_d_addr_l11 <= frm_d_addr_l11;
      end   


// Upper11 destination11 frame11 address register  
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         frm_d_addr_u11 <= 16'h0000;         
      else if (write_enable11 & (paddr11 == `AL_FRM_D_ADDR_U11))
         frm_d_addr_u11 <= pwdata11[15:0];
      else
         frm_d_addr_u11 <= frm_d_addr_u11;
      end   


// Lower11 source11 frame11 address register  
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         frm_s_addr_l11 <= 32'h0000_0000;         
      else if (write_enable11 & (paddr11 == `AL_FRM_S_ADDR_L11))
         frm_s_addr_l11 <= pwdata11;
      else
         frm_s_addr_l11 <= frm_s_addr_l11;
      end   


// Upper11 source11 frame11 address register  
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         frm_s_addr_u11 <= 16'h0000;         
      else if (write_enable11 & (paddr11 == `AL_FRM_S_ADDR_U11))
         frm_s_addr_u11 <= pwdata11[15:0];
      else
         frm_s_addr_u11 <= frm_s_addr_u11;
      end   


// Source11 port  
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         s_port11 <= 2'b00;         
      else if (write_enable11 & (paddr11 == `AL_S_PORT11))
         s_port11 <= pwdata11[1:0];
      else
         s_port11 <= s_port11;
      end   


// Lower11 switch11 MAC11 address
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         mac_addr_l11 <= 32'h0000_0000;         
      else if (write_enable11 & (paddr11 == `AL_MAC_ADDR_L11))
         mac_addr_l11 <= pwdata11;
      else
         mac_addr_l11 <= mac_addr_l11;
      end   


// Upper11 switch11 MAC11 address 
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         mac_addr_u11 <= 16'h0000;         
      else if (write_enable11 & (paddr11 == `AL_MAC_ADDR_U11))
         mac_addr_u11 <= pwdata11[15:0];
      else
         mac_addr_u11 <= mac_addr_u11;
      end   


// Best11 before age11 
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         best_bfr_age11 <= 32'hffff_ffff;         
      else if (write_enable11 & (paddr11 == `AL_BB_AGE11))
         best_bfr_age11 <= pwdata11;
      else
         best_bfr_age11 <= best_bfr_age11;
      end   


// clock11 divider11
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         div_clk11 <= 8'h00;         
      else if (write_enable11 & (paddr11 == `AL_DIV_CLK11))
         div_clk11 <= pwdata11[7:0];
      else
         div_clk11 <= div_clk11;
      end   


// command.  Needs to be automatically11 cleared11 on following11 cycle
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable11 & (paddr11 == `AL_COMMAND11))
         command <= pwdata11[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last11 invalidated11 port and address values.  These11 can either11 be updated
//   by normal11 operation11 of address checker overwriting11 existing values or
//   by the age11 checker being commanded11 to invalidate11 out of date11 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk11 or negedge n_p_reset11)
      begin 
      if (~n_p_reset11)
      begin
         lst_inv_addr_l11 <= 32'd0;
         lst_inv_addr_u11 <= 16'd0;
         lst_inv_port11   <= 2'd0;
      end
      else if (reused11)        // reused11 flag11 from address checker
      begin
         lst_inv_addr_l11 <= lst_inv_addr_nrm11[31:0];
         lst_inv_addr_u11 <= lst_inv_addr_nrm11[47:32];
         lst_inv_port11   <= lst_inv_port_nrm11;
      end
//      else if (command == 2'b01)  // invalidate11 aged11 from age11 checker
      else if (inval_in_prog11)  // invalidate11 aged11 from age11 checker
      begin
         lst_inv_addr_l11 <= lst_inv_addr_cmd11[31:0];
         lst_inv_addr_u11 <= lst_inv_addr_cmd11[47:32];
         lst_inv_port11   <= lst_inv_port_cmd11;
      end
      else
      begin
         lst_inv_addr_l11 <= lst_inv_addr_l11;
         lst_inv_addr_u11 <= lst_inv_addr_u11;
         lst_inv_port11   <= lst_inv_port11;
      end
      end
 


`ifdef ABV_ON11

defparam i_apb_monitor11.ABUS_WIDTH11 = 7;

// APB11 ASSERTION11 VIP11
apb_monitor11 i_apb_monitor11(.pclk_i11(pclk11), 
                          .presetn_i11(n_p_reset11),
                          .penable_i11(penable11),
                          .psel_i11(psel11),
                          .paddr_i11(paddr11),
                          .pwrite_i11(pwrite11),
                          .pwdata_i11(pwdata11),
                          .prdata_i11(prdata11)); 

// psl11 default clock11 = (posedge pclk11);

// ASSUMPTIONS11
//// active (set by address checker) and invalidation11 in progress11 should never both be set
//// psl11 assume_never_active_inval_aged11 : assume never (active & inval_in_prog11);


// ASSERTION11 CHECKS11
// never read and write at the same time
// psl11 assert_never_rd_wr11 : assert never (read_enable11 & write_enable11);

// check apb11 writes, pick11 command reqister11 as arbitary11 example11
// psl11 assert_cmd_wr11 : assert always ((paddr11 == `AL_COMMAND11) & write_enable11) -> 
//                                    next(command == prev(pwdata11[1:0])) abort11(~n_p_reset11);


// check rw writes, pick11 clock11 divider11 reqister11 as arbitary11 example11.  It takes11 2 cycles11 to write
// then11 read back data, therefore11 need to store11 original write data for use in assertion11 check
reg [31:0] pwdata_d11;  // 1 cycle delayed11 
always @ (posedge pclk11) pwdata_d11 <= pwdata11;

// psl11 assert_rw_div_clk11 : 
// assert always {((paddr11 == `AL_DIV_CLK11) & write_enable11) ; ((paddr11 == `AL_DIV_CLK11) & read_enable11)} |=>
// {prev(pwdata_d11[7:0]) == prdata11[7:0]};



// COVER11 SANITY11 CHECKS11
// sanity11 read
// psl11 output_for_div_clk11 : cover {((paddr11 == `AL_DIV_CLK11) & read_enable11); prdata11[7:0] == 8'h55};


`endif


endmodule 


