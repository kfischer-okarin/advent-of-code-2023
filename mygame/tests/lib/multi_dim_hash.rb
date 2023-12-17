def test_multi_dim_hash_insert_get(_args, assert)
  hash = MultiDimHash.new

  hash[[1, 2, 3]] = 22

  assert.equal! hash[[1, 2, 3]], 22
  assert.nil! hash[[2, 3]]
end

def test_multi_dim_hash_constructor(_args, assert)
  hash = MultiDimHash.new([3, 2, 1] => 22)

  assert.equal! hash[[3, 2, 1]], 22
end
