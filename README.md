Zappify-Objective_C
===================

A sample application implementing the Zappos API

About
============

Zappify is a sample app that I wrote as a challenge for Zappos.  It makes use of their Search, AutoComplete, and CoreValue APIs.  You are able to search for items from Zappos.com and have the displayed along with important information about it.  You can then enter you email address to be notified when the item discounted to your desired price (default is 20% off).  It will check every hour for updated pricing.

[SendGrid](http://www.sendgrid.com) is used to send the email notifications.


###Note
To actually use the project:
 
 	* Put your Zappos API Key in the constant defined in ZapposBrain.h.
	* Put Your SendGrid username and password in the constants defined in ZapposBrain.h


Images
============

####AutoComplete View:
![Standard View](https://raw.github.com/ianb821/Zappify-Objective_C/master/Images/AutoComplete.png)

####Search Results View:
![Standard View](https://raw.github.com/ianb821/Zappify-Objective_C/master/Images/NikeGolf.png)

####Starred Item View:
![Standard View](https://raw.github.com/ianb821/Zappify-Objective_C/master/Images/StarredItem.png)

####Favorite Items View:
![Standard View](https://raw.github.com/ianb821/Zappify-Objective_C/master/Images/FavoriteItems.png)

####Stop Monitoring Item View:
![Standard View](https://raw.github.com/ianb821/Zappify-Objective_C/master/Images/ItemView.png)
