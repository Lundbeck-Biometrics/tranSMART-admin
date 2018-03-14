<div style="text-align: center;">
    <div class="welcome"
         style="margin: 40px auto; background: #F4F4F4; border: 1px solid #DDD; padding: 20px; width: 400px; text-align: center; border-top-left-radius: 20px; border-bottom-right-radius: 20px">
        <g:set var="projectName" value="${grailsApplication.config?.com?.recomdata?.projectName}"/>
        <g:set var="providerName" value="${grailsApplication.config?.com?.recomdata?.providerName}"/>

        <g:if test="${projectName}">
            <asset:image src="lutransmartlogo.png" alt="${projectName}"
                    style="height:70px;vertical-align:middle;margin-bottom: 12px;"/>
        </g:if>

        <p><b>Welcome to tranSMART</b></p>

        <br/>

        <p>tranSMART is Lundbeck's platform for sharing Bioinformatics data across R&D.</p>

        <br/>
        
        <p>The <b>GWAS</b> tab allows you to browse and export GWAS and eQTL datasets made available through tranSMART.
        </p>
        <br/>
        <p><i>Note: You are currently accessing our sandbox environment, which is work in progress. This means that the tranSMART service might be down from time to time while we are enabling new features!</i></p>

        <br/>
        <p><b>Coming soon:</b></p>
        <br/>
        <p>The <b>Browse</b> tab will let you search and dive into the information contained in tranSMART,
        including Programs, Studies, Assays and the associated Analyses Results, Subject Level Data and Raw Files.
        This is also the location to export files stored in tranSMART.
        </p>
        <br/>
        <p>The <b>Analyze</b> tab will let you perform a number of analyses either on studies selected
        in the Browse window, or from the global search box located in the top ribbon of your screen.
        </p>
        <br/>
        <p>The <b>Gene Signature/List</b> tab will let you define and share a list of genes that you can reuse in your analyses. 
        </p>
        <br><br>
    </div>

     <div>
        <g:if test="${providerName}">
            <span style="font-size:20px;display: inline-block;line-height: 35px; height: 35px;">&nbsp;powered by &nbsp;</span>
        </g:if>
        <g:if test="${providerName}">
            <asset:image src="provider_logo.png" alt="${providerName}"
                        style="height:150px;vertical-align:middle;margin-bottom: 12px;"/>
        </g:if>
    </div>

    <sec:ifAnyGranted roles="ROLE_ADMIN">
        <div style="margin: auto; padding: 0px 16px 16px 16px; border-radius: 8px; border: 1px solid #DDD; width: 20%">
            <h4>Admin Tools</h4>
            <span class="greybutton buttonicon addprogram">Add new program</span>
        </div>
    </sec:ifAnyGranted>

    <br/><br/>
</div>