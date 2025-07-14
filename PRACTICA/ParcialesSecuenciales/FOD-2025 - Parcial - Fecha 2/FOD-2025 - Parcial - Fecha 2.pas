{
   Se desea automatizar el manejo de información referente al desempeño histórico de
los equipos de fútbol de la Liga Profesional Argentina. Para esto se cuenta con un
archivo maestro que contiene, por cada equipo, la siguiente información: código de
equipo, nombre del equipo, cantidad de partidos jugados, cantidad de partidos
ganados, cantidad de partidos empatados, cantidad de partidos perdidos y cantidad
de puntos acumulados. El archivo maestro está ordenado por código de equipo.
Al finalizar la temporada (año), se reciben 12 archivos detalle (uno por cada mes),
que contienen información de los partidos jugados por los equipos durante cada mes
del año. Cada archivo contiene múltiples registros con la siguiente información:
código de equipo, fecha del partido, cantidad de puntos obtenidos en ese partido (3
si ganó, 1 si empató, 0 si perdió) y código del equipo rival. Los archivos detalle están
ordenados por código de equipo. En cada archivo puede haber información de
cualquier equipo, y un mismo equipo puede aparecer más de una vez o no aparecer
en absoluto.
Defina los tipos de datos necesarios para representar la información del archivo
maestro y los archivos detalles, e implemente un procedimiento (y los
procedimientos que utilice) que permita actualizar el archivo maestro a partir de los
archivos detalle, recalculando los valores estadísticos de cada equipo: partidos
jugados, ganados, empatados, perdidos y puntos acumulados. Además, durante el
mismo recorrido en que se actualiza la información, se debe determinar e informar
por pantalla el equipo que más puntos sumó a lo largo de la temporada (año). Se
debe mostrar el nombre del equipo junto con la cantidad de puntos obtenidos en el
año.
Notas:
1. Los nombres de los archivos deben pedirse por teclado. Se puede suponer
que los nombres ingresados corresponden a archivos existentes.
2. Los archivos se deben recorrer una única vez
   
   
}


program untitled;

uses
	SysUtils;

const
	VA=9999;
	N=12;
type
	cadena=String[30];
	
	TEquipo=record
		codEquipo:integer;
		nomEquipo:cadena;
		cantJ:integer;
		cantG:integer;
		cantE:integer;
		cantP:integer;
		cantPuntos:integer;
	end;
	
	TPartido=record
		codEquipo:integer;
		fechaPartido:longInt;
		cantPuntos:integer;
		codRival:integer;
	end;
	
	maestro=file of TEquipo;
	detalle=file of TPartido;
	
	detalles=array[1..N] of detalle;
	regDetalle=array[1..N] of TPartido;
	
procedure CrearMaestro;
var
  archM: maestro;
  equipo: TEquipo;
  i: integer;
begin
  Assign(archM, 'maestro.dat');
  Rewrite(archM);

  for i := 1 to 5 do
  begin
    equipo.codEquipo := i;
    equipo.nomEquipo := 'Equipo_' + IntToStr(i);
    equipo.cantJ := Random(30) + 1;
    equipo.cantG := Random(equipo.cantJ);
    equipo.cantE := Random(equipo.cantJ - equipo.cantG);
    equipo.cantP := equipo.cantJ - equipo.cantG - equipo.cantE;
    equipo.cantPuntos := equipo.cantG * 3 + equipo.cantE;

    Write(archM, equipo);
  end;

  Close(archM);
  writeln('Archivo maestro creado.');
end;

procedure CrearDetalles;
var
  dets: detalles;
  partido: TPartido;
  i, j, cantPartidos: integer;
  nombreArchivo: string;
begin
  Randomize;

  for i := 1 to N do
  begin
    nombreArchivo := 'detalle' + IntToStr(i) + '.dat';
    Assign(dets[i], nombreArchivo);
    Rewrite(dets[i]);

    cantPartidos := Random(4) + 2; // entre 2 y 5 partidos ficticios

    for j := 1 to cantPartidos do
    begin
      partido.codEquipo := Random(5) + 1;
      partido.fechaPartido := 20250000 + Random(1231) + 1; // fecha ficticia YYYYMMDD
      partido.cantPuntos := Random(4); // 0, 1, 2 o 3 puntos
      partido.codRival := Random(5) + 1;

      Write(dets[i], partido);
    end;

    Close(dets[i]);
    writeln('Archivo ', nombreArchivo, ' creado con ', cantPartidos, ' registros.');
  end;
end;

	
	
	
	
procedure leer(var a:detalle; var reg:TPartido);
begin
	if (not eof(a)) then
		read(a,reg)
	else
		reg.codEquipo:=VA;
end;

procedure minimo(var vDet:detalles;var rDet:regDetalle;var min:TPartido);
var
	i,posMin:integer;
begin
	posMin:=-1; min.codEquipo:=VA;
	for i:=1 to N do begin
		if (rDet[i].codEquipo<min.codEquipo) then begin
			min:=rDet[i];
			posMin:=i;
		end;
	end;
	if (min.codEquipo<> VA) then
		leer(vDet[posMin],rDet[posMin]);
end;

procedure asignarArchivos(var mae:maestro;var vDet:detalles);
var
	i:integer;
	nombreDeArchivo:cadena;
begin
	writeln('Ingrese el nombre del archivo maestro: '); readln(nombreDeArchivo);
	assign(mae,nombreDeArchivo);
	for i:=1 to N do begin
		writeln('Ingrese el nombre del archivo detalle: '); readln(nombreDeArchivo);
		assign(vDet[i],nombreDeArchivo);
	end;
end;

procedure ejercicio(var m:maestro;var vDet:detalles);
var
	i,puntos, maxPuntos:integer; min:TPartido; 
	nombreMax:cadena;
	regM:TEquipo;
	partidos:regDetalle;
	
begin
	maxPuntos:=-1;
	asignarArchivos(m,vDet);
	reset(m);
	//ABOR LOS DETALLES y LOS LEO
	for i:=1 to N do begin
		reset(vDet[i]);
		leer(vDet[i],partidos[i]);
	end;
	
	minimo(vDet,partidos,min);
	
	while (min.codEquipo<>VA) do begin
		read(m,regM);
		while (regM.codEquipo<> min.codEquipo) do
			read(m,regM);
		puntos:=0;
		while (regM.codEquipo=min.codEquipo) do begin
			puntos:=puntos+ min.cantPuntos;
			regM.cantJ:=regM.cantJ+1;
			if (min.cantPuntos=3)then
				regM.cantG:=regM.cantG+1
			else
				if(min.cantPuntos=1)then
					regM.cantE:=regM.cantE+1
				else
					regM.cantP:=regM.cantP+1;
			minimo(vDet,partidos,min);
		end;
		regM.cantPuntos:=regM.cantPuntos+puntos;
		
		if (puntos>maxPuntos) then begin
			maxPuntos:=puntos;
			nombreMax:=regM.nomEquipo;
		end;
		seek(m,filepos(m)-1);
		write(m,regM);
	end;
	writeln('El equipo que mas puntos sumo en la temporada fue: ',nombreMax,' con ',maxPuntos,' Puntos.');
	close(m);
	for i:=1 to N do begin
		close(vDet[i]);
	end;
end;

var
	mae:maestro;
	vDet:detalles;

BEGIN
	CrearMaestro;
    CrearDetalles;
	asignarArchivos(mae,vDet);
	ejercicio(mae,vDet);
	
END.

