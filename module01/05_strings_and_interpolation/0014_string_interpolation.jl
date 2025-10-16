name = "Julia"
year = 2012
version = 1.19

intro = "My name is $name. I was released in $year"
println(intro)

println("-"^20)
current_year = 2025
age_calculation = "It is now $current_year, so I am $(current_year - year) years old."

version_info = "My current version is $(version), and uppercase it is $(uppercase(string(version)))"
println(version_info)
