//File17 name   : alut_addr_checker17.v
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


module alut_addr_checker17
(   
   // Inputs17
   pclk17,
   n_p_reset17,
   command,
   mac_addr17,
   d_addr17,
   s_addr17,
   s_port17,
   curr_time17,
   mem_read_data_add17,
   age_confirmed17,
   age_ok17,
   clear_reused17,

   //outputs17
   d_port17,
   add_check_active17,
   mem_addr_add17,
   mem_write_add17,
   mem_write_data_add17,
   lst_inv_addr_nrm17,
   lst_inv_port_nrm17,
   check_age17,
   last_accessed17,
   reused17
);



   input               pclk17;               // APB17 clock17                           
   input               n_p_reset17;          // Reset17                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr17;           // address of the switch17              
   input [47:0]        d_addr17;             // address of frame17 to be checked17     
   input [47:0]        s_addr17;             // address of frame17 to be stored17      
   input [1:0]         s_port17;             // source17 port of current frame17       
   input [31:0]        curr_time17;          // current time,for storing17 in mem    
   input [82:0]        mem_read_data_add17;  // read data from mem                 
   input               age_confirmed17;      // valid flag17 from age17 checker        
   input               age_ok17;             // result from age17 checker 
   input               clear_reused17;       // read/clear flag17 for reused17 signal17           

   output [4:0]        d_port17;             // calculated17 destination17 port for tx17 
   output              add_check_active17;   // bit 0 of status register           
   output [7:0]        mem_addr_add17;       // hash17 address for R/W17 to memory     
   output              mem_write_add17;      // R/W17 flag17 (write = high17)            
   output [82:0]       mem_write_data_add17; // write data for memory             
   output [47:0]       lst_inv_addr_nrm17;   // last invalidated17 addr normal17 op    
   output [1:0]        lst_inv_port_nrm17;   // last invalidated17 port normal17 op    
   output              check_age17;          // request flag17 for age17 check
   output [31:0]       last_accessed17;      // time field sent17 for age17 check
   output              reused17;             // indicates17 ALUT17 location17 overwritten17

   reg   [2:0]         add_chk_state17;      // current address checker state
   reg   [2:0]         nxt_add_chk_state17;  // current address checker state
   reg   [4:0]         d_port17;             // calculated17 destination17 port for tx17 
   reg   [3:0]         port_mem17;           // bitwise17 conversion17 of 2bit port
   reg   [7:0]         mem_addr_add17;       // hash17 address for R/W17 to memory
   reg                 mem_write_add17;      // R/W17 flag17 (write = high17)            
   reg                 reused17;             // indicates17 ALUT17 location17 overwritten17
   reg   [47:0]        lst_inv_addr_nrm17;   // last invalidated17 addr normal17 op    
   reg   [1:0]         lst_inv_port_nrm17;   // last invalidated17 port normal17 op    
   reg                 check_age17;          // request flag17 for age17 checker
   reg   [31:0]        last_accessed17;      // time field sent17 for age17 check


   wire   [7:0]        s_addr_hash17;        // hash17 of address for storing17
   wire   [7:0]        d_addr_hash17;        // hash17 of address for checking
   wire   [82:0]       mem_write_data_add17; // write data for memory  
   wire                add_check_active17;   // bit 0 of status register           


// Parameters17 for Address Checking17 FSM17 states17
   parameter idle17           = 3'b000;
   parameter mac_addr_chk17   = 3'b001;
   parameter read_dest_add17  = 3'b010;
   parameter valid_chk17      = 3'b011;
   parameter age_chk17        = 3'b100;
   parameter addr_chk17       = 3'b101;
   parameter read_src_add17   = 3'b110;
   parameter write_src17      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash17 conversion17 of source17 and destination17 addresses17
