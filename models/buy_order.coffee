MarketHelper = require "../lib/market_helper"
math = require("mathjs")
  number: "bignumber"
  decimals: 8

module.exports = (sequelize, DataTypes) ->

  BuyOrder = sequelize.define "BuyOrder",
      external_order_id:
        type: DataTypes.INTEGER.UNSIGNED
        allowNull: false
        unique: true
      type:
        type: DataTypes.INTEGER.UNSIGNED
        allowNull: false
        comment: "market, limit"
        get: ()->
          MarketHelper.getOrderTypeLiteral @getDataValue("type")
        set: (type)->
          @setDataValue "type", MarketHelper.getOrderType(type)
      buy_currency:
        type: DataTypes.INTEGER.UNSIGNED
        allowNull: false
        get: ()->
          MarketHelper.getCurrencyLiteral @getDataValue("buy_currency")
        set: (buyCurrency)->
          @setDataValue "buy_currency", MarketHelper.getCurrency(buyCurrency)
      sell_currency:
        type: DataTypes.INTEGER.UNSIGNED
        allowNull: false
        get: ()->
          MarketHelper.getCurrencyLiteral @getDataValue("sell_currency")
        set: (sellCurrency)->
          @setDataValue "sell_currency", MarketHelper.getCurrency(sellCurrency)
      amount:
        type: DataTypes.BIGINT.UNSIGNED
        defaultValue: 0
        allowNull: false
        validate:
          isInt: true
          notNull: true
      matched_amount:
        type: DataTypes.BIGINT.UNSIGNED
        defaultValue: 0
        validate:
          isInt: true
      result_amount:
        type: DataTypes.BIGINT.UNSIGNED
        defaultValue: 0
        validate:
          isInt: true
      fee:
        type: DataTypes.BIGINT.UNSIGNED
        defaultValue: 0
        validate:
          isInt: true
      unit_price:
        type: DataTypes.BIGINT.UNSIGNED
        defaultValue: 0
        validate:
          isInt: true
      status:
        type: DataTypes.INTEGER.UNSIGNED
        allowNull: false
        defaultValue: MarketHelper.getOrderStatus "open"
        comment: "open, partiallyCompleted, completed"
        get: ()->
          MarketHelper.getOrderStatusLiteral @getDataValue("status")
        set: (status)->
          @setDataValue "status", MarketHelper.getOrderStatus(status)
    ,
      tableName: "buy_orders"
      getterMethods:

        left_amount: ()->
          math.add @amount, -@matched_amount

        action: ()->
          "buy"

      classMethods:
        
        findById: (id, callback)->
          BuyOrder.find(id).complete callback

        findByOrderId: (orderId, callback)->
          BuyOrder.find({where: {external_order_id: orderId}}).complete callback

  BuyOrder
