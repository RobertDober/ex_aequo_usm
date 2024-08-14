defmodule ExAequoUsm.Transition do
  use ExAequoUsm.Types

  @type action_t :: nil | atom() | {map(), atom()}
  @type pp_result_t :: action_t() | {map(), action_t()}
  @type pp_fun_t :: ((binary(), map()) -> pp_result_t())
  @type result_t :: {atom(), map(), action_t()}
  
  @doc false
  def transition(line, states, current_state, context) do
    triggers = Map.fetch!(states, current_state)
    case find_transition(line, triggers, current_state, context) do
      nil -> {current_state, context, :ignore}
      result -> result
    end
  end
  
  # @spec apply_postprocessor(pp_fun_t(), binary(), map(), any()) :: {map(), action_t()}
  defp apply_postprocessor(pp, line, context, data) do
    case pp.(line, context, data) do
      {_, _} = result -> result
      action -> {context, action}
    end
  end

  defp find_transition(line, triggers, current_state, context) do
    Enum.find_value(triggers, &match_trigger_with(line, context, current_state, &1))
  end

  @spec match_fun_trigger(binary(), map(), fun(), atom()) :: {atom(), map()}
  defp match_fun_trigger(line, context, fun, new_state) do
    case fun.(line, context) do
      nil -> nil
      {_, {_, _}} = result -> result
      action -> { new_state, context, action}
    end
  end

  # @spec match_rgx_trigger(binary(), map(), Regex.t(), atom(), pp_fun_t()) ::  {atom(), action_t()}
  defp match_rgx_trigger(line, context, rgx, new_state, post_processor) do
    case Regex.run(rgx, line) do
      nil -> nil
      matches -> _match_rgx_trigger(line, context, new_state, post_processor, matches)
    end
  end

  @spec _match_rgx_trigger(binary(), map(), atom(), maybe(pp_fun_t()), list) :: {atom(), action_t()}
  defp _match_rgx_trigger(line, context, new_state, post_processor, matches) do
    ctxt = if Map.has_key?(context, :matches), do: Map.put(context, :matches, matches), else: context
    case post_processor do
      fun when is_function(fun) -> {new_state, apply_postprocessor(fun, line, ctxt, matches)}
      action -> {new_state, ctxt, action} 
    end
  end

  @type trigger_t :: fun() | {fun(), atom()} | Regex.t() | {Regex.t(), atom()} | {Regex.t(), atom(), fun()}

  @spec match_trigger_with(binary(), map(), atom(), trigger_t()) :: result_t()
  defp match_trigger_with(line, context, current_state, trigger) do
    case trigger do
      {%Regex{}=rgx, ns, pp} -> match_rgx_trigger(line, context, rgx, ns, pp)
      {%Regex{}=rgx, ns} -> match_rgx_trigger(line, context, rgx, ns, nil)
      %Regex{}=rgx -> match_rgx_trigger(line, context, rgx, current_state, nil)
      {true, ns} -> {ns, context, nil} 
      {fun, ns} -> match_fun_trigger(line, context, fun, ns)
      true -> {current_state, context, nil} 
      fun -> match_fun_trigger(line, context, fun, current_state)
    end
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
