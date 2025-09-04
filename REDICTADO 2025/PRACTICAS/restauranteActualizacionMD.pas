{
  Una cadena de restaurantes desea contabilizar las ventas de sus platos a fin
de promocionar sus platos más vendidos.
Para esto posee un archivo con la siguiente información: código de plato,
nombre, costo, fecha de lanzamiento y cantidad vendida.
Semanalmente recibe de cada restaurante (existen 17 restaurantes), un
archivo con la siguiente información: código de plato y cantidad vendida.
Escriba el programa principal con la declaración de tipos necesaria y realice
un proceso que reciba los 17 detalles y actualice el archivo maestro con la
información proveniente de los archivos detalles. Tanto el maestro como los
detalles se encuentran ordenados por código de plato.
NOTA: todos los códigos de plato de los archivos detalle seguro existen en el
maestro. 
   
   
}

program actualizacionMaestroDetalle;

const
	valoralto=9999;
	DF=17;
type
	regMaestro=record
		codigo:integer; 
		nombre:String;
		costo:real;
		fecha:LongInt;
		cantV:integer;
	end;
	
	regDet=record
		codigo:integer;
		cantV:integer;
	end;
	
	maestro=file of regMaestro;
	detalle=file of regDet;
	
	vecReg=array[1..DF] of regDet;
	vecDet=array[1..DF] of detalle;

procedure Leer(var det:detalle;var regD:regDet);
begin
	if not EOF(det) then
		read(det,regD)
	else
		regD.codigo:=valorAlto;
end;

procedure minimo(var v:vecDet; var vR:vecReg;var min:regDet);
var
	i,pos:integer;
begin
	min.codigo:=valoralto;
	for i:=1 to DF do 
		if (vR[i].codigo<min.codigo) then begin
			min:=vR[i];
			pos:=i;
		end;
	if(min.codigo<>valoralto) then
		leer(v[pos],vR[pos]);
end;

procedure actualizarMaestro(var mae:maestro; var v:vecDet);
var
	vR:vecReg;
	min:regDet;
	regMae:regMaestro;
	i:integer;
begin
	{inicializar detalles}
	for i:=1 to DF do begin
		reset(v[i]);
		leer(v[i],vR[i]);
	end;
	
	reset(mae); {abro el maestro}
	
	minimo(v,vR,min);
	while (min.codigo<> valoralto) do begin
		read(mae,regMae);
		while (regMae.codigo<>min.codigo) do 
			read(mae,regMae);
		{acumular ventas }	
		while (regMae.codigo=min.codigo) do begin
			regMae.cantV:=regMae.cantV+min.cantV;
			minimo(v,vR,min);
		end;
		seek(mae,filepos(mae)-1);
		write(mae,regMae);
	end;
	close(mae);
	for i:=1 to DF do
		close(v[i]);
end;
	
var
	m:maestro;
	vDet:vecDet;
	i:integer;
	nombreDet:string;
	
BEGIN

	for i:=1 to DF do begin
		writeln('Escriba un nombre para el archivo: ');
		readln(nombreDet);
		assign(vDet[i],nombreDet);
	end;
	actualizarMaestro(m,vDet);
	
end.
