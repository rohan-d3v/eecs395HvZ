
To get this running, pull down the source code and then run:

bundle install
rake db:schema:load

>> To set up SMS integration with Twilio, set the following environment variables:
  TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_PHONE_NUMBER

# eecs395-Hvz: Information

Website: http://ec2-35-163-170-184.us-west-2.compute.amazonaws.com

<b>This code was initially pulled from cwru-hvz-source:</b> https://github.com/cwru-hvz-core/cwru-hvz-source.git
The code has been found to be extremely defective and is currently being modified
The deployment instructions are outdated, incomplete and not useful and is in the process of being/has been updated
The rails app itself was extremely outdated and was using a not recommended version with nginx and unicorn. 
It has been switched over to the latest version at this point

If the gems aren't the latest in my code update, they are the latest possible that are still compatible with the code and will be adjusted as the code is re-written

<b>Bugs are detailed under issues and currently found code defects/ bugs are listed here:</b>

Bugs discovered week ending Nov 3:

Parameter and Create issue: waiver_controller.rb (CLOSED/FIXED) </br>
Parameter and Create Issue: games_controller.rb (CLOSED/FIXED) </br>
Signature_check method Always returns false: waiver_controller.rb (CLOSED/FIXED)</br>
Student ID always considered blank: waiver_controller.rb (CLOSED/FIXED)</br>
Defective code and multiple errors: waiver.rb (CLOSED/FIXED)</br>
Parameter and Create Issue: missions_controller.rb (CLOSED/FIXED)</br>
</br>

Bugs discovered and/or fixed week ending Nov 10:

Game Tools Issue: Null game upon cloning source (CLOSED/FIXED)</br>
Mission attendance breaks the website: missions_controller.rb (CLOSED/FIXED)</br>
Parameter, Create and Update Issue: people_controller.rb (CLOSED/FIXED)</br>
NoMethodError in TagsController#new (CLOSED/FIXED) </br>
Game doesn't update automatically: Delayed jobs/ worker not running (CLOSED/FIXED)</br>
NoMethodError in Missions#attendance (CLOSED/FIXED)</br>
</br>

NoMethodError in TagsController#create (OPEN) </br>
Missions don't give you the option to enter names for attendance: Missions_controller.rb (OPEN)</br>
