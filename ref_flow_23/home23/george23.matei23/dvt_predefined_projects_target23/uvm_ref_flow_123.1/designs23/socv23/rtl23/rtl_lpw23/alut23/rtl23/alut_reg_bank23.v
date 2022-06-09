//File23 name   : alut_reg_bank23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

// compiler23 directives23
`include "alut_defines23.v"


module alut_reg_bank23
(   
   // Inputs23
   pclk23,
   n_p_reset23,
   psel23,            
   penable23,       
   pwrite23,         
   paddr23,           
   pwdata23,          

   curr_time23,
   add_check_active23,
   age_check_active23,
   inval_in_prog23,
   reused23,
   d_port23,
   lst_inv_addr_nrm23,
   lst_inv_port_nrm23,
   lst_inv_addr_cmd23,
   lst_inv_port_cmd23,

   // Outputs23
   mac_addr23,    
   d_addr23,   
   s_addr23,    
   s_port23,    
   best_bfr_age23,
   div_clk23,     
   command, 
   prdata23,  
   clear_reused23           
);


   // APB23 Inputs23
   input                 pclk23;             // APB23 clock23
   input                 n_p_reset23;        // Reset23
   input                 psel23;             // Module23 select23 signal23
   input                 penable23;          // Enable23 signal23 
   input                 pwrite23;           // Write when HIGH23 and read when LOW23
   input [6:0]           paddr23;            // Address bus for read write
   input [31:0]          pwdata23;           // APB23 write bus

   // Inputs23 from other ALUT23 blocks
   input [31:0]          curr_time23;        // current time
   input                 add_check_active23; // used to calculate23 status[0]
   input                 age_check_active23; // used to calculate23 status[0]
   input                 inval_in_prog23;    // status[1]
   input                 reused23;           // status[2]
   input [4:0]           d_port23;           // calculated23 destination23 port for tx23
   input [47:0]          lst_inv_addr_nrm23; // last invalidated23 addr normal23 op
   input [1:0]           lst_inv_port_nrm23; // last invalidated23 port normal23 op
   input [47:0]          lst_inv_addr_cmd23; // last invalidated23 addr via cmd23
   input [1:0]           lst_inv_port_cmd23; // last invalidated23 port via cmd23
   

   output [47:0]         mac_addr23;         // address of the switch23
   output [47:0]         d_addr23;           // address of frame23 to be checked23
   output [47:0]         s_addr23;           // address of frame23 to be stored23
   output [1:0]          s_port23;           // source23 port of current frame23
   output [31:0]         best_bfr_age23;     // best23 before age23
   output [7:0]          div_clk23;          // programmed23 clock23 divider23 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata23;           // APB23 read bus
   output                clear_reused23;     // indicates23 status reg read 

   reg    [31:0]         prdata23;           //APB23 read bus   
   reg    [31:0]         frm_d_addr_l23;     
   reg    [15:0]         frm_d_addr_u23;     
   reg    [31:0]         frm_s_addr_l23;     
   reg    [15:0]         frm_s_addr_u23;     
   reg    [1:0]          s_port23;           
   reg    [31:0]         mac_addr_l23;       
   reg    [15:0]         mac_addr_u23;       
   reg    [31:0]         best_bfr_age23;     
   reg    [7:0]          div_clk23;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l23;   
   reg    [15:0]         lst_inv_addr_u23;   
   reg    [1:0]          lst_inv_port23;     


   // Internal Signal23 Declarations23
   wire                  read_enable23;      //APB23 read enable
   wire                  write_enable23;     //APB23 write enable
   wire   [47:0]         mac_addr23;        
   wire   [47:0]         d_addr23;          
   wire   [47:0]         src_addr23;        
   wire                  clear_reused23;    
   wire                  active;

   // ----------------------------
   // General23 Assignments23
   // ----------------------------

   assign read_enable23    = (psel23 & ~penable23 & ~pwrite23);
   assign write_enable23   = (psel23 & penable23 & pwrite23);

   assign mac_addr23  = {mac_addr_u23, mac_addr_l23}; 
   assign d_addr23 =    {frm_d_addr_u23, frm_d_addr_l23};
   assign s_addr23    = {frm_s_addr_u23, frm_s_addr_l23}; 

   assign clear_reused23 = read_enable23 & (paddr23 == `AL_STATUS23) & ~active;

   assign active = (add_check_active23 | age_check_active23);

