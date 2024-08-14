defmodule Test.Support.ReverseOddLinesMachine do

  defp reverse_line(line, _ctxt) do
    {:replace, String.reverse(line)}
  end

  def triggers, do: %{
    start: [ {&reverse_line/2, :even} ],
    even: [ {true, :start} ]
  }
end
# SPDX-License-Identifier: AGPL-3.0-or-later
