defmodule Challenge do

  def read_case(path) do
    case File.read(path) do
      {:ok, text} -> String.split(text, "\r\n", [trim: true])
      {:error, _} -> IO.puts("No existe el archivo")
    end
  end

  def print_list([])  do

  end

  def print_list(list) do
    IO.puts(hd list)
    print_list(tl list)
  end

  def create_matrix([], matrix) do
    _ = matrix
  end

  def create_matrix(list, matrix) do
    create_matrix(tl(list),  Tuple.append( matrix, List.to_tuple(String.to_charlist(hd(list)))))
  end

  def find_prince(matrix, i, j) do
    cond do
      elem(elem(matrix, i), j) == ?@ -> {i, j}
      i == tuple_size(matrix)-1 && j == tuple_size(elem(matrix, 0))-1 -> IO.puts("No se encontró ningún principe")
      j == tuple_size(elem(matrix, 0))-1 -> find_prince(matrix, i+1, 0)
      true -> find_prince(matrix, i, j+1)
    end
  end

  def create_route_matrix(matrix, i, j) do
    cond do
      i == tuple_size(matrix)-1 && j == tuple_size(elem(matrix, 0))-1 -> put_elem(matrix, i, put_elem(elem(matrix, i), j, :unchecked))
      j == tuple_size(elem(matrix, 0))-1 -> create_route_matrix(put_elem(matrix, i, put_elem(elem(matrix, i), j, :unchecked)), i+1, 0)
      true -> create_route_matrix(put_elem(matrix, i, put_elem(elem(matrix, i), j, :unchecked)), i, j+1)
    end
  end

end

list = Challenge.read_case("C:/Users/BRIAN/Downloads/Kommit/Challenges-Kommit/casoprueba.txt")
Challenge.print_list(list)
matrix = Challenge.create_matrix(list, {})
{i, j} = Challenge.find_prince(matrix, 0, 0)
IO.puts("El principe se encuentra en la ubicacion: fila #{i} columna #{j}")
route_matrix = Challenge.create_route_matrix(matrix, 0, 0)
IO.puts(route_matrix)
