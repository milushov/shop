"use strict"
module.exports = (sequelize, DataTypes) ->
  Merchant = sequelize.define("Merchant",
    name: DataTypes.STRING
  ,
    classMethods:
      associate: (models) ->
  )
  
  # associations can be defined here
  Merchant