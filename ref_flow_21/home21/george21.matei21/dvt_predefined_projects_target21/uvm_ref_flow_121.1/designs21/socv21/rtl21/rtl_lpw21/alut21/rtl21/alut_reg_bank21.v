//File21 name   : alut_reg_bank21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

// compiler21 directives21
`include "alut_defines21.v"


module alut_reg_bank21
(   
   // Inputs21
   pclk21,
   n_p_reset21,
   psel21,            
   penable21,       
   pwrite21,         
   paddr21,           
   pwdata21,          

   curr_time21,
   add_check_active21,
   age_check_active21,
   inval_in_prog21,
   reused21,
   d_port21,
   lst_inv_addr_nrm21,
   lst_inv_port_nrm21,
   lst_inv_addr_cmd21,
   lst_inv_port_cmd21,

   // Outputs21
   mac_addr21,    
   d_addr21,   
   s_addr21,    
   s_port21,    
   best_bfr_age21,
   div_clk21,     
   command, 
   prdata21,  
   clear_reused21           
);


   // APB21 Inputs21
   input                 pclk21;             // APB21 clock21
   input                 n_p_reset21;        // Reset21
   input                 psel21;             // Module21 select21 signal21
   input                 penable21;          // Enable21 signal21 
   input                 pwrite21;           // Write when HIGH21 and read when LOW21
   input [6:0]           paddr21;            // Address bus for read write
   input [31:0]          pwdata21;           // APB21 write bus

   // Inputs21 from other ALUT21 blocks
   input [31:0]          curr_time21;        // current time
   input                 add_check_active21; // used to calculate21 status[0]
   input                 age_check_active21; // used to calculate21 status[0]
   input                 inval_in_prog21;    // status[1]
   input                 reused21;           // status[2]
   input [4:0]           d_port21;           // calculated21 destination21 port for tx21
   input [47:0]          lst_inv_addr_nrm21; // last invalidated21 addr normal21 op
   input [1:0]           lst_inv_port_nrm21; // last invalidated21 port normal21 op
   input [47:0]          lst_inv_addr_cmd21; // last invalidated21 addr via cmd21
   input [1:0]           lst_inv_port_cmd21; // last invalidated21 port via cmd21
   

   output [47:0]         mac_addr21;         // address of the switch21
   output [47:0]         d_addr21;           // address of frame21 to be checked21
   output [47:0]         s_addr21;           // address of frame21 to be stored21
   output [1:0]          s_port21;           // source21 port of current frame21
   output [31:0]         best_bfr_age21;     // best21 before age21
   output [7:0]          div_clk21;          // programmed21 clock21 divider21 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata21;           // APB21 read bus
   output                clear_reused21;     // indicates21 status reg read 

   reg    [31:0]         prdata21;           //APB21 read bus   
   reg    [31:0]         frm_d_addr_l21;     
   reg    [15:0]         frm_d_addr_u21;     
   reg    [31:0]         frm_s_addr_l21;     
   reg    [15:0]         frm_s_addr_u21;     
   reg    [1:0]          s_port21;           
   reg    [31:0]         mac_addr_l21;       
   reg    [15:0]         mac_addr_u21;       
   reg    [31:0]         best_bfr_age21;     
   reg    [7:0]          div_clk21;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l21;   
   reg    [15:0]         lst_inv_addr_u21;   
   reg    [1:0]          lst_inv_port21;     


   // Internal Signal21 Declarations21
   wire                  read_enable21;      //APB21 read enable
   wire                  write_enable21;     //APB21 write enable
   wire   [47:0]         mac_addr21;        
   wire   [47:0]         d_addr21;          
   wire   [47:0]         src_addr21;        
   wire                  clear_reused21;    
   wire                  active;

   // ----------------------------
   // General21 Assignments21
   // ----------------------------

   assign read_enable21    = (psel21 & ~penable21 & ~pwrite21);
   assign write_enable21   = (psel21 & penable21 & pwrite21);

   assign mac_addr21  = {mac_addr_u21, mac_addr_l21}; 
   assign d_addr21 =    {frm_d_addr_u21, frm_d_addr_l21};
   assign s_addr21    = {frm_s_addr_u21, frm_s_addr_l21}; 

   assign clear_reused21 = read_enable21 & (paddr21 == `AL_STATUS21) & ~active;

   assign active = (add_check_active21 | age_check_active21);

