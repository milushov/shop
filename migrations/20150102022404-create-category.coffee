"use strict"
module.exports =
  up: (migration, DataTypes, done) ->
    migration.createTable("Categories",
      id:
        allowNull: false
        autoIncrement: true
        primaryKey: true
        type: DataTypes.INTEGER

      name:
        type: DataTypes.STRING

      createdAt:
        allowNull: false
        type: DataTypes.DATE

      updatedAt:
        allowNull: false
        type: DataTypes.DATE
    ).done done
    return

  down: (migration, DataTypes, done) ->
    migration.dropTable("Categories").done done
    return