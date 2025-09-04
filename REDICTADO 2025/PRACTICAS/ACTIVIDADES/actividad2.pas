{
  Actividad 2
   
}


program Actividad2;
const
	valoralto=9999;
	DF=12;
	
type
	regMae=record  {ORDENADOS POR CODIGO DE EQUIPO}
		codigo:integer;
		nombre:string;
		cantJ:integer;
		cantG:integer;
		cantE:integer;
		cantP:integer;
		cantPtsTotal:integer;
	end;
	
	regDet=record  {ORDENADOS POR CODIGO DE EQUIPO}
		codigo:integer;
		fecha:string; //20250905 > 20250904
		cantPts:integer;
		codidoR:integer;
	end;
	
	maestro= file of regMae;
	detalle=file of regDet;
	
	vecDet=array[1..DF] of detalle;
	vecReg=array[1..DF] of regDet;
	
procedure leer(var det:detalle; var rDet:regDet);
begin
	if not eof(det) then 
		read(det,rDet)
	else
		rDet.codigo:=valoralto;
end;
	
procedure minimo(var vDet:vecDet;var vReg:vecReg;var min:regDet);
var
	i,pos:integer;
begin 
	min.codigo:=valoralto;
	for i:=1 to DF do begin
		if(vReg[i].codigo<min.codigo) then begin
			min:=vReg[i];
			pos:=i;
		end;
	end;
	if (min.codigo<>valoralto) then
		leer(vDet[pos],vReg[pos]);
end;


procedure actualizarMaestro(var mae:maestro;var v:vecDet);
var
	vReg:vecReg;
	rMae:regMae;
	i:integer;
	min:regDet;
	ptsTemporada:integer;
	nombreMax:string;
	equipoMax:integer;
	
begin
	{inicializar detalles}
	for i:=1 to DF do begin
		reset(v[i]);
		leer(v[i],vReg[i]);
	end;
	
	equipoMax:=0;
	//abrimos el maestro
	reset(mae);
	
	minimo(v,vReg,min);
	while (min.codigo<> valoralto) do begin
		ptsTemporada:=0;
		read(mae,rMae);
		while(rMae.codigo<>min.codigo) do 
			read(mae,rMae);
		while (rMae.codigo=min.codigo) do begin
			ptsTemporada:=ptsTemporada+min.cantPts;
			rMae.cantJ:=rMae.cantJ+1;
			if (min.cantPts=3)then
				rMae.cantG:=rMae.cantG+1
				
			else if (min.cantPts=1)then
				rMae.cantE:=rMae.cantE+1
				
			else if (min.cantPts=0)then
				rMae.cantP:=rMae.cantP+1;
						
			minimo(v,vReg,min);
		end;
		rMae.cantPtsTotal:=rMae.cantPtsTotal+ptsTemporada;
		if (ptsTemporada>equipoMax)then begin
			equipoMax:=ptsTemporada;
			nombreMax:=rMae.nombre;
		end;
		seek(mae,filepos(mae)-1);
		write(mae,rMae);
	end;
	close(mae);
	for i:=1 to DF do
		close(v[i]);
	writeln('EL equipo que mas puntos hizo en l atemporada: ', nombreMax);
	
	
end;
		
	
var
	i:integer;
	nombre:string;
	mae:maestro;
	vDet:vecDet;
BEGIN
	writeln('Escriba el nombre del maestro: ');
	read(nombre);
	assign(mae,nombre);
	
	for i:=1 to DF do begin
		read(nombre);
		assign(vDet[i],nombre);
	end;	
	actualizarMaestro(mae,vDet);
	
END.