// -----------------------------------------------------------------------------
   assign s_addr_hash17 = s_addr17[7:0] ^ s_addr17[15:8] ^ s_addr17[23:16] ^
                        s_addr17[31:24] ^ s_addr17[39:32] ^ s_addr17[47:40];

   assign d_addr_hash17 = d_addr17[7:0] ^ d_addr17[15:8] ^ d_addr17[23:16] ^
                        d_addr17[31:24] ^ d_addr17[39:32] ^ d_addr17[47:40];



// -----------------------------------------------------------------------------
//   State17 Machine17 For17 handling17 the destination17 address checking process and
//   and storing17 of new source17 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state17 or age_confirmed17 or age_ok17)
   begin
      case (add_chk_state17)
      
      idle17:
         if (command == 2'b01)
            nxt_add_chk_state17 = mac_addr_chk17;
         else
            nxt_add_chk_state17 = idle17;

      mac_addr_chk17:   // check if destination17 address match MAC17 switch17 address
         if (d_addr17 == mac_addr17)
            nxt_add_chk_state17 = idle17;  // return dest17 port as 5'b1_0000
         else
            nxt_add_chk_state17 = read_dest_add17;

      read_dest_add17:       // read data from memory using hash17 of destination17 address
            nxt_add_chk_state17 = valid_chk17;

      valid_chk17:      // check if read data had17 valid bit set
         nxt_add_chk_state17 = age_chk17;

      age_chk17:        // request age17 checker to check if still in date17
         if (age_confirmed17)
            nxt_add_chk_state17 = addr_chk17;
         else
            nxt_add_chk_state17 = age_chk17; 

      addr_chk17:       // perform17 compare between dest17 and read addresses17
            nxt_add_chk_state17 = read_src_add17; // return read port from ALUT17 mem

      read_src_add17:   // read from memory location17 about17 to be overwritten17
            nxt_add_chk_state17 = write_src17; 

      write_src17:      // write new source17 data (addr and port) to memory
            nxt_add_chk_state17 = idle17; 

      default:
            nxt_add_chk_state17 = idle17;
      endcase
   end


// destination17 check FSM17 current state
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
      add_chk_state17 <= idle17;
   else
      add_chk_state17 <= nxt_add_chk_state17;
   end



// -----------------------------------------------------------------------------
//   Generate17 returned value of port for sending17 new frame17 to
// -----------------------------------------------------------------------------
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
      d_port17 <= 5'b0_1111;
   else if ((add_chk_state17 == mac_addr_chk17) & (d_addr17 == mac_addr17))
      d_port17 <= 5'b1_0000;
   else if (((add_chk_state17 == valid_chk17) & ~mem_read_data_add17[82]) |
            ((add_chk_state17 == age_chk17) & ~(age_confirmed17 & age_ok17)) |
            ((add_chk_state17 == addr_chk17) & (d_addr17 != mem_read_data_add17[47:0])))
      d_port17 <= 5'b0_1111 & ~( 1 << s_port17 );
   else if ((add_chk_state17 == addr_chk17) & (d_addr17 == mem_read_data_add17[47:0]))
      d_port17 <= {1'b0, port_mem17} & ~( 1 << s_port17 );
   else
      d_port17 <= d_port17;
   end


// -----------------------------------------------------------------------------
//   convert read port source17 value from 2bits to bitwise17 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
      port_mem17 <= 4'b1111;
   else begin
      case (mem_read_data_add17[49:48])
         2'b00: port_mem17 <= 4'b0001;
         2'b01: port_mem17 <= 4'b0010;
         2'b10: port_mem17 <= 4'b0100;
         2'b11: port_mem17 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded17 off17 add_chk_state17
// -----------------------------------------------------------------------------
assign add_check_active17 = (add_chk_state17 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate17 memory addressing17 signals17.
//   The check address command will be taken17 as the indication17 from SW17 that the 
//   source17 fields (address and port) can be written17 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17) 
   begin
       mem_write_add17 <= 1'b0;
       mem_addr_add17  <= 8'd0;
   end
   else if (add_chk_state17 == read_dest_add17)
   begin
       mem_write_add17 <= 1'b0;
       mem_addr_add17  <= d_addr_hash17;
   end
// Need17 to set address two17 cycles17 before check
   else if ( (add_chk_state17 == age_chk17) && age_confirmed17 )
   begin
       mem_write_add17 <= 1'b0;
       mem_addr_add17  <= s_addr_hash17;
   end
   else if (add_chk_state17 == write_src17)
   begin
       mem_write_add17 <= 1'b1;
       mem_addr_add17  <= s_addr_hash17;
   end
   else
   begin
       mem_write_add17 <= 1'b0;
       mem_addr_add17  <= d_addr_hash17;
   end
   end


// -----------------------------------------------------------------------------
//   Generate17 databus17 for writing to memory
//   Data written17 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add17 = {1'b1, curr_time17, s_port17, s_addr17};



// -----------------------------------------------------------------------------
//   Evaluate17 read back data that is about17 to be overwritten17 with new source17 
//   address and port values. Decide17 whether17 the reused17 flag17 must be set and
//   last_inval17 address and port values updated.
//   reused17 needs17 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17) 
   begin
      reused17 <= 1'b0;
      lst_inv_addr_nrm17 <= 48'd0;
      lst_inv_port_nrm17 <= 2'd0;
   end
   else if ((add_chk_state17 == read_src_add17) & mem_read_data_add17[82] &
            (s_addr17 != mem_read_data_add17[47:0]))
   begin
      reused17 <= 1'b1;
      lst_inv_addr_nrm17 <= mem_read_data_add17[47:0];
      lst_inv_port_nrm17 <= mem_read_data_add17[49:48];
   end
   else if (clear_reused17)
   begin
      reused17 <= 1'b0;
      lst_inv_addr_nrm17 <= lst_inv_addr_nrm17;
      lst_inv_port_nrm17 <= lst_inv_addr_nrm17;
   end
   else 
   begin
      reused17 <= reused17;
      lst_inv_addr_nrm17 <= lst_inv_addr_nrm17;
      lst_inv_port_nrm17 <= lst_inv_addr_nrm17;
   end
   end


// -----------------------------------------------------------------------------
//   Generate17 signals17 for age17 checker to perform17 in-date17 check
// -----------------------------------------------------------------------------
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17) 
   begin
      check_age17 <= 1'b0;  
      last_accessed17 <= 32'd0;
   end
   else if (check_age17)
   begin
      check_age17 <= 1'b0;  
      last_accessed17 <= mem_read_data_add17[81:50];
   end
   else if (add_chk_state17 == age_chk17)
   begin
      check_age17 <= 1'b1;  
      last_accessed17 <= mem_read_data_add17[81:50];
   end
   else 
   begin
      check_age17 <= 1'b0;  
      last_accessed17 <= 32'd0;
   end
   end


`ifdef ABV_ON17

// psl17 default clock17 = (posedge pclk17);

// ASSERTION17 CHECKS17
/* Commented17 out as also checking in toplevel17
// it should never be possible17 for the destination17 port to indicate17 the MAC17
// switch17 address and one of the other 4 Ethernets17
// psl17 assert_valid_dest_port17 : assert never (d_port17[4] & |{d_port17[3:0]});


// COVER17 SANITY17 CHECKS17
// check all values of destination17 port can be returned.
// psl17 cover_d_port_017 : cover { d_port17 == 5'b0_0001 };
// psl17 cover_d_port_117 : cover { d_port17 == 5'b0_0010 };
// psl17 cover_d_port_217 : cover { d_port17 == 5'b0_0100 };
// psl17 cover_d_port_317 : cover { d_port17 == 5'b0_1000 };
// psl17 cover_d_port_417 : cover { d_port17 == 5'b1_0000 };
// psl17 cover_d_port_all17 : cover { d_port17 == 5'b0_1111 };
*/
`endif


endmodule 









