//File11 name   : alut_addr_checker11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

// compiler11 directives11
`include "alut_defines11.v"


module alut_addr_checker11
(   
   // Inputs11
   pclk11,
   n_p_reset11,
   command,
   mac_addr11,
   d_addr11,
   s_addr11,
   s_port11,
   curr_time11,
   mem_read_data_add11,
   age_confirmed11,
   age_ok11,
   clear_reused11,

   //outputs11
   d_port11,
   add_check_active11,
   mem_addr_add11,
   mem_write_add11,
   mem_write_data_add11,
   lst_inv_addr_nrm11,
   lst_inv_port_nrm11,
   check_age11,
   last_accessed11,
   reused11
);



   input               pclk11;               // APB11 clock11                           
   input               n_p_reset11;          // Reset11                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr11;           // address of the switch11              
   input [47:0]        d_addr11;             // address of frame11 to be checked11     
   input [47:0]        s_addr11;             // address of frame11 to be stored11      
   input [1:0]         s_port11;             // source11 port of current frame11       
   input [31:0]        curr_time11;          // current time,for storing11 in mem    
   input [82:0]        mem_read_data_add11;  // read data from mem                 
   input               age_confirmed11;      // valid flag11 from age11 checker        
   input               age_ok11;             // result from age11 checker 
   input               clear_reused11;       // read/clear flag11 for reused11 signal11           

   output [4:0]        d_port11;             // calculated11 destination11 port for tx11 
   output              add_check_active11;   // bit 0 of status register           
   output [7:0]        mem_addr_add11;       // hash11 address for R/W11 to memory     
   output              mem_write_add11;      // R/W11 flag11 (write = high11)            
   output [82:0]       mem_write_data_add11; // write data for memory             
   output [47:0]       lst_inv_addr_nrm11;   // last invalidated11 addr normal11 op    
   output [1:0]        lst_inv_port_nrm11;   // last invalidated11 port normal11 op    
   output              check_age11;          // request flag11 for age11 check
   output [31:0]       last_accessed11;      // time field sent11 for age11 check
   output              reused11;             // indicates11 ALUT11 location11 overwritten11

   reg   [2:0]         add_chk_state11;      // current address checker state
   reg   [2:0]         nxt_add_chk_state11;  // current address checker state
   reg   [4:0]         d_port11;             // calculated11 destination11 port for tx11 
   reg   [3:0]         port_mem11;           // bitwise11 conversion11 of 2bit port
   reg   [7:0]         mem_addr_add11;       // hash11 address for R/W11 to memory
   reg                 mem_write_add11;      // R/W11 flag11 (write = high11)            
   reg                 reused11;             // indicates11 ALUT11 location11 overwritten11
   reg   [47:0]        lst_inv_addr_nrm11;   // last invalidated11 addr normal11 op    
   reg   [1:0]         lst_inv_port_nrm11;   // last invalidated11 port normal11 op    
   reg                 check_age11;          // request flag11 for age11 checker
   reg   [31:0]        last_accessed11;      // time field sent11 for age11 check


   wire   [7:0]        s_addr_hash11;        // hash11 of address for storing11
   wire   [7:0]        d_addr_hash11;        // hash11 of address for checking
   wire   [82:0]       mem_write_data_add11; // write data for memory  
   wire                add_check_active11;   // bit 0 of status register           


// Parameters11 for Address Checking11 FSM11 states11
   parameter idle11           = 3'b000;
   parameter mac_addr_chk11   = 3'b001;
   parameter read_dest_add11  = 3'b010;
   parameter valid_chk11      = 3'b011;
   parameter age_chk11        = 3'b100;
   parameter addr_chk11       = 3'b101;
   parameter read_src_add11   = 3'b110;
   parameter write_src11      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash11 conversion11 of source11 and destination11 addresses11
// -----------------------------------------------------------------------------
   assign s_addr_hash11 = s_addr11[7:0] ^ s_addr11[15:8] ^ s_addr11[23:16] ^
                        s_addr11[31:24] ^ s_addr11[39:32] ^ s_addr11[47:40];

   assign d_addr_hash11 = d_addr11[7:0] ^ d_addr11[15:8] ^ d_addr11[23:16] ^
                        d_addr11[31:24] ^ d_addr11[39:32] ^ d_addr11[47:40];



// -----------------------------------------------------------------------------
//   State11 Machine11 For11 handling11 the destination11 address checking process and
//   and storing11 of new source11 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state11 or age_confirmed11 or age_ok11)
   begin
      case (add_chk_state11)
      
      idle11:
         if (command == 2'b01)
            nxt_add_chk_state11 = mac_addr_chk11;
         else
            nxt_add_chk_state11 = idle11;

      mac_addr_chk11:   // check if destination11 address match MAC11 switch11 address
         if (d_addr11 == mac_addr11)
            nxt_add_chk_state11 = idle11;  // return dest11 port as 5'b1_0000
         else
            nxt_add_chk_state11 = read_dest_add11;

      read_dest_add11:       // read data from memory using hash11 of destination11 address
            nxt_add_chk_state11 = valid_chk11;

      valid_chk11:      // check if read data had11 valid bit set
         nxt_add_chk_state11 = age_chk11;

      age_chk11:        // request age11 checker to check if still in date11
         if (age_confirmed11)
            nxt_add_chk_state11 = addr_chk11;
         else
            nxt_add_chk_state11 = age_chk11; 

      addr_chk11:       // perform11 compare between dest11 and read addresses11
            nxt_add_chk_state11 = read_src_add11; // return read port from ALUT11 mem

      read_src_add11:   // read from memory location11 about11 to be overwritten11
            nxt_add_chk_state11 = write_src11; 

      write_src11:      // write new source11 data (addr and port) to memory
            nxt_add_chk_state11 = idle11; 

      default:
            nxt_add_chk_state11 = idle11;
      endcase
   end


// destination11 check FSM11 current state
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
      add_chk_state11 <= idle11;
   else
      add_chk_state11 <= nxt_add_chk_state11;
   end



// -----------------------------------------------------------------------------
//   Generate11 returned value of port for sending11 new frame11 to
// -----------------------------------------------------------------------------
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
      d_port11 <= 5'b0_1111;
   else if ((add_chk_state11 == mac_addr_chk11) & (d_addr11 == mac_addr11))
      d_port11 <= 5'b1_0000;
   else if (((add_chk_state11 == valid_chk11) & ~mem_read_data_add11[82]) |
            ((add_chk_state11 == age_chk11) & ~(age_confirmed11 & age_ok11)) |
            ((add_chk_state11 == addr_chk11) & (d_addr11 != mem_read_data_add11[47:0])))
      d_port11 <= 5'b0_1111 & ~( 1 << s_port11 );
   else if ((add_chk_state11 == addr_chk11) & (d_addr11 == mem_read_data_add11[47:0]))
      d_port11 <= {1'b0, port_mem11} & ~( 1 << s_port11 );
   else
      d_port11 <= d_port11;
   end


// -----------------------------------------------------------------------------
//   convert read port source11 value from 2bits to bitwise11 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
      port_mem11 <= 4'b1111;
   else begin
      case (mem_read_data_add11[49:48])
         2'b00: port_mem11 <= 4'b0001;
         2'b01: port_mem11 <= 4'b0010;
         2'b10: port_mem11 <= 4'b0100;
         2'b11: port_mem11 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded11 off11 add_chk_state11
// -----------------------------------------------------------------------------
assign add_check_active11 = (add_chk_state11 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate11 memory addressing11 signals11.
//   The check address command will be taken11 as the indication11 from SW11 that the 
//   source11 fields (address and port) can be written11 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11) 
   begin
       mem_write_add11 <= 1'b0;
       mem_addr_add11  <= 8'd0;
   end
   else if (add_chk_state11 == read_dest_add11)
   begin
       mem_write_add11 <= 1'b0;
       mem_addr_add11  <= d_addr_hash11;
   end
// Need11 to set address two11 cycles11 before check
   else if ( (add_chk_state11 == age_chk11) && age_confirmed11 )
   begin
       mem_write_add11 <= 1'b0;
       mem_addr_add11  <= s_addr_hash11;
   end
   else if (add_chk_state11 == write_src11)
   begin
       mem_write_add11 <= 1'b1;
       mem_addr_add11  <= s_addr_hash11;
   end
   else
   begin
       mem_write_add11 <= 1'b0;
       mem_addr_add11  <= d_addr_hash11;
   end
   end


// -----------------------------------------------------------------------------
//   Generate11 databus11 for writing to memory
//   Data written11 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add11 = {1'b1, curr_time11, s_port11, s_addr11};



// -----------------------------------------------------------------------------
//   Evaluate11 read back data that is about11 to be overwritten11 with new source11 
//   address and port values. Decide11 whether11 the reused11 flag11 must be set and
//   last_inval11 address and port values updated.
//   reused11 needs11 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11) 
   begin
      reused11 <= 1'b0;
      lst_inv_addr_nrm11 <= 48'd0;
      lst_inv_port_nrm11 <= 2'd0;
   end
   else if ((add_chk_state11 == read_src_add11) & mem_read_data_add11[82] &
            (s_addr11 != mem_read_data_add11[47:0]))
   begin
      reused11 <= 1'b1;
      lst_inv_addr_nrm11 <= mem_read_data_add11[47:0];
      lst_inv_port_nrm11 <= mem_read_data_add11[49:48];
   end
   else if (clear_reused11)
   begin
      reused11 <= 1'b0;
      lst_inv_addr_nrm11 <= lst_inv_addr_nrm11;
      lst_inv_port_nrm11 <= lst_inv_addr_nrm11;
   end
   else 
   begin
      reused11 <= reused11;
      lst_inv_addr_nrm11 <= lst_inv_addr_nrm11;
      lst_inv_port_nrm11 <= lst_inv_addr_nrm11;
   end
   end


// -----------------------------------------------------------------------------
//   Generate11 signals11 for age11 checker to perform11 in-date11 check
// -----------------------------------------------------------------------------
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11) 
   begin
      check_age11 <= 1'b0;  
      last_accessed11 <= 32'd0;
   end
   else if (check_age11)
   begin
      check_age11 <= 1'b0;  
      last_accessed11 <= mem_read_data_add11[81:50];
   end
   else if (add_chk_state11 == age_chk11)
   begin
      check_age11 <= 1'b1;  
      last_accessed11 <= mem_read_data_add11[81:50];
   end
   else 
   begin
      check_age11 <= 1'b0;  
      last_accessed11 <= 32'd0;
   end
   end


`ifdef ABV_ON11

// psl11 default clock11 = (posedge pclk11);

// ASSERTION11 CHECKS11
/* Commented11 out as also checking in toplevel11
// it should never be possible11 for the destination11 port to indicate11 the MAC11
// switch11 address and one of the other 4 Ethernets11
// psl11 assert_valid_dest_port11 : assert never (d_port11[4] & |{d_port11[3:0]});


// COVER11 SANITY11 CHECKS11
// check all values of destination11 port can be returned.
// psl11 cover_d_port_011 : cover { d_port11 == 5'b0_0001 };
// psl11 cover_d_port_111 : cover { d_port11 == 5'b0_0010 };
// psl11 cover_d_port_211 : cover { d_port11 == 5'b0_0100 };
// psl11 cover_d_port_311 : cover { d_port11 == 5'b0_1000 };
// psl11 cover_d_port_411 : cover { d_port11 == 5'b1_0000 };
// psl11 cover_d_port_all11 : cover { d_port11 == 5'b0_1111 };
*/
`endif


endmodule 









