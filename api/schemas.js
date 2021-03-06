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
        type: {type: "number"},
        description: {type: "string"}
    },
    required: ["name", "quantity", "type", "description"],
    additionalProperties: false,
};

const updateItemSchema = {
    type:"object",
    properties: {
        name: {type: "string"},
        new_name: {type: "string"},
        new_quantity: {type: "number"},
        new_description: {type: "string"}
    },
    required: ["name", "new_name", "new_quantity", "new_description"],
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