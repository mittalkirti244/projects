sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'requesttypeui/test/integration/FirstJourney',
		'requesttypeui/test/integration/pages/RequestTypeConfigList',
		'requesttypeui/test/integration/pages/RequestTypeConfigObjectPage'
    ],
    function(JourneyRunner, opaJourney, RequestTypeConfigList, RequestTypeConfigObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('requesttypeui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheRequestTypeConfigList: RequestTypeConfigList,
					onTheRequestTypeConfigObjectPage: RequestTypeConfigObjectPage
                }
            },
            opaJourney.run
        );
    }
);