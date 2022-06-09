//File3 name   : alut_reg_bank3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

// compiler3 directives3
`include "alut_defines3.v"


module alut_reg_bank3
(   
   // Inputs3
   pclk3,
   n_p_reset3,
   psel3,            
   penable3,       
   pwrite3,         
   paddr3,           
   pwdata3,          

   curr_time3,
   add_check_active3,
   age_check_active3,
   inval_in_prog3,
   reused3,
   d_port3,
   lst_inv_addr_nrm3,
   lst_inv_port_nrm3,
   lst_inv_addr_cmd3,
   lst_inv_port_cmd3,

   // Outputs3
   mac_addr3,    
   d_addr3,   
   s_addr3,    
   s_port3,    
   best_bfr_age3,
   div_clk3,     
   command, 
   prdata3,  
   clear_reused3           
);


   // APB3 Inputs3
   input                 pclk3;             // APB3 clock3
   input                 n_p_reset3;        // Reset3
   input                 psel3;             // Module3 select3 signal3
   input                 penable3;          // Enable3 signal3 
   input                 pwrite3;           // Write when HIGH3 and read when LOW3
   input [6:0]           paddr3;            // Address bus for read write
   input [31:0]          pwdata3;           // APB3 write bus

   // Inputs3 from other ALUT3 blocks
   input [31:0]          curr_time3;        // current time
   input                 add_check_active3; // used to calculate3 status[0]
   input                 age_check_active3; // used to calculate3 status[0]
   input                 inval_in_prog3;    // status[1]
   input                 reused3;           // status[2]
   input [4:0]           d_port3;           // calculated3 destination3 port for tx3
   input [47:0]          lst_inv_addr_nrm3; // last invalidated3 addr normal3 op
   input [1:0]           lst_inv_port_nrm3; // last invalidated3 port normal3 op
   input [47:0]          lst_inv_addr_cmd3; // last invalidated3 addr via cmd3
   input [1:0]           lst_inv_port_cmd3; // last invalidated3 port via cmd3
   

   output [47:0]         mac_addr3;         // address of the switch3
   output [47:0]         d_addr3;           // address of frame3 to be checked3
   output [47:0]         s_addr3;           // address of frame3 to be stored3
   output [1:0]          s_port3;           // source3 port of current frame3
   output [31:0]         best_bfr_age3;     // best3 before age3
   output [7:0]          div_clk3;          // programmed3 clock3 divider3 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata3;           // APB3 read bus
   output                clear_reused3;     // indicates3 status reg read 

   reg    [31:0]         prdata3;           //APB3 read bus   
   reg    [31:0]         frm_d_addr_l3;     
   reg    [15:0]         frm_d_addr_u3;     
   reg    [31:0]         frm_s_addr_l3;     
   reg    [15:0]         frm_s_addr_u3;     
   reg    [1:0]          s_port3;           
   reg    [31:0]         mac_addr_l3;       
   reg    [15:0]         mac_addr_u3;       
   reg    [31:0]         best_bfr_age3;     
   reg    [7:0]          div_clk3;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l3;   
   reg    [15:0]         lst_inv_addr_u3;   
   reg    [1:0]          lst_inv_port3;     


   // Internal Signal3 Declarations3
   wire                  read_enable3;      //APB3 read enable
   wire                  write_enable3;     //APB3 write enable
   wire   [47:0]         mac_addr3;        
   wire   [47:0]         d_addr3;          
   wire   [47:0]         src_addr3;        
   wire                  clear_reused3;    
   wire                  active;

   // ----------------------------
   // General3 Assignments3
   // ----------------------------

   assign read_enable3    = (psel3 & ~penable3 & ~pwrite3);
   assign write_enable3   = (psel3 & penable3 & pwrite3);

   assign mac_addr3  = {mac_addr_u3, mac_addr_l3}; 
   assign d_addr3 =    {frm_d_addr_u3, frm_d_addr_l3};
   assign s_addr3    = {frm_s_addr_u3, frm_s_addr_l3}; 

   assign clear_reused3 = read_enable3 & (paddr3 == `AL_STATUS3) & ~active;

   assign active = (add_check_active3 | age_check_active3);

