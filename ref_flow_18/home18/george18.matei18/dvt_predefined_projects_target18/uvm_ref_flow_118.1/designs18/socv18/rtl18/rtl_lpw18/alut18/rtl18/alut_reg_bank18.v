//File18 name   : alut_reg_bank18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

// compiler18 directives18
`include "alut_defines18.v"


module alut_reg_bank18
(   
   // Inputs18
   pclk18,
   n_p_reset18,
   psel18,            
   penable18,       
   pwrite18,         
   paddr18,           
   pwdata18,          

   curr_time18,
   add_check_active18,
   age_check_active18,
   inval_in_prog18,
   reused18,
   d_port18,
   lst_inv_addr_nrm18,
   lst_inv_port_nrm18,
   lst_inv_addr_cmd18,
   lst_inv_port_cmd18,

   // Outputs18
   mac_addr18,    
   d_addr18,   
   s_addr18,    
   s_port18,    
   best_bfr_age18,
   div_clk18,     
   command, 
   prdata18,  
   clear_reused18           
);


   // APB18 Inputs18
   input                 pclk18;             // APB18 clock18
   input                 n_p_reset18;        // Reset18
   input                 psel18;             // Module18 select18 signal18
   input                 penable18;          // Enable18 signal18 
   input                 pwrite18;           // Write when HIGH18 and read when LOW18
   input [6:0]           paddr18;            // Address bus for read write
   input [31:0]          pwdata18;           // APB18 write bus

   // Inputs18 from other ALUT18 blocks
   input [31:0]          curr_time18;        // current time
   input                 add_check_active18; // used to calculate18 status[0]
   input                 age_check_active18; // used to calculate18 status[0]
   input                 inval_in_prog18;    // status[1]
   input                 reused18;           // status[2]
   input [4:0]           d_port18;           // calculated18 destination18 port for tx18
   input [47:0]          lst_inv_addr_nrm18; // last invalidated18 addr normal18 op
   input [1:0]           lst_inv_port_nrm18; // last invalidated18 port normal18 op
   input [47:0]          lst_inv_addr_cmd18; // last invalidated18 addr via cmd18
   input [1:0]           lst_inv_port_cmd18; // last invalidated18 port via cmd18
   

   output [47:0]         mac_addr18;         // address of the switch18
   output [47:0]         d_addr18;           // address of frame18 to be checked18
   output [47:0]         s_addr18;           // address of frame18 to be stored18
   output [1:0]          s_port18;           // source18 port of current frame18
   output [31:0]         best_bfr_age18;     // best18 before age18
   output [7:0]          div_clk18;          // programmed18 clock18 divider18 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata18;           // APB18 read bus
   output                clear_reused18;     // indicates18 status reg read 

   reg    [31:0]         prdata18;           //APB18 read bus   
   reg    [31:0]         frm_d_addr_l18;     
   reg    [15:0]         frm_d_addr_u18;     
   reg    [31:0]         frm_s_addr_l18;     
   reg    [15:0]         frm_s_addr_u18;     
   reg    [1:0]          s_port18;           
   reg    [31:0]         mac_addr_l18;       
   reg    [15:0]         mac_addr_u18;       
   reg    [31:0]         best_bfr_age18;     
   reg    [7:0]          div_clk18;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l18;   
   reg    [15:0]         lst_inv_addr_u18;   
   reg    [1:0]          lst_inv_port18;     


   // Internal Signal18 Declarations18
   wire                  read_enable18;      //APB18 read enable
   wire                  write_enable18;     //APB18 write enable
   wire   [47:0]         mac_addr18;        
   wire   [47:0]         d_addr18;          
   wire   [47:0]         src_addr18;        
   wire                  clear_reused18;    
   wire                  active;

   // ----------------------------
   // General18 Assignments18
   // ----------------------------

   assign read_enable18    = (psel18 & ~penable18 & ~pwrite18);
   assign write_enable18   = (psel18 & penable18 & pwrite18);

   assign mac_addr18  = {mac_addr_u18, mac_addr_l18}; 
   assign d_addr18 =    {frm_d_addr_u18, frm_d_addr_l18};
   assign s_addr18    = {frm_s_addr_u18, frm_s_addr_l18}; 

   assign clear_reused18 = read_enable18 & (paddr18 == `AL_STATUS18) & ~active;

   assign active = (add_check_active18 | age_check_active18);

