<table class="detail" style="width: 515px;">
    <tbody>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Title:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'shortDescription')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Analysis Description:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'longDescription')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Research Unit:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.researchUnit')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Data type:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'assayDataType')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Trait:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.trait')}</td>
    </tr> 
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Population:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.population')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Sample Size:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.sampleSize')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Number of controls:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.numCtrls')}</td>
    </tr>  
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Number of cases:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.numCases')}</td>
    </tr> 
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Tissue:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.tissue')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Cell type:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.cellType')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Method:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.modelName')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Method description:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.modelDescription')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">p-Value Cut Off:</td> 
        <td valign="top" class="value">${analysis.pValueCutoff} </td> 
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Analysis Platform:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.analysisPlatform')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Genome Version:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.genomeVersion')}</td>
    </tr>  
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">SNP ID database:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.snpDatabaseId')}</td>
    </tr>  
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Record Count:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'dataCount')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Path to source:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.pathSource')}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name" style="text-align: right">Dataset release date:</td>
        <td valign="top" class="value">${fieldValue(bean: analysis, field: 'ext.datasetReleaseDate')}</td>
    </tr>
    </tbody>
</table>
