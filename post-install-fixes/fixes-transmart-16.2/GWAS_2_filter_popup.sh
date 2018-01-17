# Issue: Filter pop-up does not appear when clicking on a filter type in the GWAS tab
# Cause: Error in the console
# Solution: Update JavaScript file that creates the pop-up

cd /var/lib/tomcat7/webapps/transmart/js/facetedSearch/
sudo nano facetedSearchBrowse.js

# Changed the destroy line to verify if the dialog exists, because otherwise it crashes:
# from
# jQuery('#divBrowsePopups').dialog("destroy");
# to
# if($("divBrowsePopups").hasClass('ui-dialog-content')) {jQuery('#divBrowsePopups').dialog("destroy");}

# Might need to restart tomcat and refresh your browser cache
# The pop-up will now appear in the browser
