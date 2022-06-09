//File16 name   : alut_addr_checker16.v
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


module alut_addr_checker16
(   
   // Inputs16
   pclk16,
   n_p_reset16,
   command,
   mac_addr16,
   d_addr16,
   s_addr16,
   s_port16,
   curr_time16,
   mem_read_data_add16,
   age_confirmed16,
   age_ok16,
   clear_reused16,

   //outputs16
   d_port16,
   add_check_active16,
   mem_addr_add16,
   mem_write_add16,
   mem_write_data_add16,
   lst_inv_addr_nrm16,
   lst_inv_port_nrm16,
   check_age16,
   last_accessed16,
   reused16
);



   input               pclk16;               // APB16 clock16                           
   input               n_p_reset16;          // Reset16                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr16;           // address of the switch16              
   input [47:0]        d_addr16;             // address of frame16 to be checked16     
   input [47:0]        s_addr16;             // address of frame16 to be stored16      
   input [1:0]         s_port16;             // source16 port of current frame16       
   input [31:0]        curr_time16;          // current time,for storing16 in mem    
   input [82:0]        mem_read_data_add16;  // read data from mem                 
   input               age_confirmed16;      // valid flag16 from age16 checker        
   input               age_ok16;             // result from age16 checker 
   input               clear_reused16;       // read/clear flag16 for reused16 signal16           

   output [4:0]        d_port16;             // calculated16 destination16 port for tx16 
   output              add_check_active16;   // bit 0 of status register           
   output [7:0]        mem_addr_add16;       // hash16 address for R/W16 to memory     
   output              mem_write_add16;      // R/W16 flag16 (write = high16)            
   output [82:0]       mem_write_data_add16; // write data for memory             
   output [47:0]       lst_inv_addr_nrm16;   // last invalidated16 addr normal16 op    
   output [1:0]        lst_inv_port_nrm16;   // last invalidated16 port normal16 op    
   output              check_age16;          // request flag16 for age16 check
   output [31:0]       last_accessed16;      // time field sent16 for age16 check
   output              reused16;             // indicates16 ALUT16 location16 overwritten16

   reg   [2:0]         add_chk_state16;      // current address checker state
   reg   [2:0]         nxt_add_chk_state16;  // current address checker state
   reg   [4:0]         d_port16;             // calculated16 destination16 port for tx16 
   reg   [3:0]         port_mem16;           // bitwise16 conversion16 of 2bit port
   reg   [7:0]         mem_addr_add16;       // hash16 address for R/W16 to memory
   reg                 mem_write_add16;      // R/W16 flag16 (write = high16)            
   reg                 reused16;             // indicates16 ALUT16 location16 overwritten16
   reg   [47:0]        lst_inv_addr_nrm16;   // last invalidated16 addr normal16 op    
   reg   [1:0]         lst_inv_port_nrm16;   // last invalidated16 port normal16 op    
   reg                 check_age16;          // request flag16 for age16 checker
   reg   [31:0]        last_accessed16;      // time field sent16 for age16 check


   wire   [7:0]        s_addr_hash16;        // hash16 of address for storing16
   wire   [7:0]        d_addr_hash16;        // hash16 of address for checking
   wire   [82:0]       mem_write_data_add16; // write data for memory  
   wire                add_check_active16;   // bit 0 of status register           


// Parameters16 for Address Checking16 FSM16 states16
   parameter idle16           = 3'b000;
   parameter mac_addr_chk16   = 3'b001;
   parameter read_dest_add16  = 3'b010;
   parameter valid_chk16      = 3'b011;
   parameter age_chk16        = 3'b100;
   parameter addr_chk16       = 3'b101;
   parameter read_src_add16   = 3'b110;
   parameter write_src16      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash16 conversion16 of source16 and destination16 addresses16
