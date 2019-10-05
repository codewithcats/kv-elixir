defmodule KV.Registry do
  use GenServer

  @doc """
  Start new registry.
  """
  def start_link opts do
    GenServer.start_link __MODULE__, :ok, opts
  end

  @doc """
  Get the bucket from the registry by its name.
  """
  def lookup reg, name do
    GenServer.call reg, {:lookup, name}
  end

  @doc """
  Create new bucket and assign it a name.
  """
  def create reg, name do
    GenServer.cast reg, {:create, name}
  end

  @impl true
  def init :ok do
    {:ok, %{}}
  end

  @impl true
  def handle_call {:lookup, name}, _from, names do
    {:reply, (Map.fetch names, name), names}
  end

  @impl true
  def handle_cast {:create, name}, names do
    if Map.has_key? names, name do
      {:noreply, names}
    else
      {:ok, bucket} = KV.Bucket.start_link []
      {:noreply, (Map.put names, name, bucket)}
    end
  end
end
