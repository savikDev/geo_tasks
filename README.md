# GeoTasks

Umbrella application which works with geo-based tasks

**Description**

TheApplication works with PostgreSQL and Elixir(>1.7).

You can run next endpoints:

- for create geo tasks:
```
method: POST
URL: localhost:4000/api/task
Header: authorization_token: manager_token
Body: 
    { "name": "1",
      "title": "1",
      "delivery_location": {"lng": 40, "lat": 90},
      "pickup_location": {"lng": 40, "lat": 90} }
```


- for select open tasks:
```
method: POST
URL: localhost:4000/api/task/select
Header: authorization_token: driver_token
Body: {"lng": -87.9079503, "lat": 43.0384303, "distance": 40000}
```

- for assigned tasks:
```
method: POST
URL: localhost:4000/api/task/assign
Header: authorization_token: driver_token
Body: {"id": "9927b5b7-bab1-4cb1-8953-f35f13eb10bb"}
```

- for done tasks:
```
method: POST
URL: localhost:4000/api/task/done
Header: authorization_token: driver_token
Body: {"lng": -87.9079503, "lat": 43.0384303, "distance": 40000}
```

Also, all token should be ``active``

**How to start**

First of all you should get dependencies, for this run 
`mix deps.get`

Than prepare your DB, sample way for this run
`mix db_setup` 

Also you can reset your DB, for this run `mix db_reset`

For start application `mix phx.server`