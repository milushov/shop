"use strict"
module.exports =
  up: (migration, DataTypes, done) ->
    migration.createTable("Dictionaries",
      id:
        allowNull: false
        autoIncrement: true
        primaryKey: true
        type: DataTypes.INTEGER

      word:
        type: DataTypes.STRING

      hash:
        type: DataTypes.STRING

      popularity:
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
    migration.dropTable("Dictionaries").done done
    return