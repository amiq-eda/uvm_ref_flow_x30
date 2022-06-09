//File9 name   : alut_reg_bank9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

// compiler9 directives9
`include "alut_defines9.v"


module alut_reg_bank9
(   
   // Inputs9
   pclk9,
   n_p_reset9,
   psel9,            
   penable9,       
   pwrite9,         
   paddr9,           
   pwdata9,          

   curr_time9,
   add_check_active9,
   age_check_active9,
   inval_in_prog9,
   reused9,
   d_port9,
   lst_inv_addr_nrm9,
   lst_inv_port_nrm9,
   lst_inv_addr_cmd9,
   lst_inv_port_cmd9,

   // Outputs9
   mac_addr9,    
   d_addr9,   
   s_addr9,    
   s_port9,    
   best_bfr_age9,
   div_clk9,     
   command, 
   prdata9,  
   clear_reused9           
);


   // APB9 Inputs9
   input                 pclk9;             // APB9 clock9
   input                 n_p_reset9;        // Reset9
   input                 psel9;             // Module9 select9 signal9
   input                 penable9;          // Enable9 signal9 
   input                 pwrite9;           // Write when HIGH9 and read when LOW9
   input [6:0]           paddr9;            // Address bus for read write
   input [31:0]          pwdata9;           // APB9 write bus

   // Inputs9 from other ALUT9 blocks
   input [31:0]          curr_time9;        // current time
   input                 add_check_active9; // used to calculate9 status[0]
   input                 age_check_active9; // used to calculate9 status[0]
   input                 inval_in_prog9;    // status[1]
   input                 reused9;           // status[2]
   input [4:0]           d_port9;           // calculated9 destination9 port for tx9
   input [47:0]          lst_inv_addr_nrm9; // last invalidated9 addr normal9 op
   input [1:0]           lst_inv_port_nrm9; // last invalidated9 port normal9 op
   input [47:0]          lst_inv_addr_cmd9; // last invalidated9 addr via cmd9
   input [1:0]           lst_inv_port_cmd9; // last invalidated9 port via cmd9
   

   output [47:0]         mac_addr9;         // address of the switch9
   output [47:0]         d_addr9;           // address of frame9 to be checked9
   output [47:0]         s_addr9;           // address of frame9 to be stored9
   output [1:0]          s_port9;           // source9 port of current frame9
   output [31:0]         best_bfr_age9;     // best9 before age9
   output [7:0]          div_clk9;          // programmed9 clock9 divider9 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata9;           // APB9 read bus
   output                clear_reused9;     // indicates9 status reg read 

   reg    [31:0]         prdata9;           //APB9 read bus   
   reg    [31:0]         frm_d_addr_l9;     
   reg    [15:0]         frm_d_addr_u9;     
   reg    [31:0]         frm_s_addr_l9;     
   reg    [15:0]         frm_s_addr_u9;     
   reg    [1:0]          s_port9;           
   reg    [31:0]         mac_addr_l9;       
   reg    [15:0]         mac_addr_u9;       
   reg    [31:0]         best_bfr_age9;     
   reg    [7:0]          div_clk9;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l9;   
   reg    [15:0]         lst_inv_addr_u9;   
   reg    [1:0]          lst_inv_port9;     


   // Internal Signal9 Declarations9
   wire                  read_enable9;      //APB9 read enable
   wire                  write_enable9;     //APB9 write enable
   wire   [47:0]         mac_addr9;        
   wire   [47:0]         d_addr9;          
   wire   [47:0]         src_addr9;        
   wire                  clear_reused9;    
   wire                  active;

   // ----------------------------
   // General9 Assignments9
   // ----------------------------

   assign read_enable9    = (psel9 & ~penable9 & ~pwrite9);
   assign write_enable9   = (psel9 & penable9 & pwrite9);

   assign mac_addr9  = {mac_addr_u9, mac_addr_l9}; 
   assign d_addr9 =    {frm_d_addr_u9, frm_d_addr_l9};
   assign s_addr9    = {frm_s_addr_u9, frm_s_addr_l9}; 

   assign clear_reused9 = read_enable9 & (paddr9 == `AL_STATUS9) & ~active;

   assign active = (add_check_active9 | age_check_active9);

