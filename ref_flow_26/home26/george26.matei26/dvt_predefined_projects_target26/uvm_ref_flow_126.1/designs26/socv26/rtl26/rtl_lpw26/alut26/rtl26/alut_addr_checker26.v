//File26 name   : alut_addr_checker26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

// compiler26 directives26
`include "alut_defines26.v"


module alut_addr_checker26
(   
   // Inputs26
   pclk26,
   n_p_reset26,
   command,
   mac_addr26,
   d_addr26,
   s_addr26,
   s_port26,
   curr_time26,
   mem_read_data_add26,
   age_confirmed26,
   age_ok26,
   clear_reused26,

   //outputs26
   d_port26,
   add_check_active26,
   mem_addr_add26,
   mem_write_add26,
   mem_write_data_add26,
   lst_inv_addr_nrm26,
   lst_inv_port_nrm26,
   check_age26,
   last_accessed26,
   reused26
);



   input               pclk26;               // APB26 clock26                           
   input               n_p_reset26;          // Reset26                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr26;           // address of the switch26              
   input [47:0]        d_addr26;             // address of frame26 to be checked26     
   input [47:0]        s_addr26;             // address of frame26 to be stored26      
   input [1:0]         s_port26;             // source26 port of current frame26       
   input [31:0]        curr_time26;          // current time,for storing26 in mem    
   input [82:0]        mem_read_data_add26;  // read data from mem                 
   input               age_confirmed26;      // valid flag26 from age26 checker        
   input               age_ok26;             // result from age26 checker 
   input               clear_reused26;       // read/clear flag26 for reused26 signal26           

   output [4:0]        d_port26;             // calculated26 destination26 port for tx26 
   output              add_check_active26;   // bit 0 of status register           
   output [7:0]        mem_addr_add26;       // hash26 address for R/W26 to memory     
   output              mem_write_add26;      // R/W26 flag26 (write = high26)            
   output [82:0]       mem_write_data_add26; // write data for memory             
   output [47:0]       lst_inv_addr_nrm26;   // last invalidated26 addr normal26 op    
   output [1:0]        lst_inv_port_nrm26;   // last invalidated26 port normal26 op    
   output              check_age26;          // request flag26 for age26 check
   output [31:0]       last_accessed26;      // time field sent26 for age26 check
   output              reused26;             // indicates26 ALUT26 location26 overwritten26

   reg   [2:0]         add_chk_state26;      // current address checker state
   reg   [2:0]         nxt_add_chk_state26;  // current address checker state
   reg   [4:0]         d_port26;             // calculated26 destination26 port for tx26 
   reg   [3:0]         port_mem26;           // bitwise26 conversion26 of 2bit port
   reg   [7:0]         mem_addr_add26;       // hash26 address for R/W26 to memory
   reg                 mem_write_add26;      // R/W26 flag26 (write = high26)            
   reg                 reused26;             // indicates26 ALUT26 location26 overwritten26
   reg   [47:0]        lst_inv_addr_nrm26;   // last invalidated26 addr normal26 op    
   reg   [1:0]         lst_inv_port_nrm26;   // last invalidated26 port normal26 op    
   reg                 check_age26;          // request flag26 for age26 checker
   reg   [31:0]        last_accessed26;      // time field sent26 for age26 check


   wire   [7:0]        s_addr_hash26;        // hash26 of address for storing26
   wire   [7:0]        d_addr_hash26;        // hash26 of address for checking
   wire   [82:0]       mem_write_data_add26; // write data for memory  
   wire                add_check_active26;   // bit 0 of status register           


// Parameters26 for Address Checking26 FSM26 states26
   parameter idle26           = 3'b000;
   parameter mac_addr_chk26   = 3'b001;
   parameter read_dest_add26  = 3'b010;
   parameter valid_chk26      = 3'b011;
   parameter age_chk26        = 3'b100;
   parameter addr_chk26       = 3'b101;
   parameter read_src_add26   = 3'b110;
   parameter write_src26      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash26 conversion26 of source26 and destination26 addresses26
// -----------------------------------------------------------------------------
   assign s_addr_hash26 = s_addr26[7:0] ^ s_addr26[15:8] ^ s_addr26[23:16] ^
                        s_addr26[31:24] ^ s_addr26[39:32] ^ s_addr26[47:40];

   assign d_addr_hash26 = d_addr26[7:0] ^ d_addr26[15:8] ^ d_addr26[23:16] ^
                        d_addr26[31:24] ^ d_addr26[39:32] ^ d_addr26[47:40];



// -----------------------------------------------------------------------------
//   State26 Machine26 For26 handling26 the destination26 address checking process and
//   and storing26 of new source26 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state26 or age_confirmed26 or age_ok26)
   begin
      case (add_chk_state26)
      
      idle26:
         if (command == 2'b01)
            nxt_add_chk_state26 = mac_addr_chk26;
         else
            nxt_add_chk_state26 = idle26;

      mac_addr_chk26:   // check if destination26 address match MAC26 switch26 address
         if (d_addr26 == mac_addr26)
            nxt_add_chk_state26 = idle26;  // return dest26 port as 5'b1_0000
         else
            nxt_add_chk_state26 = read_dest_add26;

      read_dest_add26:       // read data from memory using hash26 of destination26 address
            nxt_add_chk_state26 = valid_chk26;

      valid_chk26:      // check if read data had26 valid bit set
         nxt_add_chk_state26 = age_chk26;

      age_chk26:        // request age26 checker to check if still in date26
         if (age_confirmed26)
            nxt_add_chk_state26 = addr_chk26;
         else
            nxt_add_chk_state26 = age_chk26; 

      addr_chk26:       // perform26 compare between dest26 and read addresses26
            nxt_add_chk_state26 = read_src_add26; // return read port from ALUT26 mem

      read_src_add26:   // read from memory location26 about26 to be overwritten26
            nxt_add_chk_state26 = write_src26; 

      write_src26:      // write new source26 data (addr and port) to memory
            nxt_add_chk_state26 = idle26; 

      default:
            nxt_add_chk_state26 = idle26;
      endcase
   end


// destination26 check FSM26 current state
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
      add_chk_state26 <= idle26;
   else
      add_chk_state26 <= nxt_add_chk_state26;
   end



// -----------------------------------------------------------------------------
//   Generate26 returned value of port for sending26 new frame26 to
// -----------------------------------------------------------------------------
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
      d_port26 <= 5'b0_1111;
   else if ((add_chk_state26 == mac_addr_chk26) & (d_addr26 == mac_addr26))
      d_port26 <= 5'b1_0000;
   else if (((add_chk_state26 == valid_chk26) & ~mem_read_data_add26[82]) |
            ((add_chk_state26 == age_chk26) & ~(age_confirmed26 & age_ok26)) |
            ((add_chk_state26 == addr_chk26) & (d_addr26 != mem_read_data_add26[47:0])))
      d_port26 <= 5'b0_1111 & ~( 1 << s_port26 );
   else if ((add_chk_state26 == addr_chk26) & (d_addr26 == mem_read_data_add26[47:0]))
      d_port26 <= {1'b0, port_mem26} & ~( 1 << s_port26 );
   else
      d_port26 <= d_port26;
   end


// -----------------------------------------------------------------------------
//   convert read port source26 value from 2bits to bitwise26 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
      port_mem26 <= 4'b1111;
   else begin
      case (mem_read_data_add26[49:48])
         2'b00: port_mem26 <= 4'b0001;
         2'b01: port_mem26 <= 4'b0010;
         2'b10: port_mem26 <= 4'b0100;
         2'b11: port_mem26 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded26 off26 add_chk_state26
// -----------------------------------------------------------------------------
assign add_check_active26 = (add_chk_state26 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate26 memory addressing26 signals26.
//   The check address command will be taken26 as the indication26 from SW26 that the 
//   source26 fields (address and port) can be written26 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26) 
   begin
       mem_write_add26 <= 1'b0;
       mem_addr_add26  <= 8'd0;
   end
   else if (add_chk_state26 == read_dest_add26)
   begin
       mem_write_add26 <= 1'b0;
       mem_addr_add26  <= d_addr_hash26;
   end
// Need26 to set address two26 cycles26 before check
   else if ( (add_chk_state26 == age_chk26) && age_confirmed26 )
   begin
       mem_write_add26 <= 1'b0;
       mem_addr_add26  <= s_addr_hash26;
   end
   else if (add_chk_state26 == write_src26)
   begin
       mem_write_add26 <= 1'b1;
       mem_addr_add26  <= s_addr_hash26;
   end
   else
   begin
       mem_write_add26 <= 1'b0;
       mem_addr_add26  <= d_addr_hash26;
   end
   end


// -----------------------------------------------------------------------------
//   Generate26 databus26 for writing to memory
//   Data written26 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add26 = {1'b1, curr_time26, s_port26, s_addr26};



// -----------------------------------------------------------------------------
//   Evaluate26 read back data that is about26 to be overwritten26 with new source26 
//   address and port values. Decide26 whether26 the reused26 flag26 must be set and
//   last_inval26 address and port values updated.
//   reused26 needs26 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26) 
   begin
      reused26 <= 1'b0;
      lst_inv_addr_nrm26 <= 48'd0;
      lst_inv_port_nrm26 <= 2'd0;
   end
   else if ((add_chk_state26 == read_src_add26) & mem_read_data_add26[82] &
            (s_addr26 != mem_read_data_add26[47:0]))
   begin
      reused26 <= 1'b1;
      lst_inv_addr_nrm26 <= mem_read_data_add26[47:0];
      lst_inv_port_nrm26 <= mem_read_data_add26[49:48];
   end
   else if (clear_reused26)
   begin
      reused26 <= 1'b0;
      lst_inv_addr_nrm26 <= lst_inv_addr_nrm26;
      lst_inv_port_nrm26 <= lst_inv_addr_nrm26;
   end
   else 
   begin
      reused26 <= reused26;
      lst_inv_addr_nrm26 <= lst_inv_addr_nrm26;
      lst_inv_port_nrm26 <= lst_inv_addr_nrm26;
   end
   end


// -----------------------------------------------------------------------------
//   Generate26 signals26 for age26 checker to perform26 in-date26 check
// -----------------------------------------------------------------------------
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26) 
   begin
      check_age26 <= 1'b0;  
      last_accessed26 <= 32'd0;
   end
   else if (check_age26)
   begin
      check_age26 <= 1'b0;  
      last_accessed26 <= mem_read_data_add26[81:50];
   end
   else if (add_chk_state26 == age_chk26)
   begin
      check_age26 <= 1'b1;  
      last_accessed26 <= mem_read_data_add26[81:50];
   end
   else 
   begin
      check_age26 <= 1'b0;  
      last_accessed26 <= 32'd0;
   end
   end


`ifdef ABV_ON26

// psl26 default clock26 = (posedge pclk26);

// ASSERTION26 CHECKS26
/* Commented26 out as also checking in toplevel26
// it should never be possible26 for the destination26 port to indicate26 the MAC26
// switch26 address and one of the other 4 Ethernets26
// psl26 assert_valid_dest_port26 : assert never (d_port26[4] & |{d_port26[3:0]});


// COVER26 SANITY26 CHECKS26
// check all values of destination26 port can be returned.
// psl26 cover_d_port_026 : cover { d_port26 == 5'b0_0001 };
// psl26 cover_d_port_126 : cover { d_port26 == 5'b0_0010 };
// psl26 cover_d_port_226 : cover { d_port26 == 5'b0_0100 };
// psl26 cover_d_port_326 : cover { d_port26 == 5'b0_1000 };
// psl26 cover_d_port_426 : cover { d_port26 == 5'b1_0000 };
// psl26 cover_d_port_all26 : cover { d_port26 == 5'b0_1111 };
*/
`endif


endmodule 









