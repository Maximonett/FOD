{
   I. El Gerente General de una cadena de librerías con sucursales en todo el país 
   requiere información sobre ejemplares de libros vendidos en cada sucursal, totalizados 
   por ISBN (International Standard Book Number) y
por autor (puede haber más de un ISBN de un mismo autor).
Se dispone de un archivo con registros de ventas compuestos por código de sucursal (codSuc: word), 
dentificador de autor (idAutor: longword), ISBN del libro (isbn: longword) e identificador interno de 
ejemplar (idEj: word). El archivo está ordenado por codSuc, idAutor e ISBN (puede haber varias ventas del mismo libro en
una misma sucursal, pero de distintos ejemplares).
Definir los tipos de registro (tVta) y del archivo (tArchVtas) y codificar un procedimiento (totalizar) 
que reciba el archivo asignado y sin abrir y el nombre de un archivo de texto y reporte en el archivo de texto:
Código de Sucursal: -
Identificación de Autor: -
ISBN: / . Total de ejemplares vendidos del libro:
. (puede haber más ISBN del mismo autor)
Total de ejemplares vendidos del autor:
... (puede haber más autores)
Total de ejemplares vendidos en la sucursal:
... (puede haber más sucursales)
TOTAL GENERAL DE EJEMPLARES VENDIDOS EN LA CADENA:
   
   
}


program parcial4;

const
	valoralto=9999;
type
	infoArc=record
		codigo:integer;
		idAutor:integer;
		isbn:integer;
		id:integer;
	end;
	
	archivo=file of infoArc;
	
procedure crearArchivo(var mae:archivo);
var
	txt:text;
	info:infoArc;
begin
	assign(txt,'archivo.txt');
	reset(txt);
	assign(mae,'ArchivoMaestro');
	rewrite(mae);
	while(not eof(txt))do 
		begin 
			readln(txt,info.codigo,info.idAutor,info.isbn,info.id);
			write(mae,info);
		end;
	writeln('Archivo binario creado');
	close(txt);
	close(mae);
end;


procedure leer(var a:archivo; var info:infoArc);
begin
	if (not eof(a)) then
		read(a,info)
	else
		info.codigo:=valoralto;
end;

procedure corteDeControl(var a:archivo;nom:string;var txt:text);
var
	cantTotal,sucActual,cantSuc,autorActual,cantAutor,isbnActual,cantISBN:integer;
	info:infoArc;
begin
	assign(txt,nom);
	rewrite(txt);
	reset(a);
	leer(a,info);
	cantTotal:=0;
	while (info.codigo<> valoralto) do
		begin
			writeln(txt,'Codigo de Sucursal: ',info.codigo);
			sucActual:=info.codigo;
			cantSuc:=0;
			while(info.codigo=sucActual) do 
				begin
					writeln(txt,'Identidicacion del Autor: ',info.idAutor);
					autorActual:=info.idAutor;
					cantAutor:=0;
					while (info.codigo=sucActual) and (info.idAutor=autorActual) do
						begin
							isbnActual:=info.isbn;
							cantISBN:=0;
							while((info.codigo=sucActual) and (info.idAutor=autorActual)and (info.isbn=isbnActual))do 
								begin
									cantISBN:=cantISBN+1;
									leer(a,info);
								end;
							writeln(txt,'ISBN: ',isbnActual, 'Total de ejemplares vendidos del libro:, cantISBN');
							cantAutor:=cantAutor+ cantISBN;
						end;
					writeln(txt,'Total de ejemplares vendidos del  autor',cantAutor);
					cantSuc:=cantSuc+cantAutor;
				end;
			writeln(txt,'Cantidad de ejemplares  vendidos en la sucursal', cantSuc);
			cantTotal:=cantTotal+cantSuc;
		end;
	writeln(txt,'TOTAL DE EJEMPLARES VENDIDOS EN LA CADENA: ',cantTotal);
	close(a);
	close(txt);
end;

var
	a:archivo;
	txt:text;
	nom:string;
BEGIN
	crearArchivo(a);
	writeln('Ingrese un nombre para el archivo de texto: ');
	readln(nom);
	corteDeControl(a,nom,txt);	
	
END.

