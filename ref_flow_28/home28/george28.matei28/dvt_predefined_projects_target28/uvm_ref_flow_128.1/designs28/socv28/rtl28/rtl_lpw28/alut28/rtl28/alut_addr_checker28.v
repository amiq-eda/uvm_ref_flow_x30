//File28 name   : alut_addr_checker28.v
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


module alut_addr_checker28
(   
   // Inputs28
   pclk28,
   n_p_reset28,
   command,
   mac_addr28,
   d_addr28,
   s_addr28,
   s_port28,
   curr_time28,
   mem_read_data_add28,
   age_confirmed28,
   age_ok28,
   clear_reused28,

   //outputs28
   d_port28,
   add_check_active28,
   mem_addr_add28,
   mem_write_add28,
   mem_write_data_add28,
   lst_inv_addr_nrm28,
   lst_inv_port_nrm28,
   check_age28,
   last_accessed28,
   reused28
);



   input               pclk28;               // APB28 clock28                           
   input               n_p_reset28;          // Reset28                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr28;           // address of the switch28              
   input [47:0]        d_addr28;             // address of frame28 to be checked28     
   input [47:0]        s_addr28;             // address of frame28 to be stored28      
   input [1:0]         s_port28;             // source28 port of current frame28       
   input [31:0]        curr_time28;          // current time,for storing28 in mem    
   input [82:0]        mem_read_data_add28;  // read data from mem                 
   input               age_confirmed28;      // valid flag28 from age28 checker        
   input               age_ok28;             // result from age28 checker 
   input               clear_reused28;       // read/clear flag28 for reused28 signal28           

   output [4:0]        d_port28;             // calculated28 destination28 port for tx28 
   output              add_check_active28;   // bit 0 of status register           
   output [7:0]        mem_addr_add28;       // hash28 address for R/W28 to memory     
   output              mem_write_add28;      // R/W28 flag28 (write = high28)            
   output [82:0]       mem_write_data_add28; // write data for memory             
   output [47:0]       lst_inv_addr_nrm28;   // last invalidated28 addr normal28 op    
   output [1:0]        lst_inv_port_nrm28;   // last invalidated28 port normal28 op    
   output              check_age28;          // request flag28 for age28 check
   output [31:0]       last_accessed28;      // time field sent28 for age28 check
   output              reused28;             // indicates28 ALUT28 location28 overwritten28

   reg   [2:0]         add_chk_state28;      // current address checker state
   reg   [2:0]         nxt_add_chk_state28;  // current address checker state
   reg   [4:0]         d_port28;             // calculated28 destination28 port for tx28 
   reg   [3:0]         port_mem28;           // bitwise28 conversion28 of 2bit port
   reg   [7:0]         mem_addr_add28;       // hash28 address for R/W28 to memory
   reg                 mem_write_add28;      // R/W28 flag28 (write = high28)            
   reg                 reused28;             // indicates28 ALUT28 location28 overwritten28
   reg   [47:0]        lst_inv_addr_nrm28;   // last invalidated28 addr normal28 op    
   reg   [1:0]         lst_inv_port_nrm28;   // last invalidated28 port normal28 op    
   reg                 check_age28;          // request flag28 for age28 checker
   reg   [31:0]        last_accessed28;      // time field sent28 for age28 check


   wire   [7:0]        s_addr_hash28;        // hash28 of address for storing28
   wire   [7:0]        d_addr_hash28;        // hash28 of address for checking
   wire   [82:0]       mem_write_data_add28; // write data for memory  
   wire                add_check_active28;   // bit 0 of status register           


// Parameters28 for Address Checking28 FSM28 states28
   parameter idle28           = 3'b000;
   parameter mac_addr_chk28   = 3'b001;
   parameter read_dest_add28  = 3'b010;
   parameter valid_chk28      = 3'b011;
   parameter age_chk28        = 3'b100;
   parameter addr_chk28       = 3'b101;
   parameter read_src_add28   = 3'b110;
   parameter write_src28      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash28 conversion28 of source28 and destination28 addresses28