// ------------------------------------------------------------------------
//   Read Mux3 Control3 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         prdata3 <= 32'h0000_0000;
      else if (read_enable3)
         begin
         case (paddr3)
            `AL_FRM_D_ADDR_L3   : prdata3 <= frm_d_addr_l3;
            `AL_FRM_D_ADDR_U3   : prdata3 <= {16'd0, frm_d_addr_u3};    
            `AL_FRM_S_ADDR_L3   : prdata3 <= frm_s_addr_l3; 
            `AL_FRM_S_ADDR_U3   : prdata3 <= {16'd0, frm_s_addr_u3}; 
            `AL_S_PORT3         : prdata3 <= {30'd0, s_port3}; 
            `AL_D_PORT3         : prdata3 <= {27'd0, d_port3}; 
            `AL_MAC_ADDR_L3     : prdata3 <= mac_addr_l3;
            `AL_MAC_ADDR_U3     : prdata3 <= {16'd0, mac_addr_u3};   
            `AL_CUR_TIME3       : prdata3 <= curr_time3; 
            `AL_BB_AGE3         : prdata3 <= best_bfr_age3;
            `AL_DIV_CLK3        : prdata3 <= {24'd0, div_clk3}; 
            `AL_STATUS3         : prdata3 <= {29'd0, reused3, inval_in_prog3,
                                           active};
            `AL_LST_INV_ADDR_L3 : prdata3 <= lst_inv_addr_l3; 
            `AL_LST_INV_ADDR_U3 : prdata3 <= {16'd0, lst_inv_addr_u3};
            `AL_LST_INV_PORT3   : prdata3 <= {30'd0, lst_inv_port3};

            default:   prdata3 <= 32'h0000_0000;
         endcase
         end
      else
         prdata3 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB3 writable3 registers
// ------------------------------------------------------------------------
// Lower3 destination3 frame3 address register  
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         frm_d_addr_l3 <= 32'h0000_0000;         
      else if (write_enable3 & (paddr3 == `AL_FRM_D_ADDR_L3))
         frm_d_addr_l3 <= pwdata3;
      else
         frm_d_addr_l3 <= frm_d_addr_l3;
      end   


// Upper3 destination3 frame3 address register  
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         frm_d_addr_u3 <= 16'h0000;         
      else if (write_enable3 & (paddr3 == `AL_FRM_D_ADDR_U3))
         frm_d_addr_u3 <= pwdata3[15:0];
      else
         frm_d_addr_u3 <= frm_d_addr_u3;
      end   


// Lower3 source3 frame3 address register  
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         frm_s_addr_l3 <= 32'h0000_0000;         
      else if (write_enable3 & (paddr3 == `AL_FRM_S_ADDR_L3))
         frm_s_addr_l3 <= pwdata3;
      else
         frm_s_addr_l3 <= frm_s_addr_l3;
      end   


// Upper3 source3 frame3 address register  
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         frm_s_addr_u3 <= 16'h0000;         
      else if (write_enable3 & (paddr3 == `AL_FRM_S_ADDR_U3))
         frm_s_addr_u3 <= pwdata3[15:0];
      else
         frm_s_addr_u3 <= frm_s_addr_u3;
      end   


// Source3 port  
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         s_port3 <= 2'b00;         
      else if (write_enable3 & (paddr3 == `AL_S_PORT3))
         s_port3 <= pwdata3[1:0];
      else
         s_port3 <= s_port3;
      end   


// Lower3 switch3 MAC3 address
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         mac_addr_l3 <= 32'h0000_0000;         
      else if (write_enable3 & (paddr3 == `AL_MAC_ADDR_L3))
         mac_addr_l3 <= pwdata3;
      else
         mac_addr_l3 <= mac_addr_l3;
      end   


// Upper3 switch3 MAC3 address 
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         mac_addr_u3 <= 16'h0000;         
      else if (write_enable3 & (paddr3 == `AL_MAC_ADDR_U3))
         mac_addr_u3 <= pwdata3[15:0];
      else
         mac_addr_u3 <= mac_addr_u3;
      end   


// Best3 before age3 
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         best_bfr_age3 <= 32'hffff_ffff;         
      else if (write_enable3 & (paddr3 == `AL_BB_AGE3))
         best_bfr_age3 <= pwdata3;
      else
         best_bfr_age3 <= best_bfr_age3;
      end   


// clock3 divider3
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         div_clk3 <= 8'h00;         
      else if (write_enable3 & (paddr3 == `AL_DIV_CLK3))
         div_clk3 <= pwdata3[7:0];
      else
         div_clk3 <= div_clk3;
      end   


// command.  Needs to be automatically3 cleared3 on following3 cycle
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable3 & (paddr3 == `AL_COMMAND3))
         command <= pwdata3[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last3 invalidated3 port and address values.  These3 can either3 be updated
//   by normal3 operation3 of address checker overwriting3 existing values or
//   by the age3 checker being commanded3 to invalidate3 out of date3 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk3 or negedge n_p_reset3)
      begin 
      if (~n_p_reset3)
      begin
         lst_inv_addr_l3 <= 32'd0;
         lst_inv_addr_u3 <= 16'd0;
         lst_inv_port3   <= 2'd0;
      end
      else if (reused3)        // reused3 flag3 from address checker
      begin
         lst_inv_addr_l3 <= lst_inv_addr_nrm3[31:0];
         lst_inv_addr_u3 <= lst_inv_addr_nrm3[47:32];
         lst_inv_port3   <= lst_inv_port_nrm3;
      end
//      else if (command == 2'b01)  // invalidate3 aged3 from age3 checker
      else if (inval_in_prog3)  // invalidate3 aged3 from age3 checker
      begin
         lst_inv_addr_l3 <= lst_inv_addr_cmd3[31:0];
         lst_inv_addr_u3 <= lst_inv_addr_cmd3[47:32];
         lst_inv_port3   <= lst_inv_port_cmd3;
      end
      else
      begin
         lst_inv_addr_l3 <= lst_inv_addr_l3;
         lst_inv_addr_u3 <= lst_inv_addr_u3;
         lst_inv_port3   <= lst_inv_port3;
      end
      end
 


`ifdef ABV_ON3

defparam i_apb_monitor3.ABUS_WIDTH3 = 7;

// APB3 ASSERTION3 VIP3
apb_monitor3 i_apb_monitor3(.pclk_i3(pclk3), 
                          .presetn_i3(n_p_reset3),
                          .penable_i3(penable3),
                          .psel_i3(psel3),
                          .paddr_i3(paddr3),
                          .pwrite_i3(pwrite3),
                          .pwdata_i3(pwdata3),
                          .prdata_i3(prdata3)); 

// psl3 default clock3 = (posedge pclk3);

// ASSUMPTIONS3
//// active (set by address checker) and invalidation3 in progress3 should never both be set
//// psl3 assume_never_active_inval_aged3 : assume never (active & inval_in_prog3);


// ASSERTION3 CHECKS3
// never read and write at the same time
// psl3 assert_never_rd_wr3 : assert never (read_enable3 & write_enable3);

// check apb3 writes, pick3 command reqister3 as arbitary3 example3
// psl3 assert_cmd_wr3 : assert always ((paddr3 == `AL_COMMAND3) & write_enable3) -> 
//                                    next(command == prev(pwdata3[1:0])) abort3(~n_p_reset3);


// check rw writes, pick3 clock3 divider3 reqister3 as arbitary3 example3.  It takes3 2 cycles3 to write
// then3 read back data, therefore3 need to store3 original write data for use in assertion3 check
reg [31:0] pwdata_d3;  // 1 cycle delayed3 
always @ (posedge pclk3) pwdata_d3 <= pwdata3;

// psl3 assert_rw_div_clk3 : 
// assert always {((paddr3 == `AL_DIV_CLK3) & write_enable3) ; ((paddr3 == `AL_DIV_CLK3) & read_enable3)} |=>
// {prev(pwdata_d3[7:0]) == prdata3[7:0]};



// COVER3 SANITY3 CHECKS3
// sanity3 read
// psl3 output_for_div_clk3 : cover {((paddr3 == `AL_DIV_CLK3) & read_enable3); prdata3[7:0] == 8'h55};


`endif


endmodule 


