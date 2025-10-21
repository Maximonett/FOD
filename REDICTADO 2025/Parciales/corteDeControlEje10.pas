{
   Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia:
____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia:
___
…………………………………………………………..
Total General de Votos:
___
NOTA: La información está ordenada por código de provincia y código de localidad.
   
   
}


program corteDeConbtrolEjercicio10;

const
	va=9999;
type
	mesa=record
		codP:integer; //1er orden
		codL:integer; //2do orden
		numeroM:integer; 
		cantVotos:integer;
	end;
	
	maestro=file of mesa;
	
procedure leer(var mae:maestro; var reg:mesa);
begin
	if (not eof(mae) ) then
		read(mae,reg)
	else
		reg.codP:=va;
end;

procedure informe( var mae:maestro);
var
	reg,act:mesa;
	totalVotosLocalidad,totalVotosProvincia, totalVotos:integer;
	
begin
	
	reset(mae);
	leer(mae,reg);
	totalVotos:=0;
	while (reg.codP<>va) do begin
		act.codP:=reg.codP;
		totalVotosProvincia:=0;
		writeln('Codigo de Provincia: ',act.codP);
		while(reg.codP=act.codP) do begin
			act.codL:=reg.codL;
			totalVotosLocalidad:=0;
			while (reg.codP=act.codP)and(reg.codL=act.codL) do begin
				totalVotosLocalidad:=totalVotosLocalidad+reg.cantVotos;
				leer(mae,reg);
			end;
			writeln('Codigo de Localidad: ',act.codL,' Total de votos: ',totalVotosLocalidad); 
			totalVotosProvincia:=totalVotosProvincia+totalVotosLocalidad;
		end;
		writeln('Total de votos Provincia: ',totalVotosProvincia);
		totalVotos:=totalVotos+totalVotosProvincia;
	end;
	writeln('Total general de Votos: ',totalVotos);
	close(mae);
end;


var
	mae:maestro;
	
BEGIN
	assig(mae,'mesas.dat');
	informe(mae);
	
END.

