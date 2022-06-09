//File15 name   : alut_reg_bank15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

// compiler15 directives15
`include "alut_defines15.v"


module alut_reg_bank15
(   
   // Inputs15
   pclk15,
   n_p_reset15,
   psel15,            
   penable15,       
   pwrite15,         
   paddr15,           
   pwdata15,          

   curr_time15,
   add_check_active15,
   age_check_active15,
   inval_in_prog15,
   reused15,
   d_port15,
   lst_inv_addr_nrm15,
   lst_inv_port_nrm15,
   lst_inv_addr_cmd15,
   lst_inv_port_cmd15,

   // Outputs15
   mac_addr15,    
   d_addr15,   
   s_addr15,    
   s_port15,    
   best_bfr_age15,
   div_clk15,     
   command, 
   prdata15,  
   clear_reused15           
);


   // APB15 Inputs15
   input                 pclk15;             // APB15 clock15
   input                 n_p_reset15;        // Reset15
   input                 psel15;             // Module15 select15 signal15
   input                 penable15;          // Enable15 signal15 
   input                 pwrite15;           // Write when HIGH15 and read when LOW15
   input [6:0]           paddr15;            // Address bus for read write
   input [31:0]          pwdata15;           // APB15 write bus

   // Inputs15 from other ALUT15 blocks
   input [31:0]          curr_time15;        // current time
   input                 add_check_active15; // used to calculate15 status[0]
   input                 age_check_active15; // used to calculate15 status[0]
   input                 inval_in_prog15;    // status[1]
   input                 reused15;           // status[2]
   input [4:0]           d_port15;           // calculated15 destination15 port for tx15
   input [47:0]          lst_inv_addr_nrm15; // last invalidated15 addr normal15 op
   input [1:0]           lst_inv_port_nrm15; // last invalidated15 port normal15 op
   input [47:0]          lst_inv_addr_cmd15; // last invalidated15 addr via cmd15
   input [1:0]           lst_inv_port_cmd15; // last invalidated15 port via cmd15
   

   output [47:0]         mac_addr15;         // address of the switch15
   output [47:0]         d_addr15;           // address of frame15 to be checked15
   output [47:0]         s_addr15;           // address of frame15 to be stored15
   output [1:0]          s_port15;           // source15 port of current frame15
   output [31:0]         best_bfr_age15;     // best15 before age15
   output [7:0]          div_clk15;          // programmed15 clock15 divider15 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata15;           // APB15 read bus
   output                clear_reused15;     // indicates15 status reg read 

   reg    [31:0]         prdata15;           //APB15 read bus   
   reg    [31:0]         frm_d_addr_l15;     
   reg    [15:0]         frm_d_addr_u15;     
   reg    [31:0]         frm_s_addr_l15;     
   reg    [15:0]         frm_s_addr_u15;     
   reg    [1:0]          s_port15;           
   reg    [31:0]         mac_addr_l15;       
   reg    [15:0]         mac_addr_u15;       
   reg    [31:0]         best_bfr_age15;     
   reg    [7:0]          div_clk15;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l15;   
   reg    [15:0]         lst_inv_addr_u15;   
   reg    [1:0]          lst_inv_port15;     


   // Internal Signal15 Declarations15
   wire                  read_enable15;      //APB15 read enable
   wire                  write_enable15;     //APB15 write enable
   wire   [47:0]         mac_addr15;        
   wire   [47:0]         d_addr15;          
   wire   [47:0]         src_addr15;        
   wire                  clear_reused15;    
   wire                  active;

   // ----------------------------
   // General15 Assignments15
   // ----------------------------

   assign read_enable15    = (psel15 & ~penable15 & ~pwrite15);
   assign write_enable15   = (psel15 & penable15 & pwrite15);

   assign mac_addr15  = {mac_addr_u15, mac_addr_l15}; 
   assign d_addr15 =    {frm_d_addr_u15, frm_d_addr_l15};
   assign s_addr15    = {frm_s_addr_u15, frm_s_addr_l15}; 

   assign clear_reused15 = read_enable15 & (paddr15 == `AL_STATUS15) & ~active;

   assign active = (add_check_active15 | age_check_active15);

