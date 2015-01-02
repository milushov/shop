"use strict"
module.exports = (sequelize, DataTypes) ->
  Category = sequelize.define("Category",
    name: DataTypes.STRING
  ,
    classMethods:
      associate: (models) ->
        models.Category.belongsToMany(models.Product, through: 'CategoriesProducts')
  )

  Category