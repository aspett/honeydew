defmodule Honeydew.NodeMonitorSupervisor do
  alias Honeydew.NodeMonitor

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, opts}
    }
  end

  def start_link(queue, nodes) do
    children = [{NodeMonitor, [], restart: :transient}]

    opts = [
      name: Honeydew.supervisor(queue, :node_monitor),
      strategy: :simple_one_for_one
    ]

    {:ok, supervisor} = Supervisor.start_link(children, opts)

    Enum.each(nodes, fn node ->
      Supervisor.start_child(supervisor, [node])
    end)

    {:ok, supervisor}
  end
end
