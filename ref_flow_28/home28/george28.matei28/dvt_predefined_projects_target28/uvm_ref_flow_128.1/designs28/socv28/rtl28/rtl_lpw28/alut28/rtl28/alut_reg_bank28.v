//File28 name   : alut_reg_bank28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

// compiler28 directives28
`include "alut_defines28.v"


module alut_reg_bank28
(   
   // Inputs28
   pclk28,
   n_p_reset28,
   psel28,            
   penable28,       
   pwrite28,         
   paddr28,           
   pwdata28,          

   curr_time28,
   add_check_active28,
   age_check_active28,
   inval_in_prog28,
   reused28,
   d_port28,
   lst_inv_addr_nrm28,
   lst_inv_port_nrm28,
   lst_inv_addr_cmd28,
   lst_inv_port_cmd28,

   // Outputs28
   mac_addr28,    
   d_addr28,   
   s_addr28,    
   s_port28,    
   best_bfr_age28,
   div_clk28,     
   command, 
   prdata28,  
   clear_reused28           
);


   // APB28 Inputs28
   input                 pclk28;             // APB28 clock28
   input                 n_p_reset28;        // Reset28
   input                 psel28;             // Module28 select28 signal28
   input                 penable28;          // Enable28 signal28 
   input                 pwrite28;           // Write when HIGH28 and read when LOW28
   input [6:0]           paddr28;            // Address bus for read write
   input [31:0]          pwdata28;           // APB28 write bus

   // Inputs28 from other ALUT28 blocks
   input [31:0]          curr_time28;        // current time
   input                 add_check_active28; // used to calculate28 status[0]
   input                 age_check_active28; // used to calculate28 status[0]
   input                 inval_in_prog28;    // status[1]
   input                 reused28;           // status[2]
   input [4:0]           d_port28;           // calculated28 destination28 port for tx28
   input [47:0]          lst_inv_addr_nrm28; // last invalidated28 addr normal28 op
   input [1:0]           lst_inv_port_nrm28; // last invalidated28 port normal28 op
   input [47:0]          lst_inv_addr_cmd28; // last invalidated28 addr via cmd28
   input [1:0]           lst_inv_port_cmd28; // last invalidated28 port via cmd28
   

   output [47:0]         mac_addr28;         // address of the switch28
   output [47:0]         d_addr28;           // address of frame28 to be checked28
   output [47:0]         s_addr28;           // address of frame28 to be stored28
   output [1:0]          s_port28;           // source28 port of current frame28
   output [31:0]         best_bfr_age28;     // best28 before age28
   output [7:0]          div_clk28;          // programmed28 clock28 divider28 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata28;           // APB28 read bus
   output                clear_reused28;     // indicates28 status reg read 

   reg    [31:0]         prdata28;           //APB28 read bus   
   reg    [31:0]         frm_d_addr_l28;     
   reg    [15:0]         frm_d_addr_u28;     
   reg    [31:0]         frm_s_addr_l28;     
   reg    [15:0]         frm_s_addr_u28;     
   reg    [1:0]          s_port28;           
   reg    [31:0]         mac_addr_l28;       
   reg    [15:0]         mac_addr_u28;       
   reg    [31:0]         best_bfr_age28;     
   reg    [7:0]          div_clk28;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l28;   
   reg    [15:0]         lst_inv_addr_u28;   
   reg    [1:0]          lst_inv_port28;     


   // Internal Signal28 Declarations28
   wire                  read_enable28;      //APB28 read enable
   wire                  write_enable28;     //APB28 write enable
   wire   [47:0]         mac_addr28;        
   wire   [47:0]         d_addr28;          
   wire   [47:0]         src_addr28;        
   wire                  clear_reused28;    
   wire                  active;

   // ----------------------------
   // General28 Assignments28
   // ----------------------------

   assign read_enable28    = (psel28 & ~penable28 & ~pwrite28);
   assign write_enable28   = (psel28 & penable28 & pwrite28);

   assign mac_addr28  = {mac_addr_u28, mac_addr_l28}; 
   assign d_addr28 =    {frm_d_addr_u28, frm_d_addr_l28};
   assign s_addr28    = {frm_s_addr_u28, frm_s_addr_l28}; 

   assign clear_reused28 = read_enable28 & (paddr28 == `AL_STATUS28) & ~active;

   assign active = (add_check_active28 | age_check_active28);

