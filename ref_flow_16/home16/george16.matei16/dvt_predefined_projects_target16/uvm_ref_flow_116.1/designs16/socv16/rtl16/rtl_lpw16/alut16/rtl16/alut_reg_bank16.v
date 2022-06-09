//File16 name   : alut_reg_bank16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

// compiler16 directives16
`include "alut_defines16.v"


module alut_reg_bank16
(   
   // Inputs16
   pclk16,
   n_p_reset16,
   psel16,            
   penable16,       
   pwrite16,         
   paddr16,           
   pwdata16,          

   curr_time16,
   add_check_active16,
   age_check_active16,
   inval_in_prog16,
   reused16,
   d_port16,
   lst_inv_addr_nrm16,
   lst_inv_port_nrm16,
   lst_inv_addr_cmd16,
   lst_inv_port_cmd16,

   // Outputs16
   mac_addr16,    
   d_addr16,   
   s_addr16,    
   s_port16,    
   best_bfr_age16,
   div_clk16,     
   command, 
   prdata16,  
   clear_reused16           
);


   // APB16 Inputs16
   input                 pclk16;             // APB16 clock16
   input                 n_p_reset16;        // Reset16
   input                 psel16;             // Module16 select16 signal16
   input                 penable16;          // Enable16 signal16 
   input                 pwrite16;           // Write when HIGH16 and read when LOW16
   input [6:0]           paddr16;            // Address bus for read write
   input [31:0]          pwdata16;           // APB16 write bus

   // Inputs16 from other ALUT16 blocks
   input [31:0]          curr_time16;        // current time
   input                 add_check_active16; // used to calculate16 status[0]
   input                 age_check_active16; // used to calculate16 status[0]
   input                 inval_in_prog16;    // status[1]
   input                 reused16;           // status[2]
   input [4:0]           d_port16;           // calculated16 destination16 port for tx16
   input [47:0]          lst_inv_addr_nrm16; // last invalidated16 addr normal16 op
   input [1:0]           lst_inv_port_nrm16; // last invalidated16 port normal16 op
   input [47:0]          lst_inv_addr_cmd16; // last invalidated16 addr via cmd16
   input [1:0]           lst_inv_port_cmd16; // last invalidated16 port via cmd16
   

   output [47:0]         mac_addr16;         // address of the switch16
   output [47:0]         d_addr16;           // address of frame16 to be checked16
   output [47:0]         s_addr16;           // address of frame16 to be stored16
   output [1:0]          s_port16;           // source16 port of current frame16
   output [31:0]         best_bfr_age16;     // best16 before age16
   output [7:0]          div_clk16;          // programmed16 clock16 divider16 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata16;           // APB16 read bus
   output                clear_reused16;     // indicates16 status reg read 

   reg    [31:0]         prdata16;           //APB16 read bus   
   reg    [31:0]         frm_d_addr_l16;     
   reg    [15:0]         frm_d_addr_u16;     
   reg    [31:0]         frm_s_addr_l16;     
   reg    [15:0]         frm_s_addr_u16;     
   reg    [1:0]          s_port16;           
   reg    [31:0]         mac_addr_l16;       
   reg    [15:0]         mac_addr_u16;       
   reg    [31:0]         best_bfr_age16;     
   reg    [7:0]          div_clk16;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l16;   
   reg    [15:0]         lst_inv_addr_u16;   
   reg    [1:0]          lst_inv_port16;     


   // Internal Signal16 Declarations16
   wire                  read_enable16;      //APB16 read enable
   wire                  write_enable16;     //APB16 write enable
   wire   [47:0]         mac_addr16;        
   wire   [47:0]         d_addr16;          
   wire   [47:0]         src_addr16;        
   wire                  clear_reused16;    
   wire                  active;

   // ----------------------------
   // General16 Assignments16
   // ----------------------------

   assign read_enable16    = (psel16 & ~penable16 & ~pwrite16);
   assign write_enable16   = (psel16 & penable16 & pwrite16);

   assign mac_addr16  = {mac_addr_u16, mac_addr_l16}; 
   assign d_addr16 =    {frm_d_addr_u16, frm_d_addr_l16};
   assign s_addr16    = {frm_s_addr_u16, frm_s_addr_l16}; 

   assign clear_reused16 = read_enable16 & (paddr16 == `AL_STATUS16) & ~active;

   assign active = (add_check_active16 | age_check_active16);

