# Issue: filters selected in the popup in the GWAS module are not applied and result in an error
# Cause: the Console reports that the addSearchTerm is not defined
# The general issue appears to be the naming of the functions

cd /var/lib/tomcat7/webapps/transmart/js/facetedSearch
nano facetedSearchBrowse.js
# Change the call in the function applyPopupFiltersAnalyses() from addSearchTerm to gwasAddSearchTerm
# Change the call in the function applyPopupFiltersDataTypes() from addSearchTerm to gwasAddSearchTerm

cd /var/lib/tomcat7/webapps/transmart/plugins/transmart-gwas-16.2/js
nano gwas.js
# Change the call in the function gwasShowSearchTemplate from isDataCategory to gwasIsDataCategory
# Update the code in the function gwasApplyPopupFiltersRegions to use encodeURIComponent around the searchString in the searchParam dict
