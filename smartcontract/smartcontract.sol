// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract SupplyChain {
    
    event Added(uint256 index);
    
    struct State {
        string description;
        address person;
    }
    
    struct Product {
        address creator;
        string productName;
        uint256 productId;
        string date;
        uint256 totalStates;
        mapping (uint256 => State) positions;
    }
    
    mapping(uint => Product) allProducts;
    uint256 items = 0;
    
    function concat(string memory _a, string memory _b) public pure returns (string memory) {
        bytes memory bytes_a = bytes(_a);
        bytes memory bytes_b = bytes(_b);
        string memory length_ab = new string(bytes_a.length + bytes_b.length);
        bytes memory bytes_c = bytes(length_ab);
        uint k = 0;
        for (uint i = 0; i < bytes_a.length; i++) bytes_c[k++] = bytes_a[i];
        for (uint i = 0; i < bytes_b.length; i++) bytes_c[k++] = bytes_b[i];
        return string(bytes_c);
    }
    
    function newItem(string memory _text, string memory _date) public returns (bool) {
        Product storage product = allProducts[items];
        product.creator = msg.sender;
        product.productName = _text;
        product.productId = items;
        product.date = _date;
        product.totalStates = 0;
        items = items + 1;
        emit Added(items - 1);
        return true;
    }
    
    function addState(uint _productId, string memory info) public returns (string memory) {
        require(_productId < items, "Product ID does not exist.");
        
        State memory newState = State({person: msg.sender, description: info});
        
        Product storage product = allProducts[_productId];
        product.positions[product.totalStates] = newState;
        product.totalStates += 1;
        
        return info;
    }
    
    function searchProduct(uint _productId) public view returns (string memory) {
        require(_productId < items, "Product ID does not exist.");
        
        string memory output = "Product Name: ";
        output = concat(output, allProducts[_productId].productName);
        output = concat(output, "<br>Manufacture Date: ");
        output = concat(output, allProducts[_productId].date);
        
        for (uint256 j = 0; j < allProducts[_productId].totalStates; j++) {
            output = concat(output, allProducts[_productId].positions[j].description);
        }
        
        return output;
    }
}