// ------------------------------------------------------------------------
//   Read Mux18 Control18 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         prdata18 <= 32'h0000_0000;
      else if (read_enable18)
         begin
         case (paddr18)
            `AL_FRM_D_ADDR_L18   : prdata18 <= frm_d_addr_l18;
            `AL_FRM_D_ADDR_U18   : prdata18 <= {16'd0, frm_d_addr_u18};    
            `AL_FRM_S_ADDR_L18   : prdata18 <= frm_s_addr_l18; 
            `AL_FRM_S_ADDR_U18   : prdata18 <= {16'd0, frm_s_addr_u18}; 
            `AL_S_PORT18         : prdata18 <= {30'd0, s_port18}; 
            `AL_D_PORT18         : prdata18 <= {27'd0, d_port18}; 
            `AL_MAC_ADDR_L18     : prdata18 <= mac_addr_l18;
            `AL_MAC_ADDR_U18     : prdata18 <= {16'd0, mac_addr_u18};   
            `AL_CUR_TIME18       : prdata18 <= curr_time18; 
            `AL_BB_AGE18         : prdata18 <= best_bfr_age18;
            `AL_DIV_CLK18        : prdata18 <= {24'd0, div_clk18}; 
            `AL_STATUS18         : prdata18 <= {29'd0, reused18, inval_in_prog18,
                                           active};
            `AL_LST_INV_ADDR_L18 : prdata18 <= lst_inv_addr_l18; 
            `AL_LST_INV_ADDR_U18 : prdata18 <= {16'd0, lst_inv_addr_u18};
            `AL_LST_INV_PORT18   : prdata18 <= {30'd0, lst_inv_port18};

            default:   prdata18 <= 32'h0000_0000;
         endcase
         end
      else
         prdata18 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB18 writable18 registers
// ------------------------------------------------------------------------
// Lower18 destination18 frame18 address register  
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         frm_d_addr_l18 <= 32'h0000_0000;         
      else if (write_enable18 & (paddr18 == `AL_FRM_D_ADDR_L18))
         frm_d_addr_l18 <= pwdata18;
      else
         frm_d_addr_l18 <= frm_d_addr_l18;
      end   


// Upper18 destination18 frame18 address register  
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         frm_d_addr_u18 <= 16'h0000;         
      else if (write_enable18 & (paddr18 == `AL_FRM_D_ADDR_U18))
         frm_d_addr_u18 <= pwdata18[15:0];
      else
         frm_d_addr_u18 <= frm_d_addr_u18;
      end   


// Lower18 source18 frame18 address register  
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         frm_s_addr_l18 <= 32'h0000_0000;         
      else if (write_enable18 & (paddr18 == `AL_FRM_S_ADDR_L18))
         frm_s_addr_l18 <= pwdata18;
      else
         frm_s_addr_l18 <= frm_s_addr_l18;
      end   


// Upper18 source18 frame18 address register  
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         frm_s_addr_u18 <= 16'h0000;         
      else if (write_enable18 & (paddr18 == `AL_FRM_S_ADDR_U18))
         frm_s_addr_u18 <= pwdata18[15:0];
      else
         frm_s_addr_u18 <= frm_s_addr_u18;
      end   


// Source18 port  
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         s_port18 <= 2'b00;         
      else if (write_enable18 & (paddr18 == `AL_S_PORT18))
         s_port18 <= pwdata18[1:0];
      else
         s_port18 <= s_port18;
      end   


// Lower18 switch18 MAC18 address
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         mac_addr_l18 <= 32'h0000_0000;         
      else if (write_enable18 & (paddr18 == `AL_MAC_ADDR_L18))
         mac_addr_l18 <= pwdata18;
      else
         mac_addr_l18 <= mac_addr_l18;
      end   


// Upper18 switch18 MAC18 address 
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         mac_addr_u18 <= 16'h0000;         
      else if (write_enable18 & (paddr18 == `AL_MAC_ADDR_U18))
         mac_addr_u18 <= pwdata18[15:0];
      else
         mac_addr_u18 <= mac_addr_u18;
      end   


// Best18 before age18 
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         best_bfr_age18 <= 32'hffff_ffff;         
      else if (write_enable18 & (paddr18 == `AL_BB_AGE18))
         best_bfr_age18 <= pwdata18;
      else
         best_bfr_age18 <= best_bfr_age18;
      end   


// clock18 divider18
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         div_clk18 <= 8'h00;         
      else if (write_enable18 & (paddr18 == `AL_DIV_CLK18))
         div_clk18 <= pwdata18[7:0];
      else
         div_clk18 <= div_clk18;
      end   


// command.  Needs to be automatically18 cleared18 on following18 cycle
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable18 & (paddr18 == `AL_COMMAND18))
         command <= pwdata18[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last18 invalidated18 port and address values.  These18 can either18 be updated
//   by normal18 operation18 of address checker overwriting18 existing values or
//   by the age18 checker being commanded18 to invalidate18 out of date18 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk18 or negedge n_p_reset18)
      begin 
      if (~n_p_reset18)
      begin
         lst_inv_addr_l18 <= 32'd0;
         lst_inv_addr_u18 <= 16'd0;
         lst_inv_port18   <= 2'd0;
      end
      else if (reused18)        // reused18 flag18 from address checker
      begin
         lst_inv_addr_l18 <= lst_inv_addr_nrm18[31:0];
         lst_inv_addr_u18 <= lst_inv_addr_nrm18[47:32];
         lst_inv_port18   <= lst_inv_port_nrm18;
      end
//      else if (command == 2'b01)  // invalidate18 aged18 from age18 checker
      else if (inval_in_prog18)  // invalidate18 aged18 from age18 checker
      begin
         lst_inv_addr_l18 <= lst_inv_addr_cmd18[31:0];
         lst_inv_addr_u18 <= lst_inv_addr_cmd18[47:32];
         lst_inv_port18   <= lst_inv_port_cmd18;
      end
      else
      begin
         lst_inv_addr_l18 <= lst_inv_addr_l18;
         lst_inv_addr_u18 <= lst_inv_addr_u18;
         lst_inv_port18   <= lst_inv_port18;
      end
      end
 


`ifdef ABV_ON18

defparam i_apb_monitor18.ABUS_WIDTH18 = 7;

// APB18 ASSERTION18 VIP18
apb_monitor18 i_apb_monitor18(.pclk_i18(pclk18), 
                          .presetn_i18(n_p_reset18),
                          .penable_i18(penable18),
                          .psel_i18(psel18),
                          .paddr_i18(paddr18),
                          .pwrite_i18(pwrite18),
                          .pwdata_i18(pwdata18),
                          .prdata_i18(prdata18)); 

// psl18 default clock18 = (posedge pclk18);

// ASSUMPTIONS18
//// active (set by address checker) and invalidation18 in progress18 should never both be set
//// psl18 assume_never_active_inval_aged18 : assume never (active & inval_in_prog18);


// ASSERTION18 CHECKS18
// never read and write at the same time
// psl18 assert_never_rd_wr18 : assert never (read_enable18 & write_enable18);

// check apb18 writes, pick18 command reqister18 as arbitary18 example18
// psl18 assert_cmd_wr18 : assert always ((paddr18 == `AL_COMMAND18) & write_enable18) -> 
//                                    next(command == prev(pwdata18[1:0])) abort18(~n_p_reset18);


// check rw writes, pick18 clock18 divider18 reqister18 as arbitary18 example18.  It takes18 2 cycles18 to write
// then18 read back data, therefore18 need to store18 original write data for use in assertion18 check
reg [31:0] pwdata_d18;  // 1 cycle delayed18 
always @ (posedge pclk18) pwdata_d18 <= pwdata18;

// psl18 assert_rw_div_clk18 : 
// assert always {((paddr18 == `AL_DIV_CLK18) & write_enable18) ; ((paddr18 == `AL_DIV_CLK18) & read_enable18)} |=>
// {prev(pwdata_d18[7:0]) == prdata18[7:0]};



// COVER18 SANITY18 CHECKS18
// sanity18 read
// psl18 output_for_div_clk18 : cover {((paddr18 == `AL_DIV_CLK18) & read_enable18); prdata18[7:0] == 8'h55};


`endif


endmodule 


