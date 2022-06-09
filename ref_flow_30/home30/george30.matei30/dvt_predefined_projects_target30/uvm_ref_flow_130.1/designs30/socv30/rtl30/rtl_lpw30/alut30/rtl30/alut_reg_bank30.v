//File30 name   : alut_reg_bank30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

// compiler30 directives30
`include "alut_defines30.v"


module alut_reg_bank30
(   
   // Inputs30
   pclk30,
   n_p_reset30,
   psel30,            
   penable30,       
   pwrite30,         
   paddr30,           
   pwdata30,          

   curr_time30,
   add_check_active30,
   age_check_active30,
   inval_in_prog30,
   reused30,
   d_port30,
   lst_inv_addr_nrm30,
   lst_inv_port_nrm30,
   lst_inv_addr_cmd30,
   lst_inv_port_cmd30,

   // Outputs30
   mac_addr30,    
   d_addr30,   
   s_addr30,    
   s_port30,    
   best_bfr_age30,
   div_clk30,     
   command, 
   prdata30,  
   clear_reused30           
);


   // APB30 Inputs30
   input                 pclk30;             // APB30 clock30
   input                 n_p_reset30;        // Reset30
   input                 psel30;             // Module30 select30 signal30
   input                 penable30;          // Enable30 signal30 
   input                 pwrite30;           // Write when HIGH30 and read when LOW30
   input [6:0]           paddr30;            // Address bus for read write
   input [31:0]          pwdata30;           // APB30 write bus

   // Inputs30 from other ALUT30 blocks
   input [31:0]          curr_time30;        // current time
   input                 add_check_active30; // used to calculate30 status[0]
   input                 age_check_active30; // used to calculate30 status[0]
   input                 inval_in_prog30;    // status[1]
   input                 reused30;           // status[2]
   input [4:0]           d_port30;           // calculated30 destination30 port for tx30
   input [47:0]          lst_inv_addr_nrm30; // last invalidated30 addr normal30 op
   input [1:0]           lst_inv_port_nrm30; // last invalidated30 port normal30 op
   input [47:0]          lst_inv_addr_cmd30; // last invalidated30 addr via cmd30
   input [1:0]           lst_inv_port_cmd30; // last invalidated30 port via cmd30
   

   output [47:0]         mac_addr30;         // address of the switch30
   output [47:0]         d_addr30;           // address of frame30 to be checked30
   output [47:0]         s_addr30;           // address of frame30 to be stored30
   output [1:0]          s_port30;           // source30 port of current frame30
   output [31:0]         best_bfr_age30;     // best30 before age30
   output [7:0]          div_clk30;          // programmed30 clock30 divider30 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata30;           // APB30 read bus
   output                clear_reused30;     // indicates30 status reg read 

   reg    [31:0]         prdata30;           //APB30 read bus   
   reg    [31:0]         frm_d_addr_l30;     
   reg    [15:0]         frm_d_addr_u30;     
   reg    [31:0]         frm_s_addr_l30;     
   reg    [15:0]         frm_s_addr_u30;     
   reg    [1:0]          s_port30;           
   reg    [31:0]         mac_addr_l30;       
   reg    [15:0]         mac_addr_u30;       
   reg    [31:0]         best_bfr_age30;     
   reg    [7:0]          div_clk30;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l30;   
   reg    [15:0]         lst_inv_addr_u30;   
   reg    [1:0]          lst_inv_port30;     


   // Internal Signal30 Declarations30
   wire                  read_enable30;      //APB30 read enable
   wire                  write_enable30;     //APB30 write enable
   wire   [47:0]         mac_addr30;        
   wire   [47:0]         d_addr30;          
   wire   [47:0]         src_addr30;        
   wire                  clear_reused30;    
   wire                  active;

   // ----------------------------
   // General30 Assignments30
   // ----------------------------

   assign read_enable30    = (psel30 & ~penable30 & ~pwrite30);
   assign write_enable30   = (psel30 & penable30 & pwrite30);

   assign mac_addr30  = {mac_addr_u30, mac_addr_l30}; 
   assign d_addr30 =    {frm_d_addr_u30, frm_d_addr_l30};
   assign s_addr30    = {frm_s_addr_u30, frm_s_addr_l30}; 

   assign clear_reused30 = read_enable30 & (paddr30 == `AL_STATUS30) & ~active;

   assign active = (add_check_active30 | age_check_active30);

