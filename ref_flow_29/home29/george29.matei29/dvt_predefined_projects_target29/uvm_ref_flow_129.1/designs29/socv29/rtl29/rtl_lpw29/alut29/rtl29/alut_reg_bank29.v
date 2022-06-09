//File29 name   : alut_reg_bank29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

// compiler29 directives29
`include "alut_defines29.v"


module alut_reg_bank29
(   
   // Inputs29
   pclk29,
   n_p_reset29,
   psel29,            
   penable29,       
   pwrite29,         
   paddr29,           
   pwdata29,          

   curr_time29,
   add_check_active29,
   age_check_active29,
   inval_in_prog29,
   reused29,
   d_port29,
   lst_inv_addr_nrm29,
   lst_inv_port_nrm29,
   lst_inv_addr_cmd29,
   lst_inv_port_cmd29,

   // Outputs29
   mac_addr29,    
   d_addr29,   
   s_addr29,    
   s_port29,    
   best_bfr_age29,
   div_clk29,     
   command, 
   prdata29,  
   clear_reused29           
);


   // APB29 Inputs29
   input                 pclk29;             // APB29 clock29
   input                 n_p_reset29;        // Reset29
   input                 psel29;             // Module29 select29 signal29
   input                 penable29;          // Enable29 signal29 
   input                 pwrite29;           // Write when HIGH29 and read when LOW29
   input [6:0]           paddr29;            // Address bus for read write
   input [31:0]          pwdata29;           // APB29 write bus

   // Inputs29 from other ALUT29 blocks
   input [31:0]          curr_time29;        // current time
   input                 add_check_active29; // used to calculate29 status[0]
   input                 age_check_active29; // used to calculate29 status[0]
   input                 inval_in_prog29;    // status[1]
   input                 reused29;           // status[2]
   input [4:0]           d_port29;           // calculated29 destination29 port for tx29
   input [47:0]          lst_inv_addr_nrm29; // last invalidated29 addr normal29 op
   input [1:0]           lst_inv_port_nrm29; // last invalidated29 port normal29 op
   input [47:0]          lst_inv_addr_cmd29; // last invalidated29 addr via cmd29
   input [1:0]           lst_inv_port_cmd29; // last invalidated29 port via cmd29
   

   output [47:0]         mac_addr29;         // address of the switch29
   output [47:0]         d_addr29;           // address of frame29 to be checked29
   output [47:0]         s_addr29;           // address of frame29 to be stored29
   output [1:0]          s_port29;           // source29 port of current frame29
   output [31:0]         best_bfr_age29;     // best29 before age29
   output [7:0]          div_clk29;          // programmed29 clock29 divider29 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata29;           // APB29 read bus
   output                clear_reused29;     // indicates29 status reg read 

   reg    [31:0]         prdata29;           //APB29 read bus   
   reg    [31:0]         frm_d_addr_l29;     
   reg    [15:0]         frm_d_addr_u29;     
   reg    [31:0]         frm_s_addr_l29;     
   reg    [15:0]         frm_s_addr_u29;     
   reg    [1:0]          s_port29;           
   reg    [31:0]         mac_addr_l29;       
   reg    [15:0]         mac_addr_u29;       
   reg    [31:0]         best_bfr_age29;     
   reg    [7:0]          div_clk29;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l29;   
   reg    [15:0]         lst_inv_addr_u29;   
   reg    [1:0]          lst_inv_port29;     


   // Internal Signal29 Declarations29
   wire                  read_enable29;      //APB29 read enable
   wire                  write_enable29;     //APB29 write enable
   wire   [47:0]         mac_addr29;        
   wire   [47:0]         d_addr29;          
   wire   [47:0]         src_addr29;        
   wire                  clear_reused29;    
   wire                  active;

   // ----------------------------
   // General29 Assignments29
   // ----------------------------

   assign read_enable29    = (psel29 & ~penable29 & ~pwrite29);
   assign write_enable29   = (psel29 & penable29 & pwrite29);

   assign mac_addr29  = {mac_addr_u29, mac_addr_l29}; 
   assign d_addr29 =    {frm_d_addr_u29, frm_d_addr_l29};
   assign s_addr29    = {frm_s_addr_u29, frm_s_addr_l29}; 

   assign clear_reused29 = read_enable29 & (paddr29 == `AL_STATUS29) & ~active;

   assign active = (add_check_active29 | age_check_active29);

