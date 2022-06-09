//File22 name   : alut_reg_bank22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

// compiler22 directives22
`include "alut_defines22.v"


module alut_reg_bank22
(   
   // Inputs22
   pclk22,
   n_p_reset22,
   psel22,            
   penable22,       
   pwrite22,         
   paddr22,           
   pwdata22,          

   curr_time22,
   add_check_active22,
   age_check_active22,
   inval_in_prog22,
   reused22,
   d_port22,
   lst_inv_addr_nrm22,
   lst_inv_port_nrm22,
   lst_inv_addr_cmd22,
   lst_inv_port_cmd22,

   // Outputs22
   mac_addr22,    
   d_addr22,   
   s_addr22,    
   s_port22,    
   best_bfr_age22,
   div_clk22,     
   command, 
   prdata22,  
   clear_reused22           
);


   // APB22 Inputs22
   input                 pclk22;             // APB22 clock22
   input                 n_p_reset22;        // Reset22
   input                 psel22;             // Module22 select22 signal22
   input                 penable22;          // Enable22 signal22 
   input                 pwrite22;           // Write when HIGH22 and read when LOW22
   input [6:0]           paddr22;            // Address bus for read write
   input [31:0]          pwdata22;           // APB22 write bus

   // Inputs22 from other ALUT22 blocks
   input [31:0]          curr_time22;        // current time
   input                 add_check_active22; // used to calculate22 status[0]
   input                 age_check_active22; // used to calculate22 status[0]
   input                 inval_in_prog22;    // status[1]
   input                 reused22;           // status[2]
   input [4:0]           d_port22;           // calculated22 destination22 port for tx22
   input [47:0]          lst_inv_addr_nrm22; // last invalidated22 addr normal22 op
   input [1:0]           lst_inv_port_nrm22; // last invalidated22 port normal22 op
   input [47:0]          lst_inv_addr_cmd22; // last invalidated22 addr via cmd22
   input [1:0]           lst_inv_port_cmd22; // last invalidated22 port via cmd22
   

   output [47:0]         mac_addr22;         // address of the switch22
   output [47:0]         d_addr22;           // address of frame22 to be checked22
   output [47:0]         s_addr22;           // address of frame22 to be stored22
   output [1:0]          s_port22;           // source22 port of current frame22
   output [31:0]         best_bfr_age22;     // best22 before age22
   output [7:0]          div_clk22;          // programmed22 clock22 divider22 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata22;           // APB22 read bus
   output                clear_reused22;     // indicates22 status reg read 

   reg    [31:0]         prdata22;           //APB22 read bus   
   reg    [31:0]         frm_d_addr_l22;     
   reg    [15:0]         frm_d_addr_u22;     
   reg    [31:0]         frm_s_addr_l22;     
   reg    [15:0]         frm_s_addr_u22;     
   reg    [1:0]          s_port22;           
   reg    [31:0]         mac_addr_l22;       
   reg    [15:0]         mac_addr_u22;       
   reg    [31:0]         best_bfr_age22;     
   reg    [7:0]          div_clk22;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l22;   
   reg    [15:0]         lst_inv_addr_u22;   
   reg    [1:0]          lst_inv_port22;     


   // Internal Signal22 Declarations22
   wire                  read_enable22;      //APB22 read enable
   wire                  write_enable22;     //APB22 write enable
   wire   [47:0]         mac_addr22;        
   wire   [47:0]         d_addr22;          
   wire   [47:0]         src_addr22;        
   wire                  clear_reused22;    
   wire                  active;

   // ----------------------------
   // General22 Assignments22
   // ----------------------------

   assign read_enable22    = (psel22 & ~penable22 & ~pwrite22);
   assign write_enable22   = (psel22 & penable22 & pwrite22);

   assign mac_addr22  = {mac_addr_u22, mac_addr_l22}; 
   assign d_addr22 =    {frm_d_addr_u22, frm_d_addr_l22};
   assign s_addr22    = {frm_s_addr_u22, frm_s_addr_l22}; 

   assign clear_reused22 = read_enable22 & (paddr22 == `AL_STATUS22) & ~active;

   assign active = (add_check_active22 | age_check_active22);

