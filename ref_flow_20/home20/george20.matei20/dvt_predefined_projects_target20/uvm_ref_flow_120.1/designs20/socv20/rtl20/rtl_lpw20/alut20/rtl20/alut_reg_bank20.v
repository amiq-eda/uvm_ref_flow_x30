//File20 name   : alut_reg_bank20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

// compiler20 directives20
`include "alut_defines20.v"


module alut_reg_bank20
(   
   // Inputs20
   pclk20,
   n_p_reset20,
   psel20,            
   penable20,       
   pwrite20,         
   paddr20,           
   pwdata20,          

   curr_time20,
   add_check_active20,
   age_check_active20,
   inval_in_prog20,
   reused20,
   d_port20,
   lst_inv_addr_nrm20,
   lst_inv_port_nrm20,
   lst_inv_addr_cmd20,
   lst_inv_port_cmd20,

   // Outputs20
   mac_addr20,    
   d_addr20,   
   s_addr20,    
   s_port20,    
   best_bfr_age20,
   div_clk20,     
   command, 
   prdata20,  
   clear_reused20           
);


   // APB20 Inputs20
   input                 pclk20;             // APB20 clock20
   input                 n_p_reset20;        // Reset20
   input                 psel20;             // Module20 select20 signal20
   input                 penable20;          // Enable20 signal20 
   input                 pwrite20;           // Write when HIGH20 and read when LOW20
   input [6:0]           paddr20;            // Address bus for read write
   input [31:0]          pwdata20;           // APB20 write bus

   // Inputs20 from other ALUT20 blocks
   input [31:0]          curr_time20;        // current time
   input                 add_check_active20; // used to calculate20 status[0]
   input                 age_check_active20; // used to calculate20 status[0]
   input                 inval_in_prog20;    // status[1]
   input                 reused20;           // status[2]
   input [4:0]           d_port20;           // calculated20 destination20 port for tx20
   input [47:0]          lst_inv_addr_nrm20; // last invalidated20 addr normal20 op
   input [1:0]           lst_inv_port_nrm20; // last invalidated20 port normal20 op
   input [47:0]          lst_inv_addr_cmd20; // last invalidated20 addr via cmd20
   input [1:0]           lst_inv_port_cmd20; // last invalidated20 port via cmd20
   

   output [47:0]         mac_addr20;         // address of the switch20
   output [47:0]         d_addr20;           // address of frame20 to be checked20
   output [47:0]         s_addr20;           // address of frame20 to be stored20
   output [1:0]          s_port20;           // source20 port of current frame20
   output [31:0]         best_bfr_age20;     // best20 before age20
   output [7:0]          div_clk20;          // programmed20 clock20 divider20 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata20;           // APB20 read bus
   output                clear_reused20;     // indicates20 status reg read 

   reg    [31:0]         prdata20;           //APB20 read bus   
   reg    [31:0]         frm_d_addr_l20;     
   reg    [15:0]         frm_d_addr_u20;     
   reg    [31:0]         frm_s_addr_l20;     
   reg    [15:0]         frm_s_addr_u20;     
   reg    [1:0]          s_port20;           
   reg    [31:0]         mac_addr_l20;       
   reg    [15:0]         mac_addr_u20;       
   reg    [31:0]         best_bfr_age20;     
   reg    [7:0]          div_clk20;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l20;   
   reg    [15:0]         lst_inv_addr_u20;   
   reg    [1:0]          lst_inv_port20;     


   // Internal Signal20 Declarations20
   wire                  read_enable20;      //APB20 read enable
   wire                  write_enable20;     //APB20 write enable
   wire   [47:0]         mac_addr20;        
   wire   [47:0]         d_addr20;          
   wire   [47:0]         src_addr20;        
   wire                  clear_reused20;    
   wire                  active;

   // ----------------------------
   // General20 Assignments20
   // ----------------------------

   assign read_enable20    = (psel20 & ~penable20 & ~pwrite20);
   assign write_enable20   = (psel20 & penable20 & pwrite20);

   assign mac_addr20  = {mac_addr_u20, mac_addr_l20}; 
   assign d_addr20 =    {frm_d_addr_u20, frm_d_addr_l20};
   assign s_addr20    = {frm_s_addr_u20, frm_s_addr_l20}; 

   assign clear_reused20 = read_enable20 & (paddr20 == `AL_STATUS20) & ~active;

   assign active = (add_check_active20 | age_check_active20);

