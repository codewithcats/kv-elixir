defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    reg = start_supervised! KV.Registry
    %{reg: reg}
  end

  test "Spawn bucket", %{reg: reg} do
    assert (KV.Registry.lookup reg, "shopping") == :error

    KV.Registry.create reg, "shopping"
    KV.Registry.lookup reg, "shopping"
    # assert {:ok, bucket} = KV.Registry.lookup reg, "shopping"

    # KV.Bucket.put bucket, "milk", 3
    # assert (KV.Bucket.get bucket, "milk") == 3
  end

  # test "Remove bucket on exit", %{reg: reg} do
  #   KV.Registry.create reg, "shopping"
  #   {:ok, shopping} = KV.Registry.lookup reg, "shopping"
  #   Agent.stop shopping
  #   assert (KV.Registry.lookup reg, "shopping") == :error
  # end
end
