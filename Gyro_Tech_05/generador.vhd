---------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	generador 
-- Descripción: 	Genera las señales de control de la transmisión
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity generador is
port (clk, rst: in std_logic;
           etx: inout std_logic);
end generador;

architecture Arq of generador is
signal contador: STD_LOGIC_VECTOR (19 downto 0) :=(others=>'0');
signal stop: STD_LOGIC_VECTOR (4 downto 0) :=(others=>'0');

begin
  
  --- Proceso para generar la señal etx
process(clk,rst,contador,stop) 
   begin  
    if (rst='1' or contador <= X"0000A" or stop = "10111") then -- 11 ciclos de 50 MHz(220 ns)
	     etx<='0';
	 elsif (clk 'event and clk='1') then
	     etx<='1';
	 end if;
  end process;
  
--- Proceso para detener etx
process(etx,rst,stop) 
   begin  
	if rst='1' then
	     stop <= (others=>'0');
		  
   elsif (etx'event and etx='1')then 
	     stop<=stop+1;
	end if;
end process;  

--Para 66 bits(trama 11 bits * # de variables V,T,P ) a 9600 baudios  6.875ms/20ns  contador de 0 a 343750 (X"53EC6")

process(clk,rst,contador) 
   begin

	if (rst='1' or contador = X"53EC6" ) then  
	 contador <= (others=>'0');		     
    elsif (clk 'event and clk='0') then
	     contador <= contador + 1;
	 end if;
   end process;

end Arq;
