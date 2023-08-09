----------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	Mensajes
-- Descripción: 	Inicialización, configuración y escritura de mensajes
-----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.Componentes_pkg.ALL;

entity Mensajes is
    Port(  clk,rst,men_1,men_2: in STD_LOGIC;
           data:  inout STD_LOGIC_VECTOR( 0 to 3 );     
           LCD_E,LCD_RS,LCD_RW:  inout   STD_LOGIC;
           SF_CE0: out STD_LOGIC );
end Mensajes;

architecture Arq of Mensajes is 

signal listo: std_logic_vector (7 downto 0);
signal LCD_E_1, LCD_E_2, LCD_E_3,LCD_E_4,LCD_E_5,LCD_E_6,LCD_E_7,LCD_E_8 : std_logic;
signal LCD_RS_1, LCD_RS_2, LCD_RS_3,LCD_RS_4,LCD_RS_5,LCD_RS_6,LCD_RS_7,LCD_RS_8 : std_logic;
signal LCD_RW_1, LCD_RW_2, LCD_RW_3,LCD_RW_4,LCD_RW_5,LCD_RW_6,LCD_RW_7,LCD_RW_8 : std_logic;
signal DATA_1, DATA_2, DATA_3, DATA_4, DATA_5,DATA_6,DATA_7,DATA_8 : std_logic_vector( 0 to 3 );

	
begin

SF_CE0 <= '1';  -- Inhabilitar acceso a StrataFlash

with listo select
LCD_E <= LCD_E_1 when "00000000",
			LCD_E_2 when "00000001",
			LCD_E_3 when "00000011",
			LCD_E_4 when "00000111",
			LCD_E_5 when "00001111",
			LCD_E_6 when "00011111",
			LCD_E_7 when "00111111",
			LCD_E_8 when "01111111",
			'0' when others;

with listo select
LCD_RS <= LCD_RS_1 when "00000000",
			 LCD_RS_2 when "00000001",
			 LCD_RS_3 when "00000011",
			 LCD_RS_4 when "00000111",
			 LCD_RS_5 when "00001111",
			 LCD_RS_6 when "00011111",
			 LCD_RS_7 when "00111111",
			 LCD_RS_8 when "01111111",
			 '0' when others;

with listo select
LCD_RW <= LCD_RW_1 when "00000000",
			 LCD_RW_2 when "00000001",
			 LCD_RW_3 when "00000011",
			 LCD_RW_4 when "00000111",
			 LCD_RW_5 when "00001111",
			 LCD_RW_6 when "00011111",
			 LCD_RW_7 when "00111111",
			 LCD_RW_8 when "01111111",
			 '0' when others;

with listo select
DATA <=  DATA_1 when "00000000",
			DATA_2 when "00000001",
			DATA_3 when "00000011",
			DATA_4 when "00000111",
			DATA_5 when "00001111",
			DATA_6 when "00011111",
			DATA_7 when "00111111",
			DATA_8 when "01111111",
			"0000" when others;
				
com0: LCD_init port map ( clk, rst, LCD_E_1,  LCD_RS_1, LCD_RW_1,listo(0),DATA_1);
com1: mensaje1 port map ( clk, rst, listo(0), LCD_E_2, LCD_RS_2, LCD_RW_2,listo(1),DATA_2);
com2: mensaje2 port map ( clk, rst, listo(1), LCD_E_3, LCD_RS_3, LCD_RW_3,listo(2),DATA_3);
com3: mensaje3 port map ( clk, rst, listo(2), LCD_E_4, LCD_RS_4, LCD_RW_4,listo(3),DATA_4);
com4: mensaje4 port map ( clk, rst, men_1,    LCD_E_5, LCD_RS_5, LCD_RW_5,listo(4),DATA_5);
com5: mensaje5 port map ( clk, rst, listo(4), LCD_E_6, LCD_RS_6, LCD_RW_6,listo(5),DATA_6);
com6: mensaje6 port map ( clk, rst, men_2,    LCD_E_7, LCD_RS_7, LCD_RW_7,listo(6),DATA_7);
com7: mensaje7 port map ( clk, rst, listo(6), LCD_E_8, LCD_RS_8, LCD_RW_8,listo(7),DATA_8);
		
end Arq;					
