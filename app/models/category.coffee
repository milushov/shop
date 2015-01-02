"use strict"
module.exports = (sequelize, DataTypes) ->
  Category = sequelize.define("Category",
    name: DataTypes.STRING
  ,
    classMethods:
      associate: (models) ->
  )
  
  # associations can be defined here
  Category.belongsToMany(Product, through: 'CategoriesProducts')