// ------------------------------------------------------------------------
//   Read Mux21 Control21 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         prdata21 <= 32'h0000_0000;
      else if (read_enable21)
         begin
         case (paddr21)
            `AL_FRM_D_ADDR_L21   : prdata21 <= frm_d_addr_l21;
            `AL_FRM_D_ADDR_U21   : prdata21 <= {16'd0, frm_d_addr_u21};    
            `AL_FRM_S_ADDR_L21   : prdata21 <= frm_s_addr_l21; 
            `AL_FRM_S_ADDR_U21   : prdata21 <= {16'd0, frm_s_addr_u21}; 
            `AL_S_PORT21         : prdata21 <= {30'd0, s_port21}; 
            `AL_D_PORT21         : prdata21 <= {27'd0, d_port21}; 
            `AL_MAC_ADDR_L21     : prdata21 <= mac_addr_l21;
            `AL_MAC_ADDR_U21     : prdata21 <= {16'd0, mac_addr_u21};   
            `AL_CUR_TIME21       : prdata21 <= curr_time21; 
            `AL_BB_AGE21         : prdata21 <= best_bfr_age21;
            `AL_DIV_CLK21        : prdata21 <= {24'd0, div_clk21}; 
            `AL_STATUS21         : prdata21 <= {29'd0, reused21, inval_in_prog21,
                                           active};
            `AL_LST_INV_ADDR_L21 : prdata21 <= lst_inv_addr_l21; 
            `AL_LST_INV_ADDR_U21 : prdata21 <= {16'd0, lst_inv_addr_u21};
            `AL_LST_INV_PORT21   : prdata21 <= {30'd0, lst_inv_port21};

            default:   prdata21 <= 32'h0000_0000;
         endcase
         end
      else
         prdata21 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB21 writable21 registers
// ------------------------------------------------------------------------
// Lower21 destination21 frame21 address register  
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         frm_d_addr_l21 <= 32'h0000_0000;         
      else if (write_enable21 & (paddr21 == `AL_FRM_D_ADDR_L21))
         frm_d_addr_l21 <= pwdata21;
      else
         frm_d_addr_l21 <= frm_d_addr_l21;
      end   


// Upper21 destination21 frame21 address register  
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         frm_d_addr_u21 <= 16'h0000;         
      else if (write_enable21 & (paddr21 == `AL_FRM_D_ADDR_U21))
         frm_d_addr_u21 <= pwdata21[15:0];
      else
         frm_d_addr_u21 <= frm_d_addr_u21;
      end   


// Lower21 source21 frame21 address register  
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         frm_s_addr_l21 <= 32'h0000_0000;         
      else if (write_enable21 & (paddr21 == `AL_FRM_S_ADDR_L21))
         frm_s_addr_l21 <= pwdata21;
      else
         frm_s_addr_l21 <= frm_s_addr_l21;
      end   


// Upper21 source21 frame21 address register  
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         frm_s_addr_u21 <= 16'h0000;         
      else if (write_enable21 & (paddr21 == `AL_FRM_S_ADDR_U21))
         frm_s_addr_u21 <= pwdata21[15:0];
      else
         frm_s_addr_u21 <= frm_s_addr_u21;
      end   


// Source21 port  
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         s_port21 <= 2'b00;         
      else if (write_enable21 & (paddr21 == `AL_S_PORT21))
         s_port21 <= pwdata21[1:0];
      else
         s_port21 <= s_port21;
      end   


// Lower21 switch21 MAC21 address
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         mac_addr_l21 <= 32'h0000_0000;         
      else if (write_enable21 & (paddr21 == `AL_MAC_ADDR_L21))
         mac_addr_l21 <= pwdata21;
      else
         mac_addr_l21 <= mac_addr_l21;
      end   


// Upper21 switch21 MAC21 address 
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         mac_addr_u21 <= 16'h0000;         
      else if (write_enable21 & (paddr21 == `AL_MAC_ADDR_U21))
         mac_addr_u21 <= pwdata21[15:0];
      else
         mac_addr_u21 <= mac_addr_u21;
      end   


// Best21 before age21 
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         best_bfr_age21 <= 32'hffff_ffff;         
      else if (write_enable21 & (paddr21 == `AL_BB_AGE21))
         best_bfr_age21 <= pwdata21;
      else
         best_bfr_age21 <= best_bfr_age21;
      end   


// clock21 divider21
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         div_clk21 <= 8'h00;         
      else if (write_enable21 & (paddr21 == `AL_DIV_CLK21))
         div_clk21 <= pwdata21[7:0];
      else
         div_clk21 <= div_clk21;
      end   


// command.  Needs to be automatically21 cleared21 on following21 cycle
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable21 & (paddr21 == `AL_COMMAND21))
         command <= pwdata21[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last21 invalidated21 port and address values.  These21 can either21 be updated
//   by normal21 operation21 of address checker overwriting21 existing values or
//   by the age21 checker being commanded21 to invalidate21 out of date21 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk21 or negedge n_p_reset21)
      begin 
      if (~n_p_reset21)
      begin
         lst_inv_addr_l21 <= 32'd0;
         lst_inv_addr_u21 <= 16'd0;
         lst_inv_port21   <= 2'd0;
      end
      else if (reused21)        // reused21 flag21 from address checker
      begin
         lst_inv_addr_l21 <= lst_inv_addr_nrm21[31:0];
         lst_inv_addr_u21 <= lst_inv_addr_nrm21[47:32];
         lst_inv_port21   <= lst_inv_port_nrm21;
      end
//      else if (command == 2'b01)  // invalidate21 aged21 from age21 checker
      else if (inval_in_prog21)  // invalidate21 aged21 from age21 checker
      begin
         lst_inv_addr_l21 <= lst_inv_addr_cmd21[31:0];
         lst_inv_addr_u21 <= lst_inv_addr_cmd21[47:32];
         lst_inv_port21   <= lst_inv_port_cmd21;
      end
      else
      begin
         lst_inv_addr_l21 <= lst_inv_addr_l21;
         lst_inv_addr_u21 <= lst_inv_addr_u21;
         lst_inv_port21   <= lst_inv_port21;
      end
      end
 


`ifdef ABV_ON21

defparam i_apb_monitor21.ABUS_WIDTH21 = 7;

// APB21 ASSERTION21 VIP21
apb_monitor21 i_apb_monitor21(.pclk_i21(pclk21), 
                          .presetn_i21(n_p_reset21),
                          .penable_i21(penable21),
                          .psel_i21(psel21),
                          .paddr_i21(paddr21),
                          .pwrite_i21(pwrite21),
                          .pwdata_i21(pwdata21),
                          .prdata_i21(prdata21)); 

// psl21 default clock21 = (posedge pclk21);

// ASSUMPTIONS21
//// active (set by address checker) and invalidation21 in progress21 should never both be set
//// psl21 assume_never_active_inval_aged21 : assume never (active & inval_in_prog21);


// ASSERTION21 CHECKS21
// never read and write at the same time
// psl21 assert_never_rd_wr21 : assert never (read_enable21 & write_enable21);

// check apb21 writes, pick21 command reqister21 as arbitary21 example21
// psl21 assert_cmd_wr21 : assert always ((paddr21 == `AL_COMMAND21) & write_enable21) -> 
//                                    next(command == prev(pwdata21[1:0])) abort21(~n_p_reset21);


// check rw writes, pick21 clock21 divider21 reqister21 as arbitary21 example21.  It takes21 2 cycles21 to write
// then21 read back data, therefore21 need to store21 original write data for use in assertion21 check
reg [31:0] pwdata_d21;  // 1 cycle delayed21 
always @ (posedge pclk21) pwdata_d21 <= pwdata21;

// psl21 assert_rw_div_clk21 : 
// assert always {((paddr21 == `AL_DIV_CLK21) & write_enable21) ; ((paddr21 == `AL_DIV_CLK21) & read_enable21)} |=>
// {prev(pwdata_d21[7:0]) == prdata21[7:0]};



// COVER21 SANITY21 CHECKS21
// sanity21 read
// psl21 output_for_div_clk21 : cover {((paddr21 == `AL_DIV_CLK21) & read_enable21); prdata21[7:0] == 8'h55};


`endif


endmodule 


