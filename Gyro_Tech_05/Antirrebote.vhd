----------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis S�nchez M�rquez
--						Ricardo Flores Mart�nez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	Antirrebote
-- Descripci�n: 	Eliminaci�n de los rebotes en los interruptores
-----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ANTIRREBOTE is
    Port ( CLK 		: in  STD_LOGIC;
           CAPTURA 	: in  STD_LOGIC;
			  CAP 		: out STD_LOGIC);
end ANTIRREBOTE;

architecture Arq of ANTIRREBOTE is

SIGNAL CNT: STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');

begin

process (CLK,CNT,CAPTURA)
  begin
    if CAPTURA = '0' then
      CNT <= "000";
    elsif (CLK'event and CLK = '1') then
      if (CNT /= "011") then 
		CNT <= CNT + 1; 
		end if;
    end if;
    if (CNT = "010") and (CAPTURA = '1') then
		CAP <= '1'; 
	 else 
		CAP <= '0'; 
	 end if;
end process;

end Arq;
