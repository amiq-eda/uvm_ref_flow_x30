//File17 name   : alut_reg_bank17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

// compiler17 directives17
`include "alut_defines17.v"


module alut_reg_bank17
(   
   // Inputs17
   pclk17,
   n_p_reset17,
   psel17,            
   penable17,       
   pwrite17,         
   paddr17,           
   pwdata17,          

   curr_time17,
   add_check_active17,
   age_check_active17,
   inval_in_prog17,
   reused17,
   d_port17,
   lst_inv_addr_nrm17,
   lst_inv_port_nrm17,
   lst_inv_addr_cmd17,
   lst_inv_port_cmd17,

   // Outputs17
   mac_addr17,    
   d_addr17,   
   s_addr17,    
   s_port17,    
   best_bfr_age17,
   div_clk17,     
   command, 
   prdata17,  
   clear_reused17           
);


   // APB17 Inputs17
   input                 pclk17;             // APB17 clock17
   input                 n_p_reset17;        // Reset17
   input                 psel17;             // Module17 select17 signal17
   input                 penable17;          // Enable17 signal17 
   input                 pwrite17;           // Write when HIGH17 and read when LOW17
   input [6:0]           paddr17;            // Address bus for read write
   input [31:0]          pwdata17;           // APB17 write bus

   // Inputs17 from other ALUT17 blocks
   input [31:0]          curr_time17;        // current time
   input                 add_check_active17; // used to calculate17 status[0]
   input                 age_check_active17; // used to calculate17 status[0]
   input                 inval_in_prog17;    // status[1]
   input                 reused17;           // status[2]
   input [4:0]           d_port17;           // calculated17 destination17 port for tx17
   input [47:0]          lst_inv_addr_nrm17; // last invalidated17 addr normal17 op
   input [1:0]           lst_inv_port_nrm17; // last invalidated17 port normal17 op
   input [47:0]          lst_inv_addr_cmd17; // last invalidated17 addr via cmd17
   input [1:0]           lst_inv_port_cmd17; // last invalidated17 port via cmd17
   

   output [47:0]         mac_addr17;         // address of the switch17
   output [47:0]         d_addr17;           // address of frame17 to be checked17
   output [47:0]         s_addr17;           // address of frame17 to be stored17
   output [1:0]          s_port17;           // source17 port of current frame17
   output [31:0]         best_bfr_age17;     // best17 before age17
   output [7:0]          div_clk17;          // programmed17 clock17 divider17 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata17;           // APB17 read bus
   output                clear_reused17;     // indicates17 status reg read 

   reg    [31:0]         prdata17;           //APB17 read bus   
   reg    [31:0]         frm_d_addr_l17;     
   reg    [15:0]         frm_d_addr_u17;     
   reg    [31:0]         frm_s_addr_l17;     
   reg    [15:0]         frm_s_addr_u17;     
   reg    [1:0]          s_port17;           
   reg    [31:0]         mac_addr_l17;       
   reg    [15:0]         mac_addr_u17;       
   reg    [31:0]         best_bfr_age17;     
   reg    [7:0]          div_clk17;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l17;   
   reg    [15:0]         lst_inv_addr_u17;   
   reg    [1:0]          lst_inv_port17;     


   // Internal Signal17 Declarations17
   wire                  read_enable17;      //APB17 read enable
   wire                  write_enable17;     //APB17 write enable
   wire   [47:0]         mac_addr17;        
   wire   [47:0]         d_addr17;          
   wire   [47:0]         src_addr17;        
   wire                  clear_reused17;    
   wire                  active;

   // ----------------------------
   // General17 Assignments17
   // ----------------------------

   assign read_enable17    = (psel17 & ~penable17 & ~pwrite17);
   assign write_enable17   = (psel17 & penable17 & pwrite17);

   assign mac_addr17  = {mac_addr_u17, mac_addr_l17}; 
   assign d_addr17 =    {frm_d_addr_u17, frm_d_addr_l17};
   assign s_addr17    = {frm_s_addr_u17, frm_s_addr_l17}; 

   assign clear_reused17 = read_enable17 & (paddr17 == `AL_STATUS17) & ~active;

   assign active = (add_check_active17 | age_check_active17);