// ------------------------------------------------------------------------
//   Read Mux22 Control22 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         prdata22 <= 32'h0000_0000;
      else if (read_enable22)
         begin
         case (paddr22)
            `AL_FRM_D_ADDR_L22   : prdata22 <= frm_d_addr_l22;
            `AL_FRM_D_ADDR_U22   : prdata22 <= {16'd0, frm_d_addr_u22};    
            `AL_FRM_S_ADDR_L22   : prdata22 <= frm_s_addr_l22; 
            `AL_FRM_S_ADDR_U22   : prdata22 <= {16'd0, frm_s_addr_u22}; 
            `AL_S_PORT22         : prdata22 <= {30'd0, s_port22}; 
            `AL_D_PORT22         : prdata22 <= {27'd0, d_port22}; 
            `AL_MAC_ADDR_L22     : prdata22 <= mac_addr_l22;
            `AL_MAC_ADDR_U22     : prdata22 <= {16'd0, mac_addr_u22};   
            `AL_CUR_TIME22       : prdata22 <= curr_time22; 
            `AL_BB_AGE22         : prdata22 <= best_bfr_age22;
            `AL_DIV_CLK22        : prdata22 <= {24'd0, div_clk22}; 
            `AL_STATUS22         : prdata22 <= {29'd0, reused22, inval_in_prog22,
                                           active};
            `AL_LST_INV_ADDR_L22 : prdata22 <= lst_inv_addr_l22; 
            `AL_LST_INV_ADDR_U22 : prdata22 <= {16'd0, lst_inv_addr_u22};
            `AL_LST_INV_PORT22   : prdata22 <= {30'd0, lst_inv_port22};

            default:   prdata22 <= 32'h0000_0000;
         endcase
         end
      else
         prdata22 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB22 writable22 registers
// ------------------------------------------------------------------------
// Lower22 destination22 frame22 address register  
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         frm_d_addr_l22 <= 32'h0000_0000;         
      else if (write_enable22 & (paddr22 == `AL_FRM_D_ADDR_L22))
         frm_d_addr_l22 <= pwdata22;
      else
         frm_d_addr_l22 <= frm_d_addr_l22;
      end   


// Upper22 destination22 frame22 address register  
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         frm_d_addr_u22 <= 16'h0000;         
      else if (write_enable22 & (paddr22 == `AL_FRM_D_ADDR_U22))
         frm_d_addr_u22 <= pwdata22[15:0];
      else
         frm_d_addr_u22 <= frm_d_addr_u22;
      end   


// Lower22 source22 frame22 address register  
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         frm_s_addr_l22 <= 32'h0000_0000;         
      else if (write_enable22 & (paddr22 == `AL_FRM_S_ADDR_L22))
         frm_s_addr_l22 <= pwdata22;
      else
         frm_s_addr_l22 <= frm_s_addr_l22;
      end   


// Upper22 source22 frame22 address register  
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         frm_s_addr_u22 <= 16'h0000;         
      else if (write_enable22 & (paddr22 == `AL_FRM_S_ADDR_U22))
         frm_s_addr_u22 <= pwdata22[15:0];
      else
         frm_s_addr_u22 <= frm_s_addr_u22;
      end   


// Source22 port  
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         s_port22 <= 2'b00;         
      else if (write_enable22 & (paddr22 == `AL_S_PORT22))
         s_port22 <= pwdata22[1:0];
      else
         s_port22 <= s_port22;
      end   


// Lower22 switch22 MAC22 address
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         mac_addr_l22 <= 32'h0000_0000;         
      else if (write_enable22 & (paddr22 == `AL_MAC_ADDR_L22))
         mac_addr_l22 <= pwdata22;
      else
         mac_addr_l22 <= mac_addr_l22;
      end   


// Upper22 switch22 MAC22 address 
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         mac_addr_u22 <= 16'h0000;         
      else if (write_enable22 & (paddr22 == `AL_MAC_ADDR_U22))
         mac_addr_u22 <= pwdata22[15:0];
      else
         mac_addr_u22 <= mac_addr_u22;
      end   


// Best22 before age22 
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         best_bfr_age22 <= 32'hffff_ffff;         
      else if (write_enable22 & (paddr22 == `AL_BB_AGE22))
         best_bfr_age22 <= pwdata22;
      else
         best_bfr_age22 <= best_bfr_age22;
      end   


// clock22 divider22
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         div_clk22 <= 8'h00;         
      else if (write_enable22 & (paddr22 == `AL_DIV_CLK22))
         div_clk22 <= pwdata22[7:0];
      else
         div_clk22 <= div_clk22;
      end   


// command.  Needs to be automatically22 cleared22 on following22 cycle
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable22 & (paddr22 == `AL_COMMAND22))
         command <= pwdata22[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last22 invalidated22 port and address values.  These22 can either22 be updated
//   by normal22 operation22 of address checker overwriting22 existing values or
//   by the age22 checker being commanded22 to invalidate22 out of date22 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk22 or negedge n_p_reset22)
      begin 
      if (~n_p_reset22)
      begin
         lst_inv_addr_l22 <= 32'd0;
         lst_inv_addr_u22 <= 16'd0;
         lst_inv_port22   <= 2'd0;
      end
      else if (reused22)        // reused22 flag22 from address checker
      begin
         lst_inv_addr_l22 <= lst_inv_addr_nrm22[31:0];
         lst_inv_addr_u22 <= lst_inv_addr_nrm22[47:32];
         lst_inv_port22   <= lst_inv_port_nrm22;
      end
//      else if (command == 2'b01)  // invalidate22 aged22 from age22 checker
      else if (inval_in_prog22)  // invalidate22 aged22 from age22 checker
      begin
         lst_inv_addr_l22 <= lst_inv_addr_cmd22[31:0];
         lst_inv_addr_u22 <= lst_inv_addr_cmd22[47:32];
         lst_inv_port22   <= lst_inv_port_cmd22;
      end
      else
      begin
         lst_inv_addr_l22 <= lst_inv_addr_l22;
         lst_inv_addr_u22 <= lst_inv_addr_u22;
         lst_inv_port22   <= lst_inv_port22;
      end
      end
 


`ifdef ABV_ON22

defparam i_apb_monitor22.ABUS_WIDTH22 = 7;

// APB22 ASSERTION22 VIP22
apb_monitor22 i_apb_monitor22(.pclk_i22(pclk22), 
                          .presetn_i22(n_p_reset22),
                          .penable_i22(penable22),
                          .psel_i22(psel22),
                          .paddr_i22(paddr22),
                          .pwrite_i22(pwrite22),
                          .pwdata_i22(pwdata22),
                          .prdata_i22(prdata22)); 

// psl22 default clock22 = (posedge pclk22);

// ASSUMPTIONS22
//// active (set by address checker) and invalidation22 in progress22 should never both be set
//// psl22 assume_never_active_inval_aged22 : assume never (active & inval_in_prog22);


// ASSERTION22 CHECKS22
// never read and write at the same time
// psl22 assert_never_rd_wr22 : assert never (read_enable22 & write_enable22);

// check apb22 writes, pick22 command reqister22 as arbitary22 example22
// psl22 assert_cmd_wr22 : assert always ((paddr22 == `AL_COMMAND22) & write_enable22) -> 
//                                    next(command == prev(pwdata22[1:0])) abort22(~n_p_reset22);


// check rw writes, pick22 clock22 divider22 reqister22 as arbitary22 example22.  It takes22 2 cycles22 to write
// then22 read back data, therefore22 need to store22 original write data for use in assertion22 check
reg [31:0] pwdata_d22;  // 1 cycle delayed22 
always @ (posedge pclk22) pwdata_d22 <= pwdata22;

// psl22 assert_rw_div_clk22 : 
// assert always {((paddr22 == `AL_DIV_CLK22) & write_enable22) ; ((paddr22 == `AL_DIV_CLK22) & read_enable22)} |=>
// {prev(pwdata_d22[7:0]) == prdata22[7:0]};



// COVER22 SANITY22 CHECKS22
// sanity22 read
// psl22 output_for_div_clk22 : cover {((paddr22 == `AL_DIV_CLK22) & read_enable22); prdata22[7:0] == 8'h55};


`endif


endmodule 


