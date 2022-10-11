defmodule Challenge do
  @moduledoc """
  Documentation for `Challenge`.

  Este modulo consta de 7 funciones, las cuales son utilizadas para la solución
  del reto primer reto con nombre "the king and his son", donde el principe
  despues de abandonar el reino de su padre, se encuentra en un lugar donde solo
  hay agua y tierra, al no saber nadar solo puede recorrer las zonas con tierra
  como entrada recibe la dirección de un directorio o carpeta donde estan los
  archivos .txt de cada caso y como salida, imprime la cantidad de tierra que
  puede recorrer incluida en la que se encuentra el principe, la ubicación inicial
  del principe e imprime el caso que se esta evaluando.
  """
  def solve_cases() do
    path = String.replace(IO.gets("Enter the case directory path:\n"), "\\", "/")
    list_Case_paths = Path.wildcard(String.replace(path, "\n", "")<>"/*.txt")
    solve_cases(list_Case_paths, 1)
  end

  def solve_cases([], _count) do
    IO.puts("All cases solved\n")
    :ok
  end

  def solve_cases(list_case_paths, count) do
    list = read_case(hd(list_case_paths))
    {:ok, matrix} = create_matrix(list, {})
    {i, j} = find_prince(matrix, 0, 0)
    amount_land =  count_land(matrix, [], i, j, 0)
    IO.puts("Case #{count}: #{amount_land}")
    IO.puts("The initial location of de prince is: column #{i}, row #{j}\n")
    print_list(list)
    solve_cases(tl(list_case_paths), count+1)
  end

  def read_case(path) do
    case File.read(path) do
      {:ok, text} -> String.split(text, "\r\n", [trim: true])
      {:error, _} -> IO.puts("File doesn't exist: #{path}")
    end
  end

  def print_list([])  do
    IO.puts("_____________________________________________________\n")
    :ok
  end

  def print_list(list) do
    IO.puts(hd list)
    print_list(tl list)
  end

  def create_matrix([], matrix) do
    {:ok, matrix}
  end

  def create_matrix(list, matrix) do
    create_matrix(tl(list),  Tuple.append( matrix, List.to_tuple(String.to_charlist(hd(list)))))
  end

  def find_prince(matrix, i, j) do
    cond do
      elem(elem(matrix, i), j) == ?@ -> {i, j}
      i == tuple_size(matrix)-1 && j == tuple_size(elem(matrix, 0))-1 -> IO.puts("Prince not found")
      j == tuple_size(elem(matrix, 0))-1 -> find_prince(matrix, i+1, 0)
      true -> find_prince(matrix, i, j+1)
    end
  end

  def count_land(matrix, [], i, j, 0) do
    cond do
      i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i-1, j, 1)
      j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i, j+1, 1)
      i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i+1, j, 1)
      j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [], i, j-1, 1)
      true -> 1
    end
  end

  def count_land(matrix, [], i, j, count)do
    if elem(elem(matrix, i), j) != :counted do
      cond do
        i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i-1, j, count+1)
        j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i, j+1, count+1)
        i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | []], i+1, j, count+1)
        j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [], i, j-1, count+1)
        true -> count+1
      end
    else
      cond do
        i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(matrix, [{i, j} | []], i-1, j, count)
        j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(matrix, [{i, j} | []], i, j+1, count)
        i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(matrix, [{i, j} | []], i+1, j, count)
        j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(matrix, [], i, j-1, count)
        true -> count
      end
    end
  end

  def count_land(matrix, position_history, i, j, count)do
    if elem(elem(matrix, i), j) != :counted do
      cond do
        i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | position_history], i-1, j, count+1)
        j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | position_history], i, j+1, count+1)
        i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), [{i, j} | position_history], i+1, j, count+1)
        j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), position_history, i, j-1, count+1)
        true -> count_land(put_elem(matrix, i, put_elem(elem(matrix, i), j, :counted)), tl(position_history), elem(hd(position_history), 0), elem(hd(position_history), 1), count+1)
      end
    else
      cond do
        i > 0 && elem(elem(matrix, i-1), j) == ?. -> count_land(matrix, [{i, j} | position_history], i-1, j, count)
        j < tuple_size(elem(matrix, 0))-1 && elem(elem(matrix, i), j+1) == ?. -> count_land(matrix, [{i, j} | position_history], i, j+1, count)
        i < tuple_size(matrix)-1 && elem(elem(matrix, i+1), j) == ?. -> count_land(matrix, [{i, j} | position_history], i+1, j, count)
        j > 0 && elem(elem(matrix, i), j-1) == ?. -> count_land(matrix, position_history, i, j-1, count)
        true -> count_land(matrix, tl(position_history), elem(hd(position_history), 0), elem(hd(position_history), 1), count)
      end
    end
  end
end

Challenge.solve_cases()
