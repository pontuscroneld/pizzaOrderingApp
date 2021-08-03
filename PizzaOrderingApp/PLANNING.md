#  PIZZA APP

The code challenge is a “Pizza Ordering App” 
What I need,

# List View
• Show a list of pizza restaurants and have the closest to your current location at the top 

**On ViewDidLoad:**

Call ApiHandler.findRestaurants( )
Save as local array

Find user location, CoreLocation
Save as local variable

Sort Restaurants by distance to user location
Save in diffable database?

**Call presentSubviews:**

Present in tableView or CollectionView

A button on the right side to segue to detailView

Segue with currentRestaurantID as parameter


# Detail View
• From the list enter into a detail view for that restaurant and display the available menu for that location.        
• Let the users add items from the menu into a shopping cart     

**On ViewDidLoad:**

Call ApiHandler.getMenu( currentRestaurantID ) 
Sort MenuItems by ID

**Call presentSubviews:**

Present in tableView or CollectionView
A button on the right side plus
A button next to it minus (active when Amount > 0)
A button at the bottom moving forward to order view

# Order View
• Place the order         
• Display the orders state 

**On ViewDidLoad:**

  ?

**Call presentSubviews:**

Present summary of order in simple view using CartModel
A button below saying "Place Order"

**On button pressed** 

Call ApiHandler.placeOrder( ) Need to do some research here how a post works. Should probably pass along the CartModel
Save the response order ID. Save it in UserDefault to make loading possible on launch in case it exists?

Call ApiHandler.readOrder( orderID ) 
Present order state in a simple readable view 

BONUS POINTS: 

This order state should be possible to update and accessible from launch screen. 

# Api Handler

You can find the API’s here:  
https://pizzaapp.docs.apiary.io/

FIND RESTAURANTS: 
https://private-anon-94d7d533ab-pizzaapp.apiary-mock.com/restaurants/

GET MENU FROM RESTAURANT: 
Needed parameter: restaurantId: Int
https://private-anon-94d7d533ab-pizzaapp.apiary-mock.com/restaurants/restaurantId/menu?category=Pizza&orderBy=rank

PLACE ORDER:
Note: Post not get function
https://private-anon-94d7d533ab-pizzaapp.apiary-mock.com/orders/

Gets a respone: 
{
  "orderId": 1234412,
  "totalPrice": 168,
  "orderedAt": "2015-04-09T17:30:47.556Z",
  "esitmatedDelivery": "2015-04-09T17:45:47.556Z",
  "status": "ordered"
}

READ ORDER:
Needed parameter: id: Int
https://private-anon-94d7d533ab-pizzaapp.apiary-mock.com/orders/id

# Models

RESTAURANTMODEL:

"id": Int,
 "name": String,
 "address1": String,
 "address2": String,
 "latitude": 59.336078,
 "longitude": 18.071807
 
 MENUMODEL:
 
 [ MenuItem ] 
 
 MENUITEM:
 
 {
     "id": Int,
     "category": String,
     "name": String,
     "topping": [ String ],
     "price": Int,
     "rank": Int
   }

CARTMODEL:

"cart": [ CARTITEM ],
 "restaurantId": Int
 
 CARTITEM:
 "menuItemId": Int,
 "quantity": Int
 
 ORDERRESPONSE:
 
 "orderId": Int,
 "totalPrice": Int,
 "orderedAt": "2015-04-09T17:30:47.556Z",
 "esitmatedDelivery": "2015-04-09T17:45:47.556Z",
 "status": String
 
 ORDERDETAILS:
 
   "orderId": 1234412,
   "totalPrice": 168,
   "orderedAt": "2015-04-09T17:30:47.556Z",
   "esitmatedDelivery": "2015-04-09T17:50:47.556Z",
   "status": String,
   "cart": CartModel

  


