{
   1. Archivos Secuenciales
Se desea automatizar el manejo de información referente a los casos positivos de 
dengue para la Provincia de Buenos Aires. Para esto se cuenta con un archivo maestro 
que contiene la siguiente información: código de municipio, nombre municipio y cantidad 
de casos positivos. Dicho archivo está ordenado por código de municipio.
Todos los meses se reciben 30 archivos que contienen la siguiente información: código de 
municipio y cantidad de casos positivos. El orden de cada archivo detalle es por código de 
municipio. En cada archivo puede venir información de cualquier municipio, un municipio puede aparecer cero una o más
de una vez en cada archivo.
Realice el sistema completo que permita la actualización de la información del archivo maestro 
a partir de los archivos detalle recalculando la cantidad de casos positivos e informando por 
pantalla aquellos municipios (código y nombre) donde la cantidad total de casos positivos es mayor a 15.
Nota: cada archivo debe recorrerse una única vez.
Nota 1: Los nombres de los archivos deben pedirse por teclado. Se puede suponer que los nombres
ingresados corresponden a archivos existentes.
Nota 2: El informe debe incluir cualquier municipio que cumpla la condición, independientemente de si se actualiza o no.
   
   
}


program untitled;

uses
	SysUtils;


const
	DF=30;
	VA=9999;
	
type
	subRango=1..DF;
	
	infoMae=record
		codigo:integer; //criterio de orden
		nombre:string;
		cantCasosPos:integer;
	end;

	infoDet=record
		codigo:integer;
		cantCasosPos:integer;
	end;
	
	maestro=file of infoMae;
	detalle=file of infoDet;
	
	vecDet=array[subRango] of detalle;
	vecReg=array[subRango] of infoDet;
	
	
procedure leer(var det:detalle;var info:infoDet);
begin
	if (not eof(det)) then
		read(det,info)
	else
		info.codigo:=VA;
end;

procedure minimo(var v:vecDet; var vecR:vecReg;var min:infoDet);
var 
	i, pos:subRango;
begin
	min.codigo:=VA;
	for i:=1 to DF do
		if(vecR[i].codigo<min.codigo) then begin 
			min:=vecR[i];
			pos:=i;
		end;
		if min.codigo<>VA then 
			leer(v[pos],vecR[pos]);
end;

procedure actualizarMaestro(var mae: maestro; var v: vecDet; var vecR: vecReg);
var
  regMae: infoMae;
  min: infoDet;
  totalCasos: integer;
  i: subrango;
begin
  reset(mae);

  // ← ← BLOQUE DE APERTURA DE DETALLES → →
  for i := 1 to DF do begin
    assign(v[i], 'detalle' + IntToStr(i) + '.dat');
    reset(v[i]);
    leer(v[i], vecR[i]);
  end;

  minimo(v, vecR, min);

  if not eof(mae) then
    read(mae, regMae)
  else
    regMae.codigo := VA;

  while regMae.codigo <> VA do begin
    totalCasos := 0;

    while min.codigo = regMae.codigo do begin
      totalCasos := totalCasos + min.cantCasosPos;
      minimo(v, vecR, min);
    end;

    if totalCasos > 0 then begin
      regMae.cantCasosPos := regMae.cantCasosPos + totalCasos;
      seek(mae, filepos(mae) - 1);
      write(mae, regMae);
    end;

    if not eof(mae) then
      read(mae, regMae)
    else
      regMae.codigo := VA;
  end;

  close(mae);

  for i := 1 to DF do
    close(v[i]);
end;



procedure mostrarMunicipios(var mae:maestro);
var 
	i:infoMae;
begin
	reset(mae);
	while not eof(mae) do begin
		read(mae,i);
		if (i.cantCasosPos>15) then
			writeln('Municipio: ',i.codigo,' Cantidad de casos Positivos: ',i.cantCasosPos,' Nombre: ',i.nombre);
	end;
	close(mae);
end;

var
  mae: maestro;
  v: vecDet;
  vecR: vecReg;
  nombresDet: array[subRango] of string;
  i: subRango;


begin
	//Ingreso nombre de los detalles 
	for i:=1 to DF do begin
		writeln('Ingrese el nombre del archivo detalle ',i,' : ');
		read(nombresDet[i]);
		assign(v[i],nombresDet[i]);
		reset(v[i]);
		leer(v[i],vecR[i]);		
	end;
	
	//abro el maestro
	assign(mae,'maestro.dat');
	
	actualizarMaestro(mae,v,vecR);
	
	//cierro todos los detalles
	
	for i:=1 to DF do 
		close(v[i]);
	
	writeln('Municiìos con mas de 15 casos positivos: ');
	mostrarMunicipios(mae);
end.
