# Issue: The 'Open in Analyze View' functionality from the Browse tab does not filter on the study in the Analyze tab
# Cause: A search is performed on the selected study, however one of the parameters of the search is not encoded correctly. 
# Solution: Update the JavaScript code that creates the query params in order to encode correctly

cd /var/lib/tomcat7/webapps/transmart/js
sudo nano rwgsearch.js

# Update the following:
# Change the following line from the showFacetResults function:
# queryString += "&searchTerms=" + encodeURIComponent(savedSearchTerms) + "&searchOperators=" + operatorString + "&globaloperator=" + globalLogicOperator;
# to:
# queryString += "&searchTerms=" + encodeURIComponent(savedSearchTerms) + "&searchOperators=" + encodeURIComponent(operatorString) + "&globaloperator=" + globalLogicOperator;
# Save changes

# Might need to restart tomcat and refresh your browser cache
