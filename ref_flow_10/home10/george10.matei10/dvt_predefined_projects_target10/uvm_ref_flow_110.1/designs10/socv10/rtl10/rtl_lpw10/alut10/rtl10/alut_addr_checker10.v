//File10 name   : alut_addr_checker10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

// compiler10 directives10
`include "alut_defines10.v"


module alut_addr_checker10
(   
   // Inputs10
   pclk10,
   n_p_reset10,
   command,
   mac_addr10,
   d_addr10,
   s_addr10,
   s_port10,
   curr_time10,
   mem_read_data_add10,
   age_confirmed10,
   age_ok10,
   clear_reused10,

   //outputs10
   d_port10,
   add_check_active10,
   mem_addr_add10,
   mem_write_add10,
   mem_write_data_add10,
   lst_inv_addr_nrm10,
   lst_inv_port_nrm10,
   check_age10,
   last_accessed10,
   reused10
);



   input               pclk10;               // APB10 clock10                           
   input               n_p_reset10;          // Reset10                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr10;           // address of the switch10              
   input [47:0]        d_addr10;             // address of frame10 to be checked10     
   input [47:0]        s_addr10;             // address of frame10 to be stored10      
   input [1:0]         s_port10;             // source10 port of current frame10       
   input [31:0]        curr_time10;          // current time,for storing10 in mem    
   input [82:0]        mem_read_data_add10;  // read data from mem                 
   input               age_confirmed10;      // valid flag10 from age10 checker        
   input               age_ok10;             // result from age10 checker 
   input               clear_reused10;       // read/clear flag10 for reused10 signal10           

   output [4:0]        d_port10;             // calculated10 destination10 port for tx10 
   output              add_check_active10;   // bit 0 of status register           
   output [7:0]        mem_addr_add10;       // hash10 address for R/W10 to memory     
   output              mem_write_add10;      // R/W10 flag10 (write = high10)            
   output [82:0]       mem_write_data_add10; // write data for memory             
   output [47:0]       lst_inv_addr_nrm10;   // last invalidated10 addr normal10 op    
   output [1:0]        lst_inv_port_nrm10;   // last invalidated10 port normal10 op    
   output              check_age10;          // request flag10 for age10 check
   output [31:0]       last_accessed10;      // time field sent10 for age10 check
   output              reused10;             // indicates10 ALUT10 location10 overwritten10

   reg   [2:0]         add_chk_state10;      // current address checker state
   reg   [2:0]         nxt_add_chk_state10;  // current address checker state
   reg   [4:0]         d_port10;             // calculated10 destination10 port for tx10 
   reg   [3:0]         port_mem10;           // bitwise10 conversion10 of 2bit port
   reg   [7:0]         mem_addr_add10;       // hash10 address for R/W10 to memory
   reg                 mem_write_add10;      // R/W10 flag10 (write = high10)            
   reg                 reused10;             // indicates10 ALUT10 location10 overwritten10
   reg   [47:0]        lst_inv_addr_nrm10;   // last invalidated10 addr normal10 op    
   reg   [1:0]         lst_inv_port_nrm10;   // last invalidated10 port normal10 op    
   reg                 check_age10;          // request flag10 for age10 checker
   reg   [31:0]        last_accessed10;      // time field sent10 for age10 check


   wire   [7:0]        s_addr_hash10;        // hash10 of address for storing10
   wire   [7:0]        d_addr_hash10;        // hash10 of address for checking
   wire   [82:0]       mem_write_data_add10; // write data for memory  
   wire                add_check_active10;   // bit 0 of status register           


// Parameters10 for Address Checking10 FSM10 states10
   parameter idle10           = 3'b000;
   parameter mac_addr_chk10   = 3'b001;
   parameter read_dest_add10  = 3'b010;
   parameter valid_chk10      = 3'b011;
   parameter age_chk10        = 3'b100;
   parameter addr_chk10       = 3'b101;
   parameter read_src_add10   = 3'b110;
   parameter write_src10      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash10 conversion10 of source10 and destination10 addresses10
// -----------------------------------------------------------------------------
   assign s_addr_hash10 = s_addr10[7:0] ^ s_addr10[15:8] ^ s_addr10[23:16] ^
                        s_addr10[31:24] ^ s_addr10[39:32] ^ s_addr10[47:40];

   assign d_addr_hash10 = d_addr10[7:0] ^ d_addr10[15:8] ^ d_addr10[23:16] ^
                        d_addr10[31:24] ^ d_addr10[39:32] ^ d_addr10[47:40];



// -----------------------------------------------------------------------------
//   State10 Machine10 For10 handling10 the destination10 address checking process and
//   and storing10 of new source10 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state10 or age_confirmed10 or age_ok10)
   begin
      case (add_chk_state10)
      
      idle10:
         if (command == 2'b01)
            nxt_add_chk_state10 = mac_addr_chk10;
         else
            nxt_add_chk_state10 = idle10;

      mac_addr_chk10:   // check if destination10 address match MAC10 switch10 address
         if (d_addr10 == mac_addr10)
            nxt_add_chk_state10 = idle10;  // return dest10 port as 5'b1_0000
         else
            nxt_add_chk_state10 = read_dest_add10;

      read_dest_add10:       // read data from memory using hash10 of destination10 address
            nxt_add_chk_state10 = valid_chk10;

      valid_chk10:      // check if read data had10 valid bit set
         nxt_add_chk_state10 = age_chk10;

      age_chk10:        // request age10 checker to check if still in date10
         if (age_confirmed10)
            nxt_add_chk_state10 = addr_chk10;
         else
            nxt_add_chk_state10 = age_chk10; 

      addr_chk10:       // perform10 compare between dest10 and read addresses10
            nxt_add_chk_state10 = read_src_add10; // return read port from ALUT10 mem

      read_src_add10:   // read from memory location10 about10 to be overwritten10
            nxt_add_chk_state10 = write_src10; 

      write_src10:      // write new source10 data (addr and port) to memory
            nxt_add_chk_state10 = idle10; 

      default:
            nxt_add_chk_state10 = idle10;
      endcase
   end


// destination10 check FSM10 current state
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
      add_chk_state10 <= idle10;
   else
      add_chk_state10 <= nxt_add_chk_state10;
   end



// -----------------------------------------------------------------------------
//   Generate10 returned value of port for sending10 new frame10 to
// -----------------------------------------------------------------------------
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
      d_port10 <= 5'b0_1111;
   else if ((add_chk_state10 == mac_addr_chk10) & (d_addr10 == mac_addr10))
      d_port10 <= 5'b1_0000;
   else if (((add_chk_state10 == valid_chk10) & ~mem_read_data_add10[82]) |
            ((add_chk_state10 == age_chk10) & ~(age_confirmed10 & age_ok10)) |
            ((add_chk_state10 == addr_chk10) & (d_addr10 != mem_read_data_add10[47:0])))
      d_port10 <= 5'b0_1111 & ~( 1 << s_port10 );
   else if ((add_chk_state10 == addr_chk10) & (d_addr10 == mem_read_data_add10[47:0]))
      d_port10 <= {1'b0, port_mem10} & ~( 1 << s_port10 );
   else
      d_port10 <= d_port10;
   end


// -----------------------------------------------------------------------------
//   convert read port source10 value from 2bits to bitwise10 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
      port_mem10 <= 4'b1111;
   else begin
      case (mem_read_data_add10[49:48])
         2'b00: port_mem10 <= 4'b0001;
         2'b01: port_mem10 <= 4'b0010;
         2'b10: port_mem10 <= 4'b0100;
         2'b11: port_mem10 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded10 off10 add_chk_state10
// -----------------------------------------------------------------------------
assign add_check_active10 = (add_chk_state10 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate10 memory addressing10 signals10.
//   The check address command will be taken10 as the indication10 from SW10 that the 
//   source10 fields (address and port) can be written10 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10) 
   begin
       mem_write_add10 <= 1'b0;
       mem_addr_add10  <= 8'd0;
   end
   else if (add_chk_state10 == read_dest_add10)
   begin
       mem_write_add10 <= 1'b0;
       mem_addr_add10  <= d_addr_hash10;
   end
// Need10 to set address two10 cycles10 before check
   else if ( (add_chk_state10 == age_chk10) && age_confirmed10 )
   begin
       mem_write_add10 <= 1'b0;
       mem_addr_add10  <= s_addr_hash10;
   end
   else if (add_chk_state10 == write_src10)
   begin
       mem_write_add10 <= 1'b1;
       mem_addr_add10  <= s_addr_hash10;
   end
   else
   begin
       mem_write_add10 <= 1'b0;
       mem_addr_add10  <= d_addr_hash10;
   end
   end


// -----------------------------------------------------------------------------
//   Generate10 databus10 for writing to memory
//   Data written10 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add10 = {1'b1, curr_time10, s_port10, s_addr10};



// -----------------------------------------------------------------------------
//   Evaluate10 read back data that is about10 to be overwritten10 with new source10 
//   address and port values. Decide10 whether10 the reused10 flag10 must be set and
//   last_inval10 address and port values updated.
//   reused10 needs10 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10) 
   begin
      reused10 <= 1'b0;
      lst_inv_addr_nrm10 <= 48'd0;
      lst_inv_port_nrm10 <= 2'd0;
   end
   else if ((add_chk_state10 == read_src_add10) & mem_read_data_add10[82] &
            (s_addr10 != mem_read_data_add10[47:0]))
   begin
      reused10 <= 1'b1;
      lst_inv_addr_nrm10 <= mem_read_data_add10[47:0];
      lst_inv_port_nrm10 <= mem_read_data_add10[49:48];
   end
   else if (clear_reused10)
   begin
      reused10 <= 1'b0;
      lst_inv_addr_nrm10 <= lst_inv_addr_nrm10;
      lst_inv_port_nrm10 <= lst_inv_addr_nrm10;
   end
   else 
   begin
      reused10 <= reused10;
      lst_inv_addr_nrm10 <= lst_inv_addr_nrm10;
      lst_inv_port_nrm10 <= lst_inv_addr_nrm10;
   end
   end


// -----------------------------------------------------------------------------
//   Generate10 signals10 for age10 checker to perform10 in-date10 check
// -----------------------------------------------------------------------------
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10) 
   begin
      check_age10 <= 1'b0;  
      last_accessed10 <= 32'd0;
   end
   else if (check_age10)
   begin
      check_age10 <= 1'b0;  
      last_accessed10 <= mem_read_data_add10[81:50];
   end
   else if (add_chk_state10 == age_chk10)
   begin
      check_age10 <= 1'b1;  
      last_accessed10 <= mem_read_data_add10[81:50];
   end
   else 
   begin
      check_age10 <= 1'b0;  
      last_accessed10 <= 32'd0;
   end
   end


`ifdef ABV_ON10

// psl10 default clock10 = (posedge pclk10);

// ASSERTION10 CHECKS10
/* Commented10 out as also checking in toplevel10
// it should never be possible10 for the destination10 port to indicate10 the MAC10
// switch10 address and one of the other 4 Ethernets10
// psl10 assert_valid_dest_port10 : assert never (d_port10[4] & |{d_port10[3:0]});


// COVER10 SANITY10 CHECKS10
// check all values of destination10 port can be returned.
// psl10 cover_d_port_010 : cover { d_port10 == 5'b0_0001 };
// psl10 cover_d_port_110 : cover { d_port10 == 5'b0_0010 };
// psl10 cover_d_port_210 : cover { d_port10 == 5'b0_0100 };
// psl10 cover_d_port_310 : cover { d_port10 == 5'b0_1000 };
// psl10 cover_d_port_410 : cover { d_port10 == 5'b1_0000 };
// psl10 cover_d_port_all10 : cover { d_port10 == 5'b0_1111 };
*/
`endif


endmodule 









