"use strict"
module.exports = (sequelize, DataTypes) ->
  Dictionary = sequelize.define("Dictionary",
    word: DataTypes.STRING
    hash: DataTypes.STRING
    popularity: DataTypes.INTEGER
  ,
    classMethods:
      associate: (models) ->
  )

  Dictionary