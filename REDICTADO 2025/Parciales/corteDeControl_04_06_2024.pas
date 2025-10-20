{
   1. Archivos Secuenciales
Considere que se tiene un archivo que contiene información de los préstamos 
otorgados por una empresa financiera que cuenta con varias sucursales. Por 
cada préstamo se tiene la siguiente información: número de sucursal donde se 
otergó, DNI del empleado que le otorgó, número de préstamo, fecha de otorgación 
y monto otorgado. Cada préstamo otorgado por la empresa se considera como una venta. 
Además, se sabe que el archivo está ordenado por los siguientes criterios: código 
de sucursal, DNI del empleado y fecha de otorgación
(en ese orden).
Se le solicita definir las estructuras de datos necesarias y escribir el módulo 
que reciba el archivo de datos y genere un informe en un archivo de texto con el 
siguiente formato:
Informe de ventas de la empresa
Sucursal < numemero sucursal?
Empleado: DNI < DNI empleado>
Año
Cantidad de ventas
Monto de ventas Totales
Empleado: DN/ < Dni empleado>
<Total ventas empleado>
<Monto total empleado>
Cantidad total de ventas sucursal:
Monto total vendido por sucursal:
Sucursal numero sucursal
Cantidad de ventas de la empresa:
Monto total vendido por la empresa: e
   
   
}


program corteDeControl;

const
	VA=9999;

type 
	prestamo=record
		numSuc:integer;
		dni:string[8];
		numPres:integer;
		fecha:string[10];
		monto:real;
	end;
	
	maestro=file of prestamo;
	
function extraerAnio(var fecha:string):integer; // se le pasa el campo fecha del registro y devuelve anio

procedure leer(var mae:maestro; var info:prestamo);
begin 
	if (not eof(mae))then
		read(mae,info)
	else
		info.numSuc:=VA;
end;

procedure generarInforme(var mae:maestro);
var
	txt:text;
	infoMae:prestamo;
	
	sucursalActual, cantTotalEmp,cantTotalSuc,anioActual,cantAnio:integer;
	montoTotalEmp,montoAnio,montoTotalsuc:real;
	dniActual:string[8];
	
	cantTotalEmpresa:integer;
	montoTotalEmpresa:real;
begin
	assign(txt,'inform.txt'); //asigno el archivo 'inform.txt' a la variable txt
	rewrite(txt);  //creo el archivo porque no existe o si existe lo borro para empezar a escribir
	
	reset(mae);
	leer(mae,infoMae);
	
	cantTotalEmpresa:=0;    
	montoTotalEmpresa:=0;
	
	writeln(txt,'Informe de ventas de la Empresa');
	writeln(txt);
	
	while (infoMae.numSuc <> VA) do begin
		sucursalActual:=infoMae.numSuc;
		writeln(txt,'Sucursal ',sucursalActual);
		writeln(txt);
		
		cantTotalSuc:=0;
		montoTotalsuc:=0;
		
		while (sucursalActual=infoMae.numSuc) do begin
			dniActual:=infoMae.dni;
			writeln(txt,'Empleado:DNI: ',dniActual);
			
			cantTotalEmp:=0;
			montoTotalEmp:=0;
			
			while (infoMae.numSuc=sucursalActual) and(infoMae.dni=dniActual) do begin
				anioActual:=extraerAnio(infoMae.fecha);
				
				cantAnio:=0;
				montoAnio:=0;
				
				while (infoMae.numSuc=sucursalActual) and (infoMae.dni=dniActual)and (extraerAnio(infoMae.fecha)=anioActual) do begin
					cantAnio:=cantAnio+1;
					montoAnio:=montoAnio+infoMae.monto;
					leer(mae,infoMae);
				end;
				
				writeln(txt,'Año: ',anioActual);
				writeln(txt,'Cantidad de Ventas: ',cantAnio);
				writeln(txt,'Monto de Ventas: ',montoAnio:0:2);
				
				cantTotalEmp:=cantTotalEmp +cantAnio;
				montoTotalEmp:=montoTotalEmp+montoAnio;
			end;
			
			writeln(txt,'Total Ventas empleado: ', cantTotalEmp);
			writeln(txt,'Monto Total empleado: $',montoTotalEmp);
			
			cantTotalSuc:=cantTotalSuc+ cantTotalEmp;
			montoTotalsuc:=montoTotalsuc+ montoTotalEmp;
			
		end;
		
		writeln(txt,'Cantidad Total de ventas Sucursal: ',cantTotalSuc);
		writeln(txt,'Monto Total de ventas Sucursal: $',montoTotalsuc:0:2);
		
		cantTotalEmpresa:=cantTotalEmpresa+ cantTotalSuc;
		montoTotalEmpresa:=montoTotalEmpresa+montoTotalsuc;	
	
	end;
	
	writeln(txt,'cantida de Ventas Total de la Empresa: ',cantTotalEmpresa);
	writeln(txt,'Monto total de ventas de la Empresa: $',montoTotalEmpresa:0:2);
	
	close(txt);
	close(mae);
end;

var 
	mae:maestro;
	
BEGIN
	assign(mae,'prestamos.dat');
	generarInforme(mae);
	
end.

