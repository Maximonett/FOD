{
• Existe un archivo maestro.
• Existe un único archivo detalle que modifica al
maestro.
• Cada registro del detalle modifica a un registro del
maestro que seguro existe.
• No todos los registros del maestro son
necesariamente modificados.
• Cada elemento del archivo maestro puede modificado, o ser modificado por uno o más
elementos del detalle.
no ser
• Ambos archivos están ordenados por igual criterio.


}




program actualizar_maestro;

const
  valor_alto = 'ZZZZ';

type
  str4 = string[4];

  // Registro del maestro: producto con código, descripción, precio unitario y stock
  producto = record
    cod: str4;
    descripcion: string[30];
    pu: real;
    stock: integer;
  end;

  // Registro del detalle: código del producto y cantidad vendida
  venta_prod = record
    cod: str4;
    cant_vendida: integer;
  end;
  
  mae= file of producto;
  det= file of venta_prod;
	
var
  archivo_maestro:mae;
  archivo_detalle:det;
	
  regm: producto;
  regd: venta_prod;
  total: integer;
  aux: str4;
  
  

procedure convertirTxtABinMaestro;
var 
	txt:text;
	bin:file of producto;
	p:producto;
begin
	assign(txt,'maestro.txt');
	reset(txt);
	
	assign(bin,'maestro.dat');
	rewrite(bin);
	while not eof(txt) do 
	begin
		readln(txt,p.cod,p.descripcion,p.pu,p.stock);
		write(bin,p);
	end;
	close(txt);
	close(bin);
	
	writeln('El binario se ha creado correctamente');
end;
	
procedure convertirTxtABinDetalle;
var
	txt:text;
	bin:file of venta_prod;
	v:venta_prod;
begin
	assign(txt,'detalle.txt');
	reset(txt);
	
	assign(bin,'detalle.dat');
	rewrite(bin);
	while not eof(txt) do 
	begin
		readln(txt,v.cod,v.cant_vendida);
		write(bin,v);
	end;
	close(txt);
	close(bin);
	
	writeln('El binario se ha creado crorectamente');
end;

  
  // Procedimiento para leer del archivo detalle, con control de fin de archivo
procedure leer(var archivo: det; var dato: venta_prod);
begin
  if not EOF(archivo) then
    read(archivo, dato)
  else
    dato.cod := valor_alto; // Marca fin de archivo
end;



//PROGRAMA PRINCIPAL

begin
  convertirTxtABinMaestro;
  convertirTxtABinDetalle;

  // Abrir los archivos maestro y detalle
  assign(archivo_maestro, 'maestro.dat');
  assign(archivo_detalle, 'detalle.dat');
  reset(archivo_maestro);
  reset(archivo_detalle);

  // Leer el primer registro de cada archivo
  read(archivo_maestro, regm);
  leer(archivo_detalle, regd);

  // Mientras no se llegue al final del archivo detalle
  while (regd.cod <> valor_alto) do
  begin
    aux := regd.cod;
    total := 0;

    // Sumar todas las cantidades vendidas del mismo producto
    while (regd.cod = aux) do
    begin
      total := total + regd.cant_vendida;
      leer(archivo_detalle, regd);
    end;

    // Buscar el producto correspondiente en el maestro
    while (regm.cod <> aux) do
      read(archivo_maestro, regm);

    // Actualizar el stock del producto
    regm.stock := regm.stock - total;
	
    // Volver una posición atrás para sobreescribir el registro correcto
    seek(archivo_maestro, filepos(archivo_maestro) - 1);
    write(archivo_maestro, regm); // Escribir el producto actualizado
    writeln('Producto ', regm.cod, ' actualizado. Stock nuevo: ', regm.stock);


    // Leer el próximo registro del maestro (si no es EOF)
    if not EOF(archivo_maestro) then
      read(archivo_maestro, regm);
  end;
  writeln('Actualizacion correcta');
  // Cerrar los archivos
  close(archivo_detalle);
  close(archivo_maestro);
end.
