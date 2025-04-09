{
   Actualizacion de un maestro con un detalle
   
   
}


program actualizarMaestro;

const
  valorAlto = 9999;

type
  venta_prod = record
    cod: integer;
    cant_vendida: integer;
  end;

  producto = record
    cod: integer;
    stock: integer;
  end;

  maestro = file of producto;
  detalle = file of venta_prod;

var
  mae: maestro;
  det: detalle;
  regm: producto;
  regd: venta_prod;
  total, aux: integer;

// Procedimiento para leer del archivo detalle
procedure leer(var archivo: detalle; var dato: venta_prod);
begin
  if not EOF(archivo) then
    read(archivo, dato)
  else
    dato.cod := valorAlto;
end;

// Programa principal
begin
  assign(mae, 'maestro.dat');
  assign(det, 'detalle.dat');
  reset(mae);
  reset(det);

  read(mae, regm);
  leer(det, regd);

  // Procesar todos los registros del archivo detalle
  while regd.cod <> valorAlto do
  begin
    aux := regd.cod;
    total := 0;

    // Acumular ventas del mismo producto
    while aux = regd.cod do
    begin
      total := total + regd.cant_vendida;
      leer(det, regd);
    end;

    // Buscar el producto en el archivo maestro si es distinto sigue buscando cuando encuentra sale del while 
    while regm.cod <> aux do
      read(mae, regm);

    // Actualizar stock resta al stock la cantidad vendida
    regm.stock := regm.stock - total;

    // Reposicionar puntero para escribir en la misma posición
    seek(mae, filepos(mae) - 1);
    write(mae, regm);

    // Leer siguiente del maestro (si no se terminó)
    if not EOF(mae) then
      read(mae, regm);
  end;

  close(det);
  close(mae);
end.