// ------------------------------------------------------------------------
//   Read Mux15 Control15 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         prdata15 <= 32'h0000_0000;
      else if (read_enable15)
         begin
         case (paddr15)
            `AL_FRM_D_ADDR_L15   : prdata15 <= frm_d_addr_l15;
            `AL_FRM_D_ADDR_U15   : prdata15 <= {16'd0, frm_d_addr_u15};    
            `AL_FRM_S_ADDR_L15   : prdata15 <= frm_s_addr_l15; 
            `AL_FRM_S_ADDR_U15   : prdata15 <= {16'd0, frm_s_addr_u15}; 
            `AL_S_PORT15         : prdata15 <= {30'd0, s_port15}; 
            `AL_D_PORT15         : prdata15 <= {27'd0, d_port15}; 
            `AL_MAC_ADDR_L15     : prdata15 <= mac_addr_l15;
            `AL_MAC_ADDR_U15     : prdata15 <= {16'd0, mac_addr_u15};   
            `AL_CUR_TIME15       : prdata15 <= curr_time15; 
            `AL_BB_AGE15         : prdata15 <= best_bfr_age15;
            `AL_DIV_CLK15        : prdata15 <= {24'd0, div_clk15}; 
            `AL_STATUS15         : prdata15 <= {29'd0, reused15, inval_in_prog15,
                                           active};
            `AL_LST_INV_ADDR_L15 : prdata15 <= lst_inv_addr_l15; 
            `AL_LST_INV_ADDR_U15 : prdata15 <= {16'd0, lst_inv_addr_u15};
            `AL_LST_INV_PORT15   : prdata15 <= {30'd0, lst_inv_port15};

            default:   prdata15 <= 32'h0000_0000;
         endcase
         end
      else
         prdata15 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB15 writable15 registers
// ------------------------------------------------------------------------
// Lower15 destination15 frame15 address register  
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         frm_d_addr_l15 <= 32'h0000_0000;         
      else if (write_enable15 & (paddr15 == `AL_FRM_D_ADDR_L15))
         frm_d_addr_l15 <= pwdata15;
      else
         frm_d_addr_l15 <= frm_d_addr_l15;
      end   


// Upper15 destination15 frame15 address register  
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         frm_d_addr_u15 <= 16'h0000;         
      else if (write_enable15 & (paddr15 == `AL_FRM_D_ADDR_U15))
         frm_d_addr_u15 <= pwdata15[15:0];
      else
         frm_d_addr_u15 <= frm_d_addr_u15;
      end   


// Lower15 source15 frame15 address register  
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         frm_s_addr_l15 <= 32'h0000_0000;         
      else if (write_enable15 & (paddr15 == `AL_FRM_S_ADDR_L15))
         frm_s_addr_l15 <= pwdata15;
      else
         frm_s_addr_l15 <= frm_s_addr_l15;
      end   


// Upper15 source15 frame15 address register  
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         frm_s_addr_u15 <= 16'h0000;         
      else if (write_enable15 & (paddr15 == `AL_FRM_S_ADDR_U15))
         frm_s_addr_u15 <= pwdata15[15:0];
      else
         frm_s_addr_u15 <= frm_s_addr_u15;
      end   


// Source15 port  
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         s_port15 <= 2'b00;         
      else if (write_enable15 & (paddr15 == `AL_S_PORT15))
         s_port15 <= pwdata15[1:0];
      else
         s_port15 <= s_port15;
      end   


// Lower15 switch15 MAC15 address
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         mac_addr_l15 <= 32'h0000_0000;         
      else if (write_enable15 & (paddr15 == `AL_MAC_ADDR_L15))
         mac_addr_l15 <= pwdata15;
      else
         mac_addr_l15 <= mac_addr_l15;
      end   


// Upper15 switch15 MAC15 address 
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         mac_addr_u15 <= 16'h0000;         
      else if (write_enable15 & (paddr15 == `AL_MAC_ADDR_U15))
         mac_addr_u15 <= pwdata15[15:0];
      else
         mac_addr_u15 <= mac_addr_u15;
      end   


// Best15 before age15 
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         best_bfr_age15 <= 32'hffff_ffff;         
      else if (write_enable15 & (paddr15 == `AL_BB_AGE15))
         best_bfr_age15 <= pwdata15;
      else
         best_bfr_age15 <= best_bfr_age15;
      end   


// clock15 divider15
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         div_clk15 <= 8'h00;         
      else if (write_enable15 & (paddr15 == `AL_DIV_CLK15))
         div_clk15 <= pwdata15[7:0];
      else
         div_clk15 <= div_clk15;
      end   


// command.  Needs to be automatically15 cleared15 on following15 cycle
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable15 & (paddr15 == `AL_COMMAND15))
         command <= pwdata15[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last15 invalidated15 port and address values.  These15 can either15 be updated
//   by normal15 operation15 of address checker overwriting15 existing values or
//   by the age15 checker being commanded15 to invalidate15 out of date15 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk15 or negedge n_p_reset15)
      begin 
      if (~n_p_reset15)
      begin
         lst_inv_addr_l15 <= 32'd0;
         lst_inv_addr_u15 <= 16'd0;
         lst_inv_port15   <= 2'd0;
      end
      else if (reused15)        // reused15 flag15 from address checker
      begin
         lst_inv_addr_l15 <= lst_inv_addr_nrm15[31:0];
         lst_inv_addr_u15 <= lst_inv_addr_nrm15[47:32];
         lst_inv_port15   <= lst_inv_port_nrm15;
      end
//      else if (command == 2'b01)  // invalidate15 aged15 from age15 checker
      else if (inval_in_prog15)  // invalidate15 aged15 from age15 checker
      begin
         lst_inv_addr_l15 <= lst_inv_addr_cmd15[31:0];
         lst_inv_addr_u15 <= lst_inv_addr_cmd15[47:32];
         lst_inv_port15   <= lst_inv_port_cmd15;
      end
      else
      begin
         lst_inv_addr_l15 <= lst_inv_addr_l15;
         lst_inv_addr_u15 <= lst_inv_addr_u15;
         lst_inv_port15   <= lst_inv_port15;
      end
      end
 


`ifdef ABV_ON15

defparam i_apb_monitor15.ABUS_WIDTH15 = 7;

// APB15 ASSERTION15 VIP15
apb_monitor15 i_apb_monitor15(.pclk_i15(pclk15), 
                          .presetn_i15(n_p_reset15),
                          .penable_i15(penable15),
                          .psel_i15(psel15),
                          .paddr_i15(paddr15),
                          .pwrite_i15(pwrite15),
                          .pwdata_i15(pwdata15),
                          .prdata_i15(prdata15)); 

// psl15 default clock15 = (posedge pclk15);

// ASSUMPTIONS15
//// active (set by address checker) and invalidation15 in progress15 should never both be set
//// psl15 assume_never_active_inval_aged15 : assume never (active & inval_in_prog15);


// ASSERTION15 CHECKS15
// never read and write at the same time
// psl15 assert_never_rd_wr15 : assert never (read_enable15 & write_enable15);

// check apb15 writes, pick15 command reqister15 as arbitary15 example15
// psl15 assert_cmd_wr15 : assert always ((paddr15 == `AL_COMMAND15) & write_enable15) -> 
//                                    next(command == prev(pwdata15[1:0])) abort15(~n_p_reset15);


// check rw writes, pick15 clock15 divider15 reqister15 as arbitary15 example15.  It takes15 2 cycles15 to write
// then15 read back data, therefore15 need to store15 original write data for use in assertion15 check
reg [31:0] pwdata_d15;  // 1 cycle delayed15 
always @ (posedge pclk15) pwdata_d15 <= pwdata15;

// psl15 assert_rw_div_clk15 : 
// assert always {((paddr15 == `AL_DIV_CLK15) & write_enable15) ; ((paddr15 == `AL_DIV_CLK15) & read_enable15)} |=>
// {prev(pwdata_d15[7:0]) == prdata15[7:0]};



// COVER15 SANITY15 CHECKS15
// sanity15 read
// psl15 output_for_div_clk15 : cover {((paddr15 == `AL_DIV_CLK15) & read_enable15); prdata15[7:0] == 8'h55};


`endif


endmodule 