// ------------------------------------------------------------------------
//   Read Mux9 Control9 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         prdata9 <= 32'h0000_0000;
      else if (read_enable9)
         begin
         case (paddr9)
            `AL_FRM_D_ADDR_L9   : prdata9 <= frm_d_addr_l9;
            `AL_FRM_D_ADDR_U9   : prdata9 <= {16'd0, frm_d_addr_u9};    
            `AL_FRM_S_ADDR_L9   : prdata9 <= frm_s_addr_l9; 
            `AL_FRM_S_ADDR_U9   : prdata9 <= {16'd0, frm_s_addr_u9}; 
            `AL_S_PORT9         : prdata9 <= {30'd0, s_port9}; 
            `AL_D_PORT9         : prdata9 <= {27'd0, d_port9}; 
            `AL_MAC_ADDR_L9     : prdata9 <= mac_addr_l9;
            `AL_MAC_ADDR_U9     : prdata9 <= {16'd0, mac_addr_u9};   
            `AL_CUR_TIME9       : prdata9 <= curr_time9; 
            `AL_BB_AGE9         : prdata9 <= best_bfr_age9;
            `AL_DIV_CLK9        : prdata9 <= {24'd0, div_clk9}; 
            `AL_STATUS9         : prdata9 <= {29'd0, reused9, inval_in_prog9,
                                           active};
            `AL_LST_INV_ADDR_L9 : prdata9 <= lst_inv_addr_l9; 
            `AL_LST_INV_ADDR_U9 : prdata9 <= {16'd0, lst_inv_addr_u9};
            `AL_LST_INV_PORT9   : prdata9 <= {30'd0, lst_inv_port9};

            default:   prdata9 <= 32'h0000_0000;
         endcase
         end
      else
         prdata9 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB9 writable9 registers
// ------------------------------------------------------------------------
// Lower9 destination9 frame9 address register  
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         frm_d_addr_l9 <= 32'h0000_0000;         
      else if (write_enable9 & (paddr9 == `AL_FRM_D_ADDR_L9))
         frm_d_addr_l9 <= pwdata9;
      else
         frm_d_addr_l9 <= frm_d_addr_l9;
      end   


// Upper9 destination9 frame9 address register  
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         frm_d_addr_u9 <= 16'h0000;         
      else if (write_enable9 & (paddr9 == `AL_FRM_D_ADDR_U9))
         frm_d_addr_u9 <= pwdata9[15:0];
      else
         frm_d_addr_u9 <= frm_d_addr_u9;
      end   


// Lower9 source9 frame9 address register  
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         frm_s_addr_l9 <= 32'h0000_0000;         
      else if (write_enable9 & (paddr9 == `AL_FRM_S_ADDR_L9))
         frm_s_addr_l9 <= pwdata9;
      else
         frm_s_addr_l9 <= frm_s_addr_l9;
      end   


// Upper9 source9 frame9 address register  
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         frm_s_addr_u9 <= 16'h0000;         
      else if (write_enable9 & (paddr9 == `AL_FRM_S_ADDR_U9))
         frm_s_addr_u9 <= pwdata9[15:0];
      else
         frm_s_addr_u9 <= frm_s_addr_u9;
      end   


// Source9 port  
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         s_port9 <= 2'b00;         
      else if (write_enable9 & (paddr9 == `AL_S_PORT9))
         s_port9 <= pwdata9[1:0];
      else
         s_port9 <= s_port9;
      end   


// Lower9 switch9 MAC9 address
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         mac_addr_l9 <= 32'h0000_0000;         
      else if (write_enable9 & (paddr9 == `AL_MAC_ADDR_L9))
         mac_addr_l9 <= pwdata9;
      else
         mac_addr_l9 <= mac_addr_l9;
      end   


// Upper9 switch9 MAC9 address 
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         mac_addr_u9 <= 16'h0000;         
      else if (write_enable9 & (paddr9 == `AL_MAC_ADDR_U9))
         mac_addr_u9 <= pwdata9[15:0];
      else
         mac_addr_u9 <= mac_addr_u9;
      end   


// Best9 before age9 
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         best_bfr_age9 <= 32'hffff_ffff;         
      else if (write_enable9 & (paddr9 == `AL_BB_AGE9))
         best_bfr_age9 <= pwdata9;
      else
         best_bfr_age9 <= best_bfr_age9;
      end   


// clock9 divider9
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         div_clk9 <= 8'h00;         
      else if (write_enable9 & (paddr9 == `AL_DIV_CLK9))
         div_clk9 <= pwdata9[7:0];
      else
         div_clk9 <= div_clk9;
      end   


// command.  Needs to be automatically9 cleared9 on following9 cycle
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable9 & (paddr9 == `AL_COMMAND9))
         command <= pwdata9[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last9 invalidated9 port and address values.  These9 can either9 be updated
//   by normal9 operation9 of address checker overwriting9 existing values or
//   by the age9 checker being commanded9 to invalidate9 out of date9 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk9 or negedge n_p_reset9)
      begin 
      if (~n_p_reset9)
      begin
         lst_inv_addr_l9 <= 32'd0;
         lst_inv_addr_u9 <= 16'd0;
         lst_inv_port9   <= 2'd0;
      end
      else if (reused9)        // reused9 flag9 from address checker
      begin
         lst_inv_addr_l9 <= lst_inv_addr_nrm9[31:0];
         lst_inv_addr_u9 <= lst_inv_addr_nrm9[47:32];
         lst_inv_port9   <= lst_inv_port_nrm9;
      end
//      else if (command == 2'b01)  // invalidate9 aged9 from age9 checker
      else if (inval_in_prog9)  // invalidate9 aged9 from age9 checker
      begin
         lst_inv_addr_l9 <= lst_inv_addr_cmd9[31:0];
         lst_inv_addr_u9 <= lst_inv_addr_cmd9[47:32];
         lst_inv_port9   <= lst_inv_port_cmd9;
      end
      else
      begin
         lst_inv_addr_l9 <= lst_inv_addr_l9;
         lst_inv_addr_u9 <= lst_inv_addr_u9;
         lst_inv_port9   <= lst_inv_port9;
      end
      end
 


`ifdef ABV_ON9

defparam i_apb_monitor9.ABUS_WIDTH9 = 7;

// APB9 ASSERTION9 VIP9
apb_monitor9 i_apb_monitor9(.pclk_i9(pclk9), 
                          .presetn_i9(n_p_reset9),
                          .penable_i9(penable9),
                          .psel_i9(psel9),
                          .paddr_i9(paddr9),
                          .pwrite_i9(pwrite9),
                          .pwdata_i9(pwdata9),
                          .prdata_i9(prdata9)); 

// psl9 default clock9 = (posedge pclk9);

// ASSUMPTIONS9
//// active (set by address checker) and invalidation9 in progress9 should never both be set
//// psl9 assume_never_active_inval_aged9 : assume never (active & inval_in_prog9);


// ASSERTION9 CHECKS9
// never read and write at the same time
// psl9 assert_never_rd_wr9 : assert never (read_enable9 & write_enable9);

// check apb9 writes, pick9 command reqister9 as arbitary9 example9
// psl9 assert_cmd_wr9 : assert always ((paddr9 == `AL_COMMAND9) & write_enable9) -> 
//                                    next(command == prev(pwdata9[1:0])) abort9(~n_p_reset9);


// check rw writes, pick9 clock9 divider9 reqister9 as arbitary9 example9.  It takes9 2 cycles9 to write
// then9 read back data, therefore9 need to store9 original write data for use in assertion9 check
reg [31:0] pwdata_d9;  // 1 cycle delayed9 
always @ (posedge pclk9) pwdata_d9 <= pwdata9;

// psl9 assert_rw_div_clk9 : 
// assert always {((paddr9 == `AL_DIV_CLK9) & write_enable9) ; ((paddr9 == `AL_DIV_CLK9) & read_enable9)} |=>
// {prev(pwdata_d9[7:0]) == prdata9[7:0]};



// COVER9 SANITY9 CHECKS9
// sanity9 read
// psl9 output_for_div_clk9 : cover {((paddr9 == `AL_DIV_CLK9) & read_enable9); prdata9[7:0] == 8'h55};


`endif


endmodule 


