defmodule KV.Registry do
  use GenServer

  @doc """
  Start new registry.
  """
  def start_link opts do
    GenServer.start_link __MODULE__, {%{}, %{}}, opts
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
  def init {names, refs} do
    {:ok, {names, refs}}
  end

  @impl true
  def handle_call {:lookup, name}, _from, {names, _} do
    {:reply, (Map.fetch names, name), names}
  end

  @impl true
  def handle_cast {:create, name}, state do
    {names, refs} = state
    if Map.has_key? names, name do
      {:noreply, {names, refs}}
    else
      {:ok, bucket} = KV.Bucket.start_link []
      ref = Process.monitor bucket
      refs = Map.put refs, ref, name
      names = Map.put names, name, bucket
      {:noreply, {names, refs}}
    end
  end

  @impl true
  def handle_info {:DOWN, ref, :process, _pid, _reason}, {names, refs} do
    {name, refs} = Map.pop refs, ref
    names = Map.delete names, name
    {:noreply, {names, refs}}
  end

  @impl true
  def handle_info _msg, state do
    {:noreply, state}
  end
end
