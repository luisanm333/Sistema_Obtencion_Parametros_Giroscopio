----------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	Mensaje7
-- Descripción: 	Prueba Terminada
-----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mensaje7 is

    port( clk,rst,listo_in:	in      STD_LOGIC;
          LCD_E, LCD_RS, LCD_RW:  inout   STD_LOGIC;
	  listo_out: out STD_LOGIC;
          DATA:  inout STD_LOGIC_VECTOR( 0 to 3 ) );

end mensaje7;

architecture Behavioral of mensaje7 is

    signal CNTR:    STD_LOGIC_VECTOR( 0 to 23 ) := X"000000";   
    signal index:   integer:=0;
    -- Tengamos una definición tipo ROM :  D Y C0 C1 C2 C3 C4 C5
	 -- Y contiene (LDC_E, LCD_RS, LCD_RW, 0)
    type ROM_TYPE is array( 0 to 72 ) of STD_LOGIC_VECTOR( 0 to 31 );   
    
signal ROM: ROM_TYPE:= ( 
	
				-- Clear Display 0x01
            X"08FFFFFF", -- 335ms 	
				X"0000000C", -- 230ns 
				X"18000032", -- 1us
				X"1000000C",  -- 230ns
				X"10014050",  -- 1.64ms 


				-- Seleccionar DDRAM
				X"880007D0", -- 40us
				X"8000000C", -- 230ns
				X"08000032", -- 1us
				X"0000000C", -- 230ns

				-- Escribiendo datos
				X"5C4FFFFF", -- 335ms	--	P
				X"5400000C", -- 230ns
				X"0C000032", -- 1us
				X"0400000C", -- 230ns
											
				X"7C4FFFFF", -- 350ms 	--	r
				X"7400000C", -- 230ns 
				X"2C000032", -- 1us 
				X"2400000C", -- 230ns 
								
				X"7C4FFFFF", -- 350ms 	--	u
				X"7400000C", -- 230ns 
				X"5C000032", -- 1us
				X"5400000C", -- 230ns
									
				X"6C4FFFFF", -- 350ms 	--	e
				X"6400000C", -- 230ns 
				X"5C000032", -- 1us 
				X"5400000C", -- 230ns
									
				X"6C4FFFFF", -- 350ms 	--	b
				X"6400000C", -- 230ns 
				X"2C000032", -- 1us 
				X"2400000C", -- 230ns 
									
				X"6C4FFFFF", -- 350ms	--	a
				X"6400000C", -- 230ns 
				X"1C000032", -- 1us
				X"1400000C", -- 230ns
									
				X"2C4FFFFF", -- 350ms 	--	_
				X"2400000C", -- 230ns 
				X"0C000032", -- 1us 
				X"0400000C", -- 230ns 
									
				X"5C4FFFFF", -- 350ms 	--	T
				X"5400000C", -- 230ns 
				X"4C000032", -- 1us 
				X"4400000C", -- 230ns 
									
				X"6C4FFFFF", -- 350ms	--	e
				X"6400000C", -- 230ns 
				X"5C000032", -- 1us 
				X"5400000C", -- 230ns 
									
				X"7C4FFFFF", -- 350ms 	-- r
				X"7400000C", -- 230ns 
				X"2C000032", -- 1us 
				X"2400000C", -- 230ns 
															
				X"6C4FFFFF", -- 350ms 	-- m
				X"6400000C", -- 230ns 
				X"DC000032", -- 1us 
				X"D400000C", -- 230ns
									
				X"6C4FFFFF", -- 350ms 	--	i
				X"6400000C", -- 230ns 
				X"9C000032", -- 1us 
				X"9400000C", -- 230ns 
									
				X"6C4FFFFF", -- 350ms 	--	n
				X"6400000C", -- 230ns
				X"EC000032", -- 1us 
				X"E400000C", -- 230ns	
				
				X"6C4FFFFF", -- 350ms 	--	a
				X"6400000C", -- 230ns
				X"1C000032", -- 1us 
				X"1400000C", -- 230ns
				
				X"6C4FFFFF", -- 350ms 	--	d
				X"6400000C", -- 230ns
				X"4C000032", -- 1us 
				X"4400000C", -- 230ns
				
				X"6C4FFFFF", -- 350ms 	--	a
				X"6400000C", -- 230ns
				X"1C000032", -- 1us 
				X"1400000C" -- 230ns
				
									
			);	

begin
    
process(CLK,RST,CNTR,index) is
    begin
    if RST = '1' then
        INDEX <=0;
	listo_out <='0';
        CNTR <= (others=>'0');
    elsif rising_edge( CLK ) and listo_in = '1' then
    
            if CNTR >= ROM(index)(8 to 31) then
                        
                CNTR <= (others=>'0');
                DATA(0 to 3) <= ROM(index)(0 to 3);
                LCD_E   <= ROM(index)(4);
                LCD_RS  <= ROM(index)(5);
                LCD_RW  <= ROM(index)(6);
                        
                if index < ROM'high then 
                        index <= index + 1;
                else    
                        index <= index;
			listo_out <= '1';
                end if;                                 
            else            
                CNTR <= CNTR + 1;                                                               
            end if;                 
    end if;
end process;                    
end Behavioral;

