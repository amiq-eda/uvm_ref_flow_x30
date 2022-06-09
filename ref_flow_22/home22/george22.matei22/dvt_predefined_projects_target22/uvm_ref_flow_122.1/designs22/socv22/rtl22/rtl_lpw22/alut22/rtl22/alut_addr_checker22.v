//File22 name   : alut_addr_checker22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

// compiler22 directives22
`include "alut_defines22.v"


module alut_addr_checker22
(   
   // Inputs22
   pclk22,
   n_p_reset22,
   command,
   mac_addr22,
   d_addr22,
   s_addr22,
   s_port22,
   curr_time22,
   mem_read_data_add22,
   age_confirmed22,
   age_ok22,
   clear_reused22,

   //outputs22
   d_port22,
   add_check_active22,
   mem_addr_add22,
   mem_write_add22,
   mem_write_data_add22,
   lst_inv_addr_nrm22,
   lst_inv_port_nrm22,
   check_age22,
   last_accessed22,
   reused22
);



   input               pclk22;               // APB22 clock22                           
   input               n_p_reset22;          // Reset22                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr22;           // address of the switch22              
   input [47:0]        d_addr22;             // address of frame22 to be checked22     
   input [47:0]        s_addr22;             // address of frame22 to be stored22      
   input [1:0]         s_port22;             // source22 port of current frame22       
   input [31:0]        curr_time22;          // current time,for storing22 in mem    
   input [82:0]        mem_read_data_add22;  // read data from mem                 
   input               age_confirmed22;      // valid flag22 from age22 checker        
   input               age_ok22;             // result from age22 checker 
   input               clear_reused22;       // read/clear flag22 for reused22 signal22           

   output [4:0]        d_port22;             // calculated22 destination22 port for tx22 
   output              add_check_active22;   // bit 0 of status register           
   output [7:0]        mem_addr_add22;       // hash22 address for R/W22 to memory     
   output              mem_write_add22;      // R/W22 flag22 (write = high22)            
   output [82:0]       mem_write_data_add22; // write data for memory             
   output [47:0]       lst_inv_addr_nrm22;   // last invalidated22 addr normal22 op    
   output [1:0]        lst_inv_port_nrm22;   // last invalidated22 port normal22 op    
   output              check_age22;          // request flag22 for age22 check
   output [31:0]       last_accessed22;      // time field sent22 for age22 check
   output              reused22;             // indicates22 ALUT22 location22 overwritten22

   reg   [2:0]         add_chk_state22;      // current address checker state
   reg   [2:0]         nxt_add_chk_state22;  // current address checker state
   reg   [4:0]         d_port22;             // calculated22 destination22 port for tx22 
   reg   [3:0]         port_mem22;           // bitwise22 conversion22 of 2bit port
   reg   [7:0]         mem_addr_add22;       // hash22 address for R/W22 to memory
   reg                 mem_write_add22;      // R/W22 flag22 (write = high22)            
   reg                 reused22;             // indicates22 ALUT22 location22 overwritten22
   reg   [47:0]        lst_inv_addr_nrm22;   // last invalidated22 addr normal22 op    
   reg   [1:0]         lst_inv_port_nrm22;   // last invalidated22 port normal22 op    
   reg                 check_age22;          // request flag22 for age22 checker
   reg   [31:0]        last_accessed22;      // time field sent22 for age22 check


   wire   [7:0]        s_addr_hash22;        // hash22 of address for storing22
   wire   [7:0]        d_addr_hash22;        // hash22 of address for checking
   wire   [82:0]       mem_write_data_add22; // write data for memory  
   wire                add_check_active22;   // bit 0 of status register           


// Parameters22 for Address Checking22 FSM22 states22
   parameter idle22           = 3'b000;
   parameter mac_addr_chk22   = 3'b001;
   parameter read_dest_add22  = 3'b010;
   parameter valid_chk22      = 3'b011;
   parameter age_chk22        = 3'b100;
   parameter addr_chk22       = 3'b101;
   parameter read_src_add22   = 3'b110;
   parameter write_src22      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash22 conversion22 of source22 and destination22 addresses22
// -----------------------------------------------------------------------------
   assign s_addr_hash22 = s_addr22[7:0] ^ s_addr22[15:8] ^ s_addr22[23:16] ^
                        s_addr22[31:24] ^ s_addr22[39:32] ^ s_addr22[47:40];

   assign d_addr_hash22 = d_addr22[7:0] ^ d_addr22[15:8] ^ d_addr22[23:16] ^
                        d_addr22[31:24] ^ d_addr22[39:32] ^ d_addr22[47:40];



// -----------------------------------------------------------------------------
//   State22 Machine22 For22 handling22 the destination22 address checking process and
//   and storing22 of new source22 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state22 or age_confirmed22 or age_ok22)
   begin
      case (add_chk_state22)
      
      idle22:
         if (command == 2'b01)
            nxt_add_chk_state22 = mac_addr_chk22;
         else
            nxt_add_chk_state22 = idle22;

      mac_addr_chk22:   // check if destination22 address match MAC22 switch22 address
         if (d_addr22 == mac_addr22)
            nxt_add_chk_state22 = idle22;  // return dest22 port as 5'b1_0000
         else
            nxt_add_chk_state22 = read_dest_add22;

      read_dest_add22:       // read data from memory using hash22 of destination22 address
            nxt_add_chk_state22 = valid_chk22;

      valid_chk22:      // check if read data had22 valid bit set
         nxt_add_chk_state22 = age_chk22;

      age_chk22:        // request age22 checker to check if still in date22
         if (age_confirmed22)
            nxt_add_chk_state22 = addr_chk22;
         else
            nxt_add_chk_state22 = age_chk22; 

      addr_chk22:       // perform22 compare between dest22 and read addresses22
            nxt_add_chk_state22 = read_src_add22; // return read port from ALUT22 mem

      read_src_add22:   // read from memory location22 about22 to be overwritten22
            nxt_add_chk_state22 = write_src22; 

      write_src22:      // write new source22 data (addr and port) to memory
            nxt_add_chk_state22 = idle22; 

      default:
            nxt_add_chk_state22 = idle22;
      endcase
   end


// destination22 check FSM22 current state
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
      add_chk_state22 <= idle22;
   else
      add_chk_state22 <= nxt_add_chk_state22;
   end



// -----------------------------------------------------------------------------
//   Generate22 returned value of port for sending22 new frame22 to
// -----------------------------------------------------------------------------
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
      d_port22 <= 5'b0_1111;
   else if ((add_chk_state22 == mac_addr_chk22) & (d_addr22 == mac_addr22))
      d_port22 <= 5'b1_0000;
   else if (((add_chk_state22 == valid_chk22) & ~mem_read_data_add22[82]) |
            ((add_chk_state22 == age_chk22) & ~(age_confirmed22 & age_ok22)) |
            ((add_chk_state22 == addr_chk22) & (d_addr22 != mem_read_data_add22[47:0])))
      d_port22 <= 5'b0_1111 & ~( 1 << s_port22 );
   else if ((add_chk_state22 == addr_chk22) & (d_addr22 == mem_read_data_add22[47:0]))
      d_port22 <= {1'b0, port_mem22} & ~( 1 << s_port22 );
   else
      d_port22 <= d_port22;
   end


// -----------------------------------------------------------------------------
//   convert read port source22 value from 2bits to bitwise22 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
      port_mem22 <= 4'b1111;
   else begin
      case (mem_read_data_add22[49:48])
         2'b00: port_mem22 <= 4'b0001;
         2'b01: port_mem22 <= 4'b0010;
         2'b10: port_mem22 <= 4'b0100;
         2'b11: port_mem22 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded22 off22 add_chk_state22
// -----------------------------------------------------------------------------
assign add_check_active22 = (add_chk_state22 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate22 memory addressing22 signals22.
//   The check address command will be taken22 as the indication22 from SW22 that the 
//   source22 fields (address and port) can be written22 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22) 
   begin
       mem_write_add22 <= 1'b0;
       mem_addr_add22  <= 8'd0;
   end
   else if (add_chk_state22 == read_dest_add22)
   begin
       mem_write_add22 <= 1'b0;
       mem_addr_add22  <= d_addr_hash22;
   end
// Need22 to set address two22 cycles22 before check
   else if ( (add_chk_state22 == age_chk22) && age_confirmed22 )
   begin
       mem_write_add22 <= 1'b0;
       mem_addr_add22  <= s_addr_hash22;
   end
   else if (add_chk_state22 == write_src22)
   begin
       mem_write_add22 <= 1'b1;
       mem_addr_add22  <= s_addr_hash22;
   end
   else
   begin
       mem_write_add22 <= 1'b0;
       mem_addr_add22  <= d_addr_hash22;
   end
   end


// -----------------------------------------------------------------------------
//   Generate22 databus22 for writing to memory
//   Data written22 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add22 = {1'b1, curr_time22, s_port22, s_addr22};



// -----------------------------------------------------------------------------
//   Evaluate22 read back data that is about22 to be overwritten22 with new source22 
//   address and port values. Decide22 whether22 the reused22 flag22 must be set and
//   last_inval22 address and port values updated.
//   reused22 needs22 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22) 
   begin
      reused22 <= 1'b0;
      lst_inv_addr_nrm22 <= 48'd0;
      lst_inv_port_nrm22 <= 2'd0;
   end
   else if ((add_chk_state22 == read_src_add22) & mem_read_data_add22[82] &
            (s_addr22 != mem_read_data_add22[47:0]))
   begin
      reused22 <= 1'b1;
      lst_inv_addr_nrm22 <= mem_read_data_add22[47:0];
      lst_inv_port_nrm22 <= mem_read_data_add22[49:48];
   end
   else if (clear_reused22)
   begin
      reused22 <= 1'b0;
      lst_inv_addr_nrm22 <= lst_inv_addr_nrm22;
      lst_inv_port_nrm22 <= lst_inv_addr_nrm22;
   end
   else 
   begin
      reused22 <= reused22;
      lst_inv_addr_nrm22 <= lst_inv_addr_nrm22;
      lst_inv_port_nrm22 <= lst_inv_addr_nrm22;
   end
   end


// -----------------------------------------------------------------------------
//   Generate22 signals22 for age22 checker to perform22 in-date22 check
// -----------------------------------------------------------------------------
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22) 
   begin
      check_age22 <= 1'b0;  
      last_accessed22 <= 32'd0;
   end
   else if (check_age22)
   begin
      check_age22 <= 1'b0;  
      last_accessed22 <= mem_read_data_add22[81:50];
   end
   else if (add_chk_state22 == age_chk22)
   begin
      check_age22 <= 1'b1;  
      last_accessed22 <= mem_read_data_add22[81:50];
   end
   else 
   begin
      check_age22 <= 1'b0;  
      last_accessed22 <= 32'd0;
   end
   end


`ifdef ABV_ON22

// psl22 default clock22 = (posedge pclk22);

// ASSERTION22 CHECKS22
/* Commented22 out as also checking in toplevel22
// it should never be possible22 for the destination22 port to indicate22 the MAC22
// switch22 address and one of the other 4 Ethernets22
// psl22 assert_valid_dest_port22 : assert never (d_port22[4] & |{d_port22[3:0]});


// COVER22 SANITY22 CHECKS22
// check all values of destination22 port can be returned.
// psl22 cover_d_port_022 : cover { d_port22 == 5'b0_0001 };
// psl22 cover_d_port_122 : cover { d_port22 == 5'b0_0010 };
// psl22 cover_d_port_222 : cover { d_port22 == 5'b0_0100 };
// psl22 cover_d_port_322 : cover { d_port22 == 5'b0_1000 };
// psl22 cover_d_port_422 : cover { d_port22 == 5'b1_0000 };
// psl22 cover_d_port_all22 : cover { d_port22 == 5'b0_1111 };
*/
`endif


endmodule 









