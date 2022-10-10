defmodule Challenge do

  def solve_cases(case_directory_path, number_cases, number_cases) do
    list = read_case(case_directory_path <> "/case#{number_cases}.txt")
    {:ok, matrix} = create_matrix(list, {})
    {i, j} = find_prince(matrix, 0, 0)
    amount_land = count_land(matrix, [], i, j, 0)
    IO.puts("Case #{number_cases}: #{amount_land}")
    IO.puts("The initial location of de prince is: column #{i}, row #{j}\n")
    print_list(list)
  end

  def solve_cases(case_directory_path, number_cases, count) do
    list = read_case(case_directory_path <> "/case#{count}.txt")
    {:ok, matrix} = create_matrix(list, {})
    {i, j} = find_prince(matrix, 0, 0)
    amount_land =  count_land(matrix, [], i, j, 0)
    IO.puts("Case #{count}: #{amount_land}")
    IO.puts("The initial location of de prince is: column #{i}, row #{j}\n")
    print_list(list)
    solve_cases(case_directory_path, number_cases, count+1)
  end

  def read_case(path) do
    case File.read(path) do
      {:ok, text} -> String.split(text, "\r\n", [trim: true])
      {:error, _} -> IO.puts("File doesn't exist")
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

Challenge.solve_cases("C:/Users/BRIAN/Downloads/Kommit/Challenges-Kommit/cases", 3, 1)
#Challenge.solve_cases(IO.gets("Enter the case directory path:\n"), IO.gets("Enter the number cases:\n"), 1)
