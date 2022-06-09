//File18 name   : alut_addr_checker18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

// compiler18 directives18
`include "alut_defines18.v"


module alut_addr_checker18
(   
   // Inputs18
   pclk18,
   n_p_reset18,
   command,
   mac_addr18,
   d_addr18,
   s_addr18,
   s_port18,
   curr_time18,
   mem_read_data_add18,
   age_confirmed18,
   age_ok18,
   clear_reused18,

   //outputs18
   d_port18,
   add_check_active18,
   mem_addr_add18,
   mem_write_add18,
   mem_write_data_add18,
   lst_inv_addr_nrm18,
   lst_inv_port_nrm18,
   check_age18,
   last_accessed18,
   reused18
);



   input               pclk18;               // APB18 clock18                           
   input               n_p_reset18;          // Reset18                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr18;           // address of the switch18              
   input [47:0]        d_addr18;             // address of frame18 to be checked18     
   input [47:0]        s_addr18;             // address of frame18 to be stored18      
   input [1:0]         s_port18;             // source18 port of current frame18       
   input [31:0]        curr_time18;          // current time,for storing18 in mem    
   input [82:0]        mem_read_data_add18;  // read data from mem                 
   input               age_confirmed18;      // valid flag18 from age18 checker        
   input               age_ok18;             // result from age18 checker 
   input               clear_reused18;       // read/clear flag18 for reused18 signal18           

   output [4:0]        d_port18;             // calculated18 destination18 port for tx18 
   output              add_check_active18;   // bit 0 of status register           
   output [7:0]        mem_addr_add18;       // hash18 address for R/W18 to memory     
   output              mem_write_add18;      // R/W18 flag18 (write = high18)            
   output [82:0]       mem_write_data_add18; // write data for memory             
   output [47:0]       lst_inv_addr_nrm18;   // last invalidated18 addr normal18 op    
   output [1:0]        lst_inv_port_nrm18;   // last invalidated18 port normal18 op    
   output              check_age18;          // request flag18 for age18 check
   output [31:0]       last_accessed18;      // time field sent18 for age18 check
   output              reused18;             // indicates18 ALUT18 location18 overwritten18

   reg   [2:0]         add_chk_state18;      // current address checker state
   reg   [2:0]         nxt_add_chk_state18;  // current address checker state
   reg   [4:0]         d_port18;             // calculated18 destination18 port for tx18 
   reg   [3:0]         port_mem18;           // bitwise18 conversion18 of 2bit port
   reg   [7:0]         mem_addr_add18;       // hash18 address for R/W18 to memory
   reg                 mem_write_add18;      // R/W18 flag18 (write = high18)            
   reg                 reused18;             // indicates18 ALUT18 location18 overwritten18
   reg   [47:0]        lst_inv_addr_nrm18;   // last invalidated18 addr normal18 op    
   reg   [1:0]         lst_inv_port_nrm18;   // last invalidated18 port normal18 op    
   reg                 check_age18;          // request flag18 for age18 checker
   reg   [31:0]        last_accessed18;      // time field sent18 for age18 check


   wire   [7:0]        s_addr_hash18;        // hash18 of address for storing18
   wire   [7:0]        d_addr_hash18;        // hash18 of address for checking
   wire   [82:0]       mem_write_data_add18; // write data for memory  
   wire                add_check_active18;   // bit 0 of status register           


// Parameters18 for Address Checking18 FSM18 states18
   parameter idle18           = 3'b000;
   parameter mac_addr_chk18   = 3'b001;
   parameter read_dest_add18  = 3'b010;
   parameter valid_chk18      = 3'b011;
   parameter age_chk18        = 3'b100;
   parameter addr_chk18       = 3'b101;
   parameter read_src_add18   = 3'b110;
   parameter write_src18      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash18 conversion18 of source18 and destination18 addresses18
// -----------------------------------------------------------------------------
   assign s_addr_hash18 = s_addr18[7:0] ^ s_addr18[15:8] ^ s_addr18[23:16] ^
                        s_addr18[31:24] ^ s_addr18[39:32] ^ s_addr18[47:40];

   assign d_addr_hash18 = d_addr18[7:0] ^ d_addr18[15:8] ^ d_addr18[23:16] ^
                        d_addr18[31:24] ^ d_addr18[39:32] ^ d_addr18[47:40];



// -----------------------------------------------------------------------------
//   State18 Machine18 For18 handling18 the destination18 address checking process and
//   and storing18 of new source18 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state18 or age_confirmed18 or age_ok18)
   begin
      case (add_chk_state18)
      
      idle18:
         if (command == 2'b01)
            nxt_add_chk_state18 = mac_addr_chk18;
         else
            nxt_add_chk_state18 = idle18;

      mac_addr_chk18:   // check if destination18 address match MAC18 switch18 address
         if (d_addr18 == mac_addr18)
            nxt_add_chk_state18 = idle18;  // return dest18 port as 5'b1_0000
         else
            nxt_add_chk_state18 = read_dest_add18;

      read_dest_add18:       // read data from memory using hash18 of destination18 address
            nxt_add_chk_state18 = valid_chk18;

      valid_chk18:      // check if read data had18 valid bit set
         nxt_add_chk_state18 = age_chk18;

      age_chk18:        // request age18 checker to check if still in date18
         if (age_confirmed18)
            nxt_add_chk_state18 = addr_chk18;
         else
            nxt_add_chk_state18 = age_chk18; 

      addr_chk18:       // perform18 compare between dest18 and read addresses18
            nxt_add_chk_state18 = read_src_add18; // return read port from ALUT18 mem

      read_src_add18:   // read from memory location18 about18 to be overwritten18
            nxt_add_chk_state18 = write_src18; 

      write_src18:      // write new source18 data (addr and port) to memory
            nxt_add_chk_state18 = idle18; 

      default:
            nxt_add_chk_state18 = idle18;
      endcase
   end


// destination18 check FSM18 current state
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
      add_chk_state18 <= idle18;
   else
      add_chk_state18 <= nxt_add_chk_state18;
   end



// -----------------------------------------------------------------------------
//   Generate18 returned value of port for sending18 new frame18 to
// -----------------------------------------------------------------------------
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
      d_port18 <= 5'b0_1111;
   else if ((add_chk_state18 == mac_addr_chk18) & (d_addr18 == mac_addr18))
      d_port18 <= 5'b1_0000;
   else if (((add_chk_state18 == valid_chk18) & ~mem_read_data_add18[82]) |
            ((add_chk_state18 == age_chk18) & ~(age_confirmed18 & age_ok18)) |
            ((add_chk_state18 == addr_chk18) & (d_addr18 != mem_read_data_add18[47:0])))
      d_port18 <= 5'b0_1111 & ~( 1 << s_port18 );
   else if ((add_chk_state18 == addr_chk18) & (d_addr18 == mem_read_data_add18[47:0]))
      d_port18 <= {1'b0, port_mem18} & ~( 1 << s_port18 );
   else
      d_port18 <= d_port18;
   end


// -----------------------------------------------------------------------------
//   convert read port source18 value from 2bits to bitwise18 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
      port_mem18 <= 4'b1111;
   else begin
      case (mem_read_data_add18[49:48])
         2'b00: port_mem18 <= 4'b0001;
         2'b01: port_mem18 <= 4'b0010;
         2'b10: port_mem18 <= 4'b0100;
         2'b11: port_mem18 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded18 off18 add_chk_state18
// -----------------------------------------------------------------------------
assign add_check_active18 = (add_chk_state18 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate18 memory addressing18 signals18.
//   The check address command will be taken18 as the indication18 from SW18 that the 
//   source18 fields (address and port) can be written18 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18) 
   begin
       mem_write_add18 <= 1'b0;
       mem_addr_add18  <= 8'd0;
   end
   else if (add_chk_state18 == read_dest_add18)
   begin
       mem_write_add18 <= 1'b0;
       mem_addr_add18  <= d_addr_hash18;
   end
// Need18 to set address two18 cycles18 before check
   else if ( (add_chk_state18 == age_chk18) && age_confirmed18 )
   begin
       mem_write_add18 <= 1'b0;
       mem_addr_add18  <= s_addr_hash18;
   end
   else if (add_chk_state18 == write_src18)
   begin
       mem_write_add18 <= 1'b1;
       mem_addr_add18  <= s_addr_hash18;
   end
   else
   begin
       mem_write_add18 <= 1'b0;
       mem_addr_add18  <= d_addr_hash18;
   end
   end


// -----------------------------------------------------------------------------
//   Generate18 databus18 for writing to memory
//   Data written18 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add18 = {1'b1, curr_time18, s_port18, s_addr18};



// -----------------------------------------------------------------------------
//   Evaluate18 read back data that is about18 to be overwritten18 with new source18 
//   address and port values. Decide18 whether18 the reused18 flag18 must be set and
//   last_inval18 address and port values updated.
//   reused18 needs18 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18) 
   begin
      reused18 <= 1'b0;
      lst_inv_addr_nrm18 <= 48'd0;
      lst_inv_port_nrm18 <= 2'd0;
   end
   else if ((add_chk_state18 == read_src_add18) & mem_read_data_add18[82] &
            (s_addr18 != mem_read_data_add18[47:0]))
   begin
      reused18 <= 1'b1;
      lst_inv_addr_nrm18 <= mem_read_data_add18[47:0];
      lst_inv_port_nrm18 <= mem_read_data_add18[49:48];
   end
   else if (clear_reused18)
   begin
      reused18 <= 1'b0;
      lst_inv_addr_nrm18 <= lst_inv_addr_nrm18;
      lst_inv_port_nrm18 <= lst_inv_addr_nrm18;
   end
   else 
   begin
      reused18 <= reused18;
      lst_inv_addr_nrm18 <= lst_inv_addr_nrm18;
      lst_inv_port_nrm18 <= lst_inv_addr_nrm18;
   end
   end


// -----------------------------------------------------------------------------
//   Generate18 signals18 for age18 checker to perform18 in-date18 check
// -----------------------------------------------------------------------------
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18) 
   begin
      check_age18 <= 1'b0;  
      last_accessed18 <= 32'd0;
   end
   else if (check_age18)
   begin
      check_age18 <= 1'b0;  
      last_accessed18 <= mem_read_data_add18[81:50];
   end
   else if (add_chk_state18 == age_chk18)
   begin
      check_age18 <= 1'b1;  
      last_accessed18 <= mem_read_data_add18[81:50];
   end
   else 
   begin
      check_age18 <= 1'b0;  
      last_accessed18 <= 32'd0;
   end
   end


`ifdef ABV_ON18

// psl18 default clock18 = (posedge pclk18);

// ASSERTION18 CHECKS18
/* Commented18 out as also checking in toplevel18
// it should never be possible18 for the destination18 port to indicate18 the MAC18
// switch18 address and one of the other 4 Ethernets18
// psl18 assert_valid_dest_port18 : assert never (d_port18[4] & |{d_port18[3:0]});


// COVER18 SANITY18 CHECKS18
// check all values of destination18 port can be returned.
// psl18 cover_d_port_018 : cover { d_port18 == 5'b0_0001 };
// psl18 cover_d_port_118 : cover { d_port18 == 5'b0_0010 };
// psl18 cover_d_port_218 : cover { d_port18 == 5'b0_0100 };
// psl18 cover_d_port_318 : cover { d_port18 == 5'b0_1000 };
// psl18 cover_d_port_418 : cover { d_port18 == 5'b1_0000 };
// psl18 cover_d_port_all18 : cover { d_port18 == 5'b0_1111 };
*/
`endif


endmodule 









