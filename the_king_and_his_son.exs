defmodule Lectura do

  def leer_caso(ruta) do
    case File.read(ruta) do
      {:ok, texto} -> String.split(texto, "\r\n", [trim: true])
      {:error, _} -> IO.puts("No existe el archivo")
    end
  end

  def imprimir_lista([])  do

  end

  def imprimir_lista(list) do
    IO.puts(hd list)
    imprimir_lista(tl list)
  end

  def crear_matriz([], matriz) do
    _ = matriz
  end

  def crear_matriz(list, matriz) do
    crear_matriz(tl(list),  Tuple.append( matriz , List.to_tuple(String.to_charlist(hd(list)))))
  end

  def encontrar_principe(matriz, i, j) do
    cond do
      elem(elem(matriz, i), j) == ?@ -> {i, j}
      i == tuple_size(matriz)-1 && j == tuple_size(elem(matriz, 0))-1 -> IO.puts("No se encontró ningún principe")
      j == tuple_size(elem(matriz, 0))-1 -> encontrar_principe(matriz, i+1, 0)
      true -> encontrar_principe(matriz, i, j+1)
    end
  end

end

list = Lectura.leer_caso("C:/Users/BRIAN/Downloads/Kommit/Challenges-Kommit/caso1.txt")
Lectura.imprimir_lista(list)
matriz = Lectura.crear_matriz(list, {})
{i, j} = Lectura.encontrar_principe(matriz, 0, 0)
IO.puts("El principe se encuentra en la ubicacion: fila #{i} columna #{j}")
