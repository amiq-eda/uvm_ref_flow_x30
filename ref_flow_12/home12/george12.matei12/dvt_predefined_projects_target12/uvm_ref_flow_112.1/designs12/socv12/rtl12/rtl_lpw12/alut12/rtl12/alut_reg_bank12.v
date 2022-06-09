//File12 name   : alut_reg_bank12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

// compiler12 directives12
`include "alut_defines12.v"


module alut_reg_bank12
(   
   // Inputs12
   pclk12,
   n_p_reset12,
   psel12,            
   penable12,       
   pwrite12,         
   paddr12,           
   pwdata12,          

   curr_time12,
   add_check_active12,
   age_check_active12,
   inval_in_prog12,
   reused12,
   d_port12,
   lst_inv_addr_nrm12,
   lst_inv_port_nrm12,
   lst_inv_addr_cmd12,
   lst_inv_port_cmd12,

   // Outputs12
   mac_addr12,    
   d_addr12,   
   s_addr12,    
   s_port12,    
   best_bfr_age12,
   div_clk12,     
   command, 
   prdata12,  
   clear_reused12           
);


   // APB12 Inputs12
   input                 pclk12;             // APB12 clock12
   input                 n_p_reset12;        // Reset12
   input                 psel12;             // Module12 select12 signal12
   input                 penable12;          // Enable12 signal12 
   input                 pwrite12;           // Write when HIGH12 and read when LOW12
   input [6:0]           paddr12;            // Address bus for read write
   input [31:0]          pwdata12;           // APB12 write bus

   // Inputs12 from other ALUT12 blocks
   input [31:0]          curr_time12;        // current time
   input                 add_check_active12; // used to calculate12 status[0]
   input                 age_check_active12; // used to calculate12 status[0]
   input                 inval_in_prog12;    // status[1]
   input                 reused12;           // status[2]
   input [4:0]           d_port12;           // calculated12 destination12 port for tx12
   input [47:0]          lst_inv_addr_nrm12; // last invalidated12 addr normal12 op
   input [1:0]           lst_inv_port_nrm12; // last invalidated12 port normal12 op
   input [47:0]          lst_inv_addr_cmd12; // last invalidated12 addr via cmd12
   input [1:0]           lst_inv_port_cmd12; // last invalidated12 port via cmd12
   

   output [47:0]         mac_addr12;         // address of the switch12
   output [47:0]         d_addr12;           // address of frame12 to be checked12
   output [47:0]         s_addr12;           // address of frame12 to be stored12
   output [1:0]          s_port12;           // source12 port of current frame12
   output [31:0]         best_bfr_age12;     // best12 before age12
   output [7:0]          div_clk12;          // programmed12 clock12 divider12 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata12;           // APB12 read bus
   output                clear_reused12;     // indicates12 status reg read 

   reg    [31:0]         prdata12;           //APB12 read bus   
   reg    [31:0]         frm_d_addr_l12;     
   reg    [15:0]         frm_d_addr_u12;     
   reg    [31:0]         frm_s_addr_l12;     
   reg    [15:0]         frm_s_addr_u12;     
   reg    [1:0]          s_port12;           
   reg    [31:0]         mac_addr_l12;       
   reg    [15:0]         mac_addr_u12;       
   reg    [31:0]         best_bfr_age12;     
   reg    [7:0]          div_clk12;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l12;   
   reg    [15:0]         lst_inv_addr_u12;   
   reg    [1:0]          lst_inv_port12;     


   // Internal Signal12 Declarations12
   wire                  read_enable12;      //APB12 read enable
   wire                  write_enable12;     //APB12 write enable
   wire   [47:0]         mac_addr12;        
   wire   [47:0]         d_addr12;          
   wire   [47:0]         src_addr12;        
   wire                  clear_reused12;    
   wire                  active;

   // ----------------------------
   // General12 Assignments12
   // ----------------------------

   assign read_enable12    = (psel12 & ~penable12 & ~pwrite12);
   assign write_enable12   = (psel12 & penable12 & pwrite12);

   assign mac_addr12  = {mac_addr_u12, mac_addr_l12}; 
   assign d_addr12 =    {frm_d_addr_u12, frm_d_addr_l12};
   assign s_addr12    = {frm_s_addr_u12, frm_s_addr_l12}; 

   assign clear_reused12 = read_enable12 & (paddr12 == `AL_STATUS12) & ~active;

   assign active = (add_check_active12 | age_check_active12);