// -----------------------------------------------------------------------------
   assign s_addr_hash28 = s_addr28[7:0] ^ s_addr28[15:8] ^ s_addr28[23:16] ^
                        s_addr28[31:24] ^ s_addr28[39:32] ^ s_addr28[47:40];

   assign d_addr_hash28 = d_addr28[7:0] ^ d_addr28[15:8] ^ d_addr28[23:16] ^
                        d_addr28[31:24] ^ d_addr28[39:32] ^ d_addr28[47:40];



// -----------------------------------------------------------------------------
//   State28 Machine28 For28 handling28 the destination28 address checking process and
//   and storing28 of new source28 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state28 or age_confirmed28 or age_ok28)
   begin
      case (add_chk_state28)
      
      idle28:
         if (command == 2'b01)
            nxt_add_chk_state28 = mac_addr_chk28;
         else
            nxt_add_chk_state28 = idle28;

      mac_addr_chk28:   // check if destination28 address match MAC28 switch28 address
         if (d_addr28 == mac_addr28)
            nxt_add_chk_state28 = idle28;  // return dest28 port as 5'b1_0000
         else
            nxt_add_chk_state28 = read_dest_add28;

      read_dest_add28:       // read data from memory using hash28 of destination28 address
            nxt_add_chk_state28 = valid_chk28;

      valid_chk28:      // check if read data had28 valid bit set
         nxt_add_chk_state28 = age_chk28;

      age_chk28:        // request age28 checker to check if still in date28
         if (age_confirmed28)
            nxt_add_chk_state28 = addr_chk28;
         else
            nxt_add_chk_state28 = age_chk28; 

      addr_chk28:       // perform28 compare between dest28 and read addresses28
            nxt_add_chk_state28 = read_src_add28; // return read port from ALUT28 mem

      read_src_add28:   // read from memory location28 about28 to be overwritten28
            nxt_add_chk_state28 = write_src28; 

      write_src28:      // write new source28 data (addr and port) to memory
            nxt_add_chk_state28 = idle28; 

      default:
            nxt_add_chk_state28 = idle28;
      endcase
   end


// destination28 check FSM28 current state
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
      add_chk_state28 <= idle28;
   else
      add_chk_state28 <= nxt_add_chk_state28;
   end



// -----------------------------------------------------------------------------
//   Generate28 returned value of port for sending28 new frame28 to
// -----------------------------------------------------------------------------
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
      d_port28 <= 5'b0_1111;
   else if ((add_chk_state28 == mac_addr_chk28) & (d_addr28 == mac_addr28))
      d_port28 <= 5'b1_0000;
   else if (((add_chk_state28 == valid_chk28) & ~mem_read_data_add28[82]) |
            ((add_chk_state28 == age_chk28) & ~(age_confirmed28 & age_ok28)) |
            ((add_chk_state28 == addr_chk28) & (d_addr28 != mem_read_data_add28[47:0])))
      d_port28 <= 5'b0_1111 & ~( 1 << s_port28 );
   else if ((add_chk_state28 == addr_chk28) & (d_addr28 == mem_read_data_add28[47:0]))
      d_port28 <= {1'b0, port_mem28} & ~( 1 << s_port28 );
   else
      d_port28 <= d_port28;
   end


// -----------------------------------------------------------------------------
//   convert read port source28 value from 2bits to bitwise28 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
      port_mem28 <= 4'b1111;
   else begin
      case (mem_read_data_add28[49:48])
         2'b00: port_mem28 <= 4'b0001;
         2'b01: port_mem28 <= 4'b0010;
         2'b10: port_mem28 <= 4'b0100;
         2'b11: port_mem28 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded28 off28 add_chk_state28
// -----------------------------------------------------------------------------
assign add_check_active28 = (add_chk_state28 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate28 memory addressing28 signals28.
//   The check address command will be taken28 as the indication28 from SW28 that the 
//   source28 fields (address and port) can be written28 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28) 
   begin
       mem_write_add28 <= 1'b0;
       mem_addr_add28  <= 8'd0;
   end
   else if (add_chk_state28 == read_dest_add28)
   begin
       mem_write_add28 <= 1'b0;
       mem_addr_add28  <= d_addr_hash28;
   end
// Need28 to set address two28 cycles28 before check
   else if ( (add_chk_state28 == age_chk28) && age_confirmed28 )
   begin
       mem_write_add28 <= 1'b0;
       mem_addr_add28  <= s_addr_hash28;
   end
   else if (add_chk_state28 == write_src28)
   begin
       mem_write_add28 <= 1'b1;
       mem_addr_add28  <= s_addr_hash28;
   end
   else
   begin
       mem_write_add28 <= 1'b0;
       mem_addr_add28  <= d_addr_hash28;
   end
   end


// -----------------------------------------------------------------------------
//   Generate28 databus28 for writing to memory
//   Data written28 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add28 = {1'b1, curr_time28, s_port28, s_addr28};



// -----------------------------------------------------------------------------
//   Evaluate28 read back data that is about28 to be overwritten28 with new source28 
//   address and port values. Decide28 whether28 the reused28 flag28 must be set and
//   last_inval28 address and port values updated.
//   reused28 needs28 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28) 
   begin
      reused28 <= 1'b0;
      lst_inv_addr_nrm28 <= 48'd0;
      lst_inv_port_nrm28 <= 2'd0;
   end
   else if ((add_chk_state28 == read_src_add28) & mem_read_data_add28[82] &
            (s_addr28 != mem_read_data_add28[47:0]))
   begin
      reused28 <= 1'b1;
      lst_inv_addr_nrm28 <= mem_read_data_add28[47:0];
      lst_inv_port_nrm28 <= mem_read_data_add28[49:48];
   end
   else if (clear_reused28)
   begin
      reused28 <= 1'b0;
      lst_inv_addr_nrm28 <= lst_inv_addr_nrm28;
      lst_inv_port_nrm28 <= lst_inv_addr_nrm28;
   end
   else 
   begin
      reused28 <= reused28;
      lst_inv_addr_nrm28 <= lst_inv_addr_nrm28;
      lst_inv_port_nrm28 <= lst_inv_addr_nrm28;
   end
   end


// -----------------------------------------------------------------------------
//   Generate28 signals28 for age28 checker to perform28 in-date28 check
// -----------------------------------------------------------------------------
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28) 
   begin
      check_age28 <= 1'b0;  
      last_accessed28 <= 32'd0;
   end
   else if (check_age28)
   begin
      check_age28 <= 1'b0;  
      last_accessed28 <= mem_read_data_add28[81:50];
   end
   else if (add_chk_state28 == age_chk28)
   begin
      check_age28 <= 1'b1;  
      last_accessed28 <= mem_read_data_add28[81:50];
   end
   else 
   begin
      check_age28 <= 1'b0;  
      last_accessed28 <= 32'd0;
   end
   end


`ifdef ABV_ON28

// psl28 default clock28 = (posedge pclk28);

// ASSERTION28 CHECKS28
/* Commented28 out as also checking in toplevel28
// it should never be possible28 for the destination28 port to indicate28 the MAC28
// switch28 address and one of the other 4 Ethernets28
// psl28 assert_valid_dest_port28 : assert never (d_port28[4] & |{d_port28[3:0]});


// COVER28 SANITY28 CHECKS28
// check all values of destination28 port can be returned.
// psl28 cover_d_port_028 : cover { d_port28 == 5'b0_0001 };
// psl28 cover_d_port_128 : cover { d_port28 == 5'b0_0010 };
// psl28 cover_d_port_228 : cover { d_port28 == 5'b0_0100 };
// psl28 cover_d_port_328 : cover { d_port28 == 5'b0_1000 };
// psl28 cover_d_port_428 : cover { d_port28 == 5'b1_0000 };
// psl28 cover_d_port_all28 : cover { d_port28 == 5'b0_1111 };
*/
`endif


endmodule 









