{
   Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con 
   la información correspondiente a las prendas que se encuentran a la venta. De cada 
   prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y precio_ unitario. 
   Ante un eventual cambio de temporada, se deben actualizar las prendas a la venta. 
   Para ello reciben un archivo conteniendo: cod_prenda de las prendas que quedarán obsoletas. 
   Deberá implementar un procedimiento que reciba ambos archivos y realice 
   la baja lógica de las prendas, para ello deberá
modificar el stock de la prenda correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las 
mismas compactando el archivo. Para ello no podrá utilizar ninguna estructura 
auxiliar, debe resolverlo dentro del mismo archivo. Solo deben quedar en el archivo 
las prendas que no fueron borradas, una vez realizadas
todas las bajas físicas.
   
   
}


program parcial5;
type
	infoMaestro=record
		codigo:integer;
		descripcion:string;
		colores:string;
		tipo:string;
		stock:integer;
		precioUnitario:real;
	end;
	
	arcMaestro= file of infoMaestro;
	arcDetalle=file of integer;


procedure bajasLogicas(var mae:arcMaestro; var det:arcDetalle);
var
	infoMae:infoMaestro;
	codigo:integer;
begin
	reset(mae);
	reset(det);
	while (not eof(det)) do 
		begin
			read(det,codigo);
			seek(mae,0);
			while (infoMae.codigo<> codigo) do 				 
				read(mae,infoMae);
			seek(mae,filepos(mae)-1);
			infoMae.stock:=-1;
			write(mae,infoMae);
		end;
	close(mae);
	close(det);
end;
{
COMPACTACION
Se detecta un registro con stock < 0.

Se guarda la posición (pos) de ese registro.

Se busca el último registro del archivo (filesize(arc) - 1).

Si ese último también tiene stock < 0, se lo elimina con truncate(arc), 
y se sigue buscando hacia atrás otro válido.

Una vez encontrado uno válido, se lo copia en la posición pos, reemplazando el registro a eliminar.

Finalmente, se elimina el último registro, que ahora está duplicado, usando truncate(arc) nuevamente.}
procedure compactacion(var arc:arcMaestro);
var
	a:infoMaestro;
	pos:integer;
begin
	reset(arc);
	while (not eof(arc)) do 
		begin
			read(arc,a);
			if (a.stock<0) then
				begin
					pos:=filepos(arc)-1;
					seek(arc,filesize(arc)-1);
					read(arc,a);
					if (filepos(arc)-1<>0) then
						while(a.stock<0)do 
							begin
								seek(arc,filesize(arc)-1);
								truncate(arc);
								seek(arc,filesize(arc)-1);
								read(arc,a);
							end;
					seek(arc,pos);
					write(arc,a);
					seek(arc,filesize(arc)-1);
					truncate(arc);
					seek(arc,pos);
				end;
		end;
	close(arc);
end;

procedure cargarArchivo(var a:arcMaestro);
var
	infoMae:infoMaestro;
begin
	assign(a,'ArchivoMaestro');
	rewrite(a);
	
	writeln('Ingrese codigo');
	readln(infoMae.codigo);
	while (infoMae.codigo<>-1) do
		begin
			writeln('Ingrese stock');
			readln(infoMae.stock);
			writeln('Ingrese codigo');
			readln(infoMae.codigo);			
		end;
	close(a);
end;

procedure cargarDetalle(var a:arcDetalle);
var
	codigo:integer;
begin
	assign(a,'Detalle');
	rewrite(a);
	writeln('Ingrese codigo');
	readln(codigo);
	while(codigo<>-1) do
		begin
			write(a,codigo);
			writeln('Ingrese codigo');
			readln(codigo);			
		end;
	close(a);
end;

procedure imprimirArchivo(var a:arcMaestro);
var
	infoMae:infoMaestro;
begin
	reset(a);
	while(not eof(a)) do
		begin
			read(a,infoMae);
			writeln(infoMae.codigo,' Stock= ', infoMae.stock);
		end;
	close(a);
end;

var
	mae:arcMaestro;
	det:arcDetalle;

BEGIN
	cargarArchivo(mae);
	cargarDetalle(det);
	bajasLogicas(mae,det);
	imprimirArchivo(mae);
	writeln();
	compactacion(mae);
	imprimirArchivo(mae);
	
END.

