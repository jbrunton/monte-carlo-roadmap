def stub_rand_and_return(random, values)
  stub_and_return(random, :rand, values: values)
end

def stub_and_return(target, method, opts)
  index = 0
  allow(target).to receive(method).with(opts[:argument] || anything) do
    index += 1
    opts[:values][index - 1]
  end
end