//File24 name   : alut_addr_checker24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

// compiler24 directives24
`include "alut_defines24.v"


module alut_addr_checker24
(   
   // Inputs24
   pclk24,
   n_p_reset24,
   command,
   mac_addr24,
   d_addr24,
   s_addr24,
   s_port24,
   curr_time24,
   mem_read_data_add24,
   age_confirmed24,
   age_ok24,
   clear_reused24,

   //outputs24
   d_port24,
   add_check_active24,
   mem_addr_add24,
   mem_write_add24,
   mem_write_data_add24,
   lst_inv_addr_nrm24,
   lst_inv_port_nrm24,
   check_age24,
   last_accessed24,
   reused24
);



   input               pclk24;               // APB24 clock24                           
   input               n_p_reset24;          // Reset24                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr24;           // address of the switch24              
   input [47:0]        d_addr24;             // address of frame24 to be checked24     
   input [47:0]        s_addr24;             // address of frame24 to be stored24      
   input [1:0]         s_port24;             // source24 port of current frame24       
   input [31:0]        curr_time24;          // current time,for storing24 in mem    
   input [82:0]        mem_read_data_add24;  // read data from mem                 
   input               age_confirmed24;      // valid flag24 from age24 checker        
   input               age_ok24;             // result from age24 checker 
   input               clear_reused24;       // read/clear flag24 for reused24 signal24           

   output [4:0]        d_port24;             // calculated24 destination24 port for tx24 
   output              add_check_active24;   // bit 0 of status register           
   output [7:0]        mem_addr_add24;       // hash24 address for R/W24 to memory     
   output              mem_write_add24;      // R/W24 flag24 (write = high24)            
   output [82:0]       mem_write_data_add24; // write data for memory             
   output [47:0]       lst_inv_addr_nrm24;   // last invalidated24 addr normal24 op    
   output [1:0]        lst_inv_port_nrm24;   // last invalidated24 port normal24 op    
   output              check_age24;          // request flag24 for age24 check
   output [31:0]       last_accessed24;      // time field sent24 for age24 check
   output              reused24;             // indicates24 ALUT24 location24 overwritten24

   reg   [2:0]         add_chk_state24;      // current address checker state
   reg   [2:0]         nxt_add_chk_state24;  // current address checker state
   reg   [4:0]         d_port24;             // calculated24 destination24 port for tx24 
   reg   [3:0]         port_mem24;           // bitwise24 conversion24 of 2bit port
   reg   [7:0]         mem_addr_add24;       // hash24 address for R/W24 to memory
   reg                 mem_write_add24;      // R/W24 flag24 (write = high24)            
   reg                 reused24;             // indicates24 ALUT24 location24 overwritten24
   reg   [47:0]        lst_inv_addr_nrm24;   // last invalidated24 addr normal24 op    
   reg   [1:0]         lst_inv_port_nrm24;   // last invalidated24 port normal24 op    
   reg                 check_age24;          // request flag24 for age24 checker
   reg   [31:0]        last_accessed24;      // time field sent24 for age24 check


   wire   [7:0]        s_addr_hash24;        // hash24 of address for storing24
   wire   [7:0]        d_addr_hash24;        // hash24 of address for checking
   wire   [82:0]       mem_write_data_add24; // write data for memory  
   wire                add_check_active24;   // bit 0 of status register           


// Parameters24 for Address Checking24 FSM24 states24
   parameter idle24           = 3'b000;
   parameter mac_addr_chk24   = 3'b001;
   parameter read_dest_add24  = 3'b010;
   parameter valid_chk24      = 3'b011;
   parameter age_chk24        = 3'b100;
   parameter addr_chk24       = 3'b101;
   parameter read_src_add24   = 3'b110;
   parameter write_src24      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash24 conversion24 of source24 and destination24 addresses24
// -----------------------------------------------------------------------------
   assign s_addr_hash24 = s_addr24[7:0] ^ s_addr24[15:8] ^ s_addr24[23:16] ^
                        s_addr24[31:24] ^ s_addr24[39:32] ^ s_addr24[47:40];

   assign d_addr_hash24 = d_addr24[7:0] ^ d_addr24[15:8] ^ d_addr24[23:16] ^
                        d_addr24[31:24] ^ d_addr24[39:32] ^ d_addr24[47:40];



// -----------------------------------------------------------------------------
//   State24 Machine24 For24 handling24 the destination24 address checking process and
//   and storing24 of new source24 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state24 or age_confirmed24 or age_ok24)
   begin
      case (add_chk_state24)
      
      idle24:
         if (command == 2'b01)
            nxt_add_chk_state24 = mac_addr_chk24;
         else
            nxt_add_chk_state24 = idle24;

      mac_addr_chk24:   // check if destination24 address match MAC24 switch24 address
         if (d_addr24 == mac_addr24)
            nxt_add_chk_state24 = idle24;  // return dest24 port as 5'b1_0000
         else
            nxt_add_chk_state24 = read_dest_add24;

      read_dest_add24:       // read data from memory using hash24 of destination24 address
            nxt_add_chk_state24 = valid_chk24;

      valid_chk24:      // check if read data had24 valid bit set
         nxt_add_chk_state24 = age_chk24;

      age_chk24:        // request age24 checker to check if still in date24
         if (age_confirmed24)
            nxt_add_chk_state24 = addr_chk24;
         else
            nxt_add_chk_state24 = age_chk24; 

      addr_chk24:       // perform24 compare between dest24 and read addresses24
            nxt_add_chk_state24 = read_src_add24; // return read port from ALUT24 mem

      read_src_add24:   // read from memory location24 about24 to be overwritten24
            nxt_add_chk_state24 = write_src24; 

      write_src24:      // write new source24 data (addr and port) to memory
            nxt_add_chk_state24 = idle24; 

      default:
            nxt_add_chk_state24 = idle24;
      endcase
   end


// destination24 check FSM24 current state
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
      add_chk_state24 <= idle24;
   else
      add_chk_state24 <= nxt_add_chk_state24;
   end



// -----------------------------------------------------------------------------
//   Generate24 returned value of port for sending24 new frame24 to
// -----------------------------------------------------------------------------
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
      d_port24 <= 5'b0_1111;
   else if ((add_chk_state24 == mac_addr_chk24) & (d_addr24 == mac_addr24))
      d_port24 <= 5'b1_0000;
   else if (((add_chk_state24 == valid_chk24) & ~mem_read_data_add24[82]) |
            ((add_chk_state24 == age_chk24) & ~(age_confirmed24 & age_ok24)) |
            ((add_chk_state24 == addr_chk24) & (d_addr24 != mem_read_data_add24[47:0])))
      d_port24 <= 5'b0_1111 & ~( 1 << s_port24 );
   else if ((add_chk_state24 == addr_chk24) & (d_addr24 == mem_read_data_add24[47:0]))
      d_port24 <= {1'b0, port_mem24} & ~( 1 << s_port24 );
   else
      d_port24 <= d_port24;
   end


// -----------------------------------------------------------------------------
//   convert read port source24 value from 2bits to bitwise24 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
      port_mem24 <= 4'b1111;
   else begin
      case (mem_read_data_add24[49:48])
         2'b00: port_mem24 <= 4'b0001;
         2'b01: port_mem24 <= 4'b0010;
         2'b10: port_mem24 <= 4'b0100;
         2'b11: port_mem24 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded24 off24 add_chk_state24
// -----------------------------------------------------------------------------
assign add_check_active24 = (add_chk_state24 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate24 memory addressing24 signals24.
//   The check address command will be taken24 as the indication24 from SW24 that the 
//   source24 fields (address and port) can be written24 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24) 
   begin
       mem_write_add24 <= 1'b0;
       mem_addr_add24  <= 8'd0;
   end
   else if (add_chk_state24 == read_dest_add24)
   begin
       mem_write_add24 <= 1'b0;
       mem_addr_add24  <= d_addr_hash24;
   end
// Need24 to set address two24 cycles24 before check
   else if ( (add_chk_state24 == age_chk24) && age_confirmed24 )
   begin
       mem_write_add24 <= 1'b0;
       mem_addr_add24  <= s_addr_hash24;
   end
   else if (add_chk_state24 == write_src24)
   begin
       mem_write_add24 <= 1'b1;
       mem_addr_add24  <= s_addr_hash24;
   end
   else
   begin
       mem_write_add24 <= 1'b0;
       mem_addr_add24  <= d_addr_hash24;
   end
   end


// -----------------------------------------------------------------------------
//   Generate24 databus24 for writing to memory
//   Data written24 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add24 = {1'b1, curr_time24, s_port24, s_addr24};



// -----------------------------------------------------------------------------
//   Evaluate24 read back data that is about24 to be overwritten24 with new source24 
//   address and port values. Decide24 whether24 the reused24 flag24 must be set and
//   last_inval24 address and port values updated.
//   reused24 needs24 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24) 
   begin
      reused24 <= 1'b0;
      lst_inv_addr_nrm24 <= 48'd0;
      lst_inv_port_nrm24 <= 2'd0;
   end
   else if ((add_chk_state24 == read_src_add24) & mem_read_data_add24[82] &
            (s_addr24 != mem_read_data_add24[47:0]))
   begin
      reused24 <= 1'b1;
      lst_inv_addr_nrm24 <= mem_read_data_add24[47:0];
      lst_inv_port_nrm24 <= mem_read_data_add24[49:48];
   end
   else if (clear_reused24)
   begin
      reused24 <= 1'b0;
      lst_inv_addr_nrm24 <= lst_inv_addr_nrm24;
      lst_inv_port_nrm24 <= lst_inv_addr_nrm24;
   end
   else 
   begin
      reused24 <= reused24;
      lst_inv_addr_nrm24 <= lst_inv_addr_nrm24;
      lst_inv_port_nrm24 <= lst_inv_addr_nrm24;
   end
   end


// -----------------------------------------------------------------------------
//   Generate24 signals24 for age24 checker to perform24 in-date24 check
// -----------------------------------------------------------------------------
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24) 
   begin
      check_age24 <= 1'b0;  
      last_accessed24 <= 32'd0;
   end
   else if (check_age24)
   begin
      check_age24 <= 1'b0;  
      last_accessed24 <= mem_read_data_add24[81:50];
   end
   else if (add_chk_state24 == age_chk24)
   begin
      check_age24 <= 1'b1;  
      last_accessed24 <= mem_read_data_add24[81:50];
   end
   else 
   begin
      check_age24 <= 1'b0;  
      last_accessed24 <= 32'd0;
   end
   end


`ifdef ABV_ON24

// psl24 default clock24 = (posedge pclk24);

// ASSERTION24 CHECKS24
/* Commented24 out as also checking in toplevel24
// it should never be possible24 for the destination24 port to indicate24 the MAC24
// switch24 address and one of the other 4 Ethernets24
// psl24 assert_valid_dest_port24 : assert never (d_port24[4] & |{d_port24[3:0]});


// COVER24 SANITY24 CHECKS24
// check all values of destination24 port can be returned.
// psl24 cover_d_port_024 : cover { d_port24 == 5'b0_0001 };
// psl24 cover_d_port_124 : cover { d_port24 == 5'b0_0010 };
// psl24 cover_d_port_224 : cover { d_port24 == 5'b0_0100 };
// psl24 cover_d_port_324 : cover { d_port24 == 5'b0_1000 };
// psl24 cover_d_port_424 : cover { d_port24 == 5'b1_0000 };
// psl24 cover_d_port_all24 : cover { d_port24 == 5'b0_1111 };
*/
`endif


endmodule 









