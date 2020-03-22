require 'recursive-open-struct'

def ostruct(hash)
  RecursiveOpenStruct.new(hash, recurse_over_arrays: true)
end
