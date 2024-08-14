defmodule Test.ReverseOddLinesMachineTest do
  use ExUnit.Case

  import ExAequoUsm
  import Test.Support.ReverseOddLinesMachine


  test "empty intput" do
    assert run([], triggers()) == {[], %{}}
  end

  test "reverses odd lines" do
    input = ~W[ alpha beta gamma ]
    expected = ~W[ ahpla beta ammag ]
    assert run(input, triggers()) == {expected, %{}}
  end


end
# SPDX-License-Identifier: AGPL-3.0-or-later
