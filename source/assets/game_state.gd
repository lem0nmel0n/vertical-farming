extends Node
'''
the GameState autoload. this preserves game data that would otherwise be 
expunged during transitions betwixt the warehouse and the main scene
'''
#consigns the customer index, whether this is the player's inaugural opening of the game, and whether they are new or not.
var customer_index = 0
var first_play = true
var new_customer = true

#initialises the player's inventory with states of emptiness across all botanical reserves
var inventory = {"tomatoes":0, "berries":0, "lettuce":0}

#used for constant surveillance of the harvesting status across all produce categories
var t_collected = false
var l_collected = false
var b_collected = true

#used for constant surveillance of the growth status across all produce categories
var t_grown = true
var l_grown = true
var b_grown = false

#assigns a bountiful amount of capital to the preset money variable
var money = 400

var added_money = 0 #the amount of payment appended to the aggregated sum of money during transactions is consigned unto this variable
var first_buy = true #remains as the boolean value true until the player's initial purchase of tomato starts

#a dictionary encompassing data regarding various customers ordered by index. 
#index 0 of the value is their spoken remark upon interaction with the player, index 1 entails the number of tomatoes they wish to purchase, 
#index 2 - lettuce, index 3 indicates the totality of berries they request, and index 4 entails the sum of their payment.
var customers = {
0: ["could i get 10 tomatoes and 2 heads of lettuce?", 10, 2, 0, 6],
1: ["20 strawberries and 5 tomatoes please!", 5, 0, 20, 4],
2: ["i'd like lots and lots of lettuce. about 10 heads.", 0, 10, 0, 20],
3: ["5 tomatoes. apples are gross.", 5, 0, 0, 1],
4: ["20 tomatoes, dear. and 10 strawberries for the grandkids.", 20, 0, 10, 5.5],
5: ["1 head of lettuce and 10 strawberries please.", 0, 1, 10, 3.5],
6: ["11 berries, 11 tomatoes, and 11 heads of lettuce. keep the change.", 11, 11, 11, 29],
7: ["i'm completely out of tomatoes and lettuce! 30 of each please.", 30, 30, 0, 66]
}
var bought = [] #stores the titles of procured items within a convenient list.
