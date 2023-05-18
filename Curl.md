Получить информацию о ВМ указав ее uuid:

`curl -X GET --header 'Accept: application/json' --header "Authorization: $token" 'https://portal-address/api/v1/servers/uuid' | jq`
