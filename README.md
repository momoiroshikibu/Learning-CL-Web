# Learning Roswell

## commands

```
$ ros crud.ros select-one 1
"ID: 1
FirstName: Taro
LastName: Yamada
CreatedAt: 3683404800
"
```

## API

authenticate

```
$ curl localhost:5000/access-tokens -XPOST -H "Content-Type: application/json" -d '{"mail-address": "test@example.com", "password": "password"}' -v
```

locations

```
$ curl -XGET localhost:5000/locations -H 'access-token: 3689823934'
```
