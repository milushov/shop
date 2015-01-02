"use strict"
module.exports = (sequelize, DataTypes) ->
  Merchant = sequelize.define("Merchant",
    name: DataTypes.STRING
  ,
    classMethods:
      associate: (models) ->
        # wtf!? why i should specify foreignkey!?
        models.Merchant.hasMany(models.Product, foreignKey: 'merchantId')
  )

  Merchant