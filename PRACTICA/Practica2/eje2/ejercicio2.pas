{
   El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
●
Ambos archivos están ordenados por código de producto.
●
Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
●
El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock
_
minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
   
   
}


program ejercicio2;

const
	valor_alto=9999;

type
	cadena=string[20];
	
	producto=record
		codP:integer;
		nombre:cadena;
		precio:real;
		stock_actual:integer;
		stock_minimo:integer;
	end;
	
	venta=record
		codP:integer;
		cant_vendida:integer;
	end;
	
	mae=file of producto;
	det=file of venta;
	
var
	archivo_maestro:mae;
	archivo_detalle:det;
	
//---------------------------------------------------

procedure leer(var archivo:det; var v:venta);
begin
	if not EOF(archivo) then 
		read(archivo,v)
	else
		v.codP:=valor_alto;
end;

//---------------------------------------------------
// Procedimiento para actualizar el archivo maestro con el detalle


procedure actualizarMaestro(var maestro:mae;var detalle:det);
var
	cod_actual:integer;
	total_vendidas:integer;
	v:venta;
	p:producto;
begin
	reset(maestro);
	reset(detalle);
	leer(detalle,v);
	
	while (v.codP<>valor_alto) do begin
		cod_actual:=v.codP;
		total_vendidas:=0;
		
		// Sumar todas las ventas del mismo producto
		while (v.codP=cod_actual) do begin
			total_vendidas:=total_vendidas+v.cant_vendida;
			leer(detalle,v);
		end;
		// Buscar el producto en el maestro y actualizar stock
		while not EOF(maestro) do begin
			read(maestro,p);
			if (p.codP=cod_actual) then begin
				p.stock_actual:=p.stock_actual-total_vendidas;
				seek(maestro,filepos(maestro)-1);
				write(maestro,p);
				break;
			end;
		end;
		seek(maestro,0); // Reiniciar para buscar desde el principio cada vez
	end;
	close(maestro);
	close(detalle);
end;

//---------------------------------------------------
// Procedimiento para generar el archivo de texto con productos bajo stock mínimo
procedure generarStockMinimo(var maestro: mae);
var 
	txt:text;
	p:producto;
begin
	assign(txt,'stock_minimo.txt');
	rewrite(txt);
	reset(maestro);
	while not EOF(maestro) do begin
		read(maestro,p);
		if (p.stock_actual<p.stock_minimo) then 
			writeln(txt,'Codigo: ',p.codP,'-Nombre: ',p.nombre,'-Precio: ',p.precio:0:2,'-Stock Actual: ',p.stock_actual,'-Stock Minimo: ',p.stock_minimo);
	end;
	
	close(maestro);
	close(txt);
end;
	
BEGIN
	assign(archivo_maestro,'maestro.dat');
	assign(archivo_detalle,'detalle.dat');
	
	actualizarMaestro(archivo_maestro,archivo_detalle);
	generarStockMinimo(archivo_maestro);	
END.

