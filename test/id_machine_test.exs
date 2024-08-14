defmodule Test.IdMachineTest do
  use ExUnit.Case

  import ExAequoUsm

  @triggers %{
    start: [true]
  }

  test "empty intput" do
    assert run([], @triggers) == {[], %{}}
  end

  test "more input" do
    input = ~W[alpha beta gamma]
    assert run(input, @triggers) == {input, %{}}
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
