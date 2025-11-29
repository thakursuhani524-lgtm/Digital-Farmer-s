// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DigitalFarmersCoopMarketplace {
    
    struct Product {
        uint id;
        address farmer;
        string name;
        uint price;     // price in wei
        bool available;
    }

    uint public productCount;
    mapping(uint => Product) public products;

    event ProductAdded(uint indexed id, address indexed farmer, string name, uint price);
    event ProductPurchased(uint indexed id, address indexed buyer);

    // Add a new product to the marketplace
    function addProduct(string memory _name, uint _price) public {
        require(_price > 0, "Price must be greater than zero");
        productCount++;

        products[productCount] = Product({
            id: productCount,
            farmer: msg.sender,
            name: _name,
            price: _price,
            available: true
        });

        emit ProductAdded(productCount, msg.sender, _name, _price);
    }

    // Purchase a product
    function purchaseProduct(uint _id) public payable {
        Product storage p = products[_id];
        require(p.available, "Product not available");
        require(msg.value == p.price, "Incorrect price amount");

        p.available = false;

        payable(p.farmer).transfer(msg.value);

        emit ProductPurchased(_id, msg.sender);
    }

    // Get details of a product
    function getProduct(uint _id) public view returns(Product memory) {
        return products[_id];
    }
}
