{
   GENERADOR DE MAESTRO.DAT Y DETALLE.DAT
   
   
}


program generarArchivos;

type
  cadena = string[20];

  producto = record
    codP: integer;
    nombre: cadena;
    precio: real;
    stock_actual: integer;
    stock_minimo: integer;
  end;

  venta = record
    codP: integer;
    cant_vendida: integer;
  end;

  mae = file of producto;
  det = file of venta;

var
  maestro: mae;
  detalle: det;
  p: producto;
  v: venta;

begin
  // Crear archivo maestro
  assign(maestro, 'maestro.dat');
  rewrite(maestro);

  p.codP := 1; p.nombre := 'Lavandina'; p.precio := 100; p.stock_actual := 30; p.stock_minimo := 20; write(maestro, p);
  p.codP := 2; p.nombre := 'Detergente'; p.precio := 80; p.stock_actual := 15; p.stock_minimo := 10; write(maestro, p);
  p.codP := 3; p.nombre := 'Desinfectante'; p.precio := 120; p.stock_actual := 8; p.stock_minimo := 10; write(maestro, p);
  p.codP := 4; p.nombre := 'Jabon Liquido'; p.precio := 90; p.stock_actual := 50; p.stock_minimo := 25; write(maestro, p);

  close(maestro);

  // Crear archivo detalle
  assign(detalle, 'detalle.dat');
  rewrite(detalle);

  v.codP := 1; v.cant_vendida := 5; write(detalle, v);
  v.codP := 2; v.cant_vendida := 6; write(detalle, v);
  v.codP := 2; v.cant_vendida := 3; write(detalle, v);
  v.codP := 3; v.cant_vendida := 4; write(detalle, v);
  v.codP := 4; v.cant_vendida := 30; write(detalle, v);
  v.codP := 9999; v.cant_vendida := 0; write(detalle, v); // fin lógico ficticio

  close(detalle);

  writeln('Archivos maestro.dat y detalle.dat generados correctamente.');
end.
