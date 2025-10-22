{
   18. Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene: código
de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
por localidad, luego por municipio y luego por hospital.
Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga un
listado con el siguiente formato:
Nombre: Localidad 1
Nombre: Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
Nombre Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad N
Cantidad de casos Totales en la Provincia
Además del informe en pantalla anterior, es necesario exportar a un archivo de texto la siguiente
información: nombre de localidad, nombre de municipio y cantidad de casos del municipio, para
aquellos municipios cuya cantidad de casos supere los 1500. El formato del archivo de texto
deberá ser el adecuado para recuperar la información con la menor cantidad de lecturas
posibles.
NOTA: El archivo debe recorrerse solo una vez.
   
   
}


program corteDeControlEje18;

const
	va=9999;
	
type
	cadena=string[30];
	//icho archivo contiene: código de localidad, nombre de localidad, código de municipio, 
	//nombre de municipio, código de hospital,
	//nombre de hospital, fecha y cantidad de casos positivos detectados.
	casos=record
		codLoc:integer; //1er orden
		nombreLoc:cadena; 
		codMun:integer; //2do orden
		nombreMun:cadena;
		codHos:integer; //3er orden
		nombreHos:cadena;
		fecha:cadena;
		casosPos:integer;
	end;
	maestro=file of casos;
	
procedure leer(var mae:maestro;var reg:casos);
begin
	if (not eof(mae)) then
		read(mae,reg)
	else
		reg.codLoc:=va;
end;

procedure informe(var mae:maestro);
var
	reg,act:casos;
	cantCasosHos,cantCasosMun,cantCasosLoc,cantCasosProv:integer;
	txt:text;
	
begin
	assign(txt,'masDe1500.txt');
	rewrite(txt);
	reset(mae);
	leer(mae,reg);
	cantCasosProv:=0;
	
	while (reg.codLoc<>va) do begin
		cantCasosLoc:=0;
		act.codLoc:=reg.codLoc;
		act.nombreLoc:=reg.nombreLoc;
		writeln('Nombre: ',act.nombreLoc);
		while(reg.codLoc=act.codLoc)do begin
			cantCasosMun:=0;
			act.codMun:=reg.codMun;
			act.nombreMun:=reg.nombreMun;
			writeln('Nombre: ',act.nombreMun);
			while (reg.codLoc=act.codLoc)and (reg.codMun=act.codMun)do begin
				cantCasosHos:=0;
				act.codHos:=reg.codHos;
				act.nombreHos:=reg.nombreHos;
				writeln('Nombre: ',act.nombreHos);
				while(reg.codLoc=act.codLoc)and(reg.codMun=act.codMun)and(reg.codHos=act.codHos) do begin
					cantCasosHos:=cantCasosHos+reg.casosPos;
					leer(mae,reg);
				end;
				writeln('Cantidad de casos Hospital: ',cantCasosHos);
				cantCasosMun:=cantCasosMun+cantCasosHos;
			end;
			writeln('Cantidad de casos Municipio: ',cantCasosMun);
			cantCasosLoc:=cantCasosLoc+cantCasosMun;
			if (cantCasosMun>1500) then begin
				writeln(txt,'Localidad: ',act.nombreLoc);
				writeln(txt,'Municipio: ',act.nombreMun);
				writeln(txt,'Casos Positivos: ',cantCasosMun);
			end;
		end;
		writeln('Cantidad de caos Localidad: ',cantCasosLoc);
		cantCasosProv:=cantCasosProv+cantCasosLoc;
	end;
	writeln('Cantidad de casos Totales en la Provincia: ',cantCasosProv);
	close(mae);
	close(txt);
end;

var
	mae:maestro;
BEGIN
	informe(mae);
	
	
END.

