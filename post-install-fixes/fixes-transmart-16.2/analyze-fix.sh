# Issue: Getting bad request error in console when expanding notes in Dataset Explorer
# Solution: Update datasetExplorer.js to encode the request

cd /var/lib/tomcat7/webapps/transmart/js/datasetExplorer
sudo nano datasetExplorer.js

# Update in function setupOntTree:
# from 
# url: addNodeDseURL + "?node=" + node.id
# to
# url: addNodeDseURL + "?node=" + encodeURIComponent(node.id)

# Save and restart tomcat and refresh browser cache
