"use strict"
module.exports =
  up: (migration, DataTypes, done) ->
    migration.createTable("CategoriesProducts",
      id:
        allowNull: false
        autoIncrement: true
        primaryKey: true
        type: DataTypes.INTEGER

      category_id:
        type: DataTypes.INTEGER

      product_id:
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
    migration.dropTable("CategoriesProducts").done done
    return