// ------------------------------------------------------------------------
//   Read Mux28 Control28 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         prdata28 <= 32'h0000_0000;
      else if (read_enable28)
         begin
         case (paddr28)
            `AL_FRM_D_ADDR_L28   : prdata28 <= frm_d_addr_l28;
            `AL_FRM_D_ADDR_U28   : prdata28 <= {16'd0, frm_d_addr_u28};    
            `AL_FRM_S_ADDR_L28   : prdata28 <= frm_s_addr_l28; 
            `AL_FRM_S_ADDR_U28   : prdata28 <= {16'd0, frm_s_addr_u28}; 
            `AL_S_PORT28         : prdata28 <= {30'd0, s_port28}; 
            `AL_D_PORT28         : prdata28 <= {27'd0, d_port28}; 
            `AL_MAC_ADDR_L28     : prdata28 <= mac_addr_l28;
            `AL_MAC_ADDR_U28     : prdata28 <= {16'd0, mac_addr_u28};   
            `AL_CUR_TIME28       : prdata28 <= curr_time28; 
            `AL_BB_AGE28         : prdata28 <= best_bfr_age28;
            `AL_DIV_CLK28        : prdata28 <= {24'd0, div_clk28}; 
            `AL_STATUS28         : prdata28 <= {29'd0, reused28, inval_in_prog28,
                                           active};
            `AL_LST_INV_ADDR_L28 : prdata28 <= lst_inv_addr_l28; 
            `AL_LST_INV_ADDR_U28 : prdata28 <= {16'd0, lst_inv_addr_u28};
            `AL_LST_INV_PORT28   : prdata28 <= {30'd0, lst_inv_port28};

            default:   prdata28 <= 32'h0000_0000;
         endcase
         end
      else
         prdata28 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB28 writable28 registers
// ------------------------------------------------------------------------
// Lower28 destination28 frame28 address register  
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         frm_d_addr_l28 <= 32'h0000_0000;         
      else if (write_enable28 & (paddr28 == `AL_FRM_D_ADDR_L28))
         frm_d_addr_l28 <= pwdata28;
      else
         frm_d_addr_l28 <= frm_d_addr_l28;
      end   


// Upper28 destination28 frame28 address register  
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         frm_d_addr_u28 <= 16'h0000;         
      else if (write_enable28 & (paddr28 == `AL_FRM_D_ADDR_U28))
         frm_d_addr_u28 <= pwdata28[15:0];
      else
         frm_d_addr_u28 <= frm_d_addr_u28;
      end   


// Lower28 source28 frame28 address register  
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         frm_s_addr_l28 <= 32'h0000_0000;         
      else if (write_enable28 & (paddr28 == `AL_FRM_S_ADDR_L28))
         frm_s_addr_l28 <= pwdata28;
      else
         frm_s_addr_l28 <= frm_s_addr_l28;
      end   


// Upper28 source28 frame28 address register  
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         frm_s_addr_u28 <= 16'h0000;         
      else if (write_enable28 & (paddr28 == `AL_FRM_S_ADDR_U28))
         frm_s_addr_u28 <= pwdata28[15:0];
      else
         frm_s_addr_u28 <= frm_s_addr_u28;
      end   


// Source28 port  
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         s_port28 <= 2'b00;         
      else if (write_enable28 & (paddr28 == `AL_S_PORT28))
         s_port28 <= pwdata28[1:0];
      else
         s_port28 <= s_port28;
      end   


// Lower28 switch28 MAC28 address
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         mac_addr_l28 <= 32'h0000_0000;         
      else if (write_enable28 & (paddr28 == `AL_MAC_ADDR_L28))
         mac_addr_l28 <= pwdata28;
      else
         mac_addr_l28 <= mac_addr_l28;
      end   


// Upper28 switch28 MAC28 address 
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         mac_addr_u28 <= 16'h0000;         
      else if (write_enable28 & (paddr28 == `AL_MAC_ADDR_U28))
         mac_addr_u28 <= pwdata28[15:0];
      else
         mac_addr_u28 <= mac_addr_u28;
      end   


// Best28 before age28 
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         best_bfr_age28 <= 32'hffff_ffff;         
      else if (write_enable28 & (paddr28 == `AL_BB_AGE28))
         best_bfr_age28 <= pwdata28;
      else
         best_bfr_age28 <= best_bfr_age28;
      end   


// clock28 divider28
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         div_clk28 <= 8'h00;         
      else if (write_enable28 & (paddr28 == `AL_DIV_CLK28))
         div_clk28 <= pwdata28[7:0];
      else
         div_clk28 <= div_clk28;
      end   


// command.  Needs to be automatically28 cleared28 on following28 cycle
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable28 & (paddr28 == `AL_COMMAND28))
         command <= pwdata28[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last28 invalidated28 port and address values.  These28 can either28 be updated
//   by normal28 operation28 of address checker overwriting28 existing values or
//   by the age28 checker being commanded28 to invalidate28 out of date28 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk28 or negedge n_p_reset28)
      begin 
      if (~n_p_reset28)
      begin
         lst_inv_addr_l28 <= 32'd0;
         lst_inv_addr_u28 <= 16'd0;
         lst_inv_port28   <= 2'd0;
      end
      else if (reused28)        // reused28 flag28 from address checker
      begin
         lst_inv_addr_l28 <= lst_inv_addr_nrm28[31:0];
         lst_inv_addr_u28 <= lst_inv_addr_nrm28[47:32];
         lst_inv_port28   <= lst_inv_port_nrm28;
      end
//      else if (command == 2'b01)  // invalidate28 aged28 from age28 checker
      else if (inval_in_prog28)  // invalidate28 aged28 from age28 checker
      begin
         lst_inv_addr_l28 <= lst_inv_addr_cmd28[31:0];
         lst_inv_addr_u28 <= lst_inv_addr_cmd28[47:32];
         lst_inv_port28   <= lst_inv_port_cmd28;
      end
      else
      begin
         lst_inv_addr_l28 <= lst_inv_addr_l28;
         lst_inv_addr_u28 <= lst_inv_addr_u28;
         lst_inv_port28   <= lst_inv_port28;
      end
      end
 


`ifdef ABV_ON28

defparam i_apb_monitor28.ABUS_WIDTH28 = 7;

// APB28 ASSERTION28 VIP28
apb_monitor28 i_apb_monitor28(.pclk_i28(pclk28), 
                          .presetn_i28(n_p_reset28),
                          .penable_i28(penable28),
                          .psel_i28(psel28),
                          .paddr_i28(paddr28),
                          .pwrite_i28(pwrite28),
                          .pwdata_i28(pwdata28),
                          .prdata_i28(prdata28)); 

// psl28 default clock28 = (posedge pclk28);

// ASSUMPTIONS28
//// active (set by address checker) and invalidation28 in progress28 should never both be set
//// psl28 assume_never_active_inval_aged28 : assume never (active & inval_in_prog28);


// ASSERTION28 CHECKS28
// never read and write at the same time
// psl28 assert_never_rd_wr28 : assert never (read_enable28 & write_enable28);

// check apb28 writes, pick28 command reqister28 as arbitary28 example28
// psl28 assert_cmd_wr28 : assert always ((paddr28 == `AL_COMMAND28) & write_enable28) -> 
//                                    next(command == prev(pwdata28[1:0])) abort28(~n_p_reset28);


// check rw writes, pick28 clock28 divider28 reqister28 as arbitary28 example28.  It takes28 2 cycles28 to write
// then28 read back data, therefore28 need to store28 original write data for use in assertion28 check
reg [31:0] pwdata_d28;  // 1 cycle delayed28 
always @ (posedge pclk28) pwdata_d28 <= pwdata28;

// psl28 assert_rw_div_clk28 : 
// assert always {((paddr28 == `AL_DIV_CLK28) & write_enable28) ; ((paddr28 == `AL_DIV_CLK28) & read_enable28)} |=>
// {prev(pwdata_d28[7:0]) == prdata28[7:0]};



// COVER28 SANITY28 CHECKS28
// sanity28 read
// psl28 output_for_div_clk28 : cover {((paddr28 == `AL_DIV_CLK28) & read_enable28); prdata28[7:0] == 8'h55};


`endif


endmodule 


