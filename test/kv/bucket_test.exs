defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link([])
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "any") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "delete value by key", %{bucket: bucket} do
    KV.Bucket.put(bucket, "milk", 3)
    value = KV.Bucket.delete(bucket, "milk")
    assert 3 = value
    assert KV.Bucket.get(bucket, "milk") |> is_nil
  end
end
