{
  MERGE
   
   
}


program actualizarMaestroConMerge;

const
  valorAlto = 9999;
  N = 3;  // cantidad de archivos detalle

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

  vector_detalles = array[1..N] of detalle;
  vector_registros = array[1..N] of venta_prod;

var
  mae: maestro;
  dets: vector_detalles;
  regs: vector_registros;
  regm: producto;

procedure leer(var arch: detalle; var dato: venta_prod);
begin
  if not EOF(arch) then
    read(arch, dato)
  else
    dato.cod := valorAlto;
end;

// mínimo entre todos los detalles, devuelve cod más chico y su posición
procedure minimo(var regs: vector_registros; var pos: integer);
var
  i: integer;
  min: integer;
begin
  min := valorAlto;
  pos := -1;
  for i := 1 to N do
    if regs[i].cod < min then
    begin
      min := regs[i].cod;
      pos := i;
    end;
end;

// Programa principal
var
  i, pos: integer;
  cod_actual, total: integer;

begin
  assign(mae, 'maestro.dat');
  reset(mae);

  // Abrir todos los archivos detalle y leer el primero de cada uno
  for i := 1 to N do
  begin
    assign(dets[i], 'detalle' + Chr(48 + i) + '.dat');  // 'detalle1.dat', 'detalle2.dat',...
    reset(dets[i]);
    leer(dets[i], regs[i]);
  end;

  // Leer primer producto del maestro
  read(mae, regm);

  // Mientras haya ventas
  minimo(regs, pos);
  while regs[pos].cod <> valorAlto do
  begin
    cod_actual := regs[pos].cod;
    total := 0;

    // Acumular todas las ventas de ese código
    while (regs[pos].cod = cod_actual) do
    begin
      total := total + regs[pos].cant_vendida;
      leer(dets[pos], regs[pos]);
      minimo(regs, pos);
    end;

    // Buscar código en el maestro
    while regm.cod <> cod_actual do
      read(mae, regm);

    // Actualizar el stock
    regm.stock := regm.stock - total;

    // Volver una posición atrás y escribir actualizado
    seek(mae, filepos(mae) - 1);
    write(mae, regm);

    // Leer el siguiente registro del maestro si no terminó
    if not EOF(mae) then
      read(mae, regm);
  end;

  // Cerrar todos los archivos
  close(mae);
  for i := 1 to N do
    close(dets[i]);

  writeln('Maestro actualizado con merge de ', N, ' archivos detalle.');
end.
