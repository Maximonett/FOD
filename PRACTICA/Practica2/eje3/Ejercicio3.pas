{
   A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
   NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
   
}


program Ejercicio3;

const
	valor_alto='ZZZZ';
type
	cadena=string[30];

	regm=record
		provicia:cadena;
		cant_per_alf:integer;
		total_encu:integer;
	end;
	
	regd=record
		provicia:cadena;
		codL:integer;
		cant_per_alf:integer;
		cant_encu:integer;
	end;
	
	mae=file of regm;
	det=file of regd;
	
var 
	archivo_maestro:mae;
	detalle1,detalle2:det;
	reg1,reg2,min:regd;
	regm_actual:regm;
	provincia_actual:cadena;
	total_encu,total_alf:integer;



procedure leer(var archivo:det;var dato:regd);
begin
	if not eof(archivo) then 
		read(archivo,dato)
	else
		dato.provicia:=valor_alto;
end;

procedure minimo(var det1,det2:det;var r1,r2,min:regd);
begin
	if (r1.provicia<=r2.provicia) then begin
		min:=r1;
		leer(det1,r1);
	end
	else begin
		if (r2.provicia<=r1.provicia) then begin
			min:=r2;
			leer(det2,r2);
		end;
	end;	
end;
		

BEGIN

	assign(archivo_maestro,'maestro.dat');
	assign(detalle1,'detalle1.dat');
	assign(detalle2,'detalle2.dat');
	
	reset(archivo_maestro);
	reset(detalle1);
	reset(detalle2);
	
	leer(detalle1,reg1);
	leer(detalle2,reg2);
	minimo(detalle1,detalle2,reg1,reg2,min);
	
	while (min.provicia<>valor_alto) do begin
		provincia_actual:=min.provicia;
		total_alf:=0;
		total_encu:=0;
		
		while (min.provicia=provincia_actual) do begin
			total_alf:=total_alf+min.cant_per_alf;
			total_encu:=total_encu+min.cant_encu;
			minimo(detalle1,detalle2,reg1,reg2,min);
		end;
		
		// Buscar provincia en el maestro
		repeat 
			read(archivo_maestro,regm_actual);
		until(regm_actual.provicia=provincia_actual);
		
		// Actualizar datos
		regm_actual.cant_per_alf:=regm_actual.cant_per_alf+total_alf;
		regm_actual.total_encu:=regm_actual.total_encu+total_encu;
		
		seek(archivo_maestro,filepos(archivo_maestro)-1);
		write(archivo_maestro,regm_actual);
	end;
	close(archivo_maestro);
	close(detalle1);
	close(detalle2);
	
	writeln('Archivo maestro actualizado correctamente');
	
END.

