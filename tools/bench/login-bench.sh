wrk -c30 -d3s -t1 --timeout 10000 -s ./tools/bench/login.lua http://localhost:5000/authenticate