// ------------------------------------------------------------------------
//   Read Mux17 Control17 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         prdata17 <= 32'h0000_0000;
      else if (read_enable17)
         begin
         case (paddr17)
            `AL_FRM_D_ADDR_L17   : prdata17 <= frm_d_addr_l17;
            `AL_FRM_D_ADDR_U17   : prdata17 <= {16'd0, frm_d_addr_u17};    
            `AL_FRM_S_ADDR_L17   : prdata17 <= frm_s_addr_l17; 
            `AL_FRM_S_ADDR_U17   : prdata17 <= {16'd0, frm_s_addr_u17}; 
            `AL_S_PORT17         : prdata17 <= {30'd0, s_port17}; 
            `AL_D_PORT17         : prdata17 <= {27'd0, d_port17}; 
            `AL_MAC_ADDR_L17     : prdata17 <= mac_addr_l17;
            `AL_MAC_ADDR_U17     : prdata17 <= {16'd0, mac_addr_u17};   
            `AL_CUR_TIME17       : prdata17 <= curr_time17; 
            `AL_BB_AGE17         : prdata17 <= best_bfr_age17;
            `AL_DIV_CLK17        : prdata17 <= {24'd0, div_clk17}; 
            `AL_STATUS17         : prdata17 <= {29'd0, reused17, inval_in_prog17,
                                           active};
            `AL_LST_INV_ADDR_L17 : prdata17 <= lst_inv_addr_l17; 
            `AL_LST_INV_ADDR_U17 : prdata17 <= {16'd0, lst_inv_addr_u17};
            `AL_LST_INV_PORT17   : prdata17 <= {30'd0, lst_inv_port17};

            default:   prdata17 <= 32'h0000_0000;
         endcase
         end
      else
         prdata17 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB17 writable17 registers
// ------------------------------------------------------------------------
// Lower17 destination17 frame17 address register  
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         frm_d_addr_l17 <= 32'h0000_0000;         
      else if (write_enable17 & (paddr17 == `AL_FRM_D_ADDR_L17))
         frm_d_addr_l17 <= pwdata17;
      else
         frm_d_addr_l17 <= frm_d_addr_l17;
      end   


// Upper17 destination17 frame17 address register  
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         frm_d_addr_u17 <= 16'h0000;         
      else if (write_enable17 & (paddr17 == `AL_FRM_D_ADDR_U17))
         frm_d_addr_u17 <= pwdata17[15:0];
      else
         frm_d_addr_u17 <= frm_d_addr_u17;
      end   


// Lower17 source17 frame17 address register  
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         frm_s_addr_l17 <= 32'h0000_0000;         
      else if (write_enable17 & (paddr17 == `AL_FRM_S_ADDR_L17))
         frm_s_addr_l17 <= pwdata17;
      else
         frm_s_addr_l17 <= frm_s_addr_l17;
      end   


// Upper17 source17 frame17 address register  
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         frm_s_addr_u17 <= 16'h0000;         
      else if (write_enable17 & (paddr17 == `AL_FRM_S_ADDR_U17))
         frm_s_addr_u17 <= pwdata17[15:0];
      else
         frm_s_addr_u17 <= frm_s_addr_u17;
      end   


// Source17 port  
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         s_port17 <= 2'b00;         
      else if (write_enable17 & (paddr17 == `AL_S_PORT17))
         s_port17 <= pwdata17[1:0];
      else
         s_port17 <= s_port17;
      end   


// Lower17 switch17 MAC17 address
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         mac_addr_l17 <= 32'h0000_0000;         
      else if (write_enable17 & (paddr17 == `AL_MAC_ADDR_L17))
         mac_addr_l17 <= pwdata17;
      else
         mac_addr_l17 <= mac_addr_l17;
      end   


// Upper17 switch17 MAC17 address 
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         mac_addr_u17 <= 16'h0000;         
      else if (write_enable17 & (paddr17 == `AL_MAC_ADDR_U17))
         mac_addr_u17 <= pwdata17[15:0];
      else
         mac_addr_u17 <= mac_addr_u17;
      end   


// Best17 before age17 
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         best_bfr_age17 <= 32'hffff_ffff;         
      else if (write_enable17 & (paddr17 == `AL_BB_AGE17))
         best_bfr_age17 <= pwdata17;
      else
         best_bfr_age17 <= best_bfr_age17;
      end   


// clock17 divider17
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         div_clk17 <= 8'h00;         
      else if (write_enable17 & (paddr17 == `AL_DIV_CLK17))
         div_clk17 <= pwdata17[7:0];
      else
         div_clk17 <= div_clk17;
      end   


// command.  Needs to be automatically17 cleared17 on following17 cycle
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable17 & (paddr17 == `AL_COMMAND17))
         command <= pwdata17[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last17 invalidated17 port and address values.  These17 can either17 be updated
//   by normal17 operation17 of address checker overwriting17 existing values or
//   by the age17 checker being commanded17 to invalidate17 out of date17 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk17 or negedge n_p_reset17)
      begin 
      if (~n_p_reset17)
      begin
         lst_inv_addr_l17 <= 32'd0;
         lst_inv_addr_u17 <= 16'd0;
         lst_inv_port17   <= 2'd0;
      end
      else if (reused17)        // reused17 flag17 from address checker
      begin
         lst_inv_addr_l17 <= lst_inv_addr_nrm17[31:0];
         lst_inv_addr_u17 <= lst_inv_addr_nrm17[47:32];
         lst_inv_port17   <= lst_inv_port_nrm17;
      end
//      else if (command == 2'b01)  // invalidate17 aged17 from age17 checker
      else if (inval_in_prog17)  // invalidate17 aged17 from age17 checker
      begin
         lst_inv_addr_l17 <= lst_inv_addr_cmd17[31:0];
         lst_inv_addr_u17 <= lst_inv_addr_cmd17[47:32];
         lst_inv_port17   <= lst_inv_port_cmd17;
      end
      else
      begin
         lst_inv_addr_l17 <= lst_inv_addr_l17;
         lst_inv_addr_u17 <= lst_inv_addr_u17;
         lst_inv_port17   <= lst_inv_port17;
      end
      end
 


`ifdef ABV_ON17

defparam i_apb_monitor17.ABUS_WIDTH17 = 7;

// APB17 ASSERTION17 VIP17
apb_monitor17 i_apb_monitor17(.pclk_i17(pclk17), 
                          .presetn_i17(n_p_reset17),
                          .penable_i17(penable17),
                          .psel_i17(psel17),
                          .paddr_i17(paddr17),
                          .pwrite_i17(pwrite17),
                          .pwdata_i17(pwdata17),
                          .prdata_i17(prdata17)); 

// psl17 default clock17 = (posedge pclk17);

// ASSUMPTIONS17
//// active (set by address checker) and invalidation17 in progress17 should never both be set
//// psl17 assume_never_active_inval_aged17 : assume never (active & inval_in_prog17);


// ASSERTION17 CHECKS17
// never read and write at the same time
// psl17 assert_never_rd_wr17 : assert never (read_enable17 & write_enable17);

// check apb17 writes, pick17 command reqister17 as arbitary17 example17
// psl17 assert_cmd_wr17 : assert always ((paddr17 == `AL_COMMAND17) & write_enable17) -> 
//                                    next(command == prev(pwdata17[1:0])) abort17(~n_p_reset17);


// check rw writes, pick17 clock17 divider17 reqister17 as arbitary17 example17.  It takes17 2 cycles17 to write
// then17 read back data, therefore17 need to store17 original write data for use in assertion17 check
reg [31:0] pwdata_d17;  // 1 cycle delayed17 
always @ (posedge pclk17) pwdata_d17 <= pwdata17;

// psl17 assert_rw_div_clk17 : 
// assert always {((paddr17 == `AL_DIV_CLK17) & write_enable17) ; ((paddr17 == `AL_DIV_CLK17) & read_enable17)} |=>
// {prev(pwdata_d17[7:0]) == prdata17[7:0]};



// COVER17 SANITY17 CHECKS17
// sanity17 read
// psl17 output_for_div_clk17 : cover {((paddr17 == `AL_DIV_CLK17) & read_enable17); prdata17[7:0] == 8'h55};


`endif


endmodule 