// ------------------------------------------------------------------------
//   Read Mux30 Control30 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         prdata30 <= 32'h0000_0000;
      else if (read_enable30)
         begin
         case (paddr30)
            `AL_FRM_D_ADDR_L30   : prdata30 <= frm_d_addr_l30;
            `AL_FRM_D_ADDR_U30   : prdata30 <= {16'd0, frm_d_addr_u30};    
            `AL_FRM_S_ADDR_L30   : prdata30 <= frm_s_addr_l30; 
            `AL_FRM_S_ADDR_U30   : prdata30 <= {16'd0, frm_s_addr_u30}; 
            `AL_S_PORT30         : prdata30 <= {30'd0, s_port30}; 
            `AL_D_PORT30         : prdata30 <= {27'd0, d_port30}; 
            `AL_MAC_ADDR_L30     : prdata30 <= mac_addr_l30;
            `AL_MAC_ADDR_U30     : prdata30 <= {16'd0, mac_addr_u30};   
            `AL_CUR_TIME30       : prdata30 <= curr_time30; 
            `AL_BB_AGE30         : prdata30 <= best_bfr_age30;
            `AL_DIV_CLK30        : prdata30 <= {24'd0, div_clk30}; 
            `AL_STATUS30         : prdata30 <= {29'd0, reused30, inval_in_prog30,
                                           active};
            `AL_LST_INV_ADDR_L30 : prdata30 <= lst_inv_addr_l30; 
            `AL_LST_INV_ADDR_U30 : prdata30 <= {16'd0, lst_inv_addr_u30};
            `AL_LST_INV_PORT30   : prdata30 <= {30'd0, lst_inv_port30};

            default:   prdata30 <= 32'h0000_0000;
         endcase
         end
      else
         prdata30 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB30 writable30 registers
// ------------------------------------------------------------------------
// Lower30 destination30 frame30 address register  
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         frm_d_addr_l30 <= 32'h0000_0000;         
      else if (write_enable30 & (paddr30 == `AL_FRM_D_ADDR_L30))
         frm_d_addr_l30 <= pwdata30;
      else
         frm_d_addr_l30 <= frm_d_addr_l30;
      end   


// Upper30 destination30 frame30 address register  
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         frm_d_addr_u30 <= 16'h0000;         
      else if (write_enable30 & (paddr30 == `AL_FRM_D_ADDR_U30))
         frm_d_addr_u30 <= pwdata30[15:0];
      else
         frm_d_addr_u30 <= frm_d_addr_u30;
      end   


// Lower30 source30 frame30 address register  
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         frm_s_addr_l30 <= 32'h0000_0000;         
      else if (write_enable30 & (paddr30 == `AL_FRM_S_ADDR_L30))
         frm_s_addr_l30 <= pwdata30;
      else
         frm_s_addr_l30 <= frm_s_addr_l30;
      end   


// Upper30 source30 frame30 address register  
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         frm_s_addr_u30 <= 16'h0000;         
      else if (write_enable30 & (paddr30 == `AL_FRM_S_ADDR_U30))
         frm_s_addr_u30 <= pwdata30[15:0];
      else
         frm_s_addr_u30 <= frm_s_addr_u30;
      end   


// Source30 port  
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         s_port30 <= 2'b00;         
      else if (write_enable30 & (paddr30 == `AL_S_PORT30))
         s_port30 <= pwdata30[1:0];
      else
         s_port30 <= s_port30;
      end   


// Lower30 switch30 MAC30 address
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         mac_addr_l30 <= 32'h0000_0000;         
      else if (write_enable30 & (paddr30 == `AL_MAC_ADDR_L30))
         mac_addr_l30 <= pwdata30;
      else
         mac_addr_l30 <= mac_addr_l30;
      end   


// Upper30 switch30 MAC30 address 
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         mac_addr_u30 <= 16'h0000;         
      else if (write_enable30 & (paddr30 == `AL_MAC_ADDR_U30))
         mac_addr_u30 <= pwdata30[15:0];
      else
         mac_addr_u30 <= mac_addr_u30;
      end   


// Best30 before age30 
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         best_bfr_age30 <= 32'hffff_ffff;         
      else if (write_enable30 & (paddr30 == `AL_BB_AGE30))
         best_bfr_age30 <= pwdata30;
      else
         best_bfr_age30 <= best_bfr_age30;
      end   


// clock30 divider30
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         div_clk30 <= 8'h00;         
      else if (write_enable30 & (paddr30 == `AL_DIV_CLK30))
         div_clk30 <= pwdata30[7:0];
      else
         div_clk30 <= div_clk30;
      end   


// command.  Needs to be automatically30 cleared30 on following30 cycle
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable30 & (paddr30 == `AL_COMMAND30))
         command <= pwdata30[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last30 invalidated30 port and address values.  These30 can either30 be updated
//   by normal30 operation30 of address checker overwriting30 existing values or
//   by the age30 checker being commanded30 to invalidate30 out of date30 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk30 or negedge n_p_reset30)
      begin 
      if (~n_p_reset30)
      begin
         lst_inv_addr_l30 <= 32'd0;
         lst_inv_addr_u30 <= 16'd0;
         lst_inv_port30   <= 2'd0;
      end
      else if (reused30)        // reused30 flag30 from address checker
      begin
         lst_inv_addr_l30 <= lst_inv_addr_nrm30[31:0];
         lst_inv_addr_u30 <= lst_inv_addr_nrm30[47:32];
         lst_inv_port30   <= lst_inv_port_nrm30;
      end
//      else if (command == 2'b01)  // invalidate30 aged30 from age30 checker
      else if (inval_in_prog30)  // invalidate30 aged30 from age30 checker
      begin
         lst_inv_addr_l30 <= lst_inv_addr_cmd30[31:0];
         lst_inv_addr_u30 <= lst_inv_addr_cmd30[47:32];
         lst_inv_port30   <= lst_inv_port_cmd30;
      end
      else
      begin
         lst_inv_addr_l30 <= lst_inv_addr_l30;
         lst_inv_addr_u30 <= lst_inv_addr_u30;
         lst_inv_port30   <= lst_inv_port30;
      end
      end
 


`ifdef ABV_ON30

defparam i_apb_monitor30.ABUS_WIDTH30 = 7;

// APB30 ASSERTION30 VIP30
apb_monitor30 i_apb_monitor30(.pclk_i30(pclk30), 
                          .presetn_i30(n_p_reset30),
                          .penable_i30(penable30),
                          .psel_i30(psel30),
                          .paddr_i30(paddr30),
                          .pwrite_i30(pwrite30),
                          .pwdata_i30(pwdata30),
                          .prdata_i30(prdata30)); 

// psl30 default clock30 = (posedge pclk30);

// ASSUMPTIONS30
//// active (set by address checker) and invalidation30 in progress30 should never both be set
//// psl30 assume_never_active_inval_aged30 : assume never (active & inval_in_prog30);


// ASSERTION30 CHECKS30
// never read and write at the same time
// psl30 assert_never_rd_wr30 : assert never (read_enable30 & write_enable30);

// check apb30 writes, pick30 command reqister30 as arbitary30 example30
// psl30 assert_cmd_wr30 : assert always ((paddr30 == `AL_COMMAND30) & write_enable30) -> 
//                                    next(command == prev(pwdata30[1:0])) abort30(~n_p_reset30);


// check rw writes, pick30 clock30 divider30 reqister30 as arbitary30 example30.  It takes30 2 cycles30 to write
// then30 read back data, therefore30 need to store30 original write data for use in assertion30 check
reg [31:0] pwdata_d30;  // 1 cycle delayed30 
always @ (posedge pclk30) pwdata_d30 <= pwdata30;

// psl30 assert_rw_div_clk30 : 
// assert always {((paddr30 == `AL_DIV_CLK30) & write_enable30) ; ((paddr30 == `AL_DIV_CLK30) & read_enable30)} |=>
// {prev(pwdata_d30[7:0]) == prdata30[7:0]};



// COVER30 SANITY30 CHECKS30
// sanity30 read
// psl30 output_for_div_clk30 : cover {((paddr30 == `AL_DIV_CLK30) & read_enable30); prdata30[7:0] == 8'h55};


`endif


endmodule 


