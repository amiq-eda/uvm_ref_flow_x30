//File29 name   : alut_addr_checker29.v
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


module alut_addr_checker29
(   
   // Inputs29
   pclk29,
   n_p_reset29,
   command,
   mac_addr29,
   d_addr29,
   s_addr29,
   s_port29,
   curr_time29,
   mem_read_data_add29,
   age_confirmed29,
   age_ok29,
   clear_reused29,

   //outputs29
   d_port29,
   add_check_active29,
   mem_addr_add29,
   mem_write_add29,
   mem_write_data_add29,
   lst_inv_addr_nrm29,
   lst_inv_port_nrm29,
   check_age29,
   last_accessed29,
   reused29
);



   input               pclk29;               // APB29 clock29                           
   input               n_p_reset29;          // Reset29                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr29;           // address of the switch29              
   input [47:0]        d_addr29;             // address of frame29 to be checked29     
   input [47:0]        s_addr29;             // address of frame29 to be stored29      
   input [1:0]         s_port29;             // source29 port of current frame29       
   input [31:0]        curr_time29;          // current time,for storing29 in mem    
   input [82:0]        mem_read_data_add29;  // read data from mem                 
   input               age_confirmed29;      // valid flag29 from age29 checker        
   input               age_ok29;             // result from age29 checker 
   input               clear_reused29;       // read/clear flag29 for reused29 signal29           

   output [4:0]        d_port29;             // calculated29 destination29 port for tx29 
   output              add_check_active29;   // bit 0 of status register           
   output [7:0]        mem_addr_add29;       // hash29 address for R/W29 to memory     
   output              mem_write_add29;      // R/W29 flag29 (write = high29)            
   output [82:0]       mem_write_data_add29; // write data for memory             
   output [47:0]       lst_inv_addr_nrm29;   // last invalidated29 addr normal29 op    
   output [1:0]        lst_inv_port_nrm29;   // last invalidated29 port normal29 op    
   output              check_age29;          // request flag29 for age29 check
   output [31:0]       last_accessed29;      // time field sent29 for age29 check
   output              reused29;             // indicates29 ALUT29 location29 overwritten29

   reg   [2:0]         add_chk_state29;      // current address checker state
   reg   [2:0]         nxt_add_chk_state29;  // current address checker state
   reg   [4:0]         d_port29;             // calculated29 destination29 port for tx29 
   reg   [3:0]         port_mem29;           // bitwise29 conversion29 of 2bit port
   reg   [7:0]         mem_addr_add29;       // hash29 address for R/W29 to memory
   reg                 mem_write_add29;      // R/W29 flag29 (write = high29)            
   reg                 reused29;             // indicates29 ALUT29 location29 overwritten29
   reg   [47:0]        lst_inv_addr_nrm29;   // last invalidated29 addr normal29 op    
   reg   [1:0]         lst_inv_port_nrm29;   // last invalidated29 port normal29 op    
   reg                 check_age29;          // request flag29 for age29 checker
   reg   [31:0]        last_accessed29;      // time field sent29 for age29 check


   wire   [7:0]        s_addr_hash29;        // hash29 of address for storing29
   wire   [7:0]        d_addr_hash29;        // hash29 of address for checking
   wire   [82:0]       mem_write_data_add29; // write data for memory  
   wire                add_check_active29;   // bit 0 of status register           


// Parameters29 for Address Checking29 FSM29 states29
   parameter idle29           = 3'b000;
   parameter mac_addr_chk29   = 3'b001;
   parameter read_dest_add29  = 3'b010;
   parameter valid_chk29      = 3'b011;
   parameter age_chk29        = 3'b100;
   parameter addr_chk29       = 3'b101;
   parameter read_src_add29   = 3'b110;
   parameter write_src29      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash29 conversion29 of source29 and destination29 addresses29
