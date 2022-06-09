//File6 name   : alut_addr_checker6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

// compiler6 directives6
`include "alut_defines6.v"


module alut_addr_checker6
(   
   // Inputs6
   pclk6,
   n_p_reset6,
   command,
   mac_addr6,
   d_addr6,
   s_addr6,
   s_port6,
   curr_time6,
   mem_read_data_add6,
   age_confirmed6,
   age_ok6,
   clear_reused6,

   //outputs6
   d_port6,
   add_check_active6,
   mem_addr_add6,
   mem_write_add6,
   mem_write_data_add6,
   lst_inv_addr_nrm6,
   lst_inv_port_nrm6,
   check_age6,
   last_accessed6,
   reused6
);



   input               pclk6;               // APB6 clock6                           
   input               n_p_reset6;          // Reset6                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr6;           // address of the switch6              
   input [47:0]        d_addr6;             // address of frame6 to be checked6     
   input [47:0]        s_addr6;             // address of frame6 to be stored6      
   input [1:0]         s_port6;             // source6 port of current frame6       
   input [31:0]        curr_time6;          // current time,for storing6 in mem    
   input [82:0]        mem_read_data_add6;  // read data from mem                 
   input               age_confirmed6;      // valid flag6 from age6 checker        
   input               age_ok6;             // result from age6 checker 
   input               clear_reused6;       // read/clear flag6 for reused6 signal6           

   output [4:0]        d_port6;             // calculated6 destination6 port for tx6 
   output              add_check_active6;   // bit 0 of status register           
   output [7:0]        mem_addr_add6;       // hash6 address for R/W6 to memory     
   output              mem_write_add6;      // R/W6 flag6 (write = high6)            
   output [82:0]       mem_write_data_add6; // write data for memory             
   output [47:0]       lst_inv_addr_nrm6;   // last invalidated6 addr normal6 op    
   output [1:0]        lst_inv_port_nrm6;   // last invalidated6 port normal6 op    
   output              check_age6;          // request flag6 for age6 check
   output [31:0]       last_accessed6;      // time field sent6 for age6 check
   output              reused6;             // indicates6 ALUT6 location6 overwritten6

   reg   [2:0]         add_chk_state6;      // current address checker state
   reg   [2:0]         nxt_add_chk_state6;  // current address checker state
   reg   [4:0]         d_port6;             // calculated6 destination6 port for tx6 
   reg   [3:0]         port_mem6;           // bitwise6 conversion6 of 2bit port
   reg   [7:0]         mem_addr_add6;       // hash6 address for R/W6 to memory
   reg                 mem_write_add6;      // R/W6 flag6 (write = high6)            
   reg                 reused6;             // indicates6 ALUT6 location6 overwritten6
   reg   [47:0]        lst_inv_addr_nrm6;   // last invalidated6 addr normal6 op    
   reg   [1:0]         lst_inv_port_nrm6;   // last invalidated6 port normal6 op    
   reg                 check_age6;          // request flag6 for age6 checker
   reg   [31:0]        last_accessed6;      // time field sent6 for age6 check


   wire   [7:0]        s_addr_hash6;        // hash6 of address for storing6
   wire   [7:0]        d_addr_hash6;        // hash6 of address for checking
   wire   [82:0]       mem_write_data_add6; // write data for memory  
   wire                add_check_active6;   // bit 0 of status register           


// Parameters6 for Address Checking6 FSM6 states6
   parameter idle6           = 3'b000;
   parameter mac_addr_chk6   = 3'b001;
   parameter read_dest_add6  = 3'b010;
   parameter valid_chk6      = 3'b011;
   parameter age_chk6        = 3'b100;
   parameter addr_chk6       = 3'b101;
   parameter read_src_add6   = 3'b110;
   parameter write_src6      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash6 conversion6 of source6 and destination6 addresses6
// -----------------------------------------------------------------------------
   assign s_addr_hash6 = s_addr6[7:0] ^ s_addr6[15:8] ^ s_addr6[23:16] ^
                        s_addr6[31:24] ^ s_addr6[39:32] ^ s_addr6[47:40];

   assign d_addr_hash6 = d_addr6[7:0] ^ d_addr6[15:8] ^ d_addr6[23:16] ^
                        d_addr6[31:24] ^ d_addr6[39:32] ^ d_addr6[47:40];



// -----------------------------------------------------------------------------
//   State6 Machine6 For6 handling6 the destination6 address checking process and
//   and storing6 of new source6 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state6 or age_confirmed6 or age_ok6)
   begin
      case (add_chk_state6)
      
      idle6:
         if (command == 2'b01)
            nxt_add_chk_state6 = mac_addr_chk6;
         else
            nxt_add_chk_state6 = idle6;

      mac_addr_chk6:   // check if destination6 address match MAC6 switch6 address
         if (d_addr6 == mac_addr6)
            nxt_add_chk_state6 = idle6;  // return dest6 port as 5'b1_0000
         else
            nxt_add_chk_state6 = read_dest_add6;

      read_dest_add6:       // read data from memory using hash6 of destination6 address
            nxt_add_chk_state6 = valid_chk6;

      valid_chk6:      // check if read data had6 valid bit set
         nxt_add_chk_state6 = age_chk6;

      age_chk6:        // request age6 checker to check if still in date6
         if (age_confirmed6)
            nxt_add_chk_state6 = addr_chk6;
         else
            nxt_add_chk_state6 = age_chk6; 

      addr_chk6:       // perform6 compare between dest6 and read addresses6
            nxt_add_chk_state6 = read_src_add6; // return read port from ALUT6 mem

      read_src_add6:   // read from memory location6 about6 to be overwritten6
            nxt_add_chk_state6 = write_src6; 

      write_src6:      // write new source6 data (addr and port) to memory
            nxt_add_chk_state6 = idle6; 

      default:
            nxt_add_chk_state6 = idle6;
      endcase
   end


// destination6 check FSM6 current state
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
      add_chk_state6 <= idle6;
   else
      add_chk_state6 <= nxt_add_chk_state6;
   end



// -----------------------------------------------------------------------------
//   Generate6 returned value of port for sending6 new frame6 to
// -----------------------------------------------------------------------------
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
      d_port6 <= 5'b0_1111;
   else if ((add_chk_state6 == mac_addr_chk6) & (d_addr6 == mac_addr6))
      d_port6 <= 5'b1_0000;
   else if (((add_chk_state6 == valid_chk6) & ~mem_read_data_add6[82]) |
            ((add_chk_state6 == age_chk6) & ~(age_confirmed6 & age_ok6)) |
            ((add_chk_state6 == addr_chk6) & (d_addr6 != mem_read_data_add6[47:0])))
      d_port6 <= 5'b0_1111 & ~( 1 << s_port6 );
   else if ((add_chk_state6 == addr_chk6) & (d_addr6 == mem_read_data_add6[47:0]))
      d_port6 <= {1'b0, port_mem6} & ~( 1 << s_port6 );
   else
      d_port6 <= d_port6;
   end


// -----------------------------------------------------------------------------
//   convert read port source6 value from 2bits to bitwise6 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
      port_mem6 <= 4'b1111;
   else begin
      case (mem_read_data_add6[49:48])
         2'b00: port_mem6 <= 4'b0001;
         2'b01: port_mem6 <= 4'b0010;
         2'b10: port_mem6 <= 4'b0100;
         2'b11: port_mem6 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded6 off6 add_chk_state6
// -----------------------------------------------------------------------------
assign add_check_active6 = (add_chk_state6 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate6 memory addressing6 signals6.
//   The check address command will be taken6 as the indication6 from SW6 that the 
//   source6 fields (address and port) can be written6 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6) 
   begin
       mem_write_add6 <= 1'b0;
       mem_addr_add6  <= 8'd0;
   end
   else if (add_chk_state6 == read_dest_add6)
   begin
       mem_write_add6 <= 1'b0;
       mem_addr_add6  <= d_addr_hash6;
   end
// Need6 to set address two6 cycles6 before check
   else if ( (add_chk_state6 == age_chk6) && age_confirmed6 )
   begin
       mem_write_add6 <= 1'b0;
       mem_addr_add6  <= s_addr_hash6;
   end
   else if (add_chk_state6 == write_src6)
   begin
       mem_write_add6 <= 1'b1;
       mem_addr_add6  <= s_addr_hash6;
   end
   else
   begin
       mem_write_add6 <= 1'b0;
       mem_addr_add6  <= d_addr_hash6;
   end
   end


// -----------------------------------------------------------------------------
//   Generate6 databus6 for writing to memory
//   Data written6 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add6 = {1'b1, curr_time6, s_port6, s_addr6};



// -----------------------------------------------------------------------------
//   Evaluate6 read back data that is about6 to be overwritten6 with new source6 
//   address and port values. Decide6 whether6 the reused6 flag6 must be set and
//   last_inval6 address and port values updated.
//   reused6 needs6 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6) 
   begin
      reused6 <= 1'b0;
      lst_inv_addr_nrm6 <= 48'd0;
      lst_inv_port_nrm6 <= 2'd0;
   end
   else if ((add_chk_state6 == read_src_add6) & mem_read_data_add6[82] &
            (s_addr6 != mem_read_data_add6[47:0]))
   begin
      reused6 <= 1'b1;
      lst_inv_addr_nrm6 <= mem_read_data_add6[47:0];
      lst_inv_port_nrm6 <= mem_read_data_add6[49:48];
   end
   else if (clear_reused6)
   begin
      reused6 <= 1'b0;
      lst_inv_addr_nrm6 <= lst_inv_addr_nrm6;
      lst_inv_port_nrm6 <= lst_inv_addr_nrm6;
   end
   else 
   begin
      reused6 <= reused6;
      lst_inv_addr_nrm6 <= lst_inv_addr_nrm6;
      lst_inv_port_nrm6 <= lst_inv_addr_nrm6;
   end
   end


// -----------------------------------------------------------------------------
//   Generate6 signals6 for age6 checker to perform6 in-date6 check
// -----------------------------------------------------------------------------
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6) 
   begin
      check_age6 <= 1'b0;  
      last_accessed6 <= 32'd0;
   end
   else if (check_age6)
   begin
      check_age6 <= 1'b0;  
      last_accessed6 <= mem_read_data_add6[81:50];
   end
   else if (add_chk_state6 == age_chk6)
   begin
      check_age6 <= 1'b1;  
      last_accessed6 <= mem_read_data_add6[81:50];
   end
   else 
   begin
      check_age6 <= 1'b0;  
      last_accessed6 <= 32'd0;
   end
   end


`ifdef ABV_ON6

// psl6 default clock6 = (posedge pclk6);

// ASSERTION6 CHECKS6
/* Commented6 out as also checking in toplevel6
// it should never be possible6 for the destination6 port to indicate6 the MAC6
// switch6 address and one of the other 4 Ethernets6
// psl6 assert_valid_dest_port6 : assert never (d_port6[4] & |{d_port6[3:0]});


// COVER6 SANITY6 CHECKS6
// check all values of destination6 port can be returned.
// psl6 cover_d_port_06 : cover { d_port6 == 5'b0_0001 };
// psl6 cover_d_port_16 : cover { d_port6 == 5'b0_0010 };
// psl6 cover_d_port_26 : cover { d_port6 == 5'b0_0100 };
// psl6 cover_d_port_36 : cover { d_port6 == 5'b0_1000 };
// psl6 cover_d_port_46 : cover { d_port6 == 5'b1_0000 };
// psl6 cover_d_port_all6 : cover { d_port6 == 5'b0_1111 };
*/
`endif


endmodule 