// ------------------------------------------------------------------------
//   Read Mux12 Control12 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         prdata12 <= 32'h0000_0000;
      else if (read_enable12)
         begin
         case (paddr12)
            `AL_FRM_D_ADDR_L12   : prdata12 <= frm_d_addr_l12;
            `AL_FRM_D_ADDR_U12   : prdata12 <= {16'd0, frm_d_addr_u12};    
            `AL_FRM_S_ADDR_L12   : prdata12 <= frm_s_addr_l12; 
            `AL_FRM_S_ADDR_U12   : prdata12 <= {16'd0, frm_s_addr_u12}; 
            `AL_S_PORT12         : prdata12 <= {30'd0, s_port12}; 
            `AL_D_PORT12         : prdata12 <= {27'd0, d_port12}; 
            `AL_MAC_ADDR_L12     : prdata12 <= mac_addr_l12;
            `AL_MAC_ADDR_U12     : prdata12 <= {16'd0, mac_addr_u12};   
            `AL_CUR_TIME12       : prdata12 <= curr_time12; 
            `AL_BB_AGE12         : prdata12 <= best_bfr_age12;
            `AL_DIV_CLK12        : prdata12 <= {24'd0, div_clk12}; 
            `AL_STATUS12         : prdata12 <= {29'd0, reused12, inval_in_prog12,
                                           active};
            `AL_LST_INV_ADDR_L12 : prdata12 <= lst_inv_addr_l12; 
            `AL_LST_INV_ADDR_U12 : prdata12 <= {16'd0, lst_inv_addr_u12};
            `AL_LST_INV_PORT12   : prdata12 <= {30'd0, lst_inv_port12};

            default:   prdata12 <= 32'h0000_0000;
         endcase
         end
      else
         prdata12 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB12 writable12 registers
// ------------------------------------------------------------------------
// Lower12 destination12 frame12 address register  
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         frm_d_addr_l12 <= 32'h0000_0000;         
      else if (write_enable12 & (paddr12 == `AL_FRM_D_ADDR_L12))
         frm_d_addr_l12 <= pwdata12;
      else
         frm_d_addr_l12 <= frm_d_addr_l12;
      end   


// Upper12 destination12 frame12 address register  
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         frm_d_addr_u12 <= 16'h0000;         
      else if (write_enable12 & (paddr12 == `AL_FRM_D_ADDR_U12))
         frm_d_addr_u12 <= pwdata12[15:0];
      else
         frm_d_addr_u12 <= frm_d_addr_u12;
      end   


// Lower12 source12 frame12 address register  
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         frm_s_addr_l12 <= 32'h0000_0000;         
      else if (write_enable12 & (paddr12 == `AL_FRM_S_ADDR_L12))
         frm_s_addr_l12 <= pwdata12;
      else
         frm_s_addr_l12 <= frm_s_addr_l12;
      end   


// Upper12 source12 frame12 address register  
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         frm_s_addr_u12 <= 16'h0000;         
      else if (write_enable12 & (paddr12 == `AL_FRM_S_ADDR_U12))
         frm_s_addr_u12 <= pwdata12[15:0];
      else
         frm_s_addr_u12 <= frm_s_addr_u12;
      end   


// Source12 port  
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         s_port12 <= 2'b00;         
      else if (write_enable12 & (paddr12 == `AL_S_PORT12))
         s_port12 <= pwdata12[1:0];
      else
         s_port12 <= s_port12;
      end   


// Lower12 switch12 MAC12 address
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         mac_addr_l12 <= 32'h0000_0000;         
      else if (write_enable12 & (paddr12 == `AL_MAC_ADDR_L12))
         mac_addr_l12 <= pwdata12;
      else
         mac_addr_l12 <= mac_addr_l12;
      end   


// Upper12 switch12 MAC12 address 
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         mac_addr_u12 <= 16'h0000;         
      else if (write_enable12 & (paddr12 == `AL_MAC_ADDR_U12))
         mac_addr_u12 <= pwdata12[15:0];
      else
         mac_addr_u12 <= mac_addr_u12;
      end   


// Best12 before age12 
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         best_bfr_age12 <= 32'hffff_ffff;         
      else if (write_enable12 & (paddr12 == `AL_BB_AGE12))
         best_bfr_age12 <= pwdata12;
      else
         best_bfr_age12 <= best_bfr_age12;
      end   


// clock12 divider12
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         div_clk12 <= 8'h00;         
      else if (write_enable12 & (paddr12 == `AL_DIV_CLK12))
         div_clk12 <= pwdata12[7:0];
      else
         div_clk12 <= div_clk12;
      end   


// command.  Needs to be automatically12 cleared12 on following12 cycle
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable12 & (paddr12 == `AL_COMMAND12))
         command <= pwdata12[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last12 invalidated12 port and address values.  These12 can either12 be updated
//   by normal12 operation12 of address checker overwriting12 existing values or
//   by the age12 checker being commanded12 to invalidate12 out of date12 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk12 or negedge n_p_reset12)
      begin 
      if (~n_p_reset12)
      begin
         lst_inv_addr_l12 <= 32'd0;
         lst_inv_addr_u12 <= 16'd0;
         lst_inv_port12   <= 2'd0;
      end
      else if (reused12)        // reused12 flag12 from address checker
      begin
         lst_inv_addr_l12 <= lst_inv_addr_nrm12[31:0];
         lst_inv_addr_u12 <= lst_inv_addr_nrm12[47:32];
         lst_inv_port12   <= lst_inv_port_nrm12;
      end
//      else if (command == 2'b01)  // invalidate12 aged12 from age12 checker
      else if (inval_in_prog12)  // invalidate12 aged12 from age12 checker
      begin
         lst_inv_addr_l12 <= lst_inv_addr_cmd12[31:0];
         lst_inv_addr_u12 <= lst_inv_addr_cmd12[47:32];
         lst_inv_port12   <= lst_inv_port_cmd12;
      end
      else
      begin
         lst_inv_addr_l12 <= lst_inv_addr_l12;
         lst_inv_addr_u12 <= lst_inv_addr_u12;
         lst_inv_port12   <= lst_inv_port12;
      end
      end
 


`ifdef ABV_ON12

defparam i_apb_monitor12.ABUS_WIDTH12 = 7;

// APB12 ASSERTION12 VIP12
apb_monitor12 i_apb_monitor12(.pclk_i12(pclk12), 
                          .presetn_i12(n_p_reset12),
                          .penable_i12(penable12),
                          .psel_i12(psel12),
                          .paddr_i12(paddr12),
                          .pwrite_i12(pwrite12),
                          .pwdata_i12(pwdata12),
                          .prdata_i12(prdata12)); 

// psl12 default clock12 = (posedge pclk12);

// ASSUMPTIONS12
//// active (set by address checker) and invalidation12 in progress12 should never both be set
//// psl12 assume_never_active_inval_aged12 : assume never (active & inval_in_prog12);


// ASSERTION12 CHECKS12
// never read and write at the same time
// psl12 assert_never_rd_wr12 : assert never (read_enable12 & write_enable12);

// check apb12 writes, pick12 command reqister12 as arbitary12 example12
// psl12 assert_cmd_wr12 : assert always ((paddr12 == `AL_COMMAND12) & write_enable12) -> 
//                                    next(command == prev(pwdata12[1:0])) abort12(~n_p_reset12);


// check rw writes, pick12 clock12 divider12 reqister12 as arbitary12 example12.  It takes12 2 cycles12 to write
// then12 read back data, therefore12 need to store12 original write data for use in assertion12 check
reg [31:0] pwdata_d12;  // 1 cycle delayed12 
always @ (posedge pclk12) pwdata_d12 <= pwdata12;

// psl12 assert_rw_div_clk12 : 
// assert always {((paddr12 == `AL_DIV_CLK12) & write_enable12) ; ((paddr12 == `AL_DIV_CLK12) & read_enable12)} |=>
// {prev(pwdata_d12[7:0]) == prdata12[7:0]};



// COVER12 SANITY12 CHECKS12
// sanity12 read
// psl12 output_for_div_clk12 : cover {((paddr12 == `AL_DIV_CLK12) & read_enable12); prdata12[7:0] == 8'h55};


`endif


endmodule 


