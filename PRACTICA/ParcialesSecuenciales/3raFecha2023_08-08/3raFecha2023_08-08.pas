{
  1. Archivos Secuenciales
Una empresa dedicada a la venta de golosinas posee un archivo que contiene 
información sobre los productos que tiene a la vento. De cada producto se registran 
los siguientes datos: código de producto.
nombre comercial, precio de venta, stock actual y stock mínimo.
La empresa cuenta con 20 sucursales. Diariamente, se recibe un archivo detalle de cada 
una de las 20 sucursales de la empresa que indica las ventas diarias efectuadas por cada 
sucursal. De cada venta se registra código de producto y cantidad vendida. Se debe realizar 
un procedimiento que actualice el stock en el archivo maestro con la información disponible 
en los archivos detalles y que además informe en un archivo de texto aquellos productos cuyo 
monto total vendido en el día supere los $10.000. En el archivo de texto a exportar, por cada 
producto incluido, se deben informar todos sus datos. Los datos de un producto se deben 
organizar en el archivo de texto para facilitar el uso eventual del mismo como un
archivo de carga.
El objetivo del ejercicio es escribir el procedimiento solicitado, junto con las 
estructuras de datos y
módulos usados en el mismo.
Nutes.
• Todos los archivos se encuentran ordenados por código de producto.
• En un archivo detalles pueden haber O, 1 o N registros de un producto determinado.
• Cada archivo detalle solo contiene productos que seguro existen en el archivo maestro.
• Los archivos se deben recorrer una sola vez. En el mismo recorrido, se debe 
realizar la actualización del archivo maestro con los archivos detalles, 
así como la generación del archivo de
   
}


program untitled;
uses
	SysUtils;
const
	valoralto=9999;
	DF=20;
type
	cadena=string[30];
	subrango=1..DF;
	
	producto=record
		codigo:integer;
		nombre:cadena;
		precio:real;
		stockAct:integer;
		stockMin:integer;
	end;
	
	venta=record
		codigo:integer;
		cantVendida:integer;
	end;
	
	maestro=file of producto;
	detalle=file of venta;
	
	vecDet=array[subrango] of detalle;
	vecReg=array[subrango] of venta;
	
procedure leer(var det:detalle;var info:venta);
begin
	if (not eof(det)) then 
		read(det,info)
	else
		info.codigo:=valoralto;
end;
	
procedure minimo(var v:vecDet; var vR:vecReg;var min:venta);
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

procedure merge(var mae:maestro;var v:vecDet);
var
	vR:vecReg;
	infoMae:producto;
	min:venta;
	i:subrango;
	txt:text;
	totalVendida:integer;
	montoTotal:real;
begin
	//ABRIR LOS ARCHIVOS 
	
	assign(txt,'ventasMayores.txt');
	rewrite(txt);
	
	assign(mae,'ArchivoMaestro.dat');
	reset(mae);
	
	for i:=1 to DF do begin
		assign(v[i], 'detalle' + IntToStr(i) + '.dat');
		reset(v[i]);
		leer(v[i],vR[i]);
	end;
	
	
	//LEO el primer registro maestro
	if not eof(mae) then 
		read(mae,infoMae)
	else
		infoMae.codigo:=valoralto;
	
	//ARRANCO EL MERGE
	
	//BUSCAR EL MINIMO REGISTRO ENTRE LOS 20 ARCHIVOS 
	minimo(v,vR,min);
	//RECORRER 
	while infoMae.codigo<>valoralto do begin
		totalVendida:=0;
		while min.codigo=infoMae.codigo do begin
			totalVendida:=totalVendida +min.cantVendida;
			minimo(v,vR,min);
		end;
		//Actualizar el stock
		infoMae.stockAct:=infoMae.stockAct-totalVendida;
		//calcular el monto total
		montoTotal:=totalVendida*infoMae.precio;

		if (montoTotal>100000) then begin
			writeln(txt,infoMae.codigo);
			writeln(txt,infoMae.nombre);
			writeln(txt,infoMae.precio);
			writeln(txt,infoMae.stockAct);
			writeln(txt,infoMae.stockMin);
		end;
	
		seek(mae,filepos(mae)-1);
		write(mae,infoMae);
	
		if (not eof(mae)) then
			read(mae,infoMae)
		else
			infoMae.codigo:=valoralto;
	end;
	close(txt);
	close(mae);
	for i:=1 to DF do //ciero los detalles
		close(v[i]);
end;
var 
	mae:maestro;
	v:vecDet;
	

BEGIN
	merge(mae,v);
	
END.

