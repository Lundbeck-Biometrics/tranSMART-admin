# Issue: filters selected in the popup in the GWAS module are not applied and result in an error
# Cause: the Console reports that the addSearchTerm is not defined for the Data type and Analyses filter,
# and the issue appears to be the naming of the functions
# For the Region of Interest filter, the reported error is a bad request because the query is not encoded
# properly. 
# For the Study filter, the error is 404 not found, since it makes a request for browseGWASExperimentsMultiSelect
# and it can't find it.

cd /var/lib/tomcat7/webapps/transmart/js/facetedSearch
nano facetedSearchBrowse.js
# Change the call in the function applyPopupFiltersAnalyses() from addSearchTerm to gwasAddSearchTerm
# Change the call in the function applyPopupFiltersDataTypes() from addSearchTerm to gwasAddSearchTerm

cd /var/lib/tomcat7/webapps/transmart/plugins/transmart-gwas-16.2/js
nano gwas.js
# Change the call in the function gwasShowSearchTemplate from isDataCategory to gwasIsDataCategory
# Update the code in the function gwasApplyPopupFiltersRegions to use encodeURIComponent around the searchString in the searchParam dict
