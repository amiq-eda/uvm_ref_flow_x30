//File24 name   : alut_reg_bank24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

// compiler24 directives24
`include "alut_defines24.v"


module alut_reg_bank24
(   
   // Inputs24
   pclk24,
   n_p_reset24,
   psel24,            
   penable24,       
   pwrite24,         
   paddr24,           
   pwdata24,          

   curr_time24,
   add_check_active24,
   age_check_active24,
   inval_in_prog24,
   reused24,
   d_port24,
   lst_inv_addr_nrm24,
   lst_inv_port_nrm24,
   lst_inv_addr_cmd24,
   lst_inv_port_cmd24,

   // Outputs24
   mac_addr24,    
   d_addr24,   
   s_addr24,    
   s_port24,    
   best_bfr_age24,
   div_clk24,     
   command, 
   prdata24,  
   clear_reused24           
);


   // APB24 Inputs24
   input                 pclk24;             // APB24 clock24
   input                 n_p_reset24;        // Reset24
   input                 psel24;             // Module24 select24 signal24
   input                 penable24;          // Enable24 signal24 
   input                 pwrite24;           // Write when HIGH24 and read when LOW24
   input [6:0]           paddr24;            // Address bus for read write
   input [31:0]          pwdata24;           // APB24 write bus

   // Inputs24 from other ALUT24 blocks
   input [31:0]          curr_time24;        // current time
   input                 add_check_active24; // used to calculate24 status[0]
   input                 age_check_active24; // used to calculate24 status[0]
   input                 inval_in_prog24;    // status[1]
   input                 reused24;           // status[2]
   input [4:0]           d_port24;           // calculated24 destination24 port for tx24
   input [47:0]          lst_inv_addr_nrm24; // last invalidated24 addr normal24 op
   input [1:0]           lst_inv_port_nrm24; // last invalidated24 port normal24 op
   input [47:0]          lst_inv_addr_cmd24; // last invalidated24 addr via cmd24
   input [1:0]           lst_inv_port_cmd24; // last invalidated24 port via cmd24
   

   output [47:0]         mac_addr24;         // address of the switch24
   output [47:0]         d_addr24;           // address of frame24 to be checked24
   output [47:0]         s_addr24;           // address of frame24 to be stored24
   output [1:0]          s_port24;           // source24 port of current frame24
   output [31:0]         best_bfr_age24;     // best24 before age24
   output [7:0]          div_clk24;          // programmed24 clock24 divider24 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata24;           // APB24 read bus
   output                clear_reused24;     // indicates24 status reg read 

   reg    [31:0]         prdata24;           //APB24 read bus   
   reg    [31:0]         frm_d_addr_l24;     
   reg    [15:0]         frm_d_addr_u24;     
   reg    [31:0]         frm_s_addr_l24;     
   reg    [15:0]         frm_s_addr_u24;     
   reg    [1:0]          s_port24;           
   reg    [31:0]         mac_addr_l24;       
   reg    [15:0]         mac_addr_u24;       
   reg    [31:0]         best_bfr_age24;     
   reg    [7:0]          div_clk24;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l24;   
   reg    [15:0]         lst_inv_addr_u24;   
   reg    [1:0]          lst_inv_port24;     


   // Internal Signal24 Declarations24
   wire                  read_enable24;      //APB24 read enable
   wire                  write_enable24;     //APB24 write enable
   wire   [47:0]         mac_addr24;        
   wire   [47:0]         d_addr24;          
   wire   [47:0]         src_addr24;        
   wire                  clear_reused24;    
   wire                  active;

   // ----------------------------
   // General24 Assignments24
   // ----------------------------

   assign read_enable24    = (psel24 & ~penable24 & ~pwrite24);
   assign write_enable24   = (psel24 & penable24 & pwrite24);

   assign mac_addr24  = {mac_addr_u24, mac_addr_l24}; 
   assign d_addr24 =    {frm_d_addr_u24, frm_d_addr_l24};
   assign s_addr24    = {frm_s_addr_u24, frm_s_addr_l24}; 

   assign clear_reused24 = read_enable24 & (paddr24 == `AL_STATUS24) & ~active;

   assign active = (add_check_active24 | age_check_active24);

