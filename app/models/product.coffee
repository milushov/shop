"use strict"
module.exports = (sequelize, DataTypes) ->
  Product = sequelize.define("Product",
    image: DataTypes.STRING
    name: DataTypes.STRING
    price: DataTypes.FLOAT
    merchantId: DataTypes.INTEGER
  ,
    classMethods:
      associate: (models) ->
        models.Product.belongsToMany(models.Category, through: 'CategoriesProducts')
        models.Product.belongsTo(models.Merchant, foreignKey: 'merchantId')
  )

  Product