// ------------------------------------------------------------------------
//   Read Mux16 Control16 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         prdata16 <= 32'h0000_0000;
      else if (read_enable16)
         begin
         case (paddr16)
            `AL_FRM_D_ADDR_L16   : prdata16 <= frm_d_addr_l16;
            `AL_FRM_D_ADDR_U16   : prdata16 <= {16'd0, frm_d_addr_u16};    
            `AL_FRM_S_ADDR_L16   : prdata16 <= frm_s_addr_l16; 
            `AL_FRM_S_ADDR_U16   : prdata16 <= {16'd0, frm_s_addr_u16}; 
            `AL_S_PORT16         : prdata16 <= {30'd0, s_port16}; 
            `AL_D_PORT16         : prdata16 <= {27'd0, d_port16}; 
            `AL_MAC_ADDR_L16     : prdata16 <= mac_addr_l16;
            `AL_MAC_ADDR_U16     : prdata16 <= {16'd0, mac_addr_u16};   
            `AL_CUR_TIME16       : prdata16 <= curr_time16; 
            `AL_BB_AGE16         : prdata16 <= best_bfr_age16;
            `AL_DIV_CLK16        : prdata16 <= {24'd0, div_clk16}; 
            `AL_STATUS16         : prdata16 <= {29'd0, reused16, inval_in_prog16,
                                           active};
            `AL_LST_INV_ADDR_L16 : prdata16 <= lst_inv_addr_l16; 
            `AL_LST_INV_ADDR_U16 : prdata16 <= {16'd0, lst_inv_addr_u16};
            `AL_LST_INV_PORT16   : prdata16 <= {30'd0, lst_inv_port16};

            default:   prdata16 <= 32'h0000_0000;
         endcase
         end
      else
         prdata16 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB16 writable16 registers
// ------------------------------------------------------------------------
// Lower16 destination16 frame16 address register  
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         frm_d_addr_l16 <= 32'h0000_0000;         
      else if (write_enable16 & (paddr16 == `AL_FRM_D_ADDR_L16))
         frm_d_addr_l16 <= pwdata16;
      else
         frm_d_addr_l16 <= frm_d_addr_l16;
      end   


// Upper16 destination16 frame16 address register  
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         frm_d_addr_u16 <= 16'h0000;         
      else if (write_enable16 & (paddr16 == `AL_FRM_D_ADDR_U16))
         frm_d_addr_u16 <= pwdata16[15:0];
      else
         frm_d_addr_u16 <= frm_d_addr_u16;
      end   


// Lower16 source16 frame16 address register  
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         frm_s_addr_l16 <= 32'h0000_0000;         
      else if (write_enable16 & (paddr16 == `AL_FRM_S_ADDR_L16))
         frm_s_addr_l16 <= pwdata16;
      else
         frm_s_addr_l16 <= frm_s_addr_l16;
      end   


// Upper16 source16 frame16 address register  
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         frm_s_addr_u16 <= 16'h0000;         
      else if (write_enable16 & (paddr16 == `AL_FRM_S_ADDR_U16))
         frm_s_addr_u16 <= pwdata16[15:0];
      else
         frm_s_addr_u16 <= frm_s_addr_u16;
      end   


// Source16 port  
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         s_port16 <= 2'b00;         
      else if (write_enable16 & (paddr16 == `AL_S_PORT16))
         s_port16 <= pwdata16[1:0];
      else
         s_port16 <= s_port16;
      end   


// Lower16 switch16 MAC16 address
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         mac_addr_l16 <= 32'h0000_0000;         
      else if (write_enable16 & (paddr16 == `AL_MAC_ADDR_L16))
         mac_addr_l16 <= pwdata16;
      else
         mac_addr_l16 <= mac_addr_l16;
      end   


// Upper16 switch16 MAC16 address 
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         mac_addr_u16 <= 16'h0000;         
      else if (write_enable16 & (paddr16 == `AL_MAC_ADDR_U16))
         mac_addr_u16 <= pwdata16[15:0];
      else
         mac_addr_u16 <= mac_addr_u16;
      end   


// Best16 before age16 
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         best_bfr_age16 <= 32'hffff_ffff;         
      else if (write_enable16 & (paddr16 == `AL_BB_AGE16))
         best_bfr_age16 <= pwdata16;
      else
         best_bfr_age16 <= best_bfr_age16;
      end   


// clock16 divider16
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         div_clk16 <= 8'h00;         
      else if (write_enable16 & (paddr16 == `AL_DIV_CLK16))
         div_clk16 <= pwdata16[7:0];
      else
         div_clk16 <= div_clk16;
      end   


// command.  Needs to be automatically16 cleared16 on following16 cycle
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable16 & (paddr16 == `AL_COMMAND16))
         command <= pwdata16[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last16 invalidated16 port and address values.  These16 can either16 be updated
//   by normal16 operation16 of address checker overwriting16 existing values or
//   by the age16 checker being commanded16 to invalidate16 out of date16 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk16 or negedge n_p_reset16)
      begin 
      if (~n_p_reset16)
      begin
         lst_inv_addr_l16 <= 32'd0;
         lst_inv_addr_u16 <= 16'd0;
         lst_inv_port16   <= 2'd0;
      end
      else if (reused16)        // reused16 flag16 from address checker
      begin
         lst_inv_addr_l16 <= lst_inv_addr_nrm16[31:0];
         lst_inv_addr_u16 <= lst_inv_addr_nrm16[47:32];
         lst_inv_port16   <= lst_inv_port_nrm16;
      end
//      else if (command == 2'b01)  // invalidate16 aged16 from age16 checker
      else if (inval_in_prog16)  // invalidate16 aged16 from age16 checker
      begin
         lst_inv_addr_l16 <= lst_inv_addr_cmd16[31:0];
         lst_inv_addr_u16 <= lst_inv_addr_cmd16[47:32];
         lst_inv_port16   <= lst_inv_port_cmd16;
      end
      else
      begin
         lst_inv_addr_l16 <= lst_inv_addr_l16;
         lst_inv_addr_u16 <= lst_inv_addr_u16;
         lst_inv_port16   <= lst_inv_port16;
      end
      end
 


`ifdef ABV_ON16

defparam i_apb_monitor16.ABUS_WIDTH16 = 7;

// APB16 ASSERTION16 VIP16
apb_monitor16 i_apb_monitor16(.pclk_i16(pclk16), 
                          .presetn_i16(n_p_reset16),
                          .penable_i16(penable16),
                          .psel_i16(psel16),
                          .paddr_i16(paddr16),
                          .pwrite_i16(pwrite16),
                          .pwdata_i16(pwdata16),
                          .prdata_i16(prdata16)); 

// psl16 default clock16 = (posedge pclk16);

// ASSUMPTIONS16
//// active (set by address checker) and invalidation16 in progress16 should never both be set
//// psl16 assume_never_active_inval_aged16 : assume never (active & inval_in_prog16);


// ASSERTION16 CHECKS16
// never read and write at the same time
// psl16 assert_never_rd_wr16 : assert never (read_enable16 & write_enable16);

// check apb16 writes, pick16 command reqister16 as arbitary16 example16
// psl16 assert_cmd_wr16 : assert always ((paddr16 == `AL_COMMAND16) & write_enable16) -> 
//                                    next(command == prev(pwdata16[1:0])) abort16(~n_p_reset16);


// check rw writes, pick16 clock16 divider16 reqister16 as arbitary16 example16.  It takes16 2 cycles16 to write
// then16 read back data, therefore16 need to store16 original write data for use in assertion16 check
reg [31:0] pwdata_d16;  // 1 cycle delayed16 
always @ (posedge pclk16) pwdata_d16 <= pwdata16;

// psl16 assert_rw_div_clk16 : 
// assert always {((paddr16 == `AL_DIV_CLK16) & write_enable16) ; ((paddr16 == `AL_DIV_CLK16) & read_enable16)} |=>
// {prev(pwdata_d16[7:0]) == prdata16[7:0]};



// COVER16 SANITY16 CHECKS16
// sanity16 read
// psl16 output_for_div_clk16 : cover {((paddr16 == `AL_DIV_CLK16) & read_enable16); prdata16[7:0] == 8'h55};


`endif


endmodule 


