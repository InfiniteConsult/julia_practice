function sum_all(label::String, numbers...)
    total = 0
    for n in numbers
        total += n
    end
    println(label, "; ", total)
end

println("--- Calling with individual arguments ---")
sum_all("Individual args", 1, 2, 3, 4)

println("\n--- Calling with splatting ---")
my_numbers = [10, 20, 30]
sum_all("Splatting", my_numbers...)

my_tuple = (100, 200)
sum_all("Splatting tuple", my_tuple...)
