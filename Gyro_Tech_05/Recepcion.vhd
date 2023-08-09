----------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	Recep
-- Descripción: 	Recepción a 9600 bauds
-----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Recep is
    Port ( clk,rst,rx: in  std_logic;
			  Motor_Listo: in std_logic;
			  Temrx, Velrx:	out std_logic_vector(15 downto 0) );
end Recep;

architecture Arq of Recep is

signal 	erx:	  std_logic:='0';                         
signal 	trx:	  std_logic_vector(6 downto 0);
signal   cntrx:  std_logic_vector(10 downto 0);
constant baudrx: std_logic_vector(10 downto 0):= "11011001000"; --(9600*3) bauds
signal   sincro: std_logic_vector(23 downto 0); 
signal 	Listo: std_logic;		


begin

--Detecta el pulso enviado por la maquina de estados
process(rst,Motor_Listo,trx)
begin
	if rst='1' or  trx="1111010" then
		Listo <= '0';
	elsif Motor_Listo'event and Motor_Listo='1' then 
		Listo <='1';
	end if;
end process;

--Contador para el bit de sincronía
process (rst,clk,rx)
begin
	if rst='1' or rx='0' then
		sincro <=(others=>'0');
	elsif clk'event and clk='1' then
		sincro<=sincro+1;
	end if;
end process;

--Habilita o deshabilita la recepción (Listo, Bit de sincronía y bit de inicio)
process (rst,rx,trx,sincro,Listo)
begin
	if rst='1' then
		erx <= '0';
	elsif Listo='1' and rx='0' and sincro>X"0DD40A0" then --  Detecta el bit de inicio y de sincronia sincro> 14500000(aprox 300ms)
			erx <= '1';			    -- Habilita la recepción
	elsif trx="1111010" then --Otra opcion: elsif Listo='0' then
		erx <= '0';				 -- Deshabilita la recepción
	end if;
end process;

process (clk,rst,cntrx,erx)
begin
	if (rst='1' or erx='0')then
		cntrx <= (others=>'0');
		trx   <= (others=>'0');
	elsif (clk'event and clk='1' and erx='1')then 
		   cntrx <= cntrx + 1;
			if (cntrx=baudrx)then
				trx <= trx + 1;
				cntrx<=(others=>'0');
			end if;
	end if;
end process;

--Almacenando lo recibido en arreglos
process (clk,rst,trx)
begin
   if rst='1' then
		Velrx   <= (others=>'0');
		Temrx  <= (others=>'0');
				
	elsif (clk'event and clk='1') then
		case (trx) is 
			----------------------------------------
			-------Vel. Ang. MSB--------------------
			when "0000100" =>  Velrx(8) <=	rx;-- b9 trx=4 
			when "0000111" =>  Velrx(9) <=	rx;-- b10 (Bit Más significativo de la conversión de la Velocidad)
			when "0001010" =>  Velrx(10) <=	rx;-- Trash
			when "0001101" =>  Velrx(11) <=	rx;-- Trash
			when "0010000" =>  Velrx(12) <=	rx;-- Trash
			when "0010011" =>  Velrx(13) <=	rx;-- Trash
			when "0010110" =>  Velrx(14) <=	rx;-- Trash
			when "0011001" =>  Velrx(15) <=	rx;-- Trash trx=25 
			----------------------------------------
			-------Vel. Ang. LSB--------------------
			when "0100010" =>  Velrx(0) <=	rx;-- b0 (lsb) trx=34 
			when "0100101" =>  Velrx(1) <=	rx;-- b1
			when "0101000" =>  Velrx(2) <=	rx;-- b2
			when "0101011" =>  Velrx(3) <=	rx;-- b3
			when "0101110" =>  Velrx(4) <=	rx;-- b4
			when "0110001" =>  Velrx(5) <=	rx;-- b5
			when "0110100" =>  Velrx(6) <=	rx;-- b6
			when "0110111" =>  Velrx(7) <=	rx;-- b7 trx=55 
			----------------------------------------
			-------Temp MSB-------------------------
			when "1000000" =>  Temrx(8) <=	rx;-- b9 trx=64
			when "1000011" =>  Temrx(9) <=	rx;-- b10 Bit Más significativo de la conversión de Temperatura)
			when "1000110" =>  Temrx(10) <=	rx;-- Trash
			when "1001001" =>  Temrx(11) <=	rx;-- Trash
			when "1001100" =>  Temrx(12) <=	rx;-- Trash
			when "1001111" =>  Temrx(13) <=	rx;-- Trash
			when "1010010" =>  Temrx(14) <=	rx;-- Trash
			when "1010101" =>  Temrx(15) <=	rx;-- Trash trx=85
			----------------------------------------
			-------Temp LSB-------------------------
			when "1011110" =>  Temrx(0) <=	rx;-- b0 (lsb) trx=94
			when "1100001" =>  Temrx(1) <=	rx;-- b1 
			when "1100100" =>  Temrx(2) <=	rx;-- b2
			when "1100111" =>  Temrx(3) <=	rx;-- b3
			when "1101010" =>  Temrx(4) <=	rx;-- b4
			when "1101101" =>  Temrx(5) <=	rx;-- b5
			when "1110000" =>  Temrx(6) <=	rx;-- b6
			when "1110011" =>  Temrx(7) <=	rx;-- b7 trx=115
			----------------------------------------
			----------------------------------------
			when others => null;
		end case;
	 end if;
end process;	

end Arq;