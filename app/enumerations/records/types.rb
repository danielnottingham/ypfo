module Records
  class Types < EnumerateIt::Base
    associate_values(
      expense: -1,
      income: 1
    )
  end
end
