defmodule ExAequoUsm.Types do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do

      @type binaries :: list(binary())
      @type binary? :: maybe(binary())

      @type maybe(t) :: nil | t

    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
