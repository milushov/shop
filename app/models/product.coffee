"use strict"
module.exports = (sequelize, DataTypes) ->
  Product = sequelize.define("Product",
    image: DataTypes.STRING
    name: DataTypes.STRING
    price: DataTypes.FLOAT
    merchant_id: DataTypes.INTEGER
  ,
    classMethods:
      associate: (models) ->
  )
  
  # associations can be defined here
  Product.belongsToMany(Category, through: 'CategoriesProducts')