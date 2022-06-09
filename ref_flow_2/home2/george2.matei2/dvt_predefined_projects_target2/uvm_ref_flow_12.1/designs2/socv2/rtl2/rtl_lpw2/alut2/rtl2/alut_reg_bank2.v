//File2 name   : alut_reg_bank2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

// compiler2 directives2
`include "alut_defines2.v"


module alut_reg_bank2
(   
   // Inputs2
   pclk2,
   n_p_reset2,
   psel2,            
   penable2,       
   pwrite2,         
   paddr2,           
   pwdata2,          

   curr_time2,
   add_check_active2,
   age_check_active2,
   inval_in_prog2,
   reused2,
   d_port2,
   lst_inv_addr_nrm2,
   lst_inv_port_nrm2,
   lst_inv_addr_cmd2,
   lst_inv_port_cmd2,

   // Outputs2
   mac_addr2,    
   d_addr2,   
   s_addr2,    
   s_port2,    
   best_bfr_age2,
   div_clk2,     
   command, 
   prdata2,  
   clear_reused2           
);


   // APB2 Inputs2
   input                 pclk2;             // APB2 clock2
   input                 n_p_reset2;        // Reset2
   input                 psel2;             // Module2 select2 signal2
   input                 penable2;          // Enable2 signal2 
   input                 pwrite2;           // Write when HIGH2 and read when LOW2
   input [6:0]           paddr2;            // Address bus for read write
   input [31:0]          pwdata2;           // APB2 write bus

   // Inputs2 from other ALUT2 blocks
   input [31:0]          curr_time2;        // current time
   input                 add_check_active2; // used to calculate2 status[0]
   input                 age_check_active2; // used to calculate2 status[0]
   input                 inval_in_prog2;    // status[1]
   input                 reused2;           // status[2]
   input [4:0]           d_port2;           // calculated2 destination2 port for tx2
   input [47:0]          lst_inv_addr_nrm2; // last invalidated2 addr normal2 op
   input [1:0]           lst_inv_port_nrm2; // last invalidated2 port normal2 op
   input [47:0]          lst_inv_addr_cmd2; // last invalidated2 addr via cmd2
   input [1:0]           lst_inv_port_cmd2; // last invalidated2 port via cmd2
   

   output [47:0]         mac_addr2;         // address of the switch2
   output [47:0]         d_addr2;           // address of frame2 to be checked2
   output [47:0]         s_addr2;           // address of frame2 to be stored2
   output [1:0]          s_port2;           // source2 port of current frame2
   output [31:0]         best_bfr_age2;     // best2 before age2
   output [7:0]          div_clk2;          // programmed2 clock2 divider2 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata2;           // APB2 read bus
   output                clear_reused2;     // indicates2 status reg read 

   reg    [31:0]         prdata2;           //APB2 read bus   
   reg    [31:0]         frm_d_addr_l2;     
   reg    [15:0]         frm_d_addr_u2;     
   reg    [31:0]         frm_s_addr_l2;     
   reg    [15:0]         frm_s_addr_u2;     
   reg    [1:0]          s_port2;           
   reg    [31:0]         mac_addr_l2;       
   reg    [15:0]         mac_addr_u2;       
   reg    [31:0]         best_bfr_age2;     
   reg    [7:0]          div_clk2;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l2;   
   reg    [15:0]         lst_inv_addr_u2;   
   reg    [1:0]          lst_inv_port2;     


   // Internal Signal2 Declarations2
   wire                  read_enable2;      //APB2 read enable
   wire                  write_enable2;     //APB2 write enable
   wire   [47:0]         mac_addr2;        
   wire   [47:0]         d_addr2;          
   wire   [47:0]         src_addr2;        
   wire                  clear_reused2;    
   wire                  active;

   // ----------------------------
   // General2 Assignments2
   // ----------------------------

   assign read_enable2    = (psel2 & ~penable2 & ~pwrite2);
   assign write_enable2   = (psel2 & penable2 & pwrite2);

   assign mac_addr2  = {mac_addr_u2, mac_addr_l2}; 
   assign d_addr2 =    {frm_d_addr_u2, frm_d_addr_l2};
   assign s_addr2    = {frm_s_addr_u2, frm_s_addr_l2}; 

   assign clear_reused2 = read_enable2 & (paddr2 == `AL_STATUS2) & ~active;

   assign active = (add_check_active2 | age_check_active2);

