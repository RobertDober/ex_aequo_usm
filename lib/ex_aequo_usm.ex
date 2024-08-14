defmodule ExAequoUsm do

  import ExAequoUsm.Transition, only: [transition: 4] 
  @moduledoc """
  # The "Ultimate" State Machine
  """

  def run(input, states, current_state \\ :start, context \\ %{}) do
    _run(input, states, current_state, context, [])
  end

  defp _run(input, states, current_state, context, output)
  defp _run([], _states, _current_state, context, output) do
    {Enum.reverse(output), context}
  end
  defp _run([line|rest], states, current_state, context, output) do
    {ns, ctxt, action} = transition(line, states, current_state, context)
    case action do
      :ignore -> _run(rest, states, ns, ctxt, output)
      :return -> {Enum.reverse(output), ctxt}
      nil -> _run(rest, states, ns, ctxt, [line|output])
      {:replace, new} -> _run(rest, states, ns, ctxt, [new|output])
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