// -----------------------------------------------------------------------------
   assign s_addr_hash16 = s_addr16[7:0] ^ s_addr16[15:8] ^ s_addr16[23:16] ^
                        s_addr16[31:24] ^ s_addr16[39:32] ^ s_addr16[47:40];

   assign d_addr_hash16 = d_addr16[7:0] ^ d_addr16[15:8] ^ d_addr16[23:16] ^
                        d_addr16[31:24] ^ d_addr16[39:32] ^ d_addr16[47:40];



// -----------------------------------------------------------------------------
//   State16 Machine16 For16 handling16 the destination16 address checking process and
//   and storing16 of new source16 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state16 or age_confirmed16 or age_ok16)
   begin
      case (add_chk_state16)
      
      idle16:
         if (command == 2'b01)
            nxt_add_chk_state16 = mac_addr_chk16;
         else
            nxt_add_chk_state16 = idle16;

      mac_addr_chk16:   // check if destination16 address match MAC16 switch16 address
         if (d_addr16 == mac_addr16)
            nxt_add_chk_state16 = idle16;  // return dest16 port as 5'b1_0000
         else
            nxt_add_chk_state16 = read_dest_add16;

      read_dest_add16:       // read data from memory using hash16 of destination16 address
            nxt_add_chk_state16 = valid_chk16;

      valid_chk16:      // check if read data had16 valid bit set
         nxt_add_chk_state16 = age_chk16;

      age_chk16:        // request age16 checker to check if still in date16
         if (age_confirmed16)
            nxt_add_chk_state16 = addr_chk16;
         else
            nxt_add_chk_state16 = age_chk16; 

      addr_chk16:       // perform16 compare between dest16 and read addresses16
            nxt_add_chk_state16 = read_src_add16; // return read port from ALUT16 mem

      read_src_add16:   // read from memory location16 about16 to be overwritten16
            nxt_add_chk_state16 = write_src16; 

      write_src16:      // write new source16 data (addr and port) to memory
            nxt_add_chk_state16 = idle16; 

      default:
            nxt_add_chk_state16 = idle16;
      endcase
   end


// destination16 check FSM16 current state
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
      add_chk_state16 <= idle16;
   else
      add_chk_state16 <= nxt_add_chk_state16;
   end



// -----------------------------------------------------------------------------
//   Generate16 returned value of port for sending16 new frame16 to
// -----------------------------------------------------------------------------
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
      d_port16 <= 5'b0_1111;
   else if ((add_chk_state16 == mac_addr_chk16) & (d_addr16 == mac_addr16))
      d_port16 <= 5'b1_0000;
   else if (((add_chk_state16 == valid_chk16) & ~mem_read_data_add16[82]) |
            ((add_chk_state16 == age_chk16) & ~(age_confirmed16 & age_ok16)) |
            ((add_chk_state16 == addr_chk16) & (d_addr16 != mem_read_data_add16[47:0])))
      d_port16 <= 5'b0_1111 & ~( 1 << s_port16 );
   else if ((add_chk_state16 == addr_chk16) & (d_addr16 == mem_read_data_add16[47:0]))
      d_port16 <= {1'b0, port_mem16} & ~( 1 << s_port16 );
   else
      d_port16 <= d_port16;
   end


// -----------------------------------------------------------------------------
//   convert read port source16 value from 2bits to bitwise16 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
      port_mem16 <= 4'b1111;
   else begin
      case (mem_read_data_add16[49:48])
         2'b00: port_mem16 <= 4'b0001;
         2'b01: port_mem16 <= 4'b0010;
         2'b10: port_mem16 <= 4'b0100;
         2'b11: port_mem16 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded16 off16 add_chk_state16
// -----------------------------------------------------------------------------
assign add_check_active16 = (add_chk_state16 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate16 memory addressing16 signals16.
//   The check address command will be taken16 as the indication16 from SW16 that the 
//   source16 fields (address and port) can be written16 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16) 
   begin
       mem_write_add16 <= 1'b0;
       mem_addr_add16  <= 8'd0;
   end
   else if (add_chk_state16 == read_dest_add16)
   begin
       mem_write_add16 <= 1'b0;
       mem_addr_add16  <= d_addr_hash16;
   end
// Need16 to set address two16 cycles16 before check
   else if ( (add_chk_state16 == age_chk16) && age_confirmed16 )
   begin
       mem_write_add16 <= 1'b0;
       mem_addr_add16  <= s_addr_hash16;
   end
   else if (add_chk_state16 == write_src16)
   begin
       mem_write_add16 <= 1'b1;
       mem_addr_add16  <= s_addr_hash16;
   end
   else
   begin
       mem_write_add16 <= 1'b0;
       mem_addr_add16  <= d_addr_hash16;
   end
   end


// -----------------------------------------------------------------------------
//   Generate16 databus16 for writing to memory
//   Data written16 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add16 = {1'b1, curr_time16, s_port16, s_addr16};



// -----------------------------------------------------------------------------
//   Evaluate16 read back data that is about16 to be overwritten16 with new source16 
//   address and port values. Decide16 whether16 the reused16 flag16 must be set and
//   last_inval16 address and port values updated.
//   reused16 needs16 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16) 
   begin
      reused16 <= 1'b0;
      lst_inv_addr_nrm16 <= 48'd0;
      lst_inv_port_nrm16 <= 2'd0;
   end
   else if ((add_chk_state16 == read_src_add16) & mem_read_data_add16[82] &
            (s_addr16 != mem_read_data_add16[47:0]))
   begin
      reused16 <= 1'b1;
      lst_inv_addr_nrm16 <= mem_read_data_add16[47:0];
      lst_inv_port_nrm16 <= mem_read_data_add16[49:48];
   end
   else if (clear_reused16)
   begin
      reused16 <= 1'b0;
      lst_inv_addr_nrm16 <= lst_inv_addr_nrm16;
      lst_inv_port_nrm16 <= lst_inv_addr_nrm16;
   end
   else 
   begin
      reused16 <= reused16;
      lst_inv_addr_nrm16 <= lst_inv_addr_nrm16;
      lst_inv_port_nrm16 <= lst_inv_addr_nrm16;
   end
   end


// -----------------------------------------------------------------------------
//   Generate16 signals16 for age16 checker to perform16 in-date16 check
// -----------------------------------------------------------------------------
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16) 
   begin
      check_age16 <= 1'b0;  
      last_accessed16 <= 32'd0;
   end
   else if (check_age16)
   begin
      check_age16 <= 1'b0;  
      last_accessed16 <= mem_read_data_add16[81:50];
   end
   else if (add_chk_state16 == age_chk16)
   begin
      check_age16 <= 1'b1;  
      last_accessed16 <= mem_read_data_add16[81:50];
   end
   else 
   begin
      check_age16 <= 1'b0;  
      last_accessed16 <= 32'd0;
   end
   end


`ifdef ABV_ON16

// psl16 default clock16 = (posedge pclk16);

// ASSERTION16 CHECKS16
/* Commented16 out as also checking in toplevel16
// it should never be possible16 for the destination16 port to indicate16 the MAC16
// switch16 address and one of the other 4 Ethernets16
// psl16 assert_valid_dest_port16 : assert never (d_port16[4] & |{d_port16[3:0]});


// COVER16 SANITY16 CHECKS16
// check all values of destination16 port can be returned.
// psl16 cover_d_port_016 : cover { d_port16 == 5'b0_0001 };
// psl16 cover_d_port_116 : cover { d_port16 == 5'b0_0010 };
// psl16 cover_d_port_216 : cover { d_port16 == 5'b0_0100 };
// psl16 cover_d_port_316 : cover { d_port16 == 5'b0_1000 };
// psl16 cover_d_port_416 : cover { d_port16 == 5'b1_0000 };
// psl16 cover_d_port_all16 : cover { d_port16 == 5'b0_1111 };
*/
`endif


endmodule 