// ------------------------------------------------------------------------
//   Read Mux2 Control2 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         prdata2 <= 32'h0000_0000;
      else if (read_enable2)
         begin
         case (paddr2)
            `AL_FRM_D_ADDR_L2   : prdata2 <= frm_d_addr_l2;
            `AL_FRM_D_ADDR_U2   : prdata2 <= {16'd0, frm_d_addr_u2};    
            `AL_FRM_S_ADDR_L2   : prdata2 <= frm_s_addr_l2; 
            `AL_FRM_S_ADDR_U2   : prdata2 <= {16'd0, frm_s_addr_u2}; 
            `AL_S_PORT2         : prdata2 <= {30'd0, s_port2}; 
            `AL_D_PORT2         : prdata2 <= {27'd0, d_port2}; 
            `AL_MAC_ADDR_L2     : prdata2 <= mac_addr_l2;
            `AL_MAC_ADDR_U2     : prdata2 <= {16'd0, mac_addr_u2};   
            `AL_CUR_TIME2       : prdata2 <= curr_time2; 
            `AL_BB_AGE2         : prdata2 <= best_bfr_age2;
            `AL_DIV_CLK2        : prdata2 <= {24'd0, div_clk2}; 
            `AL_STATUS2         : prdata2 <= {29'd0, reused2, inval_in_prog2,
                                           active};
            `AL_LST_INV_ADDR_L2 : prdata2 <= lst_inv_addr_l2; 
            `AL_LST_INV_ADDR_U2 : prdata2 <= {16'd0, lst_inv_addr_u2};
            `AL_LST_INV_PORT2   : prdata2 <= {30'd0, lst_inv_port2};

            default:   prdata2 <= 32'h0000_0000;
         endcase
         end
      else
         prdata2 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB2 writable2 registers
// ------------------------------------------------------------------------
// Lower2 destination2 frame2 address register  
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         frm_d_addr_l2 <= 32'h0000_0000;         
      else if (write_enable2 & (paddr2 == `AL_FRM_D_ADDR_L2))
         frm_d_addr_l2 <= pwdata2;
      else
         frm_d_addr_l2 <= frm_d_addr_l2;
      end   


// Upper2 destination2 frame2 address register  
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         frm_d_addr_u2 <= 16'h0000;         
      else if (write_enable2 & (paddr2 == `AL_FRM_D_ADDR_U2))
         frm_d_addr_u2 <= pwdata2[15:0];
      else
         frm_d_addr_u2 <= frm_d_addr_u2;
      end   


// Lower2 source2 frame2 address register  
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         frm_s_addr_l2 <= 32'h0000_0000;         
      else if (write_enable2 & (paddr2 == `AL_FRM_S_ADDR_L2))
         frm_s_addr_l2 <= pwdata2;
      else
         frm_s_addr_l2 <= frm_s_addr_l2;
      end   


// Upper2 source2 frame2 address register  
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         frm_s_addr_u2 <= 16'h0000;         
      else if (write_enable2 & (paddr2 == `AL_FRM_S_ADDR_U2))
         frm_s_addr_u2 <= pwdata2[15:0];
      else
         frm_s_addr_u2 <= frm_s_addr_u2;
      end   


// Source2 port  
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         s_port2 <= 2'b00;         
      else if (write_enable2 & (paddr2 == `AL_S_PORT2))
         s_port2 <= pwdata2[1:0];
      else
         s_port2 <= s_port2;
      end   


// Lower2 switch2 MAC2 address
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         mac_addr_l2 <= 32'h0000_0000;         
      else if (write_enable2 & (paddr2 == `AL_MAC_ADDR_L2))
         mac_addr_l2 <= pwdata2;
      else
         mac_addr_l2 <= mac_addr_l2;
      end   


// Upper2 switch2 MAC2 address 
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         mac_addr_u2 <= 16'h0000;         
      else if (write_enable2 & (paddr2 == `AL_MAC_ADDR_U2))
         mac_addr_u2 <= pwdata2[15:0];
      else
         mac_addr_u2 <= mac_addr_u2;
      end   


// Best2 before age2 
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         best_bfr_age2 <= 32'hffff_ffff;         
      else if (write_enable2 & (paddr2 == `AL_BB_AGE2))
         best_bfr_age2 <= pwdata2;
      else
         best_bfr_age2 <= best_bfr_age2;
      end   


// clock2 divider2
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         div_clk2 <= 8'h00;         
      else if (write_enable2 & (paddr2 == `AL_DIV_CLK2))
         div_clk2 <= pwdata2[7:0];
      else
         div_clk2 <= div_clk2;
      end   


// command.  Needs to be automatically2 cleared2 on following2 cycle
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable2 & (paddr2 == `AL_COMMAND2))
         command <= pwdata2[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last2 invalidated2 port and address values.  These2 can either2 be updated
//   by normal2 operation2 of address checker overwriting2 existing values or
//   by the age2 checker being commanded2 to invalidate2 out of date2 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk2 or negedge n_p_reset2)
      begin 
      if (~n_p_reset2)
      begin
         lst_inv_addr_l2 <= 32'd0;
         lst_inv_addr_u2 <= 16'd0;
         lst_inv_port2   <= 2'd0;
      end
      else if (reused2)        // reused2 flag2 from address checker
      begin
         lst_inv_addr_l2 <= lst_inv_addr_nrm2[31:0];
         lst_inv_addr_u2 <= lst_inv_addr_nrm2[47:32];
         lst_inv_port2   <= lst_inv_port_nrm2;
      end
//      else if (command == 2'b01)  // invalidate2 aged2 from age2 checker
      else if (inval_in_prog2)  // invalidate2 aged2 from age2 checker
      begin
         lst_inv_addr_l2 <= lst_inv_addr_cmd2[31:0];
         lst_inv_addr_u2 <= lst_inv_addr_cmd2[47:32];
         lst_inv_port2   <= lst_inv_port_cmd2;
      end
      else
      begin
         lst_inv_addr_l2 <= lst_inv_addr_l2;
         lst_inv_addr_u2 <= lst_inv_addr_u2;
         lst_inv_port2   <= lst_inv_port2;
      end
      end
 


`ifdef ABV_ON2

defparam i_apb_monitor2.ABUS_WIDTH2 = 7;

// APB2 ASSERTION2 VIP2
apb_monitor2 i_apb_monitor2(.pclk_i2(pclk2), 
                          .presetn_i2(n_p_reset2),
                          .penable_i2(penable2),
                          .psel_i2(psel2),
                          .paddr_i2(paddr2),
                          .pwrite_i2(pwrite2),
                          .pwdata_i2(pwdata2),
                          .prdata_i2(prdata2)); 

// psl2 default clock2 = (posedge pclk2);

// ASSUMPTIONS2
//// active (set by address checker) and invalidation2 in progress2 should never both be set
//// psl2 assume_never_active_inval_aged2 : assume never (active & inval_in_prog2);


// ASSERTION2 CHECKS2
// never read and write at the same time
// psl2 assert_never_rd_wr2 : assert never (read_enable2 & write_enable2);

// check apb2 writes, pick2 command reqister2 as arbitary2 example2
// psl2 assert_cmd_wr2 : assert always ((paddr2 == `AL_COMMAND2) & write_enable2) -> 
//                                    next(command == prev(pwdata2[1:0])) abort2(~n_p_reset2);


// check rw writes, pick2 clock2 divider2 reqister2 as arbitary2 example2.  It takes2 2 cycles2 to write
// then2 read back data, therefore2 need to store2 original write data for use in assertion2 check
reg [31:0] pwdata_d2;  // 1 cycle delayed2 
always @ (posedge pclk2) pwdata_d2 <= pwdata2;

// psl2 assert_rw_div_clk2 : 
// assert always {((paddr2 == `AL_DIV_CLK2) & write_enable2) ; ((paddr2 == `AL_DIV_CLK2) & read_enable2)} |=>
// {prev(pwdata_d2[7:0]) == prdata2[7:0]};



// COVER2 SANITY2 CHECKS2
// sanity2 read
// psl2 output_for_div_clk2 : cover {((paddr2 == `AL_DIV_CLK2) & read_enable2); prdata2[7:0] == 8'h55};


`endif


endmodule 


