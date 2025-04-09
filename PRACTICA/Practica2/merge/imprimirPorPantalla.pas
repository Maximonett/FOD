{
  Imprimir Mastros y detalles por pantalla
   
   
}


program mostrarArchivos;

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

procedure mostrarMaestro;
var
  m: maestro;
  p: producto;
begin
  assign(m, 'maestro.dat');
  reset(m);
  writeln('Contenido de maestro.dat:');
  writeln('--------------------------');
  while not eof(m) do
  begin
    read(m, p);
    writeln('Código: ', p.cod, ' | Stock: ', p.stock);
  end;
  close(m);
  writeln;
end;

procedure mostrarDetalle(nombre: string);
var
  d: detalle;
  v: venta_prod;
begin
  assign(d, nombre);
  reset(d);
  writeln('Contenido de ', nombre, ':');
  writeln('-----------------------------');
  while not eof(d) do
  begin
    read(d, v);
    writeln('Código: ', v.cod, ' | Vendidos: ', v.cant_vendida);
  end;
  close(d);
  writeln;
end;

begin
  mostrarMaestro;
  mostrarDetalle('detalle1.dat');
  mostrarDetalle('detalle2.dat');
  mostrarDetalle('detalle3.dat');
end.