// ------------------------------------------------------------------------
//   Read Mux23 Control23 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         prdata23 <= 32'h0000_0000;
      else if (read_enable23)
         begin
         case (paddr23)
            `AL_FRM_D_ADDR_L23   : prdata23 <= frm_d_addr_l23;
            `AL_FRM_D_ADDR_U23   : prdata23 <= {16'd0, frm_d_addr_u23};    
            `AL_FRM_S_ADDR_L23   : prdata23 <= frm_s_addr_l23; 
            `AL_FRM_S_ADDR_U23   : prdata23 <= {16'd0, frm_s_addr_u23}; 
            `AL_S_PORT23         : prdata23 <= {30'd0, s_port23}; 
            `AL_D_PORT23         : prdata23 <= {27'd0, d_port23}; 
            `AL_MAC_ADDR_L23     : prdata23 <= mac_addr_l23;
            `AL_MAC_ADDR_U23     : prdata23 <= {16'd0, mac_addr_u23};   
            `AL_CUR_TIME23       : prdata23 <= curr_time23; 
            `AL_BB_AGE23         : prdata23 <= best_bfr_age23;
            `AL_DIV_CLK23        : prdata23 <= {24'd0, div_clk23}; 
            `AL_STATUS23         : prdata23 <= {29'd0, reused23, inval_in_prog23,
                                           active};
            `AL_LST_INV_ADDR_L23 : prdata23 <= lst_inv_addr_l23; 
            `AL_LST_INV_ADDR_U23 : prdata23 <= {16'd0, lst_inv_addr_u23};
            `AL_LST_INV_PORT23   : prdata23 <= {30'd0, lst_inv_port23};

            default:   prdata23 <= 32'h0000_0000;
         endcase
         end
      else
         prdata23 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB23 writable23 registers
// ------------------------------------------------------------------------
// Lower23 destination23 frame23 address register  
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         frm_d_addr_l23 <= 32'h0000_0000;         
      else if (write_enable23 & (paddr23 == `AL_FRM_D_ADDR_L23))
         frm_d_addr_l23 <= pwdata23;
      else
         frm_d_addr_l23 <= frm_d_addr_l23;
      end   


// Upper23 destination23 frame23 address register  
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         frm_d_addr_u23 <= 16'h0000;         
      else if (write_enable23 & (paddr23 == `AL_FRM_D_ADDR_U23))
         frm_d_addr_u23 <= pwdata23[15:0];
      else
         frm_d_addr_u23 <= frm_d_addr_u23;
      end   


// Lower23 source23 frame23 address register  
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         frm_s_addr_l23 <= 32'h0000_0000;         
      else if (write_enable23 & (paddr23 == `AL_FRM_S_ADDR_L23))
         frm_s_addr_l23 <= pwdata23;
      else
         frm_s_addr_l23 <= frm_s_addr_l23;
      end   


// Upper23 source23 frame23 address register  
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         frm_s_addr_u23 <= 16'h0000;         
      else if (write_enable23 & (paddr23 == `AL_FRM_S_ADDR_U23))
         frm_s_addr_u23 <= pwdata23[15:0];
      else
         frm_s_addr_u23 <= frm_s_addr_u23;
      end   


// Source23 port  
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         s_port23 <= 2'b00;         
      else if (write_enable23 & (paddr23 == `AL_S_PORT23))
         s_port23 <= pwdata23[1:0];
      else
         s_port23 <= s_port23;
      end   


// Lower23 switch23 MAC23 address
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         mac_addr_l23 <= 32'h0000_0000;         
      else if (write_enable23 & (paddr23 == `AL_MAC_ADDR_L23))
         mac_addr_l23 <= pwdata23;
      else
         mac_addr_l23 <= mac_addr_l23;
      end   


// Upper23 switch23 MAC23 address 
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         mac_addr_u23 <= 16'h0000;         
      else if (write_enable23 & (paddr23 == `AL_MAC_ADDR_U23))
         mac_addr_u23 <= pwdata23[15:0];
      else
         mac_addr_u23 <= mac_addr_u23;
      end   


// Best23 before age23 
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         best_bfr_age23 <= 32'hffff_ffff;         
      else if (write_enable23 & (paddr23 == `AL_BB_AGE23))
         best_bfr_age23 <= pwdata23;
      else
         best_bfr_age23 <= best_bfr_age23;
      end   


// clock23 divider23
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         div_clk23 <= 8'h00;         
      else if (write_enable23 & (paddr23 == `AL_DIV_CLK23))
         div_clk23 <= pwdata23[7:0];
      else
         div_clk23 <= div_clk23;
      end   


// command.  Needs to be automatically23 cleared23 on following23 cycle
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable23 & (paddr23 == `AL_COMMAND23))
         command <= pwdata23[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last23 invalidated23 port and address values.  These23 can either23 be updated
//   by normal23 operation23 of address checker overwriting23 existing values or
//   by the age23 checker being commanded23 to invalidate23 out of date23 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk23 or negedge n_p_reset23)
      begin 
      if (~n_p_reset23)
      begin
         lst_inv_addr_l23 <= 32'd0;
         lst_inv_addr_u23 <= 16'd0;
         lst_inv_port23   <= 2'd0;
      end
      else if (reused23)        // reused23 flag23 from address checker
      begin
         lst_inv_addr_l23 <= lst_inv_addr_nrm23[31:0];
         lst_inv_addr_u23 <= lst_inv_addr_nrm23[47:32];
         lst_inv_port23   <= lst_inv_port_nrm23;
      end
//      else if (command == 2'b01)  // invalidate23 aged23 from age23 checker
      else if (inval_in_prog23)  // invalidate23 aged23 from age23 checker
      begin
         lst_inv_addr_l23 <= lst_inv_addr_cmd23[31:0];
         lst_inv_addr_u23 <= lst_inv_addr_cmd23[47:32];
         lst_inv_port23   <= lst_inv_port_cmd23;
      end
      else
      begin
         lst_inv_addr_l23 <= lst_inv_addr_l23;
         lst_inv_addr_u23 <= lst_inv_addr_u23;
         lst_inv_port23   <= lst_inv_port23;
      end
      end
 


`ifdef ABV_ON23

defparam i_apb_monitor23.ABUS_WIDTH23 = 7;

// APB23 ASSERTION23 VIP23
apb_monitor23 i_apb_monitor23(.pclk_i23(pclk23), 
                          .presetn_i23(n_p_reset23),
                          .penable_i23(penable23),
                          .psel_i23(psel23),
                          .paddr_i23(paddr23),
                          .pwrite_i23(pwrite23),
                          .pwdata_i23(pwdata23),
                          .prdata_i23(prdata23)); 

// psl23 default clock23 = (posedge pclk23);

// ASSUMPTIONS23
//// active (set by address checker) and invalidation23 in progress23 should never both be set
//// psl23 assume_never_active_inval_aged23 : assume never (active & inval_in_prog23);


// ASSERTION23 CHECKS23
// never read and write at the same time
// psl23 assert_never_rd_wr23 : assert never (read_enable23 & write_enable23);

// check apb23 writes, pick23 command reqister23 as arbitary23 example23
// psl23 assert_cmd_wr23 : assert always ((paddr23 == `AL_COMMAND23) & write_enable23) -> 
//                                    next(command == prev(pwdata23[1:0])) abort23(~n_p_reset23);


// check rw writes, pick23 clock23 divider23 reqister23 as arbitary23 example23.  It takes23 2 cycles23 to write
// then23 read back data, therefore23 need to store23 original write data for use in assertion23 check
reg [31:0] pwdata_d23;  // 1 cycle delayed23 
always @ (posedge pclk23) pwdata_d23 <= pwdata23;

// psl23 assert_rw_div_clk23 : 
// assert always {((paddr23 == `AL_DIV_CLK23) & write_enable23) ; ((paddr23 == `AL_DIV_CLK23) & read_enable23)} |=>
// {prev(pwdata_d23[7:0]) == prdata23[7:0]};



// COVER23 SANITY23 CHECKS23
// sanity23 read
// psl23 output_for_div_clk23 : cover {((paddr23 == `AL_DIV_CLK23) & read_enable23); prdata23[7:0] == 8'h55};


`endif


endmodule 


