// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract RealEstate {

    // basic details of property
    struct Property{
        address owner;
        uint256 price;
        bool forSale;
        string name;
        string location;
        string description;
    }

    //map for storing Property for unique propertyId
    mapping(uint256 => Property) public properties;

    // aaray for propertyIds
    uint256[] public propertyIds;

    event PropertySold(uint256 propertyId);

    //function to list property
    function listProperty(uint256 _propertyId,uint256 _price,string memory _name,string memory _location,string memory _description)  public {
       
       //can list only unique id properties
        for(uint256 i=0;i<propertyIds.length;++i){
            if(propertyIds[i]==_propertyId){
                revert("Already listed!");
            }
        }

        Property memory newProperty = Property({
            owner:msg.sender,
            price:_price,
            forSale:true,
            name:_name,
            location:_location,
            description:_description
        });

        properties[_propertyId] = newProperty;
        propertyIds.push(_propertyId);
    }


    //function to buy one of the properties by property id
    function buyProperty(uint256 _propertyId) public payable {
        Property storage property = properties[_propertyId];

        //some conditions to be satisfied
        require(property.forSale,"Not for sale!");
        require(msg.value >= property.price,"Insuficient funds!");

        //eths sent to the owner
        (bool sent,) = property.owner.call{value:msg.value}("");
        require(sent,"Failed to send!");

        //new owner of the property
        property.owner = msg.sender;
        property.forSale = false;

        emit PropertySold(_propertyId);
    }

}