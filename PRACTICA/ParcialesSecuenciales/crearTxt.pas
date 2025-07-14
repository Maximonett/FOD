{
   crearTxt.pas
   
   Copyright 2025 Maximo Andres Simonetti <maximosimonetti@MacBook-Pro-de-Maximo.local>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}


program untitled;

uses crt;
var i : byte;


procedure crearTxt(var m:maestro);
var 
	regM:regMaestro;
	txt:text;
begin
	assign(txt,'ArchvoTXT.txt');
	rewrite(txt);
	assign(m,'ArchivoMaestro');
	reset(m);
	
	while(not eof(m)) do begin
		read(m,regM); //LEER dentro porque es la manera de avanzar en el archivo cada vez que leo avanzo en la posicion.
		writeln(txt,regM.nombre);
		writeln(txt,regM.apellido);
		writeln(txt,regM.codigo);
	end;
	writeln('Archivo de texto creado');
	close(txt);
	close(m);		
end;


BEGIN

	
END.