// ------------------------------------------------------------------------
//   Read Mux29 Control29 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         prdata29 <= 32'h0000_0000;
      else if (read_enable29)
         begin
         case (paddr29)
            `AL_FRM_D_ADDR_L29   : prdata29 <= frm_d_addr_l29;
            `AL_FRM_D_ADDR_U29   : prdata29 <= {16'd0, frm_d_addr_u29};    
            `AL_FRM_S_ADDR_L29   : prdata29 <= frm_s_addr_l29; 
            `AL_FRM_S_ADDR_U29   : prdata29 <= {16'd0, frm_s_addr_u29}; 
            `AL_S_PORT29         : prdata29 <= {30'd0, s_port29}; 
            `AL_D_PORT29         : prdata29 <= {27'd0, d_port29}; 
            `AL_MAC_ADDR_L29     : prdata29 <= mac_addr_l29;
            `AL_MAC_ADDR_U29     : prdata29 <= {16'd0, mac_addr_u29};   
            `AL_CUR_TIME29       : prdata29 <= curr_time29; 
            `AL_BB_AGE29         : prdata29 <= best_bfr_age29;
            `AL_DIV_CLK29        : prdata29 <= {24'd0, div_clk29}; 
            `AL_STATUS29         : prdata29 <= {29'd0, reused29, inval_in_prog29,
                                           active};
            `AL_LST_INV_ADDR_L29 : prdata29 <= lst_inv_addr_l29; 
            `AL_LST_INV_ADDR_U29 : prdata29 <= {16'd0, lst_inv_addr_u29};
            `AL_LST_INV_PORT29   : prdata29 <= {30'd0, lst_inv_port29};

            default:   prdata29 <= 32'h0000_0000;
         endcase
         end
      else
         prdata29 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB29 writable29 registers
// ------------------------------------------------------------------------
// Lower29 destination29 frame29 address register  
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         frm_d_addr_l29 <= 32'h0000_0000;         
      else if (write_enable29 & (paddr29 == `AL_FRM_D_ADDR_L29))
         frm_d_addr_l29 <= pwdata29;
      else
         frm_d_addr_l29 <= frm_d_addr_l29;
      end   


// Upper29 destination29 frame29 address register  
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         frm_d_addr_u29 <= 16'h0000;         
      else if (write_enable29 & (paddr29 == `AL_FRM_D_ADDR_U29))
         frm_d_addr_u29 <= pwdata29[15:0];
      else
         frm_d_addr_u29 <= frm_d_addr_u29;
      end   


// Lower29 source29 frame29 address register  
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         frm_s_addr_l29 <= 32'h0000_0000;         
      else if (write_enable29 & (paddr29 == `AL_FRM_S_ADDR_L29))
         frm_s_addr_l29 <= pwdata29;
      else
         frm_s_addr_l29 <= frm_s_addr_l29;
      end   


// Upper29 source29 frame29 address register  
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         frm_s_addr_u29 <= 16'h0000;         
      else if (write_enable29 & (paddr29 == `AL_FRM_S_ADDR_U29))
         frm_s_addr_u29 <= pwdata29[15:0];
      else
         frm_s_addr_u29 <= frm_s_addr_u29;
      end   


// Source29 port  
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         s_port29 <= 2'b00;         
      else if (write_enable29 & (paddr29 == `AL_S_PORT29))
         s_port29 <= pwdata29[1:0];
      else
         s_port29 <= s_port29;
      end   


// Lower29 switch29 MAC29 address
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         mac_addr_l29 <= 32'h0000_0000;         
      else if (write_enable29 & (paddr29 == `AL_MAC_ADDR_L29))
         mac_addr_l29 <= pwdata29;
      else
         mac_addr_l29 <= mac_addr_l29;
      end   


// Upper29 switch29 MAC29 address 
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         mac_addr_u29 <= 16'h0000;         
      else if (write_enable29 & (paddr29 == `AL_MAC_ADDR_U29))
         mac_addr_u29 <= pwdata29[15:0];
      else
         mac_addr_u29 <= mac_addr_u29;
      end   


// Best29 before age29 
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         best_bfr_age29 <= 32'hffff_ffff;         
      else if (write_enable29 & (paddr29 == `AL_BB_AGE29))
         best_bfr_age29 <= pwdata29;
      else
         best_bfr_age29 <= best_bfr_age29;
      end   


// clock29 divider29
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         div_clk29 <= 8'h00;         
      else if (write_enable29 & (paddr29 == `AL_DIV_CLK29))
         div_clk29 <= pwdata29[7:0];
      else
         div_clk29 <= div_clk29;
      end   


// command.  Needs to be automatically29 cleared29 on following29 cycle
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable29 & (paddr29 == `AL_COMMAND29))
         command <= pwdata29[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last29 invalidated29 port and address values.  These29 can either29 be updated
//   by normal29 operation29 of address checker overwriting29 existing values or
//   by the age29 checker being commanded29 to invalidate29 out of date29 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk29 or negedge n_p_reset29)
      begin 
      if (~n_p_reset29)
      begin
         lst_inv_addr_l29 <= 32'd0;
         lst_inv_addr_u29 <= 16'd0;
         lst_inv_port29   <= 2'd0;
      end
      else if (reused29)        // reused29 flag29 from address checker
      begin
         lst_inv_addr_l29 <= lst_inv_addr_nrm29[31:0];
         lst_inv_addr_u29 <= lst_inv_addr_nrm29[47:32];
         lst_inv_port29   <= lst_inv_port_nrm29;
      end
//      else if (command == 2'b01)  // invalidate29 aged29 from age29 checker
      else if (inval_in_prog29)  // invalidate29 aged29 from age29 checker
      begin
         lst_inv_addr_l29 <= lst_inv_addr_cmd29[31:0];
         lst_inv_addr_u29 <= lst_inv_addr_cmd29[47:32];
         lst_inv_port29   <= lst_inv_port_cmd29;
      end
      else
      begin
         lst_inv_addr_l29 <= lst_inv_addr_l29;
         lst_inv_addr_u29 <= lst_inv_addr_u29;
         lst_inv_port29   <= lst_inv_port29;
      end
      end
 


`ifdef ABV_ON29

defparam i_apb_monitor29.ABUS_WIDTH29 = 7;

// APB29 ASSERTION29 VIP29
apb_monitor29 i_apb_monitor29(.pclk_i29(pclk29), 
                          .presetn_i29(n_p_reset29),
                          .penable_i29(penable29),
                          .psel_i29(psel29),
                          .paddr_i29(paddr29),
                          .pwrite_i29(pwrite29),
                          .pwdata_i29(pwdata29),
                          .prdata_i29(prdata29)); 

// psl29 default clock29 = (posedge pclk29);

// ASSUMPTIONS29
//// active (set by address checker) and invalidation29 in progress29 should never both be set
//// psl29 assume_never_active_inval_aged29 : assume never (active & inval_in_prog29);


// ASSERTION29 CHECKS29
// never read and write at the same time
// psl29 assert_never_rd_wr29 : assert never (read_enable29 & write_enable29);

// check apb29 writes, pick29 command reqister29 as arbitary29 example29
// psl29 assert_cmd_wr29 : assert always ((paddr29 == `AL_COMMAND29) & write_enable29) -> 
//                                    next(command == prev(pwdata29[1:0])) abort29(~n_p_reset29);


// check rw writes, pick29 clock29 divider29 reqister29 as arbitary29 example29.  It takes29 2 cycles29 to write
// then29 read back data, therefore29 need to store29 original write data for use in assertion29 check
reg [31:0] pwdata_d29;  // 1 cycle delayed29 
always @ (posedge pclk29) pwdata_d29 <= pwdata29;

// psl29 assert_rw_div_clk29 : 
// assert always {((paddr29 == `AL_DIV_CLK29) & write_enable29) ; ((paddr29 == `AL_DIV_CLK29) & read_enable29)} |=>
// {prev(pwdata_d29[7:0]) == prdata29[7:0]};



// COVER29 SANITY29 CHECKS29
// sanity29 read
// psl29 output_for_div_clk29 : cover {((paddr29 == `AL_DIV_CLK29) & read_enable29); prdata29[7:0] == 8'h55};


`endif


endmodule 


