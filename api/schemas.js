// or ESM/TypeScript import

// Node.js require:

const loginSchema = {
    type:"object",
    properties: {
        username: {type: "string"},
        password: {type: "string"}
    },
    required: ["username", "password"],
    additionalProperties: false,
};

const addItemSchema = {
    type:"object",
    properties: {
        name: {type: "string"},
        quantity: {type: "number"},
        type: {type: "number"}
    },
    required: ["name", "quantity", "type"],
    additionalProperties: false,
};

const updateItemSchema = {
    type:"object",
    properties: {
        name: {type: "string"},
        new_name: {type: "string"},
        new_quantity: {type: "number"}
    },
    required: ["name", "new_item", "new_quantity"],
    additionalProperties: false,
};

const removeItemSchema = {
    type:"object",
    properties: {
        name: {type: "string"},
    },
    required: ["name"],
    additionalProperties: false,
};

module.exports.loginSchema = loginSchema
module.exports.addItemSchema = addItemSchema
module.exports.updateItemSchema = updateItemSchema
module.exports.removeItemSchema = removeItemSchema