// -----------------------------------------------------------------------------
   assign s_addr_hash29 = s_addr29[7:0] ^ s_addr29[15:8] ^ s_addr29[23:16] ^
                        s_addr29[31:24] ^ s_addr29[39:32] ^ s_addr29[47:40];

   assign d_addr_hash29 = d_addr29[7:0] ^ d_addr29[15:8] ^ d_addr29[23:16] ^
                        d_addr29[31:24] ^ d_addr29[39:32] ^ d_addr29[47:40];



// -----------------------------------------------------------------------------
//   State29 Machine29 For29 handling29 the destination29 address checking process and
//   and storing29 of new source29 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state29 or age_confirmed29 or age_ok29)
   begin
      case (add_chk_state29)
      
      idle29:
         if (command == 2'b01)
            nxt_add_chk_state29 = mac_addr_chk29;
         else
            nxt_add_chk_state29 = idle29;

      mac_addr_chk29:   // check if destination29 address match MAC29 switch29 address
         if (d_addr29 == mac_addr29)
            nxt_add_chk_state29 = idle29;  // return dest29 port as 5'b1_0000
         else
            nxt_add_chk_state29 = read_dest_add29;

      read_dest_add29:       // read data from memory using hash29 of destination29 address
            nxt_add_chk_state29 = valid_chk29;

      valid_chk29:      // check if read data had29 valid bit set
         nxt_add_chk_state29 = age_chk29;

      age_chk29:        // request age29 checker to check if still in date29
         if (age_confirmed29)
            nxt_add_chk_state29 = addr_chk29;
         else
            nxt_add_chk_state29 = age_chk29; 

      addr_chk29:       // perform29 compare between dest29 and read addresses29
            nxt_add_chk_state29 = read_src_add29; // return read port from ALUT29 mem

      read_src_add29:   // read from memory location29 about29 to be overwritten29
            nxt_add_chk_state29 = write_src29; 

      write_src29:      // write new source29 data (addr and port) to memory
            nxt_add_chk_state29 = idle29; 

      default:
            nxt_add_chk_state29 = idle29;
      endcase
   end


// destination29 check FSM29 current state
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
      add_chk_state29 <= idle29;
   else
      add_chk_state29 <= nxt_add_chk_state29;
   end



// -----------------------------------------------------------------------------
//   Generate29 returned value of port for sending29 new frame29 to
// -----------------------------------------------------------------------------
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
      d_port29 <= 5'b0_1111;
   else if ((add_chk_state29 == mac_addr_chk29) & (d_addr29 == mac_addr29))
      d_port29 <= 5'b1_0000;
   else if (((add_chk_state29 == valid_chk29) & ~mem_read_data_add29[82]) |
            ((add_chk_state29 == age_chk29) & ~(age_confirmed29 & age_ok29)) |
            ((add_chk_state29 == addr_chk29) & (d_addr29 != mem_read_data_add29[47:0])))
      d_port29 <= 5'b0_1111 & ~( 1 << s_port29 );
   else if ((add_chk_state29 == addr_chk29) & (d_addr29 == mem_read_data_add29[47:0]))
      d_port29 <= {1'b0, port_mem29} & ~( 1 << s_port29 );
   else
      d_port29 <= d_port29;
   end


// -----------------------------------------------------------------------------
//   convert read port source29 value from 2bits to bitwise29 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
      port_mem29 <= 4'b1111;
   else begin
      case (mem_read_data_add29[49:48])
         2'b00: port_mem29 <= 4'b0001;
         2'b01: port_mem29 <= 4'b0010;
         2'b10: port_mem29 <= 4'b0100;
         2'b11: port_mem29 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded29 off29 add_chk_state29
// -----------------------------------------------------------------------------
assign add_check_active29 = (add_chk_state29 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate29 memory addressing29 signals29.
//   The check address command will be taken29 as the indication29 from SW29 that the 
//   source29 fields (address and port) can be written29 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29) 
   begin
       mem_write_add29 <= 1'b0;
       mem_addr_add29  <= 8'd0;
   end
   else if (add_chk_state29 == read_dest_add29)
   begin
       mem_write_add29 <= 1'b0;
       mem_addr_add29  <= d_addr_hash29;
   end
// Need29 to set address two29 cycles29 before check
   else if ( (add_chk_state29 == age_chk29) && age_confirmed29 )
   begin
       mem_write_add29 <= 1'b0;
       mem_addr_add29  <= s_addr_hash29;
   end
   else if (add_chk_state29 == write_src29)
   begin
       mem_write_add29 <= 1'b1;
       mem_addr_add29  <= s_addr_hash29;
   end
   else
   begin
       mem_write_add29 <= 1'b0;
       mem_addr_add29  <= d_addr_hash29;
   end
   end


// -----------------------------------------------------------------------------
//   Generate29 databus29 for writing to memory
//   Data written29 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add29 = {1'b1, curr_time29, s_port29, s_addr29};



// -----------------------------------------------------------------------------
//   Evaluate29 read back data that is about29 to be overwritten29 with new source29 
//   address and port values. Decide29 whether29 the reused29 flag29 must be set and
//   last_inval29 address and port values updated.
//   reused29 needs29 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29) 
   begin
      reused29 <= 1'b0;
      lst_inv_addr_nrm29 <= 48'd0;
      lst_inv_port_nrm29 <= 2'd0;
   end
   else if ((add_chk_state29 == read_src_add29) & mem_read_data_add29[82] &
            (s_addr29 != mem_read_data_add29[47:0]))
   begin
      reused29 <= 1'b1;
      lst_inv_addr_nrm29 <= mem_read_data_add29[47:0];
      lst_inv_port_nrm29 <= mem_read_data_add29[49:48];
   end
   else if (clear_reused29)
   begin
      reused29 <= 1'b0;
      lst_inv_addr_nrm29 <= lst_inv_addr_nrm29;
      lst_inv_port_nrm29 <= lst_inv_addr_nrm29;
   end
   else 
   begin
      reused29 <= reused29;
      lst_inv_addr_nrm29 <= lst_inv_addr_nrm29;
      lst_inv_port_nrm29 <= lst_inv_addr_nrm29;
   end
   end


// -----------------------------------------------------------------------------
//   Generate29 signals29 for age29 checker to perform29 in-date29 check
// -----------------------------------------------------------------------------
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29) 
   begin
      check_age29 <= 1'b0;  
      last_accessed29 <= 32'd0;
   end
   else if (check_age29)
   begin
      check_age29 <= 1'b0;  
      last_accessed29 <= mem_read_data_add29[81:50];
   end
   else if (add_chk_state29 == age_chk29)
   begin
      check_age29 <= 1'b1;  
      last_accessed29 <= mem_read_data_add29[81:50];
   end
   else 
   begin
      check_age29 <= 1'b0;  
      last_accessed29 <= 32'd0;
   end
   end


`ifdef ABV_ON29

// psl29 default clock29 = (posedge pclk29);

// ASSERTION29 CHECKS29
/* Commented29 out as also checking in toplevel29
// it should never be possible29 for the destination29 port to indicate29 the MAC29
// switch29 address and one of the other 4 Ethernets29
// psl29 assert_valid_dest_port29 : assert never (d_port29[4] & |{d_port29[3:0]});


// COVER29 SANITY29 CHECKS29
// check all values of destination29 port can be returned.
// psl29 cover_d_port_029 : cover { d_port29 == 5'b0_0001 };
// psl29 cover_d_port_129 : cover { d_port29 == 5'b0_0010 };
// psl29 cover_d_port_229 : cover { d_port29 == 5'b0_0100 };
// psl29 cover_d_port_329 : cover { d_port29 == 5'b0_1000 };
// psl29 cover_d_port_429 : cover { d_port29 == 5'b1_0000 };
// psl29 cover_d_port_all29 : cover { d_port29 == 5'b0_1111 };
*/
`endif


endmodule 









