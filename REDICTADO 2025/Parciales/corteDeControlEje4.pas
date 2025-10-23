{
  4)
1. El Gerente General de una cadena de librerías con sucursales en todo el país 
requiere información sobre
ejemplares de libros vendidos en cada sucursal, totalizados por ISBN 
(International Standard Book Number) y por autor (puede haber más de un ISBN de un mismo autor).
Se dispone de un archivo con registros de ventas compuestos por código de sucursal (codSuc: word), 
identificador de autor (idAutor: longword), ISBN del libro (isbn: longword) e identificador 
interno de ejemplar (idEj: word). El archivo está ordenado por codSuc, idAutor e ISBN 
(puede haber varias ventas del mismo libro en una misma sucursal, pero de distintos ejemplares).
Definir los tipos de registro (tVta) y del archivo (tArchVtas) y codificar 
un procedimiento (totalizar) que reciba el archivo asignado y sin abrir y 
el nombre de un archivo de texto y reporte en el archivo de texto:
Código de Sucursal: _
Identificación de Autor: _
ISBN: _ Total de ejemplares vendidos del libro:
.. (puede haber más ISBN del mismo autor)
Total de ejemplares vendidos del autor.: _
.. (puede haber más autores)
Total de ejemplares vendidos en la sucursal: _
... (puede haber más sucursales)
TOTAL GENERAL DE EJEMPLARES VENDIDOS EN LA CADENA:
   
   
}


program corteDeControl;

const
	va=9999;
type
	cadena=string[30];
	venta=record
		codSuc:integer; //1er orden
		idAutor:cadena; //2do orden
		ISBN:integer; //3er orden
		idEj:cadena;
	end;
	
	maestro=file of venta;
	
procedure leer(var mae:maestro; var reg:venta);
begin
	if (not eof(mae)) then
		read(mae,reg)
	else
		reg.codSuc:=va;
end;

procedure totalizar(var mae:maestro);
var
	act,reg:venta;
	totalVendISBN,totalVendAutor,totalVendSuc,totalVendCadena:integer;
	txt:text;
begin
	
	totalVendCadena:=0;
	assign(mae,'archivo.dat');
	reset(mae);
	assign(txt,'totalizar.txt');
	rewrite(txt);
	
	leer(mae,reg);
	while (reg.codSuc<>va) do begin
		act.codSuc:=reg.codSuc;
		totalVendSuc:=0;
		writeln(txt,'Codigo de Sucursal: ',act.codSuc);
		while (reg.codSuc=act.codSuc) do begin
			act.idAutor:=reg.idAutor;
			writeln(txt,'Identificador del autor: ',act.idAutor);
			totalVendAutor:=0;
			
			while (reg.codSuc=act.codSuc)and(reg.idAutor=act.idAutor) do begin
				totalVendISBN:=0;
				act.ISBN:=reg.ISBN;
				while (reg.codSuc=act.codSuc)and(reg.idAutor=act.idAutor)and(reg.ISBN=act.ISBN) do begin
					totalVendISBN:=totalVendISBN+1;
					leer(mae,reg);
				end;
				writeln(txt,'ISBN: ',act.ISBN);
				writeln(txt,'Total de ejemplares del Libro: ',totalVendISBN);
				totalVendAutor:=totalVendAutor+totalVendISBN;
			end;
			writeln(txt,'Total de ejemplares vendidos por el autor: ',totalVendAutor);
			totalVendSuc:=totalVendSuc+totalVendAutor;
		end;
		writeln(txt,'Total vendidos por Sucursal: ',totalVendSuc);
		totalVendCadena:=totalVendCadena+totalVendSuc;
	end;
	writeln(txt,'TOTAL GENERAL DE EJEMPLARES VENDIDOS POR LA CADENA: ',totalVendCadena);
	close(mae);
	close(txt);		

end;
	
		
var 
	mae:maestro;
	
BEGIN
	totalizar(mae);
	
END.