// ------------------------------------------------------------------------
//   Read Mux20 Control20 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         prdata20 <= 32'h0000_0000;
      else if (read_enable20)
         begin
         case (paddr20)
            `AL_FRM_D_ADDR_L20   : prdata20 <= frm_d_addr_l20;
            `AL_FRM_D_ADDR_U20   : prdata20 <= {16'd0, frm_d_addr_u20};    
            `AL_FRM_S_ADDR_L20   : prdata20 <= frm_s_addr_l20; 
            `AL_FRM_S_ADDR_U20   : prdata20 <= {16'd0, frm_s_addr_u20}; 
            `AL_S_PORT20         : prdata20 <= {30'd0, s_port20}; 
            `AL_D_PORT20         : prdata20 <= {27'd0, d_port20}; 
            `AL_MAC_ADDR_L20     : prdata20 <= mac_addr_l20;
            `AL_MAC_ADDR_U20     : prdata20 <= {16'd0, mac_addr_u20};   
            `AL_CUR_TIME20       : prdata20 <= curr_time20; 
            `AL_BB_AGE20         : prdata20 <= best_bfr_age20;
            `AL_DIV_CLK20        : prdata20 <= {24'd0, div_clk20}; 
            `AL_STATUS20         : prdata20 <= {29'd0, reused20, inval_in_prog20,
                                           active};
            `AL_LST_INV_ADDR_L20 : prdata20 <= lst_inv_addr_l20; 
            `AL_LST_INV_ADDR_U20 : prdata20 <= {16'd0, lst_inv_addr_u20};
            `AL_LST_INV_PORT20   : prdata20 <= {30'd0, lst_inv_port20};

            default:   prdata20 <= 32'h0000_0000;
         endcase
         end
      else
         prdata20 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB20 writable20 registers
// ------------------------------------------------------------------------
// Lower20 destination20 frame20 address register  
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         frm_d_addr_l20 <= 32'h0000_0000;         
      else if (write_enable20 & (paddr20 == `AL_FRM_D_ADDR_L20))
         frm_d_addr_l20 <= pwdata20;
      else
         frm_d_addr_l20 <= frm_d_addr_l20;
      end   


// Upper20 destination20 frame20 address register  
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         frm_d_addr_u20 <= 16'h0000;         
      else if (write_enable20 & (paddr20 == `AL_FRM_D_ADDR_U20))
         frm_d_addr_u20 <= pwdata20[15:0];
      else
         frm_d_addr_u20 <= frm_d_addr_u20;
      end   


// Lower20 source20 frame20 address register  
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         frm_s_addr_l20 <= 32'h0000_0000;         
      else if (write_enable20 & (paddr20 == `AL_FRM_S_ADDR_L20))
         frm_s_addr_l20 <= pwdata20;
      else
         frm_s_addr_l20 <= frm_s_addr_l20;
      end   


// Upper20 source20 frame20 address register  
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         frm_s_addr_u20 <= 16'h0000;         
      else if (write_enable20 & (paddr20 == `AL_FRM_S_ADDR_U20))
         frm_s_addr_u20 <= pwdata20[15:0];
      else
         frm_s_addr_u20 <= frm_s_addr_u20;
      end   


// Source20 port  
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         s_port20 <= 2'b00;         
      else if (write_enable20 & (paddr20 == `AL_S_PORT20))
         s_port20 <= pwdata20[1:0];
      else
         s_port20 <= s_port20;
      end   


// Lower20 switch20 MAC20 address
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         mac_addr_l20 <= 32'h0000_0000;         
      else if (write_enable20 & (paddr20 == `AL_MAC_ADDR_L20))
         mac_addr_l20 <= pwdata20;
      else
         mac_addr_l20 <= mac_addr_l20;
      end   


// Upper20 switch20 MAC20 address 
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         mac_addr_u20 <= 16'h0000;         
      else if (write_enable20 & (paddr20 == `AL_MAC_ADDR_U20))
         mac_addr_u20 <= pwdata20[15:0];
      else
         mac_addr_u20 <= mac_addr_u20;
      end   


// Best20 before age20 
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         best_bfr_age20 <= 32'hffff_ffff;         
      else if (write_enable20 & (paddr20 == `AL_BB_AGE20))
         best_bfr_age20 <= pwdata20;
      else
         best_bfr_age20 <= best_bfr_age20;
      end   


// clock20 divider20
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         div_clk20 <= 8'h00;         
      else if (write_enable20 & (paddr20 == `AL_DIV_CLK20))
         div_clk20 <= pwdata20[7:0];
      else
         div_clk20 <= div_clk20;
      end   


// command.  Needs to be automatically20 cleared20 on following20 cycle
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable20 & (paddr20 == `AL_COMMAND20))
         command <= pwdata20[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last20 invalidated20 port and address values.  These20 can either20 be updated
//   by normal20 operation20 of address checker overwriting20 existing values or
//   by the age20 checker being commanded20 to invalidate20 out of date20 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk20 or negedge n_p_reset20)
      begin 
      if (~n_p_reset20)
      begin
         lst_inv_addr_l20 <= 32'd0;
         lst_inv_addr_u20 <= 16'd0;
         lst_inv_port20   <= 2'd0;
      end
      else if (reused20)        // reused20 flag20 from address checker
      begin
         lst_inv_addr_l20 <= lst_inv_addr_nrm20[31:0];
         lst_inv_addr_u20 <= lst_inv_addr_nrm20[47:32];
         lst_inv_port20   <= lst_inv_port_nrm20;
      end
//      else if (command == 2'b01)  // invalidate20 aged20 from age20 checker
      else if (inval_in_prog20)  // invalidate20 aged20 from age20 checker
      begin
         lst_inv_addr_l20 <= lst_inv_addr_cmd20[31:0];
         lst_inv_addr_u20 <= lst_inv_addr_cmd20[47:32];
         lst_inv_port20   <= lst_inv_port_cmd20;
      end
      else
      begin
         lst_inv_addr_l20 <= lst_inv_addr_l20;
         lst_inv_addr_u20 <= lst_inv_addr_u20;
         lst_inv_port20   <= lst_inv_port20;
      end
      end
 


`ifdef ABV_ON20

defparam i_apb_monitor20.ABUS_WIDTH20 = 7;

// APB20 ASSERTION20 VIP20
apb_monitor20 i_apb_monitor20(.pclk_i20(pclk20), 
                          .presetn_i20(n_p_reset20),
                          .penable_i20(penable20),
                          .psel_i20(psel20),
                          .paddr_i20(paddr20),
                          .pwrite_i20(pwrite20),
                          .pwdata_i20(pwdata20),
                          .prdata_i20(prdata20)); 

// psl20 default clock20 = (posedge pclk20);

// ASSUMPTIONS20
//// active (set by address checker) and invalidation20 in progress20 should never both be set
//// psl20 assume_never_active_inval_aged20 : assume never (active & inval_in_prog20);


// ASSERTION20 CHECKS20
// never read and write at the same time
// psl20 assert_never_rd_wr20 : assert never (read_enable20 & write_enable20);

// check apb20 writes, pick20 command reqister20 as arbitary20 example20
// psl20 assert_cmd_wr20 : assert always ((paddr20 == `AL_COMMAND20) & write_enable20) -> 
//                                    next(command == prev(pwdata20[1:0])) abort20(~n_p_reset20);


// check rw writes, pick20 clock20 divider20 reqister20 as arbitary20 example20.  It takes20 2 cycles20 to write
// then20 read back data, therefore20 need to store20 original write data for use in assertion20 check
reg [31:0] pwdata_d20;  // 1 cycle delayed20 
always @ (posedge pclk20) pwdata_d20 <= pwdata20;

// psl20 assert_rw_div_clk20 : 
// assert always {((paddr20 == `AL_DIV_CLK20) & write_enable20) ; ((paddr20 == `AL_DIV_CLK20) & read_enable20)} |=>
// {prev(pwdata_d20[7:0]) == prdata20[7:0]};



// COVER20 SANITY20 CHECKS20
// sanity20 read
// psl20 output_for_div_clk20 : cover {((paddr20 == `AL_DIV_CLK20) & read_enable20); prdata20[7:0] == 8'h55};


`endif


endmodule 


