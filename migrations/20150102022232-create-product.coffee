"use strict"
module.exports =
  up: (migration, DataTypes, done) ->
    migration.createTable("Products",
      id:
        allowNull: false
        autoIncrement: true
        primaryKey: true
        type: DataTypes.INTEGER

      image:
        type: DataTypes.STRING

      name:
        type: DataTypes.STRING

      price:
        type: DataTypes.FLOAT

      merchantId:
        type: DataTypes.INTEGER

      createdAt:
        allowNull: false
        type: DataTypes.DATE

      updatedAt:
        allowNull: false
        type: DataTypes.DATE
    ).done done
    return

  down: (migration, DataTypes, done) ->
    migration.dropTable("Products").done done
    return