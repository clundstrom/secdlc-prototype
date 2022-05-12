
## **API Endpoints**
### **POST /login**
**JSON body**
```json
{
    username: String,
    password: String
}
```
**Response**
If a successful login is performed, a cookie 'webToken' is set on the client, and a HTTP 200 response is given.

### **GET /getInventory**
**Request**
Valid JWT for use within the Authorization bearer header

**Response JSON**
```json
{
    result: [{item_1: String, type: Number..., 
            item_n: String, type: Number}]
}
```
### **POST /logout**
**Request**
Valid JWT for use within the Authorization bearer header

**Response**
Current idea is to just respond with HTTP 200, and remove the token from an active tokens list whereby future requests will fail since the token is not "active"

### **POST /addItem**
**JSON body**
```json
{
    name: String,
    quantity: Number,
    type: Number,
    description: String
}
```
**Response**
HTTP response 201 + text body

### **POST /removeItem**
**JSON body**
```json
{
    name: String
}
```
HTTP response 200 + text body

### **POST /updateItem**
**JSON body**
```json
{
    name: String ,
    new_name: String,
    new_quantity: Number,
    new_Description: String
}
```
If arguments are left empty this will reflect in the Database, so it is best if the client verifies the original values of items, and replaces empty values with those. This will prevent items from losing properties. In the futures this might be remedied on the API side.

### Inventory Types
| Item type | Access level |
| --------- | ------------ |
| Fruit     | 1            |
| Meat      | 2            |
| Cleaning  | 3            |
| Snacks    | 4            |
| Office    | 5            |

### Logins
| User     | Password |
| -------- | -------- |
| root     | root     |
| fruit    | fruit    |
| meat     | meat     |
| food     | food     |
| supplies | supplies |