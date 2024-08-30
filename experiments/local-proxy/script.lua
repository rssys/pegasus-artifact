math.randomseed(0)
math.random(); math.random(); math.random()

request = function()
    if math.random() < 10/100 then
        return wrk.format("GET", "http://10.10.1.1:31298/test_file")
    else
        return wrk.format("GET", "http://10.10.1.1:31298/test_file2")
    end
end