// ------------------------------------------------------------------------
//   Read Mux24 Control24 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         prdata24 <= 32'h0000_0000;
      else if (read_enable24)
         begin
         case (paddr24)
            `AL_FRM_D_ADDR_L24   : prdata24 <= frm_d_addr_l24;
            `AL_FRM_D_ADDR_U24   : prdata24 <= {16'd0, frm_d_addr_u24};    
            `AL_FRM_S_ADDR_L24   : prdata24 <= frm_s_addr_l24; 
            `AL_FRM_S_ADDR_U24   : prdata24 <= {16'd0, frm_s_addr_u24}; 
            `AL_S_PORT24         : prdata24 <= {30'd0, s_port24}; 
            `AL_D_PORT24         : prdata24 <= {27'd0, d_port24}; 
            `AL_MAC_ADDR_L24     : prdata24 <= mac_addr_l24;
            `AL_MAC_ADDR_U24     : prdata24 <= {16'd0, mac_addr_u24};   
            `AL_CUR_TIME24       : prdata24 <= curr_time24; 
            `AL_BB_AGE24         : prdata24 <= best_bfr_age24;
            `AL_DIV_CLK24        : prdata24 <= {24'd0, div_clk24}; 
            `AL_STATUS24         : prdata24 <= {29'd0, reused24, inval_in_prog24,
                                           active};
            `AL_LST_INV_ADDR_L24 : prdata24 <= lst_inv_addr_l24; 
            `AL_LST_INV_ADDR_U24 : prdata24 <= {16'd0, lst_inv_addr_u24};
            `AL_LST_INV_PORT24   : prdata24 <= {30'd0, lst_inv_port24};

            default:   prdata24 <= 32'h0000_0000;
         endcase
         end
      else
         prdata24 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB24 writable24 registers
// ------------------------------------------------------------------------
// Lower24 destination24 frame24 address register  
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         frm_d_addr_l24 <= 32'h0000_0000;         
      else if (write_enable24 & (paddr24 == `AL_FRM_D_ADDR_L24))
         frm_d_addr_l24 <= pwdata24;
      else
         frm_d_addr_l24 <= frm_d_addr_l24;
      end   


// Upper24 destination24 frame24 address register  
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         frm_d_addr_u24 <= 16'h0000;         
      else if (write_enable24 & (paddr24 == `AL_FRM_D_ADDR_U24))
         frm_d_addr_u24 <= pwdata24[15:0];
      else
         frm_d_addr_u24 <= frm_d_addr_u24;
      end   


// Lower24 source24 frame24 address register  
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         frm_s_addr_l24 <= 32'h0000_0000;         
      else if (write_enable24 & (paddr24 == `AL_FRM_S_ADDR_L24))
         frm_s_addr_l24 <= pwdata24;
      else
         frm_s_addr_l24 <= frm_s_addr_l24;
      end   


// Upper24 source24 frame24 address register  
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         frm_s_addr_u24 <= 16'h0000;         
      else if (write_enable24 & (paddr24 == `AL_FRM_S_ADDR_U24))
         frm_s_addr_u24 <= pwdata24[15:0];
      else
         frm_s_addr_u24 <= frm_s_addr_u24;
      end   


// Source24 port  
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         s_port24 <= 2'b00;         
      else if (write_enable24 & (paddr24 == `AL_S_PORT24))
         s_port24 <= pwdata24[1:0];
      else
         s_port24 <= s_port24;
      end   


// Lower24 switch24 MAC24 address
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         mac_addr_l24 <= 32'h0000_0000;         
      else if (write_enable24 & (paddr24 == `AL_MAC_ADDR_L24))
         mac_addr_l24 <= pwdata24;
      else
         mac_addr_l24 <= mac_addr_l24;
      end   


// Upper24 switch24 MAC24 address 
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         mac_addr_u24 <= 16'h0000;         
      else if (write_enable24 & (paddr24 == `AL_MAC_ADDR_U24))
         mac_addr_u24 <= pwdata24[15:0];
      else
         mac_addr_u24 <= mac_addr_u24;
      end   


// Best24 before age24 
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         best_bfr_age24 <= 32'hffff_ffff;         
      else if (write_enable24 & (paddr24 == `AL_BB_AGE24))
         best_bfr_age24 <= pwdata24;
      else
         best_bfr_age24 <= best_bfr_age24;
      end   


// clock24 divider24
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         div_clk24 <= 8'h00;         
      else if (write_enable24 & (paddr24 == `AL_DIV_CLK24))
         div_clk24 <= pwdata24[7:0];
      else
         div_clk24 <= div_clk24;
      end   


// command.  Needs to be automatically24 cleared24 on following24 cycle
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable24 & (paddr24 == `AL_COMMAND24))
         command <= pwdata24[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last24 invalidated24 port and address values.  These24 can either24 be updated
//   by normal24 operation24 of address checker overwriting24 existing values or
//   by the age24 checker being commanded24 to invalidate24 out of date24 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk24 or negedge n_p_reset24)
      begin 
      if (~n_p_reset24)
      begin
         lst_inv_addr_l24 <= 32'd0;
         lst_inv_addr_u24 <= 16'd0;
         lst_inv_port24   <= 2'd0;
      end
      else if (reused24)        // reused24 flag24 from address checker
      begin
         lst_inv_addr_l24 <= lst_inv_addr_nrm24[31:0];
         lst_inv_addr_u24 <= lst_inv_addr_nrm24[47:32];
         lst_inv_port24   <= lst_inv_port_nrm24;
      end
//      else if (command == 2'b01)  // invalidate24 aged24 from age24 checker
      else if (inval_in_prog24)  // invalidate24 aged24 from age24 checker
      begin
         lst_inv_addr_l24 <= lst_inv_addr_cmd24[31:0];
         lst_inv_addr_u24 <= lst_inv_addr_cmd24[47:32];
         lst_inv_port24   <= lst_inv_port_cmd24;
      end
      else
      begin
         lst_inv_addr_l24 <= lst_inv_addr_l24;
         lst_inv_addr_u24 <= lst_inv_addr_u24;
         lst_inv_port24   <= lst_inv_port24;
      end
      end
 


`ifdef ABV_ON24

defparam i_apb_monitor24.ABUS_WIDTH24 = 7;

// APB24 ASSERTION24 VIP24
apb_monitor24 i_apb_monitor24(.pclk_i24(pclk24), 
                          .presetn_i24(n_p_reset24),
                          .penable_i24(penable24),
                          .psel_i24(psel24),
                          .paddr_i24(paddr24),
                          .pwrite_i24(pwrite24),
                          .pwdata_i24(pwdata24),
                          .prdata_i24(prdata24)); 

// psl24 default clock24 = (posedge pclk24);

// ASSUMPTIONS24
//// active (set by address checker) and invalidation24 in progress24 should never both be set
//// psl24 assume_never_active_inval_aged24 : assume never (active & inval_in_prog24);


// ASSERTION24 CHECKS24
// never read and write at the same time
// psl24 assert_never_rd_wr24 : assert never (read_enable24 & write_enable24);

// check apb24 writes, pick24 command reqister24 as arbitary24 example24
// psl24 assert_cmd_wr24 : assert always ((paddr24 == `AL_COMMAND24) & write_enable24) -> 
//                                    next(command == prev(pwdata24[1:0])) abort24(~n_p_reset24);


// check rw writes, pick24 clock24 divider24 reqister24 as arbitary24 example24.  It takes24 2 cycles24 to write
// then24 read back data, therefore24 need to store24 original write data for use in assertion24 check
reg [31:0] pwdata_d24;  // 1 cycle delayed24 
always @ (posedge pclk24) pwdata_d24 <= pwdata24;

// psl24 assert_rw_div_clk24 : 
// assert always {((paddr24 == `AL_DIV_CLK24) & write_enable24) ; ((paddr24 == `AL_DIV_CLK24) & read_enable24)} |=>
// {prev(pwdata_d24[7:0]) == prdata24[7:0]};



// COVER24 SANITY24 CHECKS24
// sanity24 read
// psl24 output_for_div_clk24 : cover {((paddr24 == `AL_DIV_CLK24) & read_enable24); prdata24[7:0] == 8'h55};


`endif


endmodule 


