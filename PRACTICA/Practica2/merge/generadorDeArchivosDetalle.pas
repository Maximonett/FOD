{
   generador de archivos detalle
   
  
   
   
}


program generarArchivosPrueba;

type
  venta_prod = record
    cod: integer;
    cant_vendida: integer;
  end;

  producto = record
    cod: integer;
    stock: integer;
  end;

  detalle = file of venta_prod;
  maestro = file of producto;

const
  N = 3; // cantidad de archivos detalle

procedure crearMaestro;
var
  m: maestro;
  p: producto;
begin
  assign(m, 'maestro.dat');
  rewrite(m);

  // Codigos de producto con stock inicial
  p.cod := 1; p.stock := 100; write(m, p);
  p.cod := 2; p.stock := 150; write(m, p);
  p.cod := 3; p.stock := 200; write(m, p);
  p.cod := 4; p.stock := 80;  write(m, p);
  p.cod := 5; p.stock := 60;  write(m, p);

  close(m);
  writeln('Archivo maestro.dat generado.');
end;

procedure crearDetalles;
var
  i: integer;
  d: detalle;
  v: venta_prod;
begin
  // detalle1.dat
  assign(d, 'detalle1.dat');
  rewrite(d);
  v.cod := 1; v.cant_vendida := 10; write(d, v);
  v.cod := 3; v.cant_vendida := 15; write(d, v);
  v.cod := 5; v.cant_vendida := 5;  write(d, v);
  close(d);

  // detalle2.dat
  assign(d, 'detalle2.dat');
  rewrite(d);
  v.cod := 1; v.cant_vendida := 8;  write(d, v);
  v.cod := 2; v.cant_vendida := 20; write(d, v);
  v.cod := 4; v.cant_vendida := 7;  write(d, v);
  close(d);

  // detalle3.dat
  assign(d, 'detalle3.dat');
  rewrite(d);
  v.cod := 2; v.cant_vendida := 5;  write(d, v);
  v.cod := 3; v.cant_vendida := 10; write(d, v);
  v.cod := 4; v.cant_vendida := 3;  write(d, v);
  close(d);

  writeln('Archivos detalle1.dat, detalle2.dat y detalle3.dat generados.');
end;

begin
  crearMaestro;
  crearDetalles;